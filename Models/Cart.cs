using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Cart
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public string? CouponCode { get; set; }

    public string? Note { get; set; }

    public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

    public virtual User User { get; set; } = null!;
}
