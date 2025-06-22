<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Qc2.ascx.cs" Inherits="BaiTapLon.Qc2" %>

<style>
    .ad-wrapper {
        width: 1038px;
        max-height: 350px;
        overflow-y: auto;
        margin: 5px auto;
        background-color: #ffffff;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        padding: 10px;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .ad-item {
        height: 75px;
        background-color: #fafafa;
        border-radius: 6px;
        border: 1px solid #ddd;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: box-shadow 0.3s;
    }

    .ad-item:hover {
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .ad-item img {
        height: 60px;
        width: auto;
        max-width: 100%;
        object-fit: contain;
        display: block;
    }
</style>

<div class="ad-wrapper">
    <asp:Repeater ID="rptAds" runat="server">
        <ItemTemplate>
            <div class="ad-item">
                <a href='<%# Eval("Url") %>' target="_blank">
                    <img src='<%# ResolveUrl(Eval("AnhUrl").ToString()) %>' alt='<%# Eval("Alter") %>' />
                </a>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>
