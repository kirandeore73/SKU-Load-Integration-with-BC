codeunit 72027 "SKU 850 Order Buffer Mgt"
{
    Permissions = tabledata "SKU 850 Order Buffer" = RIMD,
                  tabledata "SKU 850 Order Line Buffer" = RIMD,
                  tabledata "Sales Header" = RIMD,
                  tabledata "Sales Line" = RIMD,
                  tabledata "Sales Comment Line" = RIMD,
                  tabledata "Shipment Method" = RIMD,
                  tabledata "Ship-to Address" = RIMD,
                  tabledata "General Ledger Setup" = R,
                  tabledata "IWX LP Line Usage" = R,
                  tabledata "SKUIntegrationLog" = RIMD,
                  tabledata SKUIntegrationSetup = RIMD;

    var
        CustomerNotSpecifiedErr: Label 'A "senderPartyInternalId" that maps to a customer must be provided.';
        CustomerNotFoundErr: Label 'The customer %1 cannot be found.', Comment = '%1 = customer number';
        AutoSalesOrderRequiredErr: Label 'Auto Sales Order must be enabled on customer %1 before an EDI 850 order can be created.', Comment = '%1 = customer number';
        OrderAlreadyProcessedErr: Label 'Order %1 was already processed into sales order %2.', Comment = '%1 = purchase order id, %2 = sales order no.';
        OrderCreatedTxt: Label 'Sales order %1 created from EDI 850.', Comment = '%1 = sales order no.';
        OrderUpdatedTxt: Label 'Sales order %1 updated from EDI 860.', Comment = '%1 = sales order no.';
        OrderNotFoundErr: Label 'No sales order found for purchase order %1 to apply EDI 860 change.', Comment = '%1 = purchase order id';
        InvalidActionCodeErr: Label 'Unsupported action code %1. Use 01 for EDI 850 create or 02 for EDI 860 update.', Comment = '%1 = action code';

    procedure PropagateOnInsert(var OrderBuffer: Record "SKU 850 Order Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        if IsNullGuid(OrderBuffer.Id) then
            OrderBuffer.Id := CreateGuid();

        OrderBuffer.Status := OrderBuffer.Status::New;
        OrderBuffer.Insert(true);
        ProcessOrder(OrderBuffer);
    end;

    procedure PropagateOnModify(var OrderBuffer: Record "SKU 850 Order Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        OrderBuffer.Modify(true);
    end;

    procedure PropagateOnDelete(var OrderBuffer: Record "SKU 850 Order Buffer")
    var
        OrderLineBuffer: Record "SKU 850 Order Line Buffer";
    begin
        OrderLineBuffer.SetRange("Document Id", OrderBuffer.Id);
        OrderLineBuffer.DeleteAll(true);
        OrderBuffer.Delete(true);
    end;

    procedure PropagateInsertLine(var OrderLineBuffer: Record "SKU 850 Order Line Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    var
        OrderBuffer: Record "SKU 850 Order Buffer";
        SalesHeader: Record "Sales Header";
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
        OrderStatusSFDCMgt: Codeunit "Order Status SFDC Mgt";
    begin
        if OrderLineBuffer."Purchase Order Item ID" = 0 then
            exit;

        // Boomi may send the PO item ID without the duplicate OrderItem field.
        if OrderLineBuffer."PO Item ID_OrderItem" = 0 then
            OrderLineBuffer."PO Item ID_OrderItem" := OrderLineBuffer."Purchase Order Item ID";
        if OrderLineBuffer."Action Code_OrderItem" = '' then
            OrderLineBuffer."Action Code_OrderItem" := OrderLineBuffer."Action Code";

        if IsNullGuid(OrderLineBuffer.Id) then
            OrderLineBuffer.Id := CreateGuid();

        OrderLineBuffer.Insert(true);

        // Add each nested OrderItem to the sales order created with the header.
        OrderBuffer.SetRange(Id, OrderLineBuffer."Document Id");
        if not OrderBuffer.FindFirst() then
            exit;

        if (OrderBuffer.Status = OrderBuffer.Status::Processed) and
           SalesHeader.Get(SalesHeader."Document Type"::Order, OrderBuffer."Order No.") then begin
            CreateSalesLine(OrderBuffer, OrderLineBuffer, SalesHeader);

            if OrderBuffer."Action Code" = '01' then begin
                CreateOrderAcknowledgement(OrderBuffer);
                if not OrderStatusSFDCMgt.TryCreateFromSalesHeader(SalesHeader) then; // SFDC sync failures must not block the 850 insert
                if OrderBuffer."Web Order No." <> '' then
                    HybrisOrderStatusMgt.SendOrderStatusToHybris(SalesHeader);
            end;
        end;
    end;

    procedure PropagateModifyLine(var OrderLineBuffer: Record "SKU 850 Order Line Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        if OrderLineBuffer."PO Item ID_OrderItem" = 0 then
            exit;

        if OrderLineBuffer."Purchase Order Item ID" = 0 then
            exit;
        OrderLineBuffer.Modify(true);
    end;

    procedure PropagateDeleteLine(var OrderLineBuffer: Record "SKU 850 Order Line Buffer")
    begin
        OrderLineBuffer.Delete(true);
    end;

    procedure ProcessOrder(var OrderBuffer: Record "SKU 850 Order Buffer"): Code[20]
    var
        ErrorText: Text;
        SuccessMsg: Text;
        OrderNo: Code[20];
        DocumentId: Guid;
    begin
        ClearLastError();
        if ShouldSkipClosed860(OrderBuffer) then
            exit('');

        if TryProcessOrder(OrderBuffer) then begin
            OrderNo := OrderBuffer."Order No.";
            DocumentId := OrderBuffer.Id;
            // Set success message based on ActionCode (850 create vs. 860 update)
            if OrderBuffer."Action Code" = '02' then
                SuccessMsg := StrSubstNo(OrderUpdatedTxt, OrderNo)
            else
                SuccessMsg := StrSubstNo(OrderCreatedTxt, OrderNo);
            WriteLog(OrderBuffer, true, SuccessMsg);
            // Commit the order and 855 buffer before removing processed 850/860 staging records.
            Commit();
            // DeleteBufferRecords(DocumentId);
            exit(OrderNo);
        end;

        // The failed attempt was rolled back, so re-read before recording the outcome.
        ErrorText := GetLastErrorText();
        if OrderBuffer.Find() then
            SetErrorState(OrderBuffer, ErrorText);
        WriteLog(OrderBuffer, false, ErrorText);
        Commit();

        Error(ErrorText);
    end;

    local procedure ShouldSkipClosed860(var OrderBuffer: Record "SKU 850 Order Buffer"): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if OrderBuffer."Action Code" <> '02' then
            exit(false);

        if not FindExistingSalesOrderByPoAndCustomer(OrderBuffer, SalesHeader) then
            exit(false);

        exit(SalesHeader.Status <> SalesHeader.Status::Open);
    end;

    [TryFunction]
    local procedure TryProcessOrder(var OrderBuffer: Record "SKU 850 Order Buffer")
    var
        SalesHeader: Record "Sales Header";
    begin
        if (OrderBuffer.Status = OrderBuffer.Status::Processed) and (OrderBuffer."Order No." <> '') then
            Error(OrderAlreadyProcessedErr, OrderBuffer."Purchase Order ID", OrderBuffer."Order No.");

        CheckCustomerSpecified(OrderBuffer);

        case OrderBuffer."Action Code" of
            '01':
                begin
                    // EDI 850: create a new sales order.
                    CheckAutoSalesOrderEnabled(OrderBuffer."Sender Internal ID");
                    if not GetExistingSalesOrder(OrderBuffer, SalesHeader) then
                        CreateSalesHeader(OrderBuffer, SalesHeader);
                    ApplyHeaderValues(OrderBuffer, SalesHeader);
                    SalesHeader."Created From EDI 850" := true;
                    SalesHeader.Modify(true);
                    ApplyLines(OrderBuffer, SalesHeader);
                end;
            '02':
                begin
                    // EDI 860: update the existing sales order.
                    if not FindExistingSalesOrderByPoAndCustomer(OrderBuffer, SalesHeader) then
                        Error(OrderNotFoundErr, OrderBuffer."Purchase Order ID");
                    UpdateSalesOrder(OrderBuffer, SalesHeader);
                end;
            else
                Error(InvalidActionCodeErr, OrderBuffer."Action Code");
        end;

        OrderBuffer."Order No." := SalesHeader."No.";
        OrderBuffer."Order Id" := SalesHeader.SystemId;
        OrderBuffer.Status := OrderBuffer.Status::Processed;
        OrderBuffer."Processed DateTime" := CurrentDateTime();
        OrderBuffer."Error Message" := '';
        OrderBuffer.Modify(true);
    end;

    local procedure WriteLog(var OrderBuffer: Record "SKU 850 Order Buffer"; Success: Boolean; MessageText: Text)
    var
        IntegrationLog: Record "SKUIntegrationLog";
    begin
        IntegrationLog.Init();
        // Log message type based on ActionCode: 860 for updates, 850 for new orders
        if OrderBuffer."Action Code" = '02' then
            IntegrationLog."Message Type" := IntegrationLog."Message Type"::OrderChange860
        else
            IntegrationLog."Message Type" := IntegrationLog."Message Type"::OrderRequest850;
        IntegrationLog.Direction := IntegrationLog.Direction::Inbound;
        IntegrationLog.CreatedDateTime := CurrentDateTime();
        IntegrationLog.Success := Success;
        IntegrationLog.FileName := CopyStr(OrderBuffer."Purchase Order ID", 1, MaxStrLen(IntegrationLog.FileName));
        IntegrationLog."Related Document No." := CopyStr(OrderBuffer."Order No.", 1, MaxStrLen(IntegrationLog."Related Document No."));
        IntegrationLog.Message := CopyStr(MessageText, 1, MaxStrLen(IntegrationLog.Message));
        IntegrationLog.Insert(true);
    end;

    local procedure CreateOrderAcknowledgement(var OrderBuffer: Record "SKU 850 Order Buffer"): Boolean
    var
        SalesHeader: Record "Sales Header";
        OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
    begin
        if OrderBuffer."Order No." = '' then
            exit(false);

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, OrderBuffer."Order No.") then
            exit(false);

        exit(OrderConfBufferMgt.CreateFromSalesOrder(SalesHeader));
    end;

    local procedure GetSalesHeader(OrderNo: Code[20]): Record "Sales Header"
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        exit(SalesHeader);
    end;

    local procedure CheckCustomerSpecified(var OrderBuffer: Record "SKU 850 Order Buffer")
    var
        Customer: Record Customer;
    begin
        if OrderBuffer."Sender Internal ID" = '' then
            Error(CustomerNotSpecifiedErr);

        if not Customer.Get(OrderBuffer."Sender Internal ID") then
            Error(CustomerNotFoundErr, OrderBuffer."Sender Internal ID");
    end;

    local procedure CheckAutoSalesOrderEnabled(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        if not Customer."Auto Sales Order" then
            Error(AutoSalesOrderRequiredErr, Customer."No.");
    end;

    local procedure FindCustomerByBuyerPartyId(BuyerPartyId: Code[20]): Code[20]
    var
        Customer: Record Customer;
    begin
        if BuyerPartyId = '' then
            exit('');

        // Direct match: BC customer No. = SAP BuyerPartyID — no setup required.
        if Customer.Get(BuyerPartyId) then
            exit(Customer."No.");

        // Fallback: custom cross-reference field for environments where numbers differ.
        Customer.SetRange("SAP Buyer Party ID", BuyerPartyId);
        if Customer.FindFirst() then
            exit(Customer."No.");

        exit('');
    end;

    local procedure GetExistingSalesOrder(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header"): Boolean
    begin
        if OrderBuffer."Order No." = '' then
            exit(false);

        exit(SalesHeader.Get(SalesHeader."Document Type"::Order, OrderBuffer."Order No."));
    end;

    local procedure FindExistingSalesOrderByPoAndCustomer(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header"): Boolean
    var
        SalesHeaderExt: Record "Sales Header";
    begin
        // First find candidate sales orders by SAP purchase order number.
        SalesHeaderExt.SetRange("Document Type", SalesHeaderExt."Document Type"::Order);
        SalesHeaderExt.SetRange("SAP Purchase Order No.", OrderBuffer."Purchase Order ID");
        if not SalesHeaderExt.FindSet() then
            exit(false);

        repeat
            // Require the secondary sender/customer match even for a unique PO.
            if (OrderBuffer."Sender Internal ID" <> '') and
               (SalesHeaderExt."Sell-to Customer No." = OrderBuffer."Sender Internal ID") then begin
                SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeaderExt."No.");
                exit(true);
            end;
        until SalesHeaderExt.Next() = 0;

        exit(false);
    end;

    local procedure CreateSalesHeader(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", OrderBuffer."Sender Internal ID");
        SalesHeader.Modify(true);
    end;

    local procedure ApplyHeaderValues(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
    begin
        if SalesHeader."Sell-to Customer No." <> OrderBuffer."Sender Internal ID" then
            SalesHeader.Validate("Sell-to Customer No.", OrderBuffer."Sender Internal ID");

        //  if OrderBuffer."Order Date" <> 0D then begin
        SalesHeader.Validate("Order Date", OrderBuffer."Order Date");
        SalesHeader.Validate("Document Date", OrderBuffer."Order Date");
        //  end;

        GeneralLedgerSetup.Get();
        if OrderBuffer."Order Currency" = GeneralLedgerSetup."LCY Code" then
            SalesHeader.Validate("Currency Code", '')
        else
            SalesHeader.Validate("Currency Code", OrderBuffer."Order Currency");

        SalesHeader.Validate("Your Reference", CopyStr(OrderBuffer."Customer PO", 1, MaxStrLen(SalesHeader."Your Reference")));
        SalesHeader.Validate("External Document No.", CopyStr(OrderBuffer."Customer Ref PO", 1, MaxStrLen(SalesHeader."External Document No.")));

        // if OrderBuffer."SupplierPartyID_Shipto" <> '' then
        SalesHeader.Validate("SupplierPartyID_Shipto", OrderBuffer."SupplierPartyID_Shipto");
        // else
        //    SalesHeader.Validate("Bill-to Customer No.", OrderBuffer."Sender Internal ID");
        //   SalesHeader."Sell-to Customer Name" := OrderBuffer."Company Code Name";
        // SalesHeader."Bill-to Name" := OrderBuffer."Company Code Name";
        // SalesHeader."Bill-to Address" := CopyStr(OrderBuffer."Bill-to Address 1", 1, MaxStrLen(SalesHeader."Bill-to Address"));
        // SalesHeader."Bill-to Address 2" := CopyStr(OrderBuffer."Bill-to Address 2", 1, MaxStrLen(SalesHeader."Bill-to Address 2"));
        // SalesHeader."Bill-to City" := OrderBuffer."Bill-to City";
        // SalesHeader."Bill-to County" := OrderBuffer."Bill-to State";
        // SalesHeader."Bill-to Country/Region Code" := OrderBuffer."Bill-to Country";
        // SalesHeader."Bill-to Post Code" := OrderBuffer."Bill-to Zip";
        SalesHeader."EDI Address Id" := OrderBuffer."Address Id";
        // Find or create a Ship-to Address for this customer, keyed by EDI Address Id.
        if (OrderBuffer."Address Id" <> '') or (OrderBuffer."Ship-to Address 1" <> '') then
            SalesHeader.Validate("Ship-to Code", FindOrCreateShipToAddress(OrderBuffer, OrderBuffer."Sender Internal ID"));

        if OrderBuffer."Shipping Via" <> '' then begin
            if not ShipmentMethod.Get(OrderBuffer."Shipping Via") then begin
                ShipmentMethod.Init();
                ShipmentMethod.Code := OrderBuffer."Shipping Via";
                ShipmentMethod.Description := CopyStr(OrderBuffer."Shipping Via Desc", 1, MaxStrLen(ShipmentMethod.Description));
                ShipmentMethod.Insert(true);
            end;
            SalesHeader.Validate("Shipment Method Code", OrderBuffer."Shipping Via");
        end;

        SalesHeader."Ship-to Contact" := OrderBuffer."Contact Name";
        SalesHeader."EDI Ship-to Contact Phone" := OrderBuffer."Contact Phone";
        SalesHeader."EDI Ship-to Contact Email" := OrderBuffer."Contact Email";

        SalesHeader."SAP Purchase Order No." := CopyStr(OrderBuffer."Purchase Order ID", 1, MaxStrLen(SalesHeader."SAP Purchase Order No."));
        SalesHeader."SAP Sales Order No." := CopyStr(OrderBuffer."SAP Order No.", 1, MaxStrLen(SalesHeader."SAP Sales Order No."));
        SalesHeader."SAP Sender Internal ID" := OrderBuffer."Sender Internal ID";
        SalesHeader."SAP Recipient Internal ID" := OrderBuffer."Recipient Internal ID";
        SalesHeader."EDI Company Code" := OrderBuffer."EDI Company Code";
        SalesHeader."Purchasing Document Type" := OrderBuffer."Purchasing Document Type";
        SalesHeader."Purchasing Document Type Name" := OrderBuffer."Purchasing Document Type Name";
        SalesHeader."Purch Doc Type Language Code" := OrderBuffer."Purch Doc Type Language Code";

        SalesHeader."EDI Message ID" := OrderBuffer."Message ID";
        SalesHeader."EDI Order Type" := OrderBuffer."Order Type";
        SalesHeader."EDI Sales Payment Terms" := OrderBuffer."Sales Payment Terms";
        SalesHeader."EDI Tax Jurisdiction Code" := OrderBuffer."EDI Tax Jurisdiction Code";

        SalesHeader."EDI Bill-to Company" := OrderBuffer."Bill-to Company";
        SalesHeader."EDI Bill-to Address 1" := OrderBuffer."Bill-to Address 1";
        SalesHeader."EDI Bill-to Address 2" := OrderBuffer."Bill-to Address 2";
        SalesHeader."EDI Bill-to Address 3" := OrderBuffer."Bill-to Address 3";
        SalesHeader."EDI Bill-to Address 4" := OrderBuffer."Bill-to Address 4";
        SalesHeader."EDI Bill-to City" := OrderBuffer."Bill-to City";
        SalesHeader."EDI Bill-to State" := OrderBuffer."Bill-to State";
        SalesHeader."EDI Bill-to Country" := OrderBuffer."Bill-to Country";
        SalesHeader."EDI Bill-to Zip" := OrderBuffer."Bill-to Zip";
        SalesHeader."EDI Bill-to Phone" := OrderBuffer."Bill-to Phone";
        SalesHeader."EDI Bill-to Email" := OrderBuffer."Bill-to Email";

        SalesHeader."EDI Ship-to House Number" := OrderBuffer."Ship-to House Number";
        SalesHeader."EDI Ship-to State Name" := OrderBuffer."Ship-to State Name";
        SalesHeader."EDI Ship-to Phone" := OrderBuffer."Ship-to Phone";
        SalesHeader."EDI Ship-to Email" := OrderBuffer."Ship-to Email";
        SalesHeader."EDI Ship-to Attention" := OrderBuffer."Ship-to Attention";

        SalesHeader."EDI Shipping Account No." := OrderBuffer."Shipping Account Number";
        SalesHeader."EDI Ship Complete" := OrderBuffer."Ship Complete";
        SalesHeader."EDI Ship Early" := OrderBuffer."Ship Early";
        SalesHeader."EDI Ship Partial" := OrderBuffer."Ship Partial";
        SalesHeader."EDI Shipping Notes" := OrderBuffer."Shipping Notes";
        SalesHeader."EDI Scheduled Shipment" := OrderBuffer."Scheduled Shipment";
        SalesHeader."EDI Freight" := OrderBuffer.Freight;
        SalesHeader."EDI Handling Charges" := OrderBuffer."Handling Charges";

        SalesHeader."EDI Store Number" := OrderBuffer."Store Number";
        SalesHeader."EDI Web Order No." := OrderBuffer."Web Order No.";
        SalesHeader."EDI Legacy Order Number" := OrderBuffer."Legacy Order Number";
        SalesHeader."EDI ASM Initial" := OrderBuffer."ASM Initial";
        SalesHeader."EDI Hybris RMA" := OrderBuffer."Hybris RMA";

        SalesHeader."EDI Is Govt Order" := OrderBuffer."Is Govt Order";
        SalesHeader."EDI Govt Type" := OrderBuffer."Govt Type";
        SalesHeader."EDI Price Mismatch" := OrderBuffer."Price Mismatch";
        SalesHeader."EDI Questionare Type" := OrderBuffer."Questionare Type";
        SalesHeader."EDI Discontinued Items" := OrderBuffer."Discontinued Items";
        SalesHeader."EDI Discont. Item Notes" := OrderBuffer."Discontinued Item Notes";
        SalesHeader."EDI Vendor Price" := OrderBuffer."Vendor Price";
        SalesHeader.Modify(true);
    end;

    local procedure ApplyLines(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header")
    var
        OrderLineBuffer: Record "SKU 850 Order Line Buffer";
        SalesLine: Record "Sales Line";
    begin
        if OrderBuffer."Action Code" = '01' then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.DeleteAll(true);
        end;

        OrderLineBuffer.SetRange("Document Id", OrderBuffer.Id);
        if not OrderLineBuffer.FindSet() then
            exit;

        repeat
            CreateSalesLine(OrderBuffer, OrderLineBuffer, SalesHeader);
        until OrderLineBuffer.Next() = 0;
    end;

    local procedure CreateSalesLine(var OrderBuffer: Record "SKU 850 Order Buffer"; var OrderLineBuffer: Record "SKU 850 Order Line Buffer"; var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ItemNo: Code[20];
    begin
        // Freight lines have no OrderItem node, so PurchaseOrderItemID_OrderItem is blank.
        if OrderLineBuffer."PO Item ID_OrderItem" = 0 then
            exit;
        if OrderLineBuffer."Purchase Order Item ID" = 0 then
            exit;
        ItemNo := ResolveItemNo(OrderLineBuffer);
        if ItemNo = '' then
            exit;

        case OrderLineBuffer."Action Code_OrderItem" of
            '01':
                begin
                    if FindSalesLine(OrderLineBuffer, SalesHeader, SalesLine) then
                        exit;

                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type"::Order);
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine."Line No." := GetNextSalesLineNo(SalesHeader);
                    SalesLine.Insert(true);
                end;
            '02':
                if not FindSalesLine(OrderLineBuffer, SalesHeader, SalesLine) then
                    exit;
            else
                exit;
        end;

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);

        if OrderLineBuffer."Unit of Measure Code" <> '' then
            SalesLine.Validate("Unit of Measure Code", OrderLineBuffer."Unit of Measure Code")
        else if OrderLineBuffer."Schedule Line Unit Code" <> '' then
            SalesLine.Validate("Unit of Measure Code", OrderLineBuffer."Schedule Line Unit Code");

        if OrderLineBuffer."Schedule Line Order Quantity" <> 0 then
            SalesLine.Validate(Quantity, OrderLineBuffer."Schedule Line Order Quantity")
        else
            SalesLine.Validate(Quantity, OrderLineBuffer.Quantity);

        if OrderLineBuffer."Requested Delivery Date" <> 0D then
            SalesLine.Validate("Shipment Date", OrderLineBuffer."Requested Delivery Date");
        SalesLine.Validate("Unit Price", CalculateUnitPrice(OrderLineBuffer));

        // ExpectedNetPrice/Amount is the SAP purchase price; Sales Line has Unit Cost, not Direct Unit Cost.
        if OrderLineBuffer."Direct Unit Cost" <> 0 then
            SalesLine.Validate("Unit Cost", OrderLineBuffer."Direct Unit Cost");

        // if OrderLineBuffer."Location Code" <> '' then
        //     SalesLine.Validate("Location Code", OrderLineBuffer."Location Code");

        // if OrderLineBuffer."Requested Delivery Date" <> 0D then begin
        //     SalesLine.Validate("Requested Delivery Date", OrderLineBuffer."Requested Delivery Date");
        //     SalesLine.Validate("Shipment Date", OrderLineBuffer."Requested Delivery Date");
        // end;

        SalesLine."SAP PO Line No." := OrderLineBuffer."Purchase Order Item ID";
        SalesLine."Action Code_OrderItem" := OrderLineBuffer."Action Code_OrderItem";
        SalesLine."PO Item ID_OrderItem" := OrderLineBuffer."PO Item ID_OrderItem";
        SalesLine."Buyer Product ID_Product" := OrderLineBuffer."Buyer Product ID_Product";
        SalesLine."Supplier Product ID_Product" := OrderLineBuffer."Supplier Product ID_Product";
        SalesLine."SAP Sales Order Item ID" := OrderLineBuffer."Sales Order Item ID";
        SalesLine."Schedule Line Order Quantity" := OrderLineBuffer."Schedule Line Order Quantity";
        SalesLine."Schedule Line Unit Code" := OrderLineBuffer."Schedule Line Unit Code";
        SalesLine."SAP Sales Order No." := CopyStr(OrderBuffer."SAP Order No.", 1, MaxStrLen(SalesLine."SAP Sales Order No."));
        SalesLine."Purchase Order Schedule Line" := OrderLineBuffer."Purchase Order Schedule Line";

        // SalesLine."SAP Purchase Order No." := CopyStr(OrderBuffer."Purchase Order ID", 1, MaxStrLen(SalesLine."SAP Purchase Order No."));
        //  SalesLine."SAP Sales Order No." := CopyStr(OrderBuffer."SAP Order No.", 1, MaxStrLen(SalesLine."SAP Sales Order No."));
        //  SalesLine."SAP Product Code" := CopyStr(OrderLineBuffer."Buyer Product ID", 1, MaxStrLen(SalesLine."SAP Product Code"));

        //  SalesLine."Sales Order Item ID" := OrderLineBuffer."Sales Order Item ID";    //FOR NOW JUST STORE THIS AS SOMETIMS sap SENDING THIS LINE NO. AS 1, 2, BUT I OUR bc IT IS AUTO GENRATED AS 10000 LIKEWISE SO IF any other file asking line no of sales order back give 10000, and SAP salesorder line no will be this diffent
        // SalesLine."Buyer Product ID" := ItemNo;
        // SalesLine."EDI PO Schedule Line" := OrderLineBuffer."PO Schedule Line";
        salesline."CustItem" := OrderLineBuffer."CustItem";
        // SalesLine."Customer Part No." := OrderLineBuffer."Customer Part No.";
        SalesLine."Buyer Part Number" := OrderLineBuffer."Buyer Part Number";
        // SalesLine."EDI Line Level Comment" := OrderLineBuffer."Line Level Comment";
        SalesLine."Is Configurable" := OrderLineBuffer."Is Configurable";
        SalesLine."Config Part Number" := OrderLineBuffer."Config Part Number";
        SalesLine."Product Configuration" := OrderLineBuffer."Product Configuration";
        SalesLine."RestockFeePer" := OrderLineBuffer.RestockFeePer;
        // SalesLine.DRV1 := OrderLineBuffer.DRV1;
        //  SalesLine.DRV1 := OrderLineBuffer.DRV1;
        SalesLine.Modify(true);
        CreateSalesLineComments(SalesLine, OrderLineBuffer."Line Level Comment");
        // SalesLine.DRV1 := OrderLineBuffer.DRV1;
    end;

    local procedure FindSalesLine(OrderLineBuffer: Record "SKU 850 Order Line Buffer"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"): Boolean
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("SAP PO Line No.", OrderLineBuffer."Purchase Order Item ID");
        SalesLine.SetRange("SAP Sales Order Item ID", OrderLineBuffer."Sales Order Item ID");
        exit(SalesLine.FindFirst());
    end;

    local procedure GetNextSalesLineNo(SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure CreateSalesLineComments(SalesLine: Record "Sales Line"; CommentText: Text)
    var
        SalesCommentLine: Record "Sales Comment Line";
        CommentLineNo: Integer;
        StartPosition: Integer;
    begin
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Order);
        SalesCommentLine.SetRange("No.", SalesLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesLine."Line No.");

        StartPosition := 1;
        if SalesCommentLine.FindLast() then
            CommentLineNo := SalesCommentLine."Line No." + 10000
        else
            CommentLineNo := 10000;
        while StartPosition <= StrLen(CommentText) do begin
            SalesCommentLine.Init();
            SalesCommentLine."Document Type" := SalesCommentLine."Document Type"::Order;
            SalesCommentLine."No." := SalesLine."Document No.";
            SalesCommentLine."Document Line No." := SalesLine."Line No.";
            SalesCommentLine."Line No." := CommentLineNo;
            SalesCommentLine.Comment := CopyStr(CommentText, StartPosition, MaxStrLen(SalesCommentLine.Comment));
            SalesCommentLine.Validate(Date, Today());
            SalesCommentLine.Insert(true);
            StartPosition += MaxStrLen(SalesCommentLine.Comment);
            CommentLineNo += 10000;
        end;
    end;

    local procedure ResolveItemNo(var OrderLineBuffer: Record "SKU 850 Order Line Buffer"): Code[20]
    var
        Item: Record Item;
        BuyerProductId: Code[35];
    begin
        if OrderLineBuffer."Buyer Product ID_Product" <> '' then
            BuyerProductId := OrderLineBuffer."Buyer Product ID_Product"
        else
            BuyerProductId := OrderLineBuffer."Buyer Product ID";

        if BuyerProductId <> '' then begin
            Item.SetRange("Buyer Product ID", BuyerProductId);
            if Item.FindFirst() then
                exit(Item."No.");

            if Item.Get(BuyerProductId) then
                exit(Item."No.");
        end;

        exit('');
    end;

    // local procedure FindItemByCustomerReference(ReferenceNo: Text; CustomerNo: Code[20]): Code[20]
    // var
    //     ItemReference: Record "Item Reference";
    // begin
    //     if (ReferenceNo = '') or (CustomerNo = '') then
    //         exit('');

    //     ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
    //     ItemReference.SetRange("Reference Type No.", CustomerNo);
    //     ItemReference.SetRange("Reference No.", CopyStr(ReferenceNo, 1, MaxStrLen(ItemReference."Reference No.")));
    //     if ItemReference.FindFirst() then
    //         exit(ItemReference."Item No.");

    //     exit('');
    // end;

    // Mapping rule: UnitPrice = UnitPrice - ((DRV1 * -1) / Qty)
    local procedure CalculateUnitPrice(var OrderLineBuffer: Record "SKU 850 Order Line Buffer"): Decimal
    begin
        if (OrderLineBuffer.DRV1 = 0) or (OrderLineBuffer.Quantity = 0) then
            exit(OrderLineBuffer."Unit Price");

        exit(OrderLineBuffer."Unit Price" - ((OrderLineBuffer.DRV1 * -1) / OrderLineBuffer.Quantity));
    end;

    local procedure UpdateSalesOrder(var OrderBuffer: Record "SKU 850 Order Buffer"; var SalesHeader: Record "Sales Header")
    begin
        // For EDI 860: update header fields (prices, dates, quantities, ship-to address, etc.)
        // Reuse ApplyHeaderValues and ApplyLines (which deletes old lines and creates new ones)
        ApplyHeaderValues(OrderBuffer, SalesHeader);
        ApplyLines(OrderBuffer, SalesHeader);
    end;

    local procedure DeleteBufferRecords(DocumentId: Guid)
    var
        OrderLineBuffer: Record "SKU 850 Order Line Buffer";
        OrderBuffer: Record "SKU 850 Order Buffer";
    begin
        // Delete all line buffer records for this order
        OrderLineBuffer.SetRange("Document Id", DocumentId);
        OrderLineBuffer.DeleteAll(true);

        // Delete the header buffer record
        OrderBuffer.SetRange(Id, DocumentId);
        if OrderBuffer.FindFirst() then
            OrderBuffer.Delete(true);
    end;

    local procedure FindOrCreateShipToAddress(var OrderBuffer: Record "SKU 850 Order Buffer"; CustomerNo: Code[20]): Code[10]
    var
        ShipToAddress: Record "Ship-to Address";
        CombinedAddr2: Text[150];
        ShipToAddressExists: Boolean;
    begin
        if OrderBuffer."Address Id" <> '' then begin
            ShipToAddress.SetRange("Customer No.", CustomerNo);
            ShipToAddress.SetRange("EDI Address Id", OrderBuffer."Address Id");
            if ShipToAddress.FindFirst() then
                ShipToAddressExists := true;
        end;
        if not ShipToAddressExists and (OrderBuffer."Address Id" = '') then begin
            ShipToAddress.Reset();
            ShipToAddress.SetRange("Customer No.", CustomerNo);
            ShipToAddress.SetRange(Address, OrderBuffer."Ship-to Address 1");
            ShipToAddress.SetRange("Post Code", OrderBuffer."Ship-to Zip");
            if ShipToAddress.FindFirst() then
                ShipToAddressExists := true;
        end;

        if not ShipToAddressExists then begin
            ShipToAddress.Init();
            ShipToAddress."Customer No." := CustomerNo;
            ShipToAddress.Code := GetNextShipToCode(CustomerNo);
        end;

        ShipToAddress.Name := CopyStr(OrderBuffer."Ship-to Company", 1, MaxStrLen(ShipToAddress.Name));
        ShipToAddress.Address := CopyStr(OrderBuffer."Ship-to Address 1", 1, MaxStrLen(ShipToAddress.Address));
        CombinedAddr2 := OrderBuffer."Ship-to Address 2";
        if OrderBuffer."Ship-to Address 3" <> '' then
            CombinedAddr2 += ', ' + OrderBuffer."Ship-to Address 3";
        if OrderBuffer."Ship-to Address 4" <> '' then
            CombinedAddr2 += ', ' + OrderBuffer."Ship-to Address 4";
        ShipToAddress."Address 2" := CopyStr(CombinedAddr2, 1, MaxStrLen(ShipToAddress."Address 2"));
        ShipToAddress.City := OrderBuffer."Ship-to City";
        ShipToAddress.County := CopyStr(OrderBuffer."Ship-to State Code", 1, MaxStrLen(ShipToAddress.County));
        ShipToAddress."Country/Region Code" := OrderBuffer."Ship-to Country";
        ShipToAddress."Post Code" := OrderBuffer."Ship-to Zip";
        ShipToAddress."Phone No." := CopyStr(OrderBuffer."Ship-to Phone", 1, MaxStrLen(ShipToAddress."Phone No."));
        ShipToAddress."EDI Ship-to House Number" := CopyStr(OrderBuffer."Ship-to House Number", 1, MaxStrLen(ShipToAddress."EDI Ship-to House Number"));
        ShipToAddress."EDI Ship-to State Name" := CopyStr(OrderBuffer."Ship-to State Name", 1, MaxStrLen(ShipToAddress."EDI Ship-to State Name"));
        ShipToAddress."EDI Ship-to Email" := CopyStr(OrderBuffer."Ship-to Email", 1, MaxStrLen(ShipToAddress."EDI Ship-to Email"));
        ShipToAddress."EDI Address Id" := OrderBuffer."Address Id";
        if ShipToAddressExists then
            ShipToAddress.Modify(true)
        else
            ShipToAddress.Insert(true);
        exit(ShipToAddress.Code);
    end;

    local procedure GetNextShipToCode(CustomerNo: Code[20]): Code[10]
    var
        ShipToAddress: Record "Ship-to Address";
        SeqNo: Integer;
        NewCode: Code[10];
    begin
        SeqNo := 1;
        repeat
            NewCode := ConvertStr(Format(SeqNo, 3), ' ', '0');
            SeqNo += 1;
        until not ShipToAddress.Get(CustomerNo, NewCode);
        exit(NewCode);
    end;

    procedure SetErrorState(var OrderBuffer: Record "SKU 850 Order Buffer"; ErrorText: Text)
    begin
        OrderBuffer.Status := OrderBuffer.Status::Error;
        OrderBuffer."Error Message" := CopyStr(ErrorText, 1, MaxStrLen(OrderBuffer."Error Message"));
        OrderBuffer.Modify(true);
    end;
}