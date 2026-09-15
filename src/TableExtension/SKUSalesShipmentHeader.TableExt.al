tableextension 72004 "SKUSalesShptHeader" extends "Sales Shipment Header"
{
    fields
    {
        field(72000; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(72001; "SAP Sales Order No."; Code[35])
        {
            Caption = 'SAP Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(72002; "SAP Sender Internal ID"; Code[20])
        {
            Caption = 'SAP Sender Internal ID';
            DataClassification = CustomerContent;
        }
        field(72003; "SAP Recipient Internal ID"; Code[20])
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
