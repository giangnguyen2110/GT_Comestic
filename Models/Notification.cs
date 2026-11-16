using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class Notification
{
    public int Id { get; set; }

    public Guid UserId { get; set; }

    public string Message { get; set; } = null!;

    public bool IsRead { get; set; }

    public DateTime CreatedAt { get; set; }

    public int? OrderId { get; set; }

    public virtual User User { get; set; } = null!;
}
