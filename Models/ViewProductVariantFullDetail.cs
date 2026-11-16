using System.ComponentModel.DataAnnotations.Schema;

namespace NhomGT_ComesticShop.Models
{
    public class ViewProductVariantFullDetail
    {
        public Guid ProductVariantUid { get; set; }
        public int ProductVariantId { get; set; }
        public int ProductId { get; set; }
        public string SKU { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; } = string.Empty;
        public int OptionValueId { get; set; }
        public string OptionValueName { get; set; } = string.Empty;
        public string OptionGroupName { get; set; } = string.Empty;
        public int SortOrder { get; set; }
    }
}

