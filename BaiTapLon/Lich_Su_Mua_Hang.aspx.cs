using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Runtime.Remoting.Messaging;

namespace BaiTapLon
{
    public partial class Lich_Su_Mua_Hang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user_id"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                if (!IsPostBack)
                {
                    string makh = Session["user_id"]?.ToString();
                    loadDonHang(makh);
                }
                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);

            }
        }
        private void loadDonHang(string makh)
        {
            string sql = "SELECT * FROM V_DON_HANG_TONG_HOP WHERE Mkh = @Mkh ORDER BY Ngay_dat_hang DESC";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Mkh", makh);
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvDonHang.DataSource = dt;
                gvDonHang.DataBind();
            }
        }
        protected void btnHuyDon_Click(object sender, EventArgs e)
        {
            string makh = Session["user_id"]?.ToString();

            LinkButton btn = (LinkButton)sender;
            int sdh = int.Parse(btn.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE DON_DAT_HANG SET Da_giao_hang = 2 WHERE Sdh = @Sdh", conn);
                cmd.Parameters.AddWithValue("@Sdh", sdh);
                cmd.ExecuteNonQuery();
            }

            loadDonHang(makh);
        }
    }
}