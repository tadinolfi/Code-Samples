using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class control_announcements_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void butAdd_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Announcement newAnnouncement = new Announcement { Body = txtBody.Text, Teaser = txtTeaser.Text, Title = txtTitle.Text, Created = DateTime.Now, UserInfoID = (int)Session["azhuserid"] };
        context.Announcements.InsertOnSubmit(newAnnouncement);
        context.SubmitChanges();
        txtTitle.Text = "";
        txtTeaser.Text = "";
        txtBody.Text = "";
        GridView1.DataBind();
    }
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        LinkButton butDelete = sender as LinkButton;
        int announcementId = Convert.ToInt32(butDelete.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        Announcement delAnnouncement = context.Announcements.Single(n => n.AnnouncementID == announcementId);
        context.Announcements.DeleteOnSubmit(delAnnouncement);
        context.SubmitChanges();
        GridView1.DataBind();
    }
    protected void butEdit_Click(object sender, EventArgs e)
    {
        Button butEdit = sender as Button;
        int announcementId = Convert.ToInt32(butEdit.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        Announcement editAnnouncement = context.Announcements.Single(n => n.AnnouncementID == announcementId);
        TextBox txtEditBody = butEdit.Parent.FindControl("txtBody") as TextBox;
        TextBox txtEditTeaser = butEdit.Parent.FindControl("txtTeaser") as TextBox;
        TextBox txtEditTitle = butEdit.Parent.FindControl("txtTitle") as TextBox;
        editAnnouncement.Body = txtEditBody.Text;
        editAnnouncement.Teaser = txtEditTeaser.Text;
        editAnnouncement.Title = txtEditTitle.Text;
        context.SubmitChanges();
        GridView1.DataBind();
    }
}
