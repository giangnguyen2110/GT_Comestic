using System;
using System.Collections.Generic;

namespace NhomGT_ComesticShop.Models;

public partial class AspNetRoleClaim
{
    public int Id { get; set; }

    public Guid RoleId { get; set; }

    public string? ClaimType { get; set; }

    public string? ClaimValue { get; set; }

    public virtual Role Role { get; set; } = null!;
}
