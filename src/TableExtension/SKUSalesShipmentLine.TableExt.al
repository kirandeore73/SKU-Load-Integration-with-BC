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
        // EDI 850 OrderItem / LineSpecialInstructions
        // SAP sales order line sequence (SalesOrderItemID), not the BC item number.
        //for SalesOrderItemID : BC line no.
        field(72011; "SAP Sales Order Item ID"; integer)
        {
            Caption = 'SAP Sales Order Item ID';
            DataClassification = CustomerContent;
        }
        field(72012; "EDI Quantity Ordered"; Decimal)
        {
            Caption = 'EDI Quantity Ordered';
            DataClassification = CustomerContent;
        }
    }
}
