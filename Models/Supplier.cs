using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Supplier
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int? UserId { get; set; }

    public string CompanyName { get; set; } = null!;

    public string? ContactName { get; set; }

    public string? ContactTitle { get; set; }

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public string? HomePage { get; set; }

    public int? AddressId { get; set; }

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
