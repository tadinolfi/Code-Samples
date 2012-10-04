using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;

public partial class control_control : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null && !Request.Url.AbsoluteUri.Contains("Login.aspx"))
        {
            Response.Redirect("~/control/Login.aspx");
        }
        else if(!Request.Url.AbsoluteUri.Contains("Login.aspx"))
        {
            int userId = (int)Session["azhuserid"];
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
            if (currentUser.UserTypeID != 2)
                Response.Redirect("~/myazh");
        }
    }
    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Remove("azhuserid");
        Response.Redirect("~/Default.aspx");
    }
}
