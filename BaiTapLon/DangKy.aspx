<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DangKy.aspx.cs" Inherits="BaiTapLon.DangKy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Đăng ký tài khoản</title>
    <style>
        .form-container {
            width: 400px;
            margin: 50px auto;
            background: #f9f9f9;
            padding: 25px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        .form-container label {
            display: block;
            margin-top: 10px;
        }
        .form-container input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }
        .form-container button {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background: #007bff;
            border: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
            border-radius: 5px;
        }
        .form-container button:hover {
            background: #0056b3;
        }
        #<%= rblGioiTinh.ClientID %> li {
            display: inline-block;
            margin-right: 15px;
            font-weight: normal;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-container">
            <h2>Đăng ký</h2>
            <asp:Label ID="lblThongBao" runat="server" ForeColor="Red" />
            <label for="txtUsername">Tên đăng nhập:</label>
            <asp:TextBox ID="txtTenDangNhap" runat="server" />
            <label for="txtPassword">Mật khẩu:</label>
            <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" />
            <label for="txtHoTen">Họ tên:</label>
            <asp:TextBox ID="txtHoTen" runat="server" />
            <label for="txtEmail">Email:</label>
            <asp:TextBox ID="txtEmail" runat="server" />
            <label for="txtSDT">Số điện thoại:</label>
            <asp:TextBox ID="txtDienThoai" runat="server" ></asp:TextBox>
            <label for="txtDiaChi">Địa Chỉ:</label>
            <asp:TextBox ID="txtDiaChi" runat="server" />
            <label for="txtNgaySinh">Ngày Sinh:</label>
            <asp:TextBox ID="txtNgaySinh" runat="server" />

            <asp:RadioButtonList ID="rblGioiTinh" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="Nam" Value="1" />
                <asp:ListItem Text="Nữ" Value="0" />
            </asp:RadioButtonList>

            <button type="submit" runat="server" onserverclick="btnDangKy_Click">Đăng ký</button>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
        </div>
    </form>
</body>
</html>
