namespace NhomGT_ComesticShop.DTOs
{
    public class Cart
    {
        public Guid Id { get; set; }
        public string UserId { get; set; }  // hoặc CustomerId
        public DateTime CreatedDate { get; set; }
        public ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();
    }
}
