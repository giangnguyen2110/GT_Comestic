using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Models; // Thay bằng namespace của Model Brand của bà
using NhomGT_ComesticShop.Data;   // Thay bằng namespace của DbContext của bà

public class BrandsViewComponent : ViewComponent
{
    private readonly GtEcommerceContext _context;
    public BrandsViewComponent(GtEcommerceContext context) => _context = context;

    public async Task<IViewComponentResult> InvokeAsync()
    {
        var suppliers = await _context.Suppliers.ToListAsync();
        return View("Default", suppliers);
    }
}