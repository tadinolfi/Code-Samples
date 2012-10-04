using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Net.Mail;
using System.Configuration;

public partial class EmailListing : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(Request.QueryString["id"]))
            Response.Redirect("~/Default.aspx");

        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == Convert.ToInt32(Request.QueryString["id"]));
        ListingType entryType = currentEntry.Form.FormListingTypes.First().ListingType;
        if (entryType.HasPrice)
        {
            lblPrice.Text = FormatPrice(currentEntry.Price);
            if (entryType.MonthlyPrice)
            {
                lblPrice.Text += "/month";
            }
        }
        if (entryType.HasDate)
        {
            lblPrice.Text += currentEntry.Expires.Value.ToShortDateString();
        }
        lblAddress.Text = currentEntry.StreetNumber + " " + currentEntry.StreetName;
        lblCity.Text = currentEntry.City;
        lblState.Text = currentEntry.State.Abbreviation;
        lblAZH.Text = currentEntry.AZHID;

        if (currentEntry.FormImages.Count > 0)
        {
            imgListing.ImageUrl = ConfigurationManager.AppSettings["postimagesdir"] + "icons/" + currentEntry.FormImages.First().Filename;
        }
        else
        {
            imgListing.ImageUrl = "~/images/content/search-results/no-img-rentals.gif";
        }
    }
    protected void lnkAgain_Click(object sender, EventArgs e)
    {
        txtEmail.Text = "";
        pnlSent.Visible = false;
        pnlForm.Visible = true;
    }
    protected void lnkNo_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Posting.aspx?postid=" + Request.QueryString["id"]);
    }
    protected void butSendEmail_Click(object sender, ImageClickEventArgs e)
    {
        EmailSender mailSender = new EmailSender
        {
            FromAddress = txtFromEmail.Text,
            ToAddress = txtEmail.Text,
            Subject = "A Friend has sent you a listing from AZH",
            MessageUrl = "http://www.azillionhomes.com/Posting.aspx?postid=" + Request.QueryString["id"],
            MessageBody = txtMessage.Text,
            TemplateFile = Server.MapPath("~/App_Data/EmailToFriend.txt")
        };

        mailSender.SendEmail();
        pnlForm.Visible = false;
        pnlSent.Visible = true;
    }

    protected string FormatPrice(int price)
    {
        if (price == 0)
            return "N/A";
        string basePrice = price.ToString();
        string formatPrice = "";
        while (basePrice.Length > 3)
        {
            formatPrice = "," + basePrice.Substring(basePrice.Length - 3, 3) + formatPrice;
            basePrice = basePrice.Substring(0, basePrice.Length - 3);
        }
        formatPrice = "$" + basePrice + formatPrice;

        return formatPrice;
    }
}
