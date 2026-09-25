namespace Microsoft.API.V2;
page 72006 "ShipmentStatusUpdateLineSFDC"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Shipment Status Update Line SFDC';
    EntitySetCaption = 'Shipment Status Update Line SFDCs';

    EntityName = 'ShipmentStatusUpdateLineSfdc';
    EntitySetName = 'shipmentStatusUpdateLineSFDC';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "ShipStatusUpdateToSFDCLineBuff";
    Extensible = false;
    Permissions = tabledata "ShipStatusUpdateToSFDCLineBuff" = RIMD;
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
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(itemNo; Rec."No.")
                {
                    Caption = 'Item No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'QuantityShipped';
                }
                field(totalCharges; Rec."Shipment Total Charges")
                {
                    Caption = 'Total Charges';
                }
            }
        }
    }
}
