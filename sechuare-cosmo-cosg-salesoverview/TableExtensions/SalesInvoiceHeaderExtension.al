tableextension 50106 SalesInvoiceHeaderExtension extends "Sales Invoice Header"
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
        else begin
            if Rec."Quote No." <> '' then begin
                Rec."Original Order No." := Rec."Quote No.";
            end;
        end;
    end;
}