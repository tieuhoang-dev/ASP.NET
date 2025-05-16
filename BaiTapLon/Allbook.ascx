<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Allbook.ascx.cs" Inherits="BaiTapLon.Allbook" %>

<asp:Repeater ID="rptBooks" runat="server">
    <ItemTemplate>
        <div style="display: flex; border: 1px solid #ddd; padding: 10px; margin-bottom: 10px; border-radius: 6px;">
            <div style="flex: 0 0 100px;">
                <img src='<%# Eval("Hinh_minh_hoa") %>' alt="Hình sách" style="height: 100px; object-fit: cover; border-radius: 4px;" />
            </div>
            <div style="flex: 1; padding-left: 15px; display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <h4 style="margin: 0;"><%# Eval("Ten_sach") %></h4>
                    <p style="margin: 2px 0; font-size: 14px; color: #555;">Tác giả: <%# Eval("TenTacGia") %></p>
                    <p style="margin: 2px 0; font-size: 14px; color: #777;">Chủ đề: <%# Eval("TenChuDe") %></p>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: end;">
                    <span style="font-weight: bold; color: #e91e63;"><%# String.Format("{0:N0} VNĐ", Eval("Don_gia")) %></span>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <span><i class="fa fa-eye"></i> <%# Eval("So_lan_xem") %></span>
                        <span><i class="fa fa-shopping-cart"></i> <%# Eval("So_luong_ban") %></span>
                    </div>
                </div>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>
