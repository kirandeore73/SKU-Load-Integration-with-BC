tableextension 72009 "SKUSalesInvHeader" extends "Sales Invoice Header"
{
    fields
    {
        field(72000; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(72002; "SAP Sender Internal ID"; Code[20])
        {
            Caption = 'SAP Sender Internal ID';
            DataClassification = CustomerContent;
        }
        field(72071; "SAP Recipient Internal ID"; Code[20])
        {
            Caption = 'SAP Recipient Internal ID';
            DataClassification = CustomerContent;
        }
        field(72072; "EDI Tax Jurisdiction Code"; Code[20])
        {
            Caption = 'EDI Tax Jurisdiction Code';
            DataClassification = CustomerContent;
        }
        field(72070; "Created From EDI 850"; Boolean)
        {
            Caption = 'Created From EDI 850';
            DataClassification = CustomerContent;
        }

    }
}