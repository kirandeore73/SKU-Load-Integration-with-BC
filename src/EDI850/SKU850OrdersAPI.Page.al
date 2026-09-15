page 72002 "EDI SSales Order Header API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'EDI 850 Sales Order';
    EntitySetCaption = 'EDI 850 Sales Orders';
    EntityName = 'edi850SalesOrder';
    EntitySetName = 'edi850SalesOrders';
    PageType = API;
    SourceTable = "SKU 850 Order Buffer";
    DelayedInsert = true;
    ODataKeyFields = Id;
    ChangeTrackingAllowed = true;
    Extensible = false;
    Permissions = tabledata "SKU 850 Order Buffer" = RIMD,
                  tabledata "SKU 850 Order Line Buffer" = RIMD,
                  tabledata "SKUIntegrationLog" = RIMD,
                  tabledata SKUIntegrationSetup = RIMD,
                  tabledata "IWX LP Line Usage" = R;
    AboutText = 'Inbound EDI 850 purchase order staging received from SAP through Boomi. Supports insert, update and delete, and creates a Business Central sales order when processed.';

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
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    Editable = false;
                }
                field(orderNumber; Rec."Order No.")
                {
                    Caption = 'Order No.';
                    Editable = false;
                }
                field(orderId; Rec."Order Id")
                {
                    Caption = 'Order Id';
                    Editable = false;
                }
                field(messageId; Rec."Message ID")
                {
                    Caption = 'Message ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Message ID"));
                    end;
                }
                field(creationDateTime; Rec."Creation DateTime")
                {
                    Caption = 'Creation DateTime';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Creation DateTime"));
                    end;
                }
                field(senderBusinessSystemId; Rec."Sender Business System ID")
                {
                    Caption = 'Sender Business System ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sender Business System ID"));
                    end;
                }
                field(senderPartyInternalId; Rec."Sender Internal ID")
                {
                    Caption = 'Sender Party Internal ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sender Internal ID"));
                    end;
                }
                field(recipientPartyInternalId; Rec."Recipient Internal ID")
                {
                    Caption = 'Recipient Party Internal ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Recipient Internal ID"));
                    end;
                }
                field(ediCompanyCode; Rec."EDI Company Code")
                {
                    Caption = 'EDI Company Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("EDI Company Code"));
                    end;
                }
                field(supplierPartyIdShipTo; Rec."SupplierPartyID_Shipto")
                {
                    Caption = 'Supplier Party ID Ship-to';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("SupplierPartyID_Shipto"));
                    end;
                }
                field(purchasingDocumentType; Rec."Purchasing Document Type")
                {
                    Caption = 'Purchasing Document Type';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purchasing Document Type"));
                    end;
                }
                field(purchasingDocumentTypeName; Rec."Purchasing Document Type Name")
                {
                    Caption = 'Purchasing Document Type Name';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purchasing Document Type Name"));
                    end;
                }
                field(purchDocTypeLanguageCode; Rec."Purch Doc Type Language Code")
                {
                    Caption = 'Purchasing Document Type Language Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purch Doc Type Language Code"));
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
                field(purchaseOrderId; Rec."Purchase Order ID")
                {
                    Caption = 'Purchase Order ID';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Purchase Order ID"));
                    end;
                }
                field(sapOrderNumber; Rec."SAP Order No.")
                {
                    Caption = 'SAP Order No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("SAP Order No."));
                    end;
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Order Date"));
                    end;
                }
                field(orderCurrency; Rec."Order Currency")
                {
                    Caption = 'Order Currency';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Order Currency"));
                    end;
                }
                field(orderType; Rec."Order Type")
                {
                    Caption = 'Order Type';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Order Type"));
                    end;
                }
                field(salesPaymentTerms; Rec."Sales Payment Terms")
                {
                    Caption = 'Sales Payment Terms';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sales Payment Terms"));
                    end;
                }
                field(taxJurisdictionCode; Rec."EDI Tax Jurisdiction Code")
                {
                    Caption = 'Tax Jurisdiction Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("EDI Tax Jurisdiction Code"));
                    end;
                }
                field(btCompany; Rec."Bill-to Company")
                {
                    Caption = 'Bill-to Customer No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Company"));
                    end;
                }
                field(btAddress1; Rec."Bill-to Address 1")
                {
                    Caption = 'Bill-to Address 1';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Address 1"));
                    end;
                }
                field(btAddress2; Rec."Bill-to Address 2")
                {
                    Caption = 'Bill-to Address 2';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Address 2"));
                    end;
                }
                field(btAddress3; Rec."Bill-to Address 3")
                {
                    Caption = 'Bill-to Address 3';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Address 3"));
                    end;
                }
                field(btAddress4; Rec."Bill-to Address 4")
                {
                    Caption = 'Bill-to Address 4';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Address 4"));
                    end;
                }
                field(btCity; Rec."Bill-to City")
                {
                    Caption = 'Bill-to City';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to City"));
                    end;
                }
                field(btState; Rec."Bill-to State")
                {
                    Caption = 'Bill-to State';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to State"));
                    end;
                }
                field(btCountry; Rec."Bill-to Country")
                {
                    Caption = 'Bill-to Country';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Country"));
                    end;
                }
                field(btZip; Rec."Bill-to Zip")
                {
                    Caption = 'Bill-to Zip';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Zip"));
                    end;
                }
                field(btPhone; Rec."Bill-to Phone")
                {
                    Caption = 'Bill-to Phone';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Phone"));
                    end;
                }
                field(btEmail; Rec."Bill-to Email")
                {
                    Caption = 'Bill-to Email';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bill-to Email"));
                    end;
                }
                field(stHouseNumber; Rec."Ship-to House Number")
                {
                    Caption = 'Ship-to House Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to House Number"));
                    end;
                }
                field(stCompany; Rec."Ship-to Company")
                {
                    Caption = 'Ship-to Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Company"));
                    end;
                }
                field(stAddress1; Rec."Ship-to Address 1")
                {
                    Caption = 'Ship-to Address 1';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address 1"));
                    end;
                }
                field(stAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address 2"));
                    end;
                }
                field(stAddress3; Rec."Ship-to Address 3")
                {
                    Caption = 'Ship-to Address 3';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address 3"));
                    end;
                }
                field(stAddress4; Rec."Ship-to Address 4")
                {
                    Caption = 'Ship-to Address 4';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Address 4"));
                    end;
                }
                field(stCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to City"));
                    end;
                }
                field(stStateCode; Rec."Ship-to State Code")
                {
                    Caption = 'Ship-to State Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to State Code"));
                    end;
                }
                field(stStateName; Rec."Ship-to State Name")
                {
                    Caption = 'Ship-to State Name';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to State Name"));
                    end;
                }
                field(stCountry; Rec."Ship-to Country")
                {
                    Caption = 'Ship-to Country';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Country"));
                    end;
                }
                field(stZip; Rec."Ship-to Zip")
                {
                    Caption = 'Ship-to Zip';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Zip"));
                    end;
                }
                field(stPhone; Rec."Ship-to Phone")
                {
                    Caption = 'Ship-to Phone';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Phone"));
                    end;
                }
                field(stEmail; Rec."Ship-to Email")
                {
                    Caption = 'Ship-to Email';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Email"));
                    end;
                }
                field(shipToAttention; Rec."Ship-to Attention")
                {
                    Caption = 'Ship-to Attention';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship-to Attention"));
                    end;
                }
                field(shippingVia; Rec."Shipping Via")
                {
                    Caption = 'Shipping Via';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Via"));
                    end;
                }
                field(shippingViaDescription; Rec."Shipping Via Desc")
                {
                    Caption = 'Shipping Via Description';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Via Desc"));
                    end;
                }
                field(shippingAccountNumber; Rec."Shipping Account Number")
                {
                    Caption = 'Shipping Account Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Account Number"));
                    end;
                }
                field(shipComplete; Rec."Ship Complete")
                {
                    Caption = 'Ship Complete';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship Complete"));
                    end;
                }
                field(shipEarly; Rec."Ship Early")
                {
                    Caption = 'Ship Early';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ship Early"));
                    end;
                }
                field(shippingNotes; Rec."Shipping Notes")
                {
                    Caption = 'Shipping Notes';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Shipping Notes"));
                    end;
                }
                field(scheduledShipment; Rec."Scheduled Shipment")
                {
                    Caption = 'Scheduled Shipment';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Scheduled Shipment"));
                    end;
                }
                field(freight; Rec.Freight)
                {
                    Caption = 'Freight';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Freight));
                    end;
                }
                field(handlingCharges; Rec."Handling Charges")
                {
                    Caption = 'Handling Charges';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Handling Charges"));
                    end;
                }
                field(contactName; Rec."Contact Name")
                {
                    Caption = 'Contact Name';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Contact Name"));
                    end;
                }
                field(contactEmail; Rec."Contact Email")
                {
                    Caption = 'Contact Email';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Contact Email"));
                    end;
                }
                field(contactPhone; Rec."Contact Phone")
                {
                    Caption = 'Contact Phone';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Contact Phone"));
                    end;
                }
                field(storeNumber; Rec."Store Number")
                {
                    Caption = 'Store Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Store Number"));
                    end;
                }
                field(addressId; Rec."Address Id")
                {
                    Caption = 'Address Id';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Address Id"));
                    end;
                }
                field(webOrderNumber; Rec."Web Order No.")
                {
                    Caption = 'Web Order No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Web Order No."));
                    end;
                }
                field(legacyOrderNumber; Rec."Legacy Order Number")
                {
                    Caption = 'Legacy Order Number';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Legacy Order Number"));
                    end;
                }
                field(customerPo; Rec."Customer PO")
                {
                    Caption = 'Customer PO';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Customer PO"));
                    end;
                }
                field(customerRefPo; Rec."Customer Ref PO")
                {
                    Caption = 'Customer Ref PO';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Customer Ref PO"));
                    end;
                }
                field(asmInitial; Rec."ASM Initial")
                {
                    Caption = 'ASM Initial';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("ASM Initial"));
                    end;
                }
                field(hybrisRma; Rec."Hybris RMA")
                {
                    Caption = 'Hybris RMA';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Hybris RMA"));
                    end;
                }
                field(isGovtOrder; Rec."Is Govt Order")
                {
                    Caption = 'Is Govt Order';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Is Govt Order"));
                    end;
                }
                field(govtType; Rec."Govt Type")
                {
                    Caption = 'Govt Type';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Govt Type"));
                    end;
                }
                field(priceMismatch; Rec."Price Mismatch")
                {
                    Caption = 'Price Mismatch';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Price Mismatch"));
                    end;
                }
                field(questionareType; Rec."Questionare Type")
                {
                    Caption = 'Questionare Type';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Questionare Type"));
                    end;
                }
                field(discontinuedItems; Rec."Discontinued Items")
                {
                    Caption = 'Discontinued Items';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Discontinued Items"));
                    end;
                }
                field(discontinuedItemNotes; Rec."Discontinued Item Notes")
                {
                    Caption = 'Discontinued Item Notes';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Discontinued Item Notes"));
                    end;
                }
                field(vendorPrice; Rec."Vendor Price")
                {
                    Caption = 'Vendor Price';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Vendor Price"));
                    end;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field(errorMessage; Rec."Error Message")
                {
                    Caption = 'Error Message';
                    Editable = false;
                }
                field(processedDateTime; Rec."Processed DateTime")
                {
                    Caption = 'Processed DateTime';
                    Editable = false;
                }
                part(edi850SalesOrderLines; "EDI SSales Order Line API")
                {
                    Caption = 'Lines';
                    EntityName = 'edi850SalesOrderLine';
                    EntitySetName = 'edi850SalesOrderLines';
                    SubPageLink = "Document Id" = field(Id);
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        OrderBufferMgt.PropagateOnInsert(Rec, TempFieldBuffer);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        if xRec.Id <> Rec.Id then
            Error(CannotChangeIdErr);

        OrderBufferMgt.PropagateOnModify(Rec, TempFieldBuffer);
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        OrderBufferMgt: Codeunit "SKU 850 Order Buffer Mgt";
    begin
        OrderBufferMgt.PropagateOnDelete(Rec);
        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        Customer: Record Customer;
        CannotChangeIdErr: Label 'The "id" cannot be changed.', Comment = 'id is a field name and should not be translated.';
        CouldNotFindCustomerErr: Label 'The customer cannot be found.';

    local procedure ClearCalculatedFields()
    begin
        TempFieldBuffer.Reset();
        TempFieldBuffer.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := Database::"SKU 850 Order Buffer";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;
}