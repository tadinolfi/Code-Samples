using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Xml.Linq;

public partial class myazh_PostingPreview : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminSection = AZHCore.AZHSection.MyPosting;
        ShowSearch = false;
        if (Session["formEntryId"] == null)
        {
            Response.Redirect("Default.aspx");
        }
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        if (currentUser.Subscriptions.Where(n => n.Expires > DateTime.Now).Count() == 0 && listingTypeId != 3)
        {
            pnlPreview.Visible = false;
            pnlNoSubscription.Visible = true;
        }
    }
    protected void imgComplete_Click(object sender, EventArgs e)
    {
        int formEntryId = (int)Session["formEntryId"];
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry approveEntry = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        approveEntry.Completed = true;
        approveEntry.Paid = true;
        approveEntry.Active = true;

        //Build Search Keywords
        StringBuilder searchBuilder = new StringBuilder();
        Form currentForm = context.Forms.Single(n => n.FormID == approveEntry.FormID);
        XDocument entryXml = XDocument.Parse(approveEntry.Entry);
        foreach (FormSection section in currentForm.FormSections)
        {
            XElement sectionElement = entryXml.Descendants("formsection").Single(element => element.Attribute("id").Value == section.FormSectionID.ToString());
            foreach (FormField field in section.FormFields)
            {
                if (field.Searchable)
                {
                    XElement fieldElement = sectionElement.Descendants("field").Single(element => element.Attribute("id").Value == field.FormFieldID.ToString());
                    searchBuilder.Append(field.Name + ":" + fieldElement.Value + "|");
                }
            }
        }
        approveEntry.SearchableFields = searchBuilder.ToString();

        context.SubmitChanges();
        Response.Redirect("Default.aspx");
    }
    protected void imgCreateSubscription_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CreateSubscription.aspx");
    }
}
