codeunit 72030 "Hybris Order Status Management"
{
    Permissions = tabledata "Sales Line" = R,
                  tabledata "Order Status Hybris Buffer" = RIM;

    procedure DetermineHybrisStatus(SalesHeader: Record "Sales Header"): Text
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.IsEmpty() then
            exit('REJECTED');

        if SalesHeader."Order Cancelled" then
            exit('CANCELLED');

        if SalesHeader."Credit Hold" or
           (SalesHeader.Status = SalesHeader.Status::"Pending Approval") or
           (SalesHeader.Status = SalesHeader.Status::"Pending Prepayment") or
           (SalesHeader."EDI Hold Reason" <> '')
        then
            exit('ON_HOLD');

        if IsFullyShippedAndInvoiced(SalesLine) then
            exit('COMPLETED');

        if (SalesHeader.Status = SalesHeader.Status::Open) or
                   (SalesHeader.Status = SalesHeader.Status::Released)
                then
            exit('CONFIRMED');
    end;

    // Evaluated only right before a sales order is deleted, while its lines still exist.
    procedure IsCancelledOnDelete(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Order Cancelled" then
            exit(true);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.CalcSums("Quantity Shipped", "Quantity Invoiced");
        exit((SalesLine."Quantity Shipped" = 0) and (SalesLine."Quantity Invoiced" = 0));
    end;

    procedure SendOrderStatusToHybris(SalesHeader: Record "Sales Header")
    var
    //   SalesHeader: Record "Sales Header";
    begin
        //if SalesHeader.Get(SalesHeader."Document Type"::Order, OrderBuffer."Order No.") then
        SendOrderStatusToHybris(SalesHeader, DetermineHybrisStatus(SalesHeader));
    end;

    // Upserts the status into the buffer; Boomi pulls the JSON payload through the API page.
    // Multiple lines of the same order each call this; skip the write once the status is unchanged.
    procedure SendOrderStatusToHybris(SalesHeader: Record "Sales Header"; OrderStatus: Text)
    var
        OrderStatusBuffer: Record "Order Status Hybris Buffer";
    begin
        if SalesHeader."EDI Web Order No." = '' then
            exit;

        if OrderStatusBuffer.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
            if OrderStatusBuffer.Status = OrderStatus then
                exit;
        end else begin
            OrderStatusBuffer.Init();
            OrderStatusBuffer."Document Type" := SalesHeader."Document Type";
            OrderStatusBuffer."No." := SalesHeader."No.";
            OrderStatusBuffer.Insert();
        end;

        OrderStatusBuffer.Status := OrderStatus;
        OrderStatusBuffer."Hybris Order No." := SalesHeader."EDI Web Order No.";
        OrderStatusBuffer."SAP/S4 Order No." := SalesHeader."SAP Sales Order No.";
        OrderStatusBuffer."Sales Tax" := 0.00000000;
        if SalesHeader."EDI Hold Reason" <> '' then
            OrderStatusBuffer."EDI Hold Reason" := SalesHeader."EDI Hold Reason"
        else
            OrderStatusBuffer."EDI Hold Reason" := 'NULL';
        OrderStatusBuffer."Last Updated DateTime" := CurrentDateTime;
        OrderStatusBuffer.Modify();
    end;

    procedure IsFullyShippedAndInvoiced(var SalesLine: Record "Sales Line"): Boolean
    begin
        if SalesLine.FindSet() then
            repeat
                if (SalesLine."Quantity Shipped" <> SalesLine.Quantity) and
                   (SalesLine."Quantity Invoiced" <> SalesLine.Quantity)
                then
                    exit(false);
            until SalesLine.Next() = 0;

        exit(true);
    end;
}
