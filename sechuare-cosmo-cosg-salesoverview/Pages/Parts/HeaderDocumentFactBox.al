page 50102 HeaderDocumentFactBox
{
    Caption = 'Document Factbox';
    PageType = CardPart;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Header';
                field("Document No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the order/document number';

                    trigger OnDrillDown()
                    begin
                        ShowDetails;
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies the external order/document number';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method Code';
                    ToolTip = 'Specifies the payment method.';
                }
            }
        }
    }
    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Sales Order", Rec);
    end;
}

