codeunit 72000 "Temp Record Creation"
{
    trigger OnRun()
    begin
        // InsertBufferToStandardItem();
    end;

    // procedure InsertBufferToStandardItem()
    // var
    //     StandardItem: Record Item;
    //     ProductBuffer: Record "Product Buffer";
    // begin
    //     if ProductBuffer.FindSet() then
    //         repeat
    //             if not StandardItem.Get(ProductBuffer."No.") then begin
    //                 StandardItem.Init();
    //                 StandardItem."No." := ProductBuffer."No.";
    //                 StandardItem.Description := ProductBuffer.Description;
    //                 StandardItem."Price Code" := ProductBuffer."Price Code";
    //                 StandardItem."Make at Plant" := ProductBuffer."Make at Plant";
    //                 //StandardItem."Stocking Plant" := EDIItemBuffer."Stocking Plant";
    //                 StandardItem."GTD Description" := ProductBuffer."GTD Description";
    //                 //StandardItem."California Prop65" := EDIItemBuffer."California Prop65";
    //                 //StandardItem."Country/Region Purc. Code" := EDIItemBuffer."Country/Region Purc. Code";
    //                 //StandardItem.Validate("Unit Price", EDIItemBuffer."Unit Price");
    //                 StandardItem.Insert(true); // Set to true to run standard triggers/validations
    //             end else begin
    //                 //StandardItem.TransferFields(EDIItemBuffer, false); // false ignores primary key
    //                 StandardItem.Modify(true);
    //             end;
    //         until ProductBuffer.Next() = 0;
    // end;

    // procedure InsertSalesOrderToSalesOrderHybrs()
    // var
    //     SalesHeader: Record "Sales Header";
    //     OrderStatusHybrisBuffer: Record "Order Status Hybris Buffer";
    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     StartDate: Date;
    //     EndDate: Date;
    // begin
    //     StartDateTime := CreateDateTime(Today(), 0T);
    //     EndDateTime := CreateDateTime(Today(), 235959.999T);

    //     StartDate := CalcDate('<-5M>', Today);
    //     EndDate := Today();

    //     SalesHeader.reset;
    //     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    //     SalesHeader.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
    //     //SalesHeader.setrange(Status, SalesHeader.Status::Open);
    //     //SalesHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesHeader.FindSet() then
    //         repeat

    //             if not OrderStatusHybrisBuffer.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
    //                 OrderStatusHybrisBuffer.Init();
    //                 OrderStatusHybrisBuffer."Document Type" := SalesHeader."Document Type";
    //                 OrderStatusHybrisBuffer."No." := SalesHeader."No.";
    //                 OrderStatusHybrisBuffer."SAP/S4 Order No." := SalesHeader."SAP/S4 Order No.";
    //                 OrderStatusHybrisBuffer."Hybris Order No." := SalesHeader."Hybris Order No.";
    //                 OrderStatusHybrisBuffer."Hold Reason" := SalesHeader."Hold Reason";
    //                 OrderStatusHybrisBuffer."Sales Tax" := 0;
    //                 //'Rejected','Cancelled','On Hold','Completed',Confirmed'
    //                 OrderStatusHybrisBuffer.Status := 'Completed';
    //                 OrderStatusHybrisBuffer.Insert(true);
    //             end;
    //         until SalesHeader.Next() = 0;
    // end;

    // procedure InsertSalesOrderToSalesOrderSFDC()
    // var
    //     SalesHeader: Record "Sales Header";
    //     SalesLine: Record "Sales Line";
    //     OrderStatusHeaderSFDC: Record "Order Status Header SFDC Buf.";
    //     OrderStatusLineSFDC: Record "Order Status Line SFDC Buffer";
    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     StartDate: Date;
    //     EndDate: Date;
    // begin
    //     StartDateTime := CreateDateTime(Today(), 0T);
    //     EndDateTime := CreateDateTime(Today(), 235959.999T);

    //     StartDate := CalcDate('<-2M>', Today);
    //     EndDate := Today();

    //     SalesHeader.reset;
    //     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    //     SalesHeader.setrange(Status, SalesHeader.Status::Open);
    //     SalesHeader.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
    //     //SalesHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesHeader.FindSet() then
    //         repeat

    //             if not OrderStatusHeaderSFDC.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
    //                 OrderStatusHeaderSFDC.Init();
    //                 OrderStatusHeaderSFDC."Document Type" := SalesHeader."Document Type";
    //                 OrderStatusHeaderSFDC."No." := SalesHeader."No.";
    //                 OrderStatusHeaderSFDC."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
    //                 OrderStatusHeaderSFDC."Ship-to Code" := SalesHeader."Ship-to Code";
    //                 OrderStatusHeaderSFDC."Order Date" := SalesHeader."Order Date";
    //                 OrderStatusHeaderSFDC."Salesperson Code" := SalesHeader."Salesperson Code";
    //                 OrderStatusHeaderSFDC."Sell-to Contact No." := SalesHeader."Sell-to Contact No.";
    //                 OrderStatusHeaderSFDC."External Document No." := SalesHeader."External Document No.";
    //                 OrderStatusHeaderSFDC."Payment Terms Code" := SalesHeader."Payment Terms Code";
    //                 OrderStatusHeaderSFDC."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
    //                 SalesHeader.CalcFields(Amount, "Amount Including VAT");
    //                 OrderStatusHeaderSFDC.Amount := SalesHeader.Amount;
    //                 OrderStatusHeaderSFDC."Amount Including VAT" := SalesHeader."Amount Including VAT";
    //                 OrderStatusHeaderSFDC."Invoice Discount Amount" := SalesHeader."Invoice Discount Amount";
    //                 OrderStatusHeaderSFDC."Invoice Discount %" := 0;
    //                 OrderStatusHeaderSFDC."Discount Type" := 'P';
    //                 OrderStatusHeaderSFDC."Ship Partial" := 0;
    //                 OrderStatusHeaderSFDC."Ship Early" := 0;

    //                 //OrderStatusHeaderSFDC."Credit Hold" := 0;
    //                 //OrderStatusHeaderSFDC."Credit Hold Date" := 0D;
    //                 //OrderStatusHeaderSFDC."Credit Hold Reason" := '';
    //                 //OrderStatusHeaderSFDC."Credit Hold User" :=

    //                 OrderStatusHeaderSFDC."Uf Shipping Terms" := SalesHeader."Shipment Method Code";
    //                 OrderStatusHeaderSFDC."Uf Hold Reason" := '';
    //                 OrderStatusHeaderSFDC."Uf Inco Terms" := '';
    //                 OrderStatusHeaderSFDC."Uf Ship To Attention Name" := '';

    //                 OrderStatusHeaderSFDC."Tax Area Code" := SalesHeader."Tax Area Code";
    //                 OrderStatusHeaderSFDC."Sell-to E-Mail" := SalesHeader."Sell-to E-Mail";
    //                 OrderStatusHeaderSFDC."Hybris Status" := '';

    //                 //O=Ordered, F=Filled, C=Complete
    //                 OrderStatusHeaderSFDC."Status" := '';
    //                 OrderStatusHeaderSFDC.Insert(true);

    //                 SalesLine.reset;
    //                 SalesLine.setrange("Document Type", SalesHeader."Document Type");
    //                 SalesLine.setrange("Document No.", SalesHeader."No.");
    //                 if SalesLine.FindSet() then begin
    //                     repeat
    //                         OrderStatusLineSFDC."Document Type" := SalesLine."Document Type";
    //                         OrderStatusLineSFDC."Doc No." := SalesLine."Document No.";
    //                         OrderStatusLineSFDC."Line No." := SalesLine."Line No.";
    //                         OrderStatusLineSFDC."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
    //                         OrderStatusLineSFDC.Type := SalesLine.Type;
    //                         OrderStatusLineSFDC."Item No." := SalesLine."No.";
    //                         OrderStatusLineSFDC."CO Release" := 0;

    //                         OrderStatusLineSFDC.Description := SalesLine.Description;
    //                         OrderStatusLineSFDC."Location Code" := SalesLine."Location Code";
    //                         OrderStatusLineSFDC."Due Date" := SalesHeader."Due Date";
    //                         OrderStatusLineSFDC."Planned Shipment Date" := 0D;

    //                         OrderStatusLineSFDC."Line Amount" := SalesLine."line Amount";
    //                         OrderStatusLineSFDC.insert();
    //                     until SalesLine.Next() = 0;
    //                 end;
    //             end;
    //         until SalesHeader.Next() = 0;
    // end;

    // procedure InsertSalesShipmentToShipmentUpdateHybris()
    // var
    //     SalesShipmentHeader: Record "Sales Shipment Header";
    //     ShipmentHeaderHybrisBuffer: Record "Shipment Header Hybris Buffer";
    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     TargetDate: Date;
    // begin
    //     //StartDateTime := CreateDateTime(Today(), 0T);
    //     //EndDateTime := CreateDateTime(Today(), 235959.999T);
    //     TargetDate := CalcDate('<-1M>', Today);
    //     //Message('%1', TargetDate);
    //     ShipmentHeaderHybrisBuffer.DeleteAll();
    //     SalesShipmentHeader.reset;
    //     SalesShipmentHeader.SetFilter("Posting Date", '%1..%2', TargetDate, Today());
    //     //SalesShipmentHeader.SetFilter(SystemCreatedAt, '%1..%2', StartDateTime, EndDateTime);
    //     //SalesShipmentHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesShipmentHeader.FindSet() then
    //         repeat
    //             //if not ShipmentHeaderHybris.Get(SalesShipmentHeader."No.") then begin
    //             ShipmentHeaderHybrisBuffer.Init();
    //             ShipmentHeaderHybrisBuffer."Shipment ID" := SalesShipmentHeader."No.";
    //             ShipmentHeaderHybrisBuffer."Shipment Date" := SalesShipmentHeader."Posting Date";
    //             ShipmentHeaderHybrisBuffer."Location Code" := SalesShipmentHeader."Location Code";
    //             ShipmentHeaderHybrisBuffer."Order No." := SalesShipmentHeader."Order No.";
    //             ShipmentHeaderHybrisBuffer."Package Tracking No." := SalesShipmentHeader."Package Tracking No.";
    //             ShipmentHeaderHybrisBuffer."Ship-to Code" := SalesShipmentHeader."Ship-to Code";
    //             ShipmentHeaderHybrisBuffer."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
    //             ShipmentHeaderHybrisBuffer.Status := 'Shipped';
    //             ShipmentHeaderHybrisBuffer.Insert(true);
    //         //end;
    //         until SalesShipmentHeader.Next() = 0;
    // end;

    // procedure InsertSalesShipmentToShipmentUpdateSFDC()
    // var
    //     SalesShipmentHeader: Record "Sales Shipment Header";
    //     SalesShipmentLine: Record "Sales Shipment Line";

    //     ShipmentHeaderSFDC: Record "Shipment Header SFDC Buffer";
    //     ShipmentLineSFDC: Record "Shipment Line SFDC Buffer";

    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     TargetDate: Date;
    // begin
    //     //StartDateTime := CreateDateTime(Today(), 0T);
    //     //EndDateTime := CreateDateTime(Today(), 235959.999T);
    //     TargetDate := CalcDate('<-2M>', Today);
    //     SalesShipmentHeader.reset;
    //     SalesShipmentHeader.SetFilter("Posting Date", '%1..%2', TargetDate, Today());
    //     //SalesShipmentHeader.SetFilter(SystemCreatedAt, '%1..%2', StartDateTime, EndDateTime);
    //     //SalesShipmentHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesShipmentHeader.FindSet() then
    //         repeat
    //             if not ShipmentHeaderSFDC.Get(SalesShipmentHeader."No.") then begin
    //                 ShipmentHeaderSFDC.Init();
    //                 ShipmentHeaderSFDC."Shipment ID" := SalesShipmentHeader."No.";
    //                 ShipmentHeaderSFDC."Shipment Status" := 'Shipped';
    //                 ShipmentHeaderSFDC."Shipment Date" := SalesShipmentHeader."Posting Date";
    //                 ShipmentHeaderSFDC."Package Tracking No." := SalesShipmentHeader."Package Tracking No.";
    //                 ShipmentHeaderSFDC."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
    //                 ShipmentHeaderSFDC."Order No." := SalesShipmentHeader."Order No.";
    //                 ShipmentHeaderSFDC."Total Charge" := 0;
    //                 ShipmentHeaderSFDC.Insert(true);
    //             end;

    //             SalesShipmentLine.reset;
    //             SalesShipmentLine.setrange("Document No.", SalesShipmentHeader."No.");
    //             if SalesShipmentLine.FindSet() then begin
    //                 repeat
    //                     ShipmentLineSFDC."Shipment ID" := SalesShipmentLine."Document No.";
    //                     ShipmentLineSFDC."Line No." := SalesShipmentLine."Line No.";
    //                     ShipmentLineSFDC."Sales Order Line No." := SalesShipmentLine."Order Line No.";
    //                     ShipmentLineSFDC."No." := SalesShipmentLine."No.";
    //                     ShipmentLineSFDC.Quantity := SalesShipmentLine.Quantity;
    //                     ShipmentLineSFDC."Total Amount" := 0;
    //                     ShipmentLineSFDC."Co Release" := 0;
    //                     ShipmentLineSFDC.insert();
    //                 until SalesShipmentLine.Next() = 0;
    //             end;
    //         until SalesShipmentHeader.Next() = 0;
    // end;

    // procedure InsertInventoryUpdateHybris()
    // var
    //     ItemLedgerEntry: Record "Item Ledger Entry";
    //     InventoryUpdateHybrisBuffer: Record "Inventory Update Hybris Buffer";
    //     LineNo: Integer;
    // begin
    //     InventoryUpdateHybrisBuffer.DeleteAll();
    //     ItemLedgerEntry.reset;
    //     ItemLedgerEntry.setrange(Open, True);
    //     ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
    //     if ItemLedgerEntry.FindSet() then
    //         repeat
    //             LineNo := LineNo + 1;
    //             InventoryUpdateHybrisBuffer.Init();
    //             InventoryUpdateHybrisBuffer."Entry No." := LineNo;
    //             InventoryUpdateHybrisBuffer."Item No." := ItemLedgerEntry."Item No.";
    //             InventoryUpdateHybrisBuffer."Location Code" := ItemLedgerEntry."Location Code";
    //             InventoryUpdateHybrisBuffer."Remaining Qty." := ItemLedgerEntry."Remaining Quantity";
    //             InventoryUpdateHybrisBuffer."IN Stock Status" := 'forceInStock';
    //             InventoryUpdateHybrisBuffer."Max Pre-Order" := 1;
    //             InventoryUpdateHybrisBuffer."Max Stock Level History Count" := -1;
    //             InventoryUpdateHybrisBuffer.Overselling := 0;
    //             InventoryUpdateHybrisBuffer."Pre Order" := 0;
    //             InventoryUpdateHybrisBuffer.Reserved := 0;
    //             InventoryUpdateHybrisBuffer.Insert();
    //         until ItemLedgerEntry.Next() = 0;
    // end;

    // procedure InsertSalesCreditMemoToReturnOrdertoHybrisBuffer()
    // var
    //     SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    //     ReturnOrdertoHybrisBuffer: Record "Return Order to Hybris Buffer";

    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     TargetDate: Date;
    // begin
    //     ReturnOrdertoHybrisBuffer.DeleteAll();
    //     TargetDate := CalcDate('<-2M>', Today);
    //     SalesCrMemoHeader.reset;
    //     SalesCrMemoHeader.Setrange("Posting Date", TargetDate, Today());
    //     //SalesCrMemoHeader.SetFilter(SystemCreatedAt, '%1..%2', StartDateTime, EndDateTime);
    //     //SalesCrMemoHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesCrMemoHeader.FindSet() then
    //         repeat
    //             if not ReturnOrdertoHybrisBuffer.get(SalesCrMemoHeader."No.") then begin
    //                 ReturnOrdertoHybrisBuffer.Init();
    //                 ReturnOrdertoHybrisBuffer."Return Order No." := SalesCrMemoHeader."No.";
    //                 //"O=Open / A=Active / X=Cancelled / C=Completed
    //                 ReturnOrdertoHybrisBuffer.Status := 'C';
    //                 ReturnOrdertoHybrisBuffer.Insert(true);
    //             end;
    //         until SalesCrMemoHeader.Next() = 0;
    // end;

    // procedure InsertSalesHeaderToReturnOrdertoSFDCBuffer()
    // var
    //     SalesHeader: Record "Sales Header";
    //     SalesLine: Record "Sales Line";
    //     ReturnOrderHeadSFDCBuffer: Record "Return Order Head SFDC Buffer";
    //     ReturnOrderLineSFDCBuffer: Record "Return Order Line SFDC Buffer";

    //     StartDateTime: DateTime;
    //     EndDateTime: DateTime;
    //     TargetDate: Date;
    // begin
    //     ReturnOrderHeadSFDCBuffer.DeleteAll();
    //     ReturnOrderLineSFDCBuffer.DeleteAll();

    //     TargetDate := CalcDate('<-12M>', Today);
    //     SalesHeader.reset;
    //     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
    //     SalesHeader.SetRange("Posting Date", TargetDate, Today());
    //     //SalesHeader.SetFilter(SystemCreatedAt, '%1..%2', StartDateTime, EndDateTime);
    //     //SalesHeader.SetFilter(SystemModifiedAt, '%1..%2', StartDateTime, EndDateTime);
    //     if SalesHeader.FindSet() then begin
    //         repeat
    //             if not ReturnOrderHeadSFDCBuffer.get(SalesHeader."No.") then begin
    //                 ReturnOrderHeadSFDCBuffer.Init();
    //                 ReturnOrderHeadSFDCBuffer."Doc No." := SalesHeader."No.";
    //                 ReturnOrderHeadSFDCBuffer."Posting Date" := SalesHeader."Posting Date";
    //                 ReturnOrderHeadSFDCBuffer."RMA Status" := '';
    //                 ReturnOrderHeadSFDCBuffer."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
    //                 ReturnOrderHeadSFDCBuffer."Ship-to Name" := SalesHeader."Ship-to Name";
    //                 ReturnOrderHeadSFDCBuffer."Sell-to Contact" := SalesHeader."Sell-to Contact";
    //                 ReturnOrderHeadSFDCBuffer."Sell-to Phone" := SalesHeader."Sell-to Phone No.";
    //                 ReturnOrderHeadSFDCBuffer."Taken By" := '';
    //                 ReturnOrderHeadSFDCBuffer."Tax Area Code" := SalesHeader."Tax Area Code";
    //                 ReturnOrderHeadSFDCBuffer."Sales Tax" := 0;
    //                 ReturnOrderHeadSFDCBuffer."Sales Tax T" := 0;
    //                 ReturnOrderHeadSFDCBuffer.Freight := 0;
    //                 ReturnOrderHeadSFDCBuffer."Freight T" := 0;
    //                 ReturnOrderHeadSFDCBuffer."Misc Charges" := 0;
    //                 ReturnOrderHeadSFDCBuffer."Location Code" := SalesHeader."Location Code";
    //                 ReturnOrderHeadSFDCBuffer."Ship-to Code" := SalesHeader."Ship-to Code";
    //                 ReturnOrderHeadSFDCBuffer."Problem Code" := '';
    //                 ReturnOrderHeadSFDCBuffer."Total Credit" := 0;
    //                 ReturnOrderHeadSFDCBuffer."Shipment Method Code" := SalesHeader."Shipment Method Code";
    //                 ReturnOrderHeadSFDCBuffer."Include Tax in Price" := 0;
    //                 ReturnOrderHeadSFDCBuffer."Applies-to Doc. No" := SalesHeader."Applies-to Doc. No.";
    //                 ReturnOrderHeadSFDCBuffer."Location Code 1" := SalesHeader."Location Code";
    //                 ReturnOrderHeadSFDCBuffer."Amount Incl VAT" := SalesHeader."Amount Including VAT";
    //                 ReturnOrderHeadSFDCBuffer."HRC No." := '';
    //                 ReturnOrderHeadSFDCBuffer."SFDC Call Log ID" := '';
    //                 ReturnOrderHeadSFDCBuffer."Sales Order No." := SalesHeader."No.";
    //                 ReturnOrderHeadSFDCBuffer.Insert(true);
    //             end;
    //             SalesLine.reset;
    //             SalesLine.setrange("Document Type", SalesHeader."Document Type");
    //             SalesLine.setrange("Document No.", SalesHeader."No.");
    //             if SalesLine.FindSet() then begin
    //                 repeat
    //                     ReturnOrderLineSFDCBuffer."Doc No." := SalesLine."Document No.";
    //                     ReturnOrderLineSFDCBuffer."Line No." := SalesLine."Line No.";
    //                     ReturnOrderLineSFDCBuffer."Item No." := SalesLine."No.";
    //                     ReturnOrderLineSFDCBuffer.Description := SalesLine.Description;
    //                     ReturnOrderLineSFDCBuffer.Quantity := SalesLine.Quantity;
    //                     ReturnOrderLineSFDCBuffer."Authorized By" := '';
    //                     ReturnOrderLineSFDCBuffer."Call Log Line" := SalesLine."Line No.";
    //                     ReturnOrderLineSFDCBuffer."CO Release" := 0;
    //                     ReturnOrderLineSFDCBuffer."Currency Code" := SalesHeader."Currency Code";
    //                     ReturnOrderLineSFDCBuffer."Line Amount" := SalesLine."Line Amount";
    //                     ReturnOrderLineSFDCBuffer."Customer Item" := SalesLine."No.";
    //                     ReturnOrderLineSFDCBuffer.Stat := 'C'; // O=Opened, F=Filled, C=Closed
    //                     ReturnOrderLineSFDCBuffer."Return Quantity" := SalesLine.Quantity;
    //                     ReturnOrderLineSFDCBuffer.UOM := SalesLine."Unit of Measure";
    //                     ReturnOrderLineSFDCBuffer."Restock Fee Pct" := 0;
    //                     ReturnOrderLineSFDCBuffer."Restock Fee Amt" := 0;
    //                     ReturnOrderLineSFDCBuffer."Return Item" := 1;
    //                     ReturnOrderLineSFDCBuffer."Disposition Code" := 0;
    //                     ReturnOrderLineSFDCBuffer.Warranty := 0;
    //                     ReturnOrderLineSFDCBuffer."Tax Area Code" := SalesHeader."Tax Area Code";
    //                     ReturnOrderLineSFDCBuffer."Quantity Credited" := SalesLine."Quantity";
    //                     ReturnOrderLineSFDCBuffer."Quantity Received" := SalesLine."Quantity";
    //                     ReturnOrderLineSFDCBuffer."Accum. Restock Fee" := 0;
    //                     ReturnOrderLineSFDCBuffer."Last Return Date" := 0;
    //                     ReturnOrderLineSFDCBuffer."Last Return Date" := 0;
    //                     ReturnOrderLineSFDCBuffer."Original Invoice" := SalesHeader."No.";
    //                     ReturnOrderLineSFDCBuffer."Return Reason Code" := SalesHeader."Reason Code";
    //                     ReturnOrderLineSFDCBuffer."Customer Item" := SalesLine."No.";
    //                     ReturnOrderLineSFDCBuffer."Long Description" := SalesLine.Description;
    //                     ReturnOrderLineSFDCBuffer."Line Amount" := SalesLine."Line Amount";
    //                     ReturnOrderLineSFDCBuffer."Authorized By" := '';
    //                     ReturnOrderLineSFDCBuffer."Evaluation Code" := '';
    //                     ReturnOrderLineSFDCBuffer."Line Amount" := SalesLine."Line Amount";
    //                     ReturnOrderLineSFDCBuffer."Location Code" := SalesLine."Location Code";
    //                     ReturnOrderLineSFDCBuffer."Currency Code" := SalesHeader."Currency Code";
    //                     ReturnOrderLineSFDCBuffer."Call Log Line" := SalesLine."Line No.";
    //                     ReturnOrderLineSFDCBuffer.Insert(true);
    //                 until SalesLine.Next() = 0;
    //             end;
    //         until SalesHeader.Next() = 0;
    //     End;
    // End;
}

//-----------------------------------------------------

//StartDateTime := CreateDateTime(Today(), 0T);
//EndDateTime := CreateDateTime(Today(), 235959.999T);

//-----------------------------------------------------

