using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_PostingHeader : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bool hasDetails = true;

        if (Session["formEntryId"] == null)
        {
            lnkInfo.Enabled = false;
            lnkDetails.Enabled = false;
            lnkPhotos.Enabled = false;
            lnkDocuments.Enabled = false;
            lnkPreview.Enabled = false;
        }
        if (Session["editPostingType"] != null)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            Form currentForm = context.Forms.Single(n => n.FormID == Convert.ToInt32(Session["editPostingType"]));
            if (currentForm.FormSections.Count == 1)
                hasDetails = false;
        }

        if (Request.Url.AbsoluteUri.Contains("Type.aspx"))
        {
            lnkType.CssClass = "selectedProgress";
        }

        if (Request.Url.AbsoluteUri.Contains("PostingInfo.aspx"))
        {
            lnkInfo.CssClass = "selectedProgress";
            lnkType.CssClass = "completed";
        }

        if (Request.Url.AbsoluteUri.Contains("PostingDetails.aspx"))
        {
            lnkDetails.CssClass = "selectedProgress";
            lnkInfo.CssClass = "completed"; 
            lnkType.CssClass = "completed";
        }

        if (Request.Url.AbsoluteUri.Contains("PostingPhotos.aspx"))
        {
            lnkPhotos.CssClass = "selectedProgress";
            if(hasDetails)
                lnkDetails.CssClass = "completed";
            lnkInfo.CssClass = "completed";
            lnkType.CssClass = "completed";
        }
        
        if (Request.Url.AbsoluteUri.Contains("PostingDocuments.aspx"))
        {
            lnkDocuments.CssClass = "selectedProgress";
            lnkPhotos.CssClass = "completed";
            if (hasDetails)
                lnkDetails.CssClass = "completed";
            lnkInfo.CssClass = "completed";
            lnkType.CssClass = "completed";
        }

        if (Request.Url.AbsoluteUri.Contains("PostingPreview.aspx"))
        {
            lnkPreview.CssClass = "selectedProgress";
            lnkDocuments.CssClass = "completed";
            lnkPhotos.CssClass = "completed";
            if (hasDetails)
                lnkDetails.CssClass = "completed";
            lnkInfo.CssClass = "completed";
            lnkType.CssClass = "completed";
        }

        
    }
}
