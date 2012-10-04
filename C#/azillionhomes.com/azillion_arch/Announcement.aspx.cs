using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Announcement_Page : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            int announcementId = Convert.ToInt32(Request.QueryString["id"]);
            DataClassesDataContext context = new DataClassesDataContext();
            Announcement newAnnouncement = context.Announcements.Single(n => n.AnnouncementID == announcementId);
            lblTitle.Text = newAnnouncement.Title;
            lblDate.Text = newAnnouncement.Created.ToShortDateString();
            litBody.Text = newAnnouncement.Body;
            lblAuthor.Text = newAnnouncement.UserInfo.FirstName;
        }
    }
}
