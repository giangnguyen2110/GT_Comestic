using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Helpers;
using NhomGT_ComesticShop.Models;


namespace NhomGT_ComesticShop.Controllers
{
    [Authorize(Roles = "Customer")]
    public class CartController : Controller
    {
        private readonly GtEcommerceContext _context;

        public CartController(GtEcommerceContext context)
        {
            _context = context;
        }

        // =========================
        // VIEW CART
        // =========================
        //public IActionResult Index()
        //{
        //    var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        //    if (!Guid.TryParse(userIdStr, out var userId))
        //        return RedirectToAction("Login", "Account");

        //    var cart = _context.Carts
        //        .Include(x => x.CartItems)
        //            .ThenInclude(x => x.ProductVariant)
        //                .ThenInclude(v => v.Product)
        //        .FirstOrDefault(x => x.UserId == userId);

        //    var items = cart?.CartItems?.ToList() ?? new List<CartItem>();

        //    return View(items);
        //}

        public IActionResult Index()
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            var cart = _context.Carts

                .Include(x => x.CartItems)

                    .ThenInclude(x => x.ProductVariant)

                        .ThenInclude(v => v.Product)

                .Include(x => x.CartItems)

                    .ThenInclude(x => x.ProductVariant)

                        .ThenInclude(v => v.ProductVariantOptionValues)

                            .ThenInclude(pv => pv.ProductOptionValue)

                .FirstOrDefault(x => x.UserId == userId);

            var items = cart?.CartItems?.ToList() ?? new List<CartItem>();

            return View(items);
        }

        // =========================
        // ADD TO CART
        // =========================
        public IActionResult AddToCart(Guid variantUid, int quantity = 1)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            var variant = _context.ProductVariants
                .FirstOrDefault(x => x.Uid == variantUid);

            if (variant == null)
                return NotFound();

            var cart = _context.Carts
                .Include(x => x.CartItems)
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
            {
                cart = new Cart
                {
                    Id = Guid.NewGuid(),
                    UserId = userId,
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now
                };

                _context.Carts.Add(cart);
                _context.SaveChanges();
            }

            var item = _context.CartItems
                .FirstOrDefault(x => x.CartId == cart.Id && x.ProductVariantUid == variantUid);

            // =========================
            // FIX LOGIC QUANTITY
            // =========================
            if (item != null)
            {
                var newQty = item.Quantity + quantity;

                if (newQty <= 0)
                {
                    _context.CartItems.Remove(item);
                }
                else
                {
                    if (newQty > (variant.StockQuantity ?? 0))
                        return BadRequest("Không đủ hàng trong kho");

                    item.Quantity = newQty;
                }
            }
            else
            {
                if (quantity <= 0)
                    return RedirectToAction("Index");

                _context.CartItems.Add(new CartItem
                {
                    Id = Guid.NewGuid(),
                    CartId = cart.Id,
                    ProductVariantUid = variantUid,
                    Quantity = quantity,
                    Price = variant.Price ?? 0,
                    CreatedAt = DateTime.Now
                });
            }

            cart.UpdatedAt = DateTime.Now;

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        // =========================
        // REMOVE ITEM
        // =========================
        public IActionResult RemoveCart(Guid id)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            var cart = _context.Carts
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
                return RedirectToAction("Index");

            var item = _context.CartItems
                .FirstOrDefault(x => x.Id == id && x.CartId == cart.Id);

            if (item != null)
            {
                _context.CartItems.Remove(item);
                _context.SaveChanges();
            }

            return RedirectToAction("Index");
        }

        // =========================
        // UPDATE QUANTITY (NEW - NÊN CÓ)
        // =========================
        [HttpPost]
        public IActionResult UpdateQuantity(Guid id, int quantity)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            var cart = _context.Carts
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
                return RedirectToAction("Index");

            var item = _context.CartItems
                .Include(x => x.ProductVariant)
                .FirstOrDefault(x => x.Id == id && x.CartId == cart.Id);

            if (item == null)
                return NotFound();

            if (quantity <= 0)
            {
                _context.CartItems.Remove(item);
            }
            else
            {
                if (item.ProductVariant.StockQuantity < quantity)
                    return BadRequest("Không đủ hàng trong kho");

                item.Quantity = quantity;
            }

            cart.UpdatedAt = DateTime.Now;

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult PlusMinus(Guid id, int quantity)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return Json(new { success = false, message = "Chưa đăng nhập" });

            var cart = _context.Carts
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
                return Json(new { success = false, message = "Không tìm thấy giỏ hàng" });

            var item = _context.CartItems
                .Include(x => x.ProductVariant)
                .FirstOrDefault(x => x.Id == id && x.CartId == cart.Id);

            if (item == null)
                return Json(new { success = false, message = "Sản phẩm không tồn tại" });

            item.Quantity += quantity;

            // nếu quantity <= 0 thì xoá
            if (item.Quantity <= 0)
            {
                _context.CartItems.Remove(item);
                _context.SaveChanges();

                var cartCountRemove = _context.CartItems
                    .Where(x => x.CartId == cart.Id)
                    .Sum(x => x.Quantity);

                return Json(new
                {
                    success = true,
                    message = "Đã xoá sản phẩm",
                    cartCount = cartCountRemove
                });
            }

            // check tồn kho
            if (item.Quantity > (item.ProductVariant.StockQuantity ?? 0))
            {
                item.Quantity -= quantity;

                return Json(new
                {
                    success = false,
                    message = "Không đủ hàng trong kho"
                });
            }

            cart.UpdatedAt = DateTime.Now;
            _context.SaveChanges();

            var cartCount = _context.CartItems
                .Where(x => x.CartId == cart.Id)
                .Sum(x => x.Quantity);
            Console.WriteLine(cartCount);
            return Json(new
            {
                success = true,
                message = "Cập nhật thành công",
                newQuantity = item.Quantity,
                cartCount = cartCount
            });
        }

        [HttpGet]
        public IActionResult GetCartBadge()
        {
            return ViewComponent("Cart");
        }
        [Authorize]
        public IActionResult CheckOut()
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            var cart = _context.Carts
                .Include(x => x.CartItems)
                    .ThenInclude(x => x.ProductVariant)
                        .ThenInclude(x => x.Product)
                .Include(x => x.CartItems)
                    .ThenInclude(x => x.ProductVariant)
                        .ThenInclude(x => x.ProductVariantOptionValues)
                            .ThenInclude(x => x.ProductOptionValue)
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null || !cart.CartItems.Any())
            {
                TempData["Error"] = "Giỏ hàng trống";
                return RedirectToAction("Index");
            }

            return View(cart);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public IActionResult PlaceOrder(
     string firstName,
     string lastName,
     string email,
     string phone,
     string address,
     string country,
     string city,
     string province,
     string paymentMethod)
        {
            Console.WriteLine("==== PLACE ORDER START ====");

            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (!Guid.TryParse(userIdStr, out var userId))
                return RedirectToAction("Login", "Account");

            // ================= CART =================
            var cart = _context.Carts
                .Include(x => x.CartItems)
                    .ThenInclude(x => x.ProductVariant)
                        .ThenInclude(x => x.Product)
                .Include(x => x.CartItems)
                    .ThenInclude(x => x.ProductVariant)
                        .ThenInclude(x => x.ProductVariantOptionValues)
                            .ThenInclude(x => x.ProductOptionValue)
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null || !cart.CartItems.Any())
                return Content("Cart empty");

            // ================= AUTO CUSTOMER (FIX LỖI CHÍNH) =================
            var customer = _context.Customers
                .FirstOrDefault(x => x.UserId == userId);

            if (customer == null)
            {
                customer = new Customer
                {
                    Uid = Guid.NewGuid(),
                    UserId = userId,
                    ContactName = firstName + " " + lastName,
                    Email = email,
                    Phone = phone,
                    CreatedAt = DateTime.Now,
                    Status = 1
                };

                _context.Customers.Add(customer);
                _context.SaveChanges();
            }

            using var transaction = _context.Database.BeginTransaction();

            try
            {
                // ================= ORDER =================
                var order = new Order
                {
                    Uid = Guid.NewGuid(),
                    CustomerId = customer.Id,
                    OrderDate = DateTime.Now,
                    CreatedAt = DateTime.Now,

                    Receive = $"{firstName} {lastName} - {phone} - {address}, {city}, {province}, {country}",

                    Freight = 10000,
                    Notes = paymentMethod,
                    Status = 1
                };

                _context.Orders.Add(order);
                _context.SaveChanges();

                // ================= ORDER DETAILS =================
                foreach (var item in cart.CartItems)
                {
                    var productId = item.ProductVariant.ProductId;

                    if (!productId.HasValue)
                        throw new Exception("ProductId NULL in ProductVariant");

                    var variantInfo = string.Join(" / ",
                        item.ProductVariant.ProductVariantOptionValues
                            .Select(x => x.ProductOptionValue.Name));

                    _ = _context.OrderDetails.Add(new OrderDetail
                    {
                        Uid = Guid.NewGuid(),
                        OrderId = order.Id,

                        ProductId = productId.Value,
                        ProductVariantId = item.ProductVariant.Id,

                        UnitPrice = item.Price,
                        Quantity = (short)item.Quantity,

                        ProductName = item.ProductVariant.Product.ProductName,
                        Sku = item.ProductVariant.Sku,
                        VariantInfo = variantInfo,

                        LineTotal = item.Price * item.Quantity,
                        CreatedAt = DateTime.Now,
                        Status = 1
                    });

                    // giảm stock
                    item.ProductVariant.StockQuantity =
                        (item.ProductVariant.StockQuantity ?? 0) - item.Quantity;
                }

                // ================= CLEAR CART =================
                _context.CartItems.RemoveRange(cart.CartItems);

                _context.SaveChanges();
                transaction.Commit();

                Console.WriteLine("ORDER SUCCESS");

                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                var error = ex.InnerException?.Message ?? ex.Message;

                Console.WriteLine("ERROR: " + error);

                return Content("ERROR: " + error);
            }
        }
    }
    }