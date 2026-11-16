using AutoMapper;
using NhomGT_ComesticShop.DTOs;
using NhomGT_ComesticShop.Models;

namespace NhomGT_ComesticShop.Helpers
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile() 
        {
            CreateMap<RegisterVM, User>()
     .ForMember(u => u.PasswordHash, opt => opt.Ignore())
     .ForMember(u => u.UserName, opt => opt.MapFrom(x => x.Email))
     .ForMember(u => u.Email, opt => opt.MapFrom(x => x.Email))
     .ForMember(u => u.PhoneNumber, opt => opt.MapFrom(x => x.PhoneNumber))
     .ForMember(u => u.FullName, opt => opt.MapFrom(x => x.FullName));
        }
    }
}
