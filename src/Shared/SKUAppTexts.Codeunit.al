codeunit 72005 "SKUAppTexts"
{
    procedure GetProductPriceNodeMissingErr(): Text
    var
        ProductPriceNodeMissingErr: Label 'No ProductPrice/Price nodes were found in the file.';
    begin
        exit(ProductPriceNodeMissingErr);
    end;

    procedure GetOrderNodeMissingErr(): Text
    var
        OrderNodeMissingErr: Label 'No OrderRequest/Order node was found in the file.';
    begin
        exit(OrderNodeMissingErr);
    end;

    procedure GetUnknownMessageTypeErr(): Text
    var
        UnknownMessageTypeErr: Label 'The file does not contain a recognized EDI message type.';
    begin
        exit(UnknownMessageTypeErr);
    end;

    procedure GetLogDocMissingErr(): Text
    var
        LogDocMissingErr: Label 'The log entry does not contain a stored document to reprocess.';
    begin
        exit(LogDocMissingErr);
    end;

    procedure GetNoDeliveryLinesErr(): Text
    var
        NoDeliveryLinesErr: Label 'The posted shipment has no item lines to send.';
    begin
        exit(NoDeliveryLinesErr);
    end;

    procedure GetProductPriceImportedMsg(LineCount: Integer): Text
    var
        ProductPriceImportedMsg: Label '%1 product price line(s) were imported.', Comment = '%1 = number of lines';
    begin
        exit(StrSubstNo(ProductPriceImportedMsg, LineCount));
    end;

    procedure GetOrderImportedMsg(DocumentNo: Code[20]; LineCount: Integer): Text
    var
        OrderImportedMsg: Label 'Sales order %1 was created with %2 line(s).', Comment = '%1 = sales order no., %2 = number of lines';
    begin
        exit(StrSubstNo(OrderImportedMsg, DocumentNo, LineCount));
    end;

    procedure GetOrderNotFoundErr(SapPoNo: Text): Text
    var
        OrderNotFoundErr: Label 'No open sales order was found for SAP purchase order %1.', Comment = '%1 = SAP purchase order no.';
    begin
        exit(StrSubstNo(OrderNotFoundErr, SapPoNo));
    end;

    procedure GetOrderChangedMsg(DocumentNo: Code[20]; ChangedCount: Integer; DeletedCount: Integer): Text
    var
        OrderChangedMsg: Label 'Sales order %1 was updated: %2 line(s) changed, %3 line(s) deleted.', Comment = '%1 = sales order no., %2 = changed lines, %3 = deleted lines';
    begin
        exit(StrSubstNo(OrderChangedMsg, DocumentNo, ChangedCount, DeletedCount));
    end;

    procedure GetImportFileDialogTitle(): Text
    var
        ImportFileDialogTitle: Label 'Select an EDI file to import';
    begin
        exit(ImportFileDialogTitle);
    end;

    procedure GetImportFileFilter(): Text
    var
        ImportFileFilter: Label 'EDI files (*.xml;*.json)|*.xml;*.json|All files (*.*)|*.*';
    begin
        exit(ImportFileFilter);
    end;
}
