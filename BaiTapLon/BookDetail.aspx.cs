using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using BaiTapLon.Models;

namespace BaiTapLon
{
    public partial class BookDetail : System.Web.UI.Page
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
            string maSach = hfMaSach.Value;
            int soLuong;
            if (!int.TryParse(hfQuantity.Value, out soLuong) || soLuong < 1)
            {
                soLuong = 1; 
            }

            if (string.IsNullOrEmpty(maSach))
            {
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
                        SoLuong = soLuong
                    };
                }
                reader.Close();
            }

            if (item == null)
            {
                return;
            }

            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();

            CartItem existing = cart.FirstOrDefault(c => c.MaSach == item.MaSach);
            if (existing != null)
            {
                existing.SoLuong += item.SoLuong;
            }
            else
            {
                cart.Add(item);
            }

            Session["Cart"] = cart;

            string script = $"alert('Đã thêm {item.SoLuong} sản phẩm vào giỏ hàng!');";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", script, true);

            script = "document.getElementById('cartDialog').style.display = 'none';";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "closeDialog", script, true);
        }

    }
}
