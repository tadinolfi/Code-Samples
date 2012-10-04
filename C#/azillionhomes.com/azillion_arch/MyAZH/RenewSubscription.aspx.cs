using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuthNetGateway;
using System.Configuration;

public partial class MyAZH_RenewSubscription : AZHCore.AZHPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
            Response.Redirect("~/Login.aspx");
        int azhUserId = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(u => u.UserInfoID == azhUserId);
        if (currentUser.Subscriptions.Count == 0)
        {
            Response.Redirect("~/MyAZH/Default.aspx");
        }
        else
        {
            TimeSpan subRemaining = currentUser.Subscriptions[0].Expires.Subtract(DateTime.Now);
            double daysRemaining = subRemaining.TotalDays;
            double monthsRemaining = daysRemaining / 30.2;
            if (monthsRemaining > 1)
            {
                pnlNoRenew.Visible = false;
                //litMonths.Text = Math.Floor(monthsRemaining).ToString();
                //litAddMonths.Text = Math.Ceiling(12.0 - monthsRemaining).ToString();
            }
            else
            {
                pnlRenew.Visible = false;
            }
        }
    }
}
