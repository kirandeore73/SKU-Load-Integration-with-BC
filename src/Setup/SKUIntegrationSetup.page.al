page 72001 "SKUIntegrationSetup"
{
    Caption = 'SKU Integration Setup';
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "SKUIntegrationSetup";
    Permissions = tabledata "SKUIntegrationSetup" = RIMD,
                  tabledata Customer = RM;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Message)
            {
                Caption = 'Message Header Defaults';

                field(SenderInternalID; Rec.SenderInternalID)
                {
                    ToolTip = 'Specifies our own party internal ID, used as the sender on outbound messages.';
                }
                field(RecipientInternalID; Rec.RecipientInternalID)
                {
                    ToolTip = 'Specifies the partner party internal ID, used as the recipient on outbound messages.';
                }
            }
            group(BoomiIntegration)
            {
                Caption = 'Boomi Integration';

                field("Boomi 856 Endpoint URL"; Rec."Boomi 856 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 856 ASN/Delivery data (JSON).';
                }
                field("Boomi 855 Endpoint URL"; Rec."Boomi 855 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 855 Order Confirmation data (JSON).';
                }
                field("Boomi 810 Endpoint URL"; Rec."Boomi 810 Endpoint URL")
                {
                    ToolTip = 'Specifies the Boomi webhook URL for pushing 810 invoice data (XML).';
                }
                field("Test 856 Shipment No."; Rec."Test 856 Shipment No.")
                {
                    ToolTip = 'Specifies one posted shipment to use when testing the 856 integration.';
                }
                field("Test 855 Order No."; Rec."Test 855 Order No.")
                {
                    ToolTip = 'Specifies one sales order to use when testing the 855 integration.';
                }
                field("Test 810 Invoice No."; Rec."Test 810 Invoice No.")
                {
                    ToolTip = 'Specifies one posted sales invoice to use when testing the 810 integration.';
                }
                field("Test 850 Purchase Order ID"; Rec."Test 850 Purchase Order ID")
                {
                    ToolTip = 'Specifies one SAP purchase order ID to use when testing the 850 integration.';
                }
                field("EDI Buyer Party Customer No."; Rec."EDI Buyer Party Customer No.")
                {
                    ToolTip = 'Customer No. to stamp SAP Buyer Party ID onto for EDI 850 resolution.';
                }
                field("EDI Buyer Party ID"; Rec."EDI Buyer Party ID")
                {
                    ToolTip = 'The SAP Buyer Party ID (e.g. 1000030) to assign to the customer above.';
                }
                field("Boomi Auth Type"; Rec."Boomi Auth Type")
                {
                    ToolTip = 'Specifies the authentication type: Basic Auth (username/password) or OAuth 2.0.';
                }
            }
            group(BoomiBasicAuth)
            {
                Caption = 'Boomi Basic Auth';
                Visible = Rec."Boomi Auth Type" = Rec."Boomi Auth Type"::BasicAuth;

                field("Boomi Username"; Rec."Boomi Username")
                {
                    ToolTip = 'Specifies the username for Boomi Basic Authentication.';
                }
                field("Boomi Password"; Rec."Boomi Password")
                {
                    ToolTip = 'Specifies the password for Boomi Basic Authentication.';
                }
            }
            group(BoomiOAuth)
            {
                Caption = 'Boomi OAuth 2.0';
                Visible = Rec."Boomi Auth Type" = Rec."Boomi Auth Type"::OAuth;

                field("Boomi OAuth Token URL"; Rec."Boomi OAuth Token URL")
                {
                    ToolTip = 'Specifies the OAuth 2.0 token endpoint URL.';
                }
                field("Boomi Client ID"; Rec."Boomi Client ID")
                {
                    ToolTip = 'Specifies the OAuth 2.0 Client ID.';
                }
                field("Boomi Client Secret"; Rec."Boomi Client Secret")
                {
                    ToolTip = 'Specifies the OAuth 2.0 Client Secret.';
                }
                field("Boomi OAuth Scope"; Rec."Boomi OAuth Scope")
                {
                    ToolTip = 'Specifies the OAuth 2.0 scope (optional).';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PopulateDeliveryBuffers)
            {
                Caption = 'Populate Delivery Buffers';
                ToolTip = 'Creates delivery buffer records from existing posted sales shipments that are not yet in the buffer.';
                Image = Shipment;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    DeliveryBuffer: Record "SKU Delivery Buffer";
                    DeliveryBufferCheck: Record "SKU Delivery Buffer";
                    DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
                    ProgressDialog: Dialog;
                    Counter: Integer;
                    TotalToProcess: Integer;
                begin
                    // Filter from July 1, 2026 to today
                    SalesShipmentHeader.SetFilter("Posting Date", '%1..%2', DMY2Date(1, 7, 2026), Today);
                    TotalToProcess := SalesShipmentHeader.Count();

                    if not Confirm('This will create delivery buffer records for %1 shipments (Jul 1, 2026 to today). Continue?', false, TotalToProcess) then
                        exit;

                    ProgressDialog.Open('Processing shipment #1 of #2...', Counter, TotalToProcess);

                    if SalesShipmentHeader.FindSet() then
                        repeat
                            Counter += 1;
                            ProgressDialog.Update(1, Counter);

                            DeliveryBufferCheck.Reset();
                            DeliveryBufferCheck.SetRange("Shipment No.", SalesShipmentHeader."No.");
                            if DeliveryBufferCheck.IsEmpty() then begin
                                Clear(DeliveryBuffer);
                                DeliveryBuffer.Init();
                                DeliveryBuffer."Shipment No." := SalesShipmentHeader."No.";
                                if DeliveryBufferMgt.LoadFromShipment(DeliveryBuffer) then begin
                                    DeliveryBuffer.Insert(true);
                                    DeliveryBufferMgt.LoadLinesFromShipment(DeliveryBuffer);
                                end;
                            end;
                        until SalesShipmentHeader.Next() = 0;

                    ProgressDialog.Close();
                    Message('%1 shipments processed.', Counter);
                end;
            }
            action(PopulateOneDeliveryBuffer)
            {
                Caption = 'Populate One Delivery Buffer';
                ToolTip = 'Creates one delivery buffer from a specified posted sales shipment.';
                Image = Shipment;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    DeliveryBuffer: Record "SKU Delivery Buffer";
                    DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
                begin
                    Rec.TestField("Test 856 Shipment No.");

                    if not FindPostedShipment(SalesShipmentHeader, Rec."Test 856 Shipment No.") then
                        Error('Posted shipment %1 was not found.', Rec."Test 856 Shipment No.");

                    DeliveryBuffer.SetRange("Shipment No.", SalesShipmentHeader."No.");
                    if not DeliveryBuffer.IsEmpty() then begin
                        Message('Delivery buffer already exists for shipment %1.', SalesShipmentHeader."No.");
                        exit;
                    end;

                    DeliveryBuffer.Init();
                    DeliveryBuffer."Shipment No." := SalesShipmentHeader."No.";
                    if not DeliveryBufferMgt.LoadFromShipment(DeliveryBuffer) then
                        Error('Posted shipment %1 was not created from an EDI 850 order.', SalesShipmentHeader."No.");
                    DeliveryBuffer.Insert(true);
                    DeliveryBufferMgt.LoadLinesFromShipment(DeliveryBuffer);
                    Message('Delivery buffer created for shipment %1.', SalesShipmentHeader."No.");
                end;
            }
            action(PopulateTemporaryTestDeliveryBuffer)
            {
                Caption = 'Populate Temporary 856 SAP Test Buffer';
                ToolTip = 'Replaces one delivery buffer with the temporary SAP test payload.';
                Image = TestFile;

                trigger OnAction()
                var
                    DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
                begin
                    DeliveryBufferMgt.CreateTemporaryTestDeliveryBuffer();
                    Message('Temporary 856 SAP test buffer created for shipment S-SHPT152950.');
                end;
            }
            action(ClearDeliveryBuffers)
            {
                Caption = 'Clear All Delivery Buffers';
                ToolTip = 'Deletes all 856 delivery headers and lines from the integration buffers.';
                Image = Delete;

                trigger OnAction()
                var
                    DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all 856 delivery buffers and lines? This cannot be undone.', false) then
                        exit;

                    Counter := DeliveryBufferMgt.DeleteAllDeliveryBuffers();
                    Message('%1 delivery buffers deleted.', Counter);
                end;
            }
            action(ClearShipmentStatusSFDCBuffers)
            {
                Caption = 'Clear All Shipment Status SFDC Buffers';
                ToolTip = 'Deletes all shipment status update to SFDC header and line records from the integration buffers.';
                Image = Delete;

                trigger OnAction()
                var
                    ShipmentStatusSFDCMgt: Codeunit "Shipment Status SFDC Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all shipment status update to SFDC buffers and lines? This cannot be undone.', false) then
                        exit;

                    Counter := ShipmentStatusSFDCMgt.DeleteAllShipmentStatusSFDCBuffers();
                    Message('%1 shipment status SFDC buffers deleted.', Counter);
                end;
            }
            action(ClearOrderStatusSFDCBuffers)
            {
                Caption = 'Clear All Order Status SFDC Buffers';
                ToolTip = 'Deletes all order status update to SFDC header and line records from the integration buffers.';
                Image = Delete;

                trigger OnAction()
                var
                    OrderStatusSFDCMgt: Codeunit "Order Status SFDC Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all order status update to SFDC buffers and lines? This cannot be undone.', false) then
                        exit;

                    Counter := OrderStatusSFDCMgt.DeleteAllOrderStatusSFDCBuffers();
                    Message('%1 order status SFDC buffers deleted.', Counter);
                end;
            }
            action(RunInventoryFullUpdateHybris)
            {
                Caption = 'Run Inventory Full Update (Hybris)';
                ToolTip = 'Recalculates available on hand qty for every item into the inventory snapshot buffer.';
                Image = Refresh;

                trigger OnAction()
                var
                    InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
                begin
                    InventoryUpdateHybrisMgt.RunFullInventoryUpdate();
                    Message('Inventory snapshot buffer refreshed for all items.');
                end;
            }
            action(RunInventoryDeltaUpdateHybris)
            {
                Caption = 'Run Inventory Delta Update (Hybris)';
                ToolTip = 'Stages only items whose available on hand qty changed since the last run.';
                Image = Refresh;

                trigger OnAction()
                var
                    InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
                begin
                    InventoryUpdateHybrisMgt.RunDeltaInventoryUpdate();
                    Message('Inventory delta buffer updated with changed items.');
                end;
            }
            action(ClearInventorySnapshotHybrisBuffers)
            {
                Caption = 'Clear Inventory Snapshot Buffer (Hybris)';
                ToolTip = 'Deletes all rows from the inventory snapshot buffer.';
                Image = Delete;

                trigger OnAction()
                var
                    InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all inventory snapshot buffer rows? This cannot be undone.', false) then
                        exit;

                    Counter := InventoryUpdateHybrisMgt.DeleteAllInventorySnapshotBuffers();
                    Message('%1 inventory snapshot buffer rows deleted.', Counter);
                end;
            }
            action(ClearInventoryDeltaHybrisBuffers)
            {
                Caption = 'Clear Inventory Delta Buffer (Hybris)';
                ToolTip = 'Deletes all rows from the inventory delta buffer.';
                Image = Delete;

                trigger OnAction()
                var
                    InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all inventory delta buffer rows? This cannot be undone.', false) then
                        exit;

                    Counter := InventoryUpdateHybrisMgt.DeleteAllInventoryDeltaBuffers();
                    Message('%1 inventory delta buffer rows deleted.', Counter);
                end;
            }
            action(PopulateOrderConfBuffers)
            {
                Caption = 'Populate Order Confirmation Buffers';
                ToolTip = 'Creates order confirmation buffer records from existing sales orders.';
                Image = Document;

                trigger OnAction()
                var
                    OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
                    FromDate: Date;
                    ToDate: Date;
                    Counter: Integer;
                begin
                    FromDate := DMY2Date(1, 7, 2026);
                    ToDate := Today;

                    if not Confirm('This will create order confirmation buffers for Sales Orders from %1 to %2. Continue?', false, FromDate, ToDate) then
                        exit;

                    Counter := OrderConfBufferMgt.PopulateFromAllSalesOrders(FromDate, ToDate);
                    Message('%1 order confirmation records created/updated.', Counter);
                end;
            }
            action(PushUnsent855ToBoomi)
            {
                Caption = 'Push Unsent 855 to Boomi';
                ToolTip = 'Pushes all unsent order confirmation records to the Boomi endpoint.';
                Image = SendTo;

                trigger OnAction()
                var
                    OrderConfPush: Codeunit "SKU Order Conf Push";
                    SuccessCount: Integer;
                begin
                    Rec.TestField("Boomi 855 Endpoint URL");
                    SuccessCount := OrderConfPush.PushAllUnsent();
                    Message('%1 order confirmations pushed to Boomi.', SuccessCount);
                end;
            }
            action(PopulateOneOrderConfBuffer)
            {
                Caption = 'Populate One Order Confirmation Buffer';
                ToolTip = 'Creates one order confirmation buffer from a specified sales order.';
                Image = Document;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    OrderConfBuffer: Record "SKU Order Conf Buffer";
                    OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
                begin
                    Rec.TestField("Test 855 Order No.");

                    if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Test 855 Order No.") then
                        Error('Sales order %1 was not found.', Rec."Test 855 Order No.");

                    OrderConfBuffer.SetRange("Order No.", Rec."Test 855 Order No.");
                    if not OrderConfBuffer.IsEmpty() then begin
                        Message('Order confirmation buffer already exists for order %1.', Rec."Test 855 Order No.");
                        exit;
                    end;

                    OrderConfBufferMgt.CreateFromSalesOrder(SalesHeader);
                    Message('Order confirmation buffer created for order %1.', Rec."Test 855 Order No.");
                end;
            }
            action(ClearOrderConfBuffers)
            {
                Caption = 'Clear All Order Confirmation Buffers';
                ToolTip = 'Deletes all 855 order confirmation headers and lines from the integration buffers.';
                Image = Delete;

                trigger OnAction()
                var
                    OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all 855 order confirmation buffers and lines? This cannot be undone.', false) then
                        exit;

                    Counter := OrderConfBufferMgt.DeleteAllOrderConfBuffers();
                    Message('%1 order confirmation buffers deleted.', Counter);
                end;
            }
            action(SetBuyerPartyId)
            {
                Caption = 'Set SAP Buyer Party ID on Customer';
                ToolTip = 'Writes the SAP Buyer Party ID directly onto the selected customer, bypassing the Customer card.';
                Image = Customer;

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Rec.TestField("EDI Buyer Party Customer No.");
                    Rec.TestField("EDI Buyer Party ID");

                    Customer.Get(Rec."EDI Buyer Party Customer No.");
                    Customer."SAP Buyer Party ID" := Rec."EDI Buyer Party ID";
                    Customer.Modify();

                    Message('SAP Buyer Party ID ''%1'' set on customer %2 - %3.',
                        Rec."EDI Buyer Party ID",
                        Customer."No.",
                        Customer.Name);
                end;
            }
            action(Populate850Buffer)
            {
                Caption = 'Populate Test 850 Order Buffer';
                ToolTip = 'Creates one staged 850 order with two lines for testing.';
                Image = Document;

                trigger OnAction()
                var
                    OrderBuffer: Record "SKU 850 Order Buffer";
                    OrderLineBuffer: Record "SKU 850 Order Line Buffer";
                    OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
                    Item: Record Item;
                    SecondItem: Record Item;
                begin
                    Rec.TestField("Test 850 Purchase Order ID");

                    if not Item.FindFirst() then
                        Error('At least one item must exist before populating the test 850 buffer.');
                    SecondItem := Item;
                    if SecondItem.Next() = 0 then
                        SecondItem := Item;

                    OrderBuffer.SetRange("Purchase Order ID", Rec."Test 850 Purchase Order ID");
                    if not OrderBuffer.IsEmpty() then begin
                        Message('An 850 buffer already exists for purchase order %1.', Rec."Test 850 Purchase Order ID");
                        exit;
                    end;

                    OrderBuffer.Init();
                    OrderBuffer."Purchase Order ID" := Rec."Test 850 Purchase Order ID";
                    OrderBuffer."SAP Order No." := 'FP00012933';
                    OrderBuffer."Message ID" := 'FA163E1B35C81FE19BFC49A44E2A3373';
                    OrderBuffer."Sender Internal ID" := '1711';
                    // OrderBuffer."Recipient Internal ID" := '1182957';
                    //OrderBuffer."Buyer Party ID" := '1000030';
                    OrderBuffer."Action Code" := '01';
                    OrderBuffer."Order Date" := 20260624D;
                    OrderBuffer."Order Currency" := 'USD';
                    //  OrderBuffer."Buyer Payment Terms ID" := 'NT30';
                    OrderBuffer."Sales Payment Terms" := 'NT90';
                    OrderBuffer."Customer PO" := '8053670001_2';
                    OrderBuffer."Customer Ref PO" := 'NY07-00072866';
                    //  OrderBuffer."Dropship Or SA" := 'DS';
                    OrderBuffer."Order Type" := '8';
                    OrderBuffer."Web Order No." := 'HC02748934';
                    OrderBuffer."Ship Complete" := false;
                    OrderBuffer."Ship Early" := true;
                    OrderBuffer."Bill-to Company" := '1711';
                    OrderBuffer."Bill-to Address 1" := 'P.O. BOX 9073';
                    OrderBuffer."Bill-to City" := 'Melville';
                    OrderBuffer."Bill-to State" := 'NY';
                    OrderBuffer."Bill-to Country" := 'US';
                    OrderBuffer."Bill-to Zip" := '11747';
                    OrderBuffer."Bill-to Phone" := '(516) 812-2000';
                    OrderBuffer."Ship-to Company" := 'AMEICAN PACKAGING';
                    OrderBuffer."Ship-to Address 1" := '777 DRIVING PARK AVE';
                    OrderBuffer."Ship-to City" := 'ROCHESTER';
                    OrderBuffer."Ship-to State Code" := 'NY';
                    OrderBuffer."Ship-to Country" := 'US';
                    OrderBuffer."Ship-to Zip" := '14613';
                    OrderBuffer."Ship-to Phone" := '(516) 812-2000';
                    OrderBuffer."Ship-to Attention" := 'VERBAL RATRY';
                    OrderBuffer."Contact Name" := 'Cynthia Schramm';
                    OrderBuffer."Contact Email" := 'SchrammC@mscdirect.com';
                    OrderBuffer."Contact Phone" := '(516) 812-2000';
                    OrderBuffer."Store Number" := '000008311488';
                    // if Rec."EDI Buyer Party Customer No." <> '' then
                    //     OrderBuffer."Sell-to Customer No." := Rec."EDI Buyer Party Customer No."
                    // else
                    // OrderBuffer."Sell-to Customer No." := OrderBuffer."Sender Internal ID";
                    OrderBuffer.Status := OrderBuffer.Status::New;
                    OrderBuffer.Insert(true);

                    // Line 1
                    OrderLineBuffer.Init();
                    OrderLineBuffer."Document Id" := OrderBuffer.Id;
                    OrderLineBuffer."Action Code" := '01';
                    OrderLineBuffer."Action Code_OrderItem" := '01';
                    OrderLineBuffer."Purchase Order Item ID" := 10;
                    OrderLineBuffer."PO Item ID_OrderItem" := 10;
                    OrderLineBuffer."Sales Order Item ID" := 10000;
                    OrderLineBuffer."Buyer Product ID" := Item."Buyer Product ID";
                    OrderLineBuffer."Buyer Product ID_Product" := Item."Buyer Product ID";
                    OrderLineBuffer.Quantity := 1;
                    OrderLineBuffer."Unit of Measure Code" := 'EA';
                    OrderLineBuffer."Unit Price" := 513.03;
                    OrderLineBuffer."Direct Unit Cost" := 171.81;
                    OrderLineBuffer."Buyer Part Number" := '13174610';
                    // OrderLineBuffer."Requested Delivery Date" := 20260722D;
                    OrderLineBuffer."Line Level Comment" := 'OrderQty: 1.0|';
                    // OrderLineBuffer."PO Schedule Line" := '0001';
                    OrderLineBuffer.Insert(true);

                    // Line 2
                    Clear(OrderLineBuffer);
                    OrderLineBuffer."Document Id" := OrderBuffer.Id;
                    OrderLineBuffer."Action Code" := '01';
                    OrderLineBuffer."Action Code_OrderItem" := '01';
                    OrderLineBuffer."Purchase Order Item ID" := 20;
                    OrderLineBuffer."PO Item ID_OrderItem" := 20;
                    OrderLineBuffer."Sales Order Item ID" := 20000;
                    OrderLineBuffer."Buyer Product ID" := SecondItem."Buyer Product ID";
                    OrderLineBuffer."Buyer Product ID_Product" := SecondItem."Buyer Product ID";
                    OrderLineBuffer.Quantity := 1;
                    OrderLineBuffer."Unit of Measure Code" := 'EA';
                    OrderLineBuffer."Unit Price" := 1874.05;
                    OrderLineBuffer."Direct Unit Cost" := 475.0;
                    OrderLineBuffer."Buyer Part Number" := '00497461';
                    //   OrderLineBuffer."Requested Delivery Date" := 20260624D;
                    OrderLineBuffer."Line Level Comment" := 'OrderQty: 1.0|';
                    //  OrderLineBuffer."PO Schedule Line" := '0001';
                    OrderLineBuffer.Insert(true);

                    OrderBufferMgt.ProcessOrder(OrderBuffer);

                    Message('850 order buffer created for purchase order %1 with 2 lines.', Rec."Test 850 Purchase Order ID");
                end;
            }
            action(Clear850Buffers)
            {
                Caption = 'Clear All 850 Order Buffers';
                ToolTip = 'Deletes all 850 staged order headers and lines from the buffer tables.';
                Image = Delete;

                trigger OnAction()
                var
                    OrderBuffer: Record "SKU 850 Order Buffer";
                    OrderLineBuffer: Record "SKU 850 Order Line Buffer";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all 850 order buffers and lines? This cannot be undone.', false) then
                        exit;

                    OrderLineBuffer.Reset();
                    OrderLineBuffer.DeleteAll(true);

                    OrderBuffer.Reset();
                    Counter := OrderBuffer.Count();
                    OrderBuffer.DeleteAll(true);

                    Message('%1 850 order buffer(s) deleted.', Counter);
                end;
            }
            action(PopulateInvoiceBuffers)
            {
                Caption = 'Populate Invoice Buffers';
                ToolTip = 'Creates invoice buffers from posted sales invoices.';
                Image = Invoice;

                trigger OnAction()
                var
                    InvoiceBufferMgt: Codeunit "SKU Invoice Buffer Mgt";
                    Counter: Integer;
                begin
                    Counter := InvoiceBufferMgt.PopulateFromPostedInvoices(DMY2Date(1, 7, 2026), Today);
                    Message('%1 invoice records created or updated.', Counter);
                end;
            }
            action(PopulateOneInvoiceBuffer)
            {
                Caption = 'Populate One Invoice Buffer';
                ToolTip = 'Creates one invoice buffer from a specified posted sales invoice.';
                Image = Invoice;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    InvoiceBuffer: Record "SKU Invoice Buffer";
                    InvoiceBufferMgt: Codeunit "SKU Invoice Buffer Mgt";
                begin
                    Rec.TestField("Test 810 Invoice No.");

                    if not SalesInvoiceHeader.Get(Rec."Test 810 Invoice No.") then
                        Error('Posted invoice %1 was not found.', Rec."Test 810 Invoice No.");

                    InvoiceBuffer.SetRange("Invoice No.", Rec."Test 810 Invoice No.");
                    if not InvoiceBuffer.IsEmpty() then begin
                        Message('Invoice buffer already exists for invoice %1.', Rec."Test 810 Invoice No.");
                        exit;
                    end;

                    InvoiceBufferMgt.CreateFromPostedInvoice(Rec."Test 810 Invoice No.");
                    Message('Invoice buffer created for invoice %1.', Rec."Test 810 Invoice No.");
                end;
            }
            action(ClearInvoiceBuffers)
            {
                Caption = 'Clear All Invoice Buffers';
                ToolTip = 'Deletes all 810 invoice headers and lines from the integration buffers.';
                Image = Delete;

                trigger OnAction()
                var
                    InvoiceBuffer: Record "SKU Invoice Buffer";
                    InvoiceLineBuffer: Record "SKU Invoice Line Buffer";
                    Counter: Integer;
                begin
                    if not Confirm('Delete all 810 invoice buffers and lines? This cannot be undone.', false) then
                        exit;

                    InvoiceLineBuffer.Reset();
                    InvoiceLineBuffer.DeleteAll(true);

                    InvoiceBuffer.Reset();
                    Counter := InvoiceBuffer.Count();
                    InvoiceBuffer.DeleteAll(true);

                    Message('%1 invoice buffer(s) deleted.', Counter);
                end;
            }
            action(PopulateTestData)
            {
                Caption = 'Populate Test Data (One of Each)';
                ToolTip = 'Creates one sample record for each EDI type (856, 855, 810) using test record numbers from setup.';
                Image = Import;

                trigger OnAction()
                var
                    DeliveryBufferMgt: Codeunit "SKU Delivery Buffer Mgt";
                    OrderConfBufferMgt: Codeunit "SKU Order Conf Buffer Mgt";
                    InvoiceBufferMgt: Codeunit "SKU Invoice Buffer Mgt";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesHeader: Record "Sales Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    DeliveryBuffer: Record "SKU Delivery Buffer";
                    SuccessCount: Integer;
                begin
                    // Populate 856 Shipment
                    if Rec."Test 856 Shipment No." <> '' then begin
                        if SalesShipmentHeader.Get(Rec."Test 856 Shipment No.") then begin
                            Clear(DeliveryBuffer);
                            DeliveryBuffer.Init();
                            DeliveryBuffer."Shipment No." := SalesShipmentHeader."No.";
                            if DeliveryBufferMgt.LoadFromShipment(DeliveryBuffer) then begin
                                DeliveryBuffer.Insert(true);
                                DeliveryBufferMgt.LoadLinesFromShipment(DeliveryBuffer);
                                SuccessCount += 1;
                            end;
                        end;
                    end;

                    // Populate 855 Order Confirmation
                    if Rec."Test 855 Order No." <> '' then begin
                        if SalesHeader.Get(Rec."Test 855 Order No.") then begin
                            OrderConfBufferMgt.CreateFromSalesOrder(SalesHeader);
                            SuccessCount += 1;
                        end;
                    end;

                    // Populate 810 Invoice
                    if Rec."Test 810 Invoice No." <> '' then begin
                        if SalesInvoiceHeader.Get(Rec."Test 810 Invoice No.") then begin
                            InvoiceBufferMgt.CreateFromPostedInvoice(Rec."Test 810 Invoice No.");
                            SuccessCount += 1;
                        end;
                    end;

                    if SuccessCount = 0 then
                        Message('No test records specified in setup. Populate Test 856 Shipment No., Test 855 Order No., and/or Test 810 Invoice No. first.')
                    else
                        Message('%1 test buffer(s) created.', SuccessCount);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;

    local procedure FindPostedShipment(var SalesShipmentHeader: Record "Sales Shipment Header"; ShipmentNo: Code[20]): Boolean
    begin
        if SalesShipmentHeader.Get(ShipmentNo) then
            exit(true);

        SalesShipmentHeader.Reset();
        if SalesShipmentHeader.FindSet() then
            repeat
                if DelChr(SalesShipmentHeader."No.", '=', '-') = DelChr(ShipmentNo, '=', '-') then
                    exit(true);
            until SalesShipmentHeader.Next() = 0;

        exit(false);
    end;
}
