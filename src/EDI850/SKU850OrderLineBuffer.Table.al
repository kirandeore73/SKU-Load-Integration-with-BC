table 72026 "SKU 850 Order Line Buffer"
{
    Caption = 'SKU 850 Order Line Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            DataClassification = SystemMetadata;
            TableRelation = "SKU 850 Order Buffer".Id;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
        }
        field(4; "Order Entry No."; Integer)
        {
            Caption = 'Order Entry No.';
            Editable = false;
            TableRelation = "SKU 850 Order Buffer"."Entry No.";
        }

        // OrderItem identifiers
        field(10; "Action Code"; Code[10])
        {
            Caption = 'Action Code';
        }
        //for PurchaseOrderItem Line No.         store for reference
        field(11; "Purchase Order Item ID"; Integer)
        {
            Caption = 'Purchase Order Item ID';
        }
        // field(12; "Customer Order Item ID"; Code[20])
        // {
        //     Caption = 'Customer Order Item ID';
        // }
        //for our BC line No.
        field(13; "Sales Order Item ID"; Integer)
        {
            Caption = 'Sales Order Item ID';
        }
        field(14; "Purchase Order Schedule Line"; Code[20])
        {
            Caption = 'Purchase Order Schedule Line';
        }
        field(15; "Action Code_OrderItem"; Code[10])
        {
            Caption = 'ActionCode_OrderItem';
        }
        field(16; "PO Item ID_OrderItem"; Integer)
        {
            Caption = 'PurchaseOrderItemID_OrderItem';
        }

        // for our BC Item No.
        field(22; "Buyer Product ID"; Code[35])
        {
            Caption = 'Buyer Product ID';
        }
        field(23; "Buyer Product ID_Product"; Code[35])
        {
            Caption = 'BuyerProductID_Product';
        }
        field(24; "Supplier Product ID_Product"; Code[35])
        {
            Caption = 'SupplierProductID_Product';
        }
        //for custitem
        field(26; "Custitem"; Code[35])
        {
            Caption = 'Custitem';
        }
        //for buyerpartno
        field(27; "Buyer Part Number"; Code[35])
        {
            Caption = 'Buyer Part Number';
        }

        // Quantity and pricing
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(31; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(32; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 5;
        }
        field(33; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 0 : 5;
        }
        field(34; DRV1; Decimal)
        {
            Caption = 'DRV1';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Schedule Line Order Quantity"; Decimal)
        {
            Caption = 'Schedule Line Order Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Schedule Line Unit Code"; Code[10])
        {
            Caption = 'Schedule Line Unit Code';
        }

        // Delivery
        field(40; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        // field(41; "Location Code"; Code[10])
        // {
        //     Caption = 'Location Code';
        //     TableRelation = Location.Code;
        // }

        // Configuration and comments
        field(50; "Line Level Comment"; Text[250])
        {
            Caption = 'Line Level Comment';
        }
        field(51; "Is Configurable"; Boolean)
        {
            Caption = 'Is Configurable';
        }
        field(52; "Config Part Number"; Code[35])
        {
            Caption = 'Config Part Number';
        }
        field(53; "Product Configuration"; Text[100])
        {
            Caption = 'Product Configuration';
        }
        field(54; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(9631; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SKU 850 Order Buffer"."Order No." where(Id = field("Document Id")));
        }
        field(9632; "Order Id"; Guid)
        {
            Caption = 'Order Id';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SKU 850 Order Buffer"."Order Id" where(Id = field("Document Id")));
        }
        field(57; RestockFeePer; Decimal)
        {
            Caption = 'Restock Fee Percentage';
            DecimalPlaces = 0 : 5;
        }
        field(58; "Refund Reason"; Code[20])
        {
            Caption = 'Refund Reason';
        }
    }

    keys
    {
        key(PK; "Document Id", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Id)
        {
        }
        key(Key3; "Order Entry No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Id) then
            Id := CreateGuid();
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
        "Last Modified Date Time" := CurrentDateTime();
        UpdateOrderEntryNo();
        UpdateReferencedRecordIds();
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime();
        UpdateOrderEntryNo();
        UpdateReferencedRecordIds();
    end;

    procedure UpdateReferencedRecordIds()
    begin
    end;

    procedure GetNextLineNo(): Integer
    var
        OrderLineBuffer: Record "SKU 850 Order Line Buffer";
    begin
        OrderLineBuffer.SetRange("Document Id", "Document Id");
        if OrderLineBuffer.FindLast() then
            exit(OrderLineBuffer."Line No." + 10000);

        exit(10000);
    end;

    local procedure UpdateOrderEntryNo()
    var
        OrderBuffer: Record "SKU 850 Order Buffer";
    begin
        if IsNullGuid("Document Id") then
            exit;

        OrderBuffer.SetRange(Id, "Document Id");
        if OrderBuffer.FindFirst() then
            "Order Entry No." := OrderBuffer."Entry No.";
    end;
}