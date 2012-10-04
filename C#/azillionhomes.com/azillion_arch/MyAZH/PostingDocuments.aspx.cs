using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;
using Telerik.Web.UI;

public partial class myazh_PostingDocuments : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminSection = AZHCore.AZHSection.MyPosting;
        ShowSearch = false;
        //Load Form Details
        if (Session["editPostingType"] == null || Session["formEntryId"] == null)
            Response.Redirect("ChoosePostingType.aspx");

        //Set Breadcrumb
        int formId = Convert.ToInt32(Session["editPostingType"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        DataClassesDataContext context = new DataClassesDataContext();
        ListingType listingType = context.ListingTypes.Single(n => n.ListingTypeID == listingTypeId);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);
        string formTypeName = postingForm.Name;
        if (formTypeName.Contains('-'))
            formTypeName = postingForm.Name.Split(new string[] { "-" }, StringSplitOptions.None)[1].Trim();
        lblPostingBreadCrumb.Text = listingType.Name + " &raquo; " + formTypeName;
    }

    protected void butFileDelete_Click(object sender, EventArgs e)
    {
        Button delButton = sender as Button;
        int formDocumentId = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormDocument delFile = context.FormDocuments.Single(n => n.FormDocumentID == formDocumentId);
        string basePath = Server.MapPath(ConfigurationManager.AppSettings["postfilesdir"]);
        string filename = delFile.Filename;
        File.Delete(basePath + filename);
        context.FormDocuments.DeleteOnSubmit(delFile);
        context.SubmitChanges();
        rptImages.DataBind();
    }

    protected void lnkUpload_Click(object sender, EventArgs e)
    {
        if (RadUpload1.UploadedFiles.Count > 0)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            string fileFolder = Server.MapPath(ConfigurationManager.AppSettings["postfilesdir"]);
            int fileIndex = 1;
            string filePrefix = "file_" + Session["formEntryId"].ToString() + "_";
            foreach (UploadedFile file in RadUpload1.UploadedFiles)
            {
                string[] fileParts = file.FileName.Split(new string[] { "." }, StringSplitOptions.None);
                string fileExtension = fileParts[fileParts.Length - 1];
                string filename = filePrefix + fileIndex.ToString() + "." + fileExtension;
                string fullPath = fileFolder + filename;
                while (File.Exists(fullPath))
                {
                    filename = filePrefix + fileIndex.ToString() + "." + fileExtension;
                    fullPath = fileFolder + filename;
                    fileIndex++;
                }
                string docTitle = file.GetFieldValue("Title");
                if (string.IsNullOrEmpty(docTitle))
                    docTitle = file.GetName();

                file.SaveAs(fullPath);

                FormDocument newDocument = new FormDocument { Name = docTitle, Filename = filename, FormEntryID = (int)Session["formEntryId"], SortOrder = fileIndex };
                context.FormDocuments.InsertOnSubmit(newDocument);
            }
            context.SubmitChanges();
        }
        rptImages.DataBind();
    }
    protected void lnkContinue_Click(object sender, EventArgs e)
    {
        Response.Redirect("PostingPreview.aspx");
    }
}
