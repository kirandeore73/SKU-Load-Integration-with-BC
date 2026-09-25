table 72030 "OrderStatusUpdToSFDCLineBuff"
{
    Caption = 'Order Status Update to SFDC Line Buffer';

    fields
    {
        field(1; "CO Number"; Code[35])
        {
            Caption = 'CoNum';
            DataClassification = ToBeClassified;
        }
        field(2; "CO Line"; Integer)
        {
            Caption = 'CoLine';
            DataClassification = ToBeClassified;
        }
        field(3; "CO Release"; Integer)
        {
            Caption = 'CoRelease';
            DataClassification = ToBeClassified;
        }
        field(4; "Item"; Code[20])
        {
            Caption = 'Item';
            DataClassification = ToBeClassified;
        }
        field(5; "Qty Ordered"; Decimal)
        {
            Caption = 'QtyOrdered';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(6; "Due Date"; Text[19])
        {
            Caption = 'DueDate';
            DataClassification = ToBeClassified;
        }
        field(7; "Coitem Stat"; Code[10])
        {
            Caption = 'CoitemStat';
            DataClassification = ToBeClassified;
        }
        field(8; "Ship Site"; Code[10])
        {
            Caption = 'ShipSite';
            DataClassification = ToBeClassified;
        }
        field(9; "Price"; Decimal)
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(10; "Uf Hold Reason"; Text[100])
        {
            Caption = 'UfHoldReason';
            DataClassification = ToBeClassified;
        }
        field(11; "Uf Calc Due Date"; Text[19])
        {
            Caption = 'UfCalcDueDate';
            DataClassification = ToBeClassified;
        }
        field(12; "Qty Packed"; Decimal)
        {
            Caption = 'QtyPacked';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(13; "Qty Shipped"; Decimal)
        {
            Caption = 'QtyShipped';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(14; "Cancel Status"; Text[30])
        {
            Caption = 'CancelStatus';
            DataClassification = ToBeClassified;
        }
        field(15; "Smart Part Number"; Text[50])
        {
            Caption = 'SmartPartNumber';
            DataClassification = ToBeClassified;
        }
        field(16; "Uf Long Description"; Text[250])
        {
            Caption = 'UfLongDescription';
            DataClassification = ToBeClassified;
        }
        field(17; "Line Net Price"; Decimal)
        {
            Caption = 'LineNetPrice';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(18; "BC Sales Order No."; Code[20])
        {
            Caption = 'BC Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(19; "BC Line No."; Integer)
        {
            Caption = 'BC Line No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "CO Number", "CO Line")
        {
            Clustered = true;
        }
    }
}
