using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.Models;

namespace NhomGT_ComesticShop.Controllers
{
    public class EmployeeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        
            private readonly GtEcommerceContext _context;

            public EmployeeController(GtEcommerceContext context)
            {
                _context = context;
            }

            [Authorize(Roles = "Employee, Admin")]
            public IActionResult Orders()
            {
            var orders = _context.Orders
                        .Include(x => x.Customer)
                        .Include(x => x.Employee)
                            .ThenInclude(e => e.User)
                        .Include(x => x.OrderDetails)
                        .OrderByDescending(x => x.CreatedAt)
                        .ToList();

            return View(orders);
            }

        [Authorize(Roles = "Employee, Admin")]
        //public IActionResult ApproveOrder(int id)
        //{
        //    var order = _context.Orders
        //        .Include(x => x.Customer)
        //        .FirstOrDefault(x => x.Id == id);

        //    if (order == null)
        //        return NotFound();

        //    var userIdStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

        //    if (!Guid.TryParse(userIdStr, out var userId))
        //        return RedirectToAction("Login", "Account");

        //    var employee = _context.Employees
        //        .FirstOrDefault(x => x.UserId == userId);

        //    if (employee == null)
        //        return Content("Không tìm thấy employee");

        //    order.Status = 2;
        //    order.EmployeeId = employee.Id;

        //    var employeeName = $"{employee.FirstName} {employee.LastName}";

        //    _context.Notifications.Add(new Notification
        //    {
        //        UserId = order.Customer.UserId.Value,
        //        OrderId = order.Id,
        //        Message = $"Đơn hàng #{order.Id} đã được {employeeName} xác nhận",
        //        IsRead = false,
        //        CreatedAt = DateTime.Now
        //    });

        //    _context.SaveChanges();

        //    return RedirectToAction("Orders");
        //}
        public IActionResult ApproveOrder(int id)
        {
            var order = _context.Orders
                .Include(x => x.Customer)
                .FirstOrDefault(x => x.Id == id);

            if (order == null)
                return NotFound();

            var userIdStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            // Nếu không lấy được userId thì bắt đăng nhập
            if (string.IsNullOrEmpty(userIdStr))
                return RedirectToAction("Login", "Account");

            int? employeeId = null;
            string employeeName = "Admin";

            // --- LOGIC MỚI: KIỂM TRA QUYỀN ---
            if (User.IsInRole("Admin"))
            {
                // Admin: Dùng luôn, không bắt buộc có trong bảng Employees
                employeeName = "Quản trị viên";
            }
            else
            {
                // Nhân viên: Bắt buộc phải có trong bảng Employees
                Guid.TryParse(userIdStr, out var userId);
                var employee = _context.Employees.FirstOrDefault(x => x.UserId == userId);

                if (employee == null)
                {
                    TempData["Error"] = "Tài khoản của bạn chưa được liên kết với hồ sơ nhân viên!";
                    return RedirectToAction("Orders");
                }

                employeeId = employee.Id;
                employeeName = $"{employee.FirstName} {employee.LastName}";
            }
            // ---------------------------------

            order.Status = 2;
            order.EmployeeId = employeeId; // Nếu là Admin thì EmployeeId sẽ là null (hoặc bạn có thể để 0)

            _context.Notifications.Add(new Notification
            {
                UserId = order.Customer.UserId.Value,
                OrderId = order.Id,
                Message = $"Đơn hàng #{order.Id} đã được {employeeName} xác nhận",
                IsRead = false,
                CreatedAt = DateTime.Now
            });

            _context.SaveChanges();

            return RedirectToAction("Orders");
        }
    }
    
}
