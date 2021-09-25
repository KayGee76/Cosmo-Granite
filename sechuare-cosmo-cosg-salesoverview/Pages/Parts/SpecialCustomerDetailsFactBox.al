page 50101 SpecialCustomerDetailsFactBox
{
    Caption = 'Customer Details Factbox';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("Customer Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
                Caption = 'Customer Group';
                ToolTip = 'Specifies the customer''s group(e.g. VIP, B2B, Standard, etc...).';
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Customer No.';
                ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s name.';
            }
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s first name.';
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s street and building number.';
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s additional address info.';
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s city.';
            }
            field("Post Code"; Rec."Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s post code.';
            }
            field("Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s Country/Region code.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ExtendedDatatype = EMail;
                ToolTip = 'Specifies the customer''s email address.';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s telephone number.';
            }
            field("No. of Return Orders"; Rec."No. of Return Orders")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s open sales return orders total number.';
            }
        }
    }
    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Customer Card", Rec);
    end;
}

