using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class AspNetUserLogin
{
    public string LoginProvider { get; set; } = null!;

    public string ProviderKey { get; set; } = null!;

    public string? ProviderDisplayName { get; set; }

    public Guid UserId { get; set; }

    public virtual User User { get; set; } = null!;
}
