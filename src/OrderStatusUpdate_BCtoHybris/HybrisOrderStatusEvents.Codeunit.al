codeunit 72031 "Hybris Order Status Events"
{
    // Approval status transitions (Open <-> Pending Approval <-> Released) update Sales Header
    // via Modify, so OnAfterModifyEvent already covers the "Approval Status Changes" scenario.

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure OnAfterModifySalesHeader(var Rec: Record "Sales Header"; CurrFieldNo: Integer; var xRec: Record "Sales Header")
    var
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    begin
        if (xRec.Status <> Rec.Status) and ((Rec.Status = Rec.Status::"Pending Approval") or (Rec.Status = Rec.Status::"Pending Prepayment")) then
            if Rec."EDI Web Order No." <> '' then
                HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Credit Hold', false, false)]
    local procedure OnAfterValidateSalesHeaderCreditHold(var Rec: Record "Sales Header"; CurrFieldNo: Integer; var xRec: Record "Sales Header")
    var
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    begin
        if (xRec."Credit Hold" <> Rec."Credit Hold") and (Rec."Credit Hold") then
            if (Rec."EDI Web Order No." <> '') then
                HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Order Cancelled', false, false)]
    local procedure OnAfterValidateSalesHeaderOrderCancelled(var Rec: Record "Sales Header"; CurrFieldNo: Integer; var xRec: Record "Sales Header")
    var
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    begin
        if (xRec."Order Cancelled" <> Rec."Order Cancelled") and (Rec."Order Cancelled") then
            if (Rec."EDI Web Order No." <> '') then
                HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'EDI Hold Reason', false, false)]
    local procedure OnAfterValidateSalesHeaderEDIHoldReason(var Rec: Record "Sales Header"; CurrFieldNo: Integer; var xRec: Record "Sales Header")
    var
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    begin
        if (xRec."EDI Hold Reason" <> Rec."EDI Hold Reason") and (Rec."EDI Hold Reason" <> '') then
            if (Rec."EDI Web Order No." <> '') then
                HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesHeader(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if HybrisOrderStatusMgt.IsCancelledOnDelete(Rec) then
            HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec, 'CANCELLED');

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.IsEmpty() then
            exit;

        if HybrisOrderStatusMgt.IsFullyShippedAndInvoiced(SalesLine) then
            HybrisOrderStatusMgt.SendOrderStatusToHybris(Rec, 'COMPLETED');
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    // local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    // var
    //     HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
    // begin
    //     if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
    //         exit;

    //     // Sent here because a fully shipped/invoiced order is removed from the Sales Header table after posting.
    //     HybrisOrderStatusMgt.SendOrderStatusToHybris(SalesHeader);
    // end;
}
