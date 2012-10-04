using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_MyBilling : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }

        AdminSection = AZHCore.AZHSection.MyBilling;

        DataClassesDataContext context = new DataClassesDataContext();
        int userId = (int)Session["azhuserid"];
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
        if (currentUser.Subscriptions.Count > 0)
        {
            Subscription currentSubscription = currentUser.Subscriptions.OrderByDescending(n => n.Expires).FirstOrDefault();
            if (currentSubscription.Expires > DateTime.Now)
            {
                lblExpire.Text = currentSubscription.Expires.ToShortDateString();
                lblRate.Text = "$" + currentSubscription.SubscriptionType.BillingAmount.ToString();
                lblStart.Text = currentSubscription.Created.ToShortDateString();
            }
        }
        else
        {
            pnlHasSubscription.Visible = false;
            pnlNoSubscription.Visible = true;
        }

    }
}
