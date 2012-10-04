using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_LeftNav : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int listingTypeID = 0;
        if (!string.IsNullOrEmpty(Request.QueryString["postid"]))
        {
            DataClassesDataContext context = new DataClassesDataContext();
            FormEntry currentEntry = context.FormEntries.Single(f => f.FormEntryID == Convert.ToInt32(Request.QueryString["postid"]));
            listingTypeID = currentEntry.ListingTypeID;
        }
        if (Request.Url.AbsoluteUri.Contains("/rentals/") || listingTypeID == 1)
        {
            pnlRentalSearch.Visible = !Request.Url.AbsoluteUri.ToLower().Contains("search.aspx");
            btnRentals.Attributes.Add("class", "btnRentals withQuickSearch");
            lnkRentals.CssClass = "selectedMain";
        }
        else
        {
            btnRentals.Attributes.Add("class", "btnRentals");
        }
        if (Request.Url.AbsoluteUri.Contains("/sales/") || listingTypeID == 2)
        {
            pnlSalesSearch.Visible = !Request.Url.AbsoluteUri.ToLower().Contains("search.aspx");
            btnSales.Attributes["class"] += "btnSales withQuickSearch";
            lnkSales.CssClass = "selectedMain";
        }
        else
        {
            btnSales.Attributes.Add("class", "btnSales");
        }
        if (Request.Url.AbsoluteUri.Contains("/auctions/") || listingTypeID == 4)
        {
            pnlAuctionsSearch.Visible = !Request.Url.AbsoluteUri.ToLower().Contains("search.aspx");
            btnAuctions.Attributes["class"] += "btnAuctions withQuickSearch";
            lnkAuctions.CssClass = "selectedMain";
        }
        else
        {
            btnAuctions.Attributes.Add("class", "btnAuctions");
        }
        if (Request.Url.AbsoluteUri.Contains("/openhouses/") || listingTypeID == 3)
        {
            pnlOpenHouseSearch.Visible = !Request.Url.AbsoluteUri.ToLower().Contains("search.aspx");
            btnOpenHouses.Attributes["class"] += "btnOpenHouses withQuickSearch";
            lnkOpenHouses.CssClass = "selectedMain";
        }
        else
        {
            btnOpenHouses.Attributes.Add("class", "btnOpenHouses");
        }
    }
    protected void lnkRentals_Click(object sender, EventArgs e)
    {
        Session.Remove("currentsearch");
        Response.Redirect("~/rentals/search.aspx");
    }
    protected void lnkSales_Click(object sender, EventArgs e)
    {
        Session.Remove("currentsearch");
        Response.Redirect("~/sales/search.aspx");
    }
    protected void lnkOpenHouses_Click(object sender, EventArgs e)
    {
        Session.Remove("currentsearch");
        Response.Redirect("~/openhouses/search.aspx");
    }
    protected void lnkAuctions_Click(object sender, EventArgs e)
    {
        Session.Remove("currentsearch");
        Response.Redirect("~/auctions/search.aspx");
    }
}
