using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Customer
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public Guid? UserId { get; set; }

    public string? CompanyName { get; set; }

    public string? ContactName { get; set; }

    public string? ContactTitle { get; set; }

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public int? AddressId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int Status { get; set; }

    public virtual Address? Address { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual User? UpdatedByNavigation { get; set; }

    public virtual User? User { get; set; }
}
