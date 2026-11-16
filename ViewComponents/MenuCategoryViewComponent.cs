using Microsoft.AspNetCore.Mvc;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;

namespace NhomGT_ComesticShop.ViewComponents
{
    public class MenuCategoryViewComponent : ViewComponent
    {
        private readonly GtEcommerceContext _context;
        public MenuCategoryViewComponent(GtEcommerceContext context) => _context = context;
        public IViewComponentResult Invoke()
        {
            var data = _context.Categories
         .Select(c => new MenuCategory
         {
             categoryId = c.Id,
             categoryName = c.CategoryName,
             soLuong = _context.Products.Count(p => p.CategoryId == c.Id)
         })
         .ToList();

            return View(data); // default.cshtml

        }
    }
}
