using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BaiTapLon
{
    public partial class Header : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HandleLogout();

            UpdateLoginUI();
            if (IsPostBack && Request.Form["btnSearchMaster"] != null)
            {
                btnSearchMaster_Click(sender, e);
            }
        }
        protected void btnSearchMaster_Click(object sender, EventArgs e)
        {
            string keyword = Request.Form["txtSearchMaster"]?.Trim() ?? "";

            if (!string.IsNullOrEmpty(keyword))
            {
                Session["searchKeyword"] = keyword;
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                Session["searchKeyword"] = null;
                Response.Redirect("~/Default.aspx");
            }
        }
        private void HandleLogout()
        {
            if (Request.QueryString["action"] == "logout")
            {
                Session.Clear();

                var query = HttpUtility.ParseQueryString(Request.QueryString.ToString());
                query.Remove("action");

                string newUrl = Request.Url.AbsolutePath;
                string queryString = query.ToString();

                if (!string.IsNullOrEmpty(queryString))
                    newUrl += "?" + queryString;

                Response.Redirect(newUrl);
            }
        }

        private void UpdateLoginUI()
        {
            bool isLoggedIn = Session["UserName"] != null;

            phLoggedIn.Visible = isLoggedIn;
            phNotLoggedIn.Visible = !isLoggedIn;

            if (isLoggedIn)
            {
                lblUserName.Text = Session["UserName"].ToString();
            }
        }

    }
}