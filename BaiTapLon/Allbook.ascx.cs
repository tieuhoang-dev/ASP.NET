using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Collections.Generic;
using System.Web.UI.WebControls.WebParts;
using BaiTapLon.Models;
using System.Web.UI.WebControls;
using System.Web.Caching;

namespace BaiTapLon
{
    public partial class Allbook : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
                bool isLoggedIn = Session["user_id"] != null;
                string script = $"<script>var isLoggedIn = {(isLoggedIn.ToString().ToLower())};</script>";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "LoginCheck", script);
            }


        }

        private void LoadBooks()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        *
                    FROM 
                        vw_ThongTinSach S
                    
                    ";

               

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptBooks.DataSource = dt;
                rptBooks.DataBind();
               
            }
        }
        protected string GetOnClientClick(string maSach, string tenSach, decimal donGia, string functionName)
        {
            // Escape chuỗi tenSach cho JS
            tenSach = tenSach.Replace("\"", "\\\"").Replace("'", "\\'");
            return $"{functionName}(\"{maSach}\", \"{tenSach}\", {donGia}); return false;";
        }
    }

}


