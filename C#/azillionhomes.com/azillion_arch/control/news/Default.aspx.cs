using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class control_news_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void butAdd_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        string url = "";
        if (!string.IsNullOrEmpty(txtUrl.Text) && !txtUrl.Text.StartsWith("http"))
            url = "http://" + txtUrl.Text;
        else
            url = txtUrl.Text;
        New newNew = new New { Body = txtBody.Text, Teaser = txtTeaser.Text, Title = txtTitle.Text, Created = DateTime.Now, UserInfoID = (int)Session["azhuserid"], ExternalUrl = url };
        context.News.InsertOnSubmit(newNew);
        context.SubmitChanges();
        txtTitle.Text = "";
        txtUrl.Text = "";
        txtTeaser.Text = "";
        txtBody.Text = "";
        GridView1.DataBind();
    }
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        LinkButton butDelete = sender as LinkButton;
        int announcementId = Convert.ToInt32(butDelete.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        New delNew = context.News.Single(n => n.NewsID == announcementId);
        context.News.DeleteOnSubmit(delNew);
        context.SubmitChanges();
        GridView1.DataBind();
    }
    protected void butEdit_Click(object sender, EventArgs e)
    {
        Button butEdit = sender as Button;
        int announcementId = Convert.ToInt32(butEdit.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        New editNew = context.News.Single(n => n.NewsID == announcementId);
        TextBox txtEditBody = butEdit.Parent.FindControl("txtBody") as TextBox;
        TextBox txtEditTeaser = butEdit.Parent.FindControl("txtTeaser") as TextBox;
        TextBox txtEditTitle = butEdit.Parent.FindControl("txtTitle") as TextBox;
        TextBox txtEditUrl = butEdit.Parent.FindControl("txtUrl") as TextBox;
        string url = "";
        if (!string.IsNullOrEmpty(txtEditUrl.Text) && !txtEditUrl.Text.StartsWith("http"))
            url = "http://" + txtEditUrl.Text;
        else
            url = txtEditUrl.Text;
        editNew.Body = txtEditBody.Text;
        editNew.Teaser = txtEditTeaser.Text;
        editNew.Title = txtEditTitle.Text;
        editNew.ExternalUrl = url;
        context.SubmitChanges();
        GridView1.DataBind();
    }
}
