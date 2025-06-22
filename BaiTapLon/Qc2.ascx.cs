using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace BaiTapLon
{
    public partial class Qc2 : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RandomAds();
        }
        private void RandomAds()
        {
            string path = Server.MapPath("~/App_Data/Adv.xml");
            XDocument doc = XDocument.Load(path);

            var ads = doc.Descendants("Ad").Select(ad => new
            {
                Url = (string)ad.Element("NavigateUrl"),
                AnhUrl = (string)ad.Element("ImageUrl"),
                Alter = (string)ad.Element("AlternateText")
            }).ToList();

            var randomAds = ads.OrderBy(a => Guid.NewGuid()).Take(3).ToList();

            rptAds.DataSource = randomAds;
            rptAds.DataBind();
        }

    }
}