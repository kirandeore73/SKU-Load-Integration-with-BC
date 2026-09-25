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
        // for salesorderdata - AddressId : maaped for Ship to code but ship to code will be our BC default code along with this unique field this will be unique identifaction of ship to address of SAP for each order
        field(72054; "EDI Address Id"; Code[50])
        {
            Caption = 'EDI Ship-to Address Id';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - WebOrderNo
        field(72055; "EDI Web Order No."; Code[35])
        {
            Caption = 'EDI Web Order No.';
            DataClassification = CustomerContent;
        }
    }
}
