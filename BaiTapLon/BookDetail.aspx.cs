using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using BaiTapLon.Models;

namespace BaiTapLon
{
    public partial class BookDetail : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !string.IsNullOrEmpty(Request.QueryString["ms"]))
            {
                LoadBookDetail(Request.QueryString["ms"]);
            }

            var HeaderControl = (Header)LoadControl("~/Header.ascx");
            phHeader.Controls.Clear();
            phHeader.Controls.Add(HeaderControl);

            if (!IsPostBack && Request.QueryString["openModal"] == "true")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "openModal", "showOrderModal();", true);
            }
        }

        private void LoadBookDetail(string maSach)
        {
            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_LayThongTinSachTheoMa", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MaSach", maSach);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hfMaSach_AddToCart.Value = maSach;
                    lblTenSach.Text = reader["Ten_sach"].ToString();
                    lblTacGia.Text = reader["DanhSachTacGia"].ToString();
                    lblChuDe.Text = reader["TenChuDe"].ToString();
                    lblDonGia.Text = string.Format("{0:N0} VNĐ", reader["Don_gia"]);
                    lblMoTa.Text = reader["Mo_ta"].ToString();
                    lblXem.Text = reader["So_lan_xem"].ToString();
                    lblBan.Text = reader["So_luong_ban"].ToString();
                    var hinh = reader["Hinh_minh_hoa"]?.ToString();
                    if (!string.IsNullOrEmpty(hinh))
                    {
                        imgBook.ImageUrl = ResolveUrl("~/Images/" + hinh);
                    }
                    else
                    {
                        imgBook.ImageUrl = ResolveUrl("~/Images/default.jpg"); // ảnh mặc định
                    }
                }
                reader.Close();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSach_AddToCart.Value;
            if (string.IsNullOrEmpty(maSach)) return;

            List<string> cart = Session["Cart"] as List<string> ?? new List<string>();

            string currentUrl = Request.RawUrl;

            if (!cart.Contains(maSach))
            {
                cart.Add(maSach);
                Session["Cart"] = cart;

                string script = $"alert('Đã thêm sách mã {maSach} vào giỏ hàng!'); window.location='{currentUrl}';";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "addToCartAlert", script, true);
            }
            else
            {
                string script = $"alert('Sách mã {maSach} đã có trong giỏ hàng!'); window.location='{currentUrl}';";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "addToCartDuplicateAlert", script, true);
            }
        }


        protected void btnConfirmOrder_Click(object sender, EventArgs e)
        {
            string soNha = txtSoNha.Text;
            string tinh = Request.Form["ddlTinhTP"];
            string quan = Request.Form["ddlQuanHuyen"];
            string phuong = Request.Form["ddlPhuongXa"];
            string maSach = hfMaSachOrder.Value;
            if (string.IsNullOrEmpty(maSach))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Không lấy được mã sách.');", true);
                return;
            }

            string user_id = Session["user_id"]?.ToString();
            if (string.IsNullOrEmpty(user_id))
            {
                var uriBuilder = new UriBuilder(Request.Url);
                var query = System.Web.HttpUtility.ParseQueryString(uriBuilder.Query);
                query["openModal"] = "true";
                uriBuilder.Query = query.ToString();

                string urlWithOpenModal = uriBuilder.Path + uriBuilder.Query;

                string loginUrl = $"Login.aspx?returnUrl={Server.UrlEncode(urlWithOpenModal)}";
                string loginFailscript = $@"
                    alert('Vui lòng ĐĂNG NHẬP');
                    setTimeout(function() {{
                        window.location.href = '{loginUrl}';
                    }}, 1000);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "loginFail", loginFailscript, true);
                return ;
            }

            int maKhachHang = int.Parse(user_id);
            int ms = int.Parse(maSach);

            if (!int.TryParse(txtQuantityOrder.Text, out int soLuong) || soLuong <= 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "countFail",
                    "alert('Vui lòng nhập số lượng hợp lệ');", true);
                return;
            }
          

            string fullAddress = $"{soNha}, {phuong}, {quan}, {tinh}";
            if (string.IsNullOrEmpty(fullAddress))
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
            using (SqlCommand cmd = new SqlCommand("dbo.DatDonHang_TheoMkh ", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Mkh", maKhachHang);
                var tvpParam = cmd.Parameters.AddWithValue("@DanhSachSach", dtSachMua);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "dbo.SachMuaType";
                cmd.Parameters.AddWithValue("@DiaChiGiaoHang", fullAddress);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            string reloadUrl = Request.RawUrl;
            reloadUrl = System.Text.RegularExpressions.Regex.Replace(reloadUrl, @"[&?]openModal=true", "");
            ScriptManager.RegisterStartupScript(this, GetType(), "successRedirect", $@"
                alert('Đặt hàng thành công!');
                setTimeout(function() {{
                    window.location.href = '{reloadUrl}';
                }}, 100);
            ", true);
            LoadBookDetail(Request.QueryString["ms"]);
        }

    }

}
