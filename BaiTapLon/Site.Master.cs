using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using BaiTapLon.Models;
using System.Collections.Generic;
using System.Linq;

namespace BaiTapLon
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string keyword = Session["searchKeyword"] as string;
            string chuDeDuocChon = Session["ChuDeDuocChon"] as string;

            if (!string.IsNullOrEmpty(keyword))
            {
                var searchResult = (Search)LoadControl("~/Search.ascx");
                searchResult.Keyword = keyword;

                MainContent.Controls.Clear();
                MainContent.Controls.Add(searchResult);

                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1.Controls.Add(QCControl);

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);

                Session["searchKeyword"] = null;
                Session["ChuDeDuocChon"] = null;
            }
            else if (!string.IsNullOrEmpty(chuDeDuocChon))
            {
                var bookOfGenreControl = (BookOfGenre)LoadControl("~/BookOfGenre.ascx");
                bookOfGenreControl.TenChuDe = chuDeDuocChon;

                MainContent.Controls.Clear();
                MainContent.Controls.Add(bookOfGenreControl);

                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1.Controls.Add(QCControl);

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);

                Session["ChuDeDuocChon"] = null;
            }
            else
            {
                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var bookControl = (Allbook)LoadControl("~/Allbook.ascx");
                MainContent.Controls.Clear();
                MainContent.Controls.Add(bookControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1.Controls.Add(QCControl);

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);
                string userid = Session["user_id"] as string;
                lblid.Text = userid;
            }
        }
        protected void btnConfirmOrder_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSach.Value;
            if (string.IsNullOrEmpty(maSach))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Không lấy được mã sách.');", true);
                return;
            }

            string user_id = Session["user_id"]?.ToString();
            if (string.IsNullOrEmpty(user_id))
            {
                string loginFailscript = @"
            alert('Vui lòng ĐĂNG NHẬP');
            setTimeout(function() {
                window.location.href = 'Login.aspx';
            }, 1000);
        ";
                ScriptManager.RegisterStartupScript(this, GetType(), "loginFail", loginFailscript, true);
                return;
            }

            int maKhachHang = int.Parse(user_id);
            int ms = int.Parse(maSach);

            if (!int.TryParse(txtQuantity.Text, out int soLuong) || soLuong <= 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "countFail",
                    "alert('Vui lòng nhập số lượng hợp lệ');", true);
                return;
            }

            string diaChiGiaoHang = txtAddress.Text.Trim();
            if (string.IsNullOrEmpty(diaChiGiaoHang))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addressFail",
                    "alert('Vui lòng nhập địa chỉ giao hàng');", true);
                return;
            }

            DataTable dtSachMua = new DataTable();
            dtSachMua.Columns.Add("Ms", typeof(int));
            dtSachMua.Columns.Add("So_luong", typeof(int));
            dtSachMua.Rows.Add(ms, soLuong);

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("DatDonHang_TheoMkh", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Mkh", maKhachHang);
                var tvpParam = cmd.Parameters.AddWithValue("@DanhSachSach", dtSachMua);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "dbo.SachMuaType";

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "successRedirect", @"
        alert('Đặt hàng thành công!');
        document.getElementById('buyNowModal').style.display = 'none';
        document.getElementById('modalOverlay').style.display = 'none';
        setTimeout(function() {
            window.location.href = 'Default.aspx';
        }, 1000);
    ", true);
        }
        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSach_AddToCart.Value;
            if (string.IsNullOrEmpty(maSach)) return;

            List<string> cart = Session["Cart"] as List<string> ?? new List<string>();
            cart.Add(maSach);
            Session["Cart"] = cart;

            string script = $"alert('Đã thêm sách mã {maSach} vào giỏ hàng!');";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", script, true);

            Response.Redirect("Default.aspx");
        }

    }
}
