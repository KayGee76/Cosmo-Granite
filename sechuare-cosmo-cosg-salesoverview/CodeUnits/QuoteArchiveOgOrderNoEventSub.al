codeunit 50107 QuoteArchiveOgOrderNoEventSub
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeArchiveSalesQuote', '', true, true)]
    local procedure SalesQuoteArchive(var SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        SalesQuoteHeader."Original Order No." := SalesOrderHeader."No.";
    end;
}