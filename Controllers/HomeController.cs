using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Models;
using System.Diagnostics;

namespace NhomGT_ComesticShop.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly GtEcommerceContext _context;

        public HomeController(ILogger<HomeController> logger, GtEcommerceContext context)
        {
            _logger = logger;
            _context = context;
        }

        public IActionResult Index()
        {
            var viewModel = new HomeViewModels
            {
                Categories = _context.Categories
                     .Include(c => c.Products) // <--- Thêm dòng này để load dữ liệu con
                     .ToList(),
                Products = _context.Products.OrderBy(p => Guid.NewGuid()).Take(8).ToList()

            };

            return View(viewModel);
        }

        public IActionResult GetProductDetail(int id)
        {
            var product = _context.Products
               .Include(p => p.ProductVariants)
               .Include(p => p.ProductVariants)
                .ThenInclude(v => v.ProductVariantOptionValues)
                .ThenInclude(pov => pov.ProductOptionValue)
            .ThenInclude(po => po.ProductOption)// Phải Include biến thể thì Popup mới có dữ liệu để chọn
               .FirstOrDefault(p => p.Id == id);

            if (product == null) return NotFound();
            // Dòng này giúp bạn biết chắc chắn là có biến thể hay không
            var count = product.ProductVariants.Count;
            System.Diagnostics.Debug.WriteLine("Số lượng biến thể tìm thấy: " + count);

            // Chỉ định đường dẫn đầy đủ từ thư mục Views
            return PartialView("~/Views/Product/_DetailPopup.cshtml", product);
        }

        [Route("/404")]
        public IActionResult PageNotFound()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
