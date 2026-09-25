namespace Microsoft.API.V2;
page 72004 "Order Status Update Hybris"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Order Status Update to Hybris';
    EntitySetCaption = 'Order Status Update to Hybris';
    EntityName = 'OrderStatusUpdatetoHybris';
    EntitySetName = 'OrderStatusUpdatetoHybris';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Order Status Hybris Buffer";
    Extensible = false;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    Permissions = tabledata "Order Status Hybris Buffer" = RIMD;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(hybrisOrderNo; Rec."Hybris Order No.")
                {
                    Caption = 'co_num';
                }
                field(sapS4OrderNo; Rec."SAP/S4 Order No.")
                {
                    Caption = 'Uf_OrderNumber';
                }
                field(orderStatus; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(salesTax; Rec."Sales Tax")
                {
                    Caption = 'Sales_Tax';
                }
                field(holdReason; Rec."EDI Hold Reason")
                {
                    Caption = 'Uf_HoldReason';
                }
                field(lastUpdatedDateTime; Rec."Last Updated DateTime")
                {
                    Caption = 'Last Updated DateTime';
                }
            }
        }
    }
    actions
    {
    }
    trigger OnOpenPage()
    begin
        // Superseded by Hybris Order Status Management/Events, which keep the buffer current.
        // CUItemCreation.InsertSalesOrderToSalesOrderHybrs();
    end;

    var
        CUItemCreation: Codeunit "Temp Record Creation";
}

