using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Drawing;

public partial class SearchResults : System.Web.UI.MasterPage
{
    public int CurrentPage
    {
        get
        {
            if (ViewState["CurrentPage"] != null)
            {
                return (int)ViewState["CurrentPage"];
            }
            else
            {
                return 1;
            }
        }
        set { ViewState["CurrentPage"] = value; }
    }

    public int PageSize
    {
        get
        {
            if (ViewState["PageSize"] != null)
            {
                return (int)ViewState["PageSize"];
            }
            else
            {
                return 10;
            }
        }
        set { ViewState["PageSize"] = value; }
    }

    public int ListingType
    {
        get
        {
            if (ViewState["ListingType"] != null)
            {
                return (int)ViewState["ListingType"];
            }
            else
            {
                return 1;
            }
        }
        set { ViewState["ListingType"] = value; }
    }

    public int FormType
    {
        get
        {
            if (ViewState["FormType"] != null)
            {
                return (int)ViewState["FormType"];
            }
            else
            {
                return 1;
            }
        }
        set { ViewState["FormType"] = value; }
    }

    public string CurrentSort
    {
        get
        {
            if (ViewState["CurrentSort"] != null)
            {
                return (string)ViewState["CurrentSort"];
            }
            else
            {
                return "EntryDate";
            }
        }
        set { ViewState["CurrentSort"] = value; }
    }

    public SortDirection CurrentSortDirection
    {
        get
        {
            if (ViewState["CurrentSortDirection"] != null)
            {
                return (SortDirection)ViewState["CurrentSortDirection"];
            }
            else
            {
                return SortDirection.Descending;
            }
        }
        set { ViewState["CurrentSortDirection"] = value; }
    }

    public List<int> SavedListings
    {
        get
        {
            if (ViewState["SavedListings"] != null)
            {
                return (List<int>)ViewState["SavedListings"];
            }else{
                List<int> retList = new List<int>();
                if (Session["azhuserid"] != null)
                {
                    DataClassesDataContext context = new DataClassesDataContext();
                    IQueryable<SavedFormEntry> savedEntries = context.SavedFormEntries.Where(n => n.UserInfoID == (int)Session["azhuserid"]);
                    foreach (SavedFormEntry entry in savedEntries)
                    {
                        retList.Add(entry.FormEntryID);
                    }
                }
                return retList;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["currentsearch"] == null)
        {
            DataClassesDataContext context = new DataClassesDataContext();

            if (Request.Url.AbsoluteUri.Contains("/rentals/"))
            {
                Session.Add("currentsearch", "1|0|0|0|||||");
            }
            if (Request.Url.AbsoluteUri.Contains("/sales/"))
            {
                Session.Add("currentsearch", "2|0|0|0|||||");
            }
            if (Request.Url.AbsoluteUri.Contains("/openhouses/"))
            {
                Session.Add("currentsearch", "3|0|0|0|||||");
            }
            if (Request.Url.AbsoluteUri.Contains("/auctions/"))
            {
                Session.Add("currentsearch", "4|0|0|0|||||");
            }
        }
        grdResults.PageSize = PageSize;
        LoadData();
    }

    protected string GetImage(FormEntry currentEntry)
    {
        string imagePath = ConfigurationManager.AppSettings["imagesdir"] + "/icons/";
        if (currentEntry.FormImages.Count > 0)
        {
            imagePath += currentEntry.FormImages[0].Filename;
        }
        else
        {
            imagePath = "~/images/content/search-results/" + currentEntry.ListingTypeID.ToString() + "_results.jpg";
        }
        return imagePath;
    }

    protected void lnkSaveListing_Click(object sender, EventArgs e)
    {
        LinkButton saveButton = sender as LinkButton;
        int formEntryId = Convert.ToInt32(saveButton.CommandArgument);
        if (Session["azhuserid"] != null)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            SavedFormEntry listing = new SavedFormEntry
            {
                Created = DateTime.Now,
                FormEntryID = formEntryId,
                UserInfoID = (int)Session["azhuserid"]
            };
            context.SavedFormEntries.InsertOnSubmit(listing);
            context.SubmitChanges();
            saveButton.Enabled = false;
            saveButton.Text = "listing saved";
        }
        else
        {
            saveButton.Enabled = false;
            saveButton.ForeColor = Color.Red;
            saveButton.Text = "You must be logged in";
        }
    }

    protected void LoadData()
    {
        grdResults.PageIndex = CurrentPage - 1;
        IQueryable<FormEntry> searchResults = FormAPI.SearchPostings((string)Session["currentsearch"]);
        if (searchResults.Count() > 0)
        {
            grdResults.DataSource = searchResults;
            grdResults.DataBind();
            if (grdResults.PageCount == 1)
            {
                pnlViewCount.Visible = true;
                litViewing1.Text = GetViewing();
            }
        }
        else
        {
            imgNewSearch.Visible = false;
            imgSaveSearch.Visible = false;
            pnlNoResults.Visible = true;
            pnlSavedSearch.Visible = false;
            ModalPopupExtender1.Enabled = false;
        }
    }
    protected void grdResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        CurrentPage = e.NewPageIndex + 1;
        LoadData();
    }
    protected void grdResults_Sorting(object sender, GridViewSortEventArgs e)
    {
        CurrentSort = e.SortExpression;
        CurrentSortDirection = e.SortDirection;
        CurrentPage = 1;
        LoadData();
    }
    protected void imgNewSearch_Click(object sender, EventArgs e)
    {
        Session.Remove("currentsearch");
        Response.Redirect("Default.aspx");
    }
    protected void imgSave_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        SavedSearch search = new SavedSearch();
        search.Created = DateTime.Now;
        search.Criteria = (string)Session["currentsearch"];
        search.LastUsed = DateTime.Now;
        search.SearchName = txtSearchName.Text;
        search.UserInfoID = (int)Session["azhuserid"];
        context.SavedSearches.InsertOnSubmit(search);
        context.SubmitChanges();
        lblMessage.Text = txtSearchName.Text + " has been added to your saved searches";
    }
    protected void lnkLogin_Click(object sender, EventArgs e)
    {
        string retUrl = Server.UrlEncode(Request.Url.AbsoluteUri);
        Response.Redirect("~/Login.aspx?returnurl=" + retUrl);
    }
    protected bool ListingCheck(int formEntryID)
    {
        return !SavedListings.Contains(formEntryID);
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
    protected string FormatDescription(string description)
    {
        string retDescription = "";
        description = description.Trim();
        if (description.Length > 60)
        {
            int spaceIndex = description.IndexOf(' ', 60);
            if(spaceIndex > 0)
                retDescription = description.Substring(0, spaceIndex ) + "...";
        }
        else
        {
            retDescription = description;
        }
        return retDescription;
    }

    protected string GetPostingDate(FormEntry dataItem)
    {
        string retDate;
        if (dataItem.ListingTypeID == 3 && dataItem.OpenHouseDates.Count > 0)
        {
            SearchTerms terms = new SearchTerms(Session["currentsearch"].ToString());
            DateTime startDate = DateTime.Now;
            if (terms.StartDate != null)
            {
                startDate = terms.StartDate;
            }
            DateTime NextDate = dataItem.OpenHouseDates.Where(o => o.EventDate >= startDate).OrderBy(o => o.EventDate).First().EventDate;
            retDate = NextDate.ToShortDateString().Replace("/", ".") + " @ " + dataItem.EventStart.Value.ToShortTimeString();
        }
        else
        {
            if (dataItem.Form.RequiresDate)
            {
                retDate = dataItem.Expires.Value.ToShortDateString();
            }
            else
            {
                retDate = dataItem.EntryDate.ToShortDateString();
            }
        }
        return retDate.Replace('/','.');
    }
    protected void grdResults_DataBound(object sender, EventArgs e)
    {
        if (grdResults.TopPagerRow != null)
        {
            GridViewRow topPagerRow = grdResults.TopPagerRow;
            GridViewRow bottomPagerRow = grdResults.BottomPagerRow;

            Panel topRepeater = topPagerRow.FindControl("pnlPages") as Panel;
            Panel bottomRepeater = bottomPagerRow.FindControl("pnlPages") as Panel;

            for (int i = 0; i < grdResults.PageCount; i++)
            {
                int displayPage = i + 1;
                string cssClass = "pageLink";
                bool enabled = true;
                if (i == grdResults.PageIndex)
                {
                    cssClass = "activePage";
                    enabled = false;
                }
                LinkButton lnkPage = new LinkButton { CommandName = "Page", CommandArgument = displayPage.ToString(), Text = displayPage.ToString(), CssClass = cssClass, Enabled = enabled };
                LinkButton lnkPage2 = new LinkButton { CommandName = "Page", CommandArgument = displayPage.ToString(), Text = displayPage.ToString(), CssClass = cssClass, Enabled = enabled };
                topRepeater.Controls.Add(lnkPage);
                bottomRepeater.Controls.Add(lnkPage2);
            }
        }
    }

    protected string GetViewing()
    {
        string retVal = "";
        retVal += (grdResults.PageIndex * PageSize + 1).ToString();
        retVal += "-";
        int endRow =((grdResults.PageIndex + 1) * PageSize);
        int rowCount = ((IQueryable<FormEntry>)grdResults.DataSource).Count();
        if (endRow > rowCount)
            endRow = rowCount;
        retVal += endRow.ToString();
        retVal += " of " + rowCount.ToString() + " matches";
        return retVal;
    }
    protected void lnkFirst_Click(object sender, ImageClickEventArgs e)
    {
        CurrentPage = 1;
        LoadData();
    }
    protected void lnkPrev_Click(object sender, ImageClickEventArgs e)
    {
        if (CurrentPage > 1)
        {
            CurrentPage--;
            if (CurrentPage == 1)
            {
                ((ImageButton)sender).Enabled = false;
            }
            LoadData();
        }
    }
    protected void lnkNext_Click(object sender, ImageClickEventArgs e)
    {
        int rowCount = ((IQueryable<FormEntry>)grdResults.DataSource).Count();
        int pageCount = Convert.ToInt16(Math.Ceiling((double)rowCount / (double) PageSize));
        if (CurrentPage < pageCount)
        {
            CurrentPage++;
            if (CurrentPage == pageCount)
                ((ImageButton)sender).Enabled = false;
            LoadData();
        }
    }
    protected void lnkLast_Click(object sender, ImageClickEventArgs e)
    {
        int rowCount = ((IQueryable<FormEntry>)grdResults.DataSource).Count();
        int pageCount = Convert.ToInt16(Math.Ceiling((double)rowCount / (double)PageSize));
        CurrentPage = pageCount;
        LoadData();
    }
}
