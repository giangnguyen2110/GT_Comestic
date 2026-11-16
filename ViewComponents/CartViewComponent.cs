using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;
using System.Security.Claims;

namespace NhomGT_ComesticShop.ViewComponents
{
    public class CartViewComponent : ViewComponent
    {
        private readonly GtEcommerceContext _context;

        public CartViewComponent(GtEcommerceContext context)
        {
            _context = context;
        }

        public IViewComponentResult Invoke()
        {
            if(!HttpContext.User.Identity.IsAuthenticated)
            {
                return View("CartPanel", new CartModel { quantity = 0, total = 0 });
            }
            var userIdClaim = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if(!Guid.TryParse(userIdClaim, out var userId))
            {
                return View("CartPanel", new CartModel
                {
                    quantity = 0,
                    total = 0
                });
            }

            var cart = _context.Carts
                .Include(x => x.CartItems)
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
            {
                return View("CartPanel", new CartModel
                {
                    quantity = 0,
                    total = 0
                });
            }

            var quantity = cart.CartItems.Sum(x => x.Quantity);
            var total = cart.CartItems.Sum(x => x.Quantity * x.Price);

            return View("CartPanel", new CartModel
            {
                quantity = quantity,
                total = total
            });
        }
    }
}