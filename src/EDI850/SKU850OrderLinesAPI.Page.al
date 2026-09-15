page 72003 "EDI SSales Order Line API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'EDI 850 Sales Order Line';
    EntitySetCaption = 'EDI 850 Sales Order Lines';
    EntityName = 'edi850SalesOrderLine';
    EntitySetName = 'edi850SalesOrderLines';
    PageType = API;
    SourceTable = "SKU 850 Order Line Buffer";
    DelayedInsert = true;
    ODataKeyFields = Id;
    ChangeTrackingAllowed = true;
    Extensible = false;
    Permissions = tabledata "SKU 850 Order Line Buffer" = RIMD;
    AboutText = 'Inbound EDI 850 order item staging lines received from SAP through Boomi.';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';

                    trigger OnValidate()
                    begin
                        if (not IsNullGuid(xRec."Document Id")) and (xRec."Document Id" <> Rec."Document Id") then
                            Error(CannotChangeDocumentIdErr);
                    end;
                }
                field(orderEntryNo; Rec."Order Entry No.")
                {
                    Caption = 'Order Entry No.';
                    Editable = false;
                }
                field(orderNumber; Rec."Order No.")
                {
                    Caption = 'Sales Order No.';
                    Editable = false;
                }
                field(orderId; Rec."Order Id")
                {
                    Caption = 'Order Id';
                    Editable = false;
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';

                    trigger OnValidate()
                    begin
                        if (xRec."Line No." <> Rec."Line No.") and (xRec."Line No." <> 0) then
                            Error(CannotChangeLineNoErr);

                        RegisterFieldSet(Rec.FieldNo("Line No."));
                    end;
                }
                field(actionCode; Rec."Action Code")
                {
                    Caption = 'Action Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Action Code"));
                    end;
                }
                field(actionCodeOrderItem; Rec."Action Code_OrderItem")
                {
                    Caption = 'ActionCode_OrderItem';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Action Code_OrderItem"));
                    end;
                }
                field(purchaseOrderItemId; Rec."Purchase Order Item ID")
                {
                    Caption = 'Purchase Order Item ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purchase Order Item ID"));
                    end;
                }
                field(purchaseOrderItemIdOrderItem; Rec."PO Item ID_OrderItem")
                {
                    Caption = 'PurchaseOrderItemID_OrderItem';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("PO Item ID_OrderItem"));
                    end;
                }
                // field(customerOrderItemId; Rec."Customer Order Item ID")
                // {
                //     Caption = 'Customer Order Item ID';

                //     trigger OnValidate()
                //     begin
                //         RegisterFieldSet(Rec.FieldNo("Customer Order Item ID"));
                //     end;
                // }
                field(salesOrderItemId; Rec."Sales Order Item ID")
                {
                    Caption = 'Sales Order Item ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sales Order Item ID"));
                    end;
                }
                field(purchaseOrderScheduleLine; Rec."Purchase Order Schedule Line")
                {
                    Caption = 'Purchase Order Schedule Line';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purchase Order Schedule Line"));
                    end;
                }
                field(buyerProductId; Rec."Buyer Product ID")
                {
                    Caption = 'Buyer Product ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Buyer Product ID"));
                    end;
                }
                field(buyerProductIdProduct; Rec."Buyer Product ID_Product")
                {
                    Caption = 'BuyerProductID_Product';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Buyer Product ID_Product"));
                    end;
                }
                field(supplierProductIdProduct; Rec."Supplier Product ID_Product")
                {
                    Caption = 'SupplierProductID_Product';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Supplier Product ID_Product"));
                    end;
                }
                // field(customerPartNumber; Rec."Customer Part No.")
                // {
                //     Caption = 'Customer Part No.';

                //     trigger OnValidate()
                //     begin
                //         RegisterFieldSet(Rec.FieldNo("Customer Part No."));
                //     end;
                // }
                field(buyerPartNumber; Rec."Buyer Part Number")
                {
                    Caption = 'Buyer Part Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Buyer Part Number"));
                    end;
                }
                field(custItem; Rec."Custitem")
                {
                    Caption = 'Cust Item';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Custitem"));
                    end;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Quantity));
                    end;
                }
                field(scheduleLineOrderQuantity; Rec."Schedule Line Order Quantity")
                {
                    Caption = 'Schedule Line Order Quantity';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Schedule Line Order Quantity"));
                    end;
                }
                field(scheduleLineUnitCode; Rec."Schedule Line Unit Code")
                {
                    Caption = 'Schedule Line Unit Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Schedule Line Unit Code"));
                    end;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Unit of Measure Code"));
                    end;
                }
                field(salesPrice; Rec."Unit Price")
                {
                    Caption = 'Sales Price';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Unit Price"));
                    end;
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Direct Unit Cost"));
                    end;
                }
                field(drv1; Rec.DRV1)
                {
                    Caption = 'DRV1';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(DRV1));
                    end;
                }
                // field(lineAmount; Rec."Line Amount")
                // {
                //     Caption = 'Line Amount';

                //     trigger OnValidate()
                //     begin
                //         RegisterFieldSet(Rec.FieldNo("Line Amount"));
                //     end;
                // }
                // field(amountIncludingVAT; Rec."Amount Including VAT")
                // {
                //     Caption = 'Amount Including VAT';

                //     trigger OnValidate()
                //     begin
                //         RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                //     end;
                // }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    Caption = 'Requested Delivery Date';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Requested Delivery Date"));
                    end;
                }
                // field(locationCode; Rec."Location Code")
                // {
                //     Caption = 'Location Code';

                //     trigger OnValidate()
                //     begin
                //         RegisterFieldSet(Rec.FieldNo("Location Code"));
                //     end;
                // }
                field(comments; Rec."Line Level Comment")
                {
                    Caption = 'Line Level Comment';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Line Level Comment"));
                    end;
                }
                field(isConfigurable; Rec."Is Configurable")
                {
                    Caption = 'Is Configurable';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Is Configurable"));
                    end;
                }
                field(configPartNumber; Rec."Config Part Number")
                {
                    Caption = 'Config Part Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Config Part Number"));
                    end;
                }
                field(productConfiguration; Rec."Product Configuration")
                {
                    Caption = 'Product Configuration';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Product Configuration"));
                    end;
                }
                field(restockFeePer; Rec.RestockFeePer)
                {
                    Caption = 'Restock Fee Per';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(RestockFeePer));
                    end;
                }
                field(refundReason; Rec."Refund Reason")
                {
                    Caption = 'Refund Reason';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Refund Reason"));
                    end;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Order No.", "Order Id");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        OrderBufferMgt.PropagateInsertLine(Rec, TempFieldBuffer);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        if xRec.Id <> Rec.Id then
            Error(CannotChangeIdErr);

        OrderBufferMgt.PropagateModifyLine(Rec, TempFieldBuffer);
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        OrderBufferMgt.PropagateDeleteLine(Rec);
        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocumentId: Guid;
    begin
        // Nested lines are not inserted by the page, so clear carry-over values from the previous line.
        DocumentId := Rec."Document Id";
        Rec.Init();
        Rec."Document Id" := DocumentId;             //recent updates

        TempFieldBuffer.Reset();
        TempFieldBuffer.DeleteAll();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        CannotChangeIdErr: Label 'The "id" cannot be changed.', Comment = 'id is a field name and should not be translated.';
        CannotChangeDocumentIdErr: Label 'The value for "documentId" cannot be modified.', Comment = 'documentId is a field name and should not be translated.';
        CannotChangeLineNoErr: Label 'The value for sequence cannot be modified. Delete and insert the line again.';

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := Database::"SKU 850 Order Line Buffer";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;
}