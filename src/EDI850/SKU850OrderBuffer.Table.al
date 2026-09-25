table 72025 "SKU 850 Order Buffer"
{
    Caption = 'SKU 850 Order Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
        }
        field(5; "Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(6; "Order Id"; Guid)
        {
            Caption = 'Order Id';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        // MessageHeader
        field(10; "Message ID"; Text[50])
        {
            Caption = 'Message ID';
        }
        field(11; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime';
        }
        field(12; "Sender Business System ID"; Code[20])
        {
            Caption = 'Sender Business System ID';
        }
        field(13; "Sender Internal ID"; Code[20])
        {
            Caption = 'Sender Internal ID';
        }
        field(14; "Recipient Internal ID"; Code[20])
        {
            Caption = 'Recipient Internal ID';
        }
        // field(15; "Buyer Party ID"; Code[20])
        // {
        //     Caption = 'Buyer Party ID';
        // }
        //for Order Header Company Code
        field(16; "EDI Company Code"; Code[20])
        {
            Caption = 'EDI Company Code';
        }
        //for Ship-to - SupplierPartyID (stored for reference send back)
        field(17; "SupplierPartyID_Shipto"; Code[20])
        {
            Caption = 'Supplier Party ID_Ship-to';
        }
        //For Order Header PurchasingDocumentType
        field(18; "Purchasing Document Type"; Code[20])
        {
            Caption = 'Purchasing Document Type';
        }
        //For Order Header PurchasingDocumentTypeName
        field(19; "Purchasing Document Type Name"; Code[30])
        {
            Caption = 'Purchasing Document Type Name';
        }
        //for Order Header PurchasingDocumentTypeName/@languageCode
        field(4; "Purch Doc Type Language Code"; Code[10])
        {
            Caption = 'Purchasing Document Type Language Code';
        }
        // field(17; "Company Code Name"; Text[100])
        // {
        //     Caption = 'Company Code Name';
        // }

        // Order
        field(20; "Action Code"; Code[10])
        {
            Caption = 'Action Code';
        }
        field(21; "Purchase Order ID"; Code[35])
        {
            Caption = 'Purchase Order ID';
        }
        //for SalesOrderData - SAPOrder
        field(22; "SAP Order No."; Code[35])
        {
            Caption = 'SAP Order No.';
        }
        //map this to Document date of BC header
        field(23; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        //Map this to Cureency Code of BC Header
        field(24; "Order Currency"; Code[10])
        {
            Caption = 'Order Currency';
        }
        //for salesorderdata - OrderType
        field(26; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
        }
        //for salesorderdata - SalesPaymentTerms
        field(27; "Sales Payment Terms"; Code[20])
        {
            Caption = 'Sales Payment Terms';
        }
        field(28; "EDI Tax Jurisdiction Code"; Code[20])
        {
            Caption = 'EDI Tax Jurisdiction Code';
            DataClassification = CustomerContent;
        }
        // field(28; "Buyer Payment Terms ID"; Code[20])
        // {
        //     Caption = 'Buyer Payment Terms ID';
        // }

        // Sell-to
        // field(30; "Sell-to Customer No."; Code[20])
        // {
        //     Caption = 'Sell-to Customer No.';
        //     TableRelation = Customer."No.";

        //     trigger OnValidate()
        //     begin
        //         UpdateCustomerId();
        //     end;
        // }
        // field(31; "Customer Id"; Guid)
        // {
        //     Caption = 'Customer Id';
        //     DataClassification = SystemMetadata;
        //     TableRelation = Customer.SystemId;

        //     trigger OnValidate()
        //     begin
        //         UpdateCustomerNo();
        //     end;
        // }

        // Bill-to (SalesOrderData BT*)
        field(40; "Bill-to Company"; Code[20])
        {
            Caption = 'Bill-to Customer No.';
        }
        field(41; "Bill-to Address 1"; Text[100])
        {
            Caption = 'Bill-to Address 1';
        }
        field(42; "Bill-to Address 2"; Text[100])
        {
            Caption = 'Bill-to Address 2';
        }
        field(43; "Bill-to Address 3"; Text[100])
        {
            Caption = 'Bill-to Address 3';
        }
        field(44; "Bill-to Address 4"; Text[100])
        {
            Caption = 'Bill-to Address 4';
        }
        field(45; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
        }
        field(46; "Bill-to State"; Text[30])
        {
            Caption = 'Bill-to State';
        }
        field(47; "Bill-to Country"; Code[10])
        {
            Caption = 'Bill-to Country';
        }
        field(48; "Bill-to Zip"; Code[20])
        {
            Caption = 'Bill-to Zip';
        }
        field(49; "Bill-to Phone"; Text[30])
        {
            Caption = 'Bill-to Phone';
        }
        field(50; "Bill-to Email"; Text[80])
        {
            Caption = 'Bill-to Email';
        }

        // Ship-to (SalesOrderData ST*)
        field(60; "Ship-to House Number"; Text[30])
        {
            Caption = 'Ship-to House Number';
        }
        field(61; "Ship-to Company"; Code[20])
        {
            Caption = 'Ship-to Code';
        }
        field(62; "Ship-to Address 1"; Text[100])
        {
            Caption = 'Ship-to Address 1';
        }
        field(63; "Ship-to Address 2"; Text[100])
        {
            Caption = 'Ship-to Address 2';
        }
        field(64; "Ship-to Address 3"; Text[100])
        {
            Caption = 'Ship-to Address 3';
        }
        field(65; "Ship-to Address 4"; Text[100])
        {
            Caption = 'Ship-to Address 4';
        }
        field(66; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(67; "Ship-to State Code"; Text[30])
        {
            Caption = 'Ship-to State Code';
        }
        field(68; "Ship-to State Name"; Text[50])
        {
            Caption = 'Ship-to State Name';
        }
        field(69; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
        }
        field(70; "Ship-to Zip"; Code[20])
        {
            Caption = 'Ship-to Zip';
        }
        field(71; "Ship-to Phone"; Text[30])
        {
            Caption = 'Ship-to Phone';
        }
        field(72; "Ship-to Email"; Text[80])
        {
            Caption = 'Ship-to Email';
        }
        field(73; "Ship-to Attention"; Text[100])
        {
            Caption = 'Ship-to Attention';
        }

        // Shipping
        field(80; "Shipping Via"; Code[10])
        {
            Caption = 'Shipping Via';
        }
        field(81; "Shipping Via Desc"; Text[50])
        {
            Caption = 'Shipping Via Description';
        }
        field(82; "Shipping Account Number"; Code[35])
        {
            Caption = 'Shipping Account Number';
        }
        field(83; "Ship Complete"; Boolean)
        {
            Caption = 'Ship Complete';
        }
        field(84; "Ship Early"; Boolean)
        {
            Caption = 'Ship Early';
        }
        field(85; "Shipping Notes"; Text[250])
        {
            Caption = 'Shipping Notes';
        }
        field(86; "Scheduled Shipment"; Boolean)
        {
            Caption = 'Scheduled Shipment';
        }
        field(87; Freight; Decimal)
        {
            Caption = 'Freight';
            DecimalPlaces = 0 : 5;
        }
        field(88; "Handling Charges"; Decimal)
        {
            Caption = 'Handling Charges';
            DecimalPlaces = 0 : 5;
        }
        // field(89; "Dropship Or SA"; Code[10])
        // {
        //     Caption = 'Dropship Or SA';
        // }

        // Contact
        field(90; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
        field(91; "Contact Email"; Text[80])
        {
            Caption = 'Contact Email';
        }
        field(92; "Contact Phone"; Text[30])
        {
            Caption = 'Contact Phone';
        }
        field(93; "Store Number"; Code[20])
        {
            Caption = 'Store Number';
        }
        field(94; "Ship Partial"; Boolean)
        {
            Caption = 'Ship Partial';
        }

        // References Ship to address id
        field(100; "Address Id"; Code[20])
        {
            Caption = 'Address Id';
        }
        field(101; "Web Order No."; Code[35])
        {
            Caption = 'Web Order No.';
        }
        field(102; "Legacy Order Number"; Code[35])
        {
            Caption = 'Legacy Order Number';
        }
        field(103; "Customer PO"; Code[35])
        {
            Caption = 'Customer PO';
        }
        field(104; "Customer Ref PO"; Code[35])
        {
            Caption = 'Customer Ref PO';
        }
        // field(105; "Buy-from Vendor No."; Code[20])
        // {
        //     Caption = 'Buy-from Vendor No.';
        //     TableRelation = Vendor."No.";
        // }
        field(106; "ASM Initial"; Code[20])
        {
            Caption = 'ASM Initial';
        }
        field(107; "Hybris RMA"; Code[35])
        {
            Caption = 'Hybris RMA';
        }

        // Flags
        field(110; "Is Govt Order"; Boolean)
        {
            Caption = 'Is Govt Order';
        }
        field(111; "Govt Type"; Code[20])
        {
            Caption = 'Govt Type';
        }
        field(112; "Price Mismatch"; Boolean)
        {
            Caption = 'Price Mismatch';
        }
        field(113; "Questionare Type"; Code[20])
        {
            Caption = 'Questionare Type';
        }
        field(114; "Discontinued Items"; Boolean)
        {
            Caption = 'Discontinued Items';
        }
        field(115; "Discontinued Item Notes"; Text[250])
        {
            Caption = 'Discontinued Item Notes';
        }
        field(116; "Vendor Price"; Decimal)
        {
            Caption = 'Vendor Price';
            DecimalPlaces = 0 : 5;
        }

        // Processing state
        field(200; Status; Enum "SKU 850 Order Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(201; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
        }
        field(202; "Processed DateTime"; DateTime)
        {
            Caption = 'Processed DateTime';
            Editable = false;
        }
        field(9630; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
        }
        key(Key2; Id)
        {
            Clustered = true;
        }
        key(Key3; "Purchase Order ID")
        {
        }
        key(Key4; "Order No.")
        {
        }
        key(Key5; Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Id) then
            Id := CreateGuid();
        "Last Modified Date Time" := CurrentDateTime();
        UpdateReferencedRecordIds();
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime();
        UpdateReferencedRecordIds();
    end;

    trigger OnDelete()
    var
        OrderLineBuffer: Record "SKU 850 Order Line Buffer";
    begin
        OrderLineBuffer.SetRange("Document Id", Id);
        OrderLineBuffer.DeleteAll(true);
    end;

    procedure UpdateReferencedRecordIds()
    begin
    end;
}