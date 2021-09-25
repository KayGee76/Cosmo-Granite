page 50100 SalesOverviewList
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = SalesOverview;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(DocumentNumber; DocumentNumber)
                {
                    Caption = 'Document No. Filter';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ExternalOrderNumber; ExternalOrderNumber)
                {
                    Caption = 'External Order No. Filter';
                    ApplicationArea = all;
                }
                field(OrderNumber; OrderNumber)
                {
                    Caption = 'Order No. Filter';
                    ApplicationArea = all;
                }
                field(PackageTrackingNumber; PackageTrackingNumber)
                {
                    Caption = 'Package Tracking No. Filter';
                    ApplicationArea = All;
                }
                field(SerialNumber; SerialNumber)
                {
                    Caption = 'Serial No. Filter';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CustomerNumber; CustomerNumber)
                {
                    Caption = 'Customer No. Filter';
                    ApplicationArea = All;
                    TableRelation = Customer;
                }
                field(CustomerName; CustomerName)
                {
                    Caption = 'Customer Name Filter';
                    ApplicationArea = All;
                }

                field(CustomerPhone; CustomerPhone)
                {
                    Caption = 'Phone No. Filter';
                    ApplicationArea = All;
                }
                field(CustomerEmail; CustomerEmail)
                {
                    Caption = 'E-mail Filter';
                    ApplicationArea = All;
                }
            }

            repeater(General)
            {
                IndentationColumn = Rec.Indentation.AsInteger();
                ShowAsTree = true;
                TreeInitialState = CollapseAll;
                IndentationControls = Description;
                Editable = false;
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleExprTxt;
                }

                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }

                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(CustomerDetailsFactBox; SpecialCustomerDetailsFactBox)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Customer No.");
            }
            part(HeaderDocumentFactBox; HeaderDocumentFactBox)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Document No.");
            }
            part(LineDocumentFactBox; LineDocumentFactBox)
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Line No." = FIELD("Line No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Refresh;

                trigger OnAction()
                begin
                    Filter.UpdateSalesOverview(Rec, CustomerNumber, CustomerName, CustomerPhone, CustomerEmail, OrderNumber, ExternalOrderNumber, PackageTrackingNumber);
                end;
            }
            action("Show Document")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Document;

                trigger OnAction()
                var
                    CustomerRecord: Record Customer;
                    SalesHeaderRecord: Record "Sales Header";
                    SalesLineRecord: Record "Sales Line";
                    salesinvoiceRec: Record "Sales Invoice Header";

                /*RecRef: RecordRef;
                Fieldref: FieldRef;
                RecVariant: Variant;*/
                begin
                    case Rec.Indentation of
                        Rec.Indentation::Customer:
                            begin
                                CustomerRecord.Get(Rec."Customer No.");
                                Page.Run(Page::"Customer Card", CustomerRecord);
                            end;

                        Rec.Indentation::Document:
                            begin
                                case Rec."Document Type" of
                                    Rec."Document Type"::" ":
                                        begin
                                            SalesHeaderRecord.Get(Enum::"Sales Document Type"::Order, Rec."No.");   //Fieldref := RecRef.Field(3);
                                            Page.Run(Page::"Sales Order", SalesHeaderRecord);
                                        end;
                                //Fieldref.SetRange(Rec."No.");
                                end;
                            end;

                        Rec.Indentation::"Order Line":
                            begin

                                SalesHeaderRecord.Get(Enum::"Sales Document Type"::Order, Rec."No.");
                                Page.Run(Page::"Sales Order", SalesHeaderRecord);

                                SalesHeaderRecord.Get(Enum::"Sales Document Type"::Invoice, Rec."No.");
                                Page.Run(Page::"Posted Sales Invoice Lines", SalesHeaderRecord);
                            end;

                    end;
                    /* if RecRef.FindFirst() then begin
                         RecVariant := RecRef;
                         Page.Run(0, RecVariant);
                     end;*/

                end;
            }

        }
    }
    var
        CustomerNumber:
            Text[100];
        CustomerName:
                            Text[100];
        CustomerPhone:
                            Text[100];
        CustomerEmail:
                            Text[100];
        DocumentNumber:
                            Text[100];
        ExternalOrderNumber:
                            Text[100];
        OrderNumber:
                            Text[100];
        PackageTrackingNumber:
                            Text[100];
        SerialNumber:
                            Text[100];
        StyleExprTxt:
                            Text[10];
        Filter:
                            Codeunit SalesOverviewCodeunit;

    trigger OnOpenPage()
    var
    begin
        Filter.UpdateSalesOverview(Rec, '', '', '', '', '', '', '');
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Indentation of
            Enum::IndentationEnum::Customer:
                StyleExprTxt := 'Strong';
            else
                StyleExprTxt := 'Standard';
        end;
        if Rec.Description.StartsWith('ARCHIVE') then begin
            StyleExprTxt := 'Attention';
        end;
    end;
}