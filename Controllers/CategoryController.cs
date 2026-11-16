using Microsoft.AspNetCore.Mvc;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.Models;

namespace NhomGT_ComesticShop.Controllers
{
    public class CategoryController : Controller
    {
        private readonly GtEcommerceContext _context;
        public CategoryController(GtEcommerceContext context)
        {
            _context = context;
        }
        public IActionResult Index(int? loai)
        {
            var products = _context.Products.AsQueryable();
            if (loai.HasValue)
            {
                products = products.Where(p => p.CategoryId == loai.Value);
            }
            var result = products.Select(p => new ProductVM

            {
                productId = p.Id,
                productName = p.ProductName,
                productPrice = p.UnitPrice ?? 0,
                //productImage = p.


            });
            return View();
        }
    }
}
