tableextension 72008 SalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        // for PurchaseOrderItemID         store for reference
        field(72001; "SAP PO Line No."; Integer)
        {
            Caption = 'SAP PO Line No.';
            DataClassification = CustomerContent;
        }
    }
}