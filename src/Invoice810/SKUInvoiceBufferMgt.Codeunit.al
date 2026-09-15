codeunit 72019 "SKU Invoice Buffer Mgt"
{
    Permissions = tabledata "SKU Invoice Buffer" = RIMD,
                  tabledata "SKU Invoice Line Buffer" = RIMD,
                  tabledata "Sales Invoice Header" = R,
                  tabledata "Sales Invoice Line" = R,
                  tabledata "General Ledger Setup" = R,
                  tabledata SKUIntegrationSetup = RIMD;

    procedure CreateFromPostedInvoice(InvoiceNo: Code[20]): Boolean
    var
        InvoiceHeader: Record "Sales Invoice Header";
        InvoiceBuffer: Record "SKU Invoice Buffer";
    begin
        if not InvoiceHeader.Get(InvoiceNo) then
            exit(false);

        if not InvoiceHeader."Created From EDI 850" then
            exit(false);

        InvoiceBuffer.SetRange("Invoice No.", InvoiceNo);
        if InvoiceBuffer.FindFirst() then begin
            LoadFromInvoice(InvoiceBuffer, InvoiceHeader);
            InvoiceBuffer.Modify(true);
            exit(true);
        end;

        InvoiceBuffer.Init();
        InvoiceBuffer."Invoice No." := InvoiceNo;
        InvoiceBuffer.Insert(true);
        LoadFromInvoice(InvoiceBuffer, InvoiceHeader);
        InvoiceBuffer.Modify(true);
        exit(true);
    end;

    procedure PopulateFromPostedInvoices(FromDate: Date; ToDate: Date): Integer
    var
        InvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
    begin
        InvoiceHeader.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
        if InvoiceHeader.FindSet() then
            repeat
                if CreateFromPostedInvoice(InvoiceHeader."No.") then
                    Counter += 1;
            until InvoiceHeader.Next() = 0;
        exit(Counter);
    end;

    local procedure LoadFromInvoice(var InvoiceBuffer: Record "SKU Invoice Buffer"; InvoiceHeader: Record "Sales Invoice Header")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        InvoiceBuffer."Invoice Id" := InvoiceHeader.SystemId;
        // InvoiceBuffer."Supplier Integration ID" := Setup.IntegrationId;
        InvoiceBuffer."Supplier Invoice Type Code" := '004';   // default for Invoice
        InvoiceBuffer."Creation DateTime" := InvoiceHeader.SystemCreatedAt;
        InvoiceBuffer."Sender Internal ID" := InvoiceHeader."SAP Sender Internal ID";
        // if InvoiceBuffer."Sender Internal ID" = '' then
        //     InvoiceBuffer."Sender Internal ID" := Setup.SenderInternalID;
        InvoiceBuffer."Recipient Internal ID" := InvoiceHeader."SAP Recipient Internal ID";
        InvoiceBuffer."BuyerPartyID_BillFrom" := InvoiceHeader."SAP Recipient Internal ID"; //Setup."EDI Buyer Party ID";    need to confirm from where value should take here
        InvoiceBuffer."BuyerPartyID_BillTo" := InvoiceHeader."SAP Recipient Internal ID"; //InvoiceHeader."Bill-to Customer No.";
        InvoiceBuffer."SupplierPartyID" := invoiceHeader."Bill-to Customer No.";
        InvoiceBuffer."Address Name" := InvoiceHeader."Bill-to Name";
        InvoiceBuffer."Posting Date" := InvoiceHeader."Posting Date";
        InvoiceBuffer."Currency Code" := InvoiceHeader."Currency Code";
        if InvoiceBuffer."Currency Code" = '' then begin
            GeneralLedgerSetup.Get();
            InvoiceBuffer."Currency Code" := GeneralLedgerSetup."LCY Code";
        end;
        InvoiceBuffer."Amount Including VAT" := InvoiceHeader."Amount Including VAT";
        InvoiceBuffer."Sell-to Country/Region Code" := InvoiceHeader."Sell-to Country/Region Code";
        //  InvoiceBuffer."Tax Country" := InvoiceHeader."Sell-to Country/Region Code";
        LoadLines(InvoiceBuffer, InvoiceHeader);
    end;

    local procedure LoadLines(InvoiceBuffer: Record "SKU Invoice Buffer"; InvoiceHeader: Record "Sales Invoice Header")
    var
        InvoiceLine: Record "Sales Invoice Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LineBuffer: Record "SKU Invoice Line Buffer";
        LineNo: Integer;
    begin
        LineBuffer.SetRange("Document Id", InvoiceBuffer.Id);
        LineBuffer.DeleteAll();
        InvoiceLine.SetRange("Document No.", InvoiceHeader."No.");
        InvoiceLine.SetRange(Type, InvoiceLine.Type::Item);
        if InvoiceLine.FindSet() then
            repeat
                LineNo += 10000;
                LineBuffer.Init();
                LineBuffer."Invoice Entry No." := InvoiceBuffer."Entry No.";
                LineBuffer."Supplier Invoice Item ID" := LineNo;
                LineBuffer."Document Id" := InvoiceBuffer.Id;
                //  LineBuffer."Item No." := InvoiceLine."No.";
                //  LineBuffer."Supplier Invoice Item ID" := LineNo;
                LineBuffer."Invoice Item Type Code" := '002';       //default for Invoice
                LineBuffer."Net Amount" := InvoiceLine.Amount;
                LineBuffer.Quantity := InvoiceLine.Quantity;
                LineBuffer."Currency Code" := InvoiceLine.GetCurrencyCode();
                if LineBuffer."Currency Code" = '' then begin
                    GeneralLedgerSetup.Get();
                    LineBuffer."Currency Code" := GeneralLedgerSetup."LCY Code";
                end;
                LineBuffer."Unit of Measure Code" := InvoiceLine."Unit of Measure Code";
                //if SalesLine.Get(SalesLine."Document Type"::Order, InvoiceLine."Order No.", InvoiceLine."Order Line No.") then begin
                LineBuffer."Purchase Order ID" := invoiceHeader."SAP Purchase Order No.";
                LineBuffer."Purchase Order Item ID" := InvoiceLine."SAP PO Line No.";
                //end;
                LineBuffer."Supplier Tax Type Code" := InvoiceLine."Tax Area Code"; //default for Invoice
                LineBuffer."Tax Percentage" := InvoiceLine."VAT %";
                LineBuffer."Tax Determination Date" := InvoiceHeader."Posting Date";
                LineBuffer."Tax Jurisdiction" := InvoiceHeader."EDI Tax Jurisdiction Code";
                LineBuffer.Insert(true);
            until InvoiceLine.Next() = 0;
    end;
}