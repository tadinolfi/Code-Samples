using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AuthNetGateway;
using System.Configuration;

public partial class MyAZH_CreateSubscription : AZHCore.AZHPage
{
    public int SubscribeUserId
    {
        get
        {
            if (ViewState["SubscribeUserId"] != null)
            {
                return (int)ViewState["SubscribeUserId"];
            }
            else
            {
                return 0;
            }
        }
        set { ViewState["SubscribeUserId"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Request.IsSecureConnection && !Request.IsLocal)
        {
            Response.Redirect("https://www.azillionhomes.com/myazh/CreateSubscription.aspx");
        }

        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        DataClassesDataContext context = new DataClassesDataContext();
        int userId = (int)Session["azhuserid"];
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);

        //Check for Agency Subscription
        if (!string.IsNullOrEmpty(Request.QueryString["UserInfoId"]))
        {
            int userSubscribeId = Convert.ToInt32(Request.QueryString["UserInfoId"]);
            int verifyAgencyId = context.Agencies.Where(n => n.OwnerUserInfoID == userId).First().AgencyID;
            UserInfo subscribeUser = context.UserInfos.Single(n => n.UserInfoID == userSubscribeId);
            if (subscribeUser.AgencyID == verifyAgencyId)
            {
                SubscribeUserId = userSubscribeId;
                pnlAgencySubscription.Visible = true;
                lblBehalfUser.Text = subscribeUser.FirstName + " " + subscribeUser.LastName;
            }
        }

        //Check for Renewal Subscription
        if (currentUser.Subscriptions.Count() > 0)
        {
            pnlRenew.Visible = true;
            pnlCoupon.Visible = false;
            createHeading.Visible = false;
            DateTime currentExpire = currentUser.Subscriptions[0].Expires;
            DateTime renewExpire = new DateTime(DateTime.Now.Year, DateTime.Now.Month, currentExpire.Day).AddMonths(12);
            litRenewDate.Text = renewExpire.ToShortDateString();
        }

        AdminSection = AZHCore.AZHSection.MyBilling;
        if (!IsPostBack)
        {
            txtAddress.Value = currentUser.Address;
            txtCity.Value = currentUser.City;
            txtEmail.Value = currentUser.Email;
            txtFirstName.Value = currentUser.FirstName;
            txtLastName.Value = currentUser.LastName;
            if(currentUser.StateID > 0)
                ddlState.SelectedValue = currentUser.State.Abbreviation;
            txtZip.Value = currentUser.ZipCode;

            int startingYear = DateTime.Now.Year;
            for (int i = 0; i <= 10; i++)
            {
                ddlYear.Items.Add((startingYear + i).ToString());
            }
            
            IQueryable<SubscriptionType> publicSubscriptions = context.SubscriptionTypes.Where(n => n.AllowPublic == true);
            SubscriptionType defaultSubscription = publicSubscriptions.First();
            string priceValue = "$" + defaultSubscription.BillingAmount.ToString();
            if (defaultSubscription.BillingPeriod == 1)
            {
                priceValue += " monthly";
            }
            else
            {
                priceValue += " every " + defaultSubscription.BillingPeriod.ToString() + " months";
            }
            lblPrice.Text = priceValue;
            hidPrice.Value = defaultSubscription.BillingAmount.ToString();
        }
    }
    protected void imgCancel_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
    protected void imgSubmit_Click(object sender, EventArgs e)
    {
        lblConfirmAmount.Text = lblPrice.Text;
        int day = DateTime.Now.Day;
        string suffix = "th";
        if (day == 1 || day == 21 || day == 31)
        {
            suffix = "st";
        }
        if (day == 2 || day == 22)
        {
            suffix = "nd";
        }
        if (day == 3 || day == 23)
        {
            suffix = "rd";
        }
        lblConfirmDay.Text = day.ToString() + suffix;
        ModalPopupExtender1.Show();
    }

    protected void butCoupon_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        try
        {
            IQueryable<Coupon> possibleCoupons = context.Coupons.Where(n => n.CouponCode == txtCoupon.Text);
            IQueryable<Coupon> validCoupons = context.Coupons.Where(n => n.CouponCode == txtCoupon.Text && (n.Used < n.TotalUses || n.TotalUses == 0)).OrderByDescending(n => n.CouponAmount);
            if (validCoupons.Count() > 0)
            {
                Coupon enteredCoupon = validCoupons.First();
                if (enteredCoupon.Expires.HasValue && enteredCoupon.Expires < DateTime.Now)
                {
                    lblCoupon.Text = "The coupon has expired";
                    return;
                }
                decimal currentPrice = Convert.ToDecimal(hidPrice.Value);
                decimal newPrice;
                txtCoupon.Enabled = false;
                butCoupon.Enabled = false;
                couponUsed.Value = enteredCoupon.CouponID.ToString();
                switch (enteredCoupon.CouponType)
                {
                    case "month":
                        //Insert Subscription
                        IQueryable<SubscriptionType> publicSubscriptions = context.SubscriptionTypes.Where(n => n.AllowPublic == true);
                        SubscriptionType defaultSubscription = publicSubscriptions.First();
                        Subscription freeSubscription = new Subscription
                        {
                            AuthSubscriptionID = "0",
                            AutoRecurring = false,
                            Cancelled = false,
                            Created = DateTime.Now,
                            Expires = DateTime.Now.AddMonths(enteredCoupon.CouponAmount),
                            SubscriptionTypeID = defaultSubscription.SubscriptionTypeID,
                            UserInfoID = (int)Session["azhuserid"]
                        };
                        context.Subscriptions.InsertOnSubmit(freeSubscription);
                        context.SubmitChanges();

                        //Update Interface
                        hidMonths.Value = enteredCoupon.CouponAmount.ToString();
                        lblCoupon.Text = enteredCoupon.CouponAmount.ToString() + " free months added to account";
                        pnlFreeSubscription.Visible = true;
                        pnlSubscription.Visible = false;
                        break;
                    case "value":
                        newPrice = currentPrice - Convert.ToDecimal(enteredCoupon.CouponAmount);
                        hidPrice.Value = newPrice.ToString();
                        lblPrice.Text = "$" + newPrice.ToString();
                        lblCoupon.Text = "$" + enteredCoupon.CouponAmount.ToString() + " subtracted from price";
                        break;
                    case "percent":
                        decimal percentage = (decimal)enteredCoupon.CouponAmount / (decimal)100;
                        newPrice = Math.Round(currentPrice * ((decimal)1 - percentage), 2);
                        hidPrice.Value = newPrice.ToString();
                        lblPrice.Text = "$" + newPrice.ToString();
                        lblCoupon.Text = enteredCoupon.CouponAmount.ToString() + "% discount applied to price";
                        break;
                }
            }
            else
            {
                if (possibleCoupons.Count() > 0)
                {
                    lblCoupon.Text = "This coupon has already been used";
                }
                else
                {
                    lblCoupon.Text = "The coupon code could not be found";
                }
            }
        }
        catch
        {
            lblCoupon.Text = "Invalid Coupon";
        }
    }
    protected void imgFreeSubmit_Click(object sender, ImageClickEventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        SubscriptionType defaultSubscription = context.SubscriptionTypes.First();
        //Insert Subscription
        Subscription newSubscription = new Subscription
        {
            AuthSubscriptionID = "0",
            AutoRecurring = true,
            Created = DateTime.Now,
            Expires = DateTime.Now.AddMonths(Convert.ToInt32(hidMonths)),
            SubscriptionTypeID = defaultSubscription.SubscriptionTypeID,
            UserInfoID = (int)Session["azhuserid"]
        };
        context.Subscriptions.InsertOnSubmit(newSubscription);
        context.SubmitChanges();
        pnlNewSubscription.Visible = true;
        pnlSubscription.Visible = false;
        pnlFreeSubscription.Visible = false;
        Coupon usedCoupon = context.Coupons.Single(c => c.CouponID == Convert.ToInt32(couponUsed.Value));
        usedCoupon.Used++;
        context.SubmitChanges();
    }
    protected void butConfirm_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        DateTime startDate = DateTime.Now;
        UserInfo currentUser = context.UserInfos.Single(u => u.UserInfoID == (int)Session["azhuserid"]);
        if (currentUser.Subscriptions.Count() > 0)
        {
            startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, currentUser.Subscriptions[0].Expires.Day);
            if (startDate < DateTime.Now)
                startDate = startDate.AddMonths(1);
            if (currentUser.Subscriptions[0].AuthSubscriptionID != "0")
            {
                //Cancel Existing Subscription
                Processor cancelProc = new Processor();
                cancelProc.Action = ActionType.DeleteSubscription;
                cancelProc.TransactionID = currentUser.Subscriptions[0].AuthSubscriptionID;
                cancelProc.MerchantID = ConfigurationManager.AppSettings["merchantID"];
                cancelProc.MerchantLogin = ConfigurationManager.AppSettings["merchantLogin"];
                cancelProc.ProcessTransaction();
            }
        }
        SubscriptionType defaultSubscription = context.SubscriptionTypes.First();
        Processor gateway = new Processor();
        //If there is a current subscription
        
        gateway.Action = ActionType.CreateSubscription;
        gateway.Amount = Convert.ToDecimal(hidPrice.Value);
        CCInfo cardInfo = new CCInfo
        {
            Address = txtAddress.Value,
            CardNumber = txtCardNumber.Value,
            City = txtCity.Value,
            CVN = txtCVN.Value,
            Email = txtEmail.Value,
            ExpMonth = ddlMonth.SelectedValue,
            ExpYear = ddlYear.SelectedValue,
            FirstName = txtFirstName.Value,
            LastName = txtLastName.Value,
            State = ddlState.SelectedValue,
            Zip = txtZip.Value
        };
        gateway.CardInfo = cardInfo;
        gateway.CustomerID = ((int)Session["azhuserid"]).ToString();
        gateway.Description = defaultSubscription.Name;
        gateway.MerchantID = ConfigurationManager.AppSettings["merchantID"];
        gateway.MerchantLogin = ConfigurationManager.AppSettings["merchantLogin"];
        gateway.ProcessTransaction();

        if (gateway.Result.ResponseType == ResponseResult.Approved)
        {
            //Check for Existing Subscription
            if (currentUser.Subscriptions.Count() > 0)
            {
                //Update Existing Subscription
                Subscription currentSub = context.Subscriptions.Single(s => s.SubscriptionID == currentUser.Subscriptions[0].SubscriptionID);
                currentSub.Expires = startDate.AddMonths(12);
                currentSub.AuthSubscriptionID = gateway.Result.TransactionID;
                context.SubmitChanges();
            }
            else
            {
                //Insert Subscription
                int newUserId;
                if (SubscribeUserId > 0)
                    newUserId = SubscribeUserId;
                else
                    newUserId = (int)Session["azhuserid"];

                Subscription newSubscription = new Subscription
                {
                    AuthSubscriptionID = gateway.Result.TransactionID,
                    AutoRecurring = true,
                    Created = DateTime.Now,
                    Expires = DateTime.Now.AddYears(1),
                    SubscriptionTypeID = defaultSubscription.SubscriptionTypeID,
                    UserInfoID = newUserId
                };
                context.Subscriptions.InsertOnSubmit(newSubscription);
                context.SubmitChanges();
                pnlNewSubscription.Visible = true;
                pnlSubscription.Visible = false;
                if (couponUsed.Value != "0")
                {
                    Coupon usedCoupon = context.Coupons.Single(c => c.CouponID == Convert.ToInt32(couponUsed.Value));
                    usedCoupon.Used++;
                    context.SubmitChanges();
                }
            }
        }
    }
}
