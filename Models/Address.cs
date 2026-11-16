using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Address
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public string? AddressNo { get; set; }

    public int? CountryId { get; set; }

    public int? ProvinceId { get; set; }

    public int? WardId { get; set; }

    public int? TownId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public string? City { get; set; }

    public string? Region { get; set; }

    public string? PostalCode { get; set; }

    public string? Country { get; set; }

    public string? Extension { get; set; }

    public virtual User? CreatedByNavigation { get; set; }

    public virtual ICollection<Customer> Customers { get; set; } = new List<Customer>();

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual User? UpdatedByNavigation { get; set; }
}
