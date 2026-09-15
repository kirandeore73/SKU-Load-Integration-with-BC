table 72012 "SKU Delivery Line Buffer"
{
    Caption = 'SKU Delivery Line Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Delivery Entry No."; Integer)
        {
            Caption = 'Delivery Entry No.';
            TableRelation = "SKU Delivery Buffer"."Entry No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
        }
        field(4; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            DataClassification = SystemMetadata;
            TableRelation = "SKU Delivery Buffer".Id;
        }
        field(10; "Buyer Product ID"; Code[35])
        {
            Caption = 'Buyer Product ID';
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 2 : 5;
        }
        field(40; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(50; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
        }
        field(60; "SAP PO Line No."; Integer)
        {
            Caption = 'SAP PO Line No.';
        }
        field(70; "SAP Sales Order No."; Code[35])
        {
            Caption = 'SAP Sales Order No.';
        }
        field(9630; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Delivery Entry No.", "Line No.")
        {
        }
        key(Key2; Id)
        {
            Clustered = true;
        }
        key(Key3; "Document Id")
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Rec.Id) then
            Rec.Id := CreateGuid();
        Rec."Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        Rec."Last Modified Date Time" := CurrentDateTime;
    end;

}
