using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Section = AZHCore.PageSection.Login;
        if (Session["azhuserid"] != null)
            Response.Redirect("~/myazh/default.aspx");
    }
}
