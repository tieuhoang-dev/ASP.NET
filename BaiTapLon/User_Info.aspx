<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="User_Info.aspx.cs" Inherits="BaiTapLon.User_Info" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông Tin Người Dùng</title>
        <webopt:bundlereference runat="server" path="~/Content/css" />
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px 0;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            max-width: 1200px;
             margin: 70px auto 40px;
        }

        .card {
            border: none;
            border-radius: 16px;
            background-color: #ffffff;
        }

        .card h4 {
            font-weight: 600;
            color: #343a40;
        }

        .btn {
            border-radius: 8px;
        }

        .table {
            margin-top: 20px;
        }

        .table thead {
            background-color: #dee2e6;
        }

        .shadow-sm {
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        @media (max-width: 768px) {
            .row > div {
                margin-bottom: 20px;
            }
        }
        .modal-content {
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

      .modal-header {
        background-color: #007bff;
        color: white;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
      }

      .modal-footer {
        display: flex;
        justify-content: space-between;
      }

      .form-label {
        font-weight: bold;
      }

      .form-control {
        border-radius: 8px;
        border: 1px solid #ccc;
        transition: border-color 0.3s ease;
      }

      .form-control:focus {
        border-color: #007bff;
      }

      .btn-close {
        background-color: transparent;
        border: none;
        font-size: 1.5rem;
      }

    </style>
    <script type="text/javascript">
        function openModal() {
            var modalElement = document.getElementById('modalThayDoiThongTin');
            var modal = new bootstrap.Modal(modalElement);
            modal.show();
        }
        function openPasswordModal() {
            var modalElement = document.getElementById('modalThayDoiMatKhau');
            var modal = new bootstrap.Modal(modalElement);
            modal.show();
        }
        function confirmHuy(ma) {
            return confirm("" + ma + "?");
        }
    </script>
</head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<body>
    <form id="form1" runat="server">
        <asp:PlaceHolder ID="phHeader" runat="server" />
        <div class="container">
            <div class="row g-4">
                <!-- Cột 1: Thông tin người dùng -->
                <div class="col-md-4">
                    <div class="card p-4 shadow-sm">
                        <h4 class="mb-3">Thông Tin Người Dùng</h4>
                        <p><strong>Họ Tên:</strong> <asp:Label ID="lblHoTen" runat="server" /></p>
                        <p><strong>Giới Tính:</strong> <asp:Label ID="lblGioiTinh" runat="server" /></p>
                        <p><strong>Mã Khách Hàng:</strong> <asp:Label ID="lblMaKH" runat="server" /></p>
                        <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server" /></p>
                        <p><strong>Địa Chỉ:</strong> <asp:Label ID="lblDiaChi" runat="server" /></p>
                        <p><strong>Số Điện Thoại:</strong> <asp:Label ID="lblDienThoai" runat="server" /></p>
                        <hr />
                        <asp:LinkButton ID="lnkThayDoiThongTin" runat="server" CssClass="btn btn-primary w-100 mb-2"
                            OnClientClick="openModal(); return false;">
                            Thay Đổi Thông Tin
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnThayDoiMatKhau" runat="server" CssClass="btn btn-warning w-100"
                            OnClientClick="openPasswordModal(); return false;">
                            Thay Đổi Mật Khẩu
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Cột 2: Danh sách đơn hàng -->
                <div class="col-md-8">
                    <div class="card p-4 shadow-sm" style="height:600px;overflow-y:auto;">
                        <h4 class="mb-3">Danh Sách Đơn Hàng</h4>
                        <asp:GridView ID="gvDonHang" runat="server" CssClass="table table-bordered table-hover "
                            AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="Sdh" HeaderText="Mã Đơn Hàng" />
                                <asp:BoundField DataField="Ngay_dat_hang" HeaderText="Ngày Đặt" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField HeaderText="Chi Tiết Hàng">
                                    <ItemTemplate>
                                        <%# Eval("Chi_tiet_hang").ToString().Replace(";", "<br/>") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Tri_gia" HeaderText="Trị Giá" DataFormatString="{0:N0}" />
                                <asp:BoundField DataField="Trang_thai_giao_hang" HeaderText="Trạng Thái" />
                                <asp:TemplateField HeaderText="Hành Động">
                                <ItemTemplate>
                                    <asp:LinkButton 
                                        ID="lnkHuyDon" 
                                        runat="server"
                                        CommandArgument='<%# Eval("Sdh") %>' 
                                        Text="Hủy Đơn"
                                        OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmHuy(\"Bạn chắc muốn HỦY đơn hàng #" + Eval("Sdh") + "?\")" : "return false;" %>'
                                        OnClick="btnHuyDon_Click"
                                        CssClass='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "btn btn-danger btn-sm" : "btn btn-secondary btn-sm disabled" %>' 
                                    />
                                </ItemTemplate>
                            </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <!-- Modal Thay Đổi Thông Tin -->
            <div class="modal fade" id="modalThayDoiThongTin" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Thay Đổi Thông Tin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                  </div>
                  <div class="modal-body">
                    <div class="mb-3">
                      <label for="txtHoTen" class="form-label">Họ Tên</label>
                      <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                      <label for="txtDiaChi" class="form-label">Địa Chỉ</label>
                      <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                      <label for="txtDienThoai" class="form-label">Số Điện Thoại</label>
                      <asp:TextBox ID="txtDienThoai" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                      <label for="txtEmail" class="form-label">Email</label>
                      <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                    </div>
                    <div class="mb-3">
                      <label for="txtNgaySinh" class="form-label">Ngày Sinh</label>
                      <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="mb-3">
                      <label for="ddlGioiTinh" class="form-label">Giới Tính</label>
                      <asp:DropDownList ID="ddlGioiTinh" runat="server" CssClass="form-control">
                         <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                         <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                      </asp:DropDownList>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <asp:Button ID="btnLuuThongTin" runat="server" CssClass="btn btn-success" Text="Lưu Thay Đổi" OnClick="btnchangeinfo_click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  </div>
                </div>
              </div>
            </div>
            <!-- Modal Thay Đổi Mật Khẩu -->
            <div class="modal fade" id="modalThayDoiMatKhau" tabindex="-1" aria-labelledby="modalPasswordLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="modalPasswordLabel">Thay Đổi Mật Khẩu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                  </div>
                  <div class="modal-body">
                    <div class="mb-3">
                      <label for="txtTenDangNhap" class="form-label">Tên Đăng Nhập</label>
                      <asp:TextBox ID="txtTenDangNhap" runat="server" CssClass="form-control" ReadOnly="true" />
                    </div>
                    <div class="mb-3">
                      <label for="txtMatKhauCu" class="form-label">Mật Khẩu Cũ</label>
                      <asp:TextBox ID="txtMatKhauCu" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <div class="mb-3">
                      <label for="txtMatKhauMoi" class="form-label">Mật Khẩu Mới</label>
                      <asp:TextBox ID="txtMatKhauMoi" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                  </div>
                  <div class="modal-footer">
                    <asp:Button ID="btnLuuMatKhau" runat="server" CssClass="btn btn-success" Text="Lưu Mật Khẩu" OnClick="btnLuuMatKhau_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  </div>
                </div>
              </div>
            </div>

        </div>
    </form>
</body>
</html>
