using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Collections.Generic;
using System.Web.UI.WebControls.WebParts;
using BaiTapLon.Models;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class Allbook : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
            }


        }

        private void LoadBooks()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT S.*, C.Ten_chu_de AS TenChuDe, TG.Ten_tac_gia AS TenTacGia " +
                               "FROM vw_ThongTinSach S " +
                               "LEFT JOIN dbo.THAM_GIA TGIA ON S.MaSach = TGIA.Ms " +
                               "LEFT JOIN dbo.TAC_GIA TG ON TG.Mtg = TGIA.Mtg " +
                               "LEFT JOIN dbo.CHU_DE C ON S.MaChuDe = C.Mcd";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptBooks.DataSource = dt;
                rptBooks.DataBind();
            }
        }
        protected void BuyNow_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maSach = btn.CommandArgument;

            
        }
        protected void btnConfirmOrder_Click(object sender, EventArgs e)
        {
            string maSach = hfMaSach.Value; 
            litMaSach.Text = maSach;
            if (string.IsNullOrEmpty(maSach))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Không lấy được mã sách.');", true);
                return;
            }

            string user_id = Session["user_id"]?.ToString();
            if (string.IsNullOrEmpty(user_id))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng đăng nhập.');", true);
                return;
            }

            int maKhachHang = int.Parse(user_id);
            int ms = int.Parse(maSach);

            if (!int.TryParse(txtQuantity.Text, out int soLuong) || soLuong <= 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Số lượng không hợp lệ');", true);
                return;
            }

            string diaChiGiaoHang = txtAddress.Text.Trim();
            if (string.IsNullOrEmpty(diaChiGiaoHang))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng nhập địa chỉ giao hàng');", true);
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

            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đặt hàng thành công!'); closeModal();", true);

            Response.Redirect("Default.aspx");
        }

    }
}
