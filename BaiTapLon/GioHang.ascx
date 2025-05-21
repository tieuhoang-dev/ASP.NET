<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GioHang.ascx.cs" Inherits="BaiTapLon.GioHang" %>

<style>
    .giohang-container {
        width: 100%;
        max-width: 400px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 0;
        font-family: 'Segoe UI', sans-serif;
        display: flex;
        flex-direction: column;
        height: 350px; 
    }

    .giohang-title {
        font-size: 20px;
        font-weight: bold;
        color: #e91e63;
        padding: 16px;
        border-bottom: 1px solid #eee;
    }

    .giohang-scroll {
        overflow-y: auto;
        padding: 0 16px;
        flex: 1;
    }

    .cart-item {
        border-bottom: 1px solid #eee;
        padding: 10px 0;
    }

    .cart-item:last-child {
        border-bottom: none;
    }

    .item-header {
        font-size: 16px;
        font-weight: 600;
    }

    .item-sub {
        font-size: 13px;
        color: #666;
        margin-top: 4px;
    }

    .item-actions {
        text-align: right;
        margin-top: 4px;
    }

    .item-actions a {
        color: #d9534f;
        text-decoration: none;
        font-size: 13px;
    }

    .giohang-footer-fixed {
        padding: 12px 16px;
        border-top: 1px solid #eee;
        background: #fafafa;
    }

    .giohang-total {
        font-size: 16px;
        font-weight: bold;
        text-align: right;
        color: #333;
        margin-bottom: 8px;
    }

    .giohang-link {
        text-align: right;
    }

    .giohang-link a {
        font-size: 14px;
        color: #007bff;
        text-decoration: none;
    }

    .giohang-empty {
        font-style: italic;
        color: #999;
        text-align: center;
        margin-top: 20px;
    }
</style>

<div class="giohang-container">
    <div class="giohang-title">Giỏ Hàng</div>

    <div class="giohang-scroll">
        <asp:Repeater ID="rptGioHang" runat="server" OnItemCommand="rptGioHang_ItemCommand">
            <ItemTemplate>
                <div class="cart-item">
                    <div class="item-header">
                        <%# Eval("TenSach") %> x <%# Eval("SoLuong") %>
                    </div>
                    <div class="item-sub">
                        <%# string.Format("{0:N0} VNĐ", Eval("DonGia")) %>
                    </div>
                    <div class="item-actions">
                        <asp:LinkButton ID="btnXoa" runat="server"
                            CommandName="Xoa"
                            CommandArgument='<%# Eval("MaSach") %>'
                            Text="Xóa"
                            OnClientClick="return confirm('Bạn có chắc muốn xóa không?');" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Label ID="lblEmpty" runat="server" CssClass="giohang-empty" Visible="false" Text="Giỏ hàng trống."></asp:Label>
    </div>

    <div class="giohang-footer-fixed">
        <div class="giohang-total">
            Tổng tiền: <asp:Label ID="lblTongTien" runat="server" Text="0 VNĐ" />
        </div>
        <div class="giohang-link">
            <asp:HyperLink ID="lnkXemGioHang" runat="server" NavigateUrl="~/ChiTietGioHang.aspx" Text="Xem toàn bộ giỏ hàng" />
        </div>
    </div>
</div>
