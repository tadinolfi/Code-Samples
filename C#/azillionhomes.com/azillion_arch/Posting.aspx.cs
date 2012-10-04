using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Posting : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["postid"]))
        {
            mainPosting.FormEntryID = Convert.ToInt32(Request.QueryString["postid"]);
            DataClassesDataContext context = new DataClassesDataContext();
            FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == Convert.ToInt32(Request.QueryString["postid"]));
            switch(currentEntry.ListingTypeID)
            {
                case 1:
                    Section = AZHCore.PageSection.Rentals;
                    pnlRental.Visible = true;
                    break;
                case 2:
                    Section = AZHCore.PageSection.Sales;
                    pnlSales.Visible = true;
                    break;
                case 3:
                    Section = AZHCore.PageSection.OpenHouses;
                    pnlOpenHouses.Visible = true;
                    break;
                case 4:
                    Section = AZHCore.PageSection.Auctions;
                    pnlAuctions.Visible = true;
                    break;
            }
        }
        if (Session["currentsearch"] == null)
        {
            lnkNext.Visible = false;
            lnkPrev.Visible = false;
        }
        else
        {
            string searchString = (string)Session["currentsearch"];
            int formEntryId = Convert.ToInt32(Request.QueryString["postid"]);
            IQueryable<FormEntry> searchEntries = FormAPI.SearchPostings(searchString).OrderByDescending(n => n.EntryDate);
            IEnumerable<FormEntry> prevEntries = searchEntries.ToList().TakeWhile(n => n.FormEntryID != formEntryId);
            IEnumerable<FormEntry> nextEntries = searchEntries.ToList().SkipWhile(n => prevEntries.Contains(n));
            if(prevEntries.Count()> 0)
            {
                lnkPrev.Visible = true;
                lnkPrev.NavigateUrl = "~/Posting.aspx?postid=" + prevEntries.Last().FormEntryID.ToString();
            }
            if (nextEntries.Count() > 1)
            {
                lnkNext.Visible = true;
                lnkNext.NavigateUrl = "~/Posting.aspx?postid=" + nextEntries.ElementAt(1).FormEntryID.ToString();
            }
        }
    }
}
