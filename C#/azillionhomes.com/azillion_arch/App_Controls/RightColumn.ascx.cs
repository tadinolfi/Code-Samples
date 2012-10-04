using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_RightColumn : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] != null)
        {
            DataClassesDataContext content = new DataClassesDataContext();
            UserInfo currentUser = content.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
            lblName.Text = currentUser.FirstName + " " + currentUser.LastName;
            pnlWelcomeBack.Visible = true;
        }
    }
}
