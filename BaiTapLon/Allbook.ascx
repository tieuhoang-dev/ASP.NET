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
                <asp:LinkButton runat="server" 
                    OnClientClick='<%# "openModal(\"" + Eval("MaSach") + "\"); return false;" %>' 
                    CssClass="btn-buy-now" CommandArgument='<%# Eval("MaSach") %>'>
                    <i class="fa fa-credit-card"></i> Mua ngay
                </asp:LinkButton>
            </div>
        </div>
    </a>
</ItemTemplate>


    </asp:Repeater>

    <!-- Modal dialog -->
        <div id="buyNowModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%);
            background:white; padding:20px; border-radius:8px; box-shadow:0 0 10px rgba(0,0,0,0.3); z-index:1000;">
            <h3>Mua sách</h3>
            <div style="margin-bottom:10px;">
                <strong>Mã sách:</strong> <asp:Literal ID="litMaSach" runat="server" />
            </div>
            <asp:HiddenField ID="hfMaSach" runat="server" />
            <div>
                <label>Số lượng:</label>
                <asp:TextBox ID="txtQuantity" runat="server" Text="1" Width="50px"></asp:TextBox>
            </div>
            <div style="margin-top:10px;">
                <label>Địa chỉ giao hàng:</label><br />
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" Columns="30"></asp:TextBox>
            </div>
            <div style="margin-top:15px; text-align:right;">
            <asp:LinkButton ID="lnkMua" runat="server" Text="Mua" CommandArgument='<%# Eval("MaSach") %>' OnClick="btnConfirmOrder_Click" />
                <button type="button" onclick="closeModal()">Hủy</button>
            </div>
        </div>

        <!-- Overlay -->
        <div id="modalOverlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.5); z-index:999;" onclick="closeModal()"></div>

        <script type="text/javascript">
            function openModal(maSach) {
                alert("Mở modal với mã sách: " + maSach);
                document.getElementById('<%= hfMaSach.ClientID %>').value = maSach;
                document.getElementById('buyNowModal').style.display = 'block';
                document.getElementById('modalOverlay').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('buyNowModal').style.display = 'none';
                document.getElementById('modalOverlay').style.display = 'none';
            }
        </script>

</div>
