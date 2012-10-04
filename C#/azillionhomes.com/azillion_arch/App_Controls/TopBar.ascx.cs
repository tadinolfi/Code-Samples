using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_TopBar : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page is AZHCore.AZHPage)
        {
            AZHCore.AZHPage CurrentPage = Page as AZHCore.AZHPage;
            if (CurrentPage.AdminSection == AZHCore.AZHSection.Overview)
            {
                lnkWelcome.CssClass = "selectedMain";
            }
            if (CurrentPage.AdminSection == AZHCore.AZHSection.MyAccount)
            {
                lnkAccount.CssClass = "selectedMain";
            }
            if (CurrentPage.AdminSection == AZHCore.AZHSection.MyPosting)
            {
                lnkPostings.CssClass = "selectedMain";
            }
        }

        if (Session["azhuserid"] != null)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
            lnkUser.Text = currentUser.FirstName;
        }

        if (Request.Url.AbsoluteUri.ToLower().Contains("default.aspx"))
        {
            myAZHButton.Visible = false;
        }
    }
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Remove("azhuserid");
        Response.Redirect("~/Default.aspx");
    }
}
