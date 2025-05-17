using System;
using System.Web.UI;

namespace BaiTapLon
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Xử lý sự kiện tìm kiếm
            if (IsPostBack && Request.Form["btnSearchMaster"] != null)
            {
                btnSearchMaster_Click(sender, e);
                return;
            }

            string keyword = Session["searchKeyword"] as string;
            string chuDeDuocChon = Session["ChuDeDuocChon"] as string;

            if (!string.IsNullOrEmpty(keyword))
            {
                var searchResult = (Search)LoadControl("~/Search.ascx");
                searchResult.Keyword = keyword;

                MainContent.Controls.Clear();
                MainContent.Controls.Add(searchResult);

                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1.Controls.Add(QCControl);

                Session["searchKeyword"] = null;
                Session["ChuDeDuocChon"] = null;

            }
            else if (!string.IsNullOrEmpty(chuDeDuocChon))
            {
                var bookOfGenreControl = (BookOfGenre)LoadControl("~/BookOfGenre.ascx");
                bookOfGenreControl.TenChuDe = chuDeDuocChon;

                MainContent.Controls.Clear();
                MainContent.Controls.Add(bookOfGenreControl);

                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1.Controls.Add(QCControl);

                Session["ChuDeDuocChon"] = null;
            }
            else
            {
                var genreControl = (Genre)LoadControl("~/Genre.ascx");
                phChuDeSach.Controls.Clear();
                phChuDeSach.Controls.Add(genreControl);

                var bookControl = (Allbook)LoadControl("~/Allbook.ascx");
                MainContent.Controls.Clear();
                MainContent.Controls.Add(bookControl);

                var NewBookControl = (NewestBooks)LoadControl("~/NewestBooks.ascx");
                phSachMoi.Controls.Clear();
                phSachMoi.Controls.Add(NewBookControl);

                var QCControl = (QuangCao)LoadControl("~/QuangCao.ascx");
                phQuangCao1.Controls.Clear();
                phQuangCao1 .Controls.Add(QCControl);
            }
        }

        protected void btnSearchMaster_Click(object sender, EventArgs e)
        {
            string keyword = Request.Form["txtSearchMaster"]?.Trim() ?? "";

            if (!string.IsNullOrEmpty(keyword))
            {
                Session["searchKeyword"] = keyword;
                Response.Redirect(Request.RawUrl);
            }
            else
            {
                Session["searchKeyword"] = null;
                Response.Redirect(Request.RawUrl);
            }
        }
    }
}
