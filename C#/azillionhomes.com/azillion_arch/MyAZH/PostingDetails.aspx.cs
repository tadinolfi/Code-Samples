using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AZHControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Xml.Linq;

public partial class myazh_PostingDetails : AZHCore.AZHPage 
{
    protected int SelectedSectionID
    {
        get
        {
            if (ViewState["SelectedSectionID"] != null)
            {
                return (int)ViewState["SelectedSectionID"];
            }
            else
            {
                return 0;
            }
        }
        set { ViewState["SelectedSectionID"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        AdminSection = AZHCore.AZHSection.MyPosting;
        ShowSearch = false;
        //Load Form Details
        if (Session["editPostingType"] == null)
            Response.Redirect("ChoosePostingType.aspx");
        DataClassesDataContext context = new DataClassesDataContext();
        int formId = Convert.ToInt32(Session["editPostingType"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);
        ListingType listingType = context.ListingTypes.Single(n => n.ListingTypeID == listingTypeId);
        IEnumerable<FormSection> sections = postingForm.FormSections.Where(n => n.FirstPage == false).OrderBy(n => n.SortOrder);

        if (!IsPostBack)
        {
            //Set Breadcrumb
            string formTypeName = postingForm.Name;
            if (formTypeName.Contains('-'))
                formTypeName = postingForm.Name.Split(new string[] { "-" }, StringSplitOptions.None)[1].Trim();
            lblPostingBreadCrumb.Text = formTypeName;
            lblPostingBreadCrumb.Text = listingType.Name + " &raquo; " + formTypeName;
        }

        if (sections.Count() == 0)
        {
            pnlNoDetails.Visible = true;
            pnlDetails.Visible = false;
        }
        else
        {
            if (!IsPostBack)
            {
                SelectedSectionID = sections.First().FormSectionID;
            }

            foreach (FormSection currentSection in sections)
            {
                //Add Panel & Title
                LinkButton lnkSectionLink = new LinkButton { ID = "lnkSection" + currentSection.FormSectionID.ToString(), Text = currentSection.SectionName, CommandArgument = currentSection.FormSectionID.ToString() };
                lnkSectionLink.OnClientClick = "window.scroll(0,300);";
                lnkSectionLink.Click += new EventHandler(lnkSectionLink_Click);
                Panel pnlSectionFields = new Panel { ID = "pnlSection" + currentSection.FormSectionID.ToString(), CssClass = "detailContent" };
                HtmlGenericControl paragraph = new HtmlGenericControl { InnerText = currentSection.Description, TagName = "p" };
                pnlSectionFields.Controls.Add(paragraph);
                bool altRow = false;
                //Render Fields
                int ZIndex = 100000;
                IQueryable<FormField> sectionFields = currentSection.FormFields.OrderBy(n => n.SortOrder).AsQueryable();
                foreach (FormField currentField in sectionFields)
                {
                    AZHField fieldControl = new AZHField { ID = "field" + currentField.FormFieldID, FormFieldID = currentField.FormFieldID, AltRow = altRow };
                    altRow = !altRow;
                    fieldControl.ZIndex = ZIndex;
                    ZIndex--;
                    pnlSectionFields.Controls.Add(fieldControl);
                }
                Panel pnlButtonRow = new Panel { ID = "pnlButtonRow" + currentSection.FormSectionID, CssClass = "buttonRow" };
                LinkButton lnkSaveSection = new LinkButton { ID = "lnkSave" + currentSection.FormSectionID.ToString(), Text = "Save Section", CssClass = "linkButton savesection_m", CommandArgument = currentSection.FormSectionID.ToString() };
                //LinkButton lnkPhotos = new LinkButton { ID = "lnkPhotos" + currentSection.FormSectionID.ToString(), Text = "Go To Photos", CssClass = "photosButton" };
                lnkSaveSection.Click += new EventHandler(lnkSaveSection_Click);
                lnkSaveSection.OnClientClick = "window.scroll(0,300);";
                //lnkPhotos.Click += new EventHandler(lnkPhotos_Click);
                if (currentSection.FormSectionID == SelectedSectionID)
                {
                    lnkSectionLink.CssClass = "sectionLink expandedDetail";
                    pnlSectionFields.Visible = true;
                    lblSection.Text = currentSection.SectionName;
                }
                else
                {
                    lnkSectionLink.CssClass = "sectionLink";
                    pnlSectionFields.Visible = false;
                }
                pnlButtonRow.Controls.Add(lnkSaveSection);
                //pnlButtonRow.Controls.Add(lnkPhotos);
                pnlSectionFields.Controls.Add(pnlButtonRow);
                pnlSections.Controls.Add(lnkSectionLink);
                pnlSections.Controls.Add(pnlSectionFields);
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }
    }

    void lnkPhotos_Click(object sender, EventArgs e)
    {
        SaveData();
        Response.Redirect("PostingPhotos.aspx");
    }

    void lnkSaveSection_Click(object sender, EventArgs e)
    {
        SaveData();
        //Hide Current Section
        Panel pnlCurrentSection = pnlSections.FindControl("pnlSection" + SelectedSectionID.ToString()) as Panel;
        LinkButton lnkCurrentSection = pnlSections.FindControl("lnkSection" + SelectedSectionID.ToString()) as LinkButton;
        pnlCurrentSection.Visible = false;
        lnkCurrentSection.CssClass = "sectionLink";

        DataClassesDataContext context = new DataClassesDataContext();


        FormSection currentSection = context.FormSections.Single(n => n.FormSectionID == SelectedSectionID);
        lblSection.Text = currentSection.SectionName;

        IQueryable<FormSection> sections = context.FormSections.Where(n => n.FirstPage == false && n.FormID == currentSection.FormID && n.FormSectionID > SelectedSectionID).OrderBy(n => n.FormSectionID);
        if (sections.Count() > 0)
        {
            SelectedSectionID = sections.First().FormSectionID;

            FormSection nextSection = context.FormSections.Single(n => n.FormSectionID == SelectedSectionID);
            lblSection.Text = nextSection.SectionName;

            //Show Next Section
            Panel pnlOpenSection = pnlSections.FindControl("pnlSection" + SelectedSectionID.ToString()) as Panel;
            LinkButton lnkOpenSection = pnlSections.FindControl("lnkSection" + SelectedSectionID.ToString()) as LinkButton;
            pnlOpenSection.Visible = true;
            lnkOpenSection.CssClass = "sectionLink expandedDetail";
        }
        else
        {
            Response.Redirect("PostingPhotos.aspx");
        }
    }

    void lnkSectionLink_Click(object sender, EventArgs e)
    {
        //Get Section ID
        LinkButton lnkSection = sender as LinkButton;
        int sectionID = Convert.ToInt32(lnkSection.CommandArgument);
        
        //Hide Open Section
        Panel pnlOpenSection = pnlSections.FindControl("pnlSection" + SelectedSectionID.ToString()) as Panel;
        LinkButton lnkOpenSection = pnlSections.FindControl("lnkSection" + SelectedSectionID.ToString()) as LinkButton;
        pnlOpenSection.Visible = false;
        lnkOpenSection.CssClass = "sectionLink";

        //Show this section
        Panel pnlClosedSection = pnlSections.FindControl("pnlSection" + sectionID.ToString()) as Panel;
        LinkButton lnkClosedSection = pnlSections.FindControl("lnkSection" + sectionID.ToString()) as LinkButton;
        pnlClosedSection.Visible = true;
        lnkClosedSection.CssClass = "sectionLink expandedDetail";
        SelectedSectionID = sectionID;

        DataClassesDataContext context = new DataClassesDataContext();
        FormSection nextSection = context.FormSections.Single(n => n.FormSectionID == SelectedSectionID);
        lblSection.Text = nextSection.SectionName;
    }

    protected void SaveData()
    {
        //Load up the Form
        if (Session["editPostingType"] == null)
            Response.Redirect("ChoosePostingType.aspx");
        DataClassesDataContext context = new DataClassesDataContext();
        int formId = Convert.ToInt32(Session["editPostingType"]);
        int listingTypeId = Convert.ToInt32(Session["listingTypeID"]);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);
        ListingType listingType = context.ListingTypes.Single(n => n.ListingTypeID == listingTypeId);

        //Load the FormEntry
        int formEntryId = Convert.ToInt32(Session["formEntryId"]);
        FormEntry currentForm = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        XDocument dataDoc = XDocument.Parse(currentForm.Entry);

        //Loop Sections
        foreach (FormSection section in postingForm.FormSections)
        {
            if (!section.FirstPage)
            {
                XElement xmlSection = dataDoc.Descendants("formsection").Where(n => n.Attributes("id").First().Value == section.FormSectionID.ToString()).First();
                Panel pnlSection = pnlSections.FindControl("pnlSection" + section.FormSectionID.ToString()) as Panel;
                foreach (FormField field in section.FormFields)
                {
                    XElement xmlField = xmlSection.Descendants("field").Where(n => n.Attributes("id").First().Value == field.FormFieldID.ToString()).First();
                    AZHField fieldControl = pnlSection.FindControl("field" + field.FormFieldID.ToString()) as AZHField;
                    if(fieldControl != null)
                    {
                        string value = fieldControl.Value;
                        if (fieldControl.Value == "")
                        {
                            value = fieldControl.GetFieldValue();
                        }
                        xmlField.Value = value;
                    }
                }
            }
        }
        currentForm.Entry = dataDoc.ToString();
        context.SubmitChanges();
    }

    protected void LoadData()
    {
        //Load the FormEntry
        DataClassesDataContext context = new DataClassesDataContext();
        int formEntryId = Convert.ToInt32(Session["formEntryId"]);
        FormEntry currentForm = context.FormEntries.Single(n => n.FormEntryID == formEntryId);
        int formId = Convert.ToInt32(Session["editPostingType"]);
        Form postingForm = context.Forms.Single(n => n.FormID == formId);
        XDocument dataDoc = XDocument.Parse(currentForm.Entry);

        //Loop Sections
        foreach (FormSection section in postingForm.FormSections)
        {
            if (!section.FirstPage)
            {
                XElement xmlSection = dataDoc.Descendants("formsection").Where(n => n.Attributes("id").First().Value == section.FormSectionID.ToString()).First();
                Panel pnlSection = pnlSections.FindControl("pnlSection" + section.FormSectionID.ToString()) as Panel;
                foreach (FormField field in section.FormFields)
                {
                    try
                    {
                        XElement xmlField = xmlSection.Descendants("field").Where(n => n.Attributes("id").First().Value == field.FormFieldID.ToString()).First();
                        AZHField fieldControl = pnlSection.FindControl("field" + field.FormFieldID.ToString()) as AZHField;
                        fieldControl.Value = xmlField.Value;
                    }
                    catch
                    {
                        //Ignore errors here, they are likely the cause of a change in the form structure
                    }
                }
            }
        }
    }
}
