page 72022 "SKU Invoices API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Invoice';
    EntitySetCaption = 'Invoices';
    EntityName = 'invoice';
    EntitySetName = 'invoices';
    ChangeTrackingAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "SKU Invoice Buffer";
    Extensible = false;
    Permissions = tabledata "SKU Invoice Buffer" = RIMD,
                  tabledata "SKU Invoice Line Buffer" = RIMD,
                  tabledata SKUIntegrationSetup = RIMD,
                  tabledata "SKUIntegrationLog" = RIMD;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.Id) { }
                field(entryNo; Rec."Entry No.") { }
                field(invoiceNo; Rec."Invoice No.") { }
                field(invoiceId; Rec."Invoice Id") { }
                field(supplierInvoiceTypeCode; Rec."Supplier Invoice Type Code") { }
                field(creationDateTime; Rec."Creation DateTime") { }
                field(senderInternalId; Rec."Sender Internal ID") { }
                field(recipientInternalId; Rec."Recipient Internal ID") { }
                field(buyerPartyIdBillFrom; Rec."BuyerPartyID_BillFrom") { }
                field(buyerPartyIdBillTo; Rec."BuyerPartyID_BillTo") { }
                field(supplierPartyIdBillTo; Rec."SupplierPartyID") { }
                field(addressName; Rec."Address Name") { }
                field(postingDate; Rec."Posting Date") { }
                field(currencyCode; Rec."Currency Code") { }
                field(amountIncludingVAT; Rec."Amount Including VAT") { }
                field(sellToCountryRegionCode; Rec."Sell-to Country/Region Code") { }
                // field(taxCountry; Rec."Tax Country") { }
                field(lastModifiedDateTime; Rec."Last Modified Date Time") { }
                part(invoiceLines; "SKU Invoice Lines API")
                {
                    EntityName = 'invoiceLine';
                    EntitySetName = 'invoiceLines';
                    SubPageLink = "Document Id" = field(Id);
                }
            }
        }
    }

}