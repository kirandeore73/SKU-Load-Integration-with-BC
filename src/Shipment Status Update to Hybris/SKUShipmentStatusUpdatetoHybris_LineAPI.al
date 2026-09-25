namespace Microsoft.API.V2;
page 72019 "ShipStatusUpdToHybrisLine"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Shipment Status Update to Hybris Line';
    EntitySetCaption = 'Shipment Status Update to Hybris Line';
    EntityName = 'ShipmentStatusUpdateToHybrisLine';
    EntitySetName = 'shipmentStatusUpdateToHybrisLine';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "ShipStatusUpdToHybrisLineBuff";
    Extensible = false;
    Permissions = tabledata "ShipStatusUpdToHybrisLineBuff" = RIMD;
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
                field(shipmentID; Rec."Shipment ID")
                {
                    Caption = 'Shipment ID';
                }
                field(hybrisOrderLineNo; Rec.HybrisOrderLineNo)
                {
                    Caption = 'Hybris Order And Line No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(QuantityOrdered; Rec."QuantityOrdered")
                {
                    Caption = 'Qty Ordered';
                }
                field(quantityShipped; Rec."Quantity Shipped")
                {
                    Caption = 'Qty Shipped';
                }
            }
        }
    }
}
