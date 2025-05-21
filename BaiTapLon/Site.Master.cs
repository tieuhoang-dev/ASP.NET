using System;
using System.Web.UI;
using BaiTapLon.Models;

namespace BaiTapLon
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);

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

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);

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
                phQuangCao1.Controls.Add(QCControl);

                var TopsellingControl = (TopSellingBooks)LoadControl("~/TopSellingBooks.ascx");
                phSachBanChay.Controls.Clear();
                phSachBanChay.Controls.Add(TopsellingControl);

                var HeaderControl = (Header)LoadControl("~/Header.ascx");
                phHeader.Controls.Clear();
                phHeader.Controls.Add(HeaderControl);
                string userid = Session["user_id"] as string;
                lblid.Text = userid;
            }
        }

    }
}
