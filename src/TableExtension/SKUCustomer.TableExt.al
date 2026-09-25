tableextension 72005 "SKUCustomer" extends Customer
{
    fields
    {
        // SAP BuyerPartyID used to resolve the sell-to customer on inbound EDI 850.
        field(72000; "SAP Buyer Party ID"; Code[20])
        {
            Caption = 'SAP Buyer Party ID';
            DataClassification = CustomerContent;
        }
        field(72002; "SAP Recipient Internal ID"; Code[20])
        {
            Caption = 'SAP Recipient Internal ID';
            DataClassification = CustomerContent;
        }
        field(72003; "Auto Sales Order"; Boolean)
        {
            Caption = 'Auto Sales Order';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(SKUBuyerPartyId; "SAP Buyer Party ID")
        {
        }
    }
}
