page 72014 "SKU Delivery Lines API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Delivery Line';
    EntitySetCaption = 'Delivery Lines';
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    EntityName = 'deliveryLine';
    EntitySetName = 'deliveryLines';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "SKU Delivery Line Buffer";
    Extensible = false;
    Permissions = tabledata "SKU Delivery Line Buffer" = RIMD;
    AboutText = 'Outbound delivery line items (ASN 856). Read-only API - data is populated from BC when shipments are posted.';

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                }
                field(deliveryEntryNo; Rec."Delivery Entry No.")
                {
                    Caption = 'Delivery Entry No.';
                }
                field(buyerProductId; Rec."Buyer Product ID")
                {
                    Caption = 'Buyer Product ID';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    decimalPlaces = 2 : 5;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(sapPurchaseOrderNo; Rec."SAP Purchase Order No.")
                {
                    Caption = 'SAP Purchase Order No.';
                }
                field(sapPoLineNo; Rec."SAP PO Line No.")
                {
                    Caption = 'SAP PO Line No.';
                }
                field(sapSalesOrderNo; Rec."SAP Sales Order No.")
                {
                    Caption = 'SAP Sales Order No.';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                }
            }
        }
    }
}
