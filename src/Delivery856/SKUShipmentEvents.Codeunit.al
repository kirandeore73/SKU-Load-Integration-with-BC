codeunit 72003 "SKUShipmentFieldCopyMgmt"
{
    // Copies the SAP EDI reference fields from the sales order onto the posted shipment
    // during posting, and creates buffer records for outbound 856 processing.
    Permissions = tabledata SKUIntegrationSetup = RIMD,
                  tabledata "SKU Delivery Buffer" = RIMD,
                  tabledata "SKU Delivery Line Buffer" = RIMD,
                  tabledata "Sales Header" = R,
                  tabledata Customer = R,
                  tabledata "Sales Shipment Header" = RM,
                  tabledata "Sales Shipment Line" = RM;
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesShptHeader(var Rec: Record "Sales Shipment Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Order No." = '' then
            exit;

        SalesHeader.SetLoadFields("SAP Purchase Order No.", "SAP Sales Order No.", "SAP Sender Internal ID", "SAP Recipient Internal ID", "Created From EDI 850", "EDI Tax Jurisdiction Code");
        if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.") then
            exit;

        if not SalesHeader."Created From EDI 850" then
            exit;

        Rec."SAP Purchase Order No." := SalesHeader."SAP Purchase Order No.";
        Rec."SAP Sales Order No." := SalesHeader."SAP Sales Order No.";
        Rec."SAP Sender Internal ID" := SalesHeader."SAP Sender Internal ID";
        Rec."SAP Recipient Internal ID" := SalesHeader."SAP Recipient Internal ID";
        Rec."EDI Tax Jurisdiction Code" := SalesHeader."EDI Tax Jurisdiction Code";
        Rec."Created From EDI 850" := SalesHeader."Created From EDI 850";
        Rec."EDI Web Order No." := SalesHeader."EDI Web Order No.";
        Rec."EDI Address Id" := SalesHeader."EDI Address Id";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesShptLine(var Rec: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        if (SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.") and SalesHeader."Created From EDI 850") then begin
            if Rec."Order No." = '' then
                exit;
            // SalesLine.SetLoadFields("Purchase Order No.", "SAP PO Line No.", "SAP Product Code", "SAP Sales Order No.");
            if not SalesLine.Get(SalesLine."Document Type"::Order, Rec."Order No.", Rec."Order Line No.") then
                exit;
            Rec."SAP PO Line No." := SalesLine."SAP PO Line No.";
            Rec."SAP Sales Order No." := SalesLine."SAP Sales Order No.";
            Rec."SAP Sales Order Item ID" := SalesLine."SAP Sales Order Item ID";
            Rec."EDI Quantity Ordered" := SalesLine.Quantity;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ShipmentStatustoSFDCMgt: Codeunit "Shipment Status SFDC Mgt";
        ShipmentStatusToHybrisMgt: Codeunit "Shipment Status to Hybris Mgt";
    begin
        // Create buffer for shipments only
        if SalesHeader."Created From EDI 850" then begin
            if SalesShptHdrNo = '' then
                exit;

            if SalesShipmentHeader.Get(SalesShptHdrNo) then begin
                if not SalesShipmentHeader."Created From EDI 850" then
                    exit;

                CreateDeliveryBuffer(SalesShipmentHeader);
                ShipmentStatustoSFDCMgt.CreateFromPostedShipment(SalesShipmentHeader);
                if SalesShipmentHeader."EDI Web Order No." <> '' then
                    ShipmentStatusToHybrisMgt.CreateFromPostedShipment(SalesShipmentHeader);
            end;
        end;
    end;

    local procedure CreateDeliveryBuffer(SalesShipmentHeader: Record "Sales Shipment Header")
    var
        DeliveryBuffer: Record "SKU Delivery Buffer";
        DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
    begin
        // Check if buffer already exists for this shipment
        DeliveryBuffer.SetRange("Shipment No.", SalesShipmentHeader."No.");
        if not DeliveryBuffer.IsEmpty() then
            exit;

        // Create new buffer record
        DeliveryBuffer.Init();
        DeliveryBuffer."Shipment No." := SalesShipmentHeader."No.";
        if not DeliveryBufferMgt.LoadFromShipment(DeliveryBuffer) then
            exit;
        DeliveryBuffer.Insert(true);

        // Load lines from shipment (lines are now available)
        DeliveryBufferMgt.LoadLinesFromShipment(DeliveryBuffer);
    end;
}
