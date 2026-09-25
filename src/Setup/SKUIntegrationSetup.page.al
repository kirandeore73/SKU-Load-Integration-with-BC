page 72001 "SKUIntegrationSetup"
{
    Caption = 'SKU Integration Setup';
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "SKUIntegrationSetup";
    Permissions = tabledata "SKUIntegrationSetup" = RIMD,
                  tabledata Customer = RM;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Message)
            {
                Caption = 'Message Header Defaults';

                field(SenderInternalID; Rec.SenderInternalID)
                {
                    ToolTip = 'Specifies our own party internal ID, used as the sender on outbound messages.';
                }
                field(RecipientInternalID; Rec.RecipientInternalID)
                {
                    ToolTip = 'Specifies the partner party internal ID, used as the recipient on outbound messages.';
                }
            }
            group(BoomiIntegration)
            {
                Caption = 'Boomi Integration';

                field("Boomi 856 Endpoint URL"; Rec."Boomi 856 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 856 ASN/Delivery data (JSON).';
                }
                field("Boomi 855 Endpoint URL"; Rec."Boomi 855 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 855 Order Confirmation data (JSON).';
                }
                field("Boomi 810 Endpoint URL"; Rec."Boomi 810 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 810 invoice data (XML).';
                }
                field("Test 856 Shipment No."; Rec."Test 856 Shipment No.")
                {
                    ToolTip = 'Specifies one posted shipment to use when testing the 856 integration.';
                }
                field("Test 855 Order No."; Rec."Test 855 Order No.")
                {
                    ToolTip = 'Specifies one sales order to use when testing the 855 integration.';
                }
                field("Test 810 Invoice No."; Rec."Test 810 Invoice No.")
                {
                    ToolTip = 'Specifies one posted sales invoice to use when testing the 810 integration.';
                }
                field("Test 850 Purchase Order ID"; Rec."Test 850 Purchase Order ID")
                {
                    ToolTip = 'Specifies one SAP purchase order ID to use when testing the 850 integration.';
                }
                field("EDI Buyer Party Customer No."; Rec."EDI Buyer Party Customer No.")
                {
                    ToolTip = 'Customer No. to stamp SAP Buyer Party ID onto for EDI 850 resolution.';
                }
                field("EDI Buyer Party ID"; Rec."EDI Buyer Party ID")
                {
                    ToolTip = 'The SAP Buyer Party ID (e.g. 1000030) to assign to the customer above.';
                }
                field("Boomi Auth Type"; Rec."Boomi Auth Type")
                {
                    ToolTip = 'Specifies the authentication type: Basic Auth (username/password) or OAuth 2.0.';
                }
            }
            group(BoomiBasicAuth)
            {
                Caption = 'Boomi Basic Auth';
                Visible = Rec."Boomi Auth Type" = Rec."Boomi Auth Type"::BasicAuth;

                field("Boomi Username"; Rec."Boomi Username")
                {
                    ToolTip = 'Specifies the username for Boomi Basic Authentication.';
                }
                field("Boomi Password"; Rec."Boomi Password")
                {
                    ToolTip = 'Specifies the password for Boomi Basic Authentication.';
                }
            }
            group(BoomiOAuth)
            {
                Caption = 'Boomi OAuth 2.0';
                Visible = Rec."Boomi Auth Type" = Rec."Boomi Auth Type"::OAuth;

                field("Boomi OAuth Token URL"; Rec."Boomi OAuth Token URL")
                {
                    ToolTip = 'Specifies the OAuth 2.0 token endpoint URL.';
                }
                field("Boomi Client ID"; Rec."Boomi Client ID")
                {
                    ToolTip = 'Specifies the OAuth 2.0 Client ID.';
                }
                field("Boomi Client Secret"; Rec."Boomi Client Secret")
                {
                    ToolTip = 'Specifies the OAuth 2.0 Client Secret.';
                }
                field("Boomi OAuth Scope"; Rec."Boomi OAuth Scope")
                {
                    ToolTip = 'Specifies the OAuth 2.0 scope (optional).';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PushUnsent855ToBoomi)
            {
                Caption = 'Push Unsent 855 to Boomi';
                ToolTip = 'Pushes all unsent order confirmation records to the Boomi endpoint.';
                Image = SendTo;

                trigger OnAction()
                var
                    OrderConfPush: Codeunit "SKU Order Conf Push";
                    SuccessCount: Integer;
                begin
                    Rec.TestField("Boomi 855 Endpoint URL");
                    SuccessCount := OrderConfPush.PushAllUnsent();
                    Message('%1 order confirmations pushed to Boomi.', SuccessCount);
                end;
            }
            action(SetBuyerPartyId)
            {
                Caption = 'Set SAP Buyer Party ID on Customer';
                ToolTip = 'Writes the SAP Buyer Party ID directly onto the selected customer, bypassing the Customer card.';
                Image = Customer;

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Rec.TestField("EDI Buyer Party Customer No.");
                    Rec.TestField("EDI Buyer Party ID");

                    Customer.Get(Rec."EDI Buyer Party Customer No.");
                    Customer."SAP Buyer Party ID" := Rec."EDI Buyer Party ID";
                    Customer.Modify();

                    Message('SAP Buyer Party ID ''%1'' set on customer %2 - %3.',
                        Rec."EDI Buyer Party ID",
                        Customer."No.",
                        Customer.Name);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
