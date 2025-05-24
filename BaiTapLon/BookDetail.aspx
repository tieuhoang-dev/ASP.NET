<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookDetail.aspx.cs" EnableSessionState="True" Inherits="BaiTapLon.BookDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chi Tiết Sách</title>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .book-detail-container {
            max-width: 900px;
            margin: 70px auto 40px;
            display: flex;
            gap: 25px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            font-family: Arial, sans-serif;
        }
        .book-image img {
            width: 220px;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
        }
        .book-info h2 {
            color: #d6336c;
        }
        .book-info p {
            margin: 8px 0;
        }
        .btn-open-modal {
            margin-right: 12px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        /* Modal chung */
        #buyNowModal, #cartModal {
            display: none;
            position: fixed;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
            z-index: 1000;
            width: 400px;
        }
        #modalOverlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        /* Modal content */
        .modal-content h3 {
            margin-bottom: 15px;
        }
        .modal-content label {
            font-weight: 600;
        }
        .modal-content .actions {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:PlaceHolder ID="phHeader" runat="server" />

        <div class="book-detail-container">
            <div class="book-image">
                <asp:Image ID="imgBook" runat="server" CssClass="img-fluid" />
            </div>
            <div class="book-info flex-grow-1">
                <h2><asp:Label ID="lblTenSach" runat="server" /></h2>
                <p><b>Tác giả:</b> <asp:Label ID="lblTacGia" runat="server" /></p>
                <p><b>Thể loại:</b> <asp:Label ID="lblChuDe" runat="server" /></p>
                <p><b>Giá:</b> <asp:Label ID="lblDonGia" runat="server" /></p>
                <p><b>Mô tả:</b><br /><asp:Label ID="lblMoTa" runat="server" /></p>
                <p>
                    <b>Lượt xem:</b> <asp:Label ID="lblXem" runat="server" /> |
                    <b>Đã bán:</b> <asp:Label ID="lblBan" runat="server" />
                </p>
                <asp:LinkButton ID="btnShowOrderModal" runat="server" CssClass="btn btn-success btn-open-modal" OnClientClick="showOrderModal(); return false;">
                    <i class="fas fa-credit-card"></i> Đặt hàng ngay
                </asp:LinkButton>
                <asp:LinkButton ID="btnShowCartModal" runat="server" CssClass="btn btn-primary btn-open-modal" OnClientClick="showCartModal(); return false;">
                    <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                </asp:LinkButton>
                <p><asp:Label ID="lblCartCount" runat="server" ForeColor="Red" /></p>
                <p><asp:Label ID="lblDebugCart" runat="server" ForeColor="Blue" /></p>
            </div>
        </div>

        <!-- Modal giỏ hàng thủ công -->
        <div id="cartModal">
            <div class="modal-content">
                <h3>Thêm vào giỏ hàng</h3>
                <h6 id="cartBookTitle"></h6>
                <p>Giá: <span id="cartBookPrice"></span> VNĐ</p>
                <label for="cartQuantity">Số lượng:</label>
                <input type="number" id="cartQuantity" class="form-control" value="1" min="1" />
                <p>Thành tiền: <strong id="cartTotalPrice"></strong> VNĐ</p>
                <div class="actions text-end mt-3">
                    <asp:HiddenField ID="hfQuantityCart" runat="server" />
                    <asp:HiddenField ID="hfMaSachCart" runat="server" />
                    <asp:Button ID="btnAddToCart" runat="server" Text="Thêm vào giỏ hàng" CssClass="btn btn-success" OnClick="btnAddToCart_Click" />
                    <button type="button" class="btn btn-secondary" onclick="closeCartModal()">Hủy</button>
                </div>
            </div>
        </div>

        <!-- Modal mua ngay -->
        <div id="buyNowModal">
            <div class="modal-content">
                <h3>Mua sách</h3>
                <asp:HiddenField ID="hfMaSachOrder" runat="server" />
                <label>Tên sách:</label>
                <span id="lblOrderBookTitle"></span>
                <br />
                <label>Mã sách:</label>
                <span id="lblOrderMaSach"></span>
                <br />
                <label>Đơn giá:</label>
                <span id="lblOrderDonGia" style="color:red;font-weight:bold;"></span> VNĐ
                <br /><br />
                <label for="txtQuantityOrder">Số lượng:</label>
                <asp:TextBox ID="txtQuantityOrder" runat="server" CssClass="form-control" Text="1" />
                <label for="txtAddressOrder">Địa chỉ giao hàng:</label>
                <asp:TextBox ID="txtAddressOrder" runat="server" CssClass="form-control" />
                <label>Phương thức thanh toán:</label>
                <div>
                    <input type="radio" name="paymentMethod" value="COD" checked /> Thanh toán khi nhận hàng<br />
                    <input type="radio" disabled /> Chuyển khoản (Tạm thời không khả dụng)
                </div>
                <label>Thành tiền:</label>
                <span id="lblThanhTien">0đ</span>
                <div class="actions text-end mt-3">
                    <asp:Button ID="btnConfirmOrder" runat="server" Text="Mua" CssClass="btn btn-success" OnClick="btnConfirmOrder_Click" />
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                </div>
            </div>
        </div>

        <div id="modalOverlay" onclick="closeModal(); closeCartModal();"></div>
    </form>

    <script type="text/javascript">
        function showCartModal() {
            const title = $('#<%= lblTenSach.ClientID %>').text();
            const priceText = $('#<%= lblDonGia.ClientID %>').text();
            const price = parseInt(priceText.replace(/[^\d]/g, '')) || 0;

            $('#cartBookTitle').text(title);
            $('#cartBookPrice').text(price.toLocaleString());
            $('#cartQuantity').val(1);
            $('#cartTotalPrice').text(price.toLocaleString());
            $('#<%= hfMaSachCart.ClientID %>').val('<%= Request.QueryString["ms"] ?? "" %>');

            $('#cartModal').show();
            $('#modalOverlay').show();
        }

        function closeCartModal() {
            $('#cartModal').hide();
            $('#modalOverlay').hide();
        }

        $('#cartQuantity').on('input', function () {
            const price = parseInt($('#cartBookPrice').text().replace(/[^\d]/g, '')) || 0;
            const qty = parseInt($(this).val());
            if (!isNaN(qty) && qty > 0) {
                $('#cartTotalPrice').text((price * qty).toLocaleString());
            } else {
                $('#cartTotalPrice').text('0');
            }
        });

        $('#<%= btnAddToCart.ClientID %>').click(function (e) {
            e.preventDefault();
            const qty = parseInt($('#cartQuantity').val()) || 1;
            $('#<%= hfQuantityCart.ClientID %>').val(qty);
            $('#<%= form1.ClientID %>').submit();
        });

        function showOrderModal() {
            const title = $('#<%= lblTenSach.ClientID %>').text();
            const priceText = $('#<%= lblDonGia.ClientID %>').text();
            const price = parseInt(priceText.replace(/[^\d]/g, '')) || 0;

            $('#lblOrderBookTitle').text(title);
            $('#lblOrderMaSach').text('<%= Request.QueryString["ms"] ?? "" %>');
            $('#lblOrderDonGia').text(price.toLocaleString());
            $('#<%= hfMaSachOrder.ClientID %>').val('<%= Request.QueryString["ms"] ?? "" %>');

            $('#<%= txtQuantityOrder.ClientID %>').val("1");
            $('#<%= txtAddressOrder.ClientID %>').val("");
            $('#lblThanhTien').text(price.toLocaleString() + "đ");

            $('#buyNowModal').show();
            $('#modalOverlay').show();

            $('#<%= txtQuantityOrder.ClientID %>').off('input').on('input', function () {
                const qty = parseInt($(this).val());
                if (!isNaN(qty) && qty >= 1) {
                    $('#lblThanhTien').text((price * qty).toLocaleString() + "đ");
                } else {
                    $('#lblThanhTien').text("0đ");
                }
            });
        }

        // Đóng modal mua ngay
        function closeModal() {
            $('#buyNowModal').hide();
            $('#modalOverlay').hide();
        }
    </script>
</body>
</html>
