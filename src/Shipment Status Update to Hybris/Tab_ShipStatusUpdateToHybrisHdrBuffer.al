table 72007 "ShipStatusUpdToHybrisHdrBuff"
{
    Caption = 'Shipment Status Update to Hybris Header Buffer';

    fields
    {
        field(1; "Shipment ID"; Code[20])
        {
            Caption = 'Shipment ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Shipment Status"; Text[30])
        {
            Caption = 'Shipment Status';
            DataClassification = ToBeClassified;
        }
        field(3; "Hybris Order No."; Code[35])
        {
            Caption = 'ref_num';
            DataClassification = ToBeClassified;
        }
        field(4; "Hybris Address ID"; Code[20])
        {
            Caption = 'Hybris Address ID';
            DataClassification = ToBeClassified;
        }
        field(5; "Warehouse Code"; Code[20])
        {
            Caption = 'Warehouse Code';
            DataClassification = ToBeClassified;
        }
        field(6; "Tracking Number"; Text[50])
        {
            Caption = 'Tracking Number';
            DataClassification = ToBeClassified;
        }
        field(7; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = ToBeClassified;
        }
        field(8; "Ship Date"; Text[10])
        {
            Caption = 'Ship Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Last Updated DateTime"; DateTime)
        {
            Caption = 'Last Updated DateTime';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Shipment ID")
        {
            Clustered = true;
        }
    }
}
