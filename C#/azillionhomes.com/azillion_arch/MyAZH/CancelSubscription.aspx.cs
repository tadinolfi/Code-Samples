using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuthNetGateway;
using System.Configuration;

public partial class MyAZH_CancelSubscription : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        if (!IsPostBack)
        {

            int userId = (int)Session["azhuserid"];
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
            if (currentUser.Subscriptions.Count() == 0 || currentUser.Subscriptions.First().Expires <= DateTime.Now)
            {
                Response.Redirect("~/myazh/Default.aspx");
            }
            Subscription currentSubscription = currentUser.Subscriptions.First();
            if (currentSubscription.Cancelled)
            {
                pnlCancelled.Visible = true;
                pnlStart.Visible = false;
            }
            if (currentSubscription.AuthSubscriptionID == "0")
            {
                pnlStart.Visible = false;
                pnlFree.Visible = true;
            }
        }
    }
    protected void imgCancel_Click(object sender, EventArgs e)
    {
        int currentUserId = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == currentUserId);
        Subscription currentSubscription = currentUser.Subscriptions.First();
        Processor gateway = new Processor();
        gateway.Action = ActionType.DeleteSubscription;
        gateway.TransactionID = currentSubscription.AuthSubscriptionID;
        gateway.MerchantID = ConfigurationManager.AppSettings["merchantID"];
        gateway.MerchantLogin = ConfigurationManager.AppSettings["merchantLogin"];
        gateway.ProcessTransaction();
        if (gateway.Result.ResponseType == ResponseResult.Approved)
        {
            pnlStart.Visible = false;
            pnlSuccess.Visible = true;
            DateTime currentExp = currentSubscription.Expires;
            int expYear = DateTime.Now.Year;
            int expDay = currentExp.Day;
            int expMonth = DateTime.Now.Month;
            DateTime newExp = new DateTime(expYear, expMonth, expDay);
            if (expDay < DateTime.Now.Day)
            {
                newExp.AddMonths(1);
            }
            currentSubscription.Expires = newExp;
            currentSubscription.Cancelled = true;
            context.SubmitChanges();
            lblDate.Text = newExp.ToShortDateString();
        }
        else
        {
            lblMessage.Text = gateway.Result.ResponseText;
        }
    }
}
