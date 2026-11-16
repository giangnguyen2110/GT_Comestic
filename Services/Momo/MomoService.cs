using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.DTOs.Momo;
using RestSharp;

namespace NhomGT_ComesticShop.Services.Momo
{
    public class MomoService : IMomoService
    {
        private readonly IOptions<MomoOptionModel> _options;

        public MomoService(IOptions<MomoOptionModel> options)
        {
            _options = options;
        }

        public async Task<MomoCreatePaymentResponseModel> CreatePaymentMomo(OrderInfoModel model)
        {
            string partnerCode = _options.Value.PartnerCode;
            string accessKey = _options.Value.AccessKey;
            string secretKey = _options.Value.SecretKey;

            // 🔥 QUAN TRỌNG: unique cho mỗi lần thanh toán
            string momoOrderId = Guid.NewGuid().ToString("N");

            string requestId = Guid.NewGuid().ToString();
            long amount = (long)model.Amount;

            string orderInfo = "Thanh toan don hang " + model.OrderId;

            string redirectUrl = _options.Value.ReturnUrl;
            string ipnUrl = _options.Value.NotifyUrl;
            string requestType = _options.Value.RequestType;
            string extraData = model.OrderId.ToString(); // 👈 lưu order thật ở đây

            var rawData =
                $"accessKey={accessKey}" +
                $"&amount={amount}" +
                $"&extraData={extraData}" +
                $"&ipnUrl={ipnUrl}" +
                $"&orderId={momoOrderId}" +   // 🔥 dùng GUID
                $"&orderInfo={orderInfo}" +
                $"&partnerCode={partnerCode}" +
                $"&redirectUrl={redirectUrl}" +
                $"&requestId={requestId}" +
                $"&requestType={requestType}";

            var signature = ComputeHmacSha256(rawData, secretKey);

            var client = new RestClient(_options.Value.MomoApiUrl);
            var request = new RestRequest() { Method = Method.Post };

            var requestData = new
            {
                partnerCode,
                partnerName = "Test",
                storeId = "MomoTestStore",
                requestId,
                amount = amount.ToString(),
                orderId = momoOrderId, // 🔥 unique
                orderInfo,
                redirectUrl,
                ipnUrl,
                lang = "vi",
                extraData,
                requestType,
                signature
            };

            request.AddJsonBody(requestData);

            var response = await client.ExecuteAsync(request);

            return JsonConvert.DeserializeObject<MomoCreatePaymentResponseModel>(response.Content);
        }

        public MomoExecuteResponseModel PaymentExecuteAsync(IQueryCollection collection)
        {
            return new MomoExecuteResponseModel()
            {
                Amount = collection["amount"],
                OrderId = collection["orderId"], // Đây là cái GUID của MoMo
                OrderInfo = System.Net.WebUtility.UrlDecode(collection["orderInfo"]),
                ResultCode = collection["resultCode"],
                Message = collection["message"],
                ExtraData = collection["extraData"] // 👈 Thêm dòng này (nhớ thêm thuộc tính vào Model)
            };
        }

        private string ComputeHmacSha256(string message, string secretKey)
        {
            var keyBytes = Encoding.UTF8.GetBytes(secretKey);
            var messageBytes = Encoding.UTF8.GetBytes(message);

            using (var hmac = new HMACSHA256(keyBytes))
            {
                var hashBytes = hmac.ComputeHash(messageBytes);
                return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
            }
        }
    }
}