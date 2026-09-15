page 72023 "SKU Invoice Lines API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Invoice Line';
    EntitySetCaption = 'Invoice Lines';
    EntityName = 'invoiceLine';
    EntitySetName = 'invoiceLines';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "SKU Invoice Line Buffer";
    Extensible = false;
    Permissions = tabledata "SKU Invoice Line Buffer" = RIMD,
                  tabledata SKUIntegrationSetup = RIMD,
                  tabledata "SKUIntegrationLog" = RIMD;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.Id) { }
                field(documentId; Rec."Document Id") { }
                field(invoiceEntryNo; Rec."Invoice Entry No.") { }
                // field(lineNo; Rec."Line No.") { }
                // field(itemNo; Rec."Item No.") { }
                field(supplierInvoiceItemID; Rec."Supplier Invoice Item ID") { }
                field(invoiceItemTypeCode; Rec."Invoice Item Type Code") { }
                field(netAmount; Rec."Net Amount") { }
                field(currencyCode_line; Rec."Currency Code") { }
                field(quantity; Rec.Quantity) { }
                field(unitOfMeasureCode; Rec."Unit of Measure Code") { }
                field(purchaseOrderID; Rec."Purchase Order ID") { }
                field(purchaseOrderItemID; Rec."Purchase Order Item ID") { }
                field(supplierTaxTypeCode; Rec."Supplier Tax Type Code") { }
                field(taxPercentage; Rec."Tax Percentage") { }
                field(taxJurisdiction; Rec."Tax Jurisdiction") { }
                field(taxDeterminationDate; Rec."Tax Determination Date") { }
                field(lastModifiedDateTime; Rec."Last Modified Date Time") { }
            }
        }
    }
}