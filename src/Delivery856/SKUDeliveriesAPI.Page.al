page 72013 "SKU Deliveries API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Delivery';
    EntitySetCaption = 'Deliveries';
    ChangeTrackingAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    EntityName = 'delivery';
    EntitySetName = 'deliveries';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "SKU Delivery Buffer";
    Extensible = false;
    Permissions = tabledata "SKU Delivery Buffer" = RIMD,
                  tabledata "SKU Delivery Line Buffer" = RIMD;
    AboutText = 'Outbound delivery/shipment documents (ASN 856) for SAP integration. Read-only API - data is populated from BC when shipments are posted.';

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
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                // field(shipmentId; Rec."Shipment Id")
                // {
                //     Caption = 'Shipment Id';
                // }
                field(shipmentCreatedDateTime; Rec."Creation DateTime")
                {
                    Caption = 'Shipment Created DateTime';
                }
                field(senderInternalId; Rec."Sender Internal ID")
                {
                    Caption = 'Sender Internal ID';
                }
                field(recipientInternalId; Rec."Recipient Internal ID")
                {
                    Caption = 'Recipient Internal ID';
                }
                field(taxJurisdictionCode; Rec."Tax Jurisdiction Code")
                {
                    Caption = 'Tax Jurisdiction Code';
                }
                field(shipmentNo; Rec.GetShipmentNoForApi())
                {
                    Caption = 'Shipment No.';
                }
                field(sapPurchaseOrderNo; Rec."SAP Purchase Order No.")
                {
                    Caption = 'SAP Purchase Order No.';
                }
                field(deliveryDateTime; Rec."Delivery DateTime")
                {
                    Caption = 'Delivery DateTime';
                }
                // field(postingDate; Rec."Posting Date")
                // {
                //     Caption = 'Posting Date';
                // }
                field(packageTrackingNo; Rec."Package Tracking No.")
                {
                    Caption = 'Package Tracking No.';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                }
                part(deliveryLines; "SKU Delivery Lines API")
                {
                    Caption = 'Lines';
                    EntityName = 'deliveryLine';
                    EntitySetName = 'deliveryLines';
                    SubPageLink = "Document Id" = field(Id);
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
    begin
        DeliveryBufferMgt.PropagateOnDelete(Rec);
        exit(true);
    end;
}
