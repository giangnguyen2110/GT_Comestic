CREATE DATABASE GT_Ecommerce
GO
USE GT_Ecommerce
GO
--câu lệnh thêm employee
INSERT INTO Employee
(
    Uid,
    UserId,
    FirstName,
    LastName,
    Phone,
    Email,
    HireDate,
    CreatedAt,
    Status
)
VALUES
(
    NEWID(),
    '631C245F-7E6B-4200-A74C-4CD2C6A45E4C',
    'Hương',
    'Giang',
    '0909999999',
    'giang@gmail.com',
    GETDATE(),
    GETDATE(),
    1
)
--Câu lệnh xem role của user
SELECT 
    u.Id,
    u.FullName,
    u.UserName,
    u.Email,
    r.Name AS RoleName
FROM Users u
INNER JOIN AspNetUserRoles ur
    ON u.Id = ur.UserId
INNER JOIN Roles r
    ON ur.RoleId = r.Id
ORDER BY u.FullName;
--đổi quyền admin thành employee 
SELECT Id, Name
FROM Roles;


SELECT Id, UserName, Email
FROM Users



UPDATE AspNetUserRoles
SET RoleId = 'BAA35CA7-56EF-4AFD-9EE7-C50EFA01DA56'
WHERE UserId = '631C245F-7E6B-4200-A74C-4CD2C6A45E4C'
AND RoleId = '0F81572C-86B1-43AA-A6B9-7C7AE613F182';

--Thêm table Notifications(17/05)
CREATE TABLE Notifications
(
    Id INT PRIMARY KEY IDENTITY(1,1),

    UserId UNIQUEIDENTIFIER NOT NULL,

    Message NVARCHAR(500) NOT NULL,

    IsRead BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Notifications_Users
        FOREIGN KEY (UserId)
        REFERENCES Users(Id)
);
ALTER TABLE Notifications
ADD OrderId INT NULL
SELECT TOP 20 *
FROM Notifications
ORDER BY CreatedAt DESC
--Thay đổi cột status
--ALTER TABLE Product
--ADD CONSTRAINT DF_Product_Status DEFAULT 1 FOR Status

--Thêm cột picture vào product
--ALTER TABLE Product
--ADD Picture NVARCHAR(255) NULL
-- Xóa cột cũ ở bảng Category
ALTER TABLE [dbo].[Category] DROP COLUMN [CreatedBy], [UpdatedBy];

-- Xóa cột cũ ở bảng Supplier
ALTER TABLE [dbo].[Supplier] DROP COLUMN [CreatedBy], [UpdatedBy];

-- Xóa cột cũ ở bảng Product
ALTER TABLE [dbo].[Product] DROP COLUMN [CreatedBy], [UpdatedBy];

-- Thêm lại cho Category
ALTER TABLE [dbo].[Category] 
ADD [CreatedBy] uniqueidentifier NULL, 
    [UpdatedBy] uniqueidentifier NULL;

-- Thêm lại cho Supplier
ALTER TABLE [dbo].[Supplier] 
ADD [CreatedBy] uniqueidentifier NULL, 
    [UpdatedBy] uniqueidentifier NULL;

-- Thêm lại cho Product
ALTER TABLE [dbo].[Product] 
ADD [CreatedBy] uniqueidentifier NULL, 
    [UpdatedBy] uniqueidentifier NULL;


/****** Object:  Table [dbo].[Category]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[CategoryName] [nvarchar](150) NOT NULL,
	[Description] NVARCHAR(MAX) NULL,
	[Picture] [varbinary](max) NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] DEFAULT 1 NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[UserId] [int] NULL,
	[CompanyName] [nvarchar](100) NOT NULL,
	[ContactName] [nvarchar](100) NULL,
	[ContactTitle] [nvarchar](100) NULL,
	[Phone] [varchar](30) NULL,
	[Email] [varchar](100) NULL,
	[HomePage] [nvarchar](250) NULL,
	[AddressId] [int] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] DEFAULT 1 NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[ProductName] [nvarchar](150) NOT NULL,
	[Brand] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[CategoryId] [int] NULL,
	[SupplierId] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [int] NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] DEFAULT 1 NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],

CONSTRAINT FK_Product_Category 
        FOREIGN KEY (CategoryId) REFERENCES Category(Id),

    CONSTRAINT FK_Product_Supplier 
        FOREIGN KEY (SupplierId) REFERENCES Supplier(Id)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[Description] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[FullName] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
-- Khóa ngoại bảng Category
ALTER TABLE [dbo].[Category] ADD CONSTRAINT FK_Category_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES [dbo].[Users](Id);
ALTER TABLE [dbo].[Category] ADD CONSTRAINT FK_Category_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES [dbo].[Users](Id);

-- Khóa ngoại bảng Supplier
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT FK_Supplier_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES [dbo].[Users](Id);
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT FK_Supplier_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES [dbo].[Users](Id);

-- Khóa ngoại bảng Product
ALTER TABLE [dbo].[Product] ADD CONSTRAINT FK_Product_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES [dbo].[Users](Id);
ALTER TABLE [dbo].[Product] ADD CONSTRAINT FK_Product_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES [dbo].[Users](Id);
GO

/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	CONSTRAINT [FK_AspNetUserRoles_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_AspNetUserRoles_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Address]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[AddressNo] [nvarchar](150) NULL,
	[CountryId] [int] NULL,
	[ProvinceId] [int] NULL,
	[WardId] [int] NULL,
	[TownId] [int] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](255) NULL,
	[Status] [int] NULL,
	[City] [nvarchar](50) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[Country] [nvarchar](50) NULL,
	[Extension] [nvarchar](15) NULL,
 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_Address_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]),
CONSTRAINT [FK_Address_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id])
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[UserId] UNIQUEIDENTIFIER NULL,
	[CompanyName] [nvarchar](100) NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](50) NULL,
	[Phone] [varchar](30) NULL,
	[Email] NVARCHAR(256),
	[AddressId] [int] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] DEFAULT 1 NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_Customer_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]),
CONSTRAINT [FK_Customer_Address] FOREIGN KEY([AddressId]) REFERENCES [dbo].[Address] ([Id]),
CONSTRAINT [FK_Customer_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]),
CONSTRAINT [FK_Customer_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id])

) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[UserId] UNIQUEIDENTIFIER NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[Phone] [varchar](30) NULL,
	[Email] [varchar](100) NULL,
	[Title] [nvarchar](50) NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[Photo] [image] NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL,
	[AddressId] [int] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),	
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](250) NULL,
	[Status] [int] DEFAULT 1 NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_Employee_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]),-- 1. Nối với bảng Users (Tài khoản đăng nhập của nhân viên)
CONSTRAINT [FK_Employee_Address] FOREIGN KEY([AddressId]) REFERENCES [dbo].[Address] ([Id]),-- 2. Nối với bảng Address (Địa chỉ của nhân viên)
CONSTRAINT [FK_Employee_Employee_ReportsTo] FOREIGN KEY([ReportsTo]) REFERENCES [dbo].[Employee] ([Id]), -- 3. Khóa ngoại TỰ THAM CHIẾU (Quản lý cấp trên)
-- 4. Khóa ngoại cho người tạo và người cập nhật
CONSTRAINT [FK_Employee_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]),
CONSTRAINT [FK_Employee_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[CustomerId] [int] NULL,
	[EmployeeId] [int] NULL,
	[OrderDate] [datetime] NULL,
	[Freight] [money] NULL,
	[Receive] [nvarchar](100) NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NOT NULL DEFAULT 0,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_Order_Customer] FOREIGN KEY([CustomerId]) REFERENCES [dbo].[Customer] ([Id]),-- 1. Khách hàng nào đặt đơn hàng này?
CONSTRAINT [FK_Order_Employee] FOREIGN KEY([EmployeeId]) REFERENCES [dbo].[Employee] ([Id]),-- 2. Nhân viên nào xử lý đơn hàng này?
-- 3. Ai là người tạo/cập nhật đơn hàng trên phần mềm?
CONSTRAINT [FK_Order_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]),
CONSTRAINT [FK_Order_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id])
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductOption]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[ProductId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SortOrder] [int] NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
 CONSTRAINT [PK_ProductOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductOptionValue]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductOptionValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[ProductOptionId] [int] NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SortOrder] [int] NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
 CONSTRAINT [PK_ProductOptionValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariant]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariant](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[ProductId] [int] NULL,
	[SKU] [nvarchar](50) NULL,
	[Name] [nvarchar](150) NULL,
	[Description] [nvarchar](max) NULL,
	[Barcode] [nvarchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[CompareAtPrice] [decimal](18, 2) NULL,
	[StockQuantity] [int] NULL,
	[ImageUrl] [nvarchar](500) NULL,
	[IsDefault] [bit] NULL,
	[Weight] [decimal](10, 2) NULL,
	[Length] [decimal](10, 2) NULL,
	[Width] [decimal](10, 2) NULL,
	[Height] [decimal](10, 2) NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
	[RowVersions] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductVariant] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductVariant] ADD CONSTRAINT [CK_ProductVariant_StockQuantity_Positive] CHECK ([StockQuantity] >= 0);
GO
/****** Object:  Table [dbo].[ProductVariantOptionValue]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariantOptionValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[ProductVariantId] [int] NOT NULL,
	[ProductOptionValueId] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
 CONSTRAINT [PK_ProductVariantOptionValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Nối Variant với Product (Giả sử bảng Product của bà đã có Id là INT)
ALTER TABLE [dbo].[ProductVariant] ADD CONSTRAINT [FK_ProductVariant_Product] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Product] ([Id]);

-- Nối Option với Product
ALTER TABLE [dbo].[ProductOption] ADD CONSTRAINT [FK_ProductOption_Product] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Product] ([Id]);

-- Nối Value với Option
ALTER TABLE [dbo].[ProductOptionValue] ADD CONSTRAINT [FK_ProductOptionValue_Option] FOREIGN KEY([ProductOptionId]) REFERENCES [dbo].[ProductOption] ([Id]);

-- Nối bảng trung gian với Variant và Value
ALTER TABLE [dbo].[ProductVariantOptionValue] ADD CONSTRAINT [FK_PVov_Variant] FOREIGN KEY([ProductVariantId]) REFERENCES [dbo].[ProductVariant] ([Id]);
ALTER TABLE [dbo].[ProductVariantOptionValue] ADD CONSTRAINT [FK_PVov_Value] FOREIGN KEY([ProductOptionValueId]) REFERENCES [dbo].[ProductOptionValue] ([Id]);
GO
/****** Object:  View [dbo].[viewProductVariantDetail]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewProductVariantDetail]
AS
SELECT
  pv.Id AS VariantId,
  pv.ProductId,
  pv.SKU,
  pv.Price,
  pv.StockQuantity,
  STRING_AGG(CAST(po.Name + ': ' + pov.Name AS NVARCHAR(MAX)), ', ') WITHIN GROUP (ORDER BY po.SortOrder) AS VariantOptions
FROM dbo.ProductVariant pv
LEFT JOIN dbo.ProductVariantOptionValue pvov ON pv.Id = pvov.ProductVariantId
LEFT JOIN dbo.ProductOptionValue pov ON pov.Id = pvov.ProductOptionValueId
LEFT JOIN dbo.ProductOption po ON po.Id = pov.ProductOptionId
GROUP BY pv.Id, pv.ProductId, pv.SKU, pv.Price, pv.StockQuantity;

GO

/****** Object:  Table [dbo].[OrderDetail]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[Id] INT IDENTITY(1,1) NOT NULL,
	Uid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductVariantId] [int] NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[ProductName] [nvarchar](150) NULL,
	[SKU] [nvarchar](50) NULL,
	[VariantInfo] [nvarchar](512) NULL,
	[LineTotal] [decimal](18, 2) NULL,
	[Discount] [real] NULL,
	[CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
	[CreatedBy] UNIQUEIDENTIFIER NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] UNIQUEIDENTIFIER NULL,
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
-- 1. Nối với Đơn hàng chính
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY([OrderId]) REFERENCES [dbo].[Order] ([Id]);

-- 2. Nối với Biến thể sản phẩm (Mỹ phẩm màu gì, size gì)
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [FK_OrderDetail_ProductVariant] FOREIGN KEY([ProductVariantId]) REFERENCES [dbo].[ProductVariant] ([Id]);

-- 3. Nối với người tạo (Nếu cần truy vết)
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [FK_OrderDetail_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]);
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [FK_OrderDetail_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id]);

-- 4. Nối với bảng Product (Sản phẩm gốc)
ALTER TABLE [dbo].[OrderDetail] WITH CHECK ADD CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Product] ([Id])

GO

/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [uniqueidentifier] NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- 1. Nối UserClaims với Users
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [FK_UserClaims_Users] 
FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;

-- 2. Nối UserLogins với Users
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [FK_UserLogins_Users] 
FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;

-- 3. Nối UserTokens với Users
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [FK_UserTokens_Users] 
FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE;

-- 4. Nối RoleClaims với Roles (Bảng Roles bà đã tạo trước đó)
ALTER TABLE [dbo].[AspNetRoleClaims] ADD CONSTRAINT [FK_RoleClaims_Roles] 
FOREIGN KEY([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE;

GO

/****** Object:  Table [dbo].[Inventory]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[Id] [int] IDENTITY(1,1) NOT NULL, -- Thêm tự động tăng
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- Thêm mặc định
	[VariantId] [int] NOT NULL,
	[Quantity] [int] NULL DEFAULT 0,
	[WarehouseId] [int] NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [uniqueidentifier] NULL, -- Sửa thành GUID
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL, -- Sửa thành GUID
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
	[row_version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
--Thêm khóa ngoại để nối với biến thể sản phẩm bà đã tạo
ALTER TABLE [dbo].[Inventory] ADD CONSTRAINT [FK_Inventory_ProductVariant] FOREIGN KEY([VariantId]) REFERENCES [dbo].[ProductVariant] ([Id]);

GO

/****** Object:  Table [dbo].[Payment]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[Id] [int] IDENTITY(1,1) NOT NULL, -- Thêm IDENTITY
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- Thêm DEFAULT
	[OrderId] [int] NOT NULL, -- Thanh toán phải gắn với 1 Order, nên để NOT NULL
	[Amount] [decimal](18, 2) NOT NULL, -- Đổi sang decimal cho chuẩn tiền tệ
	[Method] [nvarchar](50) NULL, -- Ví dụ: 'Cash', 'Credit Card', 'Momo'
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(), -- Thêm DEFAULT
	[CreatedBy] [uniqueidentifier] NULL, -- Sửa thành GUID
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL, -- Sửa thành GUID
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1, -- 1: Thành công, 0: Thất bại/Chờ
 CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Payment] WITH CHECK ADD CONSTRAINT [FK_Payment_Order] FOREIGN KEY([OrderId]) REFERENCES [dbo].[Order] ([Id])
GO

/****** Object:  Table [dbo].[Shipper]    Script Date: 4/9/2026 5:12:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipper](
	[Id] [int] IDENTITY(1,1) NOT NULL, -- Thêm IDENTITY
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- Thêm DEFAULT
	[CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL,
	[AddressId] [int] NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [uniqueidentifier] NULL, -- Đổi thành GUID
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL, -- Đổi thành GUID
	[Notes] [nvarchar](256) NULL,
	[Status] [int] NULL DEFAULT 1,
 CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ShipInfo]    Script Date: 4/9/2026 5:12:11 PM ******/
CREATE TABLE [dbo].[ShipInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL, -- Thêm IDENTITY
	[Uid] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- Thêm DEFAULT
	[OrderId] [int] NOT NULL,
	[ShipperId] [int] NOT NULL,
	[CountryId] [int] NULL,
	[ProvinceId] [int] NULL,
	[WardId] [int] NULL,
	[TownId] [int] NULL,
	[AddressId] [int] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipAddress] [nvarchar](150) NULL,
	[ShipName] [nvarchar](50) NULL,
	[ShipPhone] [varchar](15) NULL, 
	[ShipCity] [nvarchar](50) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](15) NULL,
	[ShipCountry] [nvarchar](50) NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT GETDATE(),
	[CreatedBy] [uniqueidentifier] NULL, -- Đổi thành GUID
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL, -- Đổi thành GUID
	[Notes] [nvarchar](255) NULL,
	[Status] [int] NULL DEFAULT 1,
 CONSTRAINT [ShipAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Kết nối ShipInfo với Order
ALTER TABLE [dbo].[ShipInfo] ADD CONSTRAINT [FK_ShipInfo_Order] FOREIGN KEY([OrderId]) REFERENCES [dbo].[Order] ([Id]);

-- Kết nối ShipInfo với Shipper
ALTER TABLE [dbo].[ShipInfo] ADD CONSTRAINT [FK_ShipInfo_Shipper] FOREIGN KEY([ShipperId]) REFERENCES [dbo].[Shipper] ([Id]);

-- Kết nối CreatedBy với bảng Users (Dành cho cả 2 bảng)
ALTER TABLE [dbo].[Shipper] ADD CONSTRAINT [FK_Shipper_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]);
ALTER TABLE [dbo].[ShipInfo] ADD CONSTRAINT [FK_ShipInfo_Users_Created] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([Id]);

-- Kết nối UpdatedBy với bảng Users (Dành cho cả 2 bảng)
ALTER TABLE [dbo].[Shipper] ADD CONSTRAINT [FK_Shipper_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id]);
ALTER TABLE [dbo].[ShipInfo] ADD CONSTRAINT [FK_ShipInfo_Users_Updated] FOREIGN KEY([UpdatedBy]) REFERENCES [dbo].[Users] ([Id]);


GO
-- Đảm bảo mã SKU của từng loại mỹ phẩm không được trùng nhau
ALTER TABLE [dbo].[ProductVariant] ADD CONSTRAINT [UQ_ProductVariant_SKU] UNIQUE NONCLUSTERED ([SKU] ASC);
-- 1. Kiểm tra ngày sinh nhân viên phải hợp lý
ALTER TABLE [dbo].[Employee] WITH CHECK ADD CONSTRAINT [CK_Birthdate] CHECK (([BirthDate] < getdate()));

-- 2. Kiểm tra giảm giá trong đơn hàng (0 đến 1, ví dụ 0.1 là 10%)
ALTER TABLE [dbo].[OrderDetail] WITH CHECK ADD CONSTRAINT [CK_Discount] CHECK (([Discount] >= (0) AND [Discount] <= (1)));

-- 3. Số lượng mua phải lớn hơn 0
ALTER TABLE [dbo].[OrderDetail] WITH CHECK ADD CONSTRAINT [CK_Quantity] CHECK (([Quantity] > (0)));

-- 4. Giá tiền không được âm
ALTER TABLE [dbo].[OrderDetail] WITH CHECK ADD CONSTRAINT [CK_OrderDetail_UnitPrice] CHECK (([UnitPrice] >= (0)));
ALTER TABLE [dbo].[Product] WITH CHECK ADD CONSTRAINT [CK_Products_UnitPrice] CHECK (([UnitPrice] >= (0)));

-- 5. Đảm bảo kho không bị hiển thị số âm (Logic trừ kho cần cái này nè)
ALTER TABLE [dbo].[Product] WITH CHECK ADD CONSTRAINT [CK_UnitsInStock] CHECK (([UnitsInStock] >= (0)));
ALTER TABLE [dbo].[ProductVariant] WITH CHECK ADD CONSTRAINT [CK_StockQuantity_NotNegative] CHECK ([StockQuantity] >= 0);

-- Mặc định phí vận chuyển và các giá trị tiền tệ là 0
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [DF_Orders_Freight] DEFAULT ((0)) FOR [Freight];
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [DF_Order_Details_UnitPrice] DEFAULT ((0)) FOR [UnitPrice];
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [DF_Order_Details_Quantity] DEFAULT ((1)) FOR [Quantity];
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [DF_Products_UnitPrice] DEFAULT ((0)) FOR [UnitPrice];
ALTER TABLE [dbo].[ProductVariant] ADD CONSTRAINT [DF_ProductVariant_IsDefault] DEFAULT ((0)) FOR [IsDefault];

INSERT INTO [dbo].[Roles] ([Name], [NormalizedName], [Description])
VALUES 
(N'Admin', N'ADMIN', N'Quản trị viên hệ thống'),
(N'Customer', N'CUSTOMER', N'Khách hàng mua sắm'),
(N'Employee', N'EMPLOYEE', N'Nhân viên bán hàng');

-- 1. KHAI BÁO BIẾN (Chỗ này bà chạy chung một lượt nhé từ 1-5 nhé)
DECLARE @AdminId UNIQUEIDENTIFIER = NEWID();
DECLARE @CustomerId UNIQUEIDENTIFIER = NEWID();
DECLARE @EmployeeUserId UNIQUEIDENTIFIER = NEWID();
DECLARE @RoleAdminId UNIQUEIDENTIFIER, @RoleCustomerId UNIQUEIDENTIFIER, @RoleEmployeeId UNIQUEIDENTIFIER;

-- 2. LẤY ID ROLE (Bảng Roles bà đã có dữ liệu rồi)
SELECT @RoleAdminId = Id FROM [dbo].[Roles] WHERE [Name] = 'Admin';
SELECT @RoleCustomerId = Id FROM [dbo].[Roles] WHERE [Name] = 'Customer';
SELECT @RoleEmployeeId = Id FROM [dbo].[Roles] WHERE [Name] = 'Employee';

-- 3. INSERT VÀO BẢNG USERS
INSERT INTO [dbo].[Users] ([Id], [FullName], [IsActive], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount])
VALUES 
(@AdminId, N'Nguyễn Quản Trị', 1, 'admin@gmail.com', 'admin@gmail.com', 1, 0, 0, 1, 0),
(@CustomerId, N'Trần Khách Hàng', 1, 'customer@gmail.com', 'customer@gmail.com', 1, 0, 0, 1, 0),
(@EmployeeUserId, N'Lê Nhân Viên', 1, 'nv01@gmail.com', 'nv01@gmail.com', 1, 0, 0, 1, 0);

-- 4. GÁN QUYỀN (Bảng trung gian)
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId])
VALUES 
(@AdminId, @RoleAdminId),
(@CustomerId, @RoleCustomerId),
(@EmployeeUserId, @RoleEmployeeId);

-- 5. INSERT VÀO BẢNG EMPLOYEE 
INSERT INTO [dbo].[Employee] (
    [UserId], 
    [LastName], 
    [FirstName], 
    [Phone], 
    [Email], 
    [Title], 
    [BirthDate], 
    [HireDate], 
    [Status], 
    [CreatedBy],
    [Notes]
)
VALUES (
    @EmployeeUserId, 
    N'Lê',              -- LastName (NOT NULL)
    N'Văn Viên',        -- FirstName (NOT NULL)
    '0901234567',       -- Phone
    'nv01@gmail.com',   -- Email
    N'Sale Manager',    -- Title
    '1995-05-20',       -- BirthDate
    GETDATE(),          -- HireDate
    1,                  -- Status (Mặc định 1 là đang làm việc)
    @AdminId,           -- CreatedBy (Lấy ID ông Admin ở trên)
    N'Quản lý đội ngũ bán hàng' -- Notes
);

-- BƯỚC 2: TẠO 8 NHÂN VIÊN MỚI QUA BẢNG TẠM
---------------------------------------------------------
CREATE TABLE #TempStaff (
    Tid UNIQUEIDENTIFIER DEFAULT NEWID(),
    LName NVARCHAR(50), FName NVARCHAR(50), Email VARCHAR(100), Title NVARCHAR(50)
);

INSERT INTO #TempStaff (LName, FName, Email, Title)
VALUES 
(N'Lê', N'Văn Bình', 'binh.lv@gmail.com', N'Sales Staff'),
(N'Thân',N'Thế Cường','cuong.tt@gmail.com',N'Sales Staff'),
(N'Phan',N' Mạnh Dâng','dang.pmanh@gmail.com',N'Sales Staff'),
(N'Nguyễn', N'Văn An', 'an.nv@gmail.com', N'Sales Staff'),
(N'Lê', N'Thị Bình', 'binh.lt@gmail.com', N'Sales Staff'),
(N'Trần', N'Hoàng Cường', 'cuong.th@gmail.com', N'Accountant'),
(N'Phạm', N'Minh Đăng', 'dang.pm@gmail.com', N'Technician'),
(N'Võ', N'Thị Em', 'em.vt@gmail.com', N'Receptionist');


-- Insert vào Users
INSERT INTO [dbo].[Users] ([Id], [FullName], [UserName], [Email], [IsActive], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount])
SELECT Tid, LName + ' ' + FName, Email, Email, 1, 1, 0, 0, 1, 0 FROM #TempStaff;

-- Gán quyền Employee
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId])
SELECT Tid, (SELECT TOP 1 Id FROM [dbo].[Roles] WHERE [Name] = 'Employee') FROM #TempStaff;

-- Insert vào Employee & GÁN LUÔN REPORTS TO CHO ÔNG LÊ (ID của ông Lê làm Manager)
DECLARE @ManagerId INT;
SELECT TOP 1 @ManagerId = Id FROM [dbo].[Employee] WHERE Email = 'nv01@gmail.com';

INSERT INTO [dbo].[Employee] ([UserId], [LastName], [FirstName], [Email], [Title], [HireDate], [Status], [CreatedBy], [ReportsTo])
SELECT Tid, LName, FName, Email, Title, GETDATE(), 1, 
       (SELECT Id FROM [dbo].[Users] WHERE Email = 'nv01@gmail.com'), 
       @ManagerId -- Tất cả báo cáo cho ông Lê
FROM #TempStaff;

DROP TABLE #TempStaff;

-- BƯỚC 3: KIỂM TRA LẠI KẾT QUẢ
---------------------------------------------------------
SELECT 
    e.LastName  + ' ' + e.FirstName AS [Nhân Viên],
    e.Title AS [Chức Danh],
    m.LastName + ' ' + m.FirstName AS [Sếp Trực Tiếp]
FROM [dbo].[Employee] e
LEFT JOIN [dbo].[Employee] m ON e.ReportsTo = m.Id;

GO

-- Tạo bảng tạm để giữ thông tin 10 khách hàng mới
CREATE TABLE #TempUsers (Tid UNIQUEIDENTIFIER DEFAULT NEWID(), FName NVARCHAR(100), Mail NVARCHAR(256));

INSERT INTO #TempUsers (FName, Mail) VALUES 
(N'Nguyễn Thị Lan', 'lan.nt@gmail.com'), (N'Trần Văn Hùng', 'hung.tv@gmail.com'),
(N'Lê Minh Tâm', 'tam.lm@gmail.com'), (N'Phạm Bảo Châu', 'chau.pb@gmail.com'),
(N'Hoàng Gia Bách', 'bach.hg@gmail.com'), (N'Đỗ Thanh Hải', 'hai.dt@gmail.com'),
(N'Bùi Kim Yến', 'yen.bk@gmail.com'), (N'Vũ Đức Thịnh', 'thinh.vd@gmail.com'),
(N'Phan Ngọc Diệp', 'diep.pn@gmail.com'), (N'Trịnh Thiên Ân', 'an.tt@gmail.com');

-- Insert vào bảng Users thật
INSERT INTO [dbo].[Users] ([Id], [FullName], [UserName], [Email], [IsActive], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount])
SELECT Tid, FName, Mail, Mail, 1, 1, 0, 0, 1, 0 FROM #TempUsers;

-- Gán quyền Role 'Customer' cho 10 ông này (Nếu bà có bảng AspNetUserRoles)
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId])
SELECT Tid, (SELECT TOP 1 Id FROM [dbo].[Roles] WHERE [Name] = 'Customer') FROM #TempUsers;
GO
SELECT Id, Email, UserName 
FROM [dbo].[Users]
WHERE Id NOT IN (SELECT UserId FROM [dbo].[AspNetUserRoles]);


INSERT INTO [dbo].[AspNetUserRoles] (UserId, RoleId)
SELECT 
    u.Id, 
    (SELECT Id FROM [dbo].[Roles] WHERE [Name] = 'Employee')
FROM [dbo].[Users] u
WHERE u.Id NOT IN (SELECT UserId FROM [dbo].[AspNetUserRoles]);

-- 1. Tạo 9 địa chỉ cho NHÂN VIÊN (Quản lí tạo)
INSERT INTO [dbo].[Address] ([AddressNo], [City], [Status], [CreatedBy], [Notes])
VALUES 
(N'12 Nguyễn Đình Chiểu, Q.1', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV5'),
(N'45 Võ Văn Tần, Q.3', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV6'),
(N'123 Điện Biên Phủ, Q. Bình Thạnh', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV7'),
(N'88 Trường Sơn, Q. Tân Bình', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV8'),
(N'606 Ba Tháng Hai, Q.10', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV9'),
(N'15 Lê Hồng Phong, P. Phú Hòa', N'Thủ Dầu Một', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ Sếp Lê NV'),
(N'45 Lê Lợi, Q.1', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV2'),
(N'128 Cách Mạng Tháng 8, Q.3', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV3'),
(N'720A Điện Biên Phủ, Q.Bình Thạnh', N'TP.HCM', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Địa chỉ NV4');

GO

-- 2. Tạo 10 địa chỉ cho KHÁCH HÀNG (Nhân viên bốc ngẫu nhiên tạo)
INSERT INTO [dbo].[Address] ([AddressNo], [City], [Status], [CreatedBy], [Notes])
SELECT Adr, Cit, 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = CHOOSE(ABS(CHECKSUM(NEWID())) % 8 + 1, 1, 2, 3, 4, 5, 6, 7, 9)), N'Địa chỉ Khách hàng'
FROM (VALUES 
    (N'10 Kim Mã, Q. Ba Đình', N'Hà Nội'), (N'22 Láng Hạ, Q. Đống Đa', N'Hà Nội'),
    (N'50 Xuân Thủy, Q. Cầu Giấy', N'Hà Nội'), (N'05 Duy Tân, Q. Hải Châu', N'Đà Nẵng'),
    (N'100 Võ Nguyên Giáp, Q. Sơn Trà', N'Đà Nẵng'), (N'30 Thắng Lợi, Q. Ninh Kiều', N'Cần Thơ'),
    (N'09 Hà Huy Giáp, P. Quyết Thắng', N'Biên Hòa'), (N'12 Hoàng Văn Thụ, P. Minh Khai', N'Hải Phòng'),
    (N'55 Hùng Vương, P.4', N'Tân An'), (N'200 Trần Hưng Đạo, P. Lê Hồng Phong', N'Quy Nhơn')
) AS Temp(Adr, Cit);
GO

-- 1. CHUẨN BỊ DỮ LIỆU (Đánh số thứ tự sẵn để map với Address)
---------------------------------------------------------
SELECT 
    u.Id AS UserId, 
    u.Email, 
    u.FullName,
    ROW_NUMBER() OVER (ORDER BY u.Email) as RowNum -- Đánh số từ 1-10
INTO #FinalMapping
FROM [dbo].[Users] u
INNER JOIN #TempUsers t ON u.Email = t.Mail;

-- 2. INSERT VÀO CUSTOMER (Map 1-1 với Address ID từ 7 đến 16)
---------------------------------------------------------
INSERT INTO [dbo].[Customer] ([UserId], [Email], [ContactName], [AddressId], [Status], [CreatedAt], [CreatedBy])
SELECT 
    m.UserId, 
    m.Email, 
    m.FullName,
    (m.RowNum + 6), -- RowNum 1 + 6 = ID 7, RowNum 2 + 6 = ID 8... (Khớp đúng 10 địa chỉ KH)
    1, 
    GETDATE(),
    (SELECT UserId FROM [dbo].[Employee]  WHERE Id = CHOOSE((ABS(CHECKSUM(NEWID())) % 8) + 1, 1, 2, 3, 4, 5, 6, 7, 9)) -- Gán đại 1 NV làm người tạo cho vui
FROM #FinalMapping m;


-- 3. DỌN DẸP
---------------------------------------------------------
DROP TABLE #TempUsers;
DROP TABLE #FinalMapping;
GO
--INSERT SỐ ĐIỆN THOẠI CUSTOMER
UPDATE [dbo].[Customer]
SET [Phone] = '09' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS NVARCHAR)
WHERE [Phone] IS NULL OR [Phone] = '';

UPDATE [dbo].[Customer]
SET [CreatedBy] = (
    SELECT UserId 
    FROM [dbo].[Employee] 
    WHERE Id = CHOOSE((ABS(CHECKSUM(NEWID())) % 8) + 1, 1, 2, 3, 4, 5, 6, 7, 9)
);

-- UPDATE ĐỊA CHỈ CỦA NHÂN VIÊN
UPDATE [dbo].[Employee] SET [AddressId] = 6 WHERE [Email] = 'nv01@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 1 WHERE [Email] = 'an.nv@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 2 WHERE [Email] = 'binh.lt@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 3 WHERE [Email] = 'cuong.th@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 4 WHERE [Email] = 'dang.pm@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 5 WHERE [Email] = 'em.vt@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 17 WHERE [Email] = 'binh.lv@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 18 WHERE [Email] = 'cuong.tt@gmail.com';
UPDATE [dbo].[Employee] SET [AddressId] = 19 WHERE [Email] = 'dang.pmanh@gmail.com';

GO

---------------------------------------------------------
-- CHÈN Order 22 ĐƠN HÀNG (11 KHÁCH TỰ ĐẶT - 11 NHÂN VIÊN TẠO): nhớ chạy 1 lượt 22 đơn
---------------------------------------------------------
INSERT INTO [dbo].[Order] 
    ([CustomerId], [EmployeeId], [OrderDate], [Freight], [Receive], [Status], [CreatedBy], [Notes])
VALUES 
-- 10 ĐƠN ĐẦU: KHÁCH HÀNG TỰ ĐẶT (CreatedBy lấy từ Customer.UserId)
(1, 2, GETDATE(), 50000, N'Giao gấp cho khách', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 1), N'Khách số 1 đặt đơn'),
(1,  1, GETDATE(), 30000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 1),  N'Khách tự đặt đơn 1'),
(2,  2, GETDATE(), 15000, N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 2),  N'Khách tự đặt đơn 2'),
(3,  3, GETDATE(), 20000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 3),  N'Khách tự đặt đơn 3'),
(4,  4, GETDATE(), 0,     N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 4),  N'Khách tự đặt đơn 4'),
(5,  5, GETDATE(), 40000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 5),  N'Khách tự đặt đơn 5'),
(6,  6, GETDATE(), 25000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 6),  N'Khách tự đặt đơn 6'),
(7,  1, GETDATE(), 35000, N'Giao tận nơi', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 7),  N'Khách tự đặt đơn 7'),
(8,  2, GETDATE(), 10000, N'Tại cửa hàng', 1, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 8),  N'Khách tự đặt đơn 8'),
(9,  3, GETDATE(), 50000, N'Giao tận nơi', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 9),  N'Khách tự đặt đơn 9'),
(10, 4, GETDATE(), 0,     N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 10), N'Khách tự đặt đơn 10'),
-- 10 ĐƠN SAU: NHÂN VIÊN TẠO HỘ (CreatedBy lấy từ Employee.UserId)
(2, 3, GETDATE(), 0,     N'Khách hẹn lấy tại quầy', 2, (SELECT UserId FROM [dbo].[Customer] WHERE Id = 2), N'Đơn nhân viên 3 đặt hộ'),
(1,  5, GETDATE(), 20000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 5), N'Nhân viên 5 tạo hộ'),
(2,  6, GETDATE(), 30000, N'Giao tận nơi', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 6), N'Nhân viên 6 tạo hộ'),
(3,  1, GETDATE(), 15000, N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Quản lí tạo hộ'),
(4,  2, GETDATE(), 45000, N'Giao tận nơi', 0, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 2), N'Nhân viên 2 tạo hộ'),
(5,  3, GETDATE(), 20000, N'Giao tận nơi', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 3), N'Nhân viên 3 tạo hộ'),
(6,  4, GETDATE(), 0,     N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 4), N'Nhân viên 4 tạo hộ'),
(7,  5, GETDATE(), 25000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 5), N'Nhân viên 5 tạo hộ'),
(8,  6, GETDATE(), 35000, N'Giao tận nơi', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 6), N'Nhân viên 6 tạo hộ'),
(9,  1, GETDATE(), 10000, N'Tại cửa hàng', 2, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), N'Quản lí 1 tạo hộ'),
(10, 2, GETDATE(), 50000, N'Giao tận nơi', 1, (SELECT UserId FROM [dbo].[Employee] WHERE Id = 2), N'Nhân viên 2 tạo hộ');

---------------------------------------------------------
-- KIỂM TRA LẠI XEM ĐÃ INSERT ĐỦ CHƯA
---------------------------------------------------------
SELECT 
    o.Id AS [MaDon],
    c.ContactName AS [KhachHang],
    e.FirstName AS [NhanVienXuLy],
    u.FullName AS [NguoiNhapDon],
    o.Notes
FROM [dbo].[Order] o
JOIN [dbo].[Customer] c ON o.CustomerId = c.Id
JOIN [dbo].[Employee] e ON o.EmployeeId = e.Id
JOIN [dbo].[Users] u ON o.CreatedBy = u.Id;

SELECT 
    o.Id AS [OrderID],
    o.Notes,
    CASE 
        WHEN u.Id = c.UserId THEN N'Khách tự đặt'
        WHEN u.Id = e.UserId THEN N'Nhân viên tạo hộ'
        ELSE N'Không xác định'
    END AS [Nguồn tạo đơn]
FROM [dbo].[Order] o
LEFT JOIN [dbo].[Users] u ON o.CreatedBy = u.Id
LEFT JOIN [dbo].[Customer] c ON o.CustomerId = c.Id
LEFT JOIN [dbo].[Employee] e ON o.EmployeeId = e.Id;

GO

--INSERT ProductOption
-- 🧼 INSERT OPTION NHÓM 1: CLEANER (10 Sản phẩm)
---------------------------------------------------------
-- Sữa rửa mặt thường có nhiều dung tích (150ml, 250ml, 400ml...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (1, N'Dung tích', 1); -- Ultra Facial Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (2, N'Dung tích', 1); -- Calendula Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (3, N'Dung tích', 1); -- Foaming Facial Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (4, N'Dung tích', 1); -- Hydrating Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (5, N'Dung tích', 1); -- Effaclar Gel Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (6, N'Dung tích', 1); -- Deep Cleansing Oil
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (7, N'Trọng lượng', 1); -- Perfect Whip (Dạng tuýp g)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (8, N'Dung tích', 1); -- Green Tea Foam Cleanser
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (9, N'Dung tích', 1); -- Tea Tree Facial Wash
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (10, N'Dung tích', 1); -- Gentle Cleanser

---------------------------------------------------------
-- 💧 INSERT OPTION NHÓM 2: SKINCARE (ProducId 1 - 10) (10 Sản phẩm - 10 Option)
---------------------------------------------------------
-- Serum cao cấp thường có bản chiết hoặc bản giới hạn
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (11, N'Dung tích', 1); -- Advanced Night Repair (7ml, 30ml, 50ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (12, N'Dung tích', 1); -- Moisture Surge
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (13, N'Dung tích', 1); -- Revitalift Hyaluronic Serum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (14, N'Dung tích', 1); -- Clearly Corrective Serum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (15, N'Dung tích', 1); -- Mineral 89
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (16, N'Trọng lượng', 1); -- Hydro Boost Gel (Hũ g)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (17, N'Dung tích', 1); -- Aloe Revital Soothing Gel (300ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (18, N'Dung tích', 1); -- Vitamin E Cream
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (19, N'Dung tích', 1); -- White Lucent Cream
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (20, N'Trọng lượng', 1); -- Total Effects Cream
---------------------------------------------------------
-- 🧪 INSERT OPTION NHÓM 3: TREATMENT (Dòng 21 - 30) (10 sản phẩm - 10 option)
---------------------------------------------------------
-- Nhóm đặc trị thường phân loại theo Dung tích hoặc Phiên bản (Bản gel/cream)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (21, N'Dung tích', 1); -- Effaclar Duo+ (40ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (22, N'Dung tích', 1); -- Retinol B3 Serum (30ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (23, N'Dung tích', 1); -- Normaderm Serum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (24, N'Dung tích', 1); -- Anti-Pigment Serum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (25, N'Dung tích', 1); -- Acne Solutions Gel
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (26, N'Dung tích', 1); -- Dark Spot Solution
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (27, N'Dung tích', 1); -- Rapid Wrinkle Repair
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (28, N'Dung tích', 1); -- Tea Tree Oil (10ml/20ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (29, N'Dung tích', 1); -- Clear Face Gel
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (30, N'Dung tích', 1); -- Glycolic Bright Serum

---------------------------------------------------------
-- ☀️ INSERT OPTION NHÓM 4: SUNSCREEN (Dòng 31 - 38) (8 SP - 8 Option)
---------------------------------------------------------
-- Chống nắng cực kỳ đa dạng, thường có phân loại theo Kết cấu hoặc Loại da
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (31, N'Dung tích', 1); -- Anthelios SPF50 (50ml)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (32, N'Phân loại da', 1); -- Capital Soleil (Cho da dầu/khô)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (33, N'Dung tích', 1); -- Ultra Sheer SPF50
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (34, N'Dung tích', 1); -- UV Protector SPF50
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (35, N'Dung tích', 1); -- Perfect UV Milk
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (36, N'Phiên bản', 1); -- Sun Fluid SPF50 (Có màu/Không màu)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (37, N'Dung tích', 1); -- UV Defense SPF50
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (38, N'Dung tích', 1); -- UV Perfect SPF50
---------------------------------------------------------
-- 🎨 INSERT OPTION NHÓM 5: BASE MAKEUP (Dòng 39 - 46) (8sp - 8 option)
---------------------------------------------------------
-- Kem nền/Cushion bắt buộc chọn theo sắc độ da (Tone)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (39, N'Tông màu', 1); -- Fit Me Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (40, N'Tông màu', 1); -- Double Wear Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (41, N'Tông màu', 1); -- Teint Idole Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (42, N'Tông màu', 1); -- Studio Fix Fluid
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (43, N'Tông màu', 1); -- True Match Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (44, N'Tông màu', 1); -- ColorStay Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (45, N'Tông màu', 1); -- Total Control Drop Foundation
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (46, N'Tông màu', 1); -- Natural Radiant Foundation

---------------------------------------------------------
-- 👁️ INSERT OPTION NHÓM 6: EYE MAKEUP (Dòng 47 - 54) (8 sp - 8 option)
---------------------------------------------------------
-- Mascara thường chia theo Công dụng hoặc Màu (Đen/Nâu)
-- Bảng mắt chia theo Mã màu (Palette No.)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (47, N'Phiên bản', 1); -- Hypnôse Mascara (Waterproof/Thường)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (48, N'Màu sắc', 1); -- Great Lash Mascara (Black/Brown)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (49, N'Phiên bản', 1); -- Lash Power Mascara
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (50, N'Màu sắc', 1); -- In Extreme Dimension Mascara
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (51, N'Mã màu', 1);   -- Mood Recipe Palette (Plot Twist/Smoothen...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (52, N'Phiên bản', 1); -- Naked Palette (Naked 1, 2, 3, Heat...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (53, N'Màu sắc', 1); -- Climax Mascara
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (54, N'Dung tích', 1); -- Full Frontal Mascara (Bản mini/full)

---------------------------------------------------------
-- 💋 INSERT OPTION NHÓM 7: CHEEK & LIP (dòng 55 - 62) (8SP - 8 Otion)
---------------------------------------------------------
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (55, N'Mã màu son', 1); -- Rouge Coco Lipstick
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (56, N'Mã màu son', 1); -- Matte Lipstick (MAC - Ruby Woo, Chili...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (57, N'Mã màu son', 1); -- SuperStay Matte Ink
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (58, N'Mã màu son', 1); -- Velvet Lip Pencil
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (59, N'Dòng màu', 1);   -- Gloss Bomb (Fenty - Fu$$y, Glass Slipper...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (60, N'Màu phấn má', 1); -- Powder Blush (NARS - Orgasm, Deep Throat...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (61, N'Mã màu tint', 1); -- Lip Tint (3CE - Velvet Lip Tint colors)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (62, N'Mã màu son', 1); -- Soft Matte Lip Cream

---------------------------------------------------------
-- 🧱 INSERT OPTION NHÓM 8: CONTOUR & HIGHLIGHT (Dòng 63 - 68) (6SP - 6 Option)
---------------------------------------------------------
-- Nhóm này chia theo sắc độ (Light/Medium/Dark) hoặc hiệu ứng ánh sáng
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (63, N'Tông màu', 1);   -- Match Stix Contour (Amber, Mocha...)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (64, N'Hiệu ứng', 1);   -- Mineralize Skinfinish (Global Glow, Soft & Gentle)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (65, N'Sắc độ', 1);    -- Born to Glow Highlighter
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (66, N'Màu bắt sáng', 1); -- Illuminator
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (67, N'Tông màu', 1);   -- Bronze Goddess
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (68, N'Bảng màu', 1);   -- Master Contour Kit (Light to Medium/Medium to Deep)

---------------------------------------------------------
-- 🧴 INSERT OPTION NHÓM 9: BODY CARE (Sản phẩm 69 - 74)
---------------------------------------------------------
-- 69 Body Lotion (NIVEA)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (69, N'Dung tích', 1);
-- 70 Body Wash (Dove)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (70, N'Dung tích', 1);
-- 71 Body Butter (The Body Shop)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (71, N'Trọng lượng', 1);
-- 72 Creme de Corps (Kiehl's)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (72, N'Dung tích', 1);
-- 73 Body Milk (Yves Rocher)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (73, N'Dung tích', 1);
-- 74 UreaRepair Lotion (Eucerin)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (74, N'Dung tích', 1);

---------------------------------------------------------
-- 💇 INSERT OPTION NHÓM 10: HAIR CARE (Sản phẩm 75 - 80)
---------------------------------------------------------
-- 75 Elseve Shampoo
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (75, N'Dung tích', 1);
-- 76 Nourishing Oil Shampoo
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (76, N'Dung tích', 1);
-- 77 Hair Fall Control Shampoo
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (77, N'Dung tích', 1);
-- 78 Tsubaki Shampoo
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (78, N'Dung tích', 1);
-- 79 Repair Conditioner
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (79, N'Dung tích', 1);
-- 80 Milk & Honey Shampoo
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder])  VALUES (80, N'Dung tích', 1);

GO
----Xóa cột insert nhầm
--DELETE FROM ProductOption
--WHERE Id BETWEEN 81 AND 148;
----Đặt lại INDENTITY
--DBCC CHECKIDENT ('ProductOption', RESEED, 80);
GO

---------------------------------------------------------
-- 💎 INSERT OPTION NHÓM 11: FRAGRANCE - NƯỚC HOA CAO CẤP 81-86 (Dòng 81 - 92)
-- (Làm kỹ: Mỗi sản phẩm có 2 Option để khách chọn combo)
---------------------------------------------------------
-- Chanel No.5
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (81, N'Nồng độ', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (81, N'Dung tích', 2);

-- Idôle
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (82, N'Mùi hương', 1); 
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (82, N'Dung tích', 2);

-- La Vie Est Belle
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (83, N'Mùi hương', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (83, N'Dung tích', 2);

-- Trésor Eau de Parfum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (84, N'Mùi hương', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (84, N'Dung tích', 2);

-- Far Away Perfume
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (85, N'Mùi hương', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (85, N'Dung tích', 2);

-- Love Potion
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (86, N'Mùi hương', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (86, N'Dung tích', 2);

---------------------------------------------------------
-- 🌿 NHÓM 12 & 13: NATURAL & DERMO 88-100 (Dòng 93 - 107)
---------------------------------------------------------
-- 87 Cicaplast Baume B5 (chỉ có size)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (87, N'Dung tích', 1);
-- 88 Mineral 89
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (88, N'Dung tích', 1);
-- 89 Aquaphor
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (89, N'Dung tích', 1);
-- 90 Clear Face Gel (da mụn → có thể phân loại)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (90, N'Dung tích', 1);
-- 91 Moisturizing Cream
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (91, N'Dung tích', 1);
-- 92 Toleriane Cream (da nhạy cảm → có thể có loại)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (92, N'Dung tích', 1);
-- 93 DermatoClean Toner
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (93, N'Dung tích', 1);
-- 94 Tea Tree Serum (có thể có variant)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (94, N'Dung tích', 1);
-- 95 Green Tea Seed Serum
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (95, N'Dung tích', 1);
-- 96 Aloe Gel (có nhiều size thật)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (96, N'Dung tích', 1);
-- 97 Shea Butter Cream
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (97, N'Dung tích', 1);
-- 98 Calendula Toner
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (98, N'Dung tích', 1);
-- 99 Rose Hibiscus Mist
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (99, N'Dung tích', 1);
-- 100 Coconut Body Milk (có thể có mùi → giữ 2 option)
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (100, N'Dung tích', 1);
INSERT INTO [dbo].[ProductOption] ([ProductId], [Name], [SortOrder]) VALUES (100, N'Mùi hương', 2);

GO

--Insert ProductOptionValue
INSERT INTO [dbo].[ProductOptionValue] ([ProductOptionId], [Name], [SortOrder]) VALUES
--Nhóm 1 - Cleanser
(1,N'75ml',1),(1,N'150ml',2),(1,N'250ml',3),
(2,N'125ml',1),(2,N'230ml',2),(2,N'500ml',3),
(3,N'100ml',1),(3,N'236ml',2),(3,N'473ml',3),
(4,N'100ml',1),(4,N'236ml',2),(4,N'473ml',3),
(5,N'50ml',1),(5,N'200ml',2),(5,N'400ml',3),
(6,N'100ml',1),(6,N'180ml',2),(6,N'300ml',3),
(7,N'120g',1),(7,N'150g',2),
(8,N'100ml',1),(8,N'150ml',2),
(9,N'100ml',1),(9,N'250ml',2),
(10,N'100ml',1),(10,N'200ml',2),


--NHÓM 2: SKINCARE (11 - 20)
(11,N'7ml',1),(11,N'30ml',2),(11,N'50ml',3),
(12,N'15ml',1),(12,N'50ml',2),(12,N'75ml',3),
(13,N'30ml',1),(13,N'50ml',2),
(14,N'30ml',1),(14,N'50ml',2),
(15,N'30ml',1),(15,N'50ml',2),(15,N'75ml',3),
(16,N'50g',1),(16,N'100g',2),
(17,N'100ml',1),(17,N'300ml',2),
(18,N'50ml',1),
(19,N'50ml',1),
(20,N'50g',1),

--Nhóm 3- TREATMENT (21 - 30)
(21,N'40ml',1),
(22,N'30ml',1),
(23,N'30ml',1),
(24,N'30ml',1),
(25,N'30ml',1),
(26,N'30ml',1),
(27,N'30ml',1),
(28,N'10ml',1),(28,N'20ml',2),
(29,N'50ml',1),
(30,N'30ml',1),

--NHÓM 4: SUNSCREEN (31 - 38)
(31,N'50ml',1),
(32,N'Da dầu',1),(32,N'Da khô',2),
(33,N'50ml',1),
(34,N'50ml',1),
(35,N'60ml',1),
(36,N'Không màu',1),(36,N'Có màu',2),
(37,N'60ml',1),
(38,N'50ml',1),

--NHÓM 5: BASE MAKEUP (39 - 46)
-- Fit me
(39,N'112 Natural Ivory',1),(39,N'115 Ivory',2),(39,N'220 Natural Beige',3),
-- Estee Lauder (OptionId 40)
(40,N'1W1 Bone',1),(40,N'1C1 Shell',2),(40,N'2N1 Desert Beige',3),
(41,N'01 Beige Albatre (sáng)',1),(41,N'010 Beige Porcelaine (sáng tự nhiên)',2),(41,N'02 Lys Rose (trắng hồng)',2),
(42,N'NC20',1),(42,N'NC30',2),
(43,N'N1 (Nude Ivory)',1),(43,N'G1 (Gold Ivory)',2),(43,N'G4 (Gold Beige)',3),
(44,N'150 Buff',1),(44,N'180 Sand',2),
(45,N'01 Alabaster',1),(45,N'04 Light Ivory',2),
(46,N'Mont Blanc (Light 2)',1),(46,N'Punjab (Medium 1)',2),

-- NHÓM 6: EYE MAKEUP (47 - 54)
(47,N'Thường',1),(47,N'Waterproof',2),
(48,N'Black',1),(48,N'Brown',2),
(49,N'Black',1),
(50,N'Black',1),
(51,N'Overtake',1),(51,N'Smoother',2),
(52,N'Naked 1',1),(52,N'Naked Heat',2),
(53,N'Black',1),
(54,N'Mini',1),(54,N'Full Size',2),

--NHÓM 7: LIP & CHEEK (55 - 62)
(55,N'#106 Dominant',1),(55,N'#176 Escapade',2),
(56,N'Ruby Woo',1),(56,N'Chili',2),
(57,N'315 Extraordinary (Hồng đất)',1),(57,N'117 Groundbreaker (Đỏ gạch)',2),
(58,N'Dragon Girl(Đỏ hồng)',1), (58,N'Dolce Vita (Hồng đất)',2),
(59,N'Fu$$y(dusty pink)',1),(59,N'Glass Slipper(không nhũ)',2),
(60,N'[777] Orgasm',1),(60,N'[888] Dolce Vita',2),(60,N'[252] Torrid',3),
(61,N'Daffodil',1),(61,N'Taupe',2),(61,N'Cashmere Nude',3),
(62,N'Stockholm (trà sữa)',1),(62,N'Cairo (nude nhạt)',2),(62,N'Milan (hồng fuchsia)',3),

--NHÓM 8: CONTOUR (63 - 68)
(63,N'Amber',1),(63,N'Mocha',2),
(64,N'Soft Glow',1),(64,N'Golden',2),
(65,N'Light',1),(65,N'Dark',2),
(66,N'Pearl',1),
(67,N'Light',1),(67,N'Medium',2),
(68,N'Light-Medium',1),(68,N'Medium-Deep',2),

-- NHÓM 9-10: BODY & HAIR (69 - 80)
(69,N'250ml',1),(69,N'400ml',2),
(70,N'250ml',1),(70,N'500ml',2),
(71,N'200g',1),
(72,N'250ml',1),
(73,N'200ml',1),(73,N'400ml',2),
(74,N'250ml',1),
(75,N'400ml',1),
(76,N'380ml',1),
(77,N'400ml',1),
(78,N'450ml',1),
(79,N'300ml',1),
(80,N'400ml',1),

--NHÓM 11: FRAGRANCE (81 - 86)
--Chanel no 5
(81, N'Parfum',1), (81, N'Eau de Parfum',2),(81, N'Eau de Toilette',3),
(82, N'50ml', 1),(82, N'100ml', 2),
--Idôle
(83, N'Le Parfum', 1),(83, N'L''Intense', 2),(83, N'Aura', 3),(83, N'Nectar', 4),(83, N'Now', 5),
(84, N'50ml', 1),(84, N'75ml', 2),
-- La Vie Est Belle
(85, N'En Rose', 1),(85, N'Intensément', 2),(85, N'Soleil Cristal', 3),(85, N'Iris Absolu', 4),
(86, N'30ml', 1),(86, N'50ml', 2),
-- Trésor
(87, N'EDP', 1),(87, N'La Nuit Trésor', 2),(87, N'In Love', 3),(87, N'Midnight Rose', 4),
(88, N'50ml', 1),(88, N'100ml', 2),
-- Far Away
(89, N'Original', 1),(89, N'Gold', 2),(89, N'Rebel', 3),(89, N'Infinity', 4),
(90, N'30ml', 1), (90, N'50ml', 2),
--Love Potion
(91, N'Đỏ', 1),(91, N'Secrets (Trắng)', 2),(91, N'Blossom Kiss (Hồng)', 3),
(92, N'50ml', 1),

--NHÓM 12-13: NATURAL & DERMO (93 - 107)
(93,N'40ml',1),
(94,N'50ml',1),
(95,N'50ml',1),
(96,N'50ml',1),
(97,N'50ml',1),
(98,N'40ml',1),
(99,N'200ml',1),

(100,N'30ml',1),
(101,N'50ml',1),
(102,N'300ml',1),
(103,N'200ml',1),
(104,N'250ml',1),
(105,N'120ml',1),
(106,N'400ml',1),
(107,N'Dừa',1),(107,N'Hoa',2);

GO


--INSERT ProductVariant
INSERT INTO [dbo].[ProductVariant] ([ProductId],[SKU],[Name],[Price],[StockQuantity],[IsDefault])
VALUES
--NHÓM 1- Cleanser
(1,N'KIEHL-UFC-75ML',N'Ultra Facial Cleanser 75ml',350000,50,0),
(1,N'KIEHL-UFC-150ML',N'Ultra Facial Cleanser 150ml',450000,100,1),
(1,N'KIEHL-UFC-250ML',N'Ultra Facial Cleanser 250ml',650000,40,0),
(2,N'KIEHL-CAL-125ML',N'Calendula Cleanser 125ml',420000,40,0),
(2,N'KIEHL-CAL-230ML',N'Calendula Cleanser 230ml',520000,80,1),
(2,N'KIEHL-CAL-500ML',N'Calendula Cleanser 500ml',900000,30,0),
(3,N'CERAVE-FOAM-100ML',N'Foaming Cleanser 100ml',220000,60,0),
(3,N'CERAVE-FOAM-236ML',N'Foaming Cleanser 236ml',300000,120,1),
(3,N'CERAVE-FOAM-473ML',N'Foaming Cleanser 473ml',450000,50,0),
(4,N'CERAVE-HYD-100ML',N'Hydrating Cleanser 100ml',230000,60,0),
(4,N'CERAVE-HYD-236ML',N'Hydrating Cleanser 236ml',310000,120,1),
(4,N'CERAVE-HYD-473ML',N'Hydrating Cleanser 473ml',470000,50,0),
(5,N'LRP-EFF-50ML',N'Effaclar Gel 50ml',220000,60,0),
(5,N'LRP-EFF-200ML',N'Effaclar Gel 200ml',400000,90,1),
(5,N'LRP-EFF-400ML',N'Effaclar Gel 400ml',650000,40,0),
(6,N'SHISEI-OIL-100ML',N'Cleansing Oil 100ml',450000,40,0),
(6,N'SHISEI-OIL-180ML',N'Cleansing Oil 180ml',600000,70,1),
(6,N'SHISEI-OIL-300ML',N'Cleansing Oil 300ml',850000,30,0),
(7,N'SHISEI-WHIP-150G',N'Perfect Whip 150g',300000,80,0),
(7,N'SHISEI-WHIP-120G',N'Perfect Whip 120g',250000,150,1),
(8,N'INNI-TEA-100ML',N'Green Tea Cleanser 100ml',150000,80,0),
(8,N'INNI-TEA-150ML',N'Green Tea Cleanser 150ml',220000,130,1),
(9,N'TBS-TREE-100ML',N'Tea Tree Wash 100ml',250000,70,0),
(9,N'TBS-TREE-250ML',N'Tea Tree Wash 250ml',350000,100,1),
(10,N'CLIN-GENTLE-100ML',N'Gentle Cleanser 100ml',350000,60,0),
(10,N'CLIN-GENTLE-200ML',N'Gentle Cleanser 200ml',550000,80,1),

-- 💧 NHÓM 2: SKINCARE
(11,N'EL-ANR-7ML',N'Advanced Night Repair 7ml',350000,40,0),
(11,N'EL-ANR-30ML',N'Advanced Night Repair 30ml',1500000,60,0),
(11,N'EL-ANR-50ML',N'Advanced Night Repair 50ml',2500000,50,1),
(12,N'CLIN-MS-15ML',N'Moisture Surge 15ml',250000,50,0),
(12,N'CLIN-MS-50ML',N'Moisture Surge 50ml',900000,60,1),
(12,N'CLIN-MS-75ML',N'Moisture Surge 75ml',1200000,40,0),
(13,N'LOREAL-REV-50ML',N'Revitalift Serum 50ml',650000,60,0),
(13,N'LOREAL-REV-30ML',N'Revitalift Serum 30ml',450000,100,1),
(14,N'KIEHL-CC-30ML',N'Clearly Corrective 30ml',1200000,70,1),
(14,N'KIEHL-CC-50ML',N'Clearly Corrective 50ml',1700000,40,0),
(15,N'VICHY-M89-30ML',N'Mineral 89 30ml',450000,60,0),
(15,N'VICHY-M89-50ML',N'Mineral 89 50ml',650000,90,1),
(15,N'VICHY-M89-75ML',N'Mineral 89 75ml',900000,40,0),
(16,N'NEUTRO-HB-100G',N'Hydro Boost 100g',450000,70,0),
(16,N'NEUTRO-HB-50G',N'Hydro Boost 50g',320000,120,1),
(17,N'INNI-ALOE-100ML',N'Aloe Gel 100ml',120000,80,0),
(17,N'INNI-ALOE-300ML',N'Aloe Gel 300ml',200000,150,1),
(18,N'TBS-VITE-50ML',N'Vitamin E Cream 50ml',380000,110,1),
(19,N'SHISEI-WL-50ML',N'White Lucent 50ml',1800000,40,1),
(20,N'OLAY-TE-50G',N'Total Effects 50g',400000,100,1),

-- 🧪 NHÓM 3: TREATMENT
(21,N'LRP-DUO-40ML',N'Effaclar Duo+ 40ml',450000,90,1),
(22,N'LRP-RETINOL-30ML',N'Retinol B3 Serum 30ml',650000,80,1),
(23,N'VICHY-NORM-30ML',N'Normaderm Serum 30ml',500000,90,1),
(24,N'EUCERIN-ANTI-30ML',N'Anti Pigment 30ml',700000,70,1),
(25,N'CLIN-ACNE-30ML',N'Acne Solution 30ml',600000,80,1),
(26,N'KIEHL-DARK-30ML',N'Dark Spot 30ml',1200000,60,1),
(27,N'NEUTRO-WRINKLE-30ML',N'Rapid Wrinkle 30ml',550000,100,1),
(28,N'TBS-TTO-10ML',N'Tea Tree Oil 10ml',180000,150,1),
(28,N'TBS-TTO-20ML',N'Tea Tree Oil 20ml',300000,80,0),
(29,N'SEBA-GEL-50ML',N'Clear Face Gel 50ml',250000,120,1),
(30,N'LOREAL-GLY-30ML',N'Glycolic Serum 30ml',420000,110,1),

-- ☀️ NHÓM 4: SUNSCREEN
(31,N'LRP-SPF-50ML',N'Anthelios SPF50 50ml',450000,100,1),
(32,N'VICHY-SPF-OIL',N'Capital Soleil (Da dầu)',420000,50,1),
(32,N'VICHY-SPF-DRY',N'Capital Soleil (Da khô)',420000,40,0),
(33,N'NEUTRO-SPF-50ML',N'Ultra Sheer 50ml',380000,120,1),
(34,N'SHISEI-SPF-50ML',N'UV Protector 50ml',750000,70,1),
(35,N'SHISEI-MILK-60ML',N'Perfect UV Milk 60ml',780000,60,1),
(36,N'EUCERIN-SPF-COLOR',N'Sun Fluid (Có màu)',520000,40,0),
(36,N'EUCERIN-SPF-NORMAL',N'Sun Fluid (Không màu)',520000,80,1),
(37,N'KIEHL-SPF-60ML',N'UV Defense 60ml',900000,60,1),
(38,N'LOREAL-SPF-50ML',N'UV Perfect 50ml',350000,130,1),

-- 🎨 NHÓM 5: FOUNDATION
-- 39. Maybelline Fit Me (Khớp 3 màu)
(39,N'MAYBEL-FIT-112',N'Fit Me 112 Natural Ivory',250000,80,1),
(39,N'MAYBEL-FIT-115',N'Fit Me 115 Ivory',250000,50,0),
(39,N'MAYBEL-FIT-220',N'Fit Me 220 Natural Beige',250000,70,0),
-- 40. Estee Lauder Double Wear (Khớp 3 màu)
(40,N'EL-DW-1W1',N'Double Wear 1W1 Bone',1500000,30,0),
(40,N'EL-DW-1C1',N'Double Wear 1C1 Shell',1500000,30,0),
(40,N'EL-DW-2N1',N'Double Wear 2N1 Desert Beige',1500000,40,1),
-- 41. Lancôme Teint Idole (Khớp 3 màu)
(41,N'LANCOME-TI-01',N'Teint Idole 01 Beige Albatre',1400000,20,0),
(41,N'LANCOME-TI-010',N'Teint Idole 010 Beige Porcelaine',1400000,25,0),
(41,N'LANCOME-TI-02',N'Teint Idole 02 Lys Rose',1400000,40,1),
-- 42. MAC Studio Fix (Khớp 2 màu)
(42,N'MAC-SF-NC20',N'Studio Fix NC20',1100000,50,1),
(42,N'MAC-SF-NC30',N'Studio Fix NC30',1100000,40,0),
-- 43. L'Oreal True Match (Khớp 3 màu)
(43,N'LOREAL-TM-N1',N'True Match N1 Nude Ivory',300000,50,1),
(43,N'LOREAL-TM-G1',N'True Match G1 Gold Ivory',300000,40,0),
(43,N'LOREAL-TM-G4',N'True Match G4 Gold Beige',300000,30,0),
-- 44. Revlon ColorStay (Khớp 2 màu)
(44,N'REVLON-CS-150',N'ColorStay 150 Buff',280000,70,1),
(44,N'REVLON-CS-180',N'ColorStay 180 Sand',280000,50,0),
-- 45. NYX Total Control (Khớp 2 màu)
(45,N'NYX-TCD-01',N'Total Control 01 Alabaster',350000,40,0),
(45,N'NYX-TCD-04',N'Total Control 04 Light Ivory',350000,60,1),
-- 46. NARS Natural Radiant (Khớp 2 màu)
(46,N'NARS-NR-MONT',N'Natural Radiant Mont Blanc',1200000,30,0),
(46,N'NARS-NR-PUNJ',N'Natural Radiant Punjab',1200000,50,1),

-- 👁️ NHÓM 6: EYE MAKEUP
(47,N'LANCOME-HYPNOSE-NORMAL',N'Hypnôse Mascara Thường',800000,60,1),
(47,N'LANCOME-HYPNOSE-WP',N'Hypnôse Mascara Waterproof',820000,30,0),
(48,N'MAYBEL-GREAT-BLACK',N'Great Lash Black',180000,120,1),
(48,N'MAYBEL-GREAT-BROWN',N'Great Lash Brown',180000,80,0),
(49,N'CLINIQUE-LASH-BLACK',N'Lash Power Black',650000,100,1),
(50,N'MAC-EXTREME-BLACK',N'In Extreme Dimension Black',850000,80,1),
(51,N'3CE-MOOD-OVERTAKE',N'Mood Recipe Overtake',600000,70,1),
(51,N'3CE-MOOD-SMOOTHER',N'Mood Recipe Smoother',600000,50,0),
(52,N'UD-NAKED-1',N'Naked Palette 1',1300000,40,0),
(52,N'UD-NAKED-HEAT',N'Naked Heat',1300000,50,1),
(53,N'NARS-CLIMAX-BLACK',N'Climax Mascara Black',750000,90,1),
(54,N'FENTY-MINI',N'Full Frontal Mini',350000,60,0),
(54,N'FENTY-FULL',N'Full Frontal Full Size',700000,80,1),

-- 💋 NHÓM 7: CHEEK & LIP
-- 55. Chanel Rouge Coco (Khớp 2 màu)
(55,N'CHANEL-COCO-106',N'Rouge Coco #106 Dominant',1100000,50,1),
(55,N'CHANEL-COCO-176',N'Rouge Coco #176 Escapade',1100000,30,0),
-- 56. MAC Lipstick (Khớp 2 màu)
(56,N'MAC-RUBY-WOO',N'MAC Ruby Woo',550000,120,1),
(56,N'MAC-CHILI',N'MAC Chili',550000,100,0),
-- 57. Maybelline SuperStay (Khớp 2 màu mới)
(57,N'MAYBEL-SUPER-315',N'SuperStay 315 Extraordinary',220000,80,1),
(57,N'MAYBEL-SUPER-117',N'SuperStay 117 Groundbreaker',220000,70,0),
-- 58. NARS Velvet Lip (Khớp 2 màu)
(58,N'NARS-VELVET-DRAGON',N'Velvet Lip Dragon Girl',650000,60,1),
(58,N'NARS-VELVET-DOLCE',N'Velvet Lip Dolce Vita',650000,40,0),
-- 59. Fenty Gloss Bomb (Khớp 2 màu)
(59,N'FENTY-GLOSS-FUSSY',N'Gloss Bomb Fu$$y',500000,90,1),
(59,N'FENTY-GLOSS-GLASS',N'Gloss Bomb Glass Slipper',500000,50,0),
-- 60. NARS Blush (Khớp 3 mã màu)
(60,N'NARS-BLUSH-777',N'Blush Orgasm [777]',700000,80,1),
(60,N'NARS-BLUSH-888',N'Blush Dolce Vita [888]',700000,40,0),
(60,N'NARS-BLUSH-252',N'Blush Torrid [252]',700000,30,0),
-- 61. 3CE Tint (Khớp 3 màu)
(61,N'3CE-TINT-DAFFODIL',N'3CE Tint Daffodil',300000,120,1),
(61,N'3CE-TINT-TAUPE',N'3CE Tint Taupe',300000,60,0),
(61,N'3CE-TINT-CASHMERE',N'3CE Tint Cashmere Nude',300000,40,0),
-- 62. NYX Soft Matte (Khớp 3 màu)
(62,N'NYX-SMLC-STOCK',N'Soft Matte Stockholm',250000,140,1),
(62,N'NYX-SMLC-CAIRO',N'Soft Matte Cairo',250000,60,0),
(62,N'NYX-SMLC-MILAN',N'Soft Matte Milan',250000,50,0),

-- 🧱 NHÓM 8: CONTOUR & HIGHLIGHT
-- 63. Fenty Match Stix (Khớp màu Amber, Mocha)
(63,N'FENTY-AMBER',N'Match Stix Amber',650000,70,1),
(63,N'FENTY-MOCHA',N'Match Stix Mocha',650000,50,0),
-- 64. MAC Skinfinish (Khớp màu Soft Glow, Golden)
(64,N'MAC-SOFT-GENTLE',N'Skinfinish Soft & Gentle',900000,60,1),
(64,N'MAC-GOLDEN',N'Skinfinish Golden',900000,40,0),
-- 65. NYX Born To Glow (Khớp màu Light, Dark)
(65,N'NYX-GLOW-LIGHT',N'Born To Glow Light',320000,90,1),
(65,N'NYX-GLOW-DARK',N'Born To Glow Dark',320000,50,0),
-- 66. NARS Illuminator (Chỉ có màu Pearl)
(66,N'NARS-ILLUM-PEARL',N'Illuminator Pearl',800000,50,1),
-- 67. Estee Lauder Bronze (Khớp màu Light, Medium)
(67,N'EL-BRONZE-LIGHT',N'Bronze Goddess Light',1200000,40,1),
(67,N'EL-BRONZE-MEDIUM',N'Bronze Goddess Medium',1200000,30,0),
-- 68. Maybelline Master Contour (Khớp Light-Medium, Medium-Deep)
(68,N'MAYBEL-CONTOUR-LM',N'Master Contour Light-Medium',280000,100,1),
(68,N'MAYBEL-CONTOUR-MD',N'Master Contour Medium-Deep',280000,60,0),

-- 🧴 NHÓM 9: BODY CARE
(69,N'NIVEA-LOTION-250ML',N'Body Lotion 250ml',120000,100,0),
(69,N'NIVEA-LOTION-400ML',N'Body Lotion 400ml',180000,200,1),
(70,N'DOVE-WASH-250ML',N'Body Wash 250ml',90000,120,0),
(70,N'DOVE-WASH-500ML',N'Body Wash 500ml',160000,220,1),
(71,N'TBS-BUTTER-200G',N'Body Butter 200g',450000,120,1),
(72,N'KIEHL-BODY-250ML',N'Creme de Corps 250ml',950000,90,1),
(73,N'YR-MILK-200ML',N'Body Milk 200ml',200000,100,0),
(73,N'YR-MILK-400ML',N'Body Milk 400ml',300000,150,1),
(74,N'EUCERIN-UREA-250ML',N'UreaRepair 250ml',420000,110,1),

-- 💇 NHÓM 10: HAIR CARE
(75,N'LOREAL-SHAM-400ML',N'Elseve Shampoo 400ml',180000,200,1),
(76,N'DOVE-OIL-380ML',N'Nourishing Oil Shampoo 380ml',160000,210,1),
(77,N'NIVEA-FALL-400ML',N'Hair Fall Shampoo 400ml',170000,190,1),
(78,N'TSUBAKI-450ML',N'Tsubaki Shampoo 450ml',320000,150,1),
(79,N'AVON-COND-300ML',N'Repair Conditioner 300ml',150000,180,1),
(80,N'ORIFLAME-HONEY-400ML',N'Milk & Honey Shampoo 400ml',140000,170,1),

-- 🌸 NHÓM 11: FRAGRANCE
-- 81. Chanel no 5
(81, N'CH-N5-PAR-50', N'Chanel No.5 Parfum 50ml', 4500000, 20, 0),
(81, N'CH-N5-PAR-100', N'Chanel No.5 Parfum 100ml', 6200000, 15, 0),
(81, N'CH-N5-EDP-50', N'Chanel No.5 Eau de Parfum 50ml', 3200000, 40, 0),
(81, N'CH-N5-EDP-100', N'Chanel No.5 Eau de Parfum 100ml', 4200000, 50, 1),
(81, N'CH-N5-EDT-50', N'Chanel No.5 Eau de Toilette 50ml', 2800000, 30, 0),
(81, N'CH-N5-EDT-100', N'Chanel No.5 Eau de Toilette 100ml', 3700000, 25, 0),
-- 82. Idôle (Sửa ProductId từ 82 thành 82 như cũ nhưng bà lưu ý Option của nó là 83-84)
(82, N'LANC-ID-LP-50', N'Idôle Le Parfum 50ml', 2200000, 30, 0),
(82, N'LANC-ID-LP-75', N'Idôle Le Parfum 75ml', 2900000, 20, 1),
(82, N'LANC-ID-INT-50', N'Idôle L''Intense 50ml', 2400000, 15, 0),
(82, N'LANC-ID-INT-75', N'Idôle L''Intense 75ml', 3100000, 10, 0),
(82, N'LANC-ID-AURA-50', N'Idôle Aura 50ml', 2100000, 20, 0),
(82, N'LANC-ID-AURA-75', N'Idôle Aura 75ml', 2800000, 12, 0),
(82, N'LANC-ID-NEC-50', N'Idôle Nectar 50ml', 2300000, 18, 0),
(82, N'LANC-ID-NEC-75', N'Idôle Nectar 75ml', 3000000, 14, 0),
(82, N'LANC-ID-NOW-50', N'Idôle Now 50ml', 2250000, 20, 0),
(82, N'LANC-ID-NOW-75', N'Idôle Now 75ml', 2950000, 10, 0),
-- 83. La Vie Est Belle
(83, N'LANC-LVEB-ER-30', N'La Vie Est Belle En Rose 30ml', 1800000, 25, 0),
(83, N'LANC-LVEB-ER-50', N'La Vie Est Belle En Rose 50ml', 2500000, 15, 0),
(83, N'LANC-LVEB-INT-30', N'La Vie Est Belle Intensément 30ml', 1950000, 20, 0),
(83, N'LANC-LVEB-INT-50', N'La Vie Est Belle Intensément 50ml', 2700000, 10, 0),
(83, N'LANC-LVEB-SC-30', N'La Vie Est Belle Soleil Cristal 30ml', 1900000, 15, 0),
(83, N'LANC-LVEB-SC-50', N'La Vie Est Belle Soleil Cristal 50ml', 2650000, 10, 0),
(83, N'LANC-LVEB-IA-30', N'La Vie Est Belle Iris Absolu 30ml', 2100000, 12, 0),
(83, N'LANC-LVEB-IA-50', N'La Vie Est Belle Iris Absolu 50ml', 2850000, 10, 1),
-- 84. Trésor
(84, N'LANC-TR-EDP-50', N'Trésor EDP 50ml', 2300000, 20, 0),
(84, N'LANC-TR-EDP-100', N'Trésor EDP 100ml', 3200000, 15, 1),
(84, N'LANC-TR-LN-50', N'Trésor La Nuit 50ml', 2500000, 15, 0),
(84, N'LANC-TR-LN-100', N'Trésor La Nuit 100ml', 3400000, 10, 0),
(84, N'LANC-TR-IL-50', N'Trésor In Love 50ml', 2100000, 18, 0),
(84, N'LANC-TR-IL-100', N'Trésor In Love 100ml', 2900000, 12, 0),
(84, N'LANC-TR-MR-50', N'Trésor Midnight Rose 50ml', 2250000, 10, 0),
(84, N'LANC-TR-MR-100', N'Trésor Midnight Rose 100ml', 3100000, 8, 0),
-- 85. Far Away
(85, N'AVON-FA-ORI-30', N'Far Away Original 30ml', 450000, 50, 0),
(85, N'AVON-FA-ORI-50', N'Far Away Original 50ml', 650000, 40, 1),
(85, N'AVON-FA-GLD-30', N'Far Away Gold 30ml', 480000, 30, 0),
(85, N'AVON-FA-GLD-50', N'Far Away Gold 50ml', 680000, 25, 0),
(85, N'AVON-FA-REB-30', N'Far Away Rebel 30ml', 500000, 20, 0),
(85, N'AVON-FA-REB-50', N'Far Away Rebel 50ml', 700000, 20, 0),
(85, N'AVON-FA-INF-30', N'Far Away Infinity 30ml', 480000, 15, 0),
(85, N'AVON-FA-INF-50', N'Far Away Infinity 50ml', 680000, 10, 0),
-- 86. Love Potion
(86, N'ORI-LP-RED-50', N'Love Potion Đỏ 50ml', 750000, 40, 1),
(86, N'ORI-LP-WHT-50', N'Love Potion Secrets (Trắng) 50ml', 750000, 30, 0),
(86, N'ORI-LP-PNK-50', N'Love Potion Blossom Kiss (Hồng) 50ml', 750000, 20, 0),

-- 🧪🌿 NHÓM 12: DERMO
(87, N'LRP-B5-40ML', N'La Roche-Posay Cicaplast Baume B5 40ml', 420000, 120, 1),
(88, N'VICHY-M89-50ML-2', N'Vichy Mineral 89 50ml', 650000, 110, 1),
(89, N'EUC-AQUA-50ML', N'Eucerin Aquaphor 50ml', 350000, 130, 1),
(90, N'SEBA-CFG-50ML', N'Sebamed Clear Face Gel 50ml', 280000, 140, 1),
(91, N'CERA-MC-50ML', N'CeraVe Moisturizing Cream 50ml', 300000, 150, 1),
(92, N'LRP-TOL-40ML', N'La Roche-Posay Toleriane Cream 40ml', 450000, 120, 1),
(93, N'EUC-DCT-200ML', N'Eucerin DermatoClean Toner 200ml', 320000, 130, 1),

-- 🌿 NHÓM 13: NATURAL & ORGANIC (ProductId 94 - 100)
(94, N'TBS-TTS-30ML', N'The Body Shop Tea Tree Serum 30ml', 450000, 120, 1),
(95, N'INN-GTSS-50ML', N'Innisfree Green Tea Seed Serum 50ml', 500000, 130, 1),
(96, N'INN-ALOE-300ML', N'Innisfree Aloe Gel 300ml', 200000, 150, 1),
(97, N'YVES-SBC-200ML', N'Yves Rocher Shea Butter Cream 200ml', 350000, 140, 1),
(98, N'KIEHL-CAL-250ML', N'Kiehl''s Calendula Toner 250ml', 650000, 110, 1),
(99, N'HERB-RHM-120ML', N'Herbivore Rose Hibiscus Mist 120ml', 750000, 90, 1),
(100, N'YVES-CBM-400-DUA', N'Yves Rocher Coconut Body Milk - Dừa 400ml', 280000, 80, 1),
(100, N'YVES-CBM-400-HOA', N'Yves Rocher Coconut Body Milk - Hoa 400ml', 280000, 80, 0);

GO

--Insert [ProductVariantOptionValue]
INSERT INTO [dbo].[ProductVariantOptionValue] ([ProductVariantId], [ProductOptionValueId])
SELECT v.Id, ov.Id
FROM [dbo].[Product] p
JOIN [dbo].[ProductVariant] v ON p.Id = v.ProductId
JOIN [dbo].[ProductOption] po ON p.Id = po.ProductId
JOIN [dbo].[ProductOptionValue] ov ON po.Id = ov.ProductOptionId
WHERE 
    (v.Name LIKE N'%' + ov.Name + N'%' OR v.SKU LIKE N'%' + ov.Name + N'%')
    -- Tránh insert trùng nếu bà đã lỡ chạy lệnh nào đó trước đây
    AND NOT EXISTS (
        SELECT 1 FROM [dbo].[ProductVariantOptionValue] target
        WHERE target.ProductVariantId = v.Id AND target.ProductOptionValueId = ov.Id
    );

GO

--Insert OrderDetail
-- Dùng CTE để tạo danh sách món ăn ngẫu nhiên cho từng đơn
WITH RandomProducts AS (
    SELECT 
        o.Id AS OrderId,
        v.ProductId,
        v.Id AS ProductVariantId,
        v.Price AS UnitPrice,
        v.SKU,
        v.Name AS VariantName,
        p.ProductName AS ProductName,
        -- Tạo số thứ tự ngẫu nhiên cho từng sản phẩm trong mỗi đơn hàng
        ROW_NUMBER() OVER (PARTITION BY o.Id ORDER BY NEWID()) AS RowNum
    FROM [dbo].[Order] o
    CROSS JOIN [dbo].[ProductVariant] v
    JOIN [dbo].[Product] p ON v.ProductId = p.Id
    WHERE o.Id <= 22
)

INSERT INTO [dbo].[OrderDetail] 
([OrderId], [ProductId], [ProductVariantId], [UnitPrice], [Quantity], [ProductName], [SKU], [VariantInfo], [LineTotal], [Status])
SELECT 
    OrderId,
    ProductId,
    ProductVariantId,
    UnitPrice,
    (ABS(CHECKSUM(NEWID())) %3) + 1, -- Ngẫu nhiên mua từ 1 đến 3 cái mỗi món
    ProductName,
    SKU,
    VariantName,
    UnitPrice * ((ABS(CHECKSUM(NEWID())) % 3) + 1), -- Tính luôn LineTotal
    1
FROM RandomProducts
WHERE RowNum <= (ABS(CHECKSUM(NEWID())) % 7 + 1);; -- Mỗi đơn bốc ngẫu nhiên từ 1 - 7 món khác nhau

GO

--INSERT Inventory
INSERT INTO [dbo].[Inventory] 
    ([VariantId], [Quantity], [WarehouseId], [Notes], [Status], [CreatedBy])
SELECT 
    pv.Id AS VariantId, 
    (ABS(CHECKSUM(NEWID())) % 71) + 50 AS Quantity, -- Tồn kho từ 50-100 cái
    1 AS WarehouseId, 
    N'Nhập kho đầu kỳ - Chứng từ duyệt bởi kho' AS Notes,
    1 AS Status,
    -- CHỖ NÀY LÀ CHIÊU CHỌN NGẪU NHIÊN 1 TRONG 2:
    (SELECT UserId FROM [dbo].[Employee] 
     WHERE Id = CHOOSE((ABS(CHECKSUM(NEWID())) % 2) + 1, 1, 7)) 
FROM [dbo].[ProductVariant] pv
WHERE NOT EXISTS (
    SELECT 1 FROM [dbo].[Inventory] i WHERE i.VariantId = pv.Id
);

GO

--INSERT Payment
INSERT INTO [dbo].[Payment] 
    ([OrderId], [Amount], [Method], [Notes], [Status], [CreatedBy])
SELECT 
    o.Id AS OrderId,
    -- Tổng tiền = Tiền hàng + Phí ship
    (ISNULL(SumTable.TotalGoods, 0) + ISNULL(o.Freight, 0)) AS Amount,
    -- Random phương thức thanh toán
    CASE 
        WHEN o.Id % 3 = 0 THEN N'Momo'
        WHEN o.Id % 3 = 1 THEN N'Chuyển khoản'
        ELSE N'Tiền mặt'
    END AS Method,
    N'Hệ thống xác nhận thanh toán đơn #' + CAST(o.Id AS NVARCHAR) AS Notes,
    1 AS Status,
    -- Bốc ngẫu nhiên 1 người trong danh sách {1,2,3,4,5,6,7,9}
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 
        CHOOSE((o.Id % 8) + 1, 1, 2, 3, 4, 5, 6, 7, 9)
    ) AS CreatedBy
FROM [dbo].[Order] o
LEFT JOIN (
    SELECT OrderId, SUM(LineTotal) AS TotalGoods 
    FROM [dbo].[OrderDetail] 
    GROUP BY OrderId
) AS SumTable ON o.Id = SumTable.OrderId
WHERE o.Id <= 22 
  AND NOT EXISTS (SELECT 1 FROM [dbo].[Payment] p WHERE p.OrderId = o.Id);

GO

--INSERT Shipper
INSERT INTO [dbo].[Shipper] 
    ([CompanyName], [Phone], [Notes], [Status], [CreatedBy])
VALUES 
(
    N'Giao Hàng Tiết Kiệm (GHTK)', 
    '1900 6092', 
    N'Đối tác vận chuyển chính, giao nhanh nội thành', 
    1, 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1)
),
(
    N'Giao Hàng Nhanh (GHN)', 
    '1900 636677', 
    N'Chuyên giao hàng hỏa tốc', 
    1, 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1)
),
(
    N'Viettel Post', 
    '1900 8095', 
    N'Giao hàng toàn quốc, kể cả vùng sâu vùng xa', 
    1, 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1)
),
(
    N'Shopee Express', 
    '1900 1221', 
    N'Dành cho các đơn hàng đặt qua app hệ thống', 
    1, 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1)
),
(
    N'J&T Express', 
    '1900 1088', 
    N'Giao hàng giá rẻ, hỗ trợ lấy hàng tận nơi', 
    1, 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1)
);
--Insert địa chỉ các trụ sở sở Shippeer vào Address:
INSERT INTO [dbo].[Address] 
    ([AddressNo], [City], [Country], [CreatedBy], [Notes])
VALUES 
(
    N'171 Tô Hiến Thành, Quận 10', N'Hồ Chí Minh', N'Việt Nam', 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), 
    N'Trụ sở GHTK'
),
(
    N'285 Cách Mạng Tháng Tám, Quận 10', N'Hồ Chí Minh', N'Việt Nam', 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), 
    N'Trụ sở GHN'
),
(
    N'01 Giang Văn Minh, Ba Đình', N'Hà Nội', N'Việt Nam', 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), 
    N'Trụ sở Viettel Post'
),
(
    N'Saigon Centre Tower 2, Quận 1', N'Hồ Chí Minh', N'Việt Nam', 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), 
    N'Văn phòng Shopee Express'
),
(
    N'10 Mai Chí Thọ, Quận 2', N'Hồ Chí Minh', N'Việt Nam', 
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = 1), 
    N'Trụ sở J&T Express'
);
--Gán vảo bảng shipper:
-- Gán địa chỉ GHTK
UPDATE [dbo].[Shipper] 
SET [AddressId] = (SELECT TOP 1 Id FROM [dbo].[Address] WHERE Notes = N'Trụ sở GHTK')
WHERE [CompanyName] LIKE '%GHTK%';

-- Gán địa chỉ GHN
UPDATE [dbo].[Shipper] 
SET [AddressId] = (SELECT TOP 1 Id FROM [dbo].[Address] WHERE Notes = N'Trụ sở GHN')
WHERE [CompanyName] LIKE '%GHN%';

-- Gán địa chỉ Viettel Post
UPDATE [dbo].[Shipper] 
SET [AddressId] = (SELECT TOP 1 Id FROM [dbo].[Address] WHERE Notes = N'Trụ sở Viettel Post')
WHERE [CompanyName] LIKE '%Viettel%';

-- Gán địa chỉ Shopee Express
UPDATE [dbo].[Shipper] 
SET [AddressId] = (SELECT TOP 1 Id FROM [dbo].[Address] WHERE Notes = N'Văn phòng Shopee Express')
WHERE [CompanyName] LIKE '%Shopee%';

-- Gán địa chỉ J&T Express
UPDATE [dbo].[Shipper] 
SET [AddressId] = (SELECT TOP 1 Id FROM [dbo].[Address] WHERE Notes = N'Trụ sở J&T Express')
WHERE [CompanyName] LIKE '%J&T%';

--INSERT ShipInfo
INSERT INTO [dbo].[ShipInfo] 
    ([OrderId], [ShipperId], [ShipName], [ShipAddress], [ShipPhone], [ShipCity], [ShipCountry], 
     [RequiredDate], [ShippedDate], [Status], [CreatedBy], [Notes])
SELECT 
    o.Id AS OrderId,
    -- Bốc ngẫu nhiên ShipperId từ 1 đến 5
    (ABS(CHECKSUM(NEWID())) % 5) + 1 AS ShipperId,
    -- Lấy Tên người nhận từ cột Receive của bảng Order 
	ISNULL(o.[Receive], 
		CASE 
			WHEN c.CompanyName IS NOT NULL THEN c.CompanyName + N' - ' + c.ContactName 
			ELSE c.ContactName 
		END
	) AS ShipName,
    -- JOIN sang bảng Address để lấy chuỗi địa chỉ thực tế
    a.AddressNo AS ShipAddress,
    c.Phone AS ShipPhone,
    a.City AS ShipCity,
    a.Country AS ShipCountry,
    -- Ngày cần hàng: Sau ngày đặt 3 ngày | Ngày giao: Sau ngày đặt 2 ngày
    DATEADD(day, 3, o.OrderDate) AS RequiredDate,
    DATEADD(day, 2, o.OrderDate) AS ShippedDate,
    1 AS Status,
    -- Chia việc cho 8 nhân viên (Lấy UserId GUID từ bảng Employee)
    (SELECT UserId FROM [dbo].[Employee] WHERE Id = CHOOSE((o.Id % 8) + 1, 1, 2, 3, 4, 5, 6, 7, 9)) AS CreatedBy,
    N'Đơn hàng giao tiêu chuẩn' AS Notes
FROM [dbo].[Order] o
JOIN [dbo].[Customer] c ON o.CustomerId = c.Id
JOIN [dbo].[Address] a ON c.AddressId = a.Id -- Lấy địa chỉ mặc định của khách
WHERE o.Id <= 22 
  AND NOT EXISTS (SELECT 1 FROM [dbo].[ShipInfo] s WHERE s.OrderId = o.Id);

INSERT INTO [dbo].[Category] (CategoryName, Description)
VALUES 
(N'Cleanser', N'Làm sạch sâu bụi bẩn, dầu thừa và lớp trang điểm, giúp làn da thông thoáng và sẵn sàng hấp thụ dưỡng chất.'),
(N'Skincare', N'Nuôi dưỡng làn da khỏe mạnh, cấp ẩm và cải thiện độ đàn hồi, mang lại vẻ rạng rỡ tự nhiên mỗi ngày.'),
(N'Treatment', N'Giải pháp chuyên sâu giúp cải thiện các vấn đề da như mụn, thâm, nám và lão hóa một cách hiệu quả.'),
(N'Sunscreen', N'Bảo vệ da toàn diện trước tác hại của tia UV, ngăn ngừa lão hóa sớm và giữ làn da luôn tươi trẻ.'),
(N'Base Makeup', N'Tạo lớp nền mịn màng, che phủ hoàn hảo và mang lại làn da đều màu, tự nhiên suốt cả ngày.'),
(N'Eye Makeup', N'Tôn lên vẻ đẹp cuốn hút của đôi mắt với các sản phẩm giúp tạo chiều sâu và điểm nhấn nổi bật.'),
(N'Cheek & Lip', N'Mang lại sắc thái tươi tắn cho khuôn mặt với màu má và đôi môi rạng rỡ, đầy sức sống.'),
(N'Contour & Highlight', N'Định hình đường nét khuôn mặt, tạo hiệu ứng ánh sáng và chiều sâu chuyên nghiệp.'),
(N'Body Care', N'Chăm sóc làn da toàn thân mềm mịn, dưỡng ẩm và bảo vệ da luôn khỏe mạnh mỗi ngày.'),
(N'Hair Care', N'Nuôi dưỡng mái tóc chắc khỏe, suôn mượt và phục hồi hư tổn từ sâu bên trong.'),
(N'Fragrance', N'Tạo dấu ấn riêng với hương thơm quyến rũ, giúp bạn tự tin và nổi bật trong mọi khoảnh khắc.'),
(N'Dermocosmetics', N'Dòng dược mỹ phẩm an toàn, lành tính, hỗ trợ cải thiện làn da theo khuyến nghị của chuyên gia.'),
(N'Natural & Organic', N'Sản phẩm từ thiên nhiên lành tính, dịu nhẹ, mang đến giải pháp chăm sóc da an toàn và bền vững.');

GO

INSERT INTO [dbo].[Supplier] 
(CompanyName, ContactName, ContactTitle, Phone, Email, HomePage, Notes)
VALUES
(N'L''Oréal', N'Global Sales Team', N'Sales Manager', '0123456789', 'contact@loreal.com', N'https://www.loreal.com', N'Global beauty brand'),
(N'Estée Lauder', N'Customer Care', N'Sales Manager', '0123456790', 'info@esteelauder.com', N'https://www.esteelauder.com', N'Luxury skincare and makeup'),
(N'Maybelline', N'Support Team', N'Sales Manager', '0123456791', 'support@maybelline.com', N'https://www.maybelline.com', N'Drugstore makeup brand'),
(N'MAC', N'MAC Team', N'Sales Manager', '0123456792', 'info@maccosmetics.com', N'https://www.maccosmetics.com', N'Professional makeup brand'),
(N'Lancôme', N'Lancome Team', N'Sales Manager', '0123456793', 'contact@lancome.com', N'https://www.lancome.com', N'Luxury cosmetics brand'),
(N'Clinique', N'Clinique Team', N'Sales Manager', '0123456794', 'support@clinique.com', N'https://www.clinique.com', N'Dermatologist-developed brand'),
(N'Shiseido', N'Shiseido Team', N'Sales Manager', '0123456795', 'info@shiseido.com', N'https://www.shiseido.com', N'Japanese beauty brand'),
(N'Revlon', N'Revlon Team', N'Sales Manager', '0123456796', 'contact@revlon.com', N'https://www.revlon.com', N'Affordable cosmetics'),
(N'Avon', N'Avon Team', N'Sales Manager', '0123456797', 'info@avon.com', N'https://www.avon.com', N'Direct selling cosmetics'),
(N'Oriflame', N'Oriflame Team', N'Sales Manager', '0123456798', 'info@oriflame.com', N'https://www.oriflame.com', N'Swedish beauty brand'),
(N'3CE', N'3CE Team', N'Sales Manager', '0123456799', 'info@3ce.com', N'https://www.stylenanda.com', N'K-beauty makeup brand'),
(N'Urban Decay', N'UD Team', N'Sales Manager', '0123456800', 'info@urbandecay.com', N'https://www.urbandecay.com', N'Bold makeup brand'),
(N'NYX', N'NYX Team', N'Sales Manager', '0123456801', 'info@nyxcosmetics.com', N'https://www.nyxcosmetics.com', N'Affordable pro makeup'),
(N'NARS', N'NARS Team', N'Sales Manager', '0123456802', 'info@narscosmetics.com', N'https://www.narscosmetics.com', N'Luxury makeup brand'),
(N'Fenty Beauty', N'Fenty Team', N'Sales Manager', '0123456803', 'info@fentybeauty.com', N'https://www.fentybeauty.com', N'Inclusive beauty brand'),
(N'Kiehl''s', N'Kiehls Team', N'Sales Manager', '0123456804', 'info@kiehls.com', N'https://www.kiehls.com', N'Skincare specialist'),
(N'Neutrogena', N'Neutrogena Team', N'Sales Manager', '0123456805', 'info@neutrogena.com', N'https://www.neutrogena.com', N'Dermatology skincare'),
(N'Olay', N'Olay Team', N'Sales Manager', '0123456806', 'info@olay.com', N'https://www.olay.com', N'Anti-aging skincare'),
(N'La Roche-Posay', N'LRP Team', N'Sales Manager', '0123456807', 'info@larocheposay.com', N'https://www.laroche-posay.com', N'Dermocosmetics brand'),
(N'CeraVe', N'CeraVe Team', N'Sales Manager', '0123456808', 'info@cerave.com', N'https://www.cerave.com', N'Skincare with ceramides'),
(N'The Body Shop', N'TBS Team', N'Sales Manager', '0123456809', 'info@thebodyshop.com', N'https://www.thebodyshop.com', N'Natural beauty brand'),
(N'Innisfree', N'Innisfree Team', N'Sales Manager', '0123456810', 'info@innisfree.com', N'https://www.innisfree.com', N'Korean natural skincare'),
(N'Yves Rocher', N'YR Team', N'Sales Manager', '0123456811', 'info@yvesrocher.com', N'https://www.yves-rocher.com', N'Botanical beauty'),
(N'Herbivore Botanicals', N'HB Team', N'Sales Manager', '0123456812', 'info@herbivorebotanicals.com', N'https://www.herbivorebotanicals.com', N'Natural skincare'),
(N'Vichy', N'Vichy Team', N'Sales Manager', '0123456813', 'info@vichy.com', N'https://www.vichy.com', N'Mineral skincare'),
(N'Sebamed', N'Sebamed Team', N'Sales Manager', '0123456814', 'info@sebamed.com', N'https://www.sebamed.com', N'pH balanced skincare'),
(N'Eucerin', N'Eucerin Team', N'Sales Manager', '0123456815', 'info@eucerin.com', N'https://www.eucerin.com', N'Medical skincare'),
(N'Dove', N'Dove Team', N'Sales Manager', '0123456816', 'info@dove.com', N'https://www.dove.com', N'Body care brand'),
(N'NIVEA', N'Nivea Team', N'Sales Manager', '0123456817', 'info@nivea.com', N'https://www.nivea.com', N'Skincare and body care'),
(N'Chanel Beauty', N'Chanel Team', N'Sales Manager', '0123456818', 'info@chanel.com', N'https://www.chanel.com', N'Luxury beauty brand');

GO

INSERT INTO [dbo].[Product]
(ProductName, Brand, Description, QuantityPerUnit, CategoryId, SupplierId, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Notes)
VALUES

-- 🧼 1. CLEANER (CategoryId = 1) 10 SP
(N'Ultra Facial Cleanser', N'Kiehl''s', N'Sữa rửa mặt làm sạch dịu nhẹ, giúp loại bỏ bụi bẩn và dầu thừa.', N'150ml', 1, 16, 450000, 100, 10, 20, NULL),
(N'Calendula Cleanser', N'Kiehl''s', N'Sữa rửa mặt chiết xuất hoa cúc giúp làm dịu da.', N'230ml', 1, 16, 520000, 80, 10, 20, NULL),
(N'Foaming Facial Cleanser', N'CeraVe', N'Sữa rửa mặt tạo bọt giúp làm sạch sâu mà không gây khô da.', N'236ml', 1, 20, 300000, 120, 15, 25, NULL),
(N'Hydrating Cleanser', N'CeraVe', N'Sữa rửa mặt cấp ẩm dành cho da khô và nhạy cảm.', N'236ml', 1, 20, 310000, 120, 15, 25, NULL),
(N'Effaclar Gel Cleanser', N'La Roche-Posay', N'Gel rửa mặt dành cho da dầu và mụn.', N'200ml', 1, 19, 400000, 90, 10, 20, NULL),
(N'Deep Cleansing Oil', N'Shiseido', N'Dầu tẩy trang làm sạch lớp makeup cứng đầu.', N'180ml', 1, 7, 600000, 70, 10, 15, NULL),
(N'Perfect Whip Cleanser', N'Shiseido', N'Sữa rửa mặt tạo bọt mịn giúp làm sạch nhẹ nhàng.', N'120g', 1, 7, 250000, 150, 20, 30, NULL),
(N'Green Tea Foam Cleanser', N'Innisfree', N'Sữa rửa mặt chiết xuất trà xanh chống oxy hóa.', N'150ml', 1, 22, 220000, 130, 20, 30, NULL),
(N'Tea Tree Facial Wash', N'The Body Shop', N'Sữa rửa mặt tràm trà giúp giảm mụn.', N'250ml', 1, 21, 350000, 100, 10, 20, NULL),
(N'Gentle Cleanser', N'Clinique', N'Sữa rửa mặt dịu nhẹ cho mọi loại da.', N'200ml', 1, 6, 550000, 80, 10, 20, NULL),

-- 💧 2. SKINCARE (CategoryId = 2) 10 SP
(N'Advanced Night Repair', N'Estée Lauder', N'Serum phục hồi da ban đêm, chống lão hóa.', N'50ml', 2, 2, 2500000, 50, 5, 10, NULL),
(N'Moisture Surge', N'Clinique', N'Gel dưỡng ẩm cấp nước tức thì.', N'50ml', 2, 6, 900000, 60, 5, 15, NULL),
(N'Revitalift Hyaluronic Serum', N'L''Oréal', N'Serum cấp ẩm chứa Hyaluronic Acid.', N'30ml', 2, 1, 450000, 100, 10, 20, NULL),
(N'Clearly Corrective Serum', N'Kiehl''s', N'Serum làm sáng da, giảm thâm.', N'30ml', 2, 16, 1200000, 70, 5, 15, NULL),
(N'Mineral 89', N'Vichy', N'Serum khoáng giúp củng cố hàng rào da.', N'50ml', 2, 25, 650000, 90, 10, 20, NULL),
(N'Hydro Boost Gel', N'Neutrogena', N'Gel dưỡng ẩm nhẹ, thấm nhanh.', N'50g', 2, 17, 320000, 120, 10, 20, NULL),
(N'Aloe Revital Soothing Gel', N'Innisfree', N'Gel lô hội làm dịu và cấp ẩm.', N'300ml', 2, 22, 200000, 150, 20, 30, NULL),
(N'Vitamin E Cream', N'The Body Shop', N'Kem dưỡng vitamin E giúp mềm da.', N'50ml', 2, 21, 380000, 110, 10, 20, NULL),
(N'White Lucent Cream', N'Shiseido', N'Kem dưỡng sáng da cao cấp.', N'50ml', 2, 7, 1800000, 40, 5, 10, NULL),
(N'Total Effects Cream', N'Olay', N'Kem chống lão hóa đa tác động.', N'50g', 2, 18, 400000, 100, 10, 20, NULL),

-- 🧪 3. TREATMENT (CategoryId = 3) 10SP
(N'Effaclar Duo+', N'La Roche-Posay', N'Kem trị mụn và giảm thâm.', N'40ml', 3, 19, 450000, 90, 10, 20, NULL),
(N'Retinol B3 Serum', N'La Roche-Posay', N'Serum chống lão hóa chứa Retinol.', N'30ml', 3, 19, 650000, 80, 10, 20, NULL),
(N'Normaderm Serum', N'Vichy', N'Serum trị mụn cho da dầu.', N'30ml', 3, 25, 500000, 90, 10, 20, NULL),
(N'Anti-Pigment Serum', N'Eucerin', N'Serum giảm thâm nám.', N'30ml', 3, 27, 700000, 70, 10, 15, NULL),
(N'Acne Solutions Gel', N'Clinique', N'Gel trị mụn chuyên sâu.', N'30ml', 3, 6, 600000, 80, 10, 20, NULL),
(N'Dark Spot Solution', N'Kiehl''s', N'Serum giảm thâm hiệu quả.', N'30ml', 3, 16, 1200000, 60, 5, 15, NULL),
(N'Rapid Wrinkle Repair', N'Neutrogena', N'Serum giảm nếp nhăn nhanh.', N'30ml', 3, 17, 550000, 100, 10, 20, NULL),
(N'Tea Tree Oil', N'The Body Shop', N'Dầu tràm trà trị mụn.', N'10ml', 3, 21, 180000, 150, 20, 30, NULL),
(N'Clear Face Gel', N'Sebamed', N'Gel trị mụn pH cân bằng.', N'50ml', 3, 26, 250000, 120, 15, 25, NULL),
(N'Glycolic Bright Serum', N'L''Oréal', N'Serum tẩy da chết hóa học nhẹ.', N'30ml', 3, 1, 420000, 110, 10, 20, NULL),

-- ☀️ 4. SUNSCREEN (CategoryId = 4) 8SP
(N'Anthelios SPF50', N'La Roche-Posay', N'Kem chống nắng bảo vệ da tối ưu trước tia UVA/UVB.', N'50ml', 4, 19, 450000, 100, 10, 20, NULL),
(N'Capital Soleil SPF50', N'Vichy', N'Kem chống nắng giúp bảo vệ và dưỡng da khỏe mạnh.', N'50ml', 4, 25, 420000, 90, 10, 20, NULL),
(N'Ultra Sheer SPF50', N'Neutrogena', N'Kem chống nắng mỏng nhẹ, không bết dính.', N'50ml', 4, 17, 380000, 120, 10, 20, NULL),
(N'UV Protector SPF50', N'Shiseido', N'Kem chống nắng cao cấp chống nước hiệu quả.', N'50ml', 4, 7, 750000, 70, 5, 15, NULL),
(N'Perfect UV Milk', N'Shiseido', N'Sữa chống nắng mỏng nhẹ, thấm nhanh.', N'60ml', 4, 7, 780000, 60, 5, 15, NULL),
(N'Sun Fluid SPF50', N'Eucerin', N'Chống nắng cho da nhạy cảm, an toàn.', N'50ml', 4, 27, 520000, 80, 10, 20, NULL),
(N'UV Defense SPF50', N'Kiehl''s', N'Kem chống nắng bảo vệ da toàn diện.', N'60ml', 4, 16, 900000, 60, 5, 15, NULL),
(N'UV Perfect SPF50', N'L''Oréal', N'Chống nắng nhẹ, phù hợp dùng hằng ngày.', N'50ml', 4, 1, 350000, 130, 15, 25, NULL),

-- 🎨 5. BASE MAKEUP (CategoryId = 5) 8SP
(N'Fit Me Foundation', N'Maybelline', N'Kem nền mịn nhẹ, che phủ tự nhiên.', N'30ml', 5, 3, 250000, 150, 20, 30, NULL),
(N'Double Wear Foundation', N'Estée Lauder', N'Kem nền lâu trôi, che phủ cao cấp.', N'30ml', 5, 2, 1500000, 80, 10, 20, NULL),
(N'Teint Idole Foundation', N'Lancôme', N'Kem nền mịn lì, bền màu cả ngày.', N'30ml', 5, 5, 1400000, 70, 10, 15, NULL),
(N'Studio Fix Fluid', N'MAC', N'Kem nền chuyên nghiệp cho makeup artist.', N'30ml', 5, 4, 1100000, 90, 10, 20, NULL),
(N'True Match Foundation', N'L''Oréal', N'Kem nền tiệp da tự nhiên.', N'30ml', 5, 1, 300000, 140, 15, 25, NULL),
(N'ColorStay Foundation', N'Revlon', N'Kem nền lâu trôi, kiểm soát dầu.', N'30ml', 5, 8, 280000, 120, 10, 20, NULL),
(N'Total Control Drop Foundation', N'NYX', N'Kem nền dạng giọt điều chỉnh độ che phủ.', N'30ml', 5, 13, 350000, 110, 10, 20, NULL),
(N'Natural Radiant Foundation', N'NARS', N'Kem nền giúp da căng bóng tự nhiên.', N'30ml', 5, 14, 1200000, 80, 10, 20, NULL),

-- 👁️ 6. EYE MAKEUP (CategoryId = 6) 8SP
(N'Hypnôse Mascara', N'Lancôme', N'Mascara làm dày mi tự nhiên.', N'6ml', 6, 5, 800000, 90, 10, 20, NULL),
(N'Great Lash Mascara', N'Maybelline', N'Mascara kinh điển giá tốt.', N'7ml', 6, 3, 180000, 200, 20, 30, NULL),
(N'Lash Power Mascara', N'Clinique', N'Mascara lâu trôi, không lem.', N'6ml', 6, 6, 650000, 100, 10, 20, NULL),
(N'In Extreme Dimension Mascara', N'MAC', N'Mascara tạo độ dày và cong mi.', N'7ml', 6, 4, 850000, 80, 10, 20, NULL),
(N'Mood Recipe Palette', N'3CE', N'Bảng mắt tông màu trendy Hàn Quốc.', N'8g', 6, 11, 600000, 120, 15, 25, NULL),
(N'Naked Palette', N'Urban Decay', N'Bảng mắt nude cao cấp.', N'12g', 6, 12, 1300000, 70, 10, 15, NULL),
(N'Climax Mascara', N'NARS', N'Mascara tăng volume mạnh.', N'6g', 6, 14, 750000, 90, 10, 20, NULL),
(N'Full Frontal Mascara', N'Fenty Beauty', N'Mascara đa hiệu ứng.', N'7g', 6, 15, 700000, 80, 10, 20, NULL),

-- 💋 7. CHEEK & LIP (CategoryId = 7) 8SP
(N'Rouge Coco Lipstick', N'Chanel Beauty', N'Son dưỡng cao cấp sang trọng.', N'3.5g', 7, 30, 1100000, 90, 10, 20, NULL),
(N'Matte Lipstick', N'MAC', N'Son lì sắc nét, bền màu.', N'3g', 7, 4, 550000, 150, 15, 25, NULL),
(N'SuperStay Matte Ink', N'Maybelline', N'Son kem lâu trôi.', N'5ml', 7, 3, 220000, 200, 20, 30, NULL),
(N'Velvet Lip Pencil', N'NARS', N'Son chì mềm mịn.', N'2.5g', 7, 14, 650000, 90, 10, 20, NULL),
(N'Gloss Bomb', N'Fenty Beauty', N'Son bóng dưỡng ẩm cao.', N'5ml', 7, 15, 500000, 120, 10, 20, NULL),
(N'Powder Blush', N'NARS', N'Phấn má hồng tự nhiên.', N'4g', 7, 14, 700000, 100, 10, 20, NULL),
(N'Lip Tint', N'3CE', N'Son tint nhẹ môi tự nhiên.', N'4g', 7, 11, 300000, 150, 15, 25, NULL),
(N'Soft Matte Lip Cream', N'NYX', N'Son kem lì nhẹ môi.', N'8ml', 7, 13, 250000, 180, 20, 30, NULL),

-- 🧱 8. CONTOUR (CategoryId = 8) 6SP
(N'Match Stix Contour', N'Fenty Beauty', N'Stick tạo khối tiện dụng.', N'7g', 8, 15, 650000, 90, 10, 20, NULL),
(N'Mineralize Skinfinish', N'MAC', N'Highlight ánh glow tự nhiên.', N'10g', 8, 4, 900000, 80, 10, 20, NULL),
(N'Born to Glow Highlighter', N'NYX', N'Highlight bắt sáng tốt.', N'9g', 8, 13, 320000, 120, 10, 20, NULL),
(N'Illuminator', N'NARS', N'Phấn bắt sáng cao cấp.', N'8g', 8, 14, 800000, 90, 10, 20, NULL),
(N'Bronze Goddess', N'Estée Lauder', N'Phấn tạo khối sang trọng.', N'10g', 8, 2, 1200000, 70, 10, 15, NULL),
(N'Master Contour Kit', N'Maybelline', N'Bảng tạo khối cơ bản.', N'12g', 8, 3, 280000, 150, 15, 25, NULL),

-- 🧴 9. BODY CARE (CategoryId = 9) 6SP
(N'Body Lotion', N'NIVEA', N'Dưỡng thể cấp ẩm sâu.', N'400ml', 9, 29, 180000, 200, 20, 30, NULL),
(N'Body Wash', N'Dove', N'Sữa tắm dịu nhẹ dưỡng da.', N'500ml', 9, 28, 160000, 220, 20, 30, NULL),
(N'Body Butter', N'The Body Shop', N'Kem dưỡng body siêu ẩm.', N'200ml', 9, 21, 450000, 120, 10, 20, NULL),
(N'Creme de Corps', N'Kiehl''s', N'Dưỡng thể cao cấp.', N'250ml', 9, 16, 950000, 90, 10, 20, NULL),
(N'Body Milk', N'Yves Rocher', N'Sữa dưỡng thể nhẹ.', N'400ml', 9, 23, 300000, 150, 15, 25, NULL),
(N'UreaRepair Lotion', N'Eucerin', N'Dưỡng thể cho da khô nặng.', N'250ml', 9, 27, 420000, 110, 10, 20, NULL),


-- 💇 10. HAIR CARE (10) 6SP
(N'Elseve Shampoo', N'L''Oréal', N'Dầu gội nuôi dưỡng tóc chắc khỏe, mềm mượt.', N'400ml', 10, 1, 180000, 200, 20, 30, NULL),
(N'Nourishing Oil Shampoo', N'Dove', N'Dầu gội dưỡng ẩm giúp tóc suôn mượt.', N'380ml', 10, 28, 160000, 210, 20, 30, NULL),
(N'Hair Fall Control Shampoo', N'NIVEA', N'Dầu gội giảm gãy rụng tóc.', N'400ml', 10, 29, 170000, 190, 20, 30, NULL),
(N'Tsubaki Shampoo', N'Shiseido', N'Dầu gội phục hồi tóc hư tổn.', N'450ml', 10, 7, 320000, 150, 15, 25, NULL),
(N'Repair Conditioner', N'Avon', N'Dầu xả phục hồi tóc hư tổn.', N'300ml', 10, 9, 150000, 180, 20, 30, NULL),
(N'Milk & Honey Shampoo', N'Oriflame', N'Dầu gội dưỡng tóc mềm mượt.', N'400ml', 10, 10, 140000, 170, 20, 30, NULL),

-- 🌸 11. FRAGRANCE (10) 6 SP
(N'Chanel No.5', N'Chanel Beauty', N'Nước hoa biểu tượng sang trọng cổ điển.', N'100ml', 11, 30, 3500000, 50, 5, 10, NULL),
(N'Idôle', N'Lancôme', N'Nước hoa nữ hiện đại, thanh lịch.', N'75ml', 11, 5, 2200000, 60, 5, 10, NULL),
(N'La Vie Est Belle', N'Lancôme', N'Nước hoa ngọt ngào, nữ tính.', N'75ml', 11, 5, 2100000, 70, 5, 10, NULL),
(N'Trésor Eau de Parfum', N'Lancôme', N'Hương thơm cổ điển quyến rũ.', N'50ml', 11, 5, 2000000, 60, 5, 10, NULL),
(N'Far Away Perfume', N'Avon', N'Nước hoa nữ hương phương Đông.', N'50ml', 11, 9, 350000, 150, 15, 25, NULL),
(N'Love Potion', N'Oriflame', N'Nước hoa ngọt ngào lãng mạn.', N'50ml', 11, 10, 300000, 160, 15, 25, NULL),

-- 🧪 12. DERMOCOSMETICS (10) 7SP
(N'Cicaplast Baume B5', N'La Roche-Posay', N'Kem phục hồi da tổn thương.', N'40ml', 12, 19, 420000, 120, 10, 20, NULL),
(N'Mineral 89', N'Vichy', N'Serum phục hồi hàng rào bảo vệ da.', N'50ml', 12, 25, 650000, 110, 10, 20, NULL),
(N'Aquaphor', N'Eucerin', N'Kem dưỡng phục hồi da khô nứt.', N'50ml', 12, 27, 350000, 130, 10, 20, NULL),
(N'Clear Face Gel', N'Sebamed', N'Gel dưỡng da mụn pH cân bằng.', N'50ml', 12, 26, 280000, 140, 10, 20, NULL),
(N'Moisturizing Cream', N'CeraVe', N'Kem dưỡng ẩm chuyên sâu.', N'50ml', 12, 20, 300000, 150, 15, 25, NULL),
(N'Toleriane Cream', N'La Roche-Posay', N'Kem dưỡng da nhạy cảm.', N'40ml', 12, 19, 450000, 120, 10, 20, NULL),
(N'DermatoClean Toner', N'Eucerin', N'Toner làm sạch dịu nhẹ.', N'200ml', 12, 27, 320000, 130, 10, 20, NULL),

-- 🌿 13. NATURAL & ORGANIC (10) 7SP
(N'Tea Tree Serum', N'The Body Shop', N'Serum tràm trà hỗ trợ giảm mụn.', N'30ml', 13, 21, 450000, 120, 10, 20, NULL),
(N'Green Tea Seed Serum', N'Innisfree', N'Serum trà xanh chống oxy hóa.', N'50ml', 13, 22, 500000, 130, 10, 20, NULL),
(N'Aloe Gel', N'Innisfree', N'Gel lô hội làm dịu da.', N'300ml', 13, 22, 200000, 150, 15, 25, NULL),
(N'Shea Butter Cream', N'Yves Rocher', N'Kem dưỡng bơ hạt mỡ tự nhiên.', N'200ml', 13, 23, 350000, 140, 10, 20, NULL),
(N'Calendula Toner', N'Kiehl''s', N'Toner hoa cúc làm dịu da.', N'250ml', 13, 16, 650000, 110, 10, 20, NULL),
(N'Rose Hibiscus Mist', N'Herbivore Botanicals', N'Spray dưỡng ẩm từ hoa hồng.', N'120ml', 13, 24, 750000, 90, 10, 20, NULL),
(N'Coconut Body Milk', N'Yves Rocher', N'Sữa dưỡng thể dừa thiên nhiên.', N'400ml', 13, 23, 280000, 160, 15, 25, NULL);

GO
-- 🧼 CLEANER (1-10)
UPDATE Product SET Picture='p-1-ultra-facial-cleanser.webp' WHERE Id=1;
UPDATE Product SET Picture='p-2-calendula-cleanser.webp' WHERE Id=2;
UPDATE Product SET Picture='p-3-foaming-facial-cleanser.webp' WHERE Id=3;
UPDATE Product SET Picture='p-4-hydrating-cleanser.webp' WHERE Id=4;
UPDATE Product SET Picture='p-5-effaclar-gel-cleanser.webp' WHERE Id=5;
UPDATE Product SET Picture='p-6-deep-cleansing-oil.webp' WHERE Id=6;
UPDATE Product SET Picture='p-7-perfect-whip-cleanser.webp' WHERE Id=7;
UPDATE Product SET Picture='p-8-green-tea-foam-cleanser.webp' WHERE Id=8;
UPDATE Product SET Picture='p-9-tea-tree-facial-wash.webp' WHERE Id=9;
UPDATE Product SET Picture='p-10-gentle-cleanser.webp' WHERE Id=10;

-- 💧 SKINCARE (11-20)
UPDATE Product SET Picture='p-11-advanced-night-repair.webp' WHERE Id=11;
UPDATE Product SET Picture='p-12-moisture-surge.webp' WHERE Id=12;
UPDATE Product SET Picture='p-13-revitalift-hyaluronic-serum.webp' WHERE Id=13;
UPDATE Product SET Picture='p-14-clearly-corrective-serum.webp' WHERE Id=14;
UPDATE Product SET Picture='p-15-mineral-89.webp' WHERE Id=15;
UPDATE Product SET Picture='p-16-hydro-boost-gel.webp' WHERE Id=16;
UPDATE Product SET Picture='p-17-aloe-revital-soothing-gel.webp' WHERE Id=17;
UPDATE Product SET Picture='p-18-vitamin-e-cream.webp' WHERE Id=18;
UPDATE Product SET Picture='p-19-white-lucent-cream.webp' WHERE Id=19;
UPDATE Product SET Picture='p-20-total-effects-cream.webp' WHERE Id=20;

-- 🧪 TREATMENT (21-30)
UPDATE Product SET Picture='p-21-effaclar-duo-plus.webp' WHERE Id=21;
UPDATE Product SET Picture='p-22-retinol-b3-serum.webp' WHERE Id=22;
UPDATE Product SET Picture='p-23-normaderm-serum.webp' WHERE Id=23;
UPDATE Product SET Picture='p-24-anti-pigment-serum.webp' WHERE Id=24;
UPDATE Product SET Picture='p-25-acne-solutions-gel.webp' WHERE Id=25;
UPDATE Product SET Picture='p-26-dark-spot-solution.webp' WHERE Id=26;
UPDATE Product SET Picture='p-27-rapid-wrinkle-repair.webp' WHERE Id=27;
UPDATE Product SET Picture='p-28-tea-tree-oil.webp' WHERE Id=28;
UPDATE Product SET Picture='p-29-clear-face-gel.webp' WHERE Id=29;
UPDATE Product SET Picture='p-30-glycolic-bright-serum.webp' WHERE Id=30;

-- ☀️ SUNSCREEN (31-38)
UPDATE Product SET Picture='p-31-anthelios-spf50.webp' WHERE Id=31;
UPDATE Product SET Picture='p-32-capital-soleil-spf50.webp' WHERE Id=32;
UPDATE Product SET Picture='p-33-ultra-sheer-spf50.webp' WHERE Id=33;
UPDATE Product SET Picture='p-34-uv-protector-spf50.webp' WHERE Id=34;
UPDATE Product SET Picture='p-35-perfect-uv-milk.webp' WHERE Id=35;
UPDATE Product SET Picture='p-36-sun-fluid-spf50.webp' WHERE Id=36;
UPDATE Product SET Picture='p-37-uv-defense-spf50.webp' WHERE Id=37;
UPDATE Product SET Picture='p-38-uv-perfect-spf50.webp' WHERE Id=38;

-- 🎨 FOUNDATION (39-46)
UPDATE Product SET Picture='p-39-fit-me-foundation.webp' WHERE Id=39;
UPDATE Product SET Picture='p-40-double-wear-foundation.webp' WHERE Id=40;
UPDATE Product SET Picture='p-41-teint-idole-foundation.webp' WHERE Id=41;
UPDATE Product SET Picture='p-42-studio-fix-fluid.webp' WHERE Id=42;
UPDATE Product SET Picture='p-43-true-match-foundation.webp' WHERE Id=43;
UPDATE Product SET Picture='p-44-colorstay-foundation.webp' WHERE Id=44;
UPDATE Product SET Picture='p-45-total-control-drop-foundation.webp' WHERE Id=45;
UPDATE Product SET Picture='p-46-natural-radiant-foundation.webp' WHERE Id=46;

-- 👁️ EYES (47-54)
UPDATE Product SET Picture='p-47-hypnose-mascara.webp' WHERE Id=47;
UPDATE Product SET Picture='p-48-great-lash-mascara.webp' WHERE Id=48;
UPDATE Product SET Picture='p-49-lash-power-mascara.webp' WHERE Id=49;
UPDATE Product SET Picture='p-50-in-extreme-dimension-mascara.webp' WHERE Id=50;
UPDATE Product SET Picture='p-51-mood-recipe-palette.webp' WHERE Id=51;
UPDATE Product SET Picture='p-52-naked-palette.webp' WHERE Id=52;
UPDATE Product SET Picture='p-53-climax-mascara.webp' WHERE Id=53;
UPDATE Product SET Picture='p-54-full-frontal-mascara.webp' WHERE Id=54;

-- 💋 LIPS (55-62)
UPDATE Product SET Picture='p-55-rouge-coco-lipstick.webp' WHERE Id=55;
UPDATE Product SET Picture='p-56-matte-lipstick.webp' WHERE Id=56;
UPDATE Product SET Picture='p-57-superstay-matte-ink.webp' WHERE Id=57;
UPDATE Product SET Picture='p-58-velvet-lip-pencil.webp' WHERE Id=58;
UPDATE Product SET Picture='p-59-gloss-bomb.webp' WHERE Id=59;
UPDATE Product SET Picture='p-60-powder-blush.webp' WHERE Id=60;
UPDATE Product SET Picture='p-61-lip-tint.webp' WHERE Id=61;
UPDATE Product SET Picture='p-62-soft-matte-lip-cream.webp' WHERE Id=62;

-- 🧱 CONTOUR (63-68)
UPDATE Product SET Picture='p-63-match-stix-contour.webp' WHERE Id=63;
UPDATE Product SET Picture='p-64-mineralize-skinfinish.webp' WHERE Id=64;
UPDATE Product SET Picture='p-65-born-to-glow-highlighter.webp' WHERE Id=65;
UPDATE Product SET Picture='p-66-illuminator.webp' WHERE Id=66;
UPDATE Product SET Picture='p-67-bronze-goddess.webp' WHERE Id=67;
UPDATE Product SET Picture='p-68-master-contour-kit.webp' WHERE Id=68;

-- 🧴 BODY (69-74)
UPDATE Product SET Picture='p-69-body-lotion.webp' WHERE Id=69;
UPDATE Product SET Picture='p-70-body-wash.webp' WHERE Id=70;
UPDATE Product SET Picture='p-71-body-butter.webp' WHERE Id=71;
UPDATE Product SET Picture='p-72-creme-de-corps.webp' WHERE Id=72;
UPDATE Product SET Picture='p-73-body-milk.webp' WHERE Id=73;
UPDATE Product SET Picture='p-74-urearepair-lotion.webp' WHERE Id=74;

-- 💇 HAIR (75-80)
UPDATE Product SET Picture='p-75-elseve-shampoo.webp' WHERE Id=75;
UPDATE Product SET Picture='p-76-nourishing-oil-shampoo.webp' WHERE Id=76;
UPDATE Product SET Picture='p-77-hair-fall-control-shampoo.webp' WHERE Id=77;
UPDATE Product SET Picture='p-78-tsubaki-shampoo.webp' WHERE Id=78;
UPDATE Product SET Picture='p-79-repair-conditioner.webp' WHERE Id=79;
UPDATE Product SET Picture='p-80-milk-honey-shampoo.webp' WHERE Id=80;

-- 🌸 PERFUME (81-86)
UPDATE Product SET Picture='p-81-chanel-no5.webp' WHERE Id=81;
UPDATE Product SET Picture='p-82-idole.webp' WHERE Id=82;
UPDATE Product SET Picture='p-83-la-vie-est-belle.webp' WHERE Id=83;
UPDATE Product SET Picture='p-84-tresor-eau-de-parfum.webp' WHERE Id=84;
UPDATE Product SET Picture='p-85-far-away-perfume.webp' WHERE Id=85;
UPDATE Product SET Picture='p-86-love-potion.webp' WHERE Id=86;

-- 🧪 DERMOCOSMETICS (87-93)
UPDATE Product SET Picture='p-87-cicaplast-baume-b5.webp' WHERE Id=87;
UPDATE Product SET Picture='p-88-mineral-89-serum.webp' WHERE Id=88;
UPDATE Product SET Picture='p-89-aquaphor.webp' WHERE Id=89;
UPDATE Product SET Picture='p-90-clear-face-gel-sebamed.webp' WHERE Id=90;
UPDATE Product SET Picture='p-91-moisturizing-cream.webp' WHERE Id=91;
UPDATE Product SET Picture='p-92-toleriane-cream.webp' WHERE Id=92;
UPDATE Product SET Picture='p-93-dermatoclean-toner.webp' WHERE Id=93;

-- 🌿 NATURAL (94-100)
UPDATE Product SET Picture='p-94-tea-tree-serum.webp' WHERE Id=94;
UPDATE Product SET Picture='p-95-green-tea-seed-serum.webp' WHERE Id=95;
UPDATE Product SET Picture='p-96-aloe-gel.webp' WHERE Id=96;
UPDATE Product SET Picture='p-97-shea-butter-cream.webp' WHERE Id=97;
UPDATE Product SET Picture='p-98-calendula-toner.webp' WHERE Id=98;
UPDATE Product SET Picture='p-99-rose-hibiscus-mist.webp' WHERE Id=99;
UPDATE Product SET Picture='p-100-coconut-body-milk.webp' WHERE Id=100;

--UPDATE Product SET Picture = REPLACE(Picture, '.jpg', '.webp');

select * from Product where Picture is null
DELETE FROM Product
WHERE Picture IS NULL;
select * from Users