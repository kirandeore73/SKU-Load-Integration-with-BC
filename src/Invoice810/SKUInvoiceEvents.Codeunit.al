codeunit 72021 "SKU Invoice Events"
{
    Permissions = tabledata "Sales Invoice Header" = RM,
                  tabledata "SKU Invoice Buffer" = RIMD,
                  tabledata "SKU Invoice Line Buffer" = RIMD,
                  tabledata SKUIntegrationSetup = RIMD;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        InvoiceBufferMgt: Codeunit "SKU Invoice Buffer Mgt";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if SalesInvHdrNo = '' then
            exit;

        if not SalesHeader."Created From EDI 850" then
            exit;

        if SalesInvoiceHeader.Get(SalesInvHdrNo) then begin
            SalesInvoiceHeader."EDI Tax Jurisdiction Code" := SalesHeader."EDI Tax Jurisdiction Code";
            SalesInvoiceHeader.Modify(true);
        end;

        InvoiceBufferMgt.CreateFromPostedInvoice(SalesInvHdrNo);
    end;
}
