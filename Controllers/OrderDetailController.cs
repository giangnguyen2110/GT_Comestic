using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;

namespace NhomGT_ComesticShop.Controllers
{
    
    public class OrderDetailController : Controller
    {
        
       
            private readonly GtEcommerceContext _context;

            public OrderDetailController(GtEcommerceContext context)
            {
                _context = context;
            }

        [Authorize]
        public IActionResult Detail(int id)
        {
            var order = _context.Orders
                .Include(x => x.Employee)
                .Include(x => x.OrderDetails)
                    .ThenInclude(x => x.Product)
                .Include(x => x.OrderDetails)
                    .ThenInclude(x => x.ProductVariant)
                .FirstOrDefault(x => x.Id == id);

            if (order == null)
                return NotFound();

            return View(order);
        }
    }
}
