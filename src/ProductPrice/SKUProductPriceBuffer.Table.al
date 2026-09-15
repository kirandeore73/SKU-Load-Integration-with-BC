table 72010 "SKU Product Price Buffer"
{
    Caption = 'SKU Product Price Buffer';
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
        field(10; "Price List Code"; Code[20])
        {
            Caption = 'Price List Code';
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                UpdateCustomerId();
            end;
        }
        field(21; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
            DataClassification = SystemMetadata;
            TableRelation = Customer.SystemId;

            trigger OnValidate()
            begin
                UpdateCustomerNo();
            end;
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                UpdateItemId();
            end;
        }
        field(31; "Item Id"; Guid)
        {
            Caption = 'Item Id';
            DataClassification = SystemMetadata;
            TableRelation = Item.SystemId;

            trigger OnValidate()
            begin
                UpdateItemNo();
            end;
        }
        field(40; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            // No TableRelation - local currency (e.g. USD) won't exist in Currency table

            trigger OnValidate()
            begin
                UpdateCurrencyId();
            end;
        }
        field(41; "Currency Id"; Guid)
        {
            Caption = 'Currency Id';
            DataClassification = SystemMetadata;
            // No TableRelation - local currency won't have a SystemId

            trigger OnValidate()
            begin
                UpdateCurrencyCode();
            end;
        }
        field(50; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(60; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 2 : 5;
        }
        field(70; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(80; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(90; "SAP Product"; Code[20])
        {
            Caption = 'SAP Product';
        }
        field(100; Processed; Boolean)
        {
            Caption = 'Processed';
        }
        field(110; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(120; "Price List Line No."; Integer)
        {
            Caption = 'Price List Line No.';
            Description = 'The line number of the created Price List Line';
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
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Rec.Id) then
            Rec.Id := CreateGuid();
        Rec."Last Modified Date Time" := CurrentDateTime;
        UpdateReferencedRecordIds();
    end;

    trigger OnModify()
    begin
        Rec."Last Modified Date Time" := CurrentDateTime;
        UpdateReferencedRecordIds();
    end;

    trigger OnRename()
    begin
        Rec."Last Modified Date Time" := CurrentDateTime;
        UpdateReferencedRecordIds();
    end;

    local procedure UpdateCustomerId()
    var
        Customer: Record Customer;
    begin
        if Rec."Customer No." = '' then begin
            Clear(Rec."Customer Id");
            exit;
        end;

        if not Customer.Get(Rec."Customer No.") then
            exit;

        Rec."Customer Id" := Customer.SystemId;
    end;

    local procedure UpdateCustomerNo()
    var
        Customer: Record Customer;
    begin
        if IsNullGuid(Rec."Customer Id") then begin
            Rec."Customer No." := '';
            exit;
        end;

        if not Customer.GetBySystemId(Rec."Customer Id") then
            exit;

        Rec."Customer No." := Customer."No.";
    end;

    local procedure UpdateItemId()
    var
        Item: Record Item;
    begin
        if Rec."Item No." = '' then begin
            Clear(Rec."Item Id");
            exit;
        end;

        if not Item.Get(Rec."Item No.") then
            exit;

        Rec."Item Id" := Item.SystemId;
    end;

    local procedure UpdateItemNo()
    var
        Item: Record Item;
    begin
        if IsNullGuid(Rec."Item Id") then begin
            Rec."Item No." := '';
            exit;
        end;

        if not Item.GetBySystemId(Rec."Item Id") then
            exit;

        Rec."Item No." := Item."No.";
    end;

    local procedure UpdateCurrencyId()
    var
        Currency: Record Currency;
    begin
        if Rec."Currency Code" = '' then begin
            Clear(Rec."Currency Id");
            exit;
        end;

        if not Currency.Get(Rec."Currency Code") then
            exit;

        Rec."Currency Id" := Currency.SystemId;
    end;

    local procedure UpdateCurrencyCode()
    var
        Currency: Record Currency;
    begin
        if IsNullGuid(Rec."Currency Id") then begin
            Rec."Currency Code" := '';
            exit;
        end;

        if not Currency.GetBySystemId(Rec."Currency Id") then
            exit;

        Rec."Currency Code" := Currency.Code;
    end;

    procedure UpdateReferencedRecordIds()
    begin
        UpdateCustomerId();
        UpdateItemId();
        UpdateCurrencyId();
    end;
}
