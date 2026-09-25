table 72003 "ShipStatusUpdateToSFDCHdrBuff"
{
    Caption = 'Shipment Status Update to SFDC Header Buffer';

    fields
    {
        field(1; "Shipment ID"; code[20])
        {
            Caption = 'ShipmentID';
            DataClassification = ToBeClassified;
        }
        field(2; "Shipment Status"; Code[10])
        {
            Caption = 'ShipmentStatus';
            DataClassification = ToBeClassified;
        }
        field(3; "Shipment Date"; DateTime)
        {
            Caption = 'ShipDate';
            DataClassification = ToBeClassified;
        }
        field(4; "Package Tracking No."; text[50])
        {
            Caption = 'Package Tracking No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Shipment Method Code"; Code[10])
        {
            Caption = 'ShipVia';
            DataClassification = ToBeClassified;
        }
        field(6; "Order No."; Code[20])
        {
            Caption = 'CoNum';
            DataClassification = ToBeClassified;
        }
        field(7; "Total Charge"; Decimal)
        {
            Caption = 'TotalCharge';
            DataClassification = ToBeClassified;
            decimalPlaces = 5;
        }
        field(8; "Last Updated DateTime"; DateTime)
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
