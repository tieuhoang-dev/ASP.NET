<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Genre.ascx.cs" Inherits="BaiTapLon.Genre" %>

<asp:Repeater ID="rptChuDe" runat="server" OnItemCommand="rptChuDe_ItemCommand">
    <ItemTemplate>
        <asp:LinkButton 
            runat="server" 
            CommandName="ChonChuDe" 
            CommandArgument='<%# Eval("Ten_chu_de") %>' 
            Style="padding: 10px; display: block; border-bottom: 1px solid #ddd; text-align: left;">
            <strong><%# Eval("Ten_chu_de") %></strong>
            <span style="color: gray;">(<%# Eval("SoLuongSach") %> sách)</span>
        </asp:LinkButton>
    </ItemTemplate>
</asp:Repeater>
