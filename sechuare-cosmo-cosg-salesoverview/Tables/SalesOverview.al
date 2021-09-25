table 50100 SalesOverview
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; Id; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(3; Indentation; Enum IndentationEnum)
        {
            DataClassification = CustomerContent;
        }

        field(4; "Record Id"; RecordId)
        {
            DataClassification = CustomerContent;
        }

        field(5; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(6; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }

        field(7; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(8; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }

        field(9; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }

        field(10; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }

        field(11; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(12; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        field(13; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }

        field(14; "Original Order No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Document Type"; Enum "Sales Line Type")
        {
            DataClassification = CustomerContent;
        }

    }


    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}