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

public partial class control_forms_ManageForm : AZHCore.AZHPage 
{

    public int MaxSortOrder
    {
        get
        {
            DataClassesDataContext context = new DataClassesDataContext();
            int retVal = context.FormFields.Where(n => n.FormSectionID == Convert.ToInt32(grdSections.SelectedDataKey.Value)).OrderByDescending(n => n.SortOrder).First().SortOrder;
            return retVal;
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void grdSections_SelectedIndexChanged(object sender, EventArgs e)
    {
        addEditor.FormSectionID = (int)((GridView)sender).SelectedDataKey.Value;
        butAddField.Enabled = true;
        rptFields.DataBind();
    }

    protected void butMoveUp_Click(object sender, EventArgs e)
    {
        Button upButton = sender as Button;
        int formFieldId = Convert.ToInt32(upButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormField upField = context.FormFields.Single(n => n.FormFieldID == formFieldId);
        FormField downField = context.FormFields.Where(n => n.FormSectionID == upField.FormSectionID && n.SortOrder < upField.SortOrder).OrderByDescending(n => n.SortOrder).First();
        upField.SortOrder = downField.SortOrder;
        downField.SortOrder++;
        context.SubmitChanges();
        rptFields.DataBind();
    }

    protected void butMoveDown_Click(object sender, EventArgs e)
    {
        Button upButton = sender as Button;
        int formFieldId = Convert.ToInt32(upButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormField downField = context.FormFields.Single(n => n.FormFieldID == formFieldId);
        FormField upField = context.FormFields.Single(n => n.FormSectionID == downField.FormSectionID && n.SortOrder == downField.SortOrder + 1);
        upField.SortOrder--;
        downField.SortOrder++;
        context.SubmitChanges();
        rptFields.DataBind();
    }

    protected void butEdit_Click(object sender, EventArgs e)
    {
        Button editButton = sender as Button;
        int formFieldId = Convert.ToInt32(editButton.CommandArgument);
        addEditor.ActivateEditor(formFieldId);
    }

    protected void butDelete_Click(object sender, EventArgs e)
    {
        Button deleteButton = sender as Button;
        int formFieldId = Convert.ToInt32(deleteButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        FormField delField = context.FormFields.Single(n => n.FormFieldID == formFieldId);
        context.FormFields.DeleteOnSubmit(delField);
        IQueryable<FormField> shiftFields = context.FormFields.Where(n => n.FormSectionID == delField.FormSectionID && n.SortOrder > delField.SortOrder);
        foreach (FormField field in shiftFields)
        {
            field.SortOrder--;
        }
        context.SubmitChanges();
        rptFields.DataBind();
    }

    protected void butAddField_Click(object sender, EventArgs e)
    {
        addEditor.ActivateEditor();
    }
    protected void addEditor_FieldAdded(object sender, EventArgs e)
    {
        rptFields.DataBind();
    }
    protected void butReturn_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
    protected bool CheckMoveDown(int sortOrder, object sender)
    {
        return sortOrder < MaxSortOrder;
    }
    protected string GetFieldType(object sender)
    {
        return ((FieldType)sender).Name;
    }
}
