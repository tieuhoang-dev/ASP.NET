using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

namespace BaiTapLon
{
    public partial class User_Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user_id"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                if (!IsPostBack)
                {
                    string makh = Session["user_id"]?.ToString();
                    loadThongTinNguoiDung(makh);
                    loadDonHang(makh);
                    string tenDangNhap = Session["username"]?.ToString();
                    txtTenDangNhap.Text = tenDangNhap;
                }
                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);
            }
        }
        private void loadThongTinNguoiDung(string makh)
        {
            string sql = "SELECT * FROM KHACH_HANG WHERE Mkh = @Mkh";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Mkh", makh);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblHoTen.Text = reader["Ho_ten"].ToString();
                    lblMaKH.Text = reader["Mkh"].ToString();
                    lblEmail.Text = reader["Email"].ToString();
                    lblDiaChi.Text = reader["Dia_chi"].ToString();
                    lblDienThoai.Text = reader["Dien_thoai"].ToString();
                    int gioiTinh = Convert.ToInt32(reader["Gioi_tinh"]);
                    lblGioiTinh.Text = gioiTinh == 1 ? "Nam" : "Nữ";
                }
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
        protected void btnchangeinfo_click(object sender, EventArgs e)
        {
            string makh = Session["user_id"]?.ToString();

            string HoTen =txtHoTen.Text;
            string sdt = txtDienThoai.Text;
            string diachi=txtDiaChi.Text;
            int gioitinh=int.Parse(ddlGioiTinh.SelectedValue);
            string email=txtEmail.Text;
            string ngaysinh=txtNgaySinh.Text;
            string dienthoai=txtDienThoai.Text;
            string sql = "UPDATE dbo.KHACH_HANG SET Ho_ten=@Ho_ten,Dia_chi=@Dia_chi,Dien_thoai=@Dien_thoai,Ngay_sinh=@Ngay_sinh,Gioi_tinh=@Gioi_tinh,Email=@Email WHERE Mkh=@Mkh";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@Ho_ten",HoTen);
                cmd.Parameters.AddWithValue("@Dia_chi", diachi);
                cmd.Parameters.AddWithValue("@Dien_thoai", dienthoai);
                cmd.Parameters.AddWithValue("@Ngay_sinh", ngaysinh);
                cmd.Parameters.AddWithValue("@Gioi_tinh",gioitinh);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Mkh", makh);
                cmd.ExecuteNonQuery();
            }
            loadThongTinNguoiDung(makh);
            txtHoTen.Text = string.Empty;
            txtDienThoai.Text = string.Empty;
            txtDiaChi.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtNgaySinh.Text = string.Empty;
            ddlGioiTinh.Text = string.Empty;
        }
        protected void btnLuuMatKhau_Click(object sender, EventArgs e)
        {
            string tenDangNhap = Session["username"]?.ToString();
            string matKhauCu = txtMatKhauCu.Text.Trim();
            string matKhauMoi = txtMatKhauMoi.Text.Trim();

            // 1. Hash lại mật khẩu cũ để so sánh
            string hashedOld = HashPassword(matKhauCu);
            string hashedNew = HashPassword(matKhauMoi);

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString))
            {
                conn.Open();

                // Kiểm tra mật khẩu cũ có đúng không
                string checkQuery = "SELECT COUNT(*) FROM KHACH_HANG WHERE Ten_dang_nhap = @User AND Mat_khau = @OldPass";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@User", tenDangNhap);
                checkCmd.Parameters.AddWithValue("@OldPass", hashedOld);

                int exists = (int)checkCmd.ExecuteScalar();
                if (exists == 1)
                {
                    string updateQuery = "UPDATE KHACH_HANG SET Mat_khau = @NewPass WHERE Ten_dang_nhap = @User";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@NewPass", hashedNew);
                    updateCmd.Parameters.AddWithValue("@User", tenDangNhap);
                    updateCmd.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Đổi mật khẩu thành công!');", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Mật khẩu cũ không đúng!');", true);
                }
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(bytes).Replace("-", "");
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