<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopSellingBooks.ascx.cs" Inherits="BaiTapLon.TopSellingBooks" %>

<div class="top-selling-books">
    <h2 class="section-title">Sách Bán Chạy</h2>

    <div id="bookCarouselWrapper">
        <asp:Repeater ID="rptTopBooks" runat="server">
            <ItemTemplate>
                <div class="book-banner book-carousel-item">
                    <img src='<%# Eval("Hinh_minh_hoa") %>' alt="Ảnh sách" />
                    <div class="book-caption">
                        <h4><%# Eval("Ten_sach") %></h4>
                        <p><%# Eval("Mo_ta").ToString().Length > 100 ? Eval("Mo_ta").ToString().Substring(0, 100) + "..." : Eval("Mo_ta") %></p>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Nút điều hướng -->
        <button id="prevBtn" class="carousel-btn left" type="button">&#10094;</button>
        <button id="nextBtn" class="carousel-btn right" type="button">&#10095;</button>
    </div>
</div>

<style>
    .top-selling-books {
        max-width: 800px;
        margin: 0 auto;
        position: relative;
    }

    .section-title {
        text-align: center;
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    #bookCarouselWrapper {
        position: relative;
        width: 100%;
        height: 390px;
        overflow: hidden;
        border-radius: 10px;
    }

    .book-banner {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border-radius: 10px;
        overflow: hidden;
        opacity: 0;
        transition: opacity 1s ease-in-out;
        z-index: 0;
    }

    .book-banner.active {
        opacity: 1;
        z-index: 1;
    }

    .book-banner img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .book-caption {
        position: absolute;
        bottom: 0;
        width: 100%;
        background: rgba(0,0,0,0.6);
        color: #fff;
        padding: 10px;
        box-sizing: border-box;
    }

    .book-caption h4 {
        margin: 0;
        font-size: 18px;
    }

    .book-caption p {
        margin: 4px 0 0;
        font-size: 13px;
    }

    .carousel-btn {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: rgba(0, 0, 0, 0.5);
        color: white;
        border: none;
        font-size: 24px;
        padding: 10px;
        cursor: pointer;
        border-radius: 50%;
        z-index: 2;
    }

    .carousel-btn.left {
        left: 10px;
    }

    .carousel-btn.right {
        right: 10px;
    }

    .carousel-btn:hover {
        background: rgba(0, 0, 0, 0.7);
    }
</style>

<script>
    (function () {
        const items = document.querySelectorAll('#bookCarouselWrapper .book-carousel-item');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        if (items.length === 0) return;

        let currentIndex = 0;
        let intervalId;

        function showItem(index) {
            items.forEach(item => item.classList.remove('active'));
            items[index].classList.add('active');
        }

        function nextItem() {
            currentIndex = (currentIndex + 1) % items.length;
            showItem(currentIndex);
        }

        function prevItem() {
            currentIndex = (currentIndex - 1 + items.length) % items.length;
            showItem(currentIndex);
        }

        // Gán sự kiện
        prevBtn.addEventListener('click', () => {
            prevItem();
            resetInterval();
        });

        nextBtn.addEventListener('click', () => {
            nextItem();
            resetInterval();
        });

        // Tự động cuộn
        function startInterval() {
            intervalId = setInterval(nextItem, 10000); // 10s
        }

        function resetInterval() {
            clearInterval(intervalId);
            startInterval();
        }

        showItem(currentIndex);
        startInterval();
    })();
</script>
