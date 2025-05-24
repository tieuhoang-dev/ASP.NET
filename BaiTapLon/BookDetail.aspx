<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookDetail.aspx.cs" EnableSessionState="True" Inherits="BaiTapLon.BookDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>Chi Tiết Sách</title>
        <webopt:bundlereference runat="server" path="~/Content/css" />
        <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    

    <style>
         .book-detail-container {
            width: 800px;
            margin: 40px auto;
            display: flex;
            gap: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            font-family: Arial, sans-serif;
            margin-top:70px;
        }

        .book-image img {
            width: 200px;
            height: 280px;
            object-fit: cover;
            border-radius: 6px;
        }

        .book-info h2 {
            margin-top: 0;
            color: #e91e63;
        }

        .book-info p {
            margin: 6px 0;
        }
         .add-to-cart-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .add-to-cart-btn i {
            margin-right: 6px;
        }
        .cart-dialog {
            display: none;
            position: fixed;
            z-index: 9999;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .dialog-content {
            background-color: white;
            width: 320px;
            margin: 100px auto;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .dialog-content h3 {
            margin-top: 0;
        }
        .dialog-content input[type="number"] {
            width: 80px;
            padding: 5px;
            margin: 10px 0;
        }
        .dialog-actions button {
            padding: 8px 12px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .dialog-actions button:first-child {
            background-color: #007bff;
            color: white;
        }
        .dialog-actions button:last-child {
            background-color: #6c757d;
            color: white;
        }

    </style>
</head>
<body>
<form id="form1" runat="server">
        <div class="header">
            <asp:PlaceHolder ID="phHeader" runat="server" />
        </div>

    <div class="book-detail-container">
        <div class="book-image">
            <asp:Image ID="imgBook" runat="server" />
        </div>
        <div class="book-info">
            <h2><asp:Label ID="lblTenSach" runat="server" /></h2>
            <p><span class="label">Tác giả:</span> <asp:Label ID="lblTacGia" runat="server" /></p>
            <p><span class="label">Thể loại:</span> <asp:Label ID="lblChuDe" runat="server" /></p>
            <p><span class="label">Giá:</span> <asp:Label ID="lblDonGia" runat="server" /></p>
            <p><span class="label">Mô tả:</span><br /><asp:Label ID="lblMoTa" runat="server" /></p>
            <p><span class="label">Lượt xem:</span> <asp:Label ID="lblXem" runat="server" /> | <span class="label">Đã bán:</span> <asp:Label ID="lblBan" runat="server" /></p>
            <!-- Nút mở dialog -->
            <button type="button" class="add-to-cart-btn" onclick="openCartDialog()">
                <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
            </button>

            <p><asp:Label ID="lblCartCount" runat="server" ForeColor="Red" /></p>
            <p><asp:Label ID="lblDebugCart" runat="server" ForeColor="Blue" /></p>

            <!-- Nút ẩn submit để postback -->
            <asp:Button ID="btnAddToCart" runat="server" OnClick="btnAddToCart_Click" Style="display:none" />
            <asp:HiddenField ID="hfQuantity" runat="server" />
            <asp:HiddenField ID="hfMaSach" runat="server" />
        </div>
    </div>

    <!-- Dialog thêm giỏ hàng -->
    <div id="cartDialog" class="cart-dialog" style="display:none;">
        <div class="dialog-content">
            <h3 id="dialogBookTitle">Tên sách</h3>
            <p>Giá: <span id="dialogBookPrice"></span> VND</p>
            <label for="quantity">Số lượng:</label>
            <input type="number" id="quantity" value="1" min="1" onchange="updateTotal()" />
            <p>Thành tiền: <span id="totalPrice"></span> VND</p>
            <div class="dialog-actions">
                <button type="button" onclick="confirmAddToCart()">Thêm vào giỏ hàng</button>
                <button type="button" onclick="closeCartDialog()">Hủy</button>
            </div>
        </div>
    </div>
</form>

<script type="text/javascript">
    // Hàm mở dialog, thiết lập thông tin
    function openCartDialog() {
        var title = document.getElementById('<%= lblTenSach.ClientID %>').innerText;
        var price = document.getElementById('<%= lblDonGia.ClientID %>').innerText.replace(/[^\d]/g, '');

        document.getElementById('dialogBookTitle').innerText = title;
        document.getElementById('dialogBookPrice').innerText = price;
        document.getElementById('quantity').value = 1;
        document.getElementById('totalPrice').innerText = price;

        document.getElementById('cartDialog').style.display = 'block';
    }

    function closeCartDialog() {
        document.getElementById('cartDialog').style.display = 'none';
    }

    function updateTotal() {
        var price = parseFloat(document.getElementById('dialogBookPrice').innerText);
        var qty = parseInt(document.getElementById('quantity').value);
        document.getElementById('totalPrice').innerText = (price * qty).toLocaleString();
    }

    // Hàm gọi khi nhấn thêm vào giỏ hàng (postback)
    function confirmAddToCart() {
        var ms = '<%= Request.QueryString["ms"] %>';
        var qty = parseInt(document.getElementById('quantity').value);

        // Lưu dữ liệu vào hidden fields
        document.getElementById('<%= hfMaSach.ClientID %>').value = ms;
        document.getElementById('<%= hfQuantity.ClientID %>').value = qty;

        // Submit button ẩn để postback
        document.getElementById('<%= btnAddToCart.ClientID %>').click();
    }
</script>

</body>
</html>
