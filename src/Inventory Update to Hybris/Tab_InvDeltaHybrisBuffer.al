table 72028 "InvDeltaHybrisBuff"
{
    Caption = 'Inventory Delta Hybris Buffer';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(2; "Available On Hand Qty"; Decimal)
        {
            Caption = 'Available On Hand Qty';
            DataClassification = ToBeClassified;
        }
        field(3; Warehouse; Code[20])
        {
            Caption = 'Warehouse';
            DataClassification = ToBeClassified;
        }
        field(4; "IN Stock Status"; Text[30])
        {
            Caption = 'IN Stock Status';
            DataClassification = ToBeClassified;
        }
        field(5; "Max Pre Order"; Integer)
        {
            Caption = 'Max Pre-Order';
            DataClassification = ToBeClassified;
        }
        field(6; "Max Stock Level Hist Cnt"; Integer)
        {
            Caption = 'Max Stock Level History Count';
            DataClassification = ToBeClassified;
        }
        field(7; Overselling; Integer)
        {
            Caption = 'Overselling';
            DataClassification = ToBeClassified;
        }
        field(8; "Pre Order"; Integer)
        {
            Caption = 'Pre Order';
            DataClassification = ToBeClassified;
        }
        field(9; Reserved; Integer)
        {
            Caption = 'Reserved';
            DataClassification = ToBeClassified;
        }
        field(10; "Last Updated DateTime"; DateTime)
        {
            Caption = 'Last Updated DateTime';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }
}
