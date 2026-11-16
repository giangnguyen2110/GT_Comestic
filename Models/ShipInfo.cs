using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class ShipInfo
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int OrderId { get; set; }

    public int ShipperId { get; set; }

    public int? CountryId { get; set; }

    public int? ProvinceId { get; set; }

    public int? WardId { get; set; }

    public int? TownId { get; set; }

    public int? AddressId { get; set; }

    public DateTime? RequiredDate { get; set; }

    public DateTime? ShippedDate { get; set; }

    public string? ShipAddress { get; set; }

    public string? ShipName { get; set; }

    public string? ShipPhone { get; set; }

    public string? ShipCity { get; set; }

    public string? ShipRegion { get; set; }

    public string? ShipPostalCode { get; set; }

    public string? ShipCountry { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual Order Order { get; set; } = null!;

    public virtual Shipper Shipper { get; set; } = null!;

    public virtual User? UpdatedByNavigation { get; set; }
}
