<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BookOfGenre.ascx.cs" Inherits="BaiTapLon.BookOfGenre" %>

<style>
    .books-wrapper {
        height: 550px; 
        overflow-y: auto;
        border: 1px solid #ccc;
        padding: 10px;
        box-sizing: border-box;
        border-radius: 6px;
        background-color: #fff;
    }
    .btn-buy-now {
    background-color: #4CAF50;
    color: white;
    border: none;
    padding: 5px 10px;
    font-size: 12px;
    border-radius: 4px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    text-decoration: none;
    }

    .btn-buy-now:hover {
        background-color: #45a049;
        text-decoration: none;
        color: white;
    }
    .btn-add-to-cart {
    background-color: #2196F3; 
    color: white;
    border: none;
    padding: 5px 10px;
    font-size: 12px;
    border-radius: 4px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    text-decoration: none;
}

    .btn-add-to-cart:hover {
        background-color: #1976D2;
        color: white;
    }
    .book-actions {
        display: flex;
        gap: 10px;
        margin-top: 8px;
}
</style>

<div style="text-align: center; font-weight: bold; font-size: 24px; margin-bottom: 20px;">
    Sách thuộc thể loại <%= TenChuDe %>
</div>

<div class="books-wrapper">
    <asp:Repeater ID="rptBookOfGenre" runat="server">
        <ItemTemplate>
            <a href='<%# Eval("MaSach", "BookDetail.aspx?ms={0}") %>' style="text-decoration: none; color: inherit;">
            <div style="display: flex; border: 1px solid #ddd; padding: 10px; margin-bottom: 10px; border-radius: 6px;">
                <div style="flex: 0 0 100px;">
                    <img src='<%# Eval("Hinh_minh_hoa") %>' alt="Hình sách" style="height: 100px; object-fit: cover; border-radius: 4px;" />
                </div>
                <div style="flex: 1; padding-left: 15px; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <h4 style="margin: 0;"><%# Eval("Ten_sach") %></h4>
                        <p style="margin: 2px 0; font-size: 14px; color: #555;">Tác giả: <%# Eval("DanhSachTacGia") %></p>
                        <p style="margin: 2px 0; font-size: 14px; color: #777;">Chủ đề: <%# Eval("TenChuDe") %></p>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: end;">
                        <span style="font-weight: bold; color: #e91e63;"><%# String.Format("{0:N0} VNĐ", Eval("Don_gia")) %></span>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <span><i class="fa fa-eye"></i> <%# Eval("So_lan_xem") %></span>
                            <span><i class="fa fa-shopping-cart"></i> <%# Eval("So_luong_ban") %></span>
                        </div>
                    </div
                    </a>
                    <div class="book-actions">
                       <asp:LinkButton runat="server" CssClass="btn-buy-now" 
                            data-masach='<%# Eval("MaSach") %>' 
                            data-tensach='<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>' 
                            data-dongia='<%# String.Format("{0:0}", Eval("Don_gia")) %>'
                            OnClientClick="openModal(this.getAttribute('data-masach'), this.getAttribute('data-tensach'), this.getAttribute('data-dongia')); return false;">
                            <i class="fa fa-credit-card"></i> Mua ngay
                        </asp:LinkButton>
            
                        <asp:LinkButton runat="server"
                            CssClass="btn-add-to-cart"
                            data-masach='<%# Eval("MaSach") %>'
                            data-tensach='<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>'
                            data-dongia='<%# String.Format("{0:0}", Eval("Don_gia")) %>'>
                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                        </asp:LinkButton>
                    </div>

                </div>
            </div>
            
        </ItemTemplate>
    </asp:Repeater>
     <script>
         document.addEventListener('DOMContentLoaded', function () {
             document.querySelectorAll('.btn-buy-now').forEach(btn => {
                 btn.addEventListener('click', function (e) {
                     e.preventDefault();
                     const maSach = this.getAttribute('data-masach');
                     const tenSach = this.getAttribute('data-tensach');
                     const donGia = parseInt(this.getAttribute('data-dongia'));
                     openModal(maSach, tenSach, donGia);
                 });
             });

             document.querySelectorAll('.btn-add-to-cart').forEach(btn => {
                 btn.addEventListener('click', function (e) {
                     e.preventDefault();
                     const maSach = this.getAttribute('data-masach');
                     const tenSach = this.getAttribute('data-tensach');
                     const donGia = parseInt(this.getAttribute('data-dongia'));
                     openCartDialog(maSach, tenSach, donGia);
                 });
             });
         });
     </script>
</div>
