table 72014 "SKU Order Conf Line Buffer"
{
    Caption = 'SKU Order Confirmation Line Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Order Conf Entry No."; Integer)
        {
            Caption = 'Order Conf Entry No.';
            TableRelation = "SKU Order Conf Buffer"."Entry No.";
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
        field(4; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            DataClassification = SystemMetadata;
            TableRelation = "SKU Order Conf Buffer".Id;
        }
        // for BuyerProductID
        field(20; "SAP Product ID"; Code[35])
        {
            Caption = 'SAP Product ID';
        }
        //for PurchaseOrderItemID
        field(25; "Purchase Order Item ID"; Integer)
        {
            Caption = 'Purchase Order Item ID';
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Requested Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(40; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(50; "Purchase Order Schedule Line"; Code[20])
        {
            Caption = 'Purchase Order Schedule Line';
        }
        //for requested delivery date
        field(60; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        //for confirmed delivery date
        field(70; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(80; "Schedule Line Order Quantity"; Decimal)
        {
            Caption = 'Schedule Line Order Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(90; "Confirmed Order Quantity"; Decimal)
        {
            Caption = 'Confirmed Order Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(100; "Confirmed Order Quantity UOM"; Code[10])
        {
            Caption = 'Confirmed Order Quantity UOM';
        }
        field(110; "Schedule Line Order Qty UOM"; Code[10])
        {
            Caption = 'Schedule Line Order Quantity UOM';
        }
        field(9630; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Order Conf Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Id)
        {
        }
        key(Key3; "Document Id")
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Id) then
            Id := CreateGuid();
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

}
