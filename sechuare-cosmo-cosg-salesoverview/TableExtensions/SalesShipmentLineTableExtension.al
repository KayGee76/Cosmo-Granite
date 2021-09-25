tableextension 50105 SalesShipmentLineExtension extends "Sales Shipment Line"
{

    fields
    {
        field(50102; "Original Order No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}