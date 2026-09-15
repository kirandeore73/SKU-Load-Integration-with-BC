tableextension 72006 SKUShiptoAddress extends "Ship-to Address"
{
    fields
    {
        // EDI 850 Ship-to (ST*) for SalesOrderData - STHouseNumber
        field(72000; "EDI Ship-to House Number"; Text[30])
        {
            Caption = 'STHouseNumber';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - STStateName
        field(72001; "EDI Ship-to State Name"; Text[100])
        {
            Caption = 'STStateName';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - STPhone
        field(72002; "EDI Ship-to Phone"; Text[30])
        {
            Caption = 'STPhone';
            DataClassification = CustomerContent;
        }
        field(72003; "EDI Ship-to Email"; Text[80])
        {
            Caption = 'STEmail';
            DataClassification = CustomerContent;
        }
        // for salesorderdata - AddressId : maaped for Ship to code but ship to code will be our BC default code along with this unique field this will be unique identifaction of ship to address of SAP for each order
        field(72004; "EDI Address Id"; Code[50])
        {
            Caption = 'EDI Ship-to Address Id';
            DataClassification = CustomerContent;
        }
    }
}