<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Genre.ascx.cs" Inherits="BaiTapLon.Genre" %>

<asp:Repeater ID="rptChuDe" runat="server">
    <ItemTemplate>
        <div style="padding: 10px; border-bottom: 1px solid #ddd;">
            <strong><%# Eval("Ten_chu_de") %></strong>
            <span style="color: gray;">(<%# Eval("SoLuongSach") %> sách)</span>
        </div>
    </ItemTemplate>
</asp:Repeater>
