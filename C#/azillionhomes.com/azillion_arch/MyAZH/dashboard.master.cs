using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_dashboard : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
        {
            string url = Server.UrlEncode(Request.Url.AbsoluteUri);
            Response.Redirect("~/Login.aspx?returnurl=" + url);
        }
        if (((AZHCore.AZHPage)Page).ShowSearch)
        {
            pnlUpdate.Visible = true;
        }
        else
        {
            pnlUpdate.Visible = false;
        }
    }
    protected void lnkNewSearch_Click(object sender, EventArgs e)
    {
        lnkNewSearch.Visible = false;
        pnlSearches.Visible = true;
    }
}
