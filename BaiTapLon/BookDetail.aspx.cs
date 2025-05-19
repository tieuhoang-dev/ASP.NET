using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class BookDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack && Request.Form["btnSearchMaster"] != null)
            {
                string keyword = Request.Form["txtSearchMaster"]?.Trim();
                if (!string.IsNullOrEmpty(keyword))
                {
                    Session["searchKeyword"] = keyword;
                    Response.Redirect("~/Default.aspx");
                }
                return;
            }

            if (!IsPostBack && Request.QueryString["ms"] != null)
            {
                string maSach = Request.QueryString["ms"];
                LoadBookDetail(maSach);
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
    }
}
