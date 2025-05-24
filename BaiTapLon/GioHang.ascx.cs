using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using BaiTapLon.Models;

namespace BaiTapLon
{
    public partial class GioHang : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindGioHang();
        }

        private void BindGioHang()
        {
            List<CartItem> gioHang = Session["Cart"] as List<CartItem>;

            if (gioHang == null || gioHang.Count == 0)
            {
                rptGioHang.Visible = false;
                lblEmpty.Visible = true;
                lblTongTien.Text = "0 VNĐ";
                lnkXemGioHang.Visible = false;
                return;
            }

            rptGioHang.Visible = true;
            lblEmpty.Visible = false;
            lnkXemGioHang.Visible = true;

            rptGioHang.DataSource = gioHang;
            rptGioHang.DataBind();

            // Tính tổng tiền
            decimal tongTien = gioHang.Sum(item => item.DonGia * item.SoLuong);
            lblTongTien.Text = string.Format("{0:N0} VNĐ", tongTien);
        }

        protected void rptGioHang_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Xoa")
            {
                string maSachXoa = e.CommandArgument.ToString();
                List<CartItem> gioHang = Session["Cart"] as List<CartItem>;

                if (gioHang != null)
                {
                    CartItem itemXoa = gioHang.FirstOrDefault(x => x.MaSach == maSachXoa);
                    if (itemXoa != null)
                    {
                        gioHang.Remove(itemXoa);
                        Session["Cart"] = gioHang;
                    }
                }

                Response.Redirect("~/Default.aspx");
            }
        }
    }
}
