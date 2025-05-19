<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookDetail.aspx.cs" Inherits="BaiTapLon.BookDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>Chi Tiết Sách</title>
        <webopt:bundlereference runat="server" path="~/Content/css" />
        <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        .book-detail-container {
            width: 800px;
            margin: 40px auto;
            display: flex;
            gap: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            font-family: Arial, sans-serif;
        }

        .book-image img {
            width: 200px;
            height: 280px;
            object-fit: cover;
            border-radius: 6px;
        }

        .book-info h2 {
            margin-top: 0;
            color: #e91e63;
        }

        .book-info p {
            margin: 6px 0;
        }

        .label {
            font-weight: bold;
        }
                .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #343a40;
            padding: 10px 20px;
            color: white;
        }
        .header .logo {
            display: flex;
            align-items: center;
        }
        .header .logo img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .header .search-box {
            flex-grow: 1;
            max-width: 500px;
            margin: 0 20px;
        }
        .header .search-box input {
            width: 100%;
            padding: 8px 12px;
            border-radius: 20px;
            border: none;
        }
        .header .actions {
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
        }
        .header .actions i {
            font-size: 18px;
            cursor: pointer;
            color: white;
        }
        .header .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            cursor: pointer;
        }
        .user-menu {
            position: absolute;
            top: 45px;
            right: 0;
            background: white;
            color: black;
            border-radius: 5px;
            display: none;
            flex-direction: column;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            z-index: 999;
            min-width: 150px;
        }
        .user-menu a {
            padding: 10px;
            text-decoration: none;
            color: black;
            border-bottom: 1px solid #eee;
        }
        .user-menu a:hover {
            background-color: #f1f1f1;
        }
        .show-menu {
            display: flex !important;
        }
        .main-menu {
            background-color: #495057;
            padding: 0;
        }
        .main-menu ul {
            margin: 0;
            padding: 0;
            display: flex;
            list-style: none;
            justify-content: center;
        }
        .main-menu ul li {
            margin: 0;
        }
        .main-menu ul li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.2s ease;
        }
        .main-menu ul li a i {
            margin-right: 8px;
        }
        .main-menu ul li a:hover {
            background-color: #6c757d;
        }

         .search-box {
             position: relative;  
             width: 100%;
             max-width: 300px;
         }
        .search-input {
             width: 100%;
             padding: 8px 40px 8px 12px;
             border-radius: 20px;
             border: none;
             box-sizing: border-box;
             font-size: 16px;
             background-color: rgba(255, 255, 255, 0.5); 
             color: #333;
         }

         .search-input::placeholder {
             color: rgba(0, 0, 0, 0.3); 
             font-style: italic;
         }
         .btn-search {
             position: absolute;
             right: 10px;
             top: 50%;
             transform: translateY(-50%);
             width: 28px;
             height: 28px;
             border: none;
             background: transparent;
             cursor: pointer;
             font-family: "Font Awesome 6 Free";
             font-weight: 900;
             font-size: 18px;
             color: #555;
             line-height: 28px;
             text-align: center;
             z-index: 10;
             margin-right:220px;
         }
         .btn-search::before {
             content: "\f002"; 
             font-family: "Font Awesome 6 Free";
             font-weight: 900;
         }
         .btn-search:hover {
             color: #000;
         }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="header">
            <div class="logo">
                <img src="~/Images/logo.png" alt="Logo" />
                <span style="font-weight: bold; font-size: 20px;">Web Bán Sách</span>
            </div>

        <div class="search-box">
            <input type="text" id="txtSearchMaster" name="txtSearchMaster" class="search-input" placeholder="Tìm Kiếm sách" />
            <button type="submit" id="btnSearchMaster" name="btnSearchMaster" class="btn-search"></button>
        </div>
            <div class="actions">
                <i class="fas fa-shopping-cart"></i>
                <i class="fas fa-bell"></i>
                <img src="~/Images/user.jpg" class="user-avatar" onclick="toggleUserMenu()" />
                <div id="userMenu" class="user-menu">
                    <a href="#">Thông tin người dùng</a>
                    <a href="#">Đăng xuất</a>
                </div>
            </div>
        </div>

        <!-- Menu ngang -->
        <div class="main-menu">
            <ul>
                <li><a href="/Default.aspx"><i class="fas fa-home"></i> Trang chủ</a></li>
                <li><a href="~/DanhSachSach.aspx"><i class="fas fa-book"></i> Sách</a></li>
                <li><a href="~/DanhMucTheLoai.aspx"><i class="fas fa-th-list"></i> Thể loại</a></li>
                <li><a href="~/TacGia.aspx"><i class="fas fa-user-pen"></i> Tác giả</a></li>
                <li><a href="~/GioHang.aspx"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a></li>
            </ul>
        </div>
        <div class="book-detail-container">
             
            <div class="book-image">
                <asp:Image ID="imgBook" runat="server" />
            </div>
            <div class="book-info">
                <h2><asp:Label ID="lblTenSach" runat="server" /></h2>
                <p><span class="label">Tác giả:</span> <asp:Label ID="lblTacGia" runat="server" /></p>
                <p><span class="label">Thể loại:</span> <asp:Label ID="lblChuDe" runat="server" /></p>
                <p><span class="label">Giá:</span> <asp:Label ID="lblDonGia" runat="server" /></p>
                <p><span class="label">Mô tả:</span><br /><asp:Label ID="lblMoTa" runat="server" /></p>
                <p><span class="label">Lượt xem:</span> <asp:Label ID="lblXem" runat="server" /> | <span class="label">Đã bán:</span> <asp:Label ID="lblBan" runat="server" /></p>
            </div>
        </div>
    </form>
</body>
</html>
