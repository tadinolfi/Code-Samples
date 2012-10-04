using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Drawing;

public partial class App_Controls_QuickSearch : System.Web.UI.UserControl
{
    public int ListingTypeID
    {
        get
        {
            if (ViewState["ListingTypeID"] != null)
            {
                return (int)ViewState["ListingTypeID"];
            }
            else
            {
                return 0;
            }
        }
        set { ViewState["ListingTypeID"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string searchPath = "";
        string searchCss = "";
        DataClassesDataContext context = new DataClassesDataContext();
        ddlMin.DataTextField = "Display";
        ddlMin.DataValueField = "Amount";
        ddlMax.DataTextField = "Display";
        ddlMax.DataValueField = "Amount";
        switch (ListingTypeID)
        {
            case 1:
                searchPath = "/rentals/";
                searchCss = "qsRentals";
                txtEnd.Visible = false;
                calExtEnd.Enabled = false;
                txtStart.Visible = false;
                calExtStart.Enabled = false;
                if (!IsPostBack)
                {
                    ddlMin.DataSource = context.Prices.Where(p => p.Type == 1).OrderBy(p => p.Amount);
                    ddlMin.DataBind();
                    ddlMax.DataSource = context.Prices.Where(p => p.Type == 2).OrderBy(p => p.Amount);
                    ddlMax.DataBind();
                }
                break;
            case 2:
                searchPath = "/sales/";
                searchCss = "qsSales";
                txtEnd.Visible = false;
                calExtEnd.Enabled = false;
                txtStart.Visible = false;
                calExtStart.Enabled = false;
                if (!IsPostBack)
                {
                    ddlMin.DataSource = context.Prices.Where(p => p.Type == 3).OrderBy(p => p.Amount);
                    ddlMin.DataBind();
                    ddlMax.DataSource = context.Prices.Where(p => p.Type == 4).OrderBy(p => p.Amount);
                    ddlMax.DataBind();
                }
                break;
            case 3:
                searchPath = "/openhouses/";
                searchCss = "qsOpenHouses";
                if (!IsPostBack)
                {
                    ddlMin.DataSource = context.Prices.Where(p => p.Type == 3).OrderBy(p => p.Amount);
                    ddlMin.DataBind();
                    ddlMax.DataSource = context.Prices.Where(p => p.Type == 4).OrderBy(p => p.Amount);
                    ddlMax.DataBind();
                }
                break;
            case 4:
                searchPath = "/auctions/";
                searchCss = "qsAuctions";
                ddlMin.Visible = false;
                ddlMax.Visible = false;
                break;
        }
        lnkAdvancedSearch.NavigateUrl = "~" + searchPath + "Search.aspx";

        if (!IsPostBack)
        {
            var formTypes = context.FormListingTypes.Where(n => n.ListingTypeID == ListingTypeID).Join(context.Forms, o => o.FormID, i => i.FormID, (i, o) => new { id = o.FormID, name = o.Name });
            ddlType.DataSource = formTypes;
            ddlType.DataTextField = "name";
            ddlType.DataValueField = "id";
            ddlType.DataBind();


            if (Session["currentsearch"] != null)
            {
                string searchstring = (string)Session["currentsearch"];
                SearchTerms terms = new SearchTerms(searchstring);
                ddlType.SelectedValue = terms.FormID.ToString();
                if (terms.MinPrice != null)
                    ddlMin.SelectedValue = terms.MinPrice.ToString();
                if (terms.MaxPrice != null && terms.MaxPrice > 0)
                    ddlMax.SelectedValue = terms.MaxPrice.ToString();
                if (terms.StartDate != null && terms.StartDate != DateTime.MinValue)
                    txtStart.Text = terms.StartDate.ToShortDateString();
                if (terms.EndDate != null && terms.EndDate != DateTime.MinValue)
                    txtEnd.Text = terms.EndDate.ToShortDateString();
                txtZip.Text = terms.Zip;
                txtKeyword.Text = terms.Keywords;
            }
        }

        if (Request.Url.AbsoluteUri.Contains(searchPath) || !string.IsNullOrEmpty(Request.QueryString["postid"]))
        {
            pnlSearch.CssClass = "quickSearch";
            lnkClose.Visible = false;
        }
        else
        {
            pnlSearch.CssClass = "quickSearchPopUp " + searchCss;
        }
        
    }
    protected void imgSearch_Click(object sender, EventArgs e)
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
        string searchPath = "";
        string searchCss = "";
        switch (ListingTypeID)
        {
            case 1:
                searchPath = "/rentals/";
                searchCss = "qsRentals";
                break;
            case 2:
                searchPath = "/sales/";
                searchCss = "qsSales";
                break;
            case 3:
                searchPath = "/openhouses/";
                searchCss = "qsOpenHouses";
                break;
            case 4:
                searchPath = "/auctions/";
                searchCss = "qsAuctions";
                break;
        }

        string zipCode = txtZip.Text;
        if(zipCode.Contains(','))
        {
            string city = txtZip.Text.Substring(0,txtZip.Text.IndexOf(',')).Trim().ToLower();
            string state = txtZip.Text.Substring(txtZip.Text.IndexOf(',') + 1).Trim().ToLower();
            DataClassesDataContext context = new DataClassesDataContext();
            IQueryable<Zipcode> cityZipCode = context.Zipcodes.Where( z=> z.Abbreviation.ToLower() == state && z.City.ToLower() == city);
            if(cityZipCode.Count() > 0)
            {
                zipCode = cityZipCode.First().Zipcode1;
            }
        }

        SearchTerms terms = new SearchTerms
        {
            ListingTypeID = ListingTypeID,
            FormID = Convert.ToInt32(ddlType.SelectedValue),
            MinPrice = Convert.ToInt32(ddlMin.SelectedValue),
            MaxPrice = Convert.ToInt32(ddlMax.SelectedValue),
            Keywords = txtKeyword.Text,
            Zip = zipCode
        };
        if (!string.IsNullOrEmpty(txtStart.Text))
            terms.StartDate = DateTime.Parse(txtStart.Text);
        if (!string.IsNullOrEmpty(txtEnd.Text))
            terms.EndDate = DateTime.Parse(txtEnd.Text);

        string searchstring = terms.GetSearchString();

        if (Session["currentsearch"] != null)
        {
            Session.Add("currentsearch", searchstring);
        }
        else
        {
            Session["currentsearch"] = searchstring;
        }
        Response.Redirect("~" + searchPath + "Default.aspx");
    }
    protected void closePanel(object sender, EventArgs e)
    {
        this.Visible = false;
    }
}
