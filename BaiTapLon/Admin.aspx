<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Lab05.Admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
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
            max-height: 620px;
            overflow-y: auto;
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

        #Panel1, #Panel2, #Panel_suasach {
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
        .input {
            width: 90%;
            padding: 6px;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .btn {
            padding: 6px 16px;
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
        }

            .btn:hover {
                background-color: #0056b3;
            }
        .btn-active {
            color: #007bff; 
            cursor: pointer;
            text-decoration: none;
        }

        .btn-disabled {
            color: gray;
            cursor: default;
            pointer-events: none;
            opacity: 0.5; 
        }
        #Panel3.modal-wide {
            display: none;
            position: fixed;
            top: 40px;
            left: 50%;
            transform: translateX(-50%);
            width: 910px; 
            background-color: white;
            padding: 0;
            border: 2px solid #007BFF;
            border-radius: 10px;
            z-index: 9999;
            box-shadow: 0 0 20px rgba(0,0,0,0.25);
            max-height: 90vh;
            overflow: hidden;
            flex-direction: column;
        }

        .modal-header {
            padding: 15px 20px;
            font-weight: bold;
            font-size: 18px;
            background: white;
            border-bottom: 1px solid #ccc;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        .modal-body-two-column {
            display: flex;
            gap: 20px;
            padding: 20px;
            overflow-y: auto;
            flex: 1 1 auto;
        }

        .modal-left, .modal-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #ccc;
            background: #f8f8f8;
            text-align: right;
            position: sticky;
            bottom: 0;
            z-index: 1;
        }

        .close-btn {
            position: absolute;
            right: 15px;
            top: 10px;
            color: red;
            font-size: 22px;
            cursor: pointer;
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
        function openAddBookModal() {
            document.getElementById("Panel3").style.display = 'block';
        }
        function OpenEditBookModal(masach, tensach, tentacgia, mota, dongia) {
            var formattedPrice = parseFloat(dongia).toString();
            document.getElementById("hf_ms").value = masach;
            document.getElementById("txt_ms").value = masach;
            document.getElementById("txt_ts").value = tensach;
            document.getElementById("txt_dg").value = formattedPrice;
            document.getElementById("txt_mt").value = mota;
            document.getElementById("txt_tg").value = tentacgia;

            document.getElementById("Panel_suasach").style.display = 'block';
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
        function showSection(sectionName) {
            document.getElementById("khachHangSection").style.display = "none";
            document.getElementById("SachSection").style.display = "none";
            document.getElementById("Section_Don_Hang").style.display = "none";

            if (sectionName === "khachhang")
                document.getElementById("khachHangSection").style.display = "block";
            else if (sectionName === "sach")
                document.getElementById("SachSection").style.display = "block";
            else if (sectionName == "donhang")
                document.getElementById("Section_Don_Hang").style.display = "block";
        }
        function confirmGiao(ma) {
            return confirm("Xác nhận đơn hàng #" + ma + " đã được giao?");
        }

        function confirmHuy(ma) {
            return confirm("Bạn thật sự muốn hủy đơn hàng #" + ma + "?");
        }
        function showModal(id) {
            document.getElementById(id).style.display = 'block';
        }

        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="treeview">
            <ul>
                <li onclick="showSection('khachhang'); document.getElementById('hfSection').value = 'khachhang';">Quản lý khách hàng</li>
                <li onclick="showSection('sach'); document.getElementById('hfSection').value = 'sach';">Quản lý sách</li>
                <li onclick="showSection('donhang'); document.getElementById('hfSection').value = 'donhang';">Quản lý đơn hàng</li>
                <li onclick="navigate('logout')">Đăng xuất</li>
            </ul>
        </div>

        <div class="content">
            <div id="khachHangSection" runat="server">
                <div style="position: sticky; top: 0; background: white; padding: 15px; border-bottom: 1px solid #ddd; z-index: 10;">
                <h2>Quản lý khách hàng</h2>
                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-primary"
                    OnClientClick="openAddModal(); return false;">
                    <i class="fas fa-plus"></i> Thêm Khách Hàng Mới 
                </asp:LinkButton>

                </div>
                <div style="max-height: 620px; overflow-y: auto;">
                <asp:GridView ID="GrV_Kh" runat="server" AutoGenerateColumns="false" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="Mkh" HeaderText="Mã KH" />
                        <asp:BoundField DataField="Ho_ten" HeaderText="Họ tên" />
                        <asp:BoundField DataField="Dia_chi" HeaderText="Địa chỉ" />
                        <asp:BoundField DataField="Dien_thoai" HeaderText="Điện thoại" />
                        <asp:BoundField DataField="Ngay_sinh" HeaderText="Ngày sinh" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Giới tính">
                            <ItemTemplate>
                                <%# (bool)Eval("Gioi_tinh") ? "Nam" : "Nữ" %>
                            </ItemTemplate>
                        </asp:TemplateField>
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
                                   )'><i class="fas fa-edit"></i></a> | 
                                <asp:LinkButton ID="lnkXoa" runat="server" CssClass="fas fa-trash"
                                    CommandArgument='<%# Eval("Mkh") %>'
                                    OnClientClick='<%# "return confirmDelete(" + Eval("Mkh") + ", \"" + Eval("Ho_ten") + "\")" %>'
                                    OnClick="btnXoa_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                </div>
            </div>
            <div id="SachSection" runat="server" style="display:none;">
            <div style="position: sticky; top: 0; background: white; padding: 15px; border-bottom: 1px solid #ddd; z-index: 10;">
            <h2>Quản lý Sách</h2>
            <asp:LinkButton ID="btnThemSach" runat="server" CssClass="btn btn-primary"
                OnClientClick="openAddBookModal(); return false;">
                <i class="fas fa-plus"></i> Thêm Sách Mới
            </asp:LinkButton>
            </div>
            <div style="max-height: 500px; overflow-y: auto;">
            <asp:GridView ID="Grv_Sach" runat="server" AutoGenerateColumns="false" CssClass="table">
                <Columns>
                    <asp:BoundField DataField="Ms" HeaderText="Mã Sách " />
                    <asp:BoundField DataField="Ten_sach" HeaderText="Tên Sách" />
                    <asp:TemplateField HeaderText="Đơn Giá (VND)">
                        <ItemTemplate>
                            <%# String.Format("{0:N0} ", Eval("Don_gia")) %>
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:BoundField DataField="Mo_ta" HeaderText="Mô Tả" />
                    <asp:BoundField DataField="TenChuDe" HeaderText="Thể Loại" />
                    <asp:BoundField DataField="Ngay_cap_nhat" HeaderText="Ngày Cập Nhật" DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="DanhSachTacGia" HeaderText="Tác Giả" />
                    <asp:TemplateField HeaderText="Số Lượng Bán">
                        <ItemTemplate>
                            <%# String.Format("{0:N0} ", Eval("So_luong_ban")) %>
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:BoundField DataField="So_lan_xem" HeaderText="Lượt Xem" />
                    <asp:TemplateField HeaderText="Thao tác">
                    <ItemTemplate>
                        <a href="javascript:void(0)" 
                           onclick='OpenEditBookModal(
                                "<%# Eval("Ms") %>", 
                                "<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("DanhSachTacGia").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("Mo_ta").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("Don_gia") %>"
                            )'><i class="fas fa-edit"></i></a> |<asp:LinkButton ID="lnkXoa" CssClass="fa fa-trash" runat="server" 
                            CommandArgument='<%# Eval("Ms") %>'
                            OnClientClick='<%# "return confirmDelete(" + Eval("Ms") + ", \"" + Eval("Ten_sach") + "\")" %>'
                            OnClick="btnXoaSach_Click" />
                    </ItemTemplate>
                </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        </div>
            <div id="Section_Don_Hang" runat="server" style="display:none;">
            <div style="position: sticky; top: 0; background: white; padding: 15px; border-bottom: 1px solid #ddd; z-index: 10;">
            <h2>Quản lý đơn đặt hàng</h2>
            </div>
            <div style="max-height: 500px; overflow-y: auto;">
            <asp:GridView ID="Grv_don_hang" runat="server" AutoGenerateColumns="false" CssClass="table" OnRowDataBound="gvDonHang_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Sdh" HeaderText="Số Đơn Hàng  " />
                    <asp:BoundField DataField="Ten_khach_hang" HeaderText="Tên Khách Hàng " />
                    <asp:BoundField DataField="Ngay_dat_hang" HeaderText="Ngày Đặt Hàng " DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="Trang_thai_giao_hang" HeaderText="Trạng Thái Giao Hàng" />
                    <asp:BoundField DataField="Ngay_giao_hang" HeaderText="Ngày Giao Hàng" DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:TemplateField HeaderText="Chi Tiết Hàng">
                        <ItemTemplate>
                            <%# Eval("Chi_tiet_hang").ToString().Replace(";", "<br/>") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tổng Tiền  (VND)">
                        <ItemTemplate>
                            <%# String.Format("{0:N0} ", Eval("Tri_gia")) %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thao tác">
                    <ItemTemplate>
                        <!-- Nút xác nhận giao hàng -->
                        <asp:LinkButton ID="lnkGiaoHang" runat="server"
                            CommandArgument='<%# Eval("Sdh") %>'
                            OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmGiao(\"" + Eval("Sdh") + "\")" : "return false;" %>'
                            OnClick="btnXacNhanGiao_Click"
                            CssClass='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "fa fa-truck btn-active" : "fa fa-truck btn-disabled" %>' />
                        |
                        <!-- Nút hủy đơn hàng -->
                        <asp:LinkButton ID="lnkHuyDon" runat="server"
                            CommandArgument='<%# Eval("Sdh") %>'
                            OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmHuy(\"" + Eval("Sdh") + "?\")" : "return false;" %>'
                            OnClick="btnHuyDon_Click"
                            CssClass='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "fa fa-trash btn-active" : "fa fa-trash btn-disabled" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
         
                </Columns>
            </asp:GridView>
        </div>
        </div>
        </div>
        <!-- Modal sửa khách hàng-->
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
        <asp:HiddenField ID="hfMkhDelete" runat="server" />
        <!-- Modal thêm khách hàng-->
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
        <!-- Modal sửa thông tin sách -->
        <div id="Panel_suasach">
            <div class="modal-header">Sửa thông tin sách  <span class="close-btn" onclick="closeModal('Panel_suasach')">×</span></div>
            <asp:HiddenField ID="hf_ms" runat="server" ClientIDMode="Static" />
            <asp:TextBox ID="txt_ms" runat="server" placeholder="Mã Sách " ClientIDMode="Static" ReadOnly="true" /><br />
            <asp:TextBox ID="txt_ts" runat="server" placeholder="Tên Sách" ClientIDMode="Static" /><br />
            <asp:TextBox ID="txt_dg" runat="server" placeholder="Đơn Giá" ClientIDMode="Static" /><br />
            <asp:TextBox ID="txt_mt" runat="server" placeholder="Mô Tả" ClientIDMode="Static" TextMode="MultiLine" Rows="5" Columns="58"/><br />
            <asp:DropDownList ID="drl_cd" runat="server" ClientIDMode="Static">
            </asp:DropDownList><br />
            <asp:DropDownList ID="drl_nxb" runat="server" ClientIDMode="Static">
            </asp:DropDownList><br />
            <asp:TextBox ID="txt_tg" runat="server" placeholder="Tác Giả:Vai Trò " ClientIDMode="Static" /><br />
            <asp:Button ID="btn_save" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave1_Click" />
            <button type="button" onclick="closeModal('Panel_suasach')">Hủy</button>
        </div>
        <asp:HiddenField ID="hfSection" runat="server" ClientIDMode="Static" />
        <!-- Modal Thêm Sách -->
       <div id="Panel3" class="modal-wide">
            <div class="modal-header">
                <h4>Thêm Sách</h4>
                <span class="close-btn" onclick="closeModal('Panel3')">×</span>
            </div>

            <div class="modal-body-two-column">
                <!-- Cột trái -->
                <div class="modal-left">
                    <asp:TextBox ID="txt_tensach" runat="server" CssClass="form-control" Placeholder="Tên sách" />

                    <asp:TextBox ID="txt_dongia" runat="server" CssClass="form-control" Placeholder="Đơn giá"/>

                    <asp:TextBox ID="txt_mota" runat="server" TextMode="MultiLine" Rows="6" CssClass="form-control" Placeholder="Mô tả" />

                    <label></label>
                    <asp:TextBox ID="txt_tacgia" runat="server" CssClass="form-control"
                        Placeholder="Tác giả:Vai trò" />

                    <label>Hình minh họa:</label>
                    <asp:FileUpload ID="fu_hinh" runat="server" CssClass="form-control" />
                </div>

                <!-- Cột phải -->
                <div class="modal-right">
                    <label>Chủ đề:</label>
                    <asp:DropDownList ID="ddl_Theloai" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_Theloai_SelectedIndexChanged" />
                    <asp:TextBox ID="txtChuDeMoi" runat="server" CssClass="form-control mb-2" Placeholder="Chủ đề mới" Visible="false" />

                    <label>Nhà xuất bản:</label>
                    <asp:DropDownList ID="ddl_NXB" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_NXB_SelectedIndexChanged" />

                    <asp:Panel ID="pnlNXBMoi" runat="server" Visible="false">
                        <asp:TextBox ID="txtTenNXB" runat="server" CssClass="form-control mb-1" placeholder="Tên NXB" />
                        <asp:TextBox ID="txtDiaChiNXB" runat="server" CssClass="form-control mb-1" placeholder="Địa chỉ" />
                        <asp:TextBox ID="txtDienThoaiNXB" runat="server" CssClass="form-control mb-2" placeholder="Điện thoại" />
                    </asp:Panel>

                    
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="Btn_addSach" runat="server" Text="Thêm" CssClass="btn btn-primary" OnClick="btnThem_Click" />
                <button type="button" class="btn btn-secondary" onclick="closeModal('Panel3')">Hủy</button>
            </div>
        </div>


    </form>
</body>
</html>
