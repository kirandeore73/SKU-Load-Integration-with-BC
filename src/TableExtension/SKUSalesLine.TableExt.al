tableextension 72001 "SAPEDISalesLine" extends "Sales Line"
{
    fields
    {
        // field(72000; "SAP Purchase Order No."; Code[35])
        // {
        //     Caption = 'SAP Purchase Order No.';
        //     DataClassification = CustomerContent;
        // }
        // for PurchaseOrderItemID         store for reference
        field(72001; "SAP PO Line No."; Integer)
        {
            Caption = 'SAP PO Line No.';
            DataClassification = CustomerContent;
        }
        //for Buyer Product ID    : BC Item No.
        // field(72002; "SAP Product ID"; Code[20])
        // {
        //     Caption = 'SAP Product ID';
        //     DataClassification = CustomerContent;
        // }
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
        // // for Buyer Product ID    : BC Item No.
        // field(72012; "Buyer Product ID"; Code[20])
        // {
        //     Caption = 'Buyer Product ID';
        //     DataClassification = CustomerContent;
        // }
        // field(72013; "EDI Supplier Product ID"; Text[50])
        // {
        //     Caption = 'EDI Supplier Product ID';
        //     DataClassification = CustomerContent;
        // }
        // field(72014; "Purchase Order Schedule Line"; Code[10])
        // {
        //     Caption = 'Purchase Order Schedule Line';
        //     DataClassification = CustomerContent;
        // }
        field(72014; "Purchase Order Schedule Line"; Code[20])
        {
            Caption = 'Purchase Order Schedule Line';
            DataClassification = CustomerContent;
        }
        // DRV1 is provided by the existing sales-line extension.
        field(72016; "DRV1"; Decimal)
        {
            Caption = 'DRV1';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(72017; "CustItem"; Code[35])
        {
            Caption = 'CustItem';
            DataClassification = CustomerContent;
        }
        field(72018; "Buyer Part Number"; Code[35])
        {
            Caption = 'Buyer Part Number';
            DataClassification = CustomerContent;
        }
        // field(72019; "EDI Line Level Comment"; Text[250])
        // {
        //     Caption = 'EDI Line Level Comment';
        //     DataClassification = CustomerContent;
        // }
        field(72020; "Is Configurable"; Boolean)
        {
            Caption = 'Is Configurable';
            DataClassification = CustomerContent;
        }
        field(72021; "Config Part Number"; Code[35])
        {
            Caption = 'Config Part Number';
            DataClassification = CustomerContent;
        }
        field(72022; "Product Configuration"; Text[100])
        {
            Caption = 'Product Configuration';
            DataClassification = CustomerContent;
        }
        field(72023; "RestockFeePer"; Decimal)
        {
            Caption = 'Restock Fee Per';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(72024; "RefundReason"; Code[10])
        {
            Caption = 'Refund Reason';
            DataClassification = CustomerContent;
        }
        field(72025; "Action Code_OrderItem"; Code[10])
        {
            Caption = 'ActionCode_OrderItem';
            DataClassification = CustomerContent;
        }
        field(72026; "PO Item ID_OrderItem"; Integer)
        {
            Caption = 'PurchaseOrderItemID_OrderItem';
            DataClassification = CustomerContent;
        }
        field(72027; "Buyer Product ID_Product"; Code[35])
        {
            Caption = 'BuyerProductID_Product';
            DataClassification = CustomerContent;
        }
        field(72028; "Supplier Product ID_Product"; Code[35])
        {
            Caption = 'SupplierProductID_Product';
            DataClassification = CustomerContent;
        }
        field(72029; "Schedule Line Order Quantity"; Decimal)
        {
            Caption = 'Schedule Line Order Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(72030; "Schedule Line Unit Code"; Code[10])
        {
            Caption = 'Schedule Line Unit Code';
            DataClassification = CustomerContent;
        }
    }
}
