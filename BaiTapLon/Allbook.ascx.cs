using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

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
    }
}
