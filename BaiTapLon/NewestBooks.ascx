<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NewestBooks.ascx.cs" Inherits="BaiTapLon.NewestBooks" %>

<style>
    #carouselContainer {
        position: relative;
        width: 800px;
        margin: 0 auto;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 20px;
        box-sizing: border-box;
        background-color: #fff;
    }

    .carousel-item {
        display: none;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 10px;
        display: flex;
        gap: 15px;
        height: 150px;
        align-items: center;
        box-sizing: border-box;
    }

    .carousel-item img {
        height: 100px;
        width: 100px;
        object-fit: cover;
        border-radius: 4px;
        flex-shrink: 0;
    }

    .book-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .carousel-controls {
        position: absolute;
        top: 50%;
        left: 0;
        right: 0;
        transform: translateY(-50%);
        display: flex;
        justify-content: space-between;
        padding: 0 10px;
        pointer-events: none;
        z-index: 10;
    }

    .btn-prev, .btn-next {
        background-color: rgba(233, 30, 99, 0.9);
        border: none;
        color: white;
        font-size: 28px;
        width: 44px;
        height: 44px;
        border-radius: 50%;
        cursor: pointer;
        pointer-events: auto;
        user-select: none;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: background-color 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }

    .btn-prev:hover, .btn-next:hover {
        background-color: rgba(194, 24, 91, 1);
    }
     .btn-buy-now {
     background-color: #4CAF50;
     color: white;
     border: none;
     padding: 5px 10px;
     font-size: 12px;
     border-radius: 4px;
     cursor: pointer;
     display: inline-flex;
     align-items: center;
     gap: 5px;
     text-decoration: none;
     }

     .btn-buy-now:hover {
         background-color: #45a049;
         text-decoration: none;
         color: white;
     }
     .btn-add-to-cart {
        background-color: #2196F3; 
        color: white;
        border: none;
        padding: 5px 10px;
        font-size: 12px;
        border-radius: 4px;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        text-decoration: none;
     }

    .btn-add-to-cart:hover {
        background-color: #1976D2;
        color: white;
    }
    .book-actions {
        display: flex;
        gap: 10px;
        margin-top: 8px;
}

</style>

<div id="carouselContainer">

    <div style="text-align: center; font-weight: bold; font-size: 24px; margin-bottom: 20px;">
        SÁCH MỚI ĐĂNG BÁN
    </div>

    <div class="carousel-controls">
        <button id="btnPrev" class="btn-prev" type="button" aria-label="Previous">&#x2039;</button>
        <button id="btnNext" class="btn-next" type="button" aria-label="Next">&#x203A;</button>
    </div>

    <asp:Repeater ID="rptNewestBooks" runat="server">
        <ItemTemplate>
            <a href='<%# Eval("MaSach", "BookDetail.aspx?ms={0}") %>' style="text-decoration: none; color: inherit;">
            <div class="carousel-item">
                <img src='<%# Eval("Hinh_minh_hoa") %>' alt="Hình sách" />
                <div class="book-info">
                    <h4 style="margin: 0;"><%# Eval("Ten_sach") %></h4>
                    <p style="margin: 2px 0; font-size: 14px; color: #555;">Tác giả: <%# Eval("DanhSachTacGia") %></p>
                    <p style="margin: 2px 0; font-size: 14px; color: #777;">Chủ đề: <%# Eval("TenChuDe") %></p>
                    <div style="display: flex; justify-content: space-between; align-items: end;">
                        <span style="font-weight: bold; color: #e91e63;">
                            <%# String.Format("{0:N0} VNĐ", Eval("Don_gia")) %>
                        </span>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <span><i class="fa fa-eye"></i> <%# Eval("So_lan_xem") %></span>
                            <span><i class="fa fa-shopping-cart"></i> <%# Eval("So_luong_ban") %></span>
                        </div>
                    </div>
                    </a>
                        <div class="book-actions">
                       <asp:LinkButton runat="server" CssClass="btn-buy-now" 
                            data-masach='<%# Eval("MaSach") %>' 
                            data-tensach='<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>' 
                            data-dongia='<%# String.Format("{0:0}", Eval("Don_gia")) %>'
                            OnClientClick="openModal(this.getAttribute('data-masach'), this.getAttribute('data-tensach'), this.getAttribute('data-dongia')); return false;">
                            <i class="fa fa-credit-card"></i> Mua ngay
                        </asp:LinkButton>
            
                        <asp:LinkButton runat="server"
                            CssClass="btn-add-to-cart"
                            data-masach='<%# Eval("MaSach") %>'
                            data-tensach='<%# Eval("Ten_sach").ToString().Replace("\"", "\\\"") %>'
                            data-dongia='<%# String.Format("{0:0}", Eval("Don_gia")) %>'>
                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                        </asp:LinkButton>
                    </div>

                </div>
            </div>
            
        </ItemTemplate>
    </asp:Repeater>
</div>

<script>
    (function () {
        const container = document.getElementById('carouselContainer');
        const items = container.querySelectorAll('.carousel-item');
        if (items.length === 0) return;

        const btnPrev = document.getElementById('btnPrev');
        const btnNext = document.getElementById('btnNext');

        let currentIndex = 0;
        let autoSlideInterval;

        function showItem(index) {
            items.forEach(item => item.style.display = 'none');
            items[index].style.display = 'flex';
        }

        function nextItem() {
            currentIndex = (currentIndex + 1) % items.length;
            showItem(currentIndex);
        }

        function prevItem() {
            currentIndex = (currentIndex - 1 + items.length) % items.length;
            showItem(currentIndex);
        }

        function startAutoSlide() {
            autoSlideInterval = setInterval(nextItem, 10000);
        }

        function resetAutoSlide() {
            clearInterval(autoSlideInterval);
            startAutoSlide();
        }

        btnPrev.addEventListener('click', () => {
            prevItem();
            resetAutoSlide();
        });

        btnNext.addEventListener('click', () => {
            nextItem();
            resetAutoSlide();
        });

        showItem(currentIndex);
        startAutoSlide();
    })();
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.btn-buy-now').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                const maSach = this.getAttribute('data-masach');
                const tenSach = this.getAttribute('data-tensach');
                const donGia = parseInt(this.getAttribute('data-dongia'));
                openModal(maSach, tenSach, donGia);
            });
        });

        document.querySelectorAll('.btn-add-to-cart').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                const maSach = this.getAttribute('data-masach');
                const tenSach = this.getAttribute('data-tensach');
                const donGia = parseInt(this.getAttribute('data-dongia'));
                openCartDialog(maSach, tenSach, donGia);
            });
        });
    });


</script>
