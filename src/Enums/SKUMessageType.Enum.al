enum 72001 "SKUMessageType"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; ProductPrice)
    {
        Caption = 'Product Price';
    }
    value(2; OrderRequest850)
    {
        Caption = 'Order Request (850)';
    }
    value(3; DeliveryRequest856)
    {
        Caption = 'Delivery Request (856)';
    }
    value(4; OrderChange860)
    {
        Caption = 'Order Change (860)';
    }
    value(5; OrderConfirmation855)
    {
        Caption = 'Order Confirmation (855)';
    }
}
