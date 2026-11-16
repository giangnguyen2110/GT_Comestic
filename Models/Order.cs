using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Order
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int? CustomerId { get; set; }

    public int? EmployeeId { get; set; }

    public DateTime? OrderDate { get; set; }

    public decimal? Freight { get; set; }

    public string? Receive { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int Status { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual Customer? Customer { get; set; }

    public virtual Employee? Employee { get; set; }

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual ICollection<ShipInfo> ShipInfos { get; set; } = new List<ShipInfo>();

    public virtual User? UpdatedByNavigation { get; set; }
}
