page 72010 "SKU Product Prices API"
{
    APIGroup = 'skuIntegration';
    APIPublisher = 'sku';
    APIVersion = 'v2.0';
    EntityCaption = 'Product Price';
    EntitySetCaption = 'Product Prices';
    EntityName = 'productPrice';
    EntitySetName = 'productPrices';
    PageType = API;
    SourceTable = "SKU Product Price Buffer";
    DelayedInsert = true;
    ODataKeyFields = Id;
    ChangeTrackingAllowed = true;
    Extensible = false;
    Permissions = tabledata "SKU Product Price Buffer" = RIMD,
                  tabledata "Price List Header" = RIMD,
                  tabledata "Price List Line" = RIMD;
    AboutText = 'Manages product pricing data for SAP integration. Supports importing prices from SAP and creating Business Central Price List Lines. Each record maps to a Price List Line with customer-specific pricing, currency, date ranges, and SAP product references.';

    layout
    {
        area(Content)
        {
            repeater(Records)
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
                field(priceListCode; Rec."Price List Code")
                {
                    Caption = 'Price List Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Price List Code"));
                    end;
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';

                    trigger OnValidate()
                    begin
                        if not IsNullGuid(Rec."Customer Id") then begin
                            if not Customer.GetBySystemId(Rec."Customer Id") then
                                Error(CustomerIdDoesNotMatchErr);
                            Rec."Customer No." := Customer."No.";
                        end;
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Customer No."));
                    end;
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';

                    trigger OnValidate()
                    begin
                        if Rec."Customer No." <> '' then begin
                            if not Customer.Get(Rec."Customer No.") then
                                Error(CustomerNoDoesNotMatchErr);
                            Rec."Customer Id" := Customer.SystemId;
                        end;
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Customer No."));
                    end;
                }
                field(itemId; Rec."Item Id")
                {
                    Caption = 'Item Id';

                    trigger OnValidate()
                    begin
                        if not IsNullGuid(Rec."Item Id") then begin
                            if not Item.GetBySystemId(Rec."Item Id") then
                                Error(ItemIdDoesNotMatchErr);
                            Rec."Item No." := Item."No.";
                        end;
                        RegisterFieldSet(Rec.FieldNo("Item Id"));
                        RegisterFieldSet(Rec.FieldNo("Item No."));
                    end;
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';

                    trigger OnValidate()
                    begin
                        if Rec."Item No." <> '' then begin
                            if not Item.Get(Rec."Item No.") then
                                Error(ItemNoDoesNotMatchErr);
                            Rec."Item Id" := Item.SystemId;
                        end;
                        RegisterFieldSet(Rec.FieldNo("Item Id"));
                        RegisterFieldSet(Rec.FieldNo("Item No."));
                    end;
                }
                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';

                    trigger OnValidate()
                    begin
                        if not IsNullGuid(Rec."Currency Id") then begin
                            if not Currency.GetBySystemId(Rec."Currency Id") then
                                Error(CurrencyIdDoesNotMatchErr);
                            Rec."Currency Code" := Currency.Code;
                        end;
                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';

                    trigger OnValidate()
                    begin
                        // Currency table only has foreign currencies - local currency (e.g. USD) won't exist
                        if Rec."Currency Code" <> '' then begin
                            if Currency.Get(Rec."Currency Code") then
                                Rec."Currency Id" := Currency.SystemId
                            else
                                Clear(Rec."Currency Id"); // Local currency - no record in Currency table
                        end;
                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(minimumQuantity; Rec."Minimum Quantity")
                {
                    Caption = 'Minimum Quantity';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Minimum Quantity"));
                    end;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Unit Price"));
                    end;
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Starting Date"));
                    end;
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Ending Date"));
                    end;
                }
                field(sapProduct; Rec."SAP Product")
                {
                    Caption = 'SAP Product';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("SAP Product"));
                    end;
                }
                field(processed; Rec.Processed)
                {
                    Caption = 'Processed';
                    Editable = false;
                }
                field(errorMessage; Rec."Error Message")
                {
                    Caption = 'Error Message';
                    Editable = false;
                }
                field(priceListLineNo; Rec."Price List Line No.")
                {
                    Caption = 'Price List Line No.';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckItemSpecified();

        Rec.Insert(true);
        PropagateInsertToPriceListLine();
        Rec.Modify(true);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Id <> Rec.Id then
            Error(CannotChangeIDErr);

        Rec.Modify(true);
        PropagateModifyToPriceListLine();
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error(CannotDeleteErr);
    end;

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
        CheckPermissions();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        Customer: Record Customer;
        Item: Record Item;
        Currency: Record Currency;
        CannotChangeIDErr: Label 'The "id" cannot be changed.', Comment = 'id is a field name and should not be translated.';
        CustomerIdDoesNotMatchErr: Label 'The "customerId" does not match a Customer.', Comment = 'customerId is a field name and should not be translated.';
        CustomerNoDoesNotMatchErr: Label 'The "customerNo" does not match a Customer.', Comment = 'customerNo is a field name and should not be translated.';
        ItemIdDoesNotMatchErr: Label 'The "itemId" does not match an Item.', Comment = 'itemId is a field name and should not be translated.';
        ItemNoDoesNotMatchErr: Label 'The "itemNo" does not match an Item.', Comment = 'itemNo is a field name and should not be translated.';
        ItemNotProvidedErr: Label 'An "itemNo" or an "itemId" must be provided.', Comment = 'itemNo and itemId are field names and should not be translated.';
        CurrencyIdDoesNotMatchErr: Label 'The "currencyId" does not match a Currency.', Comment = 'currencyId is a field name and should not be translated.';
        CurrencyCodeDoesNotMatchErr: Label 'The "currencyCode" does not match a Currency.', Comment = 'currencyCode is a field name and should not be translated.';
        CannotModifyErr: Label 'Product price records cannot be modified after creation.';
        CannotDeleteErr: Label 'Product price records cannot be deleted.';
        PriceListPermissionsErr: Label 'You do not have permissions to manage Price Lists.';
        BlankGUID: Guid;
        HasWritePermission: Boolean;

    local procedure SetCalculatedFields()
    begin
        // Additional calculated fields can be set here
    end;

    local procedure ClearCalculatedFields()
    begin
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
        TempFieldBuffer."Table ID" := Database::"SKU Product Price Buffer";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;

    local procedure CheckItemSpecified()
    begin
        if (Rec."Item No." = '') and IsNullGuid(Rec."Item Id") then
            Error(ItemNotProvidedErr);
    end;

    local procedure CheckPermissions()
    var
        PriceListLine: Record "Price List Line";
    begin
        if not PriceListLine.ReadPermission() then
            Error(PriceListPermissionsErr);

        HasWritePermission := PriceListLine.WritePermission();
    end;

    local procedure PropagateInsertToPriceListLine()
    var
        PriceListLine: Record "Price List Line";
        PriceListHeader: Record "Price List Header";
    begin
        ClearLastError();
        if not TryCreatePriceListLine(PriceListLine, PriceListHeader) then begin
            Rec.Processed := false;
            Rec."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Rec."Error Message"));
        end else begin
            Rec.Processed := true;
            Rec."Error Message" := '';
            Rec."Price List Line No." := PriceListLine."Line No.";
        end;
    end;

    local procedure PropagateModifyToPriceListLine()
    var
        PriceListLine: Record "Price List Line";
    begin
        ClearLastError();
        if not TryUpdatePriceListLine(PriceListLine) then begin
            Rec.Processed := false;
            Rec."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Rec."Error Message"));
        end else begin
            Rec.Processed := true;
            Rec."Error Message" := '';
        end;
        Rec.Modify(true);
    end;

    [TryFunction]
    local procedure TryUpdatePriceListLine(var PriceListLine: Record "Price List Line")
    begin
        // Find existing Price List Line
        if Rec."Price List Code" = '' then
            exit;
        if Rec."Price List Line No." = 0 then
            exit;

        if not PriceListLine.Get(Rec."Price List Code", Rec."Price List Line No.") then
            exit;

        // Update fields
        if Rec."Currency Code" <> '' then
            PriceListLine.Validate("Currency Code", Rec."Currency Code")
        else
            PriceListLine.Validate("Currency Code", '');

        PriceListLine.Validate("Minimum Quantity", Rec."Minimum Quantity");
        PriceListLine.Validate("Unit Price", Rec."Unit Price");
        PriceListLine."Starting Date" := Rec."Starting Date";
        PriceListLine."Ending Date" := Rec."Ending Date";
        PriceListLine."SAP Product" := Rec."SAP Product";
        PriceListLine.Modify(true);
    end;

    [TryFunction]
    local procedure TryCreatePriceListLine(var PriceListLine: Record "Price List Line"; var PriceListHeader: Record "Price List Header")
    begin
        // Ensure Price List Header exists
        if Rec."Price List Code" <> '' then begin
            PriceListHeader.SetLoadFields(Code);
            if not PriceListHeader.Get(Rec."Price List Code") then begin
                PriceListHeader.Init();
                PriceListHeader.Code := Rec."Price List Code";
                PriceListHeader.Validate("Price Type", PriceListHeader."Price Type"::Sale);
                PriceListHeader.Validate("Source Group", PriceListHeader."Source Group"::Customer);
                PriceListHeader.Validate("Amount Type", PriceListHeader."Amount Type"::Any);
                PriceListHeader."Allow Updating Defaults" := true;
                PriceListHeader.Insert(true);
            end;
        end;

        // Create Price List Line
        PriceListLine.Init();
        PriceListLine."Price List Code" := Rec."Price List Code";
        PriceListLine."Line No." := GetNextLineNo(Rec."Price List Code");
        PriceListLine.Validate("Source Type", PriceListLine."Source Type"::Customer);
        if Rec."Customer No." <> '' then
            PriceListLine.Validate("Source No.", Rec."Customer No.");
        PriceListLine.Validate("Asset Type", PriceListLine."Asset Type"::Item);
        if Rec."Item No." <> '' then
            PriceListLine.Validate("Asset No.", Rec."Item No.");
        PriceListLine.Validate("Amount Type", PriceListLine."Amount Type"::Price);

        if Rec."Currency Code" <> '' then
            PriceListLine.Validate("Currency Code", Rec."Currency Code");

        PriceListLine.Validate("Minimum Quantity", Rec."Minimum Quantity");
        PriceListLine.Validate("Unit Price", Rec."Unit Price");
        PriceListLine."Starting Date" := Rec."Starting Date";
        PriceListLine."Ending Date" := Rec."Ending Date";
        PriceListLine."SAP Product" := Rec."SAP Product";
        PriceListLine.Insert(true);
    end;

    local procedure GetNextLineNo(PriceListCode: Code[20]): Integer
    var
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.SetRange("Price List Code", PriceListCode);
        if PriceListLine.FindLast() then
            exit(PriceListLine."Line No." + 10000);
        exit(10000);
    end;
}
