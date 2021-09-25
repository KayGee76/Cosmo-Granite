tableextension 50103 "Sales Line Archive Extention" extends "Sales Line Archive"
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
        Rec."Original Order No." := Rec."Document No.";
    end;
}