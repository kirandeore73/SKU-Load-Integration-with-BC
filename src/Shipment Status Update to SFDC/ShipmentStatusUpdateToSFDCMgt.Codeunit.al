codeunit 72032 "Shipment Status SFDC Mgt"
{
    Permissions = tabledata "ShipStatusUpdateToSFDCHdrBuff" = RIMD,
                  tabledata "ShipStatusUpdateToSFDCLineBuff" = RIMD,
                  tabledata "Sales Shipment Header" = R,
                  tabledata "Sales Shipment Line" = R;

    // procedure InsertSalesShipmentToShipmentUpdateSFDC()
    // var
    //     SalesShipmentHeader: Record "Sales Shipment Header";
    // begin
    //     SalesShipmentHeader.Reset();
    //     SalesShipmentHeader.SetFilter("Posting Date", '%1..%2', CalcDate('<-2M>', Today()), Today());
    //     if SalesShipmentHeader.FindSet() then
    //         repeat
    //             CreateFromPostedShipment(SalesShipmentHeader);
    //         until SalesShipmentHeader.Next() = 0;
    // end;

    procedure DeleteAllShipmentStatusSFDCBuffers(): Integer
    var
        ShipmentLineBuffer: Record "ShipStatusUpdateToSFDCLineBuff";
        ShipmentHeaderBuffer: Record "ShipStatusUpdateToSFDCHdrBuff";
        Counter: Integer;
    begin
        ShipmentLineBuffer.Reset();
        if ShipmentLineBuffer.FindSet(true) then
            repeat
                ShipmentLineBuffer.Delete(true);
            until ShipmentLineBuffer.Next() = 0;

        ShipmentHeaderBuffer.Reset();
        if ShipmentHeaderBuffer.FindSet() then
            repeat
                Counter += 1;
                ShipmentHeaderBuffer.Delete(true);
            until ShipmentHeaderBuffer.Next() = 0;

        exit(Counter);
    end;

    procedure CreateFromPostedShipment(SalesShipmentHeader: Record "Sales Shipment Header")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ShipmentHeaderBuffer: Record "ShipStatusUpdateToSFDCHdrBuff";
        ShipmentLineBuffer: Record "ShipStatusUpdateToSFDCLineBuff";
    begin
        if ShipmentHeaderBuffer.Get(SalesShipmentHeader."No.") then begin
            ShipmentHeaderBuffer."Shipment Status" := 'S';
            ShipmentHeaderBuffer."Shipment Date" := CreateDateTime(SalesShipmentHeader."Shipment Date", 0T);
            ShipmentHeaderBuffer."Package Tracking No." := SalesShipmentHeader."Package Tracking No.";
            ShipmentHeaderBuffer."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
            if SalesShipmentHeader."EDI Web Order No." <> '' then
                ShipmentHeaderBuffer."Order No." := SalesShipmentHeader."EDI Web Order No."
            else
                ShipmentHeaderBuffer."Order No." := SalesShipmentHeader."SAP Sales Order No.";
            ShipmentHeaderBuffer."Total Charge" := 0;
            ShipmentHeaderBuffer."Last Updated DateTime" := CurrentDateTime;
            ShipmentHeaderBuffer.Modify(true);
        end else begin
            ShipmentHeaderBuffer.Init();
            ShipmentHeaderBuffer."Shipment ID" := SalesShipmentHeader."No.";
            ShipmentHeaderBuffer."Shipment Status" := 'S';
            ShipmentHeaderBuffer."Shipment Date" := CreateDateTime(SalesShipmentHeader."Shipment Date", 0T);
            ShipmentHeaderBuffer."Package Tracking No." := SalesShipmentHeader."Package Tracking No.";
            ShipmentHeaderBuffer."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
            if SalesShipmentHeader."EDI Web Order No." <> '' then
                ShipmentHeaderBuffer."Order No." := SalesShipmentHeader."EDI Web Order No."
            else
                ShipmentHeaderBuffer."Order No." := SalesShipmentHeader."SAP Sales Order No.";
            ShipmentHeaderBuffer."Total Charge" := 0;
            ShipmentHeaderBuffer."Last Updated DateTime" := CurrentDateTime;
            ShipmentHeaderBuffer.Insert(true);
        end;

        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
        if SalesShipmentLine.FindSet() then
            repeat
                ShipmentLineBuffer.Init();
                ShipmentLineBuffer."Shipment ID" := SalesShipmentLine."Document No.";
                ShipmentLineBuffer."Line No." := SalesShipmentLine."SAP Sales Order Item ID";
                ShipmentLineBuffer."No." := SalesShipmentLine."No.";
                ShipmentLineBuffer.Quantity := SalesShipmentLine.Quantity;
                ShipmentLineBuffer."Shipment Total Charges" := GetShipmentLineChargeAmount(SalesShipmentLine);
                ShipmentLineBuffer.Insert(true);
            until SalesShipmentLine.Next() = 0;
    end;

    local procedure GetShipmentLineChargeAmount(SalesShipmentLine: Record "Sales Shipment Line"): Decimal
    var
        ItemChargeAssignment: Record "Item Charge Assignment (Sales)";
        TotalChargeAmount: Decimal;
    begin
        TotalChargeAmount := 0;

        if SalesShipmentLine."Order No." = '' then
            exit(TotalChargeAmount);

        ItemChargeAssignment.SetRange("Applies-to Doc. Type", ItemChargeAssignment."Applies-to Doc. Type"::Order);
        ItemChargeAssignment.SetRange("Applies-to Doc. No.", SalesShipmentLine."Order No.");
        ItemChargeAssignment.SetRange("Applies-to Doc. Line No.", SalesShipmentLine."Order Line No.");
        ItemChargeAssignment.SetRange("Item No.", SalesShipmentLine."No.");

        if ItemChargeAssignment.FindSet() then
            repeat
                TotalChargeAmount += ItemChargeAssignment."Amount to Assign";
            until ItemChargeAssignment.Next() = 0;

        exit(TotalChargeAmount);
    end;
}
