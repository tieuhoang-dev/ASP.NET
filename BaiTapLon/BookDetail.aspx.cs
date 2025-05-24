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
                    lblTenSach.Text = reader["Ten_sach"].ToString();
                    lblTacGia.Text = reader["DanhSachTacGia"].ToString();
                    lblChuDe.Text = reader["TenChuDe"].ToString();
                    lblDonGia.Text = string.Format("{0:N0} VNĐ", reader["Don_gia"]);
                    lblMoTa.Text = reader["Mo_ta"].ToString();
                    lblXem.Text = reader["So_lan_xem"].ToString();
                    lblBan.Text = reader["So_luong_ban"].ToString();
                    imgBook.ImageUrl = reader["Hinh_minh_hoa"].ToString();
                }
                reader.Close();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSachCart.Value;
            int soLuong;
            if (!int.TryParse(Request.Form["cartQuantity"], out soLuong) || soLuong < 1)
            {
                soLuong = 1;
            }

            if (string.IsNullOrEmpty(maSach))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Không lấy được mã sách để thêm vào giỏ hàng!');", true);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            CartItem item = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_LayThongTinSachTheoMa", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MaSach", maSach);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    item = new CartItem()
                    {
                        MaSach = maSach,
                        TenSach = reader["Ten_sach"].ToString(),
                        DonGia = Convert.ToDecimal(reader["Don_gia"]),
                        SoLuong = soLuong,
                        HinhMinhHoa = reader["Hinh_minh_hoa"].ToString()
                    };
                }
                reader.Close();
            }

            if (item == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Sách không tồn tại hoặc đã bị xóa!');", true);
                return;
            }

            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();

            var existingItem = cart.FirstOrDefault(c => c.MaSach == maSach);
            if (existingItem != null)
            {
                existingItem.SoLuong += soLuong;
            }
            else
            {
                cart.Add(item);
            }

            Session["Cart"] = cart;

            lblCartCount.Text = $"Giỏ hàng hiện có {cart.Sum(i => i.SoLuong)} sản phẩm.";

            // Hiển thị alert thành công và đóng modal giỏ hàng Bootstrap
            string script = @"
        alert('Thêm vào giỏ hàng thành công!');
        var cartModalEl = document.getElementById('cartModal');
        var cartModal = bootstrap.Modal.getInstance(cartModalEl);
        if (cartModal) {
            cartModal.hide();
        }
    ";
            ScriptManager.RegisterStartupScript(this, GetType(), "cartSuccess", script, true);
        }
        protected void btnConfirmOrder_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSachOrder.Value;
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

            if (!int.TryParse(txtQuantityOrder.Text, out int soLuong) || soLuong <= 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "countFail",
                    "alert('Vui lòng nhập số lượng hợp lệ');", true);
                return;
            }

            string diaChiGiaoHang = txtAddressOrder.Text.Trim();
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
                var modal = bootstrap.Modal.getInstance(document.getElementById('orderModal'));
                modal.hide();
                setTimeout(function() {
                    window.location.href = 'Default.aspx';
                }, 1000);
            ", true);
        }

    }


    // Mẫu đối tượng CartItem để lưu trong Session giỏ hàng
    public class CartItem
    {
        public string MaSach { get; set; }
        public string TenSach { get; set; }
        public decimal DonGia { get; set; }
        public int SoLuong { get; set; }
        public string HinhMinhHoa { get; set; }
    }
}
