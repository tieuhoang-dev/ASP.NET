using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class DangKy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Text = "";
        }
        protected void btnDangKy_Click(object sender, EventArgs e)
        {
            string tenDangNhap = txtTenDangNhap.Text.Trim();
            string matKhau = txtMatKhau.Text;
            string hoTen = txtHoTen.Text.Trim();
            string diaChi = txtDiaChi.Text.Trim();
            string dienThoai = txtDienThoai.Text.Trim();
            string email = txtEmail.Text.Trim();
            string ngaySinhText = txtNgaySinh.Text.Trim();
            int gioiTinh = rblGioiTinh.SelectedValue == "1" ? 1 : 0;

            if (string.IsNullOrEmpty(tenDangNhap) || string.IsNullOrEmpty(matKhau) || string.IsNullOrEmpty(hoTen))
            {
                lblMessage.Text = "Tên đăng nhập, mật khẩu và họ tên là bắt buộc.";
                return;
            }

            DateTime ngaySinh;
            if (!DateTime.TryParse(ngaySinhText, out ngaySinh))
            {
                lblMessage.Text = "Ngày sinh không hợp lệ.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Kiểm tra username đã tồn tại chưa
                string checkUserSql = "SELECT COUNT(*) FROM KHACH_HANG WHERE Ten_dang_nhap = @TenDangNhap";
                using (SqlCommand cmdCheck = new SqlCommand(checkUserSql, conn))
                {
                    cmdCheck.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                    int count = (int)cmdCheck.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMessage.Text = "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.";
                        return;
                    }
                }

                // Mã hóa mật khẩu bằng SHA-256
                string hashedPassword = HashPassword(matKhau);

                // Insert dữ liệu
                string insertSql = @"
                    INSERT INTO KHACH_HANG (Ho_ten, Dia_chi, Dien_thoai, Ten_dang_nhap, Mat_khau, Ngay_sinh, Gioi_tinh, Email) 
                    VALUES (@HoTen, @DiaChi, @DienThoai, @TenDangNhap, @MatKhau, @NgaySinh, @GioiTinh, @Email)";

                using (SqlCommand cmdInsert = new SqlCommand(insertSql, conn))
                {
                    cmdInsert.Parameters.AddWithValue("@HoTen", hoTen);
                    cmdInsert.Parameters.AddWithValue("@DiaChi", diaChi);
                    cmdInsert.Parameters.AddWithValue("@DienThoai", dienThoai);
                    cmdInsert.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                    cmdInsert.Parameters.AddWithValue("@MatKhau", hashedPassword);
                    cmdInsert.Parameters.AddWithValue("@NgaySinh", ngaySinh);
                    cmdInsert.Parameters.AddWithValue("@GioiTinh", gioiTinh);
                    cmdInsert.Parameters.AddWithValue("@Email", email);

                    int rowsAffected = cmdInsert.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.";
                        ClearForm();
                        Response.Redirect("Login.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Đăng ký thất bại. Vui lòng thử lại.";
                    }
                }
            }
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

        private void ClearForm()
        {
            txtTenDangNhap.Text = "";
            txtMatKhau.Text = "";
            txtHoTen.Text = "";
            txtDiaChi.Text = "";
            txtDienThoai.Text = "";
            txtEmail.Text = "";
            txtNgaySinh.Text = "";
            rblGioiTinh.ClearSelection();
        }
    }
}