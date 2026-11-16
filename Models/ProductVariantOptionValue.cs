using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class ProductVariantOptionValue
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int ProductVariantId { get; set; }

    public int ProductOptionValueId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public virtual ProductOptionValue ProductOptionValue { get; set; } = null!;

    public virtual ProductVariant ProductVariant { get; set; } = null!;
}
