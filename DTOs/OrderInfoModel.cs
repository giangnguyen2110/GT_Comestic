namespace NhomGT_ComesticShop.DTOs
{
    public class OrderInfoModel
    {
        public int OrderId { get; set; }
        public decimal Amount { get; set; }
        public string FullName { get; set; }
        public string OrderInfo { get; set; }
        public DateTime DatePaid { get; set; }
    }
}
