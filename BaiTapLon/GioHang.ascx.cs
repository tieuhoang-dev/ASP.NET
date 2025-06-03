using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class GioHang : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindGioHang();
        }

        private void BindGioHang()
        {
            List<string> gioHang = Session["Cart"] as List<string>;

            if (gioHang == null || gioHang.Count == 0)
            {
                rptGioHang.Visible = false;
                lblEmpty.Visible = true;
                lnkXemGioHang.Visible = false;
                return;
            }

            DataTable dt = GetBookDetails(gioHang);

            if (dt.Rows.Count == 0)
            {
                rptGioHang.Visible = false;
                lblEmpty.Visible = true;
                lnkXemGioHang.Visible = false;
                return;
            }

            rptGioHang.Visible = true;
            lblEmpty.Visible = false;
            lnkXemGioHang.Visible = true;

            rptGioHang.DataSource = dt;
            rptGioHang.DataBind();

        }

        private DataTable GetBookDetails(List<string> maSachList)
        {
            DataTable dt = new DataTable();

            if (maSachList == null || maSachList.Count == 0)
                return dt;

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            string query = $"SELECT Ms, Ten_sach, Don_gia, Hinh_minh_hoa FROM SACH WHERE Ms IN ({string.Join(",", maSachList.Select((s, i) => $"@Ms{i}"))})";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                for (int i = 0; i < maSachList.Count; i++)
                {
                    cmd.Parameters.AddWithValue($"@Ms{i}", maSachList[i]);
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            return dt;
        }

        protected void rptGioHang_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Xoa")
            {
                string maSachXoa = e.CommandArgument.ToString();
                List<string> gioHang = Session["Cart"] as List<string>;

                if (gioHang != null && gioHang.Contains(maSachXoa))
                {
                    gioHang.Remove(maSachXoa);
                    Session["Cart"] = gioHang;
                }

                Response.Redirect(Request.RawUrl);
            }
        }
    }
}
