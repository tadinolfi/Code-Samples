using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_MyPostings : AZHCore.AZHPage 
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
    public SortDirection CurrentDirection
    {
        get
        {
            if (ViewState["CurrentDirection"] != null)
            {
                return (SortDirection)ViewState["CurrentDirection"];
            }
            else
            {
                return SortDirection.Descending;
            }
        }
        set { ViewState["CurrentDirection"] = value; }
    }
    public bool ViewAgencyPosts
    {
        get
        {
            if (ViewState["ViewAgencyPosts"] != null)
            {
                return (bool)ViewState["ViewAgencyPosts"];
            }
            else
            {
                return false;
            }

        }
        set { ViewState["ViewAgencyPosts"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        else
        {
            UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
            if (currentUser.Subscriptions.Where(n => n.Expires >= DateTime.Now).Count() == 0)
            {
                pnlMessage.Visible = true;
            }
        }
        AdminSection = AZHCore.AZHSection.MyPosting;
        if (!IsPostBack)
        {
            DataBindPostings();
        }
        
        if (context.Agencies.Where(n => n.OwnerUserInfoID == (int)Session["azhuserid"]).Count() > 0)
        {
            liAgency.Visible = true;
        }

        if (HasExpiredPosts())
        {
            lblExpiredNotice.Visible = true;
        }
    }

    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        LinkButton editButton = sender as LinkButton;
        int formEntryId = Convert.ToInt32(editButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        Session.Add("formEntryId", formEntryId);
        Session.Add("listingTypeID",currentEntry.ListingTypeID);
        Session.Add("editPostingType", currentEntry.FormID);
        Response.Redirect("PostingInfo.aspx");
    }
    protected void lnkAll_Click(object sender, EventArgs e)
    {
        grdPostings.PageIndex = 0;
        ListingTypeID = 0;
        DataBindPostings();
    }
    protected void lnkRentals_Click(object sender, EventArgs e)
    {
        grdPostings.PageIndex = 0;
        ListingTypeID = 1;
        DataBindPostings();
    }
    protected void lnkSales_Click(object sender, EventArgs e)
    {
        grdPostings.PageIndex = 0;
        ListingTypeID = 2;
        DataBindPostings();
    }
    protected void lnkOpenHouses_Click(object sender, EventArgs e)
    {
        grdPostings.PageIndex = 0;
        ListingTypeID = 3;
        DataBindPostings();
    }
    protected void lnkAuctions_Click(object sender, EventArgs e)
    {
        grdPostings.PageIndex = 0;
        ListingTypeID = 4;
        DataBindPostings();
    }
    protected void grdPostings_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdPostings.PageIndex = e.NewPageIndex;
        DataBindPostings();
    }
    protected void lnkDeactivate_Click(object sender, EventArgs e)
    {
        LinkButton sendButton = sender as LinkButton;
        int formEntryId = Convert.ToInt32(sendButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        currentEntry.Active = false;
        context.SubmitChanges();
        DataBindPostings();
    }
    protected void lnkActivate_Click(object sender, EventArgs e)
    {
        LinkButton sendButton = sender as LinkButton;
        int formEntryId = Convert.ToInt32(sendButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        currentEntry.Active = true;
        context.SubmitChanges();
        DataBindPostings();
    }
    protected void grdPostings_Sorting(object sender, GridViewSortEventArgs e)
    {
        CurrentSort = e.SortExpression;
        CurrentDirection = e.SortDirection;
        grdPostings.PageIndex = 0;
        DataBindPostings();
    }
    private void DataBindPostings()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<FormEntry> entries;
        if (ViewAgencyPosts)
        {
            int agencyId = context.Agencies.Where(a => a.OwnerUserInfoID == (int)Session["azhuserid"]).First().AgencyID;
            entries = context.FormEntries.Where(n => n.UserInfo.AgencyID == agencyId);
        }
        else
        {
            entries = context.FormEntries.Where(n => n.UserInfoID == (int)Session["azhuserid"]);
        }
        if (ListingTypeID > 0)
        {
            entries = entries.Where(n => n.ListingTypeID == ListingTypeID);
        }
        string sortString = CurrentSort;
        if (CurrentDirection == SortDirection.Descending)
        {
            sortString += " DESC";
        }
        entries = entries.OrderBy(sortString);
        grdPostings.DataSource = entries;
        grdPostings.DataBind();
    }
    protected void lnkViewMine_Click(object sender, EventArgs e)
    {
        ViewAgencyPosts = false;
        grdPostings.PageIndex = 0;
        DataBindPostings();
        liMine.Visible = false;
        liAgency.Visible = true;
    }
    protected void lnkViewAgency_Click(object sender, EventArgs e)
    {
        ViewAgencyPosts = true;
        grdPostings.PageIndex = 0;
        DataBindPostings();
        liAgency.Visible = false;
        liMine.Visible = true;
    }

    protected string GetViews(int formEntryId, bool todayOnly)
    {
        string retValue;
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<FormView> views = context.FormViews.Where(n => n.FormEntryID == formEntryId);
        if (todayOnly)
            views = views.Where(n => n.ViewDate.Date == DateTime.Now.Date);
        retValue = views.Count().ToString();
        return retValue;
    }
    protected void lnkApprove_Click(object sender, EventArgs e)
    {
        LinkButton butApprove = sender as LinkButton;
        int formEntryId = Convert.ToInt32(butApprove.CommandArgument);
        Session["formEntryId"] = formEntryId;
        Response.Redirect("PostingPreview.aspx");
    }
    protected void lnkRenew_Click(object sender, EventArgs e)
    {
        LinkButton butRenew = sender as LinkButton;
        int formEntryId = Convert.ToInt32(butRenew.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentForm = context.FormEntries.Single(f => f.FormEntryID == formEntryId);
        currentForm.Expires = DateTime.Now.AddDays(30);
        context.SubmitChanges();
        DataBindPostings();
    }
    protected void butDelete_Click(object sender, EventArgs e)
    {
        Button delButton = sender as Button;
        int formEntryID = Convert.ToInt32(delButton.CommandArgument);
        DropDownList ddlReason = delButton.Parent.FindControl("ddlReason") as DropDownList;
        FormAPI.ArchiveFormEntry(formEntryID, ddlReason.SelectedValue);
        DataBindPostings();
    }
    protected bool HasExpiredPosts()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        int expiredCount = context.FormEntries.Where(f => f.Active == true && f.Completed == true && f.Expires < DateTime.Now && f.UserInfoID == (int)Session["azhuserid"]).Count();
        if (expiredCount > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
