using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.Models;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;


namespace NhomGT_ComesticShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly GtEcommerceContext _context;
        public ProductController(GtEcommerceContext context)
        {
            _context = context;
        }
        // Gộp logic lọc vào Index để hỗ trợ lọc kép (loại + giá)
        public async Task<IActionResult> Index(string? query, int? loai, int? minPrice, int? maxPrice, int page = 1, int record = 9)
        {
            var products = _context.Products.AsQueryable();

            // 🔍 search
            if (!string.IsNullOrEmpty(query))
            {
                products = products.Where(p =>
                    p.ProductName.Contains(query)
                );
            }

            // 📦 filter category
            if (loai.HasValue)
            {
                products = products.Where(p => p.CategoryId == loai.Value);
                ViewBag.CurrentLoai = loai;
            }

            // 💰 filter price
            if (minPrice.HasValue)
            {
                products = products.Where(p => p.UnitPrice >= minPrice.Value);
                ViewBag.MinPrice = minPrice;
            }

            if (maxPrice.HasValue)
            {
                products = products.Where(p => p.UnitPrice <= maxPrice.Value);
                ViewBag.MaxPrice = maxPrice;
            }

            // 🔥 paging
            int totalRecord = await products.CountAsync();
            int totalPage = (int)Math.Ceiling(totalRecord / (double)record);

            ViewBag.TotalPage = totalPage;
            ViewBag.CurrentPage = page;
            ViewBag.Record = record;

            // 🔥 giữ state
            ViewBag.Query = query;

            var result = await products
                .OrderBy(p => p.Id)
                .Skip((page - 1) * record)
                .Take(record)
                .Select(p => new ProductVM
                {
                    productId = p.Id,
                    productName = p.ProductName,
                    productPrice = p.UnitPrice ?? 0,
                    productImage = p.Picture ?? ""
                })
                .ToListAsync();

            return View(result);
        }


        public IActionResult FilterByCategory(int? loai)
        {
            return RedirectToAction("Index", new { loai = loai });
        }

        public IActionResult FilterByPrice(int? minPrice, int? maxPrice)
        {
            return RedirectToAction("Index", new { minPrice = minPrice, maxPrice = maxPrice });
        }

        public async Task<IActionResult> Search(string? query)
        {
            var products = _context.Products.AsQueryable();

            if (!string.IsNullOrEmpty(query))
            {
                products = products.Where(p => p.ProductName.Contains(query));
            }

            var result = await products
                .Select(p => new ProductVM
                {
                    productId = p.Id,
                    productName = p.ProductName,
                    productPrice = p.UnitPrice ?? 0,
                    productImage = p.Picture ?? ""
                })
                .ToListAsync();

            return View(result);
        }
        [AllowAnonymous]
        public IActionResult Detail(int id)
        {
            var data = _context.Products
                .Include(p => p.Category)
                .SingleOrDefault(p => p.Id == id);
            if (data == null)
            {
                TempData["Message"] = $"Không thấy sản phẩm có mã {id}";
                return Redirect("/404");
            }
            return View(data);
        }

        [AllowAnonymous]
        public IActionResult DetailPopup(int id)
        {
            var product = _context.Products

                .Include(p => p.Category)

                .Include(p => p.ProductVariants)

                    .ThenInclude(v => v.ProductVariantOptionValues)

                        .ThenInclude(x => x.ProductOptionValue)

                            .ThenInclude(x => x.ProductOption)

                .SingleOrDefault(p => p.Id == id);

            if (product == null)
            {
                return Content("Không tìm thấy sản phẩm");
            }

            return PartialView("_DetailPopup", product);
        }

        [Authorize(Roles = "Admin, Employee")]
        public IActionResult Create()
        {
            ViewBag.Categories = _context.Categories.ToList();
            return View();
        }

        [Authorize(Roles = "Admin, Employee")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Product model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.Categories = _context.Categories.ToList();
                return View(model);
            }

            var product = new Product
            {
                ProductName = model.ProductName,
                UnitPrice = model.UnitPrice,
                CategoryId = model.CategoryId,
                Picture = model.Picture,
                Description = model.Description,
                CreatedAt = DateTime.Now,
                Status = 1
            };

            _context.Products.Add(product);
            await _context.SaveChangesAsync();

            return RedirectToAction("Index");
        }

        [Authorize(Roles = "Admin, Employee")]
        public async Task<IActionResult> Edit(int id)
        {
            var product = await _context.Products.FindAsync(id); ;
            if(product == null)
            {
                return NotFound();

            }
            ViewBag.Categories = _context.Categories.ToList();
            return View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Product model, IFormFile ImageFile)
        {
            if (id != model.Id)
                return BadRequest();

            if (!ModelState.IsValid)
            {
                ViewBag.Categories = _context.Categories.ToList();
                return View(model);
            }

            var product = await _context.Products.FindAsync(id);

            if (product == null)
                return NotFound();

            // update text fields
            product.ProductName = model.ProductName;
            product.UnitPrice = model.UnitPrice;
            product.CategoryId = model.CategoryId;
            product.Description = model.Description;
            product.UpdatedAt = DateTime.Now;

            // 🔥 xử lý upload ảnh mới
            if (ImageFile != null && ImageFile.Length > 0)
            {
                var fileName = Path.GetFileName(ImageFile.FileName);
                var path = Path.Combine(Directory.GetCurrentDirectory(),
                                        "wwwroot/Picture", fileName);

                using (var stream = new FileStream(path, FileMode.Create))
                {
                    await ImageFile.CopyToAsync(stream);
                }

                product.Picture = fileName; // lưu ảnh mới
            }

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }
        [Authorize(Roles = "Admin, Employee")]
        public async Task<IActionResult> Delete (int id)
        {
            var product = await _context.Products.FirstOrDefaultAsync(p => p.Id == id);
            if(product == null) return NotFound();
            return View(product);
        }

        [Authorize(Roles = "Admin, Employee")]
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteCofirmed(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if(product == null)
            
                return NotFound();
            
            _context.Products.Remove(product);

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        
        
    }
}
