using Microsoft.AspNetCore.Mvc;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Models;
using System.Security.Claims;


namespace NhomGT_ComesticShop.Components
{
    public class WishlistCountViewComponent : ViewComponent
    {
        private readonly GtEcommerceContext _context;

        public WishlistCountViewComponent(GtEcommerceContext context)
        {
            _context = context;
        }

        public IViewComponentResult Invoke()
        {
            // Lấy đối tượng User từ HttpContext
            var user = ViewContext.HttpContext.User;

            // Kiểm tra đăng nhập
            if (user == null || !user.Identity.IsAuthenticated)
            {
                return View(0);
            }

            // Sử dụng user (đã là ClaimsPrincipal) để gọi FindFirstValue
            var userIdString = user.FindFirstValue(ClaimTypes.NameIdentifier);

            if (Guid.TryParse(userIdString, out Guid userId))
            {
                var count = _context.Wishlists.Count(x => x.UserId == userId);
                return View(count);
            }

            return View(0);
        }
    }
}