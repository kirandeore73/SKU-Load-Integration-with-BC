page 72016 "SKU Order Confirmations API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'SKU Order Confirmation';
    EntitySetCaption = 'SKU Order Confirmations';
    EntityName = 'skuOrderConfirmation';
    EntitySetName = 'skuOrderConfirmations';
    PageType = API;
    SourceTable = "SKU Order Conf Buffer";
    ODataKeyFields = Id;
    DelayedInsert = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    Permissions = tabledata "SKU Order Conf Buffer" = RIMD,
                  tabledata "SKU Order Conf Line Buffer" = RIMD,
                  tabledata "Sales Header" = R,
                  tabledata "Sales Line" = R;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    Editable = false;
                }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(orderId; Rec."Order Id")
                {
                    Caption = 'Order Id';
                }
                field(sapPurchaseOrderNo; Rec."SAP Purchase Order No.")
                {
                    Caption = 'SAP Purchase Order No.';
                }
                field(sapSalesOrderNo; Rec."SAP Sales Order No.")
                {
                    Caption = 'SAP Sales Order No.';
                }
                field(creationDateTime; Rec."Creation DateTime")
                {
                    Caption = 'Creation DateTime';
                }
                field(senderInternalId; Rec."Sender Internal ID")
                {
                    Caption = 'Sender Internal ID';
                }
                field(recipientInternalId; Rec."Recipient Internal ID")
                {
                    Caption = 'Recipient Internal ID';
                }
                field(sentToSap; Rec."Sent to SAP")
                {
                    Caption = 'Sent to SAP';
                    Editable = false;
                }
                field(sentDateTime; Rec."Sent DateTime")
                {
                    Caption = 'Sent DateTime';
                    Editable = false;
                }
                field(errorMessage; Rec."Error Message")
                {
                    Caption = 'Error Message';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
                part(orderConfirmationLines; "SKU Order Conf Lines API")
                {
                    Caption = 'Lines';
                    EntityName = 'skuOrderConfirmationLine';
                    EntitySetName = 'skuOrderConfirmationLines';
                    SubPageLink = "Document Id" = field(Id);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkAsSent)
            {
                Caption = 'Mark as Sent';

                trigger OnAction()
                begin
                    Rec."Sent to SAP" := true;
                    Rec."Sent DateTime" := CurrentDateTime;
                    Rec."Error Message" := '';
                    Rec.Modify(true);
                end;
            }
            action(MarkAsError)
            {
                Caption = 'Mark as Error';

                trigger OnAction()
                begin
                    Rec."Sent to SAP" := false;
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
        TempFieldBuffer: Record "Field Buffer" temporary;
    begin
        OrderConfBufferMgt.PropagateOnInsert(Rec, TempFieldBuffer);
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    var
        OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
        TempFieldBuffer: Record "Field Buffer" temporary;
    begin
        OrderConfBufferMgt.PropagateOnModify(Rec, TempFieldBuffer);
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
    begin
        OrderConfBufferMgt.PropagateOnDelete(Rec);
        exit(true);
    end;
}
