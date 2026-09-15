table 72001 "SKUIntegrationSetup"
{
    Caption = 'SKU Integration Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(7; SenderInternalID; Code[20])
        {
            Caption = 'Sender Internal ID';
        }
        field(8; RecipientInternalID; Code[20])
        {
            Caption = 'Recipient Internal ID';
        }
        field(10; "Boomi 856 Endpoint URL"; Text[250])
        {
            Caption = 'Boomi 856 Endpoint URL';
            ExtendedDatatype = URL;
        }
        field(11; "Boomi Auth Type"; Option)
        {
            Caption = 'Boomi Auth Type';
            OptionCaption = 'Basic Auth,OAuth 2.0';
            OptionMembers = BasicAuth,OAuth;
        }
        field(12; "Boomi Username"; Text[100])
        {
            Caption = 'Boomi Username';
        }
        field(13; "Boomi Password"; Text[250])
        {
            Caption = 'Boomi Password';
            ExtendedDatatype = Masked;
        }
        field(14; "Boomi OAuth Token URL"; Text[250])
        {
            Caption = 'Boomi OAuth Token URL';
            ExtendedDatatype = URL;
        }
        field(15; "Boomi Client ID"; Text[100])
        {
            Caption = 'Boomi Client ID';
        }
        field(16; "Boomi Client Secret"; Text[250])
        {
            Caption = 'Boomi Client Secret';
            ExtendedDatatype = Masked;
        }
        field(17; "Boomi OAuth Scope"; Text[100])
        {
            Caption = 'Boomi OAuth Scope';
        }
        field(21; "Boomi 855 Endpoint URL"; Text[250])
        {
            Caption = 'Boomi 855 Endpoint URL';
            ExtendedDatatype = URL;
        }
        field(23; "Boomi 810 Endpoint URL"; Text[250])
        {
            Caption = 'Boomi 810 Endpoint URL';
            ExtendedDatatype = URL;
        }
        field(24; "Test 856 Shipment No."; Code[20])
        {
            Caption = 'Test 856 Shipment No.';
        }
        field(25; "Test 855 Order No."; Code[20])
        {
            Caption = 'Test 855 Order No.';
        }
        field(26; "Test 850 Purchase Order ID"; Code[35])
        {
            Caption = 'Test 850 Purchase Order ID';
        }
        field(27; "EDI Buyer Party Customer No."; Code[20])
        {
            Caption = 'EDI Buyer Party Customer No.';
            TableRelation = Customer."No.";
        }
        field(28; "EDI Buyer Party ID"; Code[20])
        {
            Caption = 'EDI Buyer Party ID';
        }
        field(29; "Test 810 Invoice No."; Code[20])
        {
            Caption = 'Test 810 Invoice No.';
            TableRelation = "Sales Invoice Header"."No.";
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if Rec.Get() then begin
            if Rec.PrimaryKey = '' then
                Rec.Rename('DEFAULT');
            exit;
        end;

        Rec.Reset();
        if Rec.Get('DEFAULT') then
            exit;

        Rec.Init();
        Rec.PrimaryKey := 'DEFAULT';
        Rec.Insert();
    end;

    procedure GetSetupChecked()
    begin
        Rec.GetSetup();
    end;
}
