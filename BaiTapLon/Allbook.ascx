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
        height: 150px;       
        min-height: 150px;
        max-height: 150px;
        border: 1px solid #ddd;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 6px;
        box-sizing: border-box;
        overflow: hidden;
        background-color: #fff;
    }

    .book-card img {
        height: 140px;
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

<div class="books-wrapper">
<asp:Repeater ID="rptBooks" runat="server">
<ItemTemplate>
    <a href='<%# Eval("Ms", "BookDetail.aspx?ms={0}") %>' style="text-decoration: none; color: inherit;">
        <div class="book-card">
            <div>
            <img src='<%# ResolveUrl("~/Images/") + Eval("Hinh_minh_hoa") %>' alt="Hình sách" />            

            </div>
            <div class="book-info">
                <div>
                    <h4><%# Eval("Ten_sach") %></h4>
                    <p>Tác giả: <%# Eval("DanhSachTacGia") %></p>
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
                </a>
    <div class="book-actions">
               <asp:Panel ID="pnlButtons" runat="server" Visible='<%# Eval("Trang_Thai").ToString() == "1" %>'>
               <asp:LinkButton runat="server" CssClass="btn-buy-now" 
                    data-masach='<%# Eval("Ms") %>' 
                    data-tensach='<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>' 
                    data-dongia='<%# String.Format("{0:0}", Eval("Don_gia")) %>'
                    OnClientClick="openModal(this.getAttribute('data-masach'), this.getAttribute('data-tensach'), this.getAttribute('data-dongia')); return false;">
                    <i class="fa fa-credit-card"></i> Mua ngay
                </asp:LinkButton>
                
                 <asp:LinkButton runat="server"
                    CssClass="btn-add-to-cart"
                    OnClientClick='<%# "addToCart(\"" + Eval("Ms") + "\"); return false;" %>'>
                    <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                </asp:LinkButton>
                </asp:Panel>
                <asp:Label ID="lbl_Nkd" runat="server" Text="Ngừng Kinh Doanh" Visible='<%# Eval("Trang_Thai").ToString() != "1" %>' CssClass="text-muted" />
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
                    const maSach = this.getAttribute('data-Ms');
                    const tenSach = this.getAttribute('data-tensach');
                    const donGia = parseInt(this.getAttribute('data-dongia'));
                    openModal(maSach, tenSach, donGia);
                });
            });

            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('.btn-add-to-cart').forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        const maSach = this.getAttribute('data-Ms');
                        addToCart(maSach);
                    });
                });
            });
        }
        
    </script>
</div>
