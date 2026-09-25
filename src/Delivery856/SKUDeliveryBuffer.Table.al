table 72011 "SKU Delivery Buffer"
{
    Caption = 'SKU Delivery Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
        }
        field(10; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(11; "Shipment Id"; Guid)
        {
            Caption = 'Shipment Id';
            DataClassification = SystemMetadata;
            TableRelation = "Sales Shipment Header".SystemId;

            trigger OnValidate()
            begin
                UpdateShipmentNo();
            end;
        }
        field(30; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
        }
        field(40; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(45; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime';
        }
        field(46; "Delivery DateTime"; DateTime)
        {
            Caption = 'Delivery DateTime';
        }
        field(60; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(70; "Sender Internal ID"; Code[20])
        {
            Caption = 'Sender Internal ID';
        }
        field(80; "Recipient Internal ID"; Code[20])
        {
            Caption = 'Recipient Internal ID';
        }
        field(81; "Tax Jurisdiction Code"; Code[20])
        {
            Caption = 'Tax Jurisdiction Code';
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
        key(PK; "Entry No.")
        {
        }
        key(Key2; Id)
        {
            Clustered = true;
        }
        key(Key3; "Shipment No.")
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

    procedure GetShipmentNoForApi(): Code[20]
    var
        HyphenPosition: Integer;
    begin
        HyphenPosition := StrPos("Shipment No.", '-');
        if HyphenPosition > 0 then
            exit(CopyStr("Shipment No.", HyphenPosition + 1));

        exit("Shipment No.");
    end;

    local procedure UpdateShipmentNo()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if IsNullGuid(Rec."Shipment Id") then begin
            Rec."Shipment No." := '';
            exit;
        end;

        if not SalesShipmentHeader.GetBySystemId(Rec."Shipment Id") then
            exit;

        Rec."Shipment No." := SalesShipmentHeader."No.";
    end;

}
