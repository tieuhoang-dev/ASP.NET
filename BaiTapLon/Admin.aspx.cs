using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Lab05
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load_Khach_Hang();
                Load_Sach();
                LoadChuDe();
                hfSection.Value = "khachhang";
            }

            string activeSection = hfSection.Value;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showSection", $"showSection('{activeSection}');", true);

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
        private void Load_Sach()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT * FROM dbo.vw_ThongTinSach";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
               Grv_Sach.DataSource = dt;
                Grv_Sach.DataBind();
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

        protected void btnSave1_Click(object sender, EventArgs e)
        {
            int ms = int.Parse(hf_ms.Value);
            string ts = txt_ts.Text.Trim();
            decimal dg = 0;
            decimal.TryParse(txt_dg.Text.Trim(), out dg);
            string mt = txt_mt.Text.Trim();
            DateTime ngaycapnhat = DateTime.Now;

            int chude = int.Parse(drl_cd.SelectedValue);
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Cập nhật thông tin sách
                string sqlUpdateSach = @"
            UPDATE dbo.SACH SET 
                Ten_sach = @Ten_Sach,
                Don_gia = @Don_Gia,
                Mo_ta = @Mo_ta,
                Mcd = @Mcd,
                Ngay_cap_nhat = @Ngay_cap_nhat
            WHERE Ms = @Ms";

                using (SqlCommand cmd = new SqlCommand(sqlUpdateSach, con))
                {
                    cmd.Parameters.AddWithValue("@Ten_Sach", ts);
                    cmd.Parameters.AddWithValue("@Don_Gia", dg);
                    cmd.Parameters.AddWithValue("@Mo_ta", mt);
                    cmd.Parameters.AddWithValue("@Mcd", chude);
                    cmd.Parameters.AddWithValue("@Ngay_cap_nhat", ngaycapnhat);
                    cmd.Parameters.AddWithValue("@Ms", ms);
                    cmd.ExecuteNonQuery();
                }

                // 2. Xử lý danh sách tác giả
                string[] tacgiaList = txt_tg.Text.Trim()
                    .Split(',')
                    .Select(t => t.Trim())
                    .Where(t => !string.IsNullOrEmpty(t))
                    .ToArray();

                // 3. Xóa liên kết cũ trong bảng THAM_GIA
                string sqlDeleteOldTG = "DELETE FROM dbo.THAM_GIA WHERE Ms = @Ms";
                using (SqlCommand cmdDeleteTG = new SqlCommand(sqlDeleteOldTG, con))
                {
                    cmdDeleteTG.Parameters.AddWithValue("@Ms", ms);
                    cmdDeleteTG.ExecuteNonQuery();
                }

                // 4. Duyệt từng tác giả, kiểm tra - thêm nếu chưa có - rồi liên kết vào bảng THAM_GIA
                foreach (string tg in tacgiaList)
                {
                    int mtg = 0;

                    // Kiểm tra xem tác giả đã tồn tại chưa
                    string sqlCheckTacGia = "SELECT Mtg FROM dbo.TAC_GIA WHERE Ten_tac_gia = @TenTacGia";
                    using (SqlCommand cmdCheck = new SqlCommand(sqlCheckTacGia, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@TenTacGia", tg);
                        object result = cmdCheck.ExecuteScalar();
                        if (result != null)
                        {
                            mtg = Convert.ToInt32(result);
                        }
                        else
                        {
                            string sqlInsertTacGia = @"
                        INSERT INTO dbo.TAC_GIA (Ten_tac_gia, Dia_chi, Dien_thoai)
                        VALUES (@TenTacGia, '', '');
                        SELECT CAST(scope_identity() AS int)";
                            using (SqlCommand cmdInsert = new SqlCommand(sqlInsertTacGia, con))
                            {
                                cmdInsert.Parameters.AddWithValue("@TenTacGia", tg);
                                mtg = (int)cmdInsert.ExecuteScalar();
                            }
                        }
                    }

                    // Thêm liên kết vào THAM_GIA
                    string sqlInsertThamGia = "INSERT INTO dbo.THAM_GIA (Ms, Mtg, Vai_tro) VALUES (@Ms, @Mtg, @VaiTro)";
                    using (SqlCommand cmdInsertTG = new SqlCommand(sqlInsertThamGia, con))
                    {
                        cmdInsertTG.Parameters.AddWithValue("@Ms", ms);
                        cmdInsertTG.Parameters.AddWithValue("@Mtg", mtg);
                        cmdInsertTG.Parameters.AddWithValue("@VaiTro", "Tác giả");
                        cmdInsertTG.ExecuteNonQuery();
                    }
                }
            }

            Load_Sach();
            LoadChuDe();
        }

        protected void DeleteSach(int ms)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Xóa các liên kết tác giả trong bảng THAM_GIA
                string sqlDeleteTG = "DELETE FROM dbo.THAM_GIA WHERE Ms = @Ms";
                using (SqlCommand cmdDeleteTG = new SqlCommand(sqlDeleteTG, con))
                {
                    cmdDeleteTG.Parameters.AddWithValue("@Ms", ms);
                    cmdDeleteTG.ExecuteNonQuery();
                }

                // 2. Xóa sách trong bảng SACH
                string sqlDeleteSach = "DELETE FROM dbo.SACH WHERE Ms = @Ms";
                using (SqlCommand cmdDeleteSach = new SqlCommand(sqlDeleteSach, con))
                {
                    cmdDeleteSach.Parameters.AddWithValue("@Ms", ms);
                    cmdDeleteSach.ExecuteNonQuery();
                }
            }

            // Sau khi xóa, load lại danh sách
            Load_Sach();
        }

        protected void btnXoaSach_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int maSach = int.Parse(btn.CommandArgument);
            DeleteSach(maSach);  
            Load_Sach();         
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

            private void LoadChuDe()
            {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Mcd, Ten_chu_de FROM CHU_DE";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                drl_cd.DataSource = dt;
                drl_cd.DataTextField = "Ten_chu_de";
                drl_cd.DataValueField = "Mcd";
                drl_cd.DataBind();
                ddl_Theloai.DataSource = dt; 
                ddl_Theloai.DataTextField = "Ten_chu_de";
                ddl_Theloai.DataValueField = "Mcd";
                ddl_Theloai.DataBind();
                drl_cd.Items.Insert(0, new ListItem("-- Chọn chủ đề --", ""));
                ddl_Theloai.Items.Insert(0, new ListItem("-- Chọn chủ đề --", ""));
            }
            }
        protected void btnThem_Click(object sender, EventArgs e)
        {
            string ts = txt_tensach.Text.Trim();
            decimal dg = 0;
            decimal.TryParse(txt_dongia.Text.Trim(), out dg);
            string mt = txt_mota.Text.Trim();
            DateTime ngaycapnhat = DateTime.Now;
            int chude = int.Parse(ddl_Theloai.SelectedValue);
            string tg = txt_tacgia.Text.Trim();

            // Xử lý hình ảnh
            string fileName = "";
            if (fu_hinh.HasFile)
            {
                string ext = Path.GetExtension(fu_hinh.FileName).ToLower();
                string[] allowed = { ".jpg", ".jpeg", ".png", ".gif" };
                if (allowed.Contains(ext))
                {
                    fileName = Path.GetFileName(fu_hinh.FileName);
                    string folderPath = Server.MapPath("~/Images/");
                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }
                    string filePath = Path.Combine(folderPath, fileName);
                    fu_hinh.SaveAs(filePath);
                }
            }

            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Thêm sách vào bảng SACH (có thêm trường Hinh_minh_hoa nếu có)
                string sqlInsertSach = @"
            INSERT INTO dbo.SACH (Ten_sach, Don_gia, Mo_ta, Mcd, Ngay_cap_nhat, Hinh_minh_hoa)
            VALUES (@Ten_sach, @Don_gia, @Mo_ta, @Mcd, @Ngay_cap_nhat, @Hinh_minh_hoa);
            SELECT CAST(SCOPE_IDENTITY() AS int)";
                int ms = 0;
                using (SqlCommand cmd = new SqlCommand(sqlInsertSach, con))
                {
                    cmd.Parameters.AddWithValue("@Ten_sach", ts);
                    cmd.Parameters.AddWithValue("@Don_gia", dg);
                    cmd.Parameters.AddWithValue("@Mo_ta", mt);
                    cmd.Parameters.AddWithValue("@Mcd", chude);
                    cmd.Parameters.AddWithValue("@Ngay_cap_nhat", ngaycapnhat);
                    cmd.Parameters.AddWithValue("@Hinh_minh_hoa", fileName);
                    ms = (int)cmd.ExecuteScalar();
                }

                // 2. Xử lý tác giả (nhiều tác giả, cách nhau bằng dấu phẩy)
                string[] tacGiaList = tg.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (string tenTacGiaRaw in tacGiaList)
                {
                    string tenTacGia = tenTacGiaRaw.Trim();
                    if (tenTacGia == "") continue;

                    string sqlCheckTG = "SELECT Mtg FROM dbo.TAC_GIA WHERE Ten_tac_gia = @TenTacGia";
                    int mtg = 0;
                    using (SqlCommand cmdCheck = new SqlCommand(sqlCheckTG, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@TenTacGia", tenTacGia);
                        object result = cmdCheck.ExecuteScalar();
                        if (result != null)
                        {
                            mtg = Convert.ToInt32(result);
                        }
                        else
                        {
                            string sqlInsertTG = @"
                            INSERT INTO dbo.TAC_GIA (Ten_tac_gia, Dia_chi, Dien_thoai)
                            VALUES (@TenTacGia, '', '');
                            SELECT CAST(SCOPE_IDENTITY() AS int)";
                            using (SqlCommand cmdInsertTG = new SqlCommand(sqlInsertTG, con))
                            {
                                cmdInsertTG.Parameters.AddWithValue("@TenTacGia", tenTacGia);
                                mtg = (int)cmdInsertTG.ExecuteScalar();
                            }
                        }
                    }

                    // 3. Thêm vào bảng THAM_GIA
                    string sqlInsertThamGia = "INSERT INTO dbo.THAM_GIA (Ms, Mtg, Vai_tro) VALUES (@Ms, @Mtg, @VaiTro)";
                    using (SqlCommand cmdTG = new SqlCommand(sqlInsertThamGia, con))
                    {
                        cmdTG.Parameters.AddWithValue("@Ms", ms);
                        cmdTG.Parameters.AddWithValue("@Mtg", mtg);
                        cmdTG.Parameters.AddWithValue("@VaiTro", "Tác giả");
                        cmdTG.ExecuteNonQuery();
                    }
                }
            }

            Load_Sach(); // Load lại danh sách sau khi thêm
        }

    }
}
