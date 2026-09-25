pageextension 72002 "SKU Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Credit Hold"; Rec."Credit Hold")
            {
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies if the order is on credit hold for Hybris order status reporting.';
            }
            field("Order Cancelled"; Rec."Order Cancelled")
            {
                visible = false;
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies if the order is cancelled for Hybris order status reporting.';
            }
            field("EDI Hold Reason"; Rec."EDI Hold Reason")
            {
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies the reason for the EDI hold for Hybris order status reporting.';
            }
            field("Credit Hold Date"; Rec."Credit Hold Date")
            {
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies the date the order was put on credit hold.';
            }
            field("Credit Hold User"; Rec."Credit Hold User")
            {
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies the user who put the order on credit hold.';
            }
            field("EDI Web Order No."; Rec."EDI Web Order No.")
            {
                visible = false;
                ApplicationArea = All;
                Editable = CanEditHybrisStatusFields;
                ToolTip = 'Specifies the EDI web order number for Hybris order status reporting.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateHybrisStatusFieldEditability();
    end;

    local procedure UpdateHybrisStatusFieldEditability()
    var
        Customer: Record Customer;
    begin
        CanEditHybrisStatusFields := false;
        if not (Rec."Sell-to Customer No." in ['1710', '1711']) then
            exit;

        if Customer.Get(Rec."Sell-to Customer No.") then
            CanEditHybrisStatusFields := Customer."Auto Sales Order";
    end;

    var
        CanEditHybrisStatusFields: Boolean;
}
