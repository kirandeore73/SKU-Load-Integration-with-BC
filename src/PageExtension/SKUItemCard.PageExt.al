pageextension 72001 "SKU Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Buyer Product ID"; Rec."Buyer Product ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the external Buyer Product ID used to resolve inbound EDI 850 order lines.';
            }
        }
    }
}