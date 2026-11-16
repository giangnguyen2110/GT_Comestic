using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class ProductOptionValue
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int? ProductOptionId { get; set; }

    public string Name { get; set; } = null!;

    public int? SortOrder { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public virtual ProductOption? ProductOption { get; set; }

    public virtual ICollection<ProductVariantOptionValue> ProductVariantOptionValues { get; set; } = new List<ProductVariantOptionValue>();
}
