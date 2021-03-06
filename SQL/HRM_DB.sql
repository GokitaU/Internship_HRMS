USE [master]
GO
/****** Object:  Database [HRM_DB]    Script Date: 24/01/2022 13:55:40 ******/
CREATE DATABASE [HRM_DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HRM_DB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\HRM_DB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HRM_DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\HRM_DB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [HRM_DB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HRM_DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HRM_DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HRM_DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HRM_DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HRM_DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HRM_DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [HRM_DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HRM_DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HRM_DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HRM_DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HRM_DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HRM_DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HRM_DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HRM_DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HRM_DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HRM_DB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HRM_DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HRM_DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HRM_DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HRM_DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HRM_DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HRM_DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HRM_DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HRM_DB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HRM_DB] SET  MULTI_USER 
GO
ALTER DATABASE [HRM_DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HRM_DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HRM_DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HRM_DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HRM_DB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'HRM_DB', N'ON'
GO
ALTER DATABASE [HRM_DB] SET QUERY_STORE = OFF
GO
USE [HRM_DB]
GO
/****** Object:  User [amunok01]    Script Date: 24/01/2022 13:55:40 ******/
CREATE USER [amunok01] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_datareader] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [amunok01]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [amunok01]
GO
/****** Object:  UserDefinedFunction [dbo].[fConvertToUnSign]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fConvertToUnSign](@inputVar NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS
BEGIN    
    IF (@inputVar IS NULL OR @inputVar = '')  RETURN ''
   
    DECLARE @RT NVARCHAR(MAX)
    DECLARE @SIGN_CHARS NCHAR(256)
    DECLARE @UNSIGN_CHARS NCHAR (256)
 
    SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
 
    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
   
    SET @COUNTER = 1
    WHILE (@COUNTER <= LEN(@inputVar))
    BEGIN  
        SET @COUNTER1 = 1
        WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@inputVar,@COUNTER ,1))
            BEGIN          
                IF @COUNTER = 1
                    SET @inputVar = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)-1)      
                ELSE
                    SET @inputVar = SUBSTRING(@inputVar, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)- @COUNTER)
                BREAK
            END
            SET @COUNTER1 = @COUNTER1 +1
        END
        SET @COUNTER = @COUNTER +1
    END
    -- SET @inputVar = replace(@inputVar,' ','-')
    RETURN @inputVar
END
GO
/****** Object:  Table [dbo].[Access]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Access](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[RouterLink] [nvarchar](50) NULL,
	[NameTrans] [nvarchar](50) NULL,
 CONSTRAINT [PK__RoleAcce__3214EC0736D3E050] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[StaffId] [int] NULL,
	[RoleId] [int] NULL,
	[Email] [nvarchar](50) NULL,
	[CreateDate] [date] NULL,
	[UpdateDate] [date] NULL,
	[RefreshToken] [nvarchar](max) NULL,
	[TokenExpired] [datetime] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Id] [int] NOT NULL,
	[ParentId] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[LeaderStaffId] [int] NULL,
	[CreateDate] [date] NULL,
	[CreateId] [int] NULL,
	[UpdateDate] [date] NULL,
	[UpdateId] [int] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CreateDate] [date] NULL,
	[CreateId] [int] NULL,
	[UpdateDate] [date] NULL,
	[UpdateId] [int] NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleAccess]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleAccess](
	[RoleId] [int] NOT NULL,
	[AccessId] [int] NOT NULL,
 CONSTRAINT [PK_RoleAccess] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[AccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 24/01/2022 13:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[DateOfBirth] [date] NULL,
	[Sex] [int] NULL,
	[Address] [nvarchar](max) NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [nvarchar](20) NULL,
	[ContractDate] [date] NULL,
	[DepartmentId] [int] NULL,
	[PositionId] [int] NULL,
	[CreateDate] [date] NULL,
	[UpdateDate] [date] NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Access] ON 

INSERT [dbo].[Access] ([Id], [Name], [RouterLink], [NameTrans]) VALUES (1, N'Dashboard', N'/Dashboard', N'Header.Dashboard')
INSERT [dbo].[Access] ([Id], [Name], [RouterLink], [NameTrans]) VALUES (2, N'Staff', N'/Staff/List', N'Header.Staff')
INSERT [dbo].[Access] ([Id], [Name], [RouterLink], [NameTrans]) VALUES (3, N'Department', N'/Department/List', N'Header.Department')
INSERT [dbo].[Access] ([Id], [Name], [RouterLink], [NameTrans]) VALUES (4, N'Account', N'/Account/List', N'Header.Account.Register')
INSERT [dbo].[Access] ([Id], [Name], [RouterLink], [NameTrans]) VALUES (5, N'Role', N'/Role', N'Header.Role')
SET IDENTITY_INSERT [dbo].[Access] OFF
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_a', N'dhw4YPjgdw1PtBxWoJihVQ==', 2, 4, N'le_a@company.com', CAST(N'2021-12-23' AS Date), CAST(N'2021-12-23' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_b', N'dhw4YPjgdw1PtBxWoJihVQ==', 3, 5, N'le_b@company.com', CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_c', N'dhw4YPjgdw1PtBxWoJihVQ==', 4, 5, N'le_c@company.com', CAST(N'2021-12-23' AS Date), CAST(N'2021-12-23' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_w', N'dhw4YPjgdw1PtBxWoJihVQ==', 24, 1, N'le_w@company.com', CAST(N'2021-12-19' AS Date), CAST(N'2021-12-23' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_y', N'dhw4YPjgdw1PtBxWoJihVQ==', 26, 5, N'le_y@company.com', CAST(N'2021-12-19' AS Date), CAST(N'2021-12-23' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'le_z', N'dhw4YPjgdw1PtBxWoJihVQ==', NULL, NULL, NULL, NULL, CAST(N'2021-12-23' AS Date), N'iIqQPChDsndnOk/ePHqs/lDWzHdglMUGfz2mh1qBxZc=', CAST(N'2021-12-23T13:59:21.130' AS DateTime))
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N't_nhan', N'dhw4YPjgdw1PtBxWoJihVQ==', 1, 3, N't_nhan@company.com', CAST(N'2020-05-07' AS Date), CAST(N'2022-01-24' AS Date), NULL, NULL)
INSERT [dbo].[Account] ([UserName], [Password], [StaffId], [RoleId], [Email], [CreateDate], [UpdateDate], [RefreshToken], [TokenExpired]) VALUES (N'thanhnm', N'dhw4YPjgdw1PtBxWoJihVQ==', 28, 3, N'thanhnm@company.com', CAST(N'2022-01-24' AS Date), CAST(N'2022-01-24' AS Date), N'yvkpfXp6yTQiq1f50YcVne6T7JWPjSqDRVD/dz1h42g=', CAST(N'2022-01-24T14:18:40.817' AS DateTime))
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (1, 1, N'DEV', 1, NULL, NULL, CAST(N'2021-12-23' AS Date), 27)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (2, 2, N'DEV-BAS', 2, NULL, NULL, CAST(N'2021-12-23' AS Date), 1)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (3, 3, N'DEV-EMS', 5, NULL, NULL, CAST(N'2021-12-19' AS Date), 1)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (4, 4, N'BLJ', 9, NULL, NULL, CAST(N'2021-12-19' AS Date), 1)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (5, 5, N'DTP', 14, NULL, NULL, CAST(N'2021-12-19' AS Date), 1)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (6, 6, N'BAO', 20, NULL, NULL, CAST(N'2021-12-19' AS Date), 1)
INSERT [dbo].[Department] ([Id], [ParentId], [Name], [LeaderStaffId], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (7, 7, N'GA', 24, CAST(N'2020-05-18' AS Date), 10, CAST(N'2021-12-19' AS Date), 1)
INSERT [dbo].[Position] ([Id], [Name], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (1, N'Manager', NULL, NULL, NULL, NULL)
INSERT [dbo].[Position] ([Id], [Name], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (2, N'Team Leader', NULL, NULL, NULL, NULL)
INSERT [dbo].[Position] ([Id], [Name], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (3, N'Project Leader', NULL, NULL, NULL, NULL)
INSERT [dbo].[Position] ([Id], [Name], [CreateDate], [CreateId], [UpdateDate], [UpdateId]) VALUES (4, N'Member', NULL, NULL, NULL, NULL)
INSERT [dbo].[Role] ([Id], [Name], [CreateDate], [UpdateDate]) VALUES (1, N'GA', CAST(N'2021-12-23T11:10:07.140' AS DateTime), CAST(N'2021-12-23T11:10:07.140' AS DateTime))
INSERT [dbo].[Role] ([Id], [Name], [CreateDate], [UpdateDate]) VALUES (3, N'Manager', CAST(N'2021-12-23T11:10:07.140' AS DateTime), CAST(N'2021-12-23T11:10:07.140' AS DateTime))
INSERT [dbo].[Role] ([Id], [Name], [CreateDate], [UpdateDate]) VALUES (4, N'Leader', CAST(N'2021-12-23T11:10:07.140' AS DateTime), CAST(N'2021-12-23T11:10:07.140' AS DateTime))
INSERT [dbo].[Role] ([Id], [Name], [CreateDate], [UpdateDate]) VALUES (5, N'Member', CAST(N'2021-12-23T11:10:07.140' AS DateTime), CAST(N'2021-12-23T11:10:07.140' AS DateTime))
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (1, 1)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (1, 2)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (3, 1)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (3, 2)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (3, 3)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (3, 4)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (3, 5)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (4, 1)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (4, 2)
INSERT [dbo].[RoleAccess] ([RoleId], [AccessId]) VALUES (5, 1)
SET IDENTITY_INSERT [dbo].[Staff] ON 

INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (1, N'Nhân', N'Lê', CAST(N'1992-03-10' AS Date), 1, N'Huế', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2014-01-01' AS Date), 1, 1, CAST(N'2000-01-01' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (2, N'A', N'Lê', CAST(N'2021-12-19' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'lea@gmail.com', N'0906444232', CAST(N'2015-12-19' AS Date), 2, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (3, N'B', N'Lê', CAST(N'2021-12-19' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'leb@gmail.com', N'0906444233', CAST(N'2015-12-19' AS Date), 2, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (4, N'C', N'Lê', CAST(N'2021-12-19' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444235', CAST(N'2016-01-19' AS Date), 2, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (5, N'D', N'Lê', CAST(N'2021-12-13' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'led@gmail.com', N'0906444231', CAST(N'2016-12-06' AS Date), 3, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (6, N'E', N'Lê', CAST(N'2021-11-29' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-01-01' AS Date), 3, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (7, N'F', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'lef@gmail.com', N'0906444231', CAST(N'2016-01-19' AS Date), 3, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (8, N'G', N'Lê', CAST(N'2021-12-01' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-01-19' AS Date), 3, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (9, N'H', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-03-01' AS Date), 4, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (10, N'I', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-04-19' AS Date), 4, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (11, N'J', N'Lê', CAST(N'2021-12-01' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-06-19' AS Date), 4, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (12, N'K', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-06-19' AS Date), 4, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (13, N'L', N'Lê', CAST(N'2021-12-03' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2016-06-19' AS Date), 4, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (14, N'M', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'lem@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (15, N'N', N'Lê', CAST(N'2021-12-01' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (16, N'O', N'Lê', CAST(N'2021-12-02' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (17, N'P', N'Lê', CAST(N'2021-12-10' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'lep@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (18, N'Q', N'Lê', CAST(N'2021-12-04' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'leq@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (19, N'R', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2017-01-19' AS Date), 5, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (20, N'S', N'Lê', CAST(N'2021-12-11' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'les@gmail.com', N'0906444231', CAST(N'2018-01-19' AS Date), 6, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (21, N'T', N'Lê', CAST(N'2021-12-10' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'let@gmail.com', N'0906444231', CAST(N'2018-01-19' AS Date), 6, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (22, N'U', N'Lê', CAST(N'2021-12-02' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'leu@gmail.com', N'0906444231', CAST(N'2018-01-19' AS Date), 6, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (23, N'V', N'Lê', CAST(N'2021-12-03' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'lev@gmail.com', N'0906444231', CAST(N'2019-01-19' AS Date), 6, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (24, N'W', N'Lê', CAST(N'2021-12-10' AS Date), 0, N'16 Mỹ Đình, Hà Nội', N'lew@gmail.com', N'0906444231', CAST(N'2020-01-19' AS Date), 7, 2, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (25, N'X', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'lex@gmail.com', N'0906444231', CAST(N'2020-01-19' AS Date), 7, 3, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (26, N'Y', N'Lê', CAST(N'2021-12-01' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'ley@gmail.com', N'0906444231', CAST(N'2020-01-19' AS Date), 7, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (27, N'Z', N'Lê', CAST(N'2021-12-02' AS Date), 1, N'16 Mỹ Đình, Hà Nội', N'levanthanhnhan92@gmail.com', N'0906444231', CAST(N'2021-01-19' AS Date), 7, 4, CAST(N'2021-12-19' AS Date), CAST(N'2021-12-19' AS Date))
INSERT [dbo].[Staff] ([Id], [FirstName], [LastName], [DateOfBirth], [Sex], [Address], [Email], [Phone], [ContractDate], [DepartmentId], [PositionId], [CreateDate], [UpdateDate]) VALUES (28, N'Thanh', N'Nguyen', CAST(N'2005-02-24' AS Date), 1, N'Viet Nam', N'thanhnm@company.com', NULL, NULL, 1, 1, CAST(N'2022-01-24' AS Date), CAST(N'2022-01-24' AS Date))
SET IDENTITY_INSERT [dbo].[Staff] OFF
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Staff] FOREIGN KEY([StaffId])
REFERENCES [dbo].[Staff] ([Id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Staff]
GO
ALTER TABLE [dbo].[RoleAccess]  WITH CHECK ADD  CONSTRAINT [FK_RoleAccess_Access] FOREIGN KEY([AccessId])
REFERENCES [dbo].[Access] ([Id])
GO
ALTER TABLE [dbo].[RoleAccess] CHECK CONSTRAINT [FK_RoleAccess_Access]
GO
ALTER TABLE [dbo].[RoleAccess]  WITH CHECK ADD  CONSTRAINT [FK_RoleAccess_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO
ALTER TABLE [dbo].[RoleAccess] CHECK CONSTRAINT [FK_RoleAccess_Role]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Department] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([Id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Department]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Position] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([Id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Position]
GO
USE [master]
GO
ALTER DATABASE [HRM_DB] SET  READ_WRITE 
GO
