codeunit 72036 "Order Status SFDC Events"
{
    Permissions = tabledata "Sales Header" = R,
                  tabledata "Sales Line" = R;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        TriggerIfEligible(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        TriggerFromSalesLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        TriggerFromSalesLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesLine(var Rec: Record "Sales Line")
    begin
        TriggerFromSalesLine(Rec);
    end;

    // Covers shipment posting, invoice posting and partial shipment/invoice runs.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        TriggerIfEligible(SalesHeader);
    end;

    // Fully invoiced orders are deleted by BC after posting; capture the final state before the lines go with it.
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesHeader(var Rec: Record "Sales Header")
    begin
        TriggerIfEligible(Rec);
    end;

    local procedure TriggerIfEligible(var SalesHeader: Record "Sales Header")
    var
        OrderStatusSFDCMgt: Codeunit "Order Status SFDC Mgt";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;
        if not SalesHeader."Created From EDI 850" then
            exit;
        if SalesHeader."SAP Sales Order No." = '' then
            exit;

        // TryFunction so any SFDC sync failure never blocks or rolls back the triggering event.
        if not OrderStatusSFDCMgt.TryCreateFromSalesHeader(SalesHeader) then;
    end;

    local procedure TriggerFromSalesLine(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Order then
            exit;
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;

        TriggerIfEligible(SalesHeader);
    end;
}
