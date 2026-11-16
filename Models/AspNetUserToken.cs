using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class AspNetUserToken
{
    public Guid UserId { get; set; }

    public string LoginProvider { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Value { get; set; }

    public virtual User User { get; set; } = null!;
}
