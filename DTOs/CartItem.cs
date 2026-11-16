namespace NhomGT_ComesticShop.DTOs
{
    //public class CartItem
    //{
    //    public int productId {  get; set; }
    //    public string image {  get; set; }
    //    public string productName {  get; set; }
    //    public decimal price { get; set; } 
    //    public int soLuong {  get; set; }
    //    public decimal thanhTien => soLuong * price;
    //}
    public class CartItem
    {
        public Guid Id { get; set; }

        public Guid CartId { get; set; }

        public Guid ProductVariantUid { get; set; }

        public string ImageUrl { get; set; } = string.Empty;

        public string productName { get; set; } = string.Empty;

        public string variantText { get; set; } = string.Empty;

        public decimal price { get; set; }

        public int soLuong { get; set; }

        public decimal thanhTien => soLuong * price;
    }
}
