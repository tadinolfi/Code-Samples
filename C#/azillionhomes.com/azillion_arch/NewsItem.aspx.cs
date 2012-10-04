using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NewsItem : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            int newsId = Convert.ToInt32(Request.QueryString["id"]);
            DataClassesDataContext context = new DataClassesDataContext();
            New newNews = context.News.Single(n => n.NewsID == newsId);
            lblTitle.Text = newNews.Title;
            lblDate.Text = newNews.Created.ToShortDateString();
            litBody.Text = newNews.Body;
            lblAuthor.Text = newNews.UserInfo.FirstName;
        }
    }
}
