pageextension 72000 CustomerCard extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("SAP Buyer Party ID"; Rec."SAP Buyer Party ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the SAP Buyer Party ID used to resolve the sell-to customer on inbound EDI 850.';
            }
            field("Auto Sales Order"; Rec."Auto Sales Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether inbound EDI 850 messages can create sales orders for this customer.';
            }
            field("SAP Recipient Internal ID"; Rec."SAP Recipient Internal ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the SAP recipient internal ID used for outbound EDI messages for this customer.';
            }
        }
    }
}