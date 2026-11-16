using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.DTOs.Momo;

namespace NhomGT_ComesticShop.Services.Momo
{
    public interface IMomoService
    {
        Task<MomoCreatePaymentResponseModel> CreatePaymentMomo(OrderInfoModel model);
        MomoExecuteResponseModel PaymentExecuteAsync(IQueryCollection collection);
    }
}
