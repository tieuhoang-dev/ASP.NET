<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TacGia.aspx.cs" Inherits="BaiTapLon.TacGia" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin tác giả và sách</title>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background-color: #f0f2f5;
        }

        .author-books-container {
            display: flex;
            gap: 20px;
            padding: 60px;
            box-sizing: border-box;
        }

        .author-info {
            flex: 3;
            background-color: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-height: 600px;
            overflow-y: auto;
        }

        .author-info h2 {
            margin-bottom: 15px;
        }

        .author-item {
            display: block;
            padding: 12px 16px;
            border: 1px solid #ddd;
            margin-bottom: 10px;
            border-radius: 6px;
            background-color: #fafafa;
            transition: background-color 0.2s ease;
            text-align: left;
        }

        .author-item:hover {
            background-color: #e6f7ff;
            cursor: pointer;
        }

        .books-section {
            flex: 7;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .book-card {
            display: flex;
            height: 160px;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 8px;
            box-sizing: border-box;
            background-color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .book-card img {
            height: 140px;
            width: 100px;
            object-fit: cover;
            border-radius: 6px;
            flex-shrink: 0;
        }

        .book-info {
            flex: 1;
            padding-left: 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .book-info h4, .book-info p {
            margin: 2px 0;
            font-size: 14px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .book-info h4 {
            font-size: 16px;
            font-weight: bold;
        }

        .book-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
        }

        .book-footer span i {
            margin-right: 4px;
        }

        .no-books-msg {
            padding: 20px;
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            border-radius: 8px;
            color: #856404;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:PlaceHolder ID="phHeader" runat="server" />

        <div class="author-books-container">
            <!-- DANH SÁCH TÁC GIẢ -->
            <div class="author-info">
                <h4>Chọn tác giả:</h4>
                <asp:Repeater ID="rptTacGia" runat="server" OnItemCommand="rptTacGia_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton 
                            runat="server" 
                            CommandName="ChonTacGia" 
                            CommandArgument='<%# Eval("Mtg") %>' 
                            CssClass="author-item">
                            <strong><%# Eval("Ten_tac_gia") %></strong>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- DANH SÁCH SÁCH -->
            <div class="books-section">
                <asp:Panel ID="pnlNoBooks" runat="server" Visible="false">
                    <div class="no-books-msg">
                        <i class="fas fa-info-circle"></i>
                        <asp:Label ID="lblNoBooksMessage" runat="server" Text=""></asp:Label>
                    </div>
                </asp:Panel>
                <asp:Repeater ID="rptBooks" runat="server">
                    <ItemTemplate>
                        <a href='<%# Eval("Ms", "BookDetail.aspx?ms={0}") %>' style="text-decoration: none; color: inherit;">
                            <div class="book-card">
                                <img src='<%# ResolveUrl("~/Images/") + Eval("Hinh_minh_hoa") %>' alt="Hình sách" />
                                <div class="book-info">
                                    <div>
                                        <h4><%# Eval("Ten_sach") %></h4>
                                        <p>Tác giả: <%# Eval("Ten_tac_gia") %></p>
                                        <p>Chủ đề: <%# Eval("Ten_chu_de") %></p>
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
        </div>
    </form>
</body>
</html>
