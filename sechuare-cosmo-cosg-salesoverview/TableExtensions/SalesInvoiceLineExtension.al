tableextension 50107 SalesInvoiceLineExtension extends "Sales Invoice Line"
{
    fields
    {
        field(50102; "Original Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Order No." <> '' then begin
            Rec."Original Order No." := Rec."Order No.";
        end
    end;
}