page 72017 "SKU Order Conf Lines API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'SKU Order Confirmation Line';
    EntitySetCaption = 'SKU Order Confirmation Lines';
    EntityName = 'skuOrderConfirmationLine';
    EntitySetName = 'skuOrderConfirmationLines';
    PageType = API;
    SourceTable = "SKU Order Conf Line Buffer";
    ODataKeyFields = Id;
    DelayedInsert = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "SKU Order Conf Line Buffer" = RIMD;

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
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(purchaseOrderItemId; Rec."Purchase Order Item ID")
                {
                    Caption = 'Purchase Order Item ID';
                }
                field(sapProductId; Rec."SAP Product ID")
                {
                    Caption = 'SAP Product ID';
                }
                field(requestedQuantity; Rec.Quantity)
                {
                    Caption = 'Requested Quantity';
                }
                field(unitCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Code';
                }
                field(purchaseOrderScheduleLine; Rec."Purchase Order Schedule Line")
                {
                    Caption = 'Purchase Order Schedule Line';
                }
                field(promisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    Caption = 'Requested Delivery Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Confirmed Delivery Date';
                }
                field(scheduleLineOrderQuantity; Rec."Schedule Line Order Quantity")
                {
                    Caption = 'Schedule Line Order Quantity';
                }
                field(confirmedOrderQuantity; Rec."Confirmed Order Quantity")
                {
                    Caption = 'Confirmed Qty by Material Available Check';
                }
                field(scheduleLineOrderQuantityUOM; Rec."Confirmed Order Quantity UOM")
                {
                    Caption = 'Schedule Line Order Quantity UOM';
                }
                field(confirmedOrderQuantityUOM; Rec."Confirmed Order Quantity UOM")
                {
                    Caption = 'Confirmed Order Quantity UOM';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
            }
        }
    }
}
