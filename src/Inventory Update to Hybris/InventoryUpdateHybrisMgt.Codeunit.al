codeunit 72034 "Inventory Update Hybris Mgt"
{
    Permissions = tabledata "InvSnapshotHybrisBuff" = RIMD,
                  tabledata "InvDeltaHybrisBuff" = RIMD,
                  tabledata Item = R,
                  tabledata Location = R;

    // Full daily file: recalculates and stores current available qty for every item.
    procedure RunFullInventoryUpdate()
    var
        Item: Record Item;
        LocationFilter: Text;
        AvailableQty: Decimal;
    begin
        CleanupSnapshotRowsForDeletedItems();
        LocationFilter := GetNonTransitLocationFilter();

        if Item.FindSet() then
            repeat
                AvailableQty := CalculateAvailableQty(Item, LocationFilter);
                UpsertSnapshot(Item."No.", AvailableQty);
            until Item.Next() = 0;
    end;

    // ~15 min delta file: only items whose available qty changed since the last run are staged.
    procedure RunDeltaInventoryUpdate()
    var
        Item: Record Item;
        SnapshotBuffer: Record "InvSnapshotHybrisBuff";
        LocationFilter: Text;
        AvailableQty: Decimal;
    begin
        LocationFilter := GetNonTransitLocationFilter();

        if Item.FindSet() then
            repeat
                AvailableQty := CalculateAvailableQty(Item, LocationFilter);

                if SnapshotBuffer.Get(Item."No.") then begin
                    if SnapshotBuffer."Available On Hand Qty" <> AvailableQty then begin
                        UpsertDelta(Item."No.", AvailableQty);
                        UpsertSnapshot(Item."No.", AvailableQty);
                    end;
                end else begin
                    // Item never seen before - baseline it and surface it as a change too.
                    UpsertSnapshot(Item."No.", AvailableQty);
                    UpsertDelta(Item."No.", AvailableQty);
                end;
            until Item.Next() = 0;
    end;

    procedure DeleteAllInventorySnapshotBuffers(): Integer
    var
        SnapshotBuffer: Record "InvSnapshotHybrisBuff";
        Counter: Integer;
    begin
        SnapshotBuffer.Reset();
        if SnapshotBuffer.FindSet() then
            repeat
                Counter += 1;
                SnapshotBuffer.Delete(true);
            until SnapshotBuffer.Next() = 0;

        exit(Counter);
    end;

    procedure DeleteAllInventoryDeltaBuffers(): Integer
    var
        DeltaBuffer: Record "InvDeltaHybrisBuff";
        Counter: Integer;
    begin
        DeltaBuffer.Reset();
        if DeltaBuffer.FindSet() then
            repeat
                Counter += 1;
                DeltaBuffer.Delete(true);
            until DeltaBuffer.Next() = 0;

        exit(Counter);
    end;

    local procedure CleanupSnapshotRowsForDeletedItems()
    var
        SnapshotBuffer: Record "InvSnapshotHybrisBuff";
        Item: Record Item;
    begin
        if SnapshotBuffer.FindSet() then
            repeat
                if not Item.Get(SnapshotBuffer."Item No.") then
                    SnapshotBuffer.Delete(true);
            until SnapshotBuffer.Next() = 0;
    end;

    local procedure GetNonTransitLocationFilter(): Text
    var
        Location: Record Location;
        LocationFilter: TextBuilder;
    begin
        Location.SetRange("Use As In-Transit", false);
        if Location.FindSet() then
            repeat
                if LocationFilter.Length() > 0 then
                    LocationFilter.Append('|');
                LocationFilter.Append(Location.Code);
            until Location.Next() = 0;

        exit(LocationFilter.ToText());
    end;

    local procedure CalculateAvailableQty(var Item: Record Item; LocationFilter: Text): Decimal
    var
        AvailableOnHandQty: Decimal;
    begin
        Item.SetFilter("Location Filter", LocationFilter);
        Item.CalcFields(Inventory, "Qty. on Sales Order");

        AvailableOnHandQty := Item.Inventory - Item."Qty. on Sales Order";
        if AvailableOnHandQty < 0 then
            AvailableOnHandQty := 0;

        exit(AvailableOnHandQty);
    end;

    local procedure UpsertSnapshot(ItemNo: Code[20]; AvailableQty: Decimal)
    var
        SnapshotBuffer: Record "InvSnapshotHybrisBuff";
    begin
        if not SnapshotBuffer.Get(ItemNo) then begin
            SnapshotBuffer.Init();
            SnapshotBuffer."Item No." := ItemNo;
            SnapshotBuffer.Warehouse := 'MAIN';
            SnapshotBuffer."IN Stock Status" := 'forceInStock';
            SnapshotBuffer."Max Pre Order" := 1;
            SnapshotBuffer."Max Stock Level Hist Cnt" := -1;
            SnapshotBuffer.Overselling := 0;
            SnapshotBuffer."Pre Order" := 0;
            SnapshotBuffer.Reserved := 0;
            SnapshotBuffer.Insert(true);
        end;

        SnapshotBuffer."Available On Hand Qty" := AvailableQty;
        SnapshotBuffer."Last Updated DateTime" := CurrentDateTime;
        SnapshotBuffer.Modify(true);
    end;

    local procedure UpsertDelta(ItemNo: Code[20]; AvailableQty: Decimal)
    var
        DeltaBuffer: Record "InvDeltaHybrisBuff";
    begin
        if not DeltaBuffer.Get(ItemNo) then begin
            DeltaBuffer.Init();
            DeltaBuffer."Item No." := ItemNo;
            DeltaBuffer.Warehouse := 'MAIN';
            DeltaBuffer."IN Stock Status" := 'forceInStock';
            DeltaBuffer."Max Pre Order" := 1;
            DeltaBuffer."Max Stock Level Hist Cnt" := -1;
            DeltaBuffer.Overselling := 0;
            DeltaBuffer."Pre Order" := 0;
            DeltaBuffer.Reserved := 0;
            DeltaBuffer.Insert(true);
        end;

        DeltaBuffer."Available On Hand Qty" := AvailableQty;
        DeltaBuffer."Last Updated DateTime" := CurrentDateTime;
        DeltaBuffer.Modify(true);
    end;
}
