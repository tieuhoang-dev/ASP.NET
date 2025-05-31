using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace Lab05
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load_Khach_Hang();
            }
        }

        private void Load_Khach_Hang()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT * FROM dbo.KHACH_HANG";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GrV_Kh.DataSource = dt;
                GrV_Kh.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int mkh = int.Parse(hfMkh.Value); // hidden field trong modal sửa
            string hoten = txtHoTen.Text.Trim();
            string diachi = txtDiaChi.Text.Trim();
            string dienthoai = txtDienThoai.Text.Trim();
            DateTime ngaysinh;

            if (!DateTime.TryParseExact(txtNgaySinh.Text.Trim(), "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out ngaysinh))
            {
                ngaysinh = DateTime.MinValue; 
            }

            int gioitinh = int.Parse(ddlGioiTinh.SelectedValue);
            string email = txtEmail.Text.Trim();

            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string sql = @"UPDATE dbo.KHACH_HANG SET 
                        Ho_ten = @Ho_ten,
                        Dia_chi = @Dia_chi,
                        Dien_thoai = @Dien_thoai,
                        Ngay_sinh = @Ngay_sinh,
                        Gioi_tinh = @Gioi_tinh,
                        Email = @Email
                       WHERE Mkh = @Mkh";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Ho_ten", hoten);
                    cmd.Parameters.AddWithValue("@Dia_chi", diachi);
                    cmd.Parameters.AddWithValue("@Dien_thoai", dienthoai);
                    cmd.Parameters.AddWithValue("@Ngay_sinh", ngaysinh == DateTime.MinValue ? DBNull.Value : (object)ngaysinh);
                    cmd.Parameters.AddWithValue("@Gioi_tinh", gioitinh);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mkh", mkh);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Load_Khach_Hang();
        }


        protected void btnadd_Click(object sender, EventArgs e)
        {
            if (IsUsernameTaken(username.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Tên đăng nhập đã tồn tại!');", true);
                return;
            }
            int gioitinh = int.Parse(GioTinh.SelectedValue);
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            string matkhau=Password.Text;
            string hashedPassword = HashPassword(matkhau);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO dbo.KHACH_HANG 
                                (Ho_ten, Ngay_sinh, Dien_thoai, Ten_dang_nhap, Mat_khau, Gioi_tinh, Dia_chi, Email) 
                                VALUES (@HoTen, @NgaySinh, @DienThoai, @TenDN, @MatKhau, @GioiTinh, @DiaChi, @Email)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@HoTen", hoten.Text);
                cmd.Parameters.AddWithValue("@NgaySinh", NgaySINH.Text);
                cmd.Parameters.AddWithValue("@DiaChi", diachi.Text);
                cmd.Parameters.AddWithValue("@DienThoai", dienthoai.Text);
                cmd.Parameters.AddWithValue("@TenDN", username.Text);
                cmd.Parameters.AddWithValue("@MatKhau", hashedPassword);
                cmd.Parameters.AddWithValue("@GioiTinh", gioitinh);
                cmd.Parameters.AddWithValue("@Email", Email.Text);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            hoten.Text = "";
            NgaySINH.Text = "";
            diachi.Text = "";
            dienthoai.Text = "";
            username.Text = "";
            Password.Text = "";
            Email.Text = "";
            GioTinh.SelectedIndex = 0;
            Load_Khach_Hang();
        }

        protected void btnXoa_Click(object sender, EventArgs e)
        {
            int mkh = int.Parse(hfMkhDelete.Value); 

            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.Transaction = tran;

                        // 1. Xoá chi tiết đơn hàng
                        cmd.CommandText = @"DELETE CT 
                                            FROM CT_DAT_HANG CT
                                            INNER JOIN DON_DAT_HANG DD ON CT.Sdh = DD.Sdh
                                            WHERE DD.Mkh = @Mkh";
                        cmd.Parameters.AddWithValue("@Mkh", mkh);
                        cmd.ExecuteNonQuery();

                        // 2. Xoá đơn hàng
                        cmd.CommandText = "DELETE FROM DON_DAT_HANG WHERE Mkh = @Mkh";
                        cmd.ExecuteNonQuery();

                        // 3. Xoá khách hàng
                        cmd.CommandText = "DELETE FROM KHACH_HANG WHERE Mkh = @Mkh";
                        cmd.ExecuteNonQuery();

                        tran.Commit();
                    }
                }
                catch
                {
                    tran.Rollback();
                    throw;
                }
            }

            Load_Khach_Hang();
        }
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);
                StringBuilder builder = new StringBuilder();
                foreach (byte b in hash)
                    builder.Append(b.ToString("X2"));
                return builder.ToString();
            }
        }
        private bool IsUsernameTaken(string username)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM KHACH_HANG WHERE Ten_dang_nhap = @TenDN";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TenDN", username);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();

                return count > 0;
            }
        }
    }
}
