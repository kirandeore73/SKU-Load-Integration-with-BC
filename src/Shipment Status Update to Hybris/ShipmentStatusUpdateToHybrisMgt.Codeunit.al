codeunit 72033 "Shipment Status to Hybris Mgt"
{
    Permissions = tabledata "ShipStatusUpdToHybrisHdrBuff" = RIMD,
                  tabledata "ShipStatusUpdToHybrisLineBuff" = RIMD,
                  tabledata "Sales Shipment Header" = R,
                  tabledata "Sales Shipment Line" = R;

    procedure DeleteAllShipmentStatusHybrisBuffers(): Integer
    var
        ShipmentLineBuffer: Record "ShipStatusUpdToHybrisLineBuff";
        ShipmentHeaderBuffer: Record "ShipStatusUpdToHybrisHdrBuff";
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
        ShipmentHeaderBuffer: Record "ShipStatusUpdToHybrisHdrBuff";
        ShipmentLineBuffer: Record "ShipStatusUpdToHybrisLineBuff";
    begin
        if ShipmentHeaderBuffer.Get(SalesShipmentHeader."No.") then begin
            ShipmentHeaderBuffer."Shipment Status" := 'SHIPPED';
            ShipmentHeaderBuffer."Hybris Order No." := SalesShipmentHeader."EDI Web Order No.";
            ShipmentHeaderBuffer."Hybris Address ID" := SalesShipmentHeader."EDI Address Id";
            ShipmentHeaderBuffer."Warehouse Code" := SalesShipmentHeader."Location Code";
            ShipmentHeaderBuffer."Tracking Number" := SalesShipmentHeader."Package Tracking No.";
            ShipmentHeaderBuffer."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
            ShipmentHeaderBuffer."Ship Date" := FormatShipDate(SalesShipmentHeader."Shipment Date");
            ShipmentHeaderBuffer."Last Updated DateTime" := CurrentDateTime;
            ShipmentHeaderBuffer.Modify(true);
        end else begin
            ShipmentHeaderBuffer.Init();
            ShipmentHeaderBuffer."Shipment ID" := SalesShipmentHeader."No.";
            ShipmentHeaderBuffer."Shipment Status" := 'SHIPPED';
            ShipmentHeaderBuffer."Hybris Order No." := SalesShipmentHeader."EDI Web Order No.";
            ShipmentHeaderBuffer."Hybris Address ID" := SalesShipmentHeader."EDI Address Id";
            ShipmentHeaderBuffer."Warehouse Code" := SalesShipmentHeader."Location Code";
            ShipmentHeaderBuffer."Tracking Number" := SalesShipmentHeader."Package Tracking No.";
            ShipmentHeaderBuffer."Shipment Method Code" := SalesShipmentHeader."Shipment Method Code";
            ShipmentHeaderBuffer."Ship Date" := FormatShipDate(SalesShipmentHeader."Shipment Date");
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
                ShipmentLineBuffer.HybrisOrderLineNo := SalesShipmentHeader."EDI Web Order No." + ':' + Format(SalesShipmentLine."SAP Sales Order Item ID");
                ShipmentLineBuffer."Line No." := SalesShipmentLine."Line No.";
                ShipmentLineBuffer.QuantityOrdered := SalesShipmentLine."EDI Quantity Ordered";
                ShipmentLineBuffer."Quantity Shipped" := SalesShipmentLine.Quantity;
                ShipmentLineBuffer.Insert(true);
            until SalesShipmentLine.Next() = 0;
    end;

    local procedure FormatShipDate(ShipDate: Date): Text[10]
    begin
        if ShipDate = 0D then
            exit('');

        exit(Format(ShipDate, 0, '<Month,2>/<Day,2>/<Year4>'));
    end;
}
