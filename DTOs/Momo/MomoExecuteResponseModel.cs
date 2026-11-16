namespace NhomGT_ComesticShop.DTOs.Momo
{
    public class MomoExecuteResponseModel
    {
        public string OrderId { get; set; }
        public string Amount { get; set; }
        public string FullName { get; set; }
        public string OrderInfo { get; set; }
        public string ResultCode { get; set; } // 0 là thành công
        public string Message { get; set; }
        public string ExtraData { get; set; }
    }
}
