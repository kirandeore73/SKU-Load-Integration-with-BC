page 72000 "SKUIntegrationLog"
{
    Caption = 'SKU Integration Log';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "SKUIntegrationLog";
    UsageCategory = History;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the sequential log entry number.';
                }
                field(Direction; Rec.Direction)
                {
                    ToolTip = 'Specifies whether the message was inbound or outbound.';
                }
                field("Message Type"; Rec."Message Type")
                {
                    ToolTip = 'Specifies the type of EDI message processed.';
                }
                field(FileName; Rec.FileName)
                {
                    ToolTip = 'Specifies the file name. Click to download the stored document.';

                    trigger OnDrillDown()
                    begin
                        Rec.DownloadDocument();
                    end;
                }
                field(CreatedDateTime; Rec.CreatedDateTime)
                {
                    ToolTip = 'Specifies the date and time the entry was created.';
                }
                field(Success; Rec.Success)
                {
                    ToolTip = 'Specifies whether processing completed successfully.';
                    StyleExpr = StyleTxt;
                }
                field("Related Document No."; Rec."Related Document No.")
                {
                    ToolTip = 'Specifies the related Business Central document, when applicable.';
                }
                field("Message"; Rec."Message")
                {
                    ToolTip = 'Specifies the result or error message from processing.';
                }
            }
        }
    }

    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Success then
            StyleTxt := 'Favorable'
        else
            StyleTxt := 'Unfavorable';
    end;
}
