codeunit 50101 OriginalOrderNoCodeUnit
{
    Permissions =
        tabledata "Sales Shipment Header" = rm,
        tabledata "Sales Shipment Line" = rm,
        TableData "Sales Invoice Header" = rm,
        tabledata "Sales Invoice Line" = rm,
        tabledata "Item Ledger Entry" = rm;
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        "Sales Header Original No."();
        "Sales Header Archive Original No."();
        "Sales Invoice Original No."();
        "Sales Shipment Original No."();
        "Sales Quote Original No."();
        "Sales Quote Archive Original No."();
        "Item Ledger Entry Original No."();
    end;

    local procedure "Sales Header Original No."()
    var
        SalesHeaderRecord: Record "Sales Header";
        SalesLineRecord: Record "Sales Line";
    begin
        if SalesHeaderRecord.FindSet() then
            repeat
                if (SalesHeaderRecord."Original Order No." = '') and (SalesHeaderRecord."Document Type" = Enum::"Sales Document Type"::Order) then begin
                    SalesHeaderRecord."Original Order No." := SalesHeaderRecord."No.";
                    SalesHeaderRecord.Modify();

                    SalesLineRecord.SetRange("Document Type", SalesHeaderRecord."Document Type");
                    SalesLineRecord.SetRange("Document No.", SalesHeaderRecord."No.");

                    if SalesLineRecord.FindSet() then begin
                        repeat
                            if SalesLineRecord."Original Order No." = '' then begin
                                SalesLineRecord."Original Order No." := SalesLineRecord."Document No.";
                                SalesLineRecord.Modify();
                            end;
                        until SalesLineRecord.Next() = 0;
                    end;
                end;

            until SalesHeaderRecord.Next() = 0;
    end;

    local procedure "Sales Header Archive Original No."()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if SalesInvoiceHeader.FindSet() then
            repeat
                if (SalesInvoiceHeader."Original Order No." = '') then begin
                    if SalesInvoiceHeader."Order No." <> '' then begin
                        SalesInvoiceHeader."Original Order No." := SalesInvoiceHeader."Order No.";
                    end
                    else begin
                        if SalesInvoiceHeader."Quote No." <> '' then begin
                            SalesInvoiceHeader."Original Order No." := SalesInvoiceHeader."Quote No.";
                        end;
                    end;
                    SalesInvoiceHeader.Modify();

                    // Get Lines for the Header
                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    if SalesInvoiceLine.FindSet() then
                        repeat
                            if SalesInvoiceLine."Original Order No." = '' then begin
                                SalesInvoiceLine."Original Order No." := SalesInvoiceHeader."Original Order No.";
                                SalesInvoiceLine.Modify();
                            end;
                        until SalesInvoiceLine.Next = 0;
                end;
            until SalesInvoiceHeader.Next = 0;
    end;

    local procedure "Sales Invoice Original No."()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if SalesInvoiceHeader.FindSet() then
            repeat
                if (SalesInvoiceHeader."Original Order No." = '') then begin
                    if SalesInvoiceHeader."Order No." <> '' then begin
                        SalesInvoiceHeader."Original Order No." := SalesInvoiceHeader."Order No.";
                    end
                    else begin
                        if SalesInvoiceHeader."Quote No." <> '' then begin
                            SalesInvoiceHeader."Original Order No." := SalesInvoiceHeader."Quote No.";
                        end;
                    end;
                    SalesInvoiceHeader.Modify();

                    // Get Lines for the Header
                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    if SalesInvoiceLine.FindSet() then
                        repeat
                            if SalesInvoiceLine."Original Order No." = '' then begin
                                SalesInvoiceLine."Original Order No." := SalesInvoiceHeader."Original Order No.";
                                SalesInvoiceLine.Modify();
                            end;
                        until SalesInvoiceLine.Next = 0;
                end;
            until SalesInvoiceHeader.Next = 0;
    end;

    local procedure "Sales Shipment Original No."()
    var
        SalesShipmentRec: Record "Sales Shipment Header";
        SalesShipmentLineRec: Record "Sales Shipment Line";
    begin
        if SalesShipmentRec.FindSet() then
            repeat
                if (SalesShipmentRec."Original Order No." = '') then begin
                    SalesShipmentRec."Original Order No." := SalesShipmentRec."Order No.";
                    SalesShipmentRec.Modify();

                    SalesShipmentLineRec.SetRange("Document No.", SalesShipmentRec."No.");

                    if SalesShipmentLineRec.FindSet() then
                        repeat
                            if SalesShipmentLineRec."Original Order No." = '' then begin
                                SalesShipmentLineRec."Original Order No." := SalesShipmentLineRec."Order No.";
                                SalesShipmentLineRec.Modify();
                            end;
                        until SalesShipmentRec.Next() = 0;
                end;

            until SalesShipmentRec.Next() = 0;
    end;

    local procedure "Sales Quote Original No."()
    var
        SalesHeaderRecord: Record "Sales Header";
        SalesLineRecord: Record "Sales Line";
    begin
        if SalesHeaderRecord.FindSet() then
            repeat
                if (SalesHeaderRecord."Original Order No." = '') and (SalesHeaderRecord."Document Type" = Enum::"Sales Document Type"::Quote) then begin
                    SalesHeaderRecord."Original Order No." := SalesHeaderRecord."No.";
                    SalesHeaderRecord.Modify();

                    SalesLineRecord.SetRange("Document Type", SalesHeaderRecord."Document Type"::Quote);
                    SalesLineRecord.SetRange("Document No.", SalesHeaderRecord."No.");
                    if SalesLineRecord.FindSet() then
                        repeat
                            if SalesLineRecord."Original Order No." = '' then begin
                                SalesLineRecord."Original Order No." := SalesLineRecord."Document No.";
                                SalesLineRecord.Modify();
                            end;
                        until SalesLineRecord.Next = 0;
                end;
            until SalesHeaderRecord.Next = 0;
    end;

    local procedure "Sales Quote Archive Original No."()
    var
        SalesHeaderArchiveR: Record "Sales Header Archive";
        SalesLineArchiveR: Record "Sales Line Archive";
    begin
        if SalesHeaderArchiveR.FindSet() then
            repeat
                if (SalesHeaderArchiveR."Original Order No." = '') and (SalesHeaderArchiveR."Document Type" = Enum::"Sales Document Type"::Quote) then begin
                    SalesHeaderArchiveR."Original Order No." := SalesHeaderArchiveR."No.";
                    SalesHeaderArchiveR.Modify();

                    SalesLineArchiveR.SetRange("Document Type", SalesHeaderArchiveR."Document Type"::Quote);
                    SalesLineArchiveR.SetRange("Document No.", SalesHeaderArchiveR."No.");

                    if SalesLineArchiveR.FindSet() then
                        repeat
                            if SalesLineArchiveR."Original Order No." = '' then begin
                                SalesLineArchiveR."Original Order No." := SalesLineArchiveR."Document No.";
                                SalesLineArchiveR.Modify();
                            end;
                        until SalesLineArchiveR.Next() = 0;
                end;

            until SalesHeaderArchiveR.Next() = 0;
    end;

    local procedure "Item Ledger Entry Original No."()
    var
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        SalesShipmentRec: Record "Sales Shipment Header";

    begin
        if ItemLedgerEntryRec.FindSet() then
            repeat
                if (ItemLedgerEntryRec."Original Order No." = '') and (ItemLedgerEntryRec."Entry Type" = Enum::"Item Ledger Entry Type"::Sale) and (ItemLedgerEntryRec."Document Type" = "Item Ledger Document Type"::"Sales Shipment") then begin
                    SalesShipmentRec.Get(ItemLedgerEntryRec."Document No.");
                    ItemLedgerEntryRec."Original Order No." := SalesShipmentRec."Original Order No.";
                    ItemLedgerEntryRec.Modify();
                end;
            until ItemLedgerEntryRec.Next() = 0;
    end;
}
