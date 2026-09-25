table 72008 "ShipStatusUpdToHybrisLineBuff"
{
    Caption = 'Shipment Status Update to Hybris Line Buffer';

    fields
    {
        field(1; "Shipment ID"; Code[20])
        {
            Caption = 'Shipment ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; HybrisOrderLineNo; Code[50])
        {
            Caption = 'Hybris Order And Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "QuantityOrdered"; Decimal)
        {
            Caption = 'Qty Ordered';
            DataClassification = ToBeClassified;
        }
        field(5; "Quantity Shipped"; Decimal)
        {
            Caption = 'Qty Shipped';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Shipment ID", "Line No.")
        {
            Clustered = true;
        }
    }
}
