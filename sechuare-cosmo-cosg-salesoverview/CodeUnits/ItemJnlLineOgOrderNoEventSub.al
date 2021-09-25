codeunit 50104 ItemJnlLineOgOrderNoEventSub
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeItemJnlPostLine', '', true, true)]
    local procedure ItemJournalLineInsert(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
        ItemJournalLine."Original Order No." := SalesLine."Original Order No.";
    end;
}