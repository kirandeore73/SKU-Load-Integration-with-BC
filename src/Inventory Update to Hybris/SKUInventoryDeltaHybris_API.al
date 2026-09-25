page 72025 "Inventory Delta Hybris API"
{
    ApplicationArea = All;
    Caption = 'Inventory Delta Update to Hybris';
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Inventory Delta Update to Hybris';
    EntitySetCaption = 'Inventory Delta Updates to Hybris';
    EntityName = 'inventoryDeltaHybris';
    EntitySetName = 'inventoryDeltaHybris';
    ChangeTrackingAllowed = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "InvDeltaHybrisBuff";
    Extensible = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    Permissions = tabledata "InvDeltaHybrisBuff" = RD;

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
                field(availableOnHandQty; Rec."Available On Hand Qty")
                {
                    Caption = 'Available On Hand Qty';
                }
                field(warehouse; Rec.Warehouse)
                {
                    Caption = 'Warehouse';
                }
                field(inStockStatus; Rec."IN Stock Status")
                {
                    Caption = 'IN Stock Status';
                }
                field(maxPreOrder; Rec."Max Pre Order")
                {
                    Caption = 'Max Pre-Order';
                }
                field(maxStockLevelHistCnt; Rec."Max Stock Level Hist Cnt")
                {
                    Caption = 'Max Stock Level History Count';
                }
                field(overselling; Rec.Overselling)
                {
                    Caption = 'Overselling';
                }
                field(preOrder; Rec."Pre Order")
                {
                    Caption = 'Pre Order';
                }
                field(reserved; Rec.Reserved)
                {
                    Caption = 'Reserved';
                }
                field(lastUpdatedDateTime; Rec."Last Updated DateTime")
                {
                    Caption = 'Last Updated DateTime';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Product';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
    begin
        InventoryUpdateHybrisMgt.RunDeltaInventoryUpdate();
    end;
}
