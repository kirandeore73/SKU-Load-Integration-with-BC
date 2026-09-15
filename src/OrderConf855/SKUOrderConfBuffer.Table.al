table 72013 "SKU Order Conf Buffer"
{
    Caption = 'SKU Order Confirmation Buffer';
    DataClassification = CustomerContent;
    ReplicateData = false;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
        }
        field(10; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(11; "Order Id"; Guid)
        {
            Caption = 'Order Id';
            DataClassification = SystemMetadata;
            TableRelation = "Sales Header".SystemId;

            trigger OnValidate()
            begin
                UpdateOrderNo();
            end;
        }
        //for PurchaseOrderID
        field(30; "SAP Purchase Order No."; Code[35])
        {
            Caption = 'SAP Purchase Order No.';
        }
        //Order Confirmation - SAP SalesOrderID
        field(40; "SAP Sales Order No."; Code[35])
        {
            Caption = 'SAP Sales Order No.';
        }
        field(50; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime';
        }
        field(70; "Sender Internal ID"; Code[20])
        {
            Caption = 'Sender Internal ID';
        }
        field(80; "Recipient Internal ID"; Code[20])
        {
            Caption = 'Recipient Internal ID';
        }
        field(100; "Sent to SAP"; Boolean)
        {
            Caption = 'Sent to SAP';
        }
        field(110; "Sent DateTime"; DateTime)
        {
            Caption = 'Sent DateTime';
        }
        field(120; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(9630; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Id)
        {
        }
        key(Key3; "Order No.")
        {
        }
        key(Key4; "Sent to SAP", "Creation DateTime")
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

    local procedure UpdateOrderNo()
    var
        SalesHeader: Record "Sales Header";
    begin
        if IsNullGuid("Order Id") then
            exit;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SystemId, "Order Id");
        if SalesHeader.FindFirst() then
            "Order No." := SalesHeader."No.";
    end;
}
