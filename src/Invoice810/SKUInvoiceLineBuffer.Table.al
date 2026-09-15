table 72020 "SKU Invoice Line Buffer"
{
    Caption = 'SKU Invoice Line Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Invoice Entry No."; Integer) { TableRelation = "SKU Invoice Buffer"."Entry No."; }
        // field(2; "Line No."; Integer) { }
        field(3; Id; Guid) { DataClassification = SystemMetadata; }
        field(4; "Document Id"; Guid) { DataClassification = SystemMetadata; TableRelation = "SKU Invoice Buffer".Id; }
        //    field(10; "Item No."; Code[20]) { TableRelation = Item."No."; }
        field(10; "Currency Code"; Code[10]) { }
        field(20; "Supplier Invoice Item ID"; Integer) { }
        field(30; "Invoice Item Type Code"; Code[10]) { }
        field(40; "Net Amount"; Decimal) { DecimalPlaces = 0 : 5; }
        field(50; Quantity; Decimal) { DecimalPlaces = 0 : 5; }
        field(60; "Unit of Measure Code"; Code[10]) { }
        field(70; "Purchase Order ID"; Code[35]) { }
        field(80; "Purchase Order Item ID"; Integer) { }
        field(90; "Supplier Tax Type Code"; Code[20]) { }
        field(100; "Tax Percentage"; Decimal) { DecimalPlaces = 0 : 5; }
        field(110; "Tax Jurisdiction"; Code[20]) { }
        field(120; "Tax Determination Date"; Date) { }
        field(9630; "Last Modified Date Time"; DateTime) { Editable = false; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Invoice Entry No.", "Supplier Invoice Item ID") { Clustered = true; }
        key(Key2; Id) { }
        key(Key3; "Document Id") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Id) then
            Id := CreateGuid();
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;
}