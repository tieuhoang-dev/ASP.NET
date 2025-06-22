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
            max-width: 1300px;
            margin: 70px auto 40px;
            display: flex;
            gap: 25px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            font-family: Arial, sans-serif;
            min-width: 325px;
            align-items: flex-start;
        }

        .book-image img {
            width: 300px;
            height: 450px;
            object-fit: cover;
            border-radius: 8px;
            flex-shrink: 0;
        }

        .book-info {
            flex-grow: 1;
            overflow-wrap: break-word;
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

        #buyNowModal {
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

        .modal-content h3 {
            margin-bottom: 15px;
        }

        .modal-content label {
            font-weight: 600;
        }

        .modal-content .actions {
            margin-top: 20px;
        }
        #buyNowModal select.form-select {
            height: 38px;
            padding: 6px 12px;
            box-sizing: border-box;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <asp:ScriptManager runat="server" ID="ScriptManager1" />
        <asp:PlaceHolder ID="phHeader" runat="server" />

        <div class="book-detail-container">
            <div class="book-image">
                <asp:Image ID="imgBook" runat="server" />
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
                <asp:Button ID="btnAddToCart" runat="server" Text="Thêm vào giỏ hàng" CssClass="btn btn-primary btn-open-modal" OnClick="btnAddToCart_Click" />
                <asp:HiddenField ID="hfMaSach_AddToCart" runat="server" />
            </div>
        </div>
        <asp:PlaceHolder ID="phFooter" runat="server" />

        <!-- Modal Mua ngay -->
        <div id="buyNowModal">
            <div class="modal-content">
                <h3>Mua sách</h3>
                <asp:HiddenField ID="hfMaSachOrder" runat="server" />
                <label>Tên sách:</label>
                <span id="lblOrderBookTitle"></span><br />
                <label>Mã sách:</label>
                <span id="lblOrderMaSach"></span><br />
                <div><strong>Đơn giá:</strong> <span id="lblOrderDonGia" style="color:#d9534f; font-weight:bold;"></span> VNĐ</div><br />
                <label for="txtQuantityOrder">Số lượng:</label>
                <asp:TextBox ID="txtQuantityOrder" runat="server" CssClass="form-control" Text="1" />
                <label>Địa chỉ giao hàng:</label>
                <div class="row">
                    <div class="col-12 mb-2">
                        <label for="txtSoNha">Số nhà:</label>
                        <asp:TextBox ID="txtSoNha" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-4 mb-2">
                        <label for="ddlTinhTP">Tỉnh / Thành phố:</label>
                        <select id="ddlTinhTP" class="form-select" name="ddlTinhTP"></select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="ddlQuanHuyen">Quận / Huyện:</label>
                        <select id="ddlQuanHuyen" class="form-select" name="ddlQuanHuyen" disabled></select>
                    </div>
                    <div class="col-md-3 mb-2 d-flex flex-column ">
                        <label for="ddlPhuongXa">Phường / Xã:</label>
                        <select id="ddlPhuongXa" class="form-select" name="ddlPhuongXa" ></select>
                    </div>
                </div>

                <label>Phương thức thanh toán:</label>
                <div>
                    <input type="radio" id="cod" name="paymentMethod" value="COD" checked />
                    <label for="cod">Thanh toán khi nhận hàng</label><br />
                    <input type="radio" id="bank" name="paymentMethod" value="Bank" disabled />
                    <label for="bank" style="opacity: 0.5; cursor: not-allowed;">Chuyển khoản (Tạm thời không khả dụng)</label>
                </div>
                <label>Thành tiền:</label>
                <span id="lblThanhTien">0đ</span>
                <div class="actions text-end mt-3">
                    <asp:Button ID="btnConfirmOrder" runat="server" Text="Mua" CssClass="btn btn-success" OnClick="btnConfirmOrder_Click" />
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                </div>
            </div>
        </div>

        <div id="modalOverlay" onclick="closeModal();"></div>
    </form>

    <script type="text/javascript">
        let provincesData = [];
        let districtsData = [];
        let wardsData = [];

        function loadProvinces() {
            $.getJSON('https://provinces.open-api.vn/api/p/')
                .done(function (data) {
                    provincesData = data;
                    $('#ddlTinhTP').empty().append('<option value="">-- Chọn Tỉnh/Thành phố --</option>');
                    data.forEach(function (province) {
                        $('#ddlTinhTP').append(`<option value="${province.code}">${province.name}</option>`);
                    });
                }).fail(function () {
                    alert('Không tải được dữ liệu Tỉnh/Thành phố!');
                });
        }

        function loadDistricts(provinceCode) {
            if (!provinceCode) {
                $('#ddlQuanHuyen').prop('disabled', true).empty();
                $('#ddlPhuongXa').prop('disabled', true).empty();
                return;
            }
            $.getJSON(`https://provinces.open-api.vn/api/p/${provinceCode}?depth=2`)
                .done(function (data) {
                    districtsData = data.districts || [];
                    $('#ddlQuanHuyen').prop('disabled', false).empty().append('<option value="">-- Chọn Quận/Huyện --</option>');
                    $('#ddlPhuongXa').prop('disabled', true).empty();
                    districtsData.forEach(function (district) {
                        $('#ddlQuanHuyen').append(`<option value="${district.code}">${district.name}</option>`);
                    });
                }).fail(function () {
                    alert('Không tải được dữ liệu Quận/Huyện!');
                });
        }

        function loadWards(districtCode) {
            if (!districtCode) {
                $('#ddlPhuongXa').prop('disabled', true).empty();
                return;
            }
            $.getJSON(`https://provinces.open-api.vn/api/d/${districtCode}?depth=2`)
                .done(function (data) {
                    wardsData = data.wards || [];
                    $('#ddlPhuongXa').prop('disabled', false).empty().append('<option value="">-- Chọn Phường/Xã --</option>');
                    wardsData.forEach(function (ward) {
                        $('#ddlPhuongXa').append(`<option value="${ward.name}">${ward.name}</option>`);
                    });
                }).fail(function () {
                    alert('Không tải được dữ liệu Phường/Xã!');
                });
        }

        function resetAddressFields() {
            $('#txtSoNha').val('');
            $('#ddlTinhTP').val('');
            $('#ddlQuanHuyen').empty().prop('disabled', true);
            $('#ddlPhuongXa').empty().prop('disabled', true);
        }

        function showOrderModal() {
            const title = $('#<%= lblTenSach.ClientID %>').text();
        const priceText = $('#<%= lblDonGia.ClientID %>').text();
        const price = parseInt(priceText.replace(/[^\d]/g, '')) || 0;

        $('#lblOrderBookTitle').text(title);
        $('#lblOrderMaSach').text('<%= Request.QueryString["ms"] ?? "" %>');
        $('#lblOrderDonGia').text(price.toLocaleString());
        $('#<%= hfMaSachOrder.ClientID %>').val('<%= Request.QueryString["ms"] ?? "" %>');

        $('#<%= txtQuantityOrder.ClientID %>').val("1");

        resetAddressFields();
        loadProvinces();

        $('#lblThanhTien').text(price.toLocaleString() + "đ");

        $('#buyNowModal').show();
        $('#modalOverlay').show();

        $('#<%= txtQuantityOrder.ClientID %>').off('input').on('input', function () {
                const qty = parseInt($(this).val());
                $('#lblThanhTien').text(!isNaN(qty) && qty >= 1 ? (price * qty).toLocaleString() + "đ" : "0đ");
            });
        }

        $(document).ready(function () {
            // Khi chọn Tỉnh/TP thì load Quận/Huyện
            $('#ddlTinhTP').on('change', function () {
                const provinceCode = $(this).val();
                loadDistricts(provinceCode);
                $('#ddlPhuongXa').empty().prop('disabled', true);
            });

            // Khi chọn Quận/Huyện thì load Phường/Xã
            $('#ddlQuanHuyen').on('change', function () {
                const districtCode = $(this).val();
                loadWards(districtCode);
            });

            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('openModal') === 'true') {
                showOrderModal();

                urlParams.delete('openModal');
                const newUrl = window.location.pathname + '?' + urlParams.toString();
                window.history.replaceState({}, '', newUrl);
            }
        });

        function closeModal() {
            $('#ddlTinhTP, #ddlQuanHuyen, #ddlPhuongXa').prop('disabled', false);
            $('#buyNowModal').hide();
            $('#modalOverlay').hide();
        }

    </script>

</body>
</html>
