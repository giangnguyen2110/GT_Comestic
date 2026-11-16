using System.Net.Mail;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using NhomGT_ComesticShop.DTOs;

namespace NhomGT_ComesticShop.Services
{
    public class MailService
    {
        private readonly IOptions<MailSettings> _configuration;

        public MailService(IOptions<MailSettings> configuration)
        {
            _configuration = configuration;
        }

        public async Task<int> SendMail(string toMail, string subject, string message)
        {
            try
            {
                SmtpClient smtpClient = new SmtpClient(_configuration.Value.Host);
                smtpClient.EnableSsl = true;
                smtpClient.UseDefaultCredentials = false;
                // app password đã đăng ký
                string password = "ianiwchyxkrvklto";
                // email đã đăng ký
                smtpClient.Credentials = new System.Net.NetworkCredential("tranbaotram.a@gmail.com", password);
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtpClient.Port = 587;
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("tranbaotram.a@gmail.com", "Bao Tram");
                mail.To.Add(new MailAddress(toMail)); // email muốn gửi đi
                mail.IsBodyHtml = true;
                mail.Subject = subject;
                mail.Body = message;
                await smtpClient.SendMailAsync(mail);
            }
            catch (Exception) { return 0; }
            return 1;
        }
    }
}
