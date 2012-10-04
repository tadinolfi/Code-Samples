using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MyAZH_SavedListings : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminSection = AZHCore.AZHSection.MyPosting;
    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        LinkButton loadSearch = sender as LinkButton;
        string searchString = loadSearch.CommandArgument;
    }
    protected void lnkDeleteListing_Click(object sender, EventArgs e)
    {
        LinkButton delButton = sender as LinkButton;
        int savedListingID = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        SavedFormEntry delListing = context.SavedFormEntries.Single(n => n.SavedFormEntryID == savedListingID);
        context.SavedFormEntries.DeleteOnSubmit(delListing);
        context.SubmitChanges();
        grdListings.DataBind();
    }
    protected void lnkDeleteSearch_Click(object sender, EventArgs e)
    {
        LinkButton delButton = sender as LinkButton;
        int savedSearchID = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        SavedSearch delSearch = context.SavedSearches.Single(n => n.SavedSearchID == savedSearchID);
        context.SavedSearches.DeleteOnSubmit(delSearch);
        context.SubmitChanges();
        grdSearches.DataBind();
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkEmail = sender as CheckBox;
        int savedSearchId = chkEmail.TabIndex;
        DataClassesDataContext context = new DataClassesDataContext();
        SavedSearch updateSearch = context.SavedSearches.Single(search => search.SavedSearchID == savedSearchId);
        updateSearch.EmailListings = chkEmail.Checked;
        context.SubmitChanges();
    }
}
