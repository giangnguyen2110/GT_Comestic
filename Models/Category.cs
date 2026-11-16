using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Category
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? Description { get; set; }

    public string Picture { get; set; } = string.Empty!;

    public DateTime CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public string? Notes { get; set; }

    public int Status { get; set; }

    public Guid? CreatedBy { get; set; }

    public Guid? UpdatedBy { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();

    public virtual User? UpdatedByNavigation { get; set; }
}
