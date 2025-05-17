<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuangCao.ascx.cs" Inherits="BaiTapLon.QuangCao" %>

<div id="adCarouselWrapper">
    <asp:Repeater ID="rptQuangCao" runat="server">
        <ItemTemplate>
            <a href='<%# Eval("HREF") %>' target="_blank" style="text-decoration: none; color: inherit;">
                <div class="ad-box ad-carousel-item">
                    <div class="ad-banner">
                        <img src='<%# Eval("Hinh_Minh_Hoa") %>' alt="Quảng cáo" />
                    </div>
                    <div class="ad-title">
                        <%# Eval("TenCty") %>
                    </div>
                </div>
            </a>
        </ItemTemplate>
    </asp:Repeater>
</div>

<style>
    #adCarouselWrapper {
        position: relative;
        width: 100%;
        max-width: 800px;
        margin: 0 auto;
    }

    .ad-box {
        width: 100%;
        height: 230px;
        border: 1px solid #ccc;
        border-radius: 6px;
        overflow: hidden;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        margin-bottom: 15px;
        position: absolute;
        top: 0;
        left: 0;
        opacity: 0;
        transition: opacity 0.8s ease-in-out;
        z-index: 0;
    }

    .ad-box.active {
        opacity: 1;
        z-index: 1;
    }

    .ad-banner {
        height: 90%;
        background-color: #f9f9f9;
    }

    .ad-banner img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .ad-title {
        height: 10%;
        background-color: #eee;
        text-align: center;
        font-weight: bold;
        padding: 5px;
        font-size: 14px;
    }
</style>

<script>
    (function () {
        const items = document.querySelectorAll('#adCarouselWrapper .ad-carousel-item');
        if (items.length === 0) return;

        let currentIndex = 0;

        function showItem(index) {
            items.forEach((item, i) => {
                item.classList.remove('active');
            });
            items[index].classList.add('active');
        }

        function nextItem() {
            currentIndex = (currentIndex + 1) % items.length;
            showItem(currentIndex);
        }

        showItem(currentIndex);
        setInterval(nextItem, 15000); 
    })();
</script>
