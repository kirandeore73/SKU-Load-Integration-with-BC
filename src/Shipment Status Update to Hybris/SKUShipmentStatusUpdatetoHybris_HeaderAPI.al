page 72018 "ShipStatusUpdToHybrisHdr"
{
    ApplicationArea = All;
    Caption = 'Shipment Status Update to Hybris Hdr API';
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Shipment Status Update to Hybris';
    EntitySetCaption = 'Shipment Status Update to Hybris';
    EntityName = 'ShipmentStatusUpdatetoHybrisHdr';
    EntitySetName = 'ShipmentStatusUpdatetoHybrisHdr';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "ShipStatusUpdToHybrisHdrBuff";
    Extensible = false;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    Permissions = tabledata "ShipStatusUpdToHybrisHdrBuff" = RIMD;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(systemId; Rec."SystemId")
                {
                    Caption = 'System ID';
                }
                field(shipmentNo; Rec."Shipment ID")
                {
                    Caption = 'Shipment No.';
                }
                field(status; Rec."Shipment Status")
                {
                    Caption = 'Status';
                }
                field(hybrisOrderNo; Rec."Hybris Order No.")
                {
                    Caption = 'ref_num';
                }
                field(hybrisAddressId; Rec."Hybris Address ID")
                {
                    Caption = 'Hybris Address ID';
                }
                field(warehouseCode; Rec."Warehouse Code")
                {
                    Caption = 'Warehouse Code';
                }
                field(trackingNumber; Rec."Tracking Number")
                {
                    Caption = 'Tracking Number';
                }
                field(shipCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment_Code';
                }
                field(shipDate; Rec."Ship Date")
                {
                    Caption = 'Ship Date';
                }
            }
        }
    }
}
