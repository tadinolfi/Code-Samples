using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_PublicTopbar : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page is AZHCore.AZHPage)
        {
            AZHCore.AZHPage CurrentPage = Page as AZHCore.AZHPage;
            if (CurrentPage.Section == AZHCore.PageSection.AboutUs)
            {
                lnkAbout.CssClass = "selectedMain";
            }
            if (CurrentPage.Section == AZHCore.PageSection.Login)
            {
                lnkLogin.CssClass = "selectedMain";
            }
            if (CurrentPage.Section == AZHCore.PageSection.SignUp)
            {
                lnkSignUp.CssClass = "selectedMain";
            }
            if (CurrentPage.Section == AZHCore.PageSection.Forum)
            {
                lnkForum.CssClass = "selectedMain";
            }
        }
        if (Session["azhuserid"] != null)
        {
            lnkLogo.NavigateUrl = "~/myazh/Default.aspx";
            btnLogin.Visible = false;
            btnLogout.Visible = true;
            btnSignUp.Visible = false;
            btnMyAZH.Visible = true;
        }
    }
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Remove("azhuserid");
        Response.Redirect("Default.aspx");
    }
}
