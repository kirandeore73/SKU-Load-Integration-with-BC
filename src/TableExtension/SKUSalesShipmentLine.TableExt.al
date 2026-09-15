tableextension 72003 "SKUSalesShptLine" extends "Sales Shipment Line"
{
    fields
    {
        field(72001; "SAP PO Line No."; Integer)
        {
            Caption = 'SAP PO Line No.';
            DataClassification = CustomerContent;
        }
        field(72003; "SAP Sales Order No."; Code[35])
        {
            Caption = 'SAP Sales Order No.';
            DataClassification = CustomerContent;
        }
    }
}
