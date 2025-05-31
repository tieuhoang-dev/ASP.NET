<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Lab05.Admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0; padding: 0;
        }
        .treeview {
            width: 200px;
            float: left;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 15px;
            margin: 20px;
            background: white;
        }
        .treeview ul {
            list-style: none;
            padding-left: 10px;
            margin: 0;
        }
        .treeview li {
            margin: 15px 0;
            font-weight: bold;
            cursor: pointer;
            color: #333;
            transition: 0.3s;
        }
        .treeview li:hover {
            color: #007BFF;
            transform: translateX(5px);
        }
        .content {
            margin-left: 250px;
            padding: 20px;
            background: white;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            min-height: 600px;
        }
        .btn {
            margin: 0 5px 15px 0;
            cursor: pointer;
            background-color: #007BFF;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        table.table {
            width: 100%;
            border-collapse: collapse;
        }
        table.table th, table.table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        table.table th {
            background-color: #007BFF;
            color: white;
        }
        a {
            color: #007BFF;
            cursor: pointer;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        #Panel1, #Panel2 {
            display: none;
            position: fixed;
            top: 15%;
            left: 50%;
            transform: translateX(-50%);
            width: 450px;
            background-color: white;
            padding: 25px 30px;
            border: 2px solid #007BFF;
            border-radius: 10px;
            z-index: 9999;
            box-shadow: 0 0 20px rgba(0,0,0,0.25);
        }
        .modal-header {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 15px;
            position: relative;
        }
        .close-btn {
            position: absolute;
            right: 0;
            top: 0;
            font-weight: bold;
            color: red;
            cursor: pointer;
            font-size: 22px;
            user-select: none;
        }
        .modal-footer {
            margin-top: 20px;
            text-align: right;
        }
        input[type="text"], input[type="email"], input[type="password"], select {
            width: 100%;
            padding: 8px 10px;
            margin: 6px 0 14px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        button, input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            margin-left: 10px;
        }
        button:hover, input[type="submit"]:hover {
            background-color: #0056b3;
        }
        button[type="button"] {
            background-color: #6c757d;
        }
        button[type="button"]:hover {
            background-color: #565e64;
        }
    </style>
    <script>
        function openEditModal(mkh, hoten, diachi, dienthoai, ngaysinh, gioitinh, email) {
            document.getElementById("hfMkh").value = mkh;
            document.getElementById("txtHoTen").value = hoten;
            document.getElementById("txtDiaChi").value = diachi;
            document.getElementById("txtDienThoai").value = dienthoai;
            document.getElementById("txtNgaySinh").value = ngaysinh;
            document.getElementById("ddlGioiTinh").value = gioitinh;
            document.getElementById("txtEmail").value = email;

            document.getElementById("Panel1").style.display = 'block';
        }

        function openAddModal() {
            document.getElementById("Panel2").style.display = 'block';
        }

        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }

        function confirmDelete(mkh, hoten) {
            if (confirm("Bạn có chắc muốn xóa " + hoten + "?")) {
                document.getElementById('hfMkhDelete').value = mkh;
                return true;
            }
            return false;
        }

        function navigate(option) {
            switch (option) {
                case 'logout':
                    window.location.href = 'Default.aspx';
                    break;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="treeview">
            <ul>
                <li onclick="document.getElementById('khachHangSection').scrollIntoView()">Quản lý khách hàng</li>
                <li>Quản lý sách</li>
                <li>Quản lý đơn hàng</li>
                <li onclick="navigate('logout')">Đăng xuất</li>
            </ul>
        </div>

        <div class="content">
            <div id="khachHangSection">
                <h2>Quản lý khách hàng</h2>
                <asp:Button ID="btnAddCustomer" runat="server" Text="Thêm mới khách hàng" CssClass="btn" OnClientClick="openAddModal(); return false;" />
                <asp:GridView ID="GrV_Kh" runat="server" AutoGenerateColumns="false" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="Mkh" HeaderText="Mã KH" />
                        <asp:BoundField DataField="Ho_ten" HeaderText="Họ tên" />
                        <asp:BoundField DataField="Dia_chi" HeaderText="Địa chỉ" />
                        <asp:BoundField DataField="Dien_thoai" HeaderText="Điện thoại" />
                        <asp:BoundField DataField="Ngay_sinh" HeaderText="Ngày sinh" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="Gioi_tinh" HeaderText="Giới tính" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <a href="javascript:void(0)" 
                                   onclick='openEditModal(
                                       "<%# Eval("Mkh") %>", 
                                       "<%# Eval("Ho_ten").ToString().Replace("\"", "\\\"") %>", 
                                       "<%# Eval("Dia_chi").ToString().Replace("\"", "\\\"") %>", 
                                       "<%# Eval("Dien_thoai").ToString().Replace("\"", "\\\"") %>", 
                                       "<%# Eval("Ngay_sinh", "{0:yyyy-MM-dd}") %>", 
                                       "<%# Eval("Gioi_tinh") %>", 
                                       "<%# Eval("Email").ToString().Replace("\"", "\\\"") %>"
                                   )'>Sửa</a> | 
                                <asp:LinkButton ID="lnkXoa" runat="server" Text="Xóa"
                                    CommandArgument='<%# Eval("Mkh") %>'
                                    OnClientClick='<%# "return confirmDelete(" + Eval("Mkh") + ", \"" + Eval("Ho_ten") + "\")" %>'
                                    OnClick="btnXoa_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Modal sửa -->
        <div id="Panel1">
            <div class="modal-header">Sửa khách hàng <span class="close-btn" onclick="closeModal('Panel1')">×</span></div>
            <asp:HiddenField ID="hfMkh" runat="server" ClientIDMode="Static" />
            <asp:TextBox ID="txtHoTen" runat="server" placeholder="Họ tên" ClientIDMode="Static" /><br />
            <asp:TextBox ID="txtDiaChi" runat="server" placeholder="Địa chỉ" ClientIDMode="Static" /><br />
            <asp:TextBox ID="txtDienThoai" runat="server" placeholder="Điện thoại" ClientIDMode="Static" /><br />
            <asp:TextBox ID="txtNgaySinh" runat="server" type="date" placeholder="Ngày sinh" ClientIDMode="Static" /><br />
            <asp:DropDownList ID="ddlGioiTinh" runat="server" ClientIDMode="Static">
                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
            </asp:DropDownList><br />
            <asp:TextBox ID="txtEmail" runat="server" placeholder="Email" ClientIDMode="Static" /><br />
            <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave_Click" />
            <button type="button" onclick="closeModal('Panel1')">Hủy</button>
        </div>

        <!-- Modal thêm -->
        <div id="Panel2">
            <div class="modal-header">Thêm khách hàng <span class="close-btn" onclick="closeModal('Panel2')">×</span></div>
            <asp:TextBox ID="hoten" runat="server" placeholder="Họ tên" /><br />
            <asp:TextBox ID="diachi" runat="server" placeholder="Địa chỉ" /><br />
            <asp:TextBox ID="dienthoai" runat="server" placeholder="Điện thoại" /><br />
            <asp:TextBox ID="NgaySINH" runat="server" type="date" placeholder="Ngày sinh" ClientIDMode="Static" /><br />
            <asp:DropDownList ID="GioTinh" runat="server">
                <asp:ListItem Text="Nam" Value="1" />
                <asp:ListItem Text="Nữ" Value="0" />
            </asp:DropDownList><br />
            <asp:TextBox ID="username" runat="server" placeholder="Tên đăng nhập" /><br />
            <asp:TextBox ID="Password" runat="server" TextMode="Password" placeholder="Mật khẩu" /><br />
            <asp:TextBox ID="Email" runat="server" placeholder="Email" /><br />
            <div class="modal-footer">
                <asp:Button ID="btnadd" runat="server" Text="Thêm" CssClass="btn" OnClick="btnadd_Click" />
                <button type="button" onclick="closeModal('Panel2')">Hủy</button>
            </div>
        </div>
        <asp:HiddenField ID="hfMkhDelete" runat="server" />

    </form>
</body>
</html>
