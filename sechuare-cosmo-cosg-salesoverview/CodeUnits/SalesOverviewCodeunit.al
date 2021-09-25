codeunit 50100 SalesOverviewCodeunit
{
    procedure UpdateSalesOverview(
        var SalesOverviewRec: Record SalesOverview;
        CustomerNo: Code[20];
        CustomerName: Text[100];
        CustomerPhone: Text[100];
        CustomerEmail: Text[100];
        OrderNo: Text[100];
        ExternalOrderNo: Text[100];
        PackageTrackingNo: Text[100])
    var
        CustomerRecord: Record Customer;
    begin
        SalesHeaderRec.Reset();

        // Add filters
        CustomerFilter(CustomerRecord, CustomerNo, CustomerName, CustomerPhone, CustomerEmail);
        OrderNoFilter(CustomerRecord, OrderNo);
        ExternalOrderNoFilter(CustomerRecord, ExternalOrderNo);
        PackageTrackingNoFilter(CustomerRecord, PackageTrackingNo);

        /* Load data into the worksheet */
        // Delete previous filter results
        SalesOverviewRec.DeleteAll();
        // Set Id
        Id := 1;
        // Fill the worksheet
        FillTable(SalesOverviewRec, CustomerRecord);
    end;

    local procedure CustomerFilter(
        var CustomerRecord: Record Customer;
        "No.": Code[20];
        Name: Text[100];
        Phone: Text[100];
        Email: Text[100])
    begin
        if "No." <> '' then
            CustomerRecord.SetRange("No.", "No.");
        if Name <> '' then
            CustomerRecord.SetFilter(Name, '%1', '*' + Name + '*');
        if Phone <> '' then
            CustomerRecord.SetFilter("Phone No.", '%1', '*' + Phone + '*');
        if Email <> '' then
            CustomerRecord.SetFilter("E-Mail", '%1', '*' + Email + '*');
    end;

    local procedure OrderNoFilter(
        var CustomerRecord: Record Customer;
        OrderNo: Text[100])
    begin
        if OrderNo <> '' then begin
            CustomerRecord.SetFilter("No.", GetCustomerNoByOrderNo(OrderNo));
            SalesHeaderRec.SetFilter("Original Order No.", '%1', '*' + OrderNo + '*');
        end;
    end;

    local procedure ExternalOrderNoFilter(
        var CustomerRecord: Record Customer;
        ExternalOrderNo: Text[100])
    begin
        if ExternalOrderNo <> '' then begin
            CustomerRecord.SetFilter("No.", GetCustomerNoByExternalOrderNo(ExternalOrderNo));
            SalesHeaderRec.SetFilter("External Document No.", '%1', '*' + ExternalOrderNo + '*');
        end;
    end;

    local procedure FillTable(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    begin
        if CustomerRecord.FindSet() then
            repeat
                //Insert Customer - 1st level
                InsertRecord(Rec, 0, IndentationEnum::Customer, Rec."Record Id", CustomerRecord."No." + ' - ' + CustomerRecord.Name, Rec.Date, '', '', 0, '', '', CustomerRecord."No.", 0, "Sales Line Type"::" ");

                // Search the "Sale Orders" of a Customer
                SearchSalesOrder(Rec, CustomerRecord);

                //Search the "Sales Invoices" of a customer
                SearchSalesInvoice(Rec, CustomerRecord);

                //Search the "Sales Quote"
                SearchSalesQuote(Rec, CustomerRecord);

                //Search the "Sales Archive"
                SearchSalesHeaderArchive(Rec, CustomerRecord);

                //Search the "Sales Quote Archive"
                SearchSalesQuoteArchive(Rec, CustomerRecord);
                if Rec.Indentation = IndentationEnum::Customer then
                    Rec.Delete();
            until CustomerRecord.Next = 0;
    end;

    local procedure GetCustomerNoByOrderNo(OrderNo: Code[20]) CustomerNo: Text[2048]
    var
        SalesHeaderRec: Record "Sales Header";
    begin
        SalesHeaderRec.SetFilter("Original Order No.", '%1', '*' + OrderNo + '*');

        if SalesHeaderRec.FindSet() then begin
            repeat
                CustomerNo += SalesHeaderRec."Sell-to Customer No." + '|';
            until SalesHeaderRec.Next = 0;
            CustomerNo := CustomerNo.Substring(1, StrLen(CustomerNo) - 1);
        end
        else begin
            CustomerNo := '-';
        end;
        ;
    end;

    local procedure GetCustomerNoByExternalOrderNo(ExternalOrderNo: Text[100]) CustomerNo: Text[2048]
    var
        SalesHeaderRec: Record "Sales Header";
    begin
        SalesHeaderRec.SetFilter("External Document No.", '%1', '*' + ExternalOrderNo + '*');
        SalesHeaderRec.SetFilter("Document Type", format("Sales Document Type"::Order));

        if SalesHeaderRec.FindSet() then begin
            repeat
                CustomerNo += SalesHeaderRec."Sell-to Customer No." + '|';
            until SalesHeaderRec.Next = 0;
            CustomerNo := CustomerNo.Substring(1, StrLen(CustomerNo) - 1);
        end;
    end;

    local procedure GetCustomerNoByPackageTrackingNo(PackageTrackingNo: Text[100]) CustomerNo: Text[2048]
    var
        SalesHeaderRec: Record "Sales Header";
    begin
        SalesHeaderRec.SetFilter("Package Tracking No.", '%1', '*' + PackageTrackingNo + '*');
        SalesHeaderRec.SetFilter("Document Type", format("Sales Document Type"::Order));

        if SalesHeaderRec.FindSet() then begin
            repeat
                CustomerNo += SalesHeaderRec."Sell-to Customer No." + '|';
            until SalesHeaderRec.Next = 0;
            CustomerNo := CustomerNo.Substring(1, StrLen(CustomerNo) - 1);
        end;
    end;

    local procedure PackageTrackingNoFilter(
        var CustomerRecord: Record Customer;
        PackageTrackingNo: Text[100])
    begin
        if PackageTrackingNo <> '' then begin
            CustomerRecord.SetFilter("No.", GetCustomerNoByPackageTrackingNo(PackageTrackingNo));
            SalesHeaderRec.SetFilter("Package Tracking No.", '%1', '*' + PackageTrackingNo + '*');
        end;
    end;

    local procedure SearchOrderLine(var Rec: Record SalesOverview; var SalesHeaderRecord: Record "Sales Header"; var CustomerRecord: Record Customer)
    var
        SalesLineRecord: Record "Sales Line";
    begin
        SalesLineRecord.SetRange("Document Type", SalesHeaderRecord."Document Type");
        SalesLineRecord.SetRange("Document No.", SalesHeaderRecord."No.");
        if SalesLineRecord.FindSet() then
            repeat
                InsertRecord(Rec, SalesLineRecord."Line No.", Enum::IndentationEnum::"Order Line", Rec."Record Id", 'Order Line', Rec.Date, SalesHeaderRecord."No.", SalesLineRecord.Description, SalesLineRecord.Quantity, SalesLineRecord."Unit of Measure", SalesHeaderRecord."No.", CustomerRecord."No.", SalesLineRecord.Amount, SalesLineRecord."Document Type");
            until SalesLineRecord.Next = 0;
    end;

    local procedure SearchOrderLineArchive(var Rec: Record SalesOverview; var SalesHeaderArchiveRecord: Record "Sales Header Archive")
    var
        LineArchive: Record "Sales Line Archive";
    begin
        LineArchive.SetRange("Document Type", SalesHeaderArchiveRecord."Document Type");
        LineArchive.SetRange("Document No.", SalesHeaderArchiveRecord."No.");
        if LineArchive.FindSet() then
            repeat
                InsertRecord(Rec, LineArchive."Line No.", IndentationEnum::"Order Line", Rec."Record Id", 'ARCHIVE! Order Line', Rec.Date, SalesHeaderArchiveRecord."No.", LineArchive.Description, LineArchive.Quantity, LineArchive."Unit of Measure", '', '', LineArchive.Amount, "Sales Line Type"::" ");
            until LineArchive.Next = 0;
    end;

    local procedure SearchPostedSalesInvoice(var Rec: Record SalesOverview; OriginalNo: code[20]; CustomerNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.SetFilter("Original Order No.", OriginalNo);
        if SalesInvoiceHeader.FindSet() then
            repeat
                InsertRecord(Rec, 0, IndentationEnum::Document, Rec."Record Id", 'Posted Sales Invoice', SalesInvoiceHeader."Due Date", SalesInvoiceHeader."No.", '', 0, '', '', CustomerNo, SalesInvoiceHeader.Amount, "Sales Line Type"::" ");
                PostedSalesInvoiceLine(Rec, SalesInvoiceHeader);
            until SalesInvoiceHeader.Next() = 0;
    end;

    local procedure PostedSalesInvoiceLine(var Rec: Record SalesOverview; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetFilter("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                InsertRecord(Rec, SalesInvoiceLine."Line No.", IndentationEnum::"Order Line", Rec."Record Id", 'Invoice Line', Rec.Date, SalesInvoiceHeader."Original Order No.", SalesInvoiceLine.Description, SalesInvoiceLine.Quantity, SalesInvoiceLine."Unit of Measure", SalesInvoiceHeader."No.", '', SalesInvoiceLine.Amount, SalesInvoiceLine.Type);
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure SearchSalesHeaderArchive(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    var
        ArchiveRecord: Record "Sales Header Archive";
    begin
        ArchiveRecord.SetFilter("Sell-to Customer No.", CustomerRecord."No.");
        ArchiveRecord.SetFilter("Document Type", FORMAT("Sales Document Type"::Order));
        if ArchiveRecord.FindSet() then
            repeat
                InsertRecord(Rec, 0, IndentationEnum::"Original Order No.", Rec."Record Id", 'ARCHIVE! Original Order No.: ' + ArchiveRecord."No.", ArchiveRecord."Due Date", ArchiveRecord."No.", '', 0, '', '', '', 0, "Sales Line Type"::" ");
                InsertRecord(Rec, 0, IndentationEnum::Document, Rec."Record Id", 'ARCHIVE! Order No.: ' + ArchiveRecord."No.", ArchiveRecord."Due Date", '', '', 0, '', '', '', 0, "Sales Line Type"::" ");
                SearchOrderLineArchive(Rec, ArchiveRecord);
                SearchShipment(Rec, ArchiveRecord."No.");
                SearchPostedSalesInvoice(Rec, ArchiveRecord."No.", CustomerRecord."No.");
            until ArchiveRecord.Next = 0;
    end;

    local procedure SearchSalesQuoteArchive(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    var
        ArchiveRecord: Record "Sales Header Archive";
    begin
        ArchiveRecord.SetFilter("Sell-to Customer No.", CustomerRecord."No.");
        ArchiveRecord.SetFilter("Document Type", FORMAT("Sales Document Type"::Quote));
        if ArchiveRecord.FindSet() then
            repeat
                InsertRecord(Rec, 0, IndentationEnum::"Original Order No.", Rec."Record Id", 'ARCHIVE! Quote Original Order No.: ' + ArchiveRecord."Original Order No.", ArchiveRecord."Due Date", ArchiveRecord."No.", '', 0, '', '', '', 0, "Sales Line Type"::" ");
                InsertRecord(Rec, 0, IndentationEnum::Document, Rec."Record Id", 'ARCHIVE! Quote No.: ' + ArchiveRecord."No.", ArchiveRecord."Due Date", '', '', 0, '', '', '', 0, "Sales Line Type"::" ");
                SearchQuoteLineArchive(Rec, ArchiveRecord);
            until ArchiveRecord.Next = 0;
    end;

    local procedure SearchQuoteLineArchive(var Rec: Record SalesOverview; var SalesHeaderArchiveRecord: Record "Sales Header Archive")
    var
        LineArchive: Record "Sales Line Archive";
    begin
        LineArchive.SetRange("Document Type", SalesHeaderArchiveRecord."Document Type"::Quote);
        LineArchive.SetRange("Document No.", SalesHeaderArchiveRecord."No.");
        if LineArchive.FindSet() then
            repeat
                InsertRecord(Rec, LineArchive."Line No.", IndentationEnum::"Order Line", Rec."Record Id", 'ARCHIVE! Quote Order Line', Rec.Date, SalesHeaderArchiveRecord."No.", LineArchive.Description, LineArchive.Quantity, LineArchive."Unit of Measure", '', '', LineArchive.Amount, "Sales Line Type"::" ");
            until LineArchive.Next = 0;
    end;

    local procedure SearchSalesInvoice(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    begin
        SalesHeaderRec.SetRange("Sell-to Customer No.", CustomerRecord."No.");
        SalesHeaderRec.SetRange("Document Type", "Sales Document Type"::Invoice);
        if SalesHeaderRec.FindSet() then
            repeat
                // Insert Original Order
                InsertRecord(Rec, 0, IndentationEnum::"Original Order No.", Rec."Record Id", 'Original Order : ' + SalesHeaderRec."No.", SalesHeaderRec."Due Date", SalesHeaderRec."No.", '', 0, '', SalesHeaderRec."No.", CustomerRecord."No.", 0, "Sales Line Type"::" ");
                // Insert Invoice
                InsertRecord(Rec, 0, IndentationEnum::Document, Rec."Record Id", 'Sales Invoice ' + SalesHeaderRec."No.", SalesHeaderRec."Due Date", SalesHeaderRec."No.", '', 0, '', SalesHeaderRec."No.", CustomerRecord."No.", 0, "Sales Line Type"::" ");
                // Get Lines for the Invoice
                SearchSalesLine(Rec, SalesHeaderRec, CustomerRecord."No.");
            until SalesHeaderRec.Next = 0;
    end;

    local procedure SearchSalesLine(var Rec: Record SalesOverview; var SalesHeaderRecord: Record "Sales Header"; CustomerNo: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeaderRecord."Document Type");
        SalesLine.SetRange("Document No.", SalesHeaderRecord."No.");

        if SalesLine.FindSet() then
            repeat
                InsertRecord(Rec, SalesLine."Line No.", IndentationEnum::"Order Line", Rec."Record Id", 'Line', Rec.Date, SalesHeaderRecord."No.", SalesLine.Description, SalesLine.Quantity, SalesLine."Unit of Measure", SalesHeaderRecord."No.", CustomerNo, SalesLine.Amount, SalesLine."Document Type");
            until SalesLine.Next = 0;
    end;

    local procedure SearchSalesOrder(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    begin
        SalesHeaderRec.SetRange("Sell-to Customer No.", CustomerRecord."No.");
        SalesHeaderRec.SetRange("Document Type", "Sales Document Type"::Order);

        if SalesHeaderRec.FindSet() then
            repeat
                // Insert Original Order    - 2nd level
                InsertRecord(Rec, 0, IndentationEnum::"Original Order No.", Rec."Record Id", 'Original Order : ' + SalesHeaderRec."No.", SalesHeaderRec."Due Date", SalesHeaderRec."No.", '', 0, '', SalesHeaderRec."No.", CustomerRecord."No.", 0, "Sales Line Type"::" ");
                // Insert Order             - 3rd level
                InsertRecord(Rec, 0, IndentationEnum::Document, Rec."Record Id", 'Order ' + SalesHeaderRec."No.", SalesHeaderRec."Due Date", SalesHeaderRec."No.", '', 0, '', SalesHeaderRec."No.", CustomerRecord."No.", 0, "Sales Line Type"::" ");
                // Get Lines for the Order  - 4th level
                SearchSalesLine(Rec, SalesHeaderRec, CustomerRecord."No.");
                // Shipments
                SearchShipment(Rec, SalesHeaderRec."No.");
                // Posted Sales
                SearchPostedSalesInvoice(Rec, SalesHeaderRec."No.", CustomerRecord."No.");
            until SalesHeaderRec.Next = 0;
    end;

    local procedure SearchSalesQuote(var Rec: Record SalesOverview; var CustomerRecord: Record Customer)
    var
        SalesQuoteRec: Record "Sales Header";
    begin
        SalesQuoteRec.Setfilter("Sell-to Customer No.", CustomerRecord."No.");
        SalesQuoteRec.SetFilter("Document Type", FORMAT(Enum::"Sales Document Type"::Quote));
        if SalesQuoteRec.FindSet() then
            repeat
                InsertRecord(Rec, 0, Enum::IndentationEnum::"Original Order No.", Rec."Record Id", 'Offer Original Order No.: ' + SalesQuoteRec."No.", SalesQuoteRec."Due Date", SalesQuoteRec."No.", '', 0, '', '', '', 0, "Sales Line Type"::" ");
                InsertRecord(Rec, 0, Enum::IndentationEnum::Document, Rec."Record Id", 'Offer Order No.: ' + SalesQuoteRec."No.", SalesQuoteRec."Due Date", '', '', 0, '', '', '', 0, "Sales Line Type"::" ");
                SearchSalesQuoteLine(Rec, SalesQuoteRec, CustomerRecord);
            until SalesQuoteRec.Next() = 0;
    end;

    local procedure SearchSalesQuoteLine(var Rec: Record SalesOverview; var SalesQuoteRec: Record "Sales Header"; var CustomerRecord: Record Customer)
    var
        LineSalesQuote: Record "Sales Line";
    begin
        LineSalesQuote.SetRange("Document Type", SalesQuoteRec."Document Type"::Quote);
        LineSalesQuote.SetRange("Document No.", SalesQuoteRec."No.");
        if LineSalesQuote.FindSet() then
            repeat
                InsertRecord(Rec, LineSalesQuote."Line No.", Enum::IndentationEnum::"Order Line", Rec."Record Id", 'Offer Order Line', Rec.Date, LineSalesQuote."No.", LineSalesQuote.Description, LineSalesQuote.Quantity, LineSalesQuote."Unit of Measure", '', '', LineSalesQuote.Amount, "Sales Line Type"::" ");
            until LineSalesQuote.Next() = 0;
    end;

    local procedure SearchShipment(var Rec: Record SalesOverview; OrderNo: Code[20])
    var
        SalesShipmentRec: Record "Sales Shipment Header";
    begin
        SalesShipmentRec.SetFilter("Order No.", OrderNo);
        if SalesShipmentRec.FindSet() then
            repeat
                InsertRecord(Rec, 0, Enum::IndentationEnum::Document, Rec."Record Id", 'Sales shipment No.: ' + SalesShipmentRec."No.", SalesShipmentRec."Due Date", '', '', 0, '', '', '', 0, "Sales Line Type"::" ");
                SearchShipmentLine(Rec, SalesShipmentRec."No.");
            until SalesShipmentRec.Next() = 0;
    end;

    local procedure SearchShipmentLine(var Rec: Record SalesOverview; DocumentNo: Code[20])
    var
        SalesShipmentLineRec: Record "Sales Shipment Line";
        SalesLineRec: Record "Sales Line";
    begin
        SalesShipmentLineRec.SetFilter("Document No.", DocumentNo);
        if SalesShipmentLineRec.FindSet() then
            repeat
                InsertRecord(Rec, SalesShipmentLineRec."Line No.", Enum::IndentationEnum::"Order Line", Rec."Record Id", 'Sales shipment Line', Rec.Date, SalesShipmentLineRec."No.", SalesShipmentLineRec.Description, SalesShipmentLineRec.Quantity, SalesShipmentLineRec."Unit of Measure", SalesShipmentLineRec."No.", SalesShipmentLineRec."No.", 0, "Sales Line Type"::" ");
                SearchItemLedgerEntry(Rec, SalesShipmentLineRec."Document No.", SalesShipmentLineRec."Line No.", SalesShipmentLineRec.Description);
            until SalesShipmentLineRec.Next() = 0;
    end;

    local procedure SearchItemLedgerEntry(var Rec: Record SalesOverview; DocumentNo: Code[20]; "Line No.": Integer; ItemName: Text[100])
    var
        ItemLedgerEntryRec: Record "Item Ledger Entry";
    begin
        ItemLedgerEntryRec.SetRange("Document Type", "Item Ledger Document Type"::"Sales Shipment");
        ItemLedgerEntryRec.SetRange("Document No.", DocumentNo);
        ItemLedgerEntryRec.SetRange("Entry Type", "Item Ledger Entry Type"::Sale);
        ItemLedgerEntryRec.SetRange("Document Line No.", "Line No.");
        if ItemLedgerEntryRec.FindSet() then
            repeat
                InsertRecord(Rec, ItemLedgerEntryRec."Document Line No.", Enum::IndentationEnum::"Item Ledger Entry", Rec."Record Id", 'Item Ledger Entry:' + Format(ItemLedgerEntryRec."Entry No."), Rec.Date, Format(ItemLedgerEntryRec."Entry No."), ItemName, ItemLedgerEntryRec.Quantity, ItemLedgerEntryRec."Unit of Measure Code", Format(ItemLedgerEntryRec."Document No."), Format(ItemLedgerEntryRec."Entry No."), ItemLedgerEntryRec."Sales Amount (Actual)", "Sales Line Type"::" ");
            until ItemLedgerEntryRec.Next() = 0;
    end;

    local procedure InsertRecord(
        var Rec: Record SalesOverview;
        "Line No.": Integer;
        Indentation: Enum IndentationEnum;
        "Record Id": RecordId;
        Description: Text[200];
        Date: Date;
        "No.": Code[20];
        Name: Text[100];
        Quantity: Integer;
        "Unit of Measure Code": Code[20];
        "Document No.": Code[20];
        "Customer No.": Code[20];
        Price: Decimal;
        "Sales Line Type": Enum "Sales Line Type")
    begin
        Rec.Init();
        Rec.Id := Id;
        Rec."Line No." := "Line No.";
        Rec.Indentation := Indentation;
        Rec."Record Id" := "Record Id";
        Rec.Description := Description;
        Rec.Date := Date;
        Rec."No." := "No.";
        Rec.Name := Name;
        Rec.Quantity := Quantity;
        Rec."Unit of Measure Code" := "Unit of Measure Code";
        Rec."Document No." := "Document No.";
        Rec."Customer No." := "Customer No.";
        Rec.Price := Price;
        Rec."Document Type" := "Sales Line Type";
        Rec.Insert();
        Id += 1;
    end;

    var
        SalesHeaderRec: Record "Sales Header";
        Id: Integer;

}
