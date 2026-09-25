table 72002 "Order Status Hybris Buffer"
{
    Caption = 'Order Status Hybris Buffer';
    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Hybris Order No."; Code[35])
        {
            Caption = 'Hybris Order No.';
            DataClassification = ToBeClassified;
        }
        field(4; "SAP/S4 Order No."; Code[35])
        {
            Caption = 'SAP/S4 Order No.';
            DataClassification = ToBeClassified;
        }
        field(5; Status; CODE[20])
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(6; "Sales Tax"; Decimal)
        {
            Caption = 'Sales Tax';
            DataClassification = ToBeClassified;
        }
        field(7; "EDI Hold Reason"; Text[250])
        {
            Caption = 'Hold Reason';
            DataClassification = ToBeClassified;
        }
        field(8; "Last Updated DateTime"; DateTime)
        {
            Caption = 'Last Updated DateTime';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
}
