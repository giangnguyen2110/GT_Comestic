using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Models;
using System.Security.Claims;

public class WishlistController : Controller
{
    private readonly GtEcommerceContext _context;

    public WishlistController(GtEcommerceContext context)
    {
        _context = context;
    }
    [HttpPost]
    public IActionResult Toggle(int productId)
    {
        if (!User.Identity.IsAuthenticated)
        {
            return Unauthorized();
        }

        try
        {
            var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            // Nhớ dùng đúng tên navigation property là x.Product (số ít) nhé
            var item = _context.Wishlists
                .FirstOrDefault(x => x.UserId == userId && x.ProductId == productId);

            // Tính tổng số lượng để trả về cho icon Header nhảy số luôn
            if (item == null)
            {
                _context.Wishlists.Add(new Wishlist
                {
                    UserId = userId,
                    ProductId = productId
                });

                _context.SaveChanges();
                var totalCountAdd = _context.Wishlists.Count(x => x.UserId == userId);
                return Json(new { success = true, liked = true, totalCount = totalCountAdd });
            }

            _context.Wishlists.Remove(item);
            _context.SaveChanges();

            var totalCountRemove = _context.Wishlists.Count(x => x.UserId == userId);
            return Json(new { success = true, liked = false, totalCount = totalCountRemove });
        }
        catch (Exception ex)
        {
            return Json(new { success = false, error = ex.Message });
        }
    }
    [Authorize]
    public IActionResult Index()
    {
        var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(userIdString, out Guid userId))
        {
            return RedirectToAction("Login", "Account");
        }

        var data = _context.Wishlists
            .Include(x => x.Product)
            .Where(x => x.UserId == userId)
            .ToList();

        return View(data);
    }
}
