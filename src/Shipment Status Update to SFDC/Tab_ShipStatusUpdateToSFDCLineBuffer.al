table 72004 "ShipStatusUpdateToSFDCLineBuff"
{
    Caption = 'Shipment Status Update to SFDC Line Buffer';

    fields
    {
        field(1; "Shipment ID"; code[20])
        {
            Caption = 'Shipment ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'CoLine';
            DataClassification = ToBeClassified;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'Item';
            DataClassification = ToBeClassified;
        }
        field(4; "Quantity"; Decimal)
        {
            Caption = 'QtyShipped';
            DataClassification = ToBeClassified;
        }
        field(5; "Shipment Total Charges"; Decimal)
        {
            Caption = 'ShipmentTotalCharges';
            DataClassification = ToBeClassified;
            decimalPlaces = 5;
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
