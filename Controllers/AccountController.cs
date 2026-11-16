using System.Linq.Expressions;
using System.Security.Claims;
using System.Text.RegularExpressions;
using AutoMapper;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using NhomGT_ComesticShop.Data;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.Helpers;
using NhomGT_ComesticShop.Models;
using NhomGT_ComesticShop.Services;

namespace NhomGT_ComesticShop.Controllers
{
    public class AccountController : Controller
    {
        //private readonly GtEcommerceContext _context;
        private readonly GtEcommerceContext _context;
        private readonly IMapper _mapper;
        private readonly MailService _mailService;

        public AccountController(
         GtEcommerceContext context,
         IMapper mapper,
         MailService mailService)
        {
            _context = context;
            _mapper = mapper;
            _mailService = mailService;
        }
        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }
        [HttpPost]
        public IActionResult Register(RegisterVM model)
        {
            var sessionOtp = HttpContext.Session.GetString("OTP");
            var inputOtp = Request.Form["Otp"];

            if (sessionOtp == null || sessionOtp != inputOtp)
            {
                ModelState.AddModelError("", "OTP không đúng");
                return View(model);
            }

            if (ModelState.IsValid)
            {
                var user = _mapper.Map<User>(model);

                user.Id = Guid.NewGuid();
                user.CreatedAt = DateTime.Now;
                user.UserName = model.Email;
                user.PasswordHash = Util.HashPassword(user, model.Password);
                user.IsActive = true;

                _context.Users.Add(user);
                _context.SaveChanges();

                return RedirectToAction("Login");
            }

            return View(model);
        }
        [HttpPost]
        public IActionResult SendOtp(string email)
        {
            if (string.IsNullOrEmpty(email))
                return Json(new { success = false, message = "Email không hợp lệ" });

            // chỉ gmail
            if (!Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@gmail\.com$"))
            {
                return Json(new
                {
                    success = false,
                    message = "Chỉ hỗ trợ email @gmail.com"
                });
            }

            // check trùng DB
            var exists = _context.Users.Any(x => x.Email == email);

            if (exists)
            {
                return Json(new
                {
                    success = false,
                    message = "Email đã được sử dụng"
                });
            }

            var otp = new Random().Next(100000, 999999).ToString();

            HttpContext.Session.SetString("OTP", otp);
            HttpContext.Session.SetString("OTP_EMAIL", email);

            _mailService.SendMail(email, "OTP đăng ký", $"Mã OTP: {otp}");

            return Json(new
            {
                success = true,
                message = "Đã gửi OTP đến Gmail"
            });
        }

        [HttpGet]
        public IActionResult VerifyOtp()
        {
            return View();
        }

        [HttpPost]
        public IActionResult VerifyOtp(VerifyOtpVM model)
        {
            var otp = HttpContext.Session.GetString("RegisterOtp");

            if (otp != model.Otp)
            {
                ModelState.AddModelError("", "OTP không đúng");
                return View(model);
            }

            var pendingUserJson =
                HttpContext.Session.GetString("PendingUser");

            var pendingUser =
                System.Text.Json.JsonSerializer
                .Deserialize<RegisterVM>(pendingUserJson);

            var user = _mapper.Map<User>(pendingUser);

            user.Id = Guid.NewGuid();
            user.CreatedAt = DateTime.Now;
            user.IsActive = true;
            user.UserName = pendingUser.Email;
            user.PasswordHash =
                Util.HashPassword(user, pendingUser.Password);

            _context.Users.Add(user);
            _context.SaveChanges();

            HttpContext.Session.Remove("RegisterOtp");
            HttpContext.Session.Remove("PendingUser");

            return RedirectToAction("Login");
        }

        [HttpGet]
        public IActionResult Login(string? ReturnUrl)
        {
            ViewBag.ReturnUrl = ReturnUrl;
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginVM model, string? ReturnUrl)
        {
            ViewBag.ReturnUrl = ReturnUrl;
            if (ModelState.IsValid)
            {
                var user = _context.Users.FirstOrDefault(kh =>
                kh.UserName == model.UserName);
                if (user == null)
                {
                    ModelState.AddModelError("", "Sai tài khoản hoặc mật khẩu");
                }
                else
                {
                    if (!user.IsActive)
                    {
                        ModelState.AddModelError("", "Tài khoản đã bị khóa");
                    }
                    else
                    {
                        if (!Util.VerifyPassword(user, user.PasswordHash, model.Password))
                        {
                            ModelState.AddModelError("", "Sai tài khoản hoặc mật khẩu");
                        }
                        //else

                        //{
                        //    var role = _context.Users
                        //                         .Where(u => u.Id == user.Id)
                        //                         .SelectMany(u => u.Roles)
                        //                         .Select(r => r.Name)
                        //                         .FirstOrDefault();
                        //    var claims = new List<Claim>
                        //    {
                        //        new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                        //        new Claim(ClaimTypes.Email, user.Email ?? ""),
                        //        new Claim(ClaimTypes.Name, user.FullName),
                        //        new Claim("UsernameId", user.UserName ?? ""),

                        //        new Claim(ClaimTypes.Role, role ?? "Customer")
                        //    };
                        //    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                        //    var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);
                        //    await HttpContext.SignInAsync(claimsPrincipal);
                        //    await _mailService.SendMail(
                        //                                user.Email,
                        //                                "Đăng nhập thành công",
                        //                                $"<h2>Xin chào {user.FullName}</h2><p>Bạn vừa đăng nhập lúc {DateTime.Now}</p>"
                        //                            );
                        //    if (Url.IsLocalUrl(ReturnUrl))
                        //    {
                        //        return Redirect(ReturnUrl);
                        //    }
                        //    else
                        //    {
                        //        return RedirectToAction("Index", "Product");
                        //    }
                        //}
                        else
                        {
                            // 1. Lấy danh sách tất cả các Role của user
                            var roleNames = _context.Users
                                                    .Where(u => u.Id == user.Id)
                                                    .SelectMany(u => u.Roles)
                                                    .Select(r => r.Name)
                                                    .ToList();

                            // 2. Tạo danh sách claims cơ bản
                            var claims = new List<Claim>
                            {
                                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                                new Claim(ClaimTypes.Email, user.Email ?? ""),
                                new Claim(ClaimTypes.Name, user.FullName),
                                new Claim("UsernameId", user.UserName ?? "")
                            };

                            // 3. Thêm TẤT CẢ các Role tìm được vào Claims
                            if (roleNames.Any())
                            {
                                foreach (var roleName in roleNames)
                                {
                                    claims.Add(new Claim(ClaimTypes.Role, roleName));
                                }
                            }
                            else
                            {
                                // Nếu không có role nào, mặc định là Customer
                                claims.Add(new Claim(ClaimTypes.Role, "Customer"));
                            }

                            // 4. Tiếp tục các bước đăng nhập bình thường
                            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

                            await HttpContext.SignInAsync(claimsPrincipal);

                            await _mailService.SendMail(
                                user.Email,
                                "Đăng nhập thành công",
                                $"<h2>Xin chào {user.FullName}</h2><p>Bạn vừa đăng nhập lúc {DateTime.Now}</p>"
                            );

                            if (Url.IsLocalUrl(ReturnUrl))
                            {
                                return Redirect(ReturnUrl);
                            }
                            else
                            {
                                return RedirectToAction("Index", "Product");
                            }
                        }
                    }
                }
            }
            return View();

        }
        [Authorize]
        public IActionResult Profile()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LogOut()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Index", "Product");
        }
    }
}

