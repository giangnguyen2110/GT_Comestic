using System.ComponentModel.DataAnnotations.Schema;

namespace NhomGT_ComesticShop.Models
{
    [Table("wishlist")]
    public class Wishlist
    {
        public int Id { get; set; }

        public Guid UserId { get; set; } 

        public int ProductId { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // navigation
        public Product Product { get; set; }
    }
}
