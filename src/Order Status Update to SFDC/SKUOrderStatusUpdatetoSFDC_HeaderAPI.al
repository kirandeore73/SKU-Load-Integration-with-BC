namespace Microsoft.API.V2;
page 72026 "OrderStatusUpdtoSFDCHdr"
{
    ApplicationArea = All;
    Caption = 'Order Status Update to SFDC';
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Order Status Update to SFDC';
    EntitySetCaption = 'Order Status Update to SFDC';
    EntityName = 'orderStatusUpdatetoSFDC';
    EntitySetName = 'orderStatusUpdatetoSFDC';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "OrderStatusUpdToSFDCHdrBuff";
    Extensible = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    Permissions = tabledata "OrderStatusUpdToSFDCHdrBuff" = RIMD,
                  tabledata "OrderStatusUpdToSFDCLineBuff" = RD;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(coNum; Rec."CO Number")
                {
                    Caption = 'CO Number';
                }
                field(bcSalesOrderNo; Rec."BC Sales Order No.")
                {
                    Caption = 'BC Sales Order No.';
                }
                field(custNum; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(custSeq; Rec."Customer Seq")
                {
                    Caption = 'Customer Seq';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(takenBy; Rec."Taken By")
                {
                    Caption = 'Taken By';
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(custPo; Rec."Customer PO")
                {
                    Caption = 'Customer PO';
                }
                field(termsCode; Rec."Terms Code")
                {
                    Caption = 'Terms Code';
                }
                field(shipCode; Rec."Ship Code")
                {
                    Caption = 'Ship Code';
                }
                field(price; Rec.Price)
                {
                    Caption = 'Price';
                }
                field(salesTax; Rec."Sales Tax")
                {
                    Caption = 'Sales Tax';
                }
                field(discAmount; Rec."Disc Amount")
                {
                    Caption = 'Disc Amount';
                }
                field(disc; Rec.Disc)
                {
                    Caption = 'Disc';
                }
                field(discountType; Rec."Discount Type")
                {
                    Caption = 'Discount Type';
                }
                field(shipPartial; Rec."Ship Partial")
                {
                    Caption = 'Ship Partial';
                }
                field(shipEarly; Rec."Ship Early")
                {
                    Caption = 'Ship Early';
                }
                field(creditHold; Rec."Credit Hold")
                {
                    Caption = 'Credit Hold';
                }
                field(creditHoldDate; Rec."Credit Hold Date")
                {
                    Caption = 'Credit Hold Date';
                }
                field(creditHoldReason; Rec."Credit Hold Reason")
                {
                    Caption = 'Credit Hold Reason';
                }
                field(creditHoldUser; Rec."Credit Hold User")
                {
                    Caption = 'Credit Hold User';
                }
                field(ufFlatFeeFreight; Rec."Uf Flat Fee Freight")
                {
                    Caption = 'Uf Flat Fee Freight';
                }
                field(ufFlatFeeFreightAmt; Rec."Uf Flat Fee Freight Amt")
                {
                    Caption = 'Uf Flat Fee Freight Amt';
                }
                field(ufFreightAccount; Rec."Uf Freight Account")
                {
                    Caption = 'Uf Freight Account';
                }
                field(ufHoldDate; Rec."Uf Hold Date")
                {
                    Caption = 'Uf Hold Date';
                }
                field(ufOneTimeFreight; Rec."Uf One Time Freight")
                {
                    Caption = 'Uf One Time Freight';
                }
                field(ufShippingTerms; Rec."Uf Shipping Terms")
                {
                    Caption = 'Uf Shipping Terms';
                }
                field(ufHoldReason; Rec."Uf Hold Reason")
                {
                    Caption = 'Uf Hold Reason';
                }
                field(ufIncoTerms; Rec."Uf Inco Terms")
                {
                    Caption = 'Uf Inco Terms';
                }
                field(ufShipToAttentionName; Rec."Uf ShipTo Attention Name")
                {
                    Caption = 'Uf ShipTo Attention Name';
                }
                field(taxCode1; Rec."Tax Code1")
                {
                    Caption = 'Tax Code1';
                }
                field(contactEmail; Rec."Contact Email")
                {
                    Caption = 'Contact Email';
                }
                field(hybrisStatus; Rec."Hybris Status")
                {
                    Caption = 'Hybris Status';
                }
                field(lastUpdatedDateTime; Rec."Last Updated DateTime")
                {
                    Caption = 'Last Updated DateTime';
                }
                part(OrderStatusLines; "OrderStatusUpdtoSFDCLine")
                {
                    Caption = 'Lines';
                    EntityName = 'orderStatusUpdatetoSFDCLine';
                    EntitySetName = 'orderStatusUpdatetoSFDCLines';
                    SubPageLink = "CO Number" = field("CO Number");
                }
            }
        }
    }
}
