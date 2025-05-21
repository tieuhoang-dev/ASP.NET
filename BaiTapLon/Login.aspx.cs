using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace BaiTapLon
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            Session.Clear();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string hashedPassword = BitConverter.ToString(
                System.Security.Cryptography.SHA256.Create().ComputeHash(
                    System.Text.Encoding.UTF8.GetBytes(password)
                )
            ).Replace("-", "");

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Mkh, Ho_ten FROM Khach_Hang WHERE Ten_dang_nhap = @username AND Mat_khau = @password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", hashedPassword);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["user_id"] = reader["Mkh"];
                    Session["user_name"] = reader["Ho_ten"];
                    Session["username"] = username;

                    string returnUrl = Request.QueryString["returnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("Default.aspx"); 
                    }
                }
                else
                {
                    lblError.Text = "Sai tên đăng nhập hoặc mật khẩu!";
                    lblError.Visible = true;
                }

                reader.Close();
                
            }
        }
    }
}
