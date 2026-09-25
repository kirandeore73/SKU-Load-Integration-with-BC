table 72029 "OrderStatusUpdToSFDCHdrBuff"
{
    Caption = 'Order Status Update to SFDC Header Buffer';

    fields
    {
        field(1; "CO Number"; Code[35])
        {
            Caption = 'CoNum';
            DataClassification = ToBeClassified;
        }
        field(2; "Type"; Code[10])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'CustNum';
            DataClassification = ToBeClassified;
        }
        field(4; "Customer Seq"; Code[20])
        {
            Caption = 'CustSeq';
            DataClassification = ToBeClassified;
        }
        field(5; "Order Date"; Text[19])
        {
            Caption = 'OrderDate';
            DataClassification = ToBeClassified;
        }
        field(6; "Taken By"; Text[50])
        {
            Caption = 'TakenBy';
            DataClassification = ToBeClassified;
        }
        field(7; "Contact"; Text[100])
        {
            Caption = 'Contact';
            DataClassification = ToBeClassified;
        }
        field(8; "Customer PO"; Text[50])
        {
            Caption = 'CustPo';
            DataClassification = ToBeClassified;
        }
        field(9; "Terms Code"; Code[20])
        {
            Caption = 'TermsCode';
            DataClassification = ToBeClassified;
        }
        field(10; "Ship Code"; Code[10])
        {
            Caption = 'ShipCode';
            DataClassification = ToBeClassified;
        }
        field(11; "Price"; Decimal)
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(12; "Sales Tax"; Decimal)
        {
            Caption = 'SalesTax';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(13; "Disc Amount"; Decimal)
        {
            Caption = 'DiscAmount';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(14; "Disc"; Decimal)
        {
            Caption = 'Disc';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(15; "Discount Type"; Code[10])
        {
            Caption = 'DiscountType';
            DataClassification = ToBeClassified;
        }
        field(16; "Ship Partial"; Integer)
        {
            Caption = 'ShipPartial';
            DataClassification = ToBeClassified;
        }
        field(17; "Ship Early"; Integer)
        {
            Caption = 'ShipEarly';
            DataClassification = ToBeClassified;
        }
        field(18; "Credit Hold"; Integer)
        {
            Caption = 'CreditHold';
            DataClassification = ToBeClassified;
        }
        field(19; "Credit Hold Date"; Text[19])
        {
            Caption = 'CreditHoldDate';
            DataClassification = ToBeClassified;
        }
        field(20; "Credit Hold Reason"; Text[100])
        {
            Caption = 'CreditHoldReason';
            DataClassification = ToBeClassified;
        }
        field(21; "Credit Hold User"; Text[50])
        {
            Caption = 'CreditHoldUser';
            DataClassification = ToBeClassified;
        }
        field(22; "Uf Flat Fee Freight"; Integer)
        {
            Caption = 'UfFlatFeeFreight';
            DataClassification = ToBeClassified;
        }
        field(23; "Uf Flat Fee Freight Amt"; Decimal)
        {
            Caption = 'UfFlatFeeFreightAmt';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(24; "Uf Freight Account"; Text[50])
        {
            Caption = 'UfFreightAccount';
            DataClassification = ToBeClassified;
        }
        field(25; "Uf Hold Date"; Text[19])
        {
            Caption = 'UfHoldDate';
            DataClassification = ToBeClassified;
        }
        field(26; "Uf One Time Freight"; Integer)
        {
            Caption = 'UfOneTimeFreight';
            DataClassification = ToBeClassified;
        }
        field(27; "Uf Shipping Terms"; Text[50])
        {
            Caption = 'UfShippingTerms';
            DataClassification = ToBeClassified;
        }
        field(28; "Uf Hold Reason"; Text[100])
        {
            Caption = 'UfHoldReason';
            DataClassification = ToBeClassified;
        }
        field(29; "Uf Inco Terms"; Code[10])
        {
            Caption = 'UfIncoTerms';
            DataClassification = ToBeClassified;
        }
        field(30; "Uf ShipTo Attention Name"; Text[100])
        {
            Caption = 'UfShipToAttentionName';
            DataClassification = ToBeClassified;
        }
        field(31; "Tax Code1"; Code[10])
        {
            Caption = 'TaxCode1';
            DataClassification = ToBeClassified;
        }
        field(32; "Contact Email"; Text[80])
        {
            Caption = 'ContactEmail';
            DataClassification = ToBeClassified;
        }
        field(33; "Hybris Status"; Text[30])
        {
            Caption = 'HybrisStatus';
            DataClassification = ToBeClassified;
        }
        field(34; "Last Updated DateTime"; DateTime)
        {
            Caption = 'Last Updated DateTime';
            DataClassification = ToBeClassified;
        }
        field(35; "BC Sales Order No."; Code[20])
        {
            Caption = 'BC Sales Order No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "CO Number")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        LineBuffer: Record "OrderStatusUpdToSFDCLineBuff";
    begin
        LineBuffer.SetRange("BC Sales Order No.", "BC Sales Order No.");
        LineBuffer.DeleteAll(true);
    end;
}
