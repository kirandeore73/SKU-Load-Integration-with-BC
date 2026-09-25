codeunit 72035 "Order Status SFDC Mgt"
{
    Permissions = tabledata "OrderStatusUpdToSFDCHdrBuff" = RIMD,
                  tabledata "OrderStatusUpdToSFDCLineBuff" = RIMD,
                  tabledata "Sales Header" = R,
                  tabledata "Sales Line" = R,
                  tabledata "Item Charge Assignment (Sales)" = R;

    procedure CreateFromSalesHeader(var SalesHeader: Record "Sales Header")
    var
        DocTypeCode: Code[1];
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                DocTypeCode := 'R';
            SalesHeader."Document Type"::"Blanket Order":
                DocTypeCode := 'B';
            else
                exit; // only Order (R) and Blanket Order (B) are sent to SFDC
        end;

        UpsertHeader(SalesHeader, DocTypeCode);
        UpsertLines(SalesHeader);
    end;

    // Isolates SFDC sync failures so they can never roll back or block the calling EDI transaction.
    [TryFunction]
    procedure TryCreateFromSalesHeader(var SalesHeader: Record "Sales Header")
    begin
        CreateFromSalesHeader(SalesHeader);
    end;

    procedure DeleteAllOrderStatusSFDCBuffers(): Integer
    var
        LineBuffer: Record "OrderStatusUpdToSFDCLineBuff";
        HeaderBuffer: Record "OrderStatusUpdToSFDCHdrBuff";
        Counter: Integer;
    begin
        LineBuffer.Reset();
        LineBuffer.DeleteAll(true);

        HeaderBuffer.Reset();
        if HeaderBuffer.FindSet() then
            repeat
                Counter += 1;
                HeaderBuffer.Delete(true);
            until HeaderBuffer.Next() = 0;

        exit(Counter);
    end;

    local procedure UpsertHeader(var SalesHeader: Record "Sales Header"; DocTypeCode: Code[1])
    var
        HeaderBuffer: Record "OrderStatusUpdToSFDCHdrBuff";
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
        CoNumber: Code[35];
        HeaderExists: Boolean;
        HasFreightCharge: Boolean;
        FreightAmount: Decimal;
        FreightChargeItemNo: Code[20];
    begin
        SalesHeader.CalcFields("Amount Including VAT");
        if SalesHeader."EDI Web Order No." <> '' then
            CoNumber := SalesHeader."EDI Web Order No."
        else
            CoNumber := SalesHeader."SAP Sales Order No.";
        // CoNumber := SalesHeader."SAP Sales Order No.";

        HeaderBuffer.SetRange("BC Sales Order No.", SalesHeader."No.");
        HeaderExists := HeaderBuffer.FindFirst();
        if not HeaderExists then begin
            HeaderBuffer.Init();
            HeaderBuffer."CO Number" := CoNumber;
        end;

        HeaderBuffer.Type := DocTypeCode;
        HeaderBuffer."BC Sales Order No." := SalesHeader."No.";
        HeaderBuffer."Customer No." := SalesHeader."Sell-to Customer No.";
        HeaderBuffer."Customer Seq" := SalesHeader."Ship-to Code";
        HeaderBuffer."Order Date" := FormatSFDCDateTime(CreateDateTime(SalesHeader."Order Date", 0T));
        HeaderBuffer."Taken By" := '';
        HeaderBuffer.Contact := SalesHeader."Ship-to Contact";
        HeaderBuffer."Customer PO" := SalesHeader."Your Reference";
        HeaderBuffer."Terms Code" := SalesHeader."EDI Sales Payment Terms";
        HeaderBuffer."Ship Code" := SalesHeader."Shipment Method Code";
        HeaderBuffer.Price := SalesHeader."Amount Including VAT";
        HeaderBuffer."Sales Tax" := 0;
        HeaderBuffer."Disc Amount" := 0;
        HeaderBuffer.Disc := 0;
        HeaderBuffer."Discount Type" := 'P';

        if salesheader."EDI Ship Complete" = true then
            HeaderBuffer."Ship Partial" := BoolToInt(false)
        else
            HeaderBuffer."Ship Partial" := BoolToInt(salesheader."EDI Ship Partial");
        HeaderBuffer."Ship Early" := BoolToInt(SalesHeader."EDI Ship Early");
        HeaderBuffer."Credit Hold" := BoolToInt(SalesHeader."Credit Hold");
        if SalesHeader."Credit Hold Date" <> 0DT then
            HeaderBuffer."Credit Hold Date" := FormatSFDCDateTime(SalesHeader."Credit Hold Date")
        else
            HeaderBuffer."Credit Hold Date" := '';
        HeaderBuffer."Credit Hold Reason" := SalesHeader."EDI Hold Reason";
        HeaderBuffer."Credit Hold User" := SalesHeader."Credit Hold User";
        // Freight and inco terms fields left blank until mapping is confirmed.
        HasFreightCharge := GetFreightChargeInfo(SalesHeader, FreightAmount, FreightChargeItemNo);
        HeaderBuffer."Uf Flat Fee Freight" := BoolToInt(HasFreightCharge);
        HeaderBuffer."Uf Flat Fee Freight Amt" := FreightAmount;
        HeaderBuffer."Uf Freight Account" := FreightChargeItemNo;
        HeaderBuffer."Uf Hold Date" := HeaderBuffer."Credit Hold Date";
        HeaderBuffer."Uf One Time Freight" := BoolToInt(false);
        HeaderBuffer."Uf Shipping Terms" := SalesHeader."Shipment Method Code";
        HeaderBuffer."Uf Hold Reason" := HeaderBuffer."Credit Hold Reason";
        HeaderBuffer."Uf Inco Terms" := '';
        HeaderBuffer."Uf ShipTo Attention Name" := SalesHeader."EDI Ship-to Attention";
        HeaderBuffer."Tax Code1" := 'NT';
        HeaderBuffer."Contact Email" := SalesHeader."EDI Ship-to Contact Email";
        HeaderBuffer."Hybris Status" := CopyStr(HybrisOrderStatusMgt.DetermineHybrisStatus(SalesHeader), 1, MaxStrLen(HeaderBuffer."Hybris Status"));
        HeaderBuffer."Last Updated DateTime" := CurrentDateTime;

        if HeaderExists then
            HeaderBuffer.Modify(true)
        else
            HeaderBuffer.Insert(true);
    end;

    local procedure UpsertLines(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        LineBuffer: Record "OrderStatusUpdToSFDCLineBuff";
        HybrisOrderStatusMgt: Codeunit "Hybris Order Status Management";
        CoNumber: Code[35];
        LineExists: Boolean;
    begin
        if SalesHeader."EDI Web Order No." <> '' then
            CoNumber := SalesHeader."EDI Web Order No."
        else
            CoNumber := SalesHeader."SAP Sales Order No.";

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if not SalesLine.FindSet() then
            exit;

        repeat
            LineBuffer.SetRange("BC Sales Order No.", SalesHeader."No.");
            LineBuffer.SetRange("CO Line", SalesLine."SAP Sales Order Item ID");
            LineExists := LineBuffer.FindFirst();
            if not LineExists then begin
                LineBuffer.Init();
                LineBuffer."CO Number" := CoNumber;
                LineBuffer."CO Line" := SalesLine."SAP Sales Order Item ID";
            end;

            LineBuffer."CO Release" := 0;
            LineBuffer."BC Sales Order No." := SalesHeader."No.";
            LineBuffer."BC Line No." := SalesLine."Line No.";
            LineBuffer.Item := SalesLine."No.";
            LineBuffer."Qty Ordered" := SalesLine.Quantity;
            LineBuffer."Due Date" := FormatSFDCDateTime(CreateDateTime(SalesLine."Shipment Date", 0T));
            LineBuffer."Coitem Stat" := DetermineLineStatus(SalesLine);
            LineBuffer."Ship Site" := SalesLine."Location Code";
            LineBuffer.Price := SalesLine."Unit Price";
            LineBuffer."Uf Hold Reason" := SalesHeader."EDI Hold Reason";
            LineBuffer."Uf Calc Due Date" := FormatSFDCDateTime(CreateDateTime(SalesLine."Shipment Date", 0T));
            LineBuffer."Qty Packed" := SalesLine."Quantity Shipped";
            LineBuffer."Qty Shipped" := SalesLine."Quantity Shipped";
            if HybrisOrderStatusMgt.DetermineHybrisStatus(SalesHeader) = 'Cancelled' then
                LineBuffer."Cancel Status" := 'Cancelled';
            LineBuffer."Smart Part Number" := SalesLine."Config Part Number";
            LineBuffer."Uf Long Description" := SalesLine.Description;
            LineBuffer."Line Net Price" := SalesLine."Line Amount";

            if LineExists then
                LineBuffer.Modify(true)
            else
                LineBuffer.Insert(true);
        until SalesLine.Next() = 0;
    end;

    local procedure DetermineLineStatus(SalesLine: Record "Sales Line"): Code[10]
    begin
        if SalesLine."Quantity Invoiced" = SalesLine.Quantity then
            exit('C');
        if SalesLine."Quantity Shipped" = SalesLine.Quantity then
            exit('S');
        exit('O');
    end;

    // Sums Item Charge Assignment amounts for Charge (Item) lines (e.g. freight); charge item no. becomes the freight account.
    local procedure GetFreightChargeInfo(SalesHeader: Record "Sales Header"; var Amount: Decimal; var ChargeItemNo: Code[20]): Boolean
    var
        SalesLine: Record "Sales Line";
        ItemChargeAssignment: Record "Item Charge Assignment (Sales)";
    begin
        Amount := 0;
        ChargeItemNo := '';

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"Charge (Item)");
        if not SalesLine.FindSet() then
            exit(false);

        repeat
            if ChargeItemNo = '' then
                ChargeItemNo := SalesLine."No.";

            ItemChargeAssignment.SetRange("Document Type", SalesLine."Document Type");
            ItemChargeAssignment.SetRange("Document No.", SalesLine."Document No.");
            ItemChargeAssignment.SetRange("Document Line No.", SalesLine."Line No.");
            if ItemChargeAssignment.FindSet() then
                repeat
                    Amount += ItemChargeAssignment."Amount to Assign";
                until ItemChargeAssignment.Next() = 0;
        until SalesLine.Next() = 0;

        exit(true);
    end;

    // SFDC expects 1/0 instead of true/false for boolean-style fields.
    local procedure BoolToInt(Value: Boolean): Integer
    begin
        if Value then
            exit(1);
        exit(0);
    end;

    // Matches the source system's ISO-like format, e.g. 2026-04-13T01:00:00 (no offset, no milliseconds).
    local procedure FormatSFDCDateTime(Value: DateTime): Text[19]
    begin
        exit(Format(Value, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
    end;
}
