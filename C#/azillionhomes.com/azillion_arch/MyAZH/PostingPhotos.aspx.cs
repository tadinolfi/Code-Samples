using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;
using Telerik.Web.UI;

public partial class myazh_PostingPhotos : AZHCore.AZHPage 
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

        CheckMaxUploads();
    }

    protected void butImgDelete_Click(object sender, EventArgs e)
    {
        Button delButton = sender as Button;
        int formImageId = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormImage delImage = context.FormImages.Single(n => n.FormImageID == formImageId);
        string basePath = Server.MapPath(ConfigurationManager.AppSettings["postimagesdir"]);
        string filename = delImage.Filename;
        File.Delete(basePath + filename);
        File.Delete(basePath + "icons/" + filename);
        File.Delete(basePath + "thumbs/" + filename);
        context.FormImages.DeleteOnSubmit(delImage);
        context.SubmitChanges();
        rptImages.DataBind();
    }
    protected void lnkUpload_Click(object sender, EventArgs e)
    {
        if (RadUpload1.UploadedFiles.Count > 0)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            string imgFolder = Server.MapPath(ConfigurationManager.AppSettings["postimagesdir"]);
            string imgPrefix = "img_" + Session["formEntryId"].ToString() + "_";
            foreach (UploadedFile file in RadUpload1.UploadedFiles)
            {
                FormImage newImage = new FormImage { Caption = "", Filename = "", FormEntryID = (int)Session["formEntryId"], SortOrder = 0 };
                context.FormImages.InsertOnSubmit(newImage);
                context.SubmitChanges();

                string imgFilename = imgPrefix + newImage.FormImageID.ToString() + ".jpg";
                string fullPath = imgFolder + imgFilename;

                file.SaveAs(fullPath);
                ImageTools.ResizeImage(imgFilename, 320, 240, "thumbs", false);
                ImageTools.ResizeImage(imgFilename, 92, 69, "icons", true);

                string imgTitle = file.GetFieldValue("Title");
                if (string.IsNullOrEmpty(imgTitle))
                    imgTitle = imgFilename;

                newImage.Filename = imgFilename;
                newImage.SortOrder = newImage.FormImageID;
                newImage.Caption = imgTitle;
                context.SubmitChanges();
            }
            context.SubmitChanges();
        }
        rptImages.DataBind();
        CheckMaxUploads();
    }
    protected void lnkContinue_Click(object sender, EventArgs e)
    {
        Response.Redirect("PostingDocuments.aspx");
    }

    protected void CheckMaxUploads()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormEntry currentEntry = context.FormEntries.Single(n => n.FormEntryID == (int)Session["formEntryId"]);
        if (currentEntry.FormImages.Count >= 12)
        {
            RadUpload1.Visible = false;
            pnlMax.Visible = true;
            lnkUpload.Visible = false;
        }
        else
        {
            RadUpload1.MaxFileInputsCount = 12 - currentEntry.FormImages.Count;
            if (currentEntry.FormImages.Count > 9)
            {
                RadUpload1.InitialFileInputsCount = 12 - currentEntry.FormImages.Count;
            }
        }
    }
}
