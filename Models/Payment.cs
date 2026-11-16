using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Payment
{
    public int Id { get; set; }

    public Guid Uid { get; set; }

    public int OrderId { get; set; }

    public decimal Amount { get; set; }

    public string? Method { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid? CreatedBy { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public Guid? UpdatedBy { get; set; }

    public string? Notes { get; set; }

    public int? Status { get; set; }

    public virtual Order Order { get; set; } = null!;
}
