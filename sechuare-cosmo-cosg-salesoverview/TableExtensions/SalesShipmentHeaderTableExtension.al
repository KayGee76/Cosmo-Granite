tableextension 50104 SalesShipmentHeaderExtension extends "Sales Shipment Header"
{
    fields
    {
        field(50102; "Original Order No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}