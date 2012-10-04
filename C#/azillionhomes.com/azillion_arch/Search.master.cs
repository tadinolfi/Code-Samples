using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Amplify.Utilities;
using System.Text.RegularExpressions;
using System.Drawing;

public partial class Search : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int listingTypeId = 1;
        if (Request.Url.AbsoluteUri.ToLower().Contains("/rentals/"))
        {
            listingTypeId = 1;
            hidMinType.Value = "1";
            hidMaxType.Value = "2";
        }
        if (Request.Url.AbsoluteUri.ToLower().Contains("/sales/"))
        {
            listingTypeId = 2;
            hidMinType.Value = "3";
            hidMaxType.Value = "4";
        }
        if (Request.Url.AbsoluteUri.ToLower().Contains("/openhouses/"))
        {
            listingTypeId = 3;
            hidMinType.Value = "3";
            hidMaxType.Value = "4";
        }
        if (Request.Url.AbsoluteUri.ToLower().Contains("/auctions/"))
        {
            listingTypeId = 4;
        }
        DataClassesDataContext context = new DataClassesDataContext();
        var ddlData = from f in context.Forms
                      join fl in context.FormListingTypes on f.FormID equals fl.FormID
                      where fl.ListingTypeID == listingTypeId
                      select new { formName = f.Name, formId = f.FormID };
        ddlType.DataSource = ddlData;
        ddlType.DataTextField = "formName";
        ddlType.DataValueField = "formId";
        ddlType.DataBind();
        if (listingTypeId == 4)
        {
            priceRow.Visible = false;
        }
    }
    protected void lnkPlus_Click(object sender, EventArgs e)
    {
        pnlAdditionalCriteria.Visible = true;
        lnkMinus.Visible = true;
        lnkPlus.Visible = false;
    }
    protected void lnkMinus_Click(object sender, EventArgs e)
    {
        pnlAdditionalCriteria.Visible = false;
        lnkMinus.Visible = false;
        lnkPlus.Visible = true;
    }
    protected void imgSearch_Click(object sender, EventArgs e)
    {
        int listingTypeId = 1;
        if (Request.Url.AbsoluteUri.ToLower().Contains("/rentals/"))
            listingTypeId = 1;
        if (Request.Url.AbsoluteUri.ToLower().Contains("/sales/"))
            listingTypeId = 2;
        if(Request.Url.AbsoluteUri.ToLower().Contains("/openhouses/"))
            listingTypeId = 3;
        if (Request.Url.AbsoluteUri.ToLower().Contains("/auctions/"))
            listingTypeId = 4;
        if (!string.IsNullOrEmpty(txtKeyword.Text))
        {
            string azhPattern = "^([A-Z]){4}\\d+$";
            Regex azhRegex = new Regex(azhPattern);
            if (azhRegex.IsMatch(txtKeyword.Text.Trim().ToUpper()))
            {
                DataClassesDataContext context = new DataClassesDataContext();
                FormEntry entry = context.FormEntries.SingleOrDefault(n => n.AZHID == txtKeyword.Text.Trim().ToUpper());
                if (entry != null)
                {
                    Response.Redirect("~/Posting.aspx?postid=" + entry.FormEntryID.ToString());
                }
                else
                {
                    txtKeyword.Text += " INVALID AZH#";
                    txtKeyword.ForeColor = Color.Red;
                    return;
                }
            }
        }
        SearchTerms advSearch = new SearchTerms();
        advSearch.Baths = Convert.ToInt32(ddlBaths.SelectedValue);
        advSearch.Bedrooms = Convert.ToInt32(ddlBeds.SelectedValue);
        advSearch.FormID = Convert.ToInt32(ddlType.SelectedValue);
        advSearch.ListingTypeID = listingTypeId;
        advSearch.MaxPrice = Convert.ToInt32(ddlMax.SelectedValue);
        advSearch.MinPrice = Convert.ToInt32(ddlMin.SelectedValue);
        switch (ddlSort.SelectedValue)
        {
            case "DateDesc":
                advSearch.Sort = SearchSort.DateDesc;
                break;
            case "DateAsc":
                advSearch.Sort = SearchSort.DateAsc;
                break;
            case "PriceDesc":
                advSearch.Sort = SearchSort.PriceDesc;
                break;
            case "PriceAsc":
                advSearch.Sort = SearchSort.PriceAsc;
                break;
        }
        if (string.IsNullOrEmpty(txtCity.Text))
        {
            if (ddlState.SelectedValue == "0")
                advSearch.StateID = 0;
            else
            {
                DataClassesDataContext context = new DataClassesDataContext();
                advSearch.StateID = context.States.Where(n => n.Abbreviation == ddlState.SelectedValue).First().StateID;
            }
        }
        else
        {
            advSearch.Zip = GeoData.GetZipCodeByLocation(txtCity.Text, ddlState.SelectedValue);
        }

        Session["currentsearch"] = advSearch.GetSearchString();
        Response.Redirect("Default.aspx");
    }
}
