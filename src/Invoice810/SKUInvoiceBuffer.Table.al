table 72019 "SKU Invoice Buffer"
{
    Caption = 'SKU Invoice Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; Id; Guid) { DataClassification = SystemMetadata; }
        field(10; "Invoice No."; Code[20]) { TableRelation = "Sales Invoice Header"."No."; }
        field(11; "Invoice Id"; Guid) { DataClassification = SystemMetadata; }
        // field(20; "Customer No."; Code[20]) { TableRelation = Customer."No."; }
        // field(21; "Customer Id"; Guid) { DataClassification = SystemMetadata; }
        // field(22; "Bill-to Address Name"; Text[100]) { }
        field(23; "Supplier Invoice Type Code"; Code[10]) { }
        field(24; "BuyerPartyID_BillFrom"; Code[20]) { }
        field(25; "BuyerPartyID_BillTo"; Code[20]) { }
        field(26; "Sender Internal ID"; Code[20]) { }
        field(27; "Recipient Internal ID"; Code[20]) { }
        field(28; "Creation DateTime"; DateTime) { }
        field(30; "Posting Date"; Date) { }
        field(31; "SupplierPartyID"; Code[20]) { }
        field(32; "Address Name"; Text[100]) { }
        field(40; "Currency Code"; Code[10]) { }
        field(50; "Amount Including VAT"; Decimal) { DecimalPlaces = 0 : 5; }
        field(60; "Sell-to Country/Region Code"; Code[10]) { }
        // field(61; "Tax Country"; Code[10]) { }
        field(9630; "Last Modified Date Time"; DateTime) { Editable = false; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Entry No.") { }
        key(Key2; Id) { Clustered = true; }
        key(Key3; "Invoice No.") { }
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

    trigger OnDelete()
    var
        InvoiceLineBuffer: Record "SKU Invoice Line Buffer";
    begin
        InvoiceLineBuffer.SetRange("Document Id", Id);
        InvoiceLineBuffer.DeleteAll(true);
    end;
}