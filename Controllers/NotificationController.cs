using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;

namespace NhomGT_ComesticShop.Controllers
{
    public class NotificationController : Controller
    {
        private readonly GtEcommerceContext _context;

        public NotificationController(GtEcommerceContext context)
        {
            _context = context;
        }
        [Authorize(Roles = "Customer")]
        public IActionResult Index()
        {
            var userId = Guid.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier).Value
            );

            var list = _context.Notifications
                .Where(x => x.UserId == userId)
                .OrderByDescending(x => x.CreatedAt)
                .ToList();
            // mark all as read
            foreach (var item in list)
            {
                item.IsRead = true;
            }


            return View(list);
        }
    }
}
