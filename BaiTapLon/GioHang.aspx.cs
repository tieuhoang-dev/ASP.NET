using BaiTapLon.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class GioHang1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGioHang();
            }

            var HeaderControl = (Header)LoadControl("~/Header.ascx");
            phHeader.Controls.Clear();
            phHeader.Controls.Add(HeaderControl);
        }

        private void LoadGioHang()
        {
            List<string> gioHang = Session["Cart"] as List<string>;

            if (gioHang == null || gioHang.Count == 0)
            {
                rptGioHang.Visible = false;
                lblTongTien.Text = "0.00 VNĐ";
                txttrangthai.Visible = true;
                txttrangthai.Text = "Giỏ Hàng Trống";
                return;
            }

            var soLuongTheoMa = gioHang.GroupBy(ms => ms)
                                      .ToDictionary(g => g.Key, g => g.Count());

            DataTable dt = GetBookDetails(soLuongTheoMa.Keys.ToList());

            if (dt.Rows.Count == 0)
            {
                rptGioHang.Visible = false;
                lblTongTien.Text = "0.00 VNĐ";
                return;
            }

            if (!dt.Columns.Contains("SoLuong"))
                dt.Columns.Add("SoLuong", typeof(int));

            decimal tongTien = 0;

            foreach (DataRow row in dt.Rows)
            {
                string ms = row["Ms"].ToString();
                int soLuong = soLuongTheoMa.ContainsKey(ms) ? soLuongTheoMa[ms] : 1;
                row["SoLuong"] = soLuong;

                decimal donGia = 0;
                decimal.TryParse(row["Don_gia"].ToString(), out donGia);
                tongTien += donGia * soLuong;
            }

            rptGioHang.Visible = true;
            rptGioHang.DataSource = dt;
            rptGioHang.DataBind();

            lblTongTien.Text = String.Format("{0:#,0} VNĐ", tongTien).Replace(',', '.');
        }

        private DataTable GetBookDetails(List<string> maSachList)
        {
            DataTable dt = new DataTable();

            if (maSachList == null || maSachList.Count == 0)
                return dt;

            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;

            string query = $"SELECT Ms, Ten_sach, Don_gia, Hinh_minh_hoa FROM SACH WHERE Ms IN ({string.Join(",", maSachList.Select((s, i) => $"@Ms{i}"))})";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                for (int i = 0; i < maSachList.Count; i++)
                {
                    cmd.Parameters.AddWithValue($"@Ms{i}", maSachList[i]);
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            return dt;
        }

        protected void rptGioHang_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string maSach = e.CommandArgument.ToString();
            List<string> gioHang = Session["Cart"] as List<string> ?? new List<string>();

            if (e.CommandName == "Cong")
            {
                gioHang.Add(maSach);
            }
            else if (e.CommandName == "Tru")
            {
                int index = gioHang.IndexOf(maSach);
                if (index >= 0)
                    gioHang.RemoveAt(index);
            }

            Session["Cart"] = gioHang;
            LoadGioHang();
            TinhTongTien();
        }
        private void TinhTongTien()
        {
            decimal tongTien = 0;

            foreach (RepeaterItem item in rptGioHang.Items)
            {
                CheckBox chkDatHang = (CheckBox)item.FindControl("chkDatHang");
                if (chkDatHang != null && chkDatHang.Checked)
                {
                    HiddenField hiddenDonGia = (HiddenField)item.FindControl("hiddenDonGia");
                    TextBox txtSoLuong = (TextBox)item.FindControl("txtSoLuong");

                    if (hiddenDonGia != null && txtSoLuong != null)
                    {
                        decimal donGia = 0;
                        int soLuong = 1;

                        decimal.TryParse(hiddenDonGia.Value, out donGia);
                        int.TryParse(txtSoLuong.Text, out soLuong);

                        tongTien += donGia * soLuong;
                    }
                }
            }

            lblTongTien.Text = String.Format("{0:#,0} VNĐ", tongTien).Replace(',', '.');
        }

        protected void txtSoLuong_TextChanged(object sender, EventArgs e)
        {
            TextBox txt = (TextBox)sender;
            RepeaterItem item = (RepeaterItem)txt.NamingContainer;

            int soLuong;
            if (!int.TryParse(txt.Text, out soLuong) || soLuong < 1)
            {
                soLuong = 1;
                txt.Text = "1";
            }

            List<string> gioHang = new List<string>();
            foreach (RepeaterItem i in rptGioHang.Items)
            {
                HiddenField hiddenMs = (HiddenField)i.FindControl("hiddenMs");
                TextBox txtSL = (TextBox)i.FindControl("txtSoLuong");
                CheckBox chk = (CheckBox)i.FindControl("chkDatHang");

                if (hiddenMs != null && txtSL != null && chk != null && chk.Checked)
                {
                    int sl = 1;
                    if (!int.TryParse(txtSL.Text, out sl) || sl < 1) sl = 1;
                    for (int j = 0; j < sl; j++)
                        gioHang.Add(hiddenMs.Value);
                }
            }

            Session["Cart"] = gioHang;

            // Tính lại tổng tiền
            TinhTongTien();
        }

        protected void chkDatHang_CheckedChanged(object sender, EventArgs e)
        {
            TinhTongTien();
        }

        protected void btnDatMua_Click(object sender, EventArgs e)
        {
            string soNha = txtSoNha.Text.Trim();
            string phuongXa = Request.Form["ddlPhuongXa"] ?? "";
            string quanHuyen = Request.Form["ddlQuanHuyen"] ?? "";
            string tinhThanh = Request.Form["ddlTinhThanh"] ?? "";

            string user_id = Session["user_id"]?.ToString();
            if (string.IsNullOrEmpty(user_id))
            {
                // Ghi nhớ để quay lại sau khi đăng nhập
                Session["ReturnUrl"] = "GioHang.aspx";
                string loginFailscript = @"
            alert('Vui lòng ĐĂNG NHẬP');
            setTimeout(function() {
                window.location.href = 'Login.aspx';
            }, 1000);
        ";
                ScriptManager.RegisterStartupScript(this, GetType(), "loginFail", loginFailscript, true);
                return;
            }

            string diaChiGiaoHang = $"{soNha}, {phuongXa}, {quanHuyen}, {tinhThanh}";
            if (string.IsNullOrEmpty(diaChiGiaoHang))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "addressFail",
                    "alert('Vui lòng nhập địa chỉ giao hàng');", true);
                return;
            }

            int maKhachHang = int.Parse(user_id);
            DataTable dtSachMua = new DataTable();
            dtSachMua.Columns.Add("Ms", typeof(int));
            dtSachMua.Columns.Add("So_luong", typeof(int));

            foreach (RepeaterItem item in rptGioHang.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chkDatHang");
                HiddenField hiddenMs = (HiddenField)item.FindControl("hiddenMs");
                TextBox txtSL = (TextBox)item.FindControl("txtSoLuong");

                if (chk != null && chk.Checked && hiddenMs != null && txtSL != null)
                {
                    int ms;
                    int soLuong;

                    if (int.TryParse(hiddenMs.Value, out ms) &&
                        int.TryParse(txtSL.Text, out soLuong) && soLuong > 0)
                    {
                        dtSachMua.Rows.Add(ms, soLuong);
                    }
                }
            }

            if (dtSachMua.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "noSelection",
                    "alert('Vui lòng chọn ít nhất một sản phẩm để đặt hàng');", true);
                return;
            }

            // Gọi stored procedure để lưu đơn hàng
            string connStr = ConfigurationManager.ConnectionStrings["QLbansachConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("dbo.DatDonHang_TheoMkh", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Mkh", maKhachHang);
                var tvpParam = cmd.Parameters.AddWithValue("@DanhSachSach", dtSachMua);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "dbo.SachMuaType";
                cmd.Parameters.AddWithValue("@DiaChiGiaoHang", diaChiGiaoHang);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Xóa sản phẩm đã đặt trong Session (nếu cần)
            Session["Cart"] = null;

            ScriptManager.RegisterStartupScript(this, GetType(), "successRedirect", @"
        alert('Đặt hàng thành công!');
        setTimeout(function() {
            window.location.href = 'Default.aspx';
        }, 1000);
    ", true);
        }

    }
}
