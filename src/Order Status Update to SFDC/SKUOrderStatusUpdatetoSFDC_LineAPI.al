namespace Microsoft.API.V2;
page 72027 "OrderStatusUpdtoSFDCLine"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Order Status Update to SFDC Line';
    EntitySetCaption = 'Order Status Update to SFDC Lines';
    EntityName = 'orderStatusUpdatetoSFDCLine';
    EntitySetName = 'orderStatusUpdatetoSFDCLines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "OrderStatusUpdToSFDCLineBuff";
    Extensible = false;
    Permissions = tabledata "OrderStatusUpdToSFDCLineBuff" = RIMD;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                }
                field(coNum; Rec."CO Number")
                {
                    Caption = 'CO Number';
                }
                field(bcSalesOrderNo; Rec."BC Sales Order No.")
                {
                    Caption = 'BC Sales Order No.';
                }
                field(coLine; Rec."CO Line")
                {
                    Caption = 'CO Line';
                }
                field(bcLineNo; Rec."BC Line No.")
                {
                    Caption = 'BC Line No.';
                }
                field(coRelease; Rec."CO Release")
                {
                    Caption = 'CO Release';
                }
                field(item; Rec.Item)
                {
                    Caption = 'Item';
                }
                field(qtyOrdered; Rec."Qty Ordered")
                {
                    Caption = 'Qty Ordered';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(coitemStat; Rec."Coitem Stat")
                {
                    Caption = 'Coitem Stat';
                }
                field(shipSite; Rec."Ship Site")
                {
                    Caption = 'Ship Site';
                }
                field(price; Rec.Price)
                {
                    Caption = 'Price';
                }
                field(ufHoldReason; Rec."Uf Hold Reason")
                {
                    Caption = 'Uf Hold Reason';
                }
                field(ufCalcDueDate; Rec."Uf Calc Due Date")
                {
                    Caption = 'Uf Calc Due Date';
                }
                field(qtyPacked; Rec."Qty Packed")
                {
                    Caption = 'Qty Packed';
                }
                field(qtyShipped; Rec."Qty Shipped")
                {
                    Caption = 'Qty Shipped';
                }
                field(cancelStatus; Rec."Cancel Status")
                {
                    Caption = 'Cancel Status';
                }
                field(smartPartNumber; Rec."Smart Part Number")
                {
                    Caption = 'Smart Part Number';
                }
                field(ufLongDescription; Rec."Uf Long Description")
                {
                    Caption = 'Uf Long Description';
                }
                field(lineNetPrice; Rec."Line Net Price")
                {
                    Caption = 'Line Net Price';
                }
            }
        }
    }
}
