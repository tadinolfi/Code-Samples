using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class control_forms_EditForm : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            Form editForm = context.Forms.Single(n => n.FormID == Convert.ToInt32(Request.QueryString["formid"]));
            txtName.Text = editForm.Name;
            txtDescription.Text = editForm.Description;
            chkActive.Checked = editForm.Active;
        }
    }
    protected void butInsertSection_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection newSection = new FormSection { Active = txtSectionActive.Checked, Description = txtSectionDescription.Text, SectionName = txtSectionName.Text, FormID = Convert.ToInt32(Request.QueryString["formid"]) };
        newSection.SortOrder = GetMaxSortOrder() + 1;
        context.FormSections.InsertOnSubmit(newSection);
        context.SubmitChanges();
        txtSectionActive.Checked = true;
        txtSectionDescription.Text = "";
        txtSectionName.Text = "";
        grdSections.DataBind();
    }
    protected void butUpdateSection_Click(object sender, EventArgs e)
    {
        Button submitButton = sender as Button;
        int formSectionId = Convert.ToInt32(submitButton.CommandArgument);
        TextBox thisName = submitButton.Parent.FindControl("txtEditName") as TextBox;
        TextBox thisDescription = submitButton.Parent.FindControl("txtEditDescription") as TextBox;
        CheckBox thisActive = submitButton.Parent.FindControl("chkEditActive") as CheckBox;
        CheckBox thisFirstPage = submitButton.Parent.FindControl("chkEditFirstPage") as CheckBox;
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection updateSection = context.FormSections.Single(n => n.FormSectionID == formSectionId);
        updateSection.SectionName = thisName.Text;
        updateSection.Description = thisDescription.Text;
        updateSection.Active = thisActive.Checked;
        if (thisFirstPage.Checked)
        {
            IQueryable<FormSection> clearSections = context.FormSections.Where(n => n.FirstPage == true && n.FormID == updateSection.FormID);
            foreach (FormSection section in clearSections)
            {
                if (section.FormSectionID != updateSection.FormSectionID)
                {
                    section.FirstPage = false;
                }
            }
        }
        updateSection.FirstPage = thisFirstPage.Checked;
        context.SubmitChanges();
        grdSections.DataBind();
    }
    protected void butSubmit_Click(object sender, EventArgs e)
    {
        int formId = Convert.ToInt32(Request.QueryString["formid"]);
        DataClassesDataContext context = new DataClassesDataContext();
        Form updateForm = context.Forms.Single(n => n.FormID == formId);
        updateForm.Name = txtName.Text;
        updateForm.Description = txtDescription.Text;
        updateForm.Active = chkActive.Checked;
        context.SubmitChanges();
        lblMessage.Text = "Form Updated Successfully";
    }
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        LinkButton delButton = sender as LinkButton;
        int formSectionId = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection delSection = context.FormSections.Single(n => n.FormSectionID == formSectionId);
        
        IQueryable<FormSection> shiftSections = context.FormSections.Where(n => n.FormID == delSection.FormID && n.SortOrder > delSection.SortOrder);
        foreach (FormSection currentSection in shiftSections)
        {
            currentSection.SortOrder--;
        }
        
        context.FormFields.DeleteAllOnSubmit(context.FormFields.Where(n => n.FormSectionID == formSectionId));
        context.FormSections.DeleteOnSubmit(delSection);
        context.SubmitChanges();
        grdSections.DataBind();
    }
    protected void butCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
    protected void butManager_Click(object sender, EventArgs e)
    {
        Response.Redirect("ManageForm.aspx?formid=" + Request.QueryString["formid"]);
    }
    protected void lnkMoveUp_Click(object sender, EventArgs e)
    {
        LinkButton upButton = sender as LinkButton;
        int formSectionId = Convert.ToInt32(upButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection upSection = context.FormSections.Single(n => n.FormSectionID == formSectionId);
        FormSection downSection = context.FormSections.Single(n => n.FormID == upSection.FormID && n.SortOrder == upSection.SortOrder - 1);
        upSection.SortOrder--;
        downSection.SortOrder++;

        context.SubmitChanges();
        grdSections.DataBind();
    }
    protected void lnkMoveDown_Click(object sender, EventArgs e)
    {
        LinkButton downButton = sender as LinkButton;
        int formSectionId = Convert.ToInt32(downButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection downSection = context.FormSections.Single(n => n.FormSectionID == formSectionId);
        FormSection upSection = context.FormSections.Single(n => n.FormID == downSection.FormID && n.SortOrder == downSection.SortOrder + 1);
        upSection.SortOrder--;
        downSection.SortOrder++;

        context.SubmitChanges();
        grdSections.DataBind();
    }
    protected int GetMaxSortOrder()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.FormSections.Where(n => n.FormID == Convert.ToInt32(Request.QueryString["formid"])).Max(n => n.SortOrder);
    }
}
