namespace NhomGT_ComesticShop.Models
{
    public class HomeViewModels
    {
        // Danh sách các danh mục
        public IEnumerable<Category> Categories { get; set; } = Enumerable.Empty<Category>();

        // Danh sách sản phẩm nổi bật
        public IEnumerable<Product> Products { get; set; } = Enumerable.Empty<Product>();
        public virtual ICollection<ProductVariant> Variants { get; set; } = new List<ProductVariant>();

        // Có thể thêm Banner, Tin tức... nếu cần
    }
}
