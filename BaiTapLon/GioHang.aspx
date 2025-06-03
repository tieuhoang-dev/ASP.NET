<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GioHang.aspx.cs" Inherits="BaiTapLon.GioHang1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Giỏ Hàng</title>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
        }

        .content {
            display: flex;
            gap: 30px;
            margin: 60px 0;
        }

        #rptGioHangWrapper {
            flex: 1 1 0;
            max-height: 600px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            background: #fff;
            box-shadow: 0 0 8px rgba(0,0,0,0.05);
        }

        .cart-item {
            display: flex;
            gap: 20px;
            padding: 15px 10px;
            border-bottom: 1px solid #ddd;
            align-items: center;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item img {
            width: 100px;
            height: 130px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }

        .cart-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .cart-info h4 {
            margin: 0 0 8px;
            font-size: 20px;
            color: #333;
        }

        .price {
            font-weight: 700;
            font-size: 18px;
            color: #e91e63;
            margin-bottom: 12px;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-controls button {
            width: 32px;
            height: 32px;
            background-color: #e91e63;
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }

        .quantity-controls button:hover {
            background-color: #c2185b;
        }

        .quantity-controls input[type="text"] {
            width: 50px;
            padding: 6px 8px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-align: center;
        }

        .cart-footer {
            margin-top: 12px;
        }

        .cart-footer label {
            font-size: 14px;
            color: #555;
            cursor: pointer;
        }

        .summary {
            flex: 0 0 350px;
            background: #fff;
            padding: 25px 20px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
            height: fit-content;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .summary label {
            font-size: 20px;
            font-weight: 700;
            color: #333;
        }

        .address-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .address-grid input {
            width: 100%;
            padding: 12px 15px;
            font-size: 16px;
            border: 1.5px solid #ccc;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }

        .address-grid input:focus {
            border-color: #e91e63;
            outline: none;
            box-shadow: 0 0 6px #e91e63;
        }

        #btnDatMua {
            padding: 12px 30px;
            font-size: 18px;
            background-color: #e91e63;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #btnDatMua:hover {
            background-color: #c2185b;
        }

        @media (max-width: 900px) {
            .content {
                flex-direction: column;
            }

            #rptGioHangWrapper, .summary {
                flex: none;
                max-height: none;
                position: static;
                width: 100%;
            }
        }

        @media (max-width: 600px) {
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .cart-item img {
                width: 100%;
                height: auto;
                max-height: 250px;
                margin-bottom: 10px;
            }

            #btnDatMua {
                width: 100%;
                font-size: 16px;
            }

            .summary label {
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:PlaceHolder ID="phHeader" runat="server" />

        <div class="container">
            <div class="content">
                <div id="rptGioHangWrapper">
                    <asp:Label runat="server" ID="txttrangthai" Visible="false"></asp:Label>
                    <asp:Repeater ID="rptGioHang" runat="server" OnItemCommand="rptGioHang_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-item">
                                <img src='<%# ResolveUrl("~/Images/") + Eval("Hinh_minh_hoa") %>' alt="Ảnh sách" />
                                <div class="cart-info">
                                    <h4><%# Eval("Ten_sach") %></h4>
                                    <div class="price"><%# String.Format("{0:N0} VNĐ", Eval("Don_gia")) %></div>
                                    <div class="quantity-controls">
                                        <asp:Button runat="server" CommandName="Tru" CommandArgument='<%# Eval("Ms") %>' Text="−" />
                                        <asp:TextBox runat="server" ID="txtSoLuong" Text='<%# Eval("SoLuong") %>' AutoPostBack="true" OnTextChanged="txtSoLuong_TextChanged" />
                                        <asp:Button runat="server" CommandName="Cong" CommandArgument='<%# Eval("Ms") %>' Text="+" />
                                    </div>
                                    <asp:HiddenField ID="hiddenMs" runat="server" Value='<%# Eval("Ms") %>' />
                                    <asp:HiddenField ID="hiddenDonGia" runat="server" Value='<%# Eval("Don_gia") %>' />
                                    <div class="cart-footer">
                                        <label>
                                            <asp:CheckBox ID="chkDatHang" runat="server" Checked="true" AutoPostBack="true" OnCheckedChanged="chkDatHang_CheckedChanged" Text="Đặt Mua" />
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="summary">
                    <div class="summary-row">
                        <label>Tổng tiền:</label>
                        <asp:Label ID="lblTongTien" runat="server"></asp:Label>
                    </div>
                    <div class="address-grid">
                        <asp:TextBox ID="txtSoNha" runat="server" placeholder="Số nhà, đường..."></asp:TextBox>
                        <asp:TextBox ID="txtPhuongXa" runat="server" placeholder="Phường/Xã..."></asp:TextBox>
                        <asp:TextBox ID="txtQuanHuyen" runat="server" placeholder="Quận/Huyện..."></asp:TextBox>
                        <asp:TextBox ID="txtTinhThanh" runat="server" placeholder="Tỉnh/Thành phố..."></asp:TextBox>
                    </div>
                    <asp:Button ID="btnDatMua" runat="server" Text="Đặt Mua" OnClick="btnDatMua_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
