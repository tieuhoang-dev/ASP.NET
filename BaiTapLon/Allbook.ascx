<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Allbook.ascx.cs" Inherits="BaiTapLon.Allbook" %>

<style>
    .books-wrapper {
        max-height: 600px; 
        overflow-y: auto; 
        border: 1px solid #ccc;
        padding: 10px;
        box-sizing: border-box;
        background: #fff;
        border-radius: 6px;
    }

    .book-card {
        display: flex;
        height: 120px;       
        min-height: 120px;
        max-height: 120px;
        border: 1px solid #ddd;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 6px;
        box-sizing: border-box;
        overflow: hidden;
        background-color: #fff;
    }

    .book-card img {
        height: 100px;
        width: 100px;
        object-fit: cover;
        border-radius: 4px;
        flex-shrink: 0;
    }

    .book-info {
        flex: 1;
        padding-left: 15px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        overflow: hidden;
    }

    .book-info h4,
    .book-info p {
        margin: 2px 0;
        font-size: 14px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .book-info h4 {
        font-size: 15px;
        font-weight: bold;
    }

    .book-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 12px;
    }
</style>

<div class="books-wrapper">
    <asp:Repeater ID="rptBooks" runat="server">
<ItemTemplate>
    <a href='<%# Eval("MaSach", "BookDetail.aspx?ms={0}") %>' style="text-decoration: none; color: inherit;">
        <div class="book-card">
            <div>
                <img src='<%# Eval("Hinh_minh_hoa") %>' alt="Hình sách" />
            </div>
            <div class="book-info">
                <div>
                    <h4><%# Eval("Ten_sach") %></h4>
                    <p>Tác giả: <%# Eval("TenTacGia") %></p>
                    <p>Chủ đề: <%# Eval("TenChuDe") %></p>
                </div>
                <div class="book-footer">
                    <span style="color: #e91e63; font-weight: bold;">
                        <%# String.Format("{0:N0} VNĐ", Eval("Don_gia")) %>
                    </span>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <span><i class="fa fa-eye"></i> <%# Eval("So_lan_xem") %></span>
                        <span><i class="fa fa-shopping-cart"></i> <%# Eval("So_luong_ban") %></span>
                    </div>
                </div>
            </div>
        </div>
    </a>
</ItemTemplate>

    </asp:Repeater>
</div>
