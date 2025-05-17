using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class BookOfGenre : System.Web.UI.UserControl
    {
        public string TenChuDe { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !string.IsNullOrEmpty(TenChuDe))
            {
                LoadData();
            }
        }
        private void LoadData()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_TimSachTheoChuDe", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TuKhoa", TenChuDe);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                rptBookOfGenre.DataSource = reader;
                rptBookOfGenre.DataBind();
            }
        }
    }
}