/// <summary>
/// TableExtension SKUSalesHeader (ID 72000) extends Record Sales Header.
/// </summary>
tableextension 72000 "SKUSalesHeader" extends "Sales Header"
{
    fields
    {
        //for order - PurchaseOrderID
        field(72000; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
            DataClassification = CustomerContent;
        }
        //for SalesorderData - SAPOrder
        field(72001; "SAP Sales Order No."; Code[35])
        {
            Caption = 'SAP Sales Order No.';
            DataClassification = CustomerContent;
        }
        //for SenderPArty - InternalID
        field(72002; "SAP Sender Internal ID"; Code[20])
        {
            Caption = 'SAP Sender Internal ID';
            DataClassification = CustomerContent;
        }
        //for Order -CompanyCode
        field(72003; "EDI Company Code"; Code[20])
        {
            Caption = 'EDI Company Code';
            DataClassification = CustomerContent;
        }
        //for Ship-to - SupplierPartyID (stored for reference send back)
        field(72004; "SupplierPartyID_Shipto"; Code[20])
        {
            Caption = 'Supplier Party ID_Ship-to';
            DataClassification = CustomerContent;
        }
        //For Order Header PurchasingDocumentType
        field(72005; "Purchasing Document Type"; Code[20])
        {
            Caption = 'Purchasing Document Type';
        }
        //For Order Header PurchasingDocumentTypeName
        field(72006; "Purchasing Document Type Name"; Code[30])
        {
            Caption = 'Purchasing Document Type Name';
        }
        //for Order Header PurchasingDocumentTypeName/@languageCode
        field(72007; "Purch Doc Type Language Code"; Code[10])
        {
            Caption = 'Purchasing Document Type Language Code';
        }
        // EDI 850 MessageHeader / Order
        field(72010; "EDI Message ID"; Text[50])
        {
            Caption = 'EDI Message ID';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - OrderType
        field(72012; "EDI Order Type"; Code[20])
        {
            Caption = 'EDI Order Type';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - SalesPaymentTerms
        field(72013; "EDI Sales Payment Terms"; Code[20])
        {
            Caption = 'EDI Sales Payment Terms';
            DataClassification = CustomerContent;
        }
        // field(72015; "EDI Dropship Or SA"; Code[10])
        // {
        //     Caption = 'EDI Dropship Or SA';
        //     DataClassification = CustomerContent;
        // }

        // EDI 850 Bill-to (BT*) - only values with no standard Sales Header equivalent
        //for salesorderdata - BTCompany
        field(72014; "EDI Bill-to Company"; Text[100])
        {
            Caption = 'BTCompany';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTAddress1
        field(72015; "EDI Bill-to Address 1"; Text[100])
        {
            Caption = 'BTAddress1';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTAddress2
        field(72016; "EDI Bill-to Address 2"; Text[100])
        {
            Caption = 'BTAddress2';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTCity
        field(72017; "EDI Bill-to City"; Text[50])
        {
            Caption = 'BTCity';
            DataClassification = CustomerContent;
        }
        field(72021; "EDI Bill-to Address 3"; Text[100])
        {
            Caption = 'BTAddress3';
            DataClassification = CustomerContent;
        }
        field(72022; "EDI Bill-to Address 4"; Text[100])
        {
            Caption = 'BTAddress4';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTPhone
        field(72023; "EDI Bill-to Phone"; Text[30])
        {
            Caption = 'BTPhone';
            DataClassification = CustomerContent;
        }
        field(72024; "EDI Bill-to Email"; Text[80])
        {
            Caption = 'BTEmail';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTState
        field(72025; "EDI Bill-to State"; Text[50])
        {
            Caption = 'BTState';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTCountry
        field(72026; "EDI Bill-to Country"; Text[50])
        {
            Caption = 'BTCountry';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - BTZip
        field(72027; "EDI Bill-to Zip"; Code[20])
        {
            Caption = 'BTZip';
            DataClassification = CustomerContent;
        }

        // EDI 850 Ship-to (ST*) for SalesOrderData - STHouseNumber
        field(72030; "EDI Ship-to House Number"; Text[30])
        {
            Caption = 'STHouseNumber';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - STStateName
        field(72033; "EDI Ship-to State Name"; Text[100])
        {
            Caption = 'STStateName';
            DataClassification = CustomerContent;
        }
        field(72034; "EDI Ship-to Email"; Text[80])
        {
            Caption = 'STEmail';
            DataClassification = CustomerContent;
        }
        field(72035; "EDI Ship-to Attention"; Text[100])
        {
            Caption = 'EDI Ship-to Attention';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - shippingAccountNumber
        field(72041; "EDI Shipping Account No."; Code[35])
        {
            Caption = 'EDI Shipping Account Number';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - shipComplete
        field(72042; "EDI Ship Complete"; Boolean)
        {
            Caption = 'EDI Ship Complete';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - shipEarly
        field(72043; "EDI Ship Early"; Boolean)
        {
            Caption = 'EDI Ship Early';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - shippingNotes
        field(72044; "EDI Shipping Notes"; Text[250])
        {
            Caption = 'EDI Shipping Notes';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - scheduledShipment
        field(72045; "EDI Scheduled Shipment"; Boolean)
        {
            Caption = 'EDI Scheduled Shipment';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - freight
        field(72046; "EDI Freight"; Decimal)
        {
            Caption = 'EDI Freight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        //for salesorderdata - handlingCharges
        field(72047; "EDI Handling Charges"; Decimal)
        {
            Caption = 'EDI Handling Charges';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        // for salesorderdata - Store Number
        field(72053; "EDI Store Number"; Code[50])
        {
            Caption = 'EDI Store Number';
            DataClassification = CustomerContent;
        }
        // for salesorderdata - AddressId : maaped for Ship to code but ship to code will be our BC default code along with this unique field this will be unique identifaction of ship to address of SAP for each order
        field(72054; "EDI Address Id"; Code[50])
        {
            Caption = 'EDI Ship-to Address Id';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - WebOrderNo
        field(72055; "EDI Web Order No."; Code[35])
        {
            Caption = 'EDI Web Order No.';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - LegacyOrderNumber
        field(72056; "EDI Legacy Order Number"; Code[35])
        {
            Caption = 'EDI Legacy Order Number';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - ASMInitial
        field(72057; "EDI ASM Initial"; Code[20])
        {
            Caption = 'EDI ASM Initial';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - HybrisRMA
        field(72058; "EDI Hybris RMA"; Code[35])
        {
            Caption = 'EDI Hybris RMA';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - STPhone
        field(72059; "EDI Ship-to Phone"; Text[30])
        {
            Caption = 'STPhone';
            DataClassification = CustomerContent;
        }
        // EDI 850 Flags
        //for salesorderdata - isGovtOrder
        field(72060; "EDI Is Govt Order"; Boolean)
        {
            Caption = 'EDI Is Govt Order';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - GovtType
        field(72061; "EDI Govt Type"; Code[20])
        {
            Caption = 'EDI Govt Type';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - PriceMismatch
        field(72062; "EDI Price Mismatch"; Boolean)
        {
            Caption = 'EDI Price Mismatch';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - QuestionareType
        field(72063; "EDI Questionare Type"; Code[20])
        {
            Caption = 'EDI Questionare Type';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - DiscontinuedItems
        field(72064; "EDI Discontinued Items"; Boolean)
        {
            Caption = 'EDI Discontinued Items';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - DiscontinuedItemsNotes
        field(72065; "EDI Discont. Item Notes"; Text[250])
        {
            Caption = 'EDI Discontinued Item Notes';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - VendorPrice
        field(72066; "EDI Vendor Price"; Decimal)
        {
            Caption = 'EDI Vendor Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        //for salesorderdata - ContactEmail
        field(72067; "EDI Ship-to Contact Email"; Text[80])
        {
            Caption = 'EDI Ship-to Contact Email';
            DataClassification = CustomerContent;
        }
        //for salesorderdata - ContactPhone
        field(72069; "EDI Ship-to Contact Phone"; Text[30])
        {
            Caption = 'EDI Ship-to Contact Phone';
            DataClassification = CustomerContent;
        }
        field(72070; "Created From EDI 850"; Boolean)
        {
            Caption = 'Created From EDI 850';
            DataClassification = CustomerContent;
        }
        field(72071; "SAP Recipient Internal ID"; Code[20])
        {
            Caption = 'SAP Recipient Internal ID';
            DataClassification = CustomerContent;
        }
        field(72072; "EDI Tax Jurisdiction Code"; Code[20])
        {
            Caption = 'EDI Tax Jurisdiction Code';
            DataClassification = CustomerContent;
        }
        field(72073; "Credit Hold"; Boolean)
        {
            Caption = 'Credit Hold';
            DataClassification = CustomerContent;
            InitValue = false;
        }
        field(72074; "Order Cancelled"; Boolean)
        {
            Caption = 'Order Cancelled';
            DataClassification = CustomerContent;
            InitValue = false;
        }
        field(72075; "EDI Hold Reason"; text[250])
        {
            Caption = 'EDI Hold Reason';
            DataClassification = CustomerContent;
        }
        field(72076; "EDI Ship Partial"; Boolean)
        {
            Caption = 'EDI Ship Partial';
            DataClassification = CustomerContent;
        }
        field(72077; "Credit Hold Date"; DateTime)
        {
            Caption = 'Credit Hold Date';
            DataClassification = CustomerContent;
        }
        field(72078; "Credit Hold User"; Text[50])
        {
            Caption = 'Credit Hold User';
            DataClassification = CustomerContent;
        }
    }
}
