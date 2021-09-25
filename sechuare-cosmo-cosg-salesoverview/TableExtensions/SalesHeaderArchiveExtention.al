tableextension 50102 "Sales Header Archive Extention" extends "Sales Header Archive"
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
        if Rec."Document Type" = "Sales Document Type"::Order then begin
            Rec."Original Order No." := Rec."No.";
        end;
    end;

}