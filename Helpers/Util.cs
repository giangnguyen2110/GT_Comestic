using Microsoft.AspNetCore.Identity;
using NhomGT_ComesticShop.Models;

namespace NhomGT_ComesticShop.Helpers
{
    public class Util
    {
        private static readonly PasswordHasher<User> _hasher = new PasswordHasher<User>();

        public static string HashPassword(User user, string password)
        {
            return _hasher.HashPassword(user, password);
        }

        public static bool VerifyPassword(User user, string hashedPassword, string password)
        {
            var result = _hasher.VerifyHashedPassword(user, hashedPassword, password);
            return result == PasswordVerificationResult.Success;
        }
    }
}
