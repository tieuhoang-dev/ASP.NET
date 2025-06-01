<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Lab05.Admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin</title>
        <link href="Admin.css" rel="stylesheet" type="text/css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

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
                    <asp:BoundField DataField="MaSach" HeaderText="Mã Sách " />
                    <asp:BoundField DataField="Ten_sach" HeaderText="Tên Sách" />
                    <asp:TemplateField HeaderText="Đơn Giá (VND)">
                        <ItemTemplate>
                            <%# String.Format("{0:N0} ", Eval("Don_gia")) %>
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:BoundField DataField="Mo_ta" HeaderText="Mô Tả" />
                    <asp:BoundField DataField="TenChuDe" HeaderText="Thể Loại" />
                    <asp:BoundField DataField="Ngay_cap_nhat" HeaderText="Ngày Cập Nhật" DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="TenTacGia" HeaderText="Tác Giả" />
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
                                "<%# Eval("MaSach") %>", 
                                "<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("TenTacGia").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("Mo_ta").ToString().Replace("\"", "\\\"") %>", 
                                "<%# Eval("Don_gia") %>"
                            )'><i class="fas fa-edit"></i></a> |<asp:LinkButton ID="lnkXoa" CssClass="fa fa-trash" runat="server" 
                            CommandArgument='<%# Eval("MaSach") %>'
                            OnClientClick='<%# "return confirmDelete(" + Eval("MaSach") + ", \"" + Eval("Ten_sach") + "\")" %>'
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
                            OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmGiao(\"Xác nhận đơn hàng #" + Eval("Sdh") + " đã được giao?\")" : "return false;" %>'
                            OnClick="btnXacNhanGiao_Click"
                            CssClass='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "fa fa-truck btn-active" : "fa fa-truck btn-disabled" %>' />
                        |
                        <!-- Nút hủy đơn hàng -->
                        <asp:LinkButton ID="lnkHuyDon" runat="server"
                            CommandArgument='<%# Eval("Sdh") %>'
                            OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmHuy(\"Bạn chắc muốn HỦY đơn hàng #" + Eval("Sdh") + "?\")" : "return false;" %>'
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
            <asp:TextBox ID="txt_tg" runat="server" placeholder="Tác Giả " ClientIDMode="Static" /><br />
            <asp:Button ID="btn_save" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave1_Click" />
            <button type="button" onclick="closeModal('Panel_suasach')">Hủy</button>
        </div>
        <asp:HiddenField ID="hfSection" runat="server" ClientIDMode="Static" />
        <!-- Modal Thêm Sách -->
        <div id="Panel3">
    <div class="modal-header">
        Thêm Sách  
        <span class="close-btn" onclick="closeModal('Panel3')">×</span>
    </div>

    <asp:TextBox ID="txt_tensach" runat="server" placeholder="Tên Sách" CssClass="input" /><br />

    <asp:TextBox ID="txt_dongia" runat="server" placeholder="Đơn Giá" CssClass="input" /><br />

    <asp:TextBox ID="txt_mota" runat="server" placeholder="Mô Tả" 
        TextMode="MultiLine" Rows="5" Columns="58" CssClass="input" /><br />

    <asp:TextBox ID="txt_tacgia" runat="server" placeholder="Tác Giả" 
        ClientIDMode="Static" CssClass="input" /><br />

    <asp:DropDownList ID="ddl_Theloai" runat="server" CssClass="input">
    </asp:DropDownList><br />

    <label>Hình minh họa:</label><br />
    <asp:FileUpload ID="fu_hinh" runat="server" CssClass="input" /><br /><br />

    <div class="modal-footer">
        <asp:Button ID="Btn_addSach" runat="server" Text="Thêm" 
            CssClass="btn" OnClick="btnThem_Click" />
        <button type="button" onclick="closeModal('Panel3')">Hủy</button>
    </div>
</div>

    </form>
</body>
</html>
