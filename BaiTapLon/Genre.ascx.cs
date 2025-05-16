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
    public partial class Genre : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("<p style='color:blue;'>Genre.aspx ĐANG CHẠY</p>");
            if (!IsPostBack)
            {
                LoadChuDe();
            }
        }
        private void LoadChuDe()
        {
            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT CD.Mcd, CD.Ten_chu_de, COUNT(S.Ms) AS SoLuongSach
                         FROM CHU_DE CD
                         LEFT JOIN SACH S ON CD.Mcd = S.Mcd
                         GROUP BY CD.Mcd, CD.Ten_chu_de";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptChuDe.DataSource = dt;
                rptChuDe.DataBind();
            }
        }
    }
}