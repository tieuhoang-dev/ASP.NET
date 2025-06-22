<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lich_Su_Mua_Hang.aspx.cs" Inherits="BaiTapLon.Lich_Su_Mua_Hang" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lịch Sử Mua Hàng</title>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            max-height:700px;
        }

       .container {
            max-width: 1200px;
            margin-top : 60px ;
            padding: 30px;
            height:500px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

            display: flex;
            justify-content: center;

            align-items: flex-start;
            overflow-y: auto;
        }


        .card {
            width: 100%;
            max-width: 1000px;
        }

        .table th, .table td {
            vertical-align: middle !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:PlaceHolder ID="phHeader" runat="server" />

        <div class="container">
            <div class="card p-4 shadow-sm">
                <h4 class="mb-3">Lịch Sử Mua Hàng</h4>
                <asp:GridView ID="gvDonHang" runat="server" CssClass="table table-bordered table-hover"
                    AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Sdh" HeaderText="Mã Đơn Hàng" />
                        <asp:BoundField DataField="Ngay_dat_hang" HeaderText="Ngày Đặt" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="Chi Tiết Hàng">
                            <ItemTemplate>
                                <%# Eval("Chi_tiet_hang").ToString().Replace(";", "<br/>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Tri_gia" HeaderText="Trị Giá" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Trang_thai_giao_hang" HeaderText="Trạng Thái" />
                        <asp:TemplateField HeaderText="Hành Động">
                            <ItemTemplate>
                                <asp:LinkButton 
                                    ID="lnkHuyDon" 
                                    runat="server"
                                    CommandArgument='<%# Eval("Sdh") %>' 
                                    Text="Hủy Đơn"
                                    OnClientClick='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "return confirmHuy(\"Bạn chắc muốn HỦY đơn hàng #" + Eval("Sdh") + "?\")" : "return false;" %>'
                                    OnClick="btnHuyDon_Click"
                                    CssClass='<%# Convert.ToInt32(Eval("Da_giao_hang")) == 0 ? "btn btn-danger btn-sm" : "btn btn-secondary btn-sm disabled" %>' 
                                />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
