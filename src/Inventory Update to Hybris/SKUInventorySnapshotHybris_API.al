page 72024 "Inventory Snapshot Hybris API"
{
    ApplicationArea = All;
    Caption = 'Inventory Snapshot Update to Hybris';
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Inventory Snapshot Update to Hybris';
    EntitySetCaption = 'Inventory Snapshot Updates to Hybris';
    EntityName = 'inventorySnapshotHybris';
    EntitySetName = 'inventorySnapshotHybris';
    ChangeTrackingAllowed = true;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "InvSnapshotHybrisBuff";
    Extensible = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "InvSnapshotHybrisBuff" = R;

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
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Product';
                }
                field(reserved; Rec.Reserved)
                {
                    Caption = 'Reserved';
                }
                field(lastUpdatedDateTime; Rec."Last Updated DateTime")
                {
                    Caption = 'Last Updated DateTime';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        InventoryUpdateHybrisMgt: Codeunit "Inventory Update Hybris Mgt";
    begin
        InventoryUpdateHybrisMgt.RunFullInventoryUpdate();
    end;
}
