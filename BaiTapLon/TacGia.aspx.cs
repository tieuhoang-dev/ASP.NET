using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class TacGia : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load_Tac_Gia();
                rptBooks.DataSource = null;
                rptBooks.DataBind();
                pnlNoBooks.Visible = true;
                lblNoBooksMessage.Text = "Vui lòng chọn tác giả để xem sách.";
            }
            var HeaderControl = (Header)LoadControl("~/Header.ascx");
            phHeader.Controls.Clear();
            phHeader.Controls.Add(HeaderControl);
        }
        private void Load_Tac_Gia()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT * FROM dbo.TAC_GIA ";
                SqlDataAdapter da=new SqlDataAdapter(query, conn);
                DataTable dt=new DataTable();
                da.Fill(dt);
                rptTacGia.DataSource = dt;
                rptTacGia.DataBind();
            }
        }
        private void Sach_Of_Tac_Gia(int mtg)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_sachcuatacgia", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Mtg", mtg);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                rptBooks.DataSource = reader;
                rptBooks.DataBind();
            }

            if (rptBooks.Items.Count == 0)
            {
                pnlNoBooks.Visible = true;
                lblNoBooksMessage.Text = "Tác giả này chưa có sách nào.";
            }
            else
            {
                pnlNoBooks.Visible = false;
            }
        }
        protected void rptTacGia_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ChonTacGia")
            {
                int mtg = int.Parse(e.CommandArgument.ToString());
                ViewState["SelectedAuthor"] = mtg;
                Sach_Of_Tac_Gia(mtg);
            }
        }
    }
}