page 72005 "ShipmentStatusUpdatetoSFDCHdr"
{
    ApplicationArea = All;
    Caption = 'Shipment Status Update to SFDC';
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Shipment Status Update to SFDC';
    EntitySetCaption = 'Shipment Status Update to SFDC';
    EntityName = 'ShipmentStatusUpdatetoSFDC';
    EntitySetName = 'ShipmentStatusUpdatetoSFDC';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "ShipStatusUpdateToSFDCHdrBuff";
    Extensible = false;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    Permissions = tabledata "ShipStatusUpdateToSFDCHdrBuff" = RIMD;

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
                field(shipmentDate; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field(packageTrackingNo; Rec."Package Tracking No.")
                {
                    Caption = 'Package Tracking No.';
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'S4/Hybris Sales Order No.';
                }
                field(totalCharge; Rec."Total Charge")
                {
                    Caption = 'Total Charge';
                }
                part(ShipmentLines; ShipmentStatusUpdateLineSFDC)
                {
                    Caption = 'Lines';
                    EntityName = 'ShipmentStatusUpdateLineSfdc';
                    EntitySetName = 'shipmentStatusUpdateLineSFDC';
                    SubPageLink = "Shipment ID" = field("Shipment ID");
                }
            }
        }
    }
}
