codeunit 72010 "SKU Order Conf Buffer Mgt"
{
    // Management codeunit for SKU Order Confirmation Buffer
    // Populates 855 buffer from Sales Orders
    Permissions = tabledata "SKU Order Conf Buffer" = RIMD,
                  tabledata "SKU Order Conf Line Buffer" = RIMD,
                  tabledata "Sales Header" = R,
                  tabledata "Sales Line" = R,
                  tabledata SKUIntegrationSetup = RIMD;

    procedure PropagateOnInsert(var OrderConfBuffer: Record "SKU Order Conf Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        if OrderConfBuffer."Order No." <> '' then
            LoadFromSalesOrder(OrderConfBuffer);
    end;

    procedure PropagateOnModify(var OrderConfBuffer: Record "SKU Order Conf Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        OrderConfBuffer."Last Modified Date Time" := CurrentDateTime;
    end;

    procedure PropagateOnDelete(var OrderConfBuffer: Record "SKU Order Conf Buffer")
    var
        OrderConfLineBuffer: Record "SKU Order Conf Line Buffer";
    begin
        OrderConfLineBuffer.SetRange("Document Id", OrderConfBuffer.Id);
        OrderConfLineBuffer.DeleteAll(true);
    end;

    procedure DeleteAllOrderConfBuffers(): Integer
    var
        OrderConfBuffer: Record "SKU Order Conf Buffer";
        OrderConfLineBuffer: Record "SKU Order Conf Line Buffer";
        Counter: Integer;
    begin
        OrderConfLineBuffer.Reset();
        if OrderConfLineBuffer.FindSet(true) then
            repeat
                OrderConfLineBuffer.Delete(true);
            until OrderConfLineBuffer.Next() = 0;

        OrderConfBuffer.Reset();
        if OrderConfBuffer.FindSet() then
            repeat
                Counter += 1;
                OrderConfBuffer.Delete(true);
            until OrderConfBuffer.Next() = 0;

        exit(Counter);
    end;

    procedure LoadFromSalesOrder(var OrderConfBuffer: Record "SKU Order Conf Buffer")
    var
        SalesHeader: Record "Sales Header";
    begin
        if OrderConfBuffer."Order No." = '' then
            exit;

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, OrderConfBuffer."Order No.") then
            exit;

        OrderConfBuffer."Order Id" := SalesHeader.SystemId;
        OrderConfBuffer."SAP Purchase Order No." := SalesHeader."SAP Purchase Order No.";
        OrderConfBuffer."SAP Sales Order No." := SalesHeader."SAP Sales Order No.";
        OrderConfBuffer."Creation DateTime" := SalesHeader.SystemCreatedAt;
        OrderConfBuffer."Sender Internal ID" := SalesHeader."Sell-to Customer No.";
        OrderConfBuffer."Recipient Internal ID" := SalesHeader."SAP Recipient Internal ID";

        LoadLines(OrderConfBuffer, SalesHeader);
    end;

    local procedure LoadLines(var OrderConfBuffer: Record "SKU Order Conf Buffer"; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        OrderConfLineBuffer: Record "SKU Order Conf Line Buffer";
        Item: Record Item;
    begin
        // Clear existing lines
        OrderConfLineBuffer.SetRange("Document Id", OrderConfBuffer.Id);
        OrderConfLineBuffer.DeleteAll();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity, '<>0');

        if SalesLine.FindSet() then begin
            repeat
                OrderConfLineBuffer.Init();
                OrderConfLineBuffer."Order Conf Entry No." := OrderConfBuffer."Entry No.";
                OrderConfLineBuffer."Line No." := SalesLine."Line No.";
                OrderConfLineBuffer.Id := CreateGuid();
                OrderConfLineBuffer."Document Id" := OrderConfBuffer.Id;
                if Item.Get(SalesLine."No.") then begin
                    OrderConfLineBuffer."SAP Product ID" := Item."Buyer Product ID";
                end;
                OrderConfLineBuffer."Purchase Order Item ID" := SalesLine."SAP PO Line No.";
                OrderConfLineBuffer.Quantity := SalesLine.Quantity;
                OrderConfLineBuffer."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                OrderConfLineBuffer."Purchase Order Schedule Line" := '0001';
                OrderConfLineBuffer."Promised Delivery Date" := SalesLine."Promised Delivery Date";
                OrderConfLineBuffer."Due Date" := SalesLine."Shipment Date";
                OrderConfLineBuffer."Schedule Line Order Quantity" := SalesLine.Quantity;
                OrderConfLineBuffer."Schedule Line Order Qty UOM" := SalesLine."Unit of Measure Code";
                OrderConfLineBuffer."Confirmed Order Quantity" := SalesLine.Quantity;
                OrderConfLineBuffer."Confirmed Order Quantity UOM" := SalesLine."Unit of Measure Code";
                OrderConfLineBuffer.Insert(true);
            until SalesLine.Next() = 0;
        end;
    end;

    procedure CreateFromSalesOrder(SalesHeader: Record "Sales Header"): Boolean
    var
        OrderConfBuffer: Record "SKU Order Conf Buffer";
        ExistingBuffer: Record "SKU Order Conf Buffer";
    begin
        if not SalesHeader."Created From EDI 850" then
            exit(false);

        // Check if buffer already exists for this order
        ExistingBuffer.SetRange("Order No.", SalesHeader."No.");
        if ExistingBuffer.FindFirst() then begin
            LoadFromSalesOrder(ExistingBuffer);
            ExistingBuffer.Modify(true);
            exit(true);
        end;

        // Create new buffer
        OrderConfBuffer.Init();
        OrderConfBuffer."Order No." := SalesHeader."No.";
        OrderConfBuffer.Id := CreateGuid();
        OrderConfBuffer.Insert(true);
        LoadFromSalesOrder(OrderConfBuffer);
        OrderConfBuffer.Modify(true);
        exit(true);
    end;

    procedure PopulateFromAllSalesOrders(FromDate: Date; ToDate: Date): Integer
    var
        SalesHeader: Record "Sales Header";
        Counter: Integer;
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Order Date", '%1..%2', FromDate, ToDate);

        if SalesHeader.FindSet() then
            repeat
                if CreateFromSalesOrder(SalesHeader) then
                    Counter += 1;
            until SalesHeader.Next() = 0;

        exit(Counter);
    end;

    var
        Item: Record Item;
}
