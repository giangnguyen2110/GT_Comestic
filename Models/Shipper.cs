using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Shipper
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public string CompanyName { get; set; } = null!;

    public string? Phone { get; set; }

    public int? AddressId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual ICollection<ShipInfo> ShipInfos { get; set; } = new List<ShipInfo>();

    public virtual User? UpdatedByNavigation { get; set; }
}
