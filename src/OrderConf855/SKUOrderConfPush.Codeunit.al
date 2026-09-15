codeunit 72011 "SKU Order Conf Push"
{
    // Pushes 855 Order Confirmation data to Boomi webhook endpoint using Basic Auth or OAuth 2.0
    Permissions = tabledata "SKU Order Conf Buffer" = RM,
                  tabledata "SKU Order Conf Line Buffer" = R,
                  tabledata "SKUIntegrationSetup" = RIMD;

    var
        Setup: Record "SKUIntegrationSetup";
        SetupLoaded: Boolean;
        AccessToken: Text;
        TokenExpiry: DateTime;
        BoomiUrlMissingErr: Label 'Boomi 855 Endpoint URL is not configured in SKU Integration Setup.';
        BasicAuthConfigMissingErr: Label 'Boomi Basic Auth configuration is incomplete. Please configure Username and Password.';
        OAuthConfigMissingErr: Label 'Boomi OAuth configuration is incomplete. Please configure Token URL, Client ID, and Client Secret.';
        TokenRequestFailedErr: Label 'Failed to obtain OAuth access token: %1';

    procedure PushOrderConfirmation(var OrderConfBuffer: Record "SKU Order Conf Buffer"): Boolean
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        JsonText: Text;
        ResponseText: Text;
        AuthHeader: Text;
    begin
        LoadSetup();
        if Setup."Boomi 855 Endpoint URL" = '' then
            Error(BoomiUrlMissingErr);

        JsonText := BuildOrderConfirmationJson(OrderConfBuffer);

        Content.WriteFrom(JsonText);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        // Add Authorization header based on Auth Type
        AuthHeader := GetAuthorizationHeader();
        Client.DefaultRequestHeaders().Add('Authorization', AuthHeader);

        if Client.Post(Setup."Boomi 855 Endpoint URL", Content, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                OrderConfBuffer."Sent to SAP" := true;
                OrderConfBuffer."Sent DateTime" := CurrentDateTime;
                OrderConfBuffer."Error Message" := '';
                OrderConfBuffer.Modify(true);
                exit(true);
            end else begin
                Response.Content.ReadAs(ResponseText);
                OrderConfBuffer."Sent to SAP" := false;
                OrderConfBuffer."Error Message" := CopyStr('HTTP ' + Format(Response.HttpStatusCode) + ': ' + ResponseText, 1, 250);
                OrderConfBuffer.Modify(true);
                exit(false);
            end;
        end else begin
            OrderConfBuffer."Sent to SAP" := false;
            OrderConfBuffer."Error Message" := CopyStr('Connection failed', 1, 250);
            OrderConfBuffer.Modify(true);
            exit(false);
        end;
    end;

    local procedure BuildOrderConfirmationJson(OrderConfBuffer: Record "SKU Order Conf Buffer"): Text
    var
        OrderConfLineBuffer: Record "SKU Order Conf Line Buffer";
        JsonObj: JsonObject;
        LinesArray: JsonArray;
        LineObj: JsonObject;
        ScheduleLineObj: JsonObject;
    begin
        // Build header
        JsonObj.Add('sapPurchaseOrderNo', OrderConfBuffer."SAP Purchase Order No.");
        JsonObj.Add('sapSalesOrderNo', OrderConfBuffer."SAP Sales Order No.");
        JsonObj.Add('creationDateTime', FormatDateTime(OrderConfBuffer."Creation DateTime"));
        JsonObj.Add('senderInternalId', OrderConfBuffer."Sender Internal ID");
        JsonObj.Add('recipientInternalId', OrderConfBuffer."Recipient Internal ID");

        // Build lines
        OrderConfLineBuffer.SetRange("Document Id", OrderConfBuffer.Id);
        if OrderConfLineBuffer.FindSet() then
            repeat
                Clear(LineObj);
                LineObj.Add('purchaseOrderItemId', OrderConfLineBuffer."Purchase Order Item ID");
                LineObj.Add('sapProductId', OrderConfLineBuffer."SAP Product ID");
                LineObj.Add('requestedQuantity', OrderConfLineBuffer.Quantity);
                LineObj.Add('promisedDeliveryDate', Format(OrderConfLineBuffer."Promised Delivery Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                LineObj.Add('unitCode', OrderConfLineBuffer."Unit of Measure Code");

                // Schedule Line object
                Clear(ScheduleLineObj);
                ScheduleLineObj.Add('purchaseOrderScheduleLine', OrderConfLineBuffer."Purchase Order Schedule Line");
                ScheduleLineObj.Add('promisedDeliveryDate', Format(OrderConfLineBuffer."Promised Delivery Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                ScheduleLineObj.Add('dueDate', Format(OrderConfLineBuffer."Due Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                ScheduleLineObj.Add('scheduleLineOrderQuantity', OrderConfLineBuffer."Schedule Line Order Quantity");
                ScheduleLineObj.Add('confirmedOrderQuantity', OrderConfLineBuffer."Confirmed Order Quantity");
                ScheduleLineObj.Add('confirmedOrderQuantityUOM', OrderConfLineBuffer."Confirmed Order Quantity UOM");
                ScheduleLineObj.Add('unitCode', OrderConfLineBuffer."Unit of Measure Code");

                LineObj.Add('scheduleLine', ScheduleLineObj);
                LinesArray.Add(LineObj);
            until OrderConfLineBuffer.Next() = 0;

        JsonObj.Add('items', LinesArray);

        exit(Format(JsonObj));
    end;

    local procedure FormatDateTime(DT: DateTime): Text
    begin
        exit(Format(DT, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'));
    end;

    local procedure GetAuthorizationHeader(): Text
    begin
        LoadSetup();
        case Setup."Boomi Auth Type" of
            Setup."Boomi Auth Type"::BasicAuth:
                exit(GetBasicAuthHeader());
            Setup."Boomi Auth Type"::OAuth:
                exit('Bearer ' + GetOAuthAccessToken());
        end;
    end;

    local procedure GetBasicAuthHeader(): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        Credentials: Text;
    begin
        if (Setup."Boomi Username" = '') or (Setup."Boomi Password" = '') then
            Error(BasicAuthConfigMissingErr);

        Credentials := Setup."Boomi Username" + ':' + Setup."Boomi Password";
        exit('Basic ' + Base64Convert.ToBase64(Credentials));
    end;

    local procedure GetOAuthAccessToken(): Text
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        RequestBody: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        ExpiresIn: Integer;
    begin
        // Return cached token if still valid (with 60 second buffer)
        if (AccessToken <> '') and (TokenExpiry > CurrentDateTime + 60000) then
            exit(AccessToken);

        LoadSetup();

        // Validate OAuth configuration
        if (Setup."Boomi OAuth Token URL" = '') or
           (Setup."Boomi Client ID" = '') or
           (Setup."Boomi Client Secret" = '') then
            Error(OAuthConfigMissingErr);

        // Build OAuth 2.0 client credentials request
        RequestBody := 'grant_type=client_credentials' +
                       '&client_id=' + UriEncode(Setup."Boomi Client ID") +
                       '&client_secret=' + UriEncode(Setup."Boomi Client Secret");

        if Setup."Boomi OAuth Scope" <> '' then
            RequestBody += '&scope=' + UriEncode(Setup."Boomi OAuth Scope");

        Content.WriteFrom(RequestBody);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        if not Client.Post(Setup."Boomi OAuth Token URL", Content, Response) then
            Error(TokenRequestFailedErr, 'Connection failed');

        if not Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ResponseText);
            Error(TokenRequestFailedErr, 'HTTP ' + Format(Response.HttpStatusCode) + ': ' + ResponseText);
        end;

        Response.Content.ReadAs(ResponseText);

        if not JsonResponse.ReadFrom(ResponseText) then
            Error(TokenRequestFailedErr, 'Invalid JSON response');

        if not JsonResponse.Get('access_token', JsonToken) then
            Error(TokenRequestFailedErr, 'No access_token in response');

        AccessToken := JsonToken.AsValue().AsText();

        // Cache token expiry
        if JsonResponse.Get('expires_in', JsonToken) then begin
            ExpiresIn := JsonToken.AsValue().AsInteger();
            TokenExpiry := CurrentDateTime + (ExpiresIn * 1000);
        end else
            TokenExpiry := CurrentDateTime + 3600000; // Default 1 hour

        exit(AccessToken);
    end;

    local procedure UriEncode(Input: Text): Text
    var
        TypeHelper: Codeunit "Uri";
    begin
        exit(TypeHelper.EscapeDataString(Input));
    end;

    procedure PushAllUnsent(): Integer
    var
        OrderConfBuffer: Record "SKU Order Conf Buffer";
        Counter: Integer;
    begin
        OrderConfBuffer.SetRange("Sent to SAP", false);
        if OrderConfBuffer.FindSet() then
            repeat
                if PushOrderConfirmation(OrderConfBuffer) then
                    Counter += 1;
            until OrderConfBuffer.Next() = 0;
        exit(Counter);
    end;

    local procedure LoadSetup()
    begin
        if SetupLoaded then
            exit;
        Setup.GetSetup();
        SetupLoaded := true;
    end;
}
