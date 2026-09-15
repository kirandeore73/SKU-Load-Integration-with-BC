table 72000 "SKUIntegrationLog"
{
    Caption = 'SKU Integration Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Message Type"; Enum "SKUMessageType")
        {
            Caption = 'Message Type';
        }
        field(3; Direction; Enum "SKUDirection")
        {
            Caption = 'Direction';
        }
        field(4; FileName; Text[250])
        {
            Caption = 'File Name';
        }
        field(5; CreatedDateTime; DateTime)
        {
            Caption = 'Created DateTime';
        }
        field(6; Success; Boolean)
        {
            Caption = 'Success';
        }
        field(7; "Message"; Text[2048])
        {
            Caption = 'Message';
        }
        field(8; "Related Document No."; Code[20])
        {
            Caption = 'Related Document No.';
        }
        field(9; Document; Blob)
        {
            Caption = 'Document';
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

    procedure DownloadDocument()
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        FileNameVar: Text;
    begin
        if FileName = '' then
            exit;

        Rec.CalcFields(Document);
        if not Rec.Document.HasValue() then
            exit;

        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        Rec.Document.CreateInStream(InStr, TextEncoding::UTF8);
        CopyStream(OutStr, InStr);

        FileNameVar := FileName;
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        DownloadFromStream(InStr, '', '', '', FileNameVar);
    end;
}
