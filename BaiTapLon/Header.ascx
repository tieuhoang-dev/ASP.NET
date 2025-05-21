<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="BaiTapLon.Header" %>

        <style>
        html, body {
          margin: 0;
          padding: 0;
          width: 100%;
          box-sizing: border-box;
        }
        .header_content {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
          height:60px;
          width:100vw;
        }

        /* HEADER */
        .header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          background-color: #343a40;
          padding: 20px 0; 
          color: white;
          box-sizing: border-box;
          position: relative;
          height:60px;
        }

        /* Logo */
        .header .logo {
          display: flex;
          align-items: center;
          font-weight: bold;
          font-size: 20px;
          cursor: default;
          margin-left:20px;
        }

        .header .logo img {
          width: 40px;
          height: 40px;
          border-radius: 50%;
          margin-right: 10px;
        }

        /* Search box */
        .header .search-box {
            flex-grow: 1;
            max-width: 400px;
            margin: 0 10px; 
            position: relative;
        }


        .search-input {
          width: 100%;
          padding: 8px 40px 8px 12px;
          border-radius: 20px;
          border: none;
          font-size: 16px;
          box-sizing: border-box;
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
          margin-right: 120px; 
}
        .btn-search::before {
          content: "\f002"; 
          font-family: "Font Awesome 6 Free";
          font-weight: 900;
        }

        .btn-search:hover {
          color: #000;
        }

        .header .actions {
          display: flex;
          align-items: center;
          gap: 15px;
          position: relative;
          white-space: nowrap;
        }
        .header.actions.login{
            margin-right:20px;
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
          object-fit: cover;
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
          font-size: 14px;
        }

        .user-menu a {
          padding: 10px;
          text-decoration: none;
          color: black;
          border-bottom: 1px solid #eee;
          display: block;
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
            width:100vw;
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

</style>

        <div class="header_content">
        <!-- Phần header -->
        <div class="header">
          <div class="logo">
            <asp:HyperLink runat="server" NavigateUrl="~/Default.aspx">
                <img src="data:image/jpeg;base64,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" alt="Logo" />
                <span>Huyền Thiên Thư Viện</span>
            </asp:HyperLink>
          </div>

          <div class="search-box">
            <input type="text" id="txtSearchMaster" name="txtSearchMaster" class="search-input" placeholder="Tìm Kiếm sách" />
            <button type="submit" id="btnSearchMaster" name="btnSearchMaster" class="btn-search"></button>
          </div>

          <div class="actions">
            <i class="fas fa-shopping-cart"></i>
            <i class="fas fa-bell"></i>
              <div style="margin-right:30px">
        <asp:PlaceHolder ID="phNotLoggedIn" runat="server">
            <div style="color: white;">
                <a href="DangKy.aspx" style="color:white; margin-right: 10px;">Đăng ký</a> |
                <a href='<%= "Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl) %>'>Đăng nhập</a>
            </div>
        </asp:PlaceHolder>

        <asp:PlaceHolder ID="phLoggedIn" runat="server" Visible="false">
            <img src="data:image/jpeg;base64,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" class="user-avatar" onclick="toggleUserMenu()" />
            <div id="userMenu" class="user-menu">
                <asp:Label ID="lblUserName" runat="server" Text="User"></asp:Label>
                    <a href='<%= Request.RawUrl + (Request.RawUrl.Contains("?") ? "&" : "?") + "action=logout" %>'>Đăng xuất</a>
            </div>
        </asp:PlaceHolder>
              </div>
          </div>
        </div>


        <div class="main-menu">
          <ul>
            <li><a href="Default.aspx"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li><a href="#"><i class="fas fa-book"></i> Sách</a></li>
            <li><a href="#"><i class="fas fa-th-list"></i> Thể loại</a></li>
            <li><a href="#"><i class="fas fa-user-pen"></i> Tác giả</a></li>
            <li><a href="#"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a></li>
          </ul>
        </div>

        <script>
          function toggleUserMenu() {
            var menu = document.getElementById('userMenu');
            menu.classList.toggle('show-menu');
          }
          document.addEventListener('click', function(event) {
            var menu = document.getElementById('userMenu');
            var avatar = document.querySelector('.user-avatar');
            if (!menu.contains(event.target) && !avatar.contains(event.target)) {
              menu.classList.remove('show-menu');
            }
          });
        </script>
  </div>
