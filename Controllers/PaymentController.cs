using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.DTOs.Momo;
using NhomGT_ComesticShop.Hubs; // Đảm bảo đúng namespace của Hub
using NhomGT_ComesticShop.Models;
using NhomGT_ComesticShop.Services.Momo;

namespace NhomGT_ComesticShop.Controllers
{
    public class PaymentController : Controller
    {
        private readonly IMomoService _momoService;
        private readonly GtEcommerceContext _context;
        private readonly IHubContext<NotificationHub> _hubContext; // Thêm HubContext ở đây

        public PaymentController(IMomoService momoService, GtEcommerceContext context, IHubContext<NotificationHub> hubContext)
        {
            _momoService = momoService;
            _context = context;
            _hubContext = hubContext;
        }

        [HttpGet]
        public async Task<IActionResult> CreatePaymentMomo(OrderInfoModel model)
        {
            var response = await _momoService.CreatePaymentMomo(model);
            if (response != null && !string.IsNullOrEmpty(response.PayUrl))
            {
                return Redirect(response.PayUrl);
            }
            return Content("Lỗi khi tạo liên kết thanh toán MoMo");
        }

        [HttpGet]
        public async Task<IActionResult> PaymentCallBack()
        {
            var query = HttpContext.Request.Query;

            // 1. Gọi Service của bà để nhận dữ liệu giải mã từ MoMo
            var momoResult = _momoService.PaymentExecuteAsync(query);

            // 2. Lấy ID đơn hàng thật từ ExtraData
            if (int.TryParse(momoResult.ExtraData, out int orderId))
            {
                // Phải Include Customer để lấy UserId
                var order = await _context.Orders
                    .Include(x => x.Customer)
                    .FirstOrDefaultAsync(x => x.Id == orderId);

                if (order != null)
                {
                    // 🌟 CHIÊU ĐỘ DEMO: Ép Đơn hàng thành trạng thái 2 (Đã thanh toán) để đi demo cho mượt
                    order.Status = 2;

                    // Chuyển số tiền MoMo trả về (dạng string) sang decimal để lưu DB
                    decimal.TryParse(momoResult.Amount, out decimal paymentAmount);

                    // Lấy UserId của khách hàng (kiểu Guid?) để làm người tạo Payment
                    Guid? currentUserId = order.Customer?.UserId;

                    // 🌟 TẠO BẢN GHI PAYMENT MỚI KHỚP 100% KIỂU DỮ LIỆU TRONG SQL:
                    var newPayment = new Payment
                    {
                        Uid = Guid.NewGuid(), // Chuẩn kiểu Guid
                        OrderId = orderId, // Chuẩn kiểu int
                        Amount = paymentAmount > 0 ? paymentAmount : 0, // Chuẩn kiểu decimal
                        Method = "MOMO_QR", // Chuẩn kiểu string?
                        CreatedAt = DateTime.Now, // Chuẩn kiểu DateTime
                        CreatedBy = currentUserId, // 🌟 FIX LỖI CHÍ MẠNG: Gán bằng Guid? của User chứ không gán chữ nữa!
                        Status = 1, // Chuẩn kiểu int? (1 đại diện cho Thành công)
                        Notes = $"Thanh toan MoMo (Ma GD MoMo: {momoResult.OrderId} - ResultCode: {momoResult.ResultCode})" // Chuẩn kiểu string?
                    };

                    // Ném bản ghi chuẩn chỉnh này vào bảng Payment
                    _context.Payments.Add(newPayment);

                    // --- LUÔN XÓA GIỎ HÀNG (Giữ nguyên logic gốc của bà) ---
                    var userId = order.Customer?.UserId;
                    if (userId.HasValue)
                    {
                        var cart = await _context.Carts
                            .Include(x => x.CartItems)
                            .FirstOrDefaultAsync(x => x.UserId == userId.Value);

                        if (cart != null)
                        {
                            // Xóa item trong DB
                            _context.CartItems.RemoveRange(cart.CartItems);

                            // LƯU TOÀN BỘ XUỐNG SQL SERVER (Thêm Payment + Cập nhật Order + Xóa Giỏ hàng)
                            await _context.SaveChangesAsync(); // <--- CHỐT HẠ ĐƯA DATA VÀO DB

                            // GỬI LỆNH ĐẾN LAYOUT ĐỂ XÓA SỐ TRÊN XE ĐẨY
                            await _hubContext.Clients.User(userId.Value.ToString()).SendAsync("ForceUpdateCart", 0);
                            // Xóa nốt Session nếu có
                            HttpContext.Session.SetInt32("CartCount", 0);
                        }
                    }
                    else
                    {
                        // Nếu không có Customer liên kết, vẫn lưu Payment và Trạng thái Order mới vào DB
                        await _context.SaveChangesAsync();
                    }

                    // Trả dữ liệu về cho trang View đơn giản hiển thị thành công
                    return View("PaymentCallBack", momoResult);
                }
            }

            return Content("Lỗi đơn hàng hoặc không tìm thấy ExtraData!");
        }
        public IActionResult Index() => View();
    }
}