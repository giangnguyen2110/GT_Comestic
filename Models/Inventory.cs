using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Inventory
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int VariantId { get; set; }

    public int? Quantity { get; set; }

    public int? WarehouseId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public byte[] RowVersion { get; set; } = null!;

    public virtual ProductVariant Variant { get; set; } = null!;
}
