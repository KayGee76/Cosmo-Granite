page 50103 LineDocumentFactBox
{
    Caption = 'Document Factbox';
    PageType = CardPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            group(Line)
            {
                Caption = 'Line';
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    ToolTip = 'Specifies the item''s name.';

                    trigger OnDrillDown()
                    begin
                        ShowDetails;
                    end;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Item Name 2';
                    ToolTip = 'Specifies the item''s name.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the item''s type.';
                }
                field("Item Number"; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item Number';
                    ToolTip = 'Specifies the item''s unique number.';
                }
                field("Free Inventory"; CalculatedInventory)
                {
                    ApplicationArea = All;
                    Caption = 'Free Inventory';
                    ToolTip = 'Specifies the item''s availability.';
                    BlankZero = true;
                    DecimalPlaces = 0 : 5;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Gross Weight';
                    ToolTip = 'Specifies the item''s gross weight.';
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Net Weight';
                    ToolTip = 'Specifies the item''s net weight.';
                }

            }
        }
    }
    var
        ItemRecord: Record Item;
        CalculatedInventory: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        if ItemRecord.Get(Rec."No.") then begin
            ItemRecord.CalcFields(Inventory);
            CalculatedInventory := ItemRecord.Inventory;
        end else
            CalculatedInventory := 0;
    end;

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Sales Order Subform", Rec);
    end;
}

