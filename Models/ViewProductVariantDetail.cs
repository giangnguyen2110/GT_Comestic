using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class ViewProductVariantDetail
{
    public int VariantId { get; set; }

    public int? ProductId { get; set; }

    public string? Sku { get; set; }

    public decimal? Price { get; set; }

    public int? StockQuantity { get; set; }

    public string? VariantOptions { get; set; }
}
