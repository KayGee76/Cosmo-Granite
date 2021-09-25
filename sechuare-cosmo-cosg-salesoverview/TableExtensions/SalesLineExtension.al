tableextension 50101 "Sales Line Extension" extends "Sales Line"
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