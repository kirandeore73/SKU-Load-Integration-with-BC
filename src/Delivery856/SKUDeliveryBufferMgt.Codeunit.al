codeunit 72006 "SKU Delivery Buffer Mgt"
{
    // Management codeunit for SKU Delivery Buffer - follows the pattern of 
    // "Graph Mgt - Sales Order Buffer" from standard Business Central
    Permissions = tabledata "SKU Delivery Buffer" = RIMD,
                  tabledata "SKU Delivery Line Buffer" = RIMD,
                  tabledata "Sales Shipment Header" = R,
                  tabledata "Sales Shipment Line" = R,
                  tabledata SKUIntegrationSetup = RIMD;

    var
        AppTexts: Codeunit "SKUAppTexts";

    procedure PropagateOnInsert(var DeliveryBuffer: Record "SKU Delivery Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        // For 856, we typically load from existing shipment, so insert is minimal
        if DeliveryBuffer."Shipment No." <> '' then
            LoadFromShipment(DeliveryBuffer);
    end;

    procedure PropagateOnModify(var DeliveryBuffer: Record "SKU Delivery Buffer"; var TempFieldBuffer: Record "Field Buffer" temporary)
    begin
        // Update the buffer record with any changes
        DeliveryBuffer."Last Modified Date Time" := CurrentDateTime;
    end;

    procedure PropagateOnDelete(var DeliveryBuffer: Record "SKU Delivery Buffer")
    var
        DeliveryLineBuffer: Record "SKU Delivery Line Buffer";
    begin
        // Delete associated lines
        DeliveryLineBuffer.SetRange("Document Id", DeliveryBuffer.Id);
        DeliveryLineBuffer.DeleteAll(true);
    end;

    procedure DeleteAllDeliveryBuffers(): Integer
    var
        DeliveryBuffer: Record "SKU Delivery Buffer";
        DeliveryLineBuffer: Record "SKU Delivery Line Buffer";
        Counter: Integer;
    begin
        DeliveryLineBuffer.Reset();
        if DeliveryLineBuffer.FindSet(true) then
            repeat
                DeliveryLineBuffer.Delete(true);
            until DeliveryLineBuffer.Next() = 0;

        DeliveryBuffer.Reset();
        if DeliveryBuffer.FindSet() then
            repeat
                Counter += 1;
                DeliveryBuffer.Delete(true);
            until DeliveryBuffer.Next() = 0;

        exit(Counter);
    end;

    procedure CreateTemporaryTestDeliveryBuffer()
    var
        DeliveryBuffer: Record "SKU Delivery Buffer";
        DeliveryLineBuffer: Record "SKU Delivery Line Buffer";
        CreationDateTime: DateTime;
        DeliveryDateTime: DateTime;
    begin
        DeliveryBuffer.SetRange("Shipment No.", 'S-SHPT152956');
        if DeliveryBuffer.FindFirst() then begin
            DeliveryLineBuffer.SetRange("Document Id", DeliveryBuffer.Id);
            DeliveryLineBuffer.DeleteAll(true);
            DeliveryBuffer.Delete(true);
        end;

        DeliveryBuffer.Init();
        DeliveryBuffer."Shipment No." := 'SHPT152956';
        DeliveryBuffer."SAP Purchase Order No." := '4500019250';
        Evaluate(CreationDateTime, '2026-09-08T16:44:34.23Z');
        Evaluate(DeliveryDateTime, '2026-09-08T00:00:00Z');
        DeliveryBuffer."Creation DateTime" := CreationDateTime;
        DeliveryBuffer."Delivery DateTime" := DeliveryDateTime;
        DeliveryBuffer."Sender Internal ID" := '1711';
        DeliveryBuffer."Recipient Internal ID" := '1057084';
        deliveryBuffer."Package Tracking No." := 'TRK_S158057';

        DeliveryBuffer.Insert(true);

        DeliveryLineBuffer.Init();
        DeliveryLineBuffer."Delivery Entry No." := DeliveryBuffer."Entry No.";
        DeliveryLineBuffer."Line No." := 10000;
        DeliveryLineBuffer."Document Id" := DeliveryBuffer.Id;
        DeliveryLineBuffer."Buyer Product ID" := 'A10004023';
        DeliveryLineBuffer.Quantity := 1.00;
        DeliveryLineBuffer."Unit of Measure Code" := 'EA';
        DeliveryLineBuffer."SAP Purchase Order No." := '4500019250';
        DeliveryLineBuffer."SAP PO Line No." := 10;
        DeliveryLineBuffer."SAP Sales Order No." := 'FP00018358';
        DeliveryLineBuffer.Insert(true);
    end;

    procedure LoadFromShipment(var DeliveryBuffer: Record "SKU Delivery Buffer"): Boolean
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if DeliveryBuffer."Shipment No." = '' then
            exit(false);

        if not SalesShipmentHeader.Get(DeliveryBuffer."Shipment No.") then
            exit(false);

        if not SalesShipmentHeader."Created From EDI 850" then
            exit(false);

        DeliveryBuffer."Shipment Id" := SalesShipmentHeader.SystemId;

        DeliveryBuffer."SAP Purchase Order No." := SalesShipmentHeader."SAP Purchase Order No.";
        DeliveryBuffer."Posting Date" := SalesShipmentHeader."Posting Date";
        DeliveryBuffer."Creation DateTime" := SalesShipmentHeader.SystemCreatedAt;
        DeliveryBuffer."Delivery DateTime" := CreateDateTime(SalesShipmentHeader."Posting Date", 053000T);
        DeliveryBuffer."Package Tracking No." := SalesShipmentHeader."Package Tracking No."; // 'TRK_S158060';

        DeliveryBuffer."Sender Internal ID" := SalesShipmentHeader."SAP Sender Internal ID";
        DeliveryBuffer."Tax Jurisdiction Code" := SalesShipmentHeader."EDI Tax Jurisdiction Code";

        DeliveryBuffer."Recipient Internal ID" := SalesShipmentHeader."SAP Recipient Internal ID";

        exit(true);
    end;

    procedure LoadLinesFromShipment(DeliveryBuffer: Record "SKU Delivery Buffer")
    var
        DeliveryLineBuffer: Record "SKU Delivery Line Buffer";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        Item: Record Item;
        LineNo: Integer;
    begin
        // Clear existing lines
        DeliveryLineBuffer.SetRange("Document Id", DeliveryBuffer.Id);
        DeliveryLineBuffer.DeleteAll();

        if not SalesShipmentHeader.Get(DeliveryBuffer."Shipment No.") then
            exit;

        SalesShipmentLine.SetRange("Document No.", DeliveryBuffer."Shipment No.");
        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

        if SalesShipmentLine.FindSet() then
            repeat
                LineNo += 10000;
                DeliveryLineBuffer.Init();
                DeliveryLineBuffer."Delivery Entry No." := DeliveryBuffer."Entry No.";
                DeliveryLineBuffer."Line No." := LineNo;
                DeliveryLineBuffer."Document Id" := DeliveryBuffer.Id;
                if Item.Get(SalesShipmentLine."No.") then
                    DeliveryLineBuffer."Buyer Product ID" := Item."Buyer Product ID";
                DeliveryLineBuffer.Quantity := SalesShipmentLine.Quantity;
                DeliveryLineBuffer."Unit of Measure Code" := SalesShipmentLine."Unit of Measure Code";
                DeliveryLineBuffer."SAP Purchase Order No." := SalesShipmentHeader."SAP Purchase Order No.";
                DeliveryLineBuffer."SAP PO Line No." := SalesShipmentLine."SAP PO Line No.";
                DeliveryLineBuffer."SAP Sales Order No." := SalesShipmentLine."SAP Sales Order No.";
                DeliveryLineBuffer.Insert(true);
            until SalesShipmentLine.Next() = 0;
    end;
}
