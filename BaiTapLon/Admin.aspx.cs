using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
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
                load_don_hang();
                LoadNXB();
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
            int nxb=int.Parse(drl_nxb.SelectedValue);
            string tacgiaChuoi = txt_tg.Text.Trim();  

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
                Ngay_cap_nhat = @Ngay_cap_nhat,
                Mnxb=@Mnxb
            WHERE Ms = @Ms";

                using (SqlCommand cmd = new SqlCommand(sqlUpdateSach, con))
                {
                    cmd.Parameters.AddWithValue("@Ten_Sach", ts);
                    cmd.Parameters.AddWithValue("@Don_Gia", dg);
                    cmd.Parameters.AddWithValue("@Mo_ta", mt);
                    cmd.Parameters.AddWithValue("@Mcd", chude);
                    cmd.Parameters.AddWithValue("@Ngay_cap_nhat", ngaycapnhat);
                    cmd.Parameters.AddWithValue("@Mnxb", nxb);
                    cmd.Parameters.AddWithValue("@Ms", ms);
                    cmd.ExecuteNonQuery();
                }

                // Xóa liên kết cũ
                string sqlDeleteOldTG = "DELETE FROM dbo.THAM_GIA WHERE Ms = @Ms";
                using (SqlCommand cmdDeleteTG = new SqlCommand(sqlDeleteOldTG, con))
                {
                    cmdDeleteTG.Parameters.AddWithValue("@Ms", ms);
                    cmdDeleteTG.ExecuteNonQuery();
                }

                // Thêm lại theo kiểu mới
                string[] tacgiaArray = tacgiaChuoi.Split(',');
                foreach (var tg in tacgiaArray)
                {
                    string[] parts = tg.Trim().Split(':');
                    if (parts.Length == 0) continue;

                    string ten = parts[0].Trim();
                    string vaitro = (parts.Length > 1) ? parts[1].Trim() : "Tác giả";

                    int mtg = 0;
                    string sqlCheckTG = "SELECT Mtg FROM TAC_GIA WHERE Ten_tac_gia = @Ten";
                    using (SqlCommand cmdCheck = new SqlCommand(sqlCheckTG, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@Ten", ten);
                        var result = cmdCheck.ExecuteScalar();
                        if (result != null)
                        {
                            mtg = (int)result;
                        }
                        else
                        {
                            string queryInsertTG = "INSERT INTO TAC_GIA (Ten_tac_gia, Dia_chi, Dien_thoai) VALUES (@Ten, '', ''); SELECT SCOPE_IDENTITY();";
                            using (SqlCommand cmdInsertTG = new SqlCommand(queryInsertTG, con))
                            {
                                cmdInsertTG.Parameters.AddWithValue("@Ten", ten);
                                mtg = Convert.ToInt32(cmdInsertTG.ExecuteScalar());
                            }
                        }
                    }

                    string sqlInsertTG = "INSERT INTO THAM_GIA (Ms, Mtg, Vai_tro) VALUES (@Ms, @Mtg, @VaiTro)";
                    using (SqlCommand cmdTG = new SqlCommand(sqlInsertTG, con))
                    {
                        cmdTG.Parameters.AddWithValue("@Ms", ms);
                        cmdTG.Parameters.AddWithValue("@Mtg", mtg);
                        cmdTG.Parameters.AddWithValue("@VaiTro", vaitro);
                        cmdTG.ExecuteNonQuery();
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

                // Kiểm tra sách đã từng phát sinh đơn hàng hay chưa
                string sqlCheck = "SELECT COUNT(*) FROM CT_DAT_HANG WHERE Ms = @Ms";
                SqlCommand cmdCheck = new SqlCommand(sqlCheck, con);
                cmdCheck.Parameters.AddWithValue("@Ms", ms);
                int count = (int)cmdCheck.ExecuteScalar();

                if (count > 0)
                {
                    // Đã có đơn hàng -> Chuyển trạng thái về 0 (ngừng KD)
                    string sqlUpdateTrangThai = "UPDATE SACH SET Trang_thai = 0 WHERE Ms = @Ms";
                    SqlCommand cmdUpdate = new SqlCommand(sqlUpdateTrangThai, con);
                    cmdUpdate.Parameters.AddWithValue("@Ms", ms);
                    cmdUpdate.ExecuteNonQuery();
                }
                else
                {
                    // Chưa có đơn hàng -> Xóa liên kết và xóa sách
                    // 1. Xóa các liên kết trong bảng THAM_GIA
                    string sqlDeleteTG = "DELETE FROM THAM_GIA WHERE Ms = @Ms";
                    using (SqlCommand cmdTG = new SqlCommand(sqlDeleteTG, con))
                    {
                        cmdTG.Parameters.AddWithValue("@Ms", ms);
                        cmdTG.ExecuteNonQuery();
                    }

                    // 2. Xóa sách chính
                    string sqlDeleteSach = "DELETE FROM SACH WHERE Ms = @Ms";
                    using (SqlCommand cmdDelete = new SqlCommand(sqlDeleteSach, con))
                    {
                        cmdDelete.Parameters.AddWithValue("@Ms", ms);
                        cmdDelete.ExecuteNonQuery();
                    }

                }
            }

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
            hoten.Text = string.Empty;
            NgaySINH.Text = string.Empty;
            diachi.Text = string.Empty;
            dienthoai.Text = string.Empty;
            username.Text = string.Empty;
            Password.Text = string.Empty;
            Email.Text = string.Empty;
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

                // 0. Kiểm tra xem khách hàng có phát sinh đơn hàng hay không
                using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM DON_DAT_HANG WHERE Mkh = @Mkh", con))
                {
                    checkCmd.Parameters.AddWithValue("@Mkh", mkh);
                    int count = (int)checkCmd.ExecuteScalar();

                    if (count > 0)
                    {
                        
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Không thể xoá khách hàng vì đã phát sinh đơn hàng.');", true);
                        return;
                    }
                }

                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.Transaction = tran;

                        cmd.CommandText = "DELETE FROM KHACH_HANG WHERE Mkh = @Mkh";
                        cmd.Parameters.AddWithValue("@Mkh", mkh);
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
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddl_Theloai.DataSource = dt;
                ddl_Theloai.DataTextField = "Ten_chu_de";
                ddl_Theloai.DataValueField = "Mcd";
                ddl_Theloai.DataBind();

                ddl_Theloai.Items.Insert(0, new ListItem("-- Chọn chủ đề --", ""));
                ddl_Theloai.Items.Add(new ListItem("Khác...", "khac"));

                drl_cd.DataSource = dt;
                drl_cd.DataTextField = "Ten_chu_de";
                drl_cd.DataValueField = "Mcd";
                drl_cd.DataBind();
                drl_cd.Items.Insert(0, new ListItem("--Chọn chủ đề --", ""));
            }
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            string ts = txt_tensach.Text.Trim();
            decimal.TryParse(txt_dongia.Text.Trim(), out decimal dg);
            string mt = txt_mota.Text.Trim();
            DateTime ngaycapnhat = DateTime.Now;

            int chude = -1;
            int nxb;
            string tacgiaChuoi = txt_tacgia.Text.Trim();

            string fileName = "";
            if (fu_hinh.HasFile)
            {
                string ext = Path.GetExtension(fu_hinh.FileName).ToLower();
                string[] allowed = { ".jpg", ".jpeg", ".png", ".gif" };
                if (allowed.Contains(ext))
                {
                    fileName = Path.GetFileName(fu_hinh.FileName);
                    string folderPath = Server.MapPath("~/Images/");
                    Directory.CreateDirectory(folderPath);
                    fu_hinh.SaveAs(Path.Combine(folderPath, fileName));
                }
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                

                if (ddl_NXB.SelectedValue == "khac")
                {
                    string ten = txtTenNXB.Text.Trim();
                    string diachi = txtDiaChiNXB.Text.Trim();
                    string dienthoai = txtDienThoaiNXB.Text.Trim();

                    string checkNXB = "SELECT COUNT(*) FROM NHA_XUAT_BAN WHERE Ten_nha_xuat_ban = @Ten";
                    using (SqlCommand cmdCheck = new SqlCommand(checkNXB, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@Ten", ten);
                        int count = (int)cmdCheck.ExecuteScalar();
                        if (count > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Nhà xuất bản đã tồn tại!');", true);
                            return;
                        }
                    }

                    string sqlInsertNXB = @"
                        INSERT INTO NHA_XUAT_BAN (Ten_nha_xuat_ban, Dia_chi, Dien_thoai)
                        VALUES (@Ten, @DiaChi, @DienThoai);
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmdInsert = new SqlCommand(sqlInsertNXB, con))
                    {
                        cmdInsert.Parameters.AddWithValue("@Ten", ten);
                        cmdInsert.Parameters.AddWithValue("@DiaChi", diachi);
                        cmdInsert.Parameters.AddWithValue("@DienThoai", dienthoai);
                        nxb = Convert.ToInt32(cmdInsert.ExecuteScalar());
                    }

                }
                else
                {
                    nxb = int.Parse(ddl_NXB.SelectedValue);
                }

                if (ddl_Theloai.SelectedValue == "khac" && !string.IsNullOrEmpty(txtChuDeMoi.Text))
                {
                    string tenCDMoi = txtChuDeMoi.Text.Trim();

                    string checkChuDe = "SELECT COUNT(*) FROM CHU_DE WHERE Ten_chu_de = @Ten";
                    using (SqlCommand cmdCheck = new SqlCommand(checkChuDe, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@Ten", tenCDMoi);
                        int count = (int)cmdCheck.ExecuteScalar();
                        if (count > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chủ đề đã tồn tại!');", true);
                            return;
                        }
                    }

                    string insertChuDe = "INSERT INTO CHU_DE (Ten_chu_de) VALUES (@Ten); SELECT SCOPE_IDENTITY();";
                    using (SqlCommand cmdInsert = new SqlCommand(insertChuDe, con))
                    {
                        cmdInsert.Parameters.AddWithValue("@Ten", tenCDMoi);
                        chude = Convert.ToInt32(cmdInsert.ExecuteScalar());
                    }
                }
                else if (!string.IsNullOrEmpty(ddl_Theloai.SelectedValue))
                {
                    chude = int.Parse(ddl_Theloai.SelectedValue);
                }
                // Kiểm tra trùng tên sách
                string checkSach = "SELECT COUNT(*) FROM SACH WHERE Ten_sach = @Ten";
                using (SqlCommand cmdCheck = new SqlCommand(checkSach, con))
                {
                    cmdCheck.Parameters.AddWithValue("@Ten", ts);
                    int count = (int)cmdCheck.ExecuteScalar();
                    if (count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Tên sách đã tồn tại!');", true);
                        return;
                    }
                }


                // 1. Thêm sách
                string sqlInsert = @"
                    INSERT INTO SACH (Ten_sach, Don_gia, Mo_ta, Mcd, Mnxb, Ngay_cap_nhat, Hinh_minh_hoa, Trang_thai)
                    VALUES (@Ten_sach, @Don_gia, @Mo_ta, @Mcd, @Mnxb, @Ngay_cap_nhat, @Hinh, 1);
                    SELECT SCOPE_IDENTITY();";
                int ms = 0;

                using (SqlCommand cmd = new SqlCommand(sqlInsert, con))
                {
                    cmd.Parameters.AddWithValue("@Ten_sach", ts);
                    cmd.Parameters.AddWithValue("@Don_gia", dg);
                    cmd.Parameters.AddWithValue("@Mo_ta", mt);
                    cmd.Parameters.AddWithValue("@Mcd", chude);
                    cmd.Parameters.AddWithValue("@Mnxb", nxb);
                    cmd.Parameters.AddWithValue("@Ngay_cap_nhat", ngaycapnhat);
                    cmd.Parameters.AddWithValue("@Hinh", fileName);
                    ms = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // 2. Xử lý tác giả + vai trò
                string[] tacgiaArray = tacgiaChuoi.Split(',');
                foreach (var tg in tacgiaArray)
                {
                    string[] parts = tg.Trim().Split(':');
                    if (parts.Length == 0) continue;

                    string ten = parts[0].Trim();
                    string vaitro = (parts.Length > 1) ? parts[1].Trim() : "Tác giả";

                    int mtg = 0;
                    string sqlCheckTG = "SELECT Mtg FROM TAC_GIA WHERE Ten_tac_gia = @Ten";
                    using (SqlCommand cmdCheck = new SqlCommand(sqlCheckTG, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@Ten", ten);
                        var result = cmdCheck.ExecuteScalar();
                        if (result != null)
                        {
                            mtg = (int)result;
                        }
                        else
                        {
                            string queryInsertTG = "INSERT INTO TAC_GIA (Ten_tac_gia, Dia_chi, Dien_thoai) VALUES (@Ten, '', ''); SELECT SCOPE_IDENTITY();";
                            using (SqlCommand cmdInsertTG = new SqlCommand(queryInsertTG, con))
                            {
                                cmdInsertTG.Parameters.AddWithValue("@Ten", ten);
                                mtg = Convert.ToInt32(cmdInsertTG.ExecuteScalar());
                            }
                        }
                    }

                    // Thêm vào THAM_GIA
                    string sqlInsertTG = "INSERT INTO THAM_GIA (Ms, Mtg, Vai_tro) VALUES (@Ms, @Mtg, @VaiTro)";
                    using (SqlCommand cmdTG = new SqlCommand(sqlInsertTG, con))
                    {
                        cmdTG.Parameters.AddWithValue("@Ms", ms);
                        cmdTG.Parameters.AddWithValue("@Mtg", mtg);
                        cmdTG.Parameters.AddWithValue("@VaiTro", vaitro);
                        cmdTG.ExecuteNonQuery();
                    }
                }
            }

            Load_Sach(); // Load lại sách
        }


        private void load_don_hang()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT * FROM dbo.V_DON_HANG_TONG_HOP ORDER BY Ngay_dat_hang DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                Grv_don_hang.DataSource = dt;
                Grv_don_hang.DataBind();
            }
        }
        protected void btnXacNhanGiao_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int sdh = int.Parse(btn.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE DON_DAT_HANG SET Da_giao_hang = 1, Ngay_giao_hang = GETDATE() WHERE Sdh = @Sdh", conn);
                cmd.Parameters.AddWithValue("@Sdh", sdh);
                cmd.ExecuteNonQuery();
            }

            load_don_hang();
        }

        protected void btnHuyDon_Click(object sender, EventArgs e)
        {
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

            load_don_hang();
        }
        protected void gvDonHang_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int daGiaoHang = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Da_giao_hang"));

                LinkButton btnXacNhanGiao = (LinkButton)e.Row.FindControl("lnkGiaoHang");
                LinkButton btnHuyDon = (LinkButton)e.Row.FindControl("lnkHuyDon");

                if (daGiaoHang == 1 || daGiaoHang == 2)
                {
                     btnXacNhanGiao.Enabled = false;
                    btnHuyDon.Enabled = false;

                }
                else
                {
                    btnXacNhanGiao.Visible = true;
                    btnHuyDon.Visible = true;
                }
            }
        }
        private void LoadNXB()
        {
            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Mnxb, Ten_nha_xuat_ban FROM NHA_XUAT_BAN";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddl_NXB.DataSource = dt;
                ddl_NXB.DataTextField = "Ten_nha_xuat_ban";
                ddl_NXB.DataValueField = "Mnxb";
                ddl_NXB.DataBind();

                drl_nxb.DataSource = dt;
                drl_nxb.DataTextField = "Ten_nha_xuat_ban";
                drl_nxb.DataValueField = "Mnxb";
                drl_nxb.DataBind();

                ddl_NXB.Items.Insert(0, new ListItem("-- Chọn NXB --", ""));
                ddl_NXB.Items.Add(new ListItem("Khác...", "khac"));
                drl_nxb.Items.Insert(0, new ListItem("-- Chọn NXB --", ""));
            }
        }

        protected void btnThemChuDe_Click(object sender, EventArgs e)
        {
            string tenCD = txtChuDeMoi.Text.Trim();
            if (string.IsNullOrEmpty(tenCD)) return;

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Kiểm tra trùng tên
                string checkSql = "SELECT COUNT(*) FROM CHU_DE WHERE Ten_chu_de = @Ten";
                using (SqlCommand cmdCheck = new SqlCommand(checkSql, con))
                {
                    cmdCheck.Parameters.AddWithValue("@Ten", tenCD);
                    int count = (int)cmdCheck.ExecuteScalar();
                    if (count == 0)
                    {
                        string insertSql = "INSERT INTO CHU_DE (Ten_chu_de) VALUES (@Ten)";
                        using (SqlCommand cmdInsert = new SqlCommand(insertSql, con))
                        {
                            cmdInsert.Parameters.AddWithValue("@Ten", tenCD);
                            cmdInsert.ExecuteNonQuery();
                        }
                    }
                }
            }

            LoadChuDe(); 
        }
        protected void ddl_Theloai_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtChuDeMoi.Visible = (ddl_Theloai.SelectedValue == "khac");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "showModal('Panel3');", true);
        }

        protected void ddl_NXB_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddl_NXB.SelectedValue == "khac")
            {
                pnlNXBMoi.Visible = true;
            }
            else
            {
                pnlNXBMoi.Visible = false;
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "showModal('Panel3');", true);
        }


    }
}
