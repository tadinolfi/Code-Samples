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
using System.Collections.Generic;

public partial class App_Controls_FormFieldEditor : System.Web.UI.UserControl
{
    public int FormSectionID
    {
        get
        {
            if (ViewState["FormSectionID"] != null)
            {
                return (int)ViewState["FormSectionID"];
            }
            else
            {
                return 0;
            }
        }
        set { ViewState["FormSectionID"] = value;}
    }
    public string ListValues
    {
        get
        {
            if (ViewState["ListValues"] != null)
            {
                return (string)ViewState["ListValues"];
            }
            else
            {
                return string.Empty;
            }
        }
        set { ViewState["ListValues"] = value; }
    }
    public string DefaultValue
    {
        get
        {
            if (ViewState["DefaultValue"] != null)
            {
                return (string)ViewState["DefaultValue"];
            }
            else
            {
                return string.Empty;
            }
        }
        set { ViewState["DefaultValue"] = value; }
    }
    public int FormFieldID
    {
        get
        {
            if (ViewState["FormFieldID"] != null)
            {
                return (int)ViewState["FormFieldID"];
            }
            else
            {
                return 0;
            }
        }
        set { ViewState["FormFieldID"] = value; }
    }
    public string Suffix
    {
        get
        {
            if (ViewState["Suffix"] != null)
            {
                return (string)ViewState["Suffix"];
            }
            else
            {
                return string.Empty;
            }
        }
        set { ViewState["Suffix"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(ListValues))
        {
            BuildListValues();
        }
        if (!IsPostBack && FormFieldID != 0)
        {
            UpdateFormData();
        }
    }

    public event EventHandler FieldAdded;

    protected virtual void OnFieldAdded(EventArgs e)
    {
        if (FieldAdded != null)
            FieldAdded(this, e);
    }

    protected void UpdateFormData()
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormField currentField = context.FormFields.Single(n => n.FormFieldID == FormFieldID);
        txtAddDefaultValue.Text = currentField.DefaultValue;
        DefaultValue = currentField.DefaultValue;
        txtAddFieldName.Text = currentField.Name;
        txtAddToolTip.Text = currentField.ToolTip;
        txtAddSuffix.Text = currentField.Suffix;
        hidSortOrder.Value = currentField.SortOrder.ToString();
        ddlAddFieldType.DataBind();
        ddlAddFieldType.SelectedValue = currentField.FieldTypeID.ToString();
        chkRequired.Checked = currentField.Required;
        chkSearchable.Checked = currentField.Searchable;
        if (currentField.FieldType.ValueFormat.FormatName.Contains("List"))
        {
            pnlSimpleField.Visible = false;
            pnlList.Visible = true;
            ListValues = currentField.AllowedValues;
            BuildListValues();
        }
        if (currentField.FieldType.ValueFormat.FormatName.Contains("Boolean"))
        {
            if (currentField.FieldTypeID == 12)
            {
                pnlSimpleField.Visible = false;
                pnlYesNo.Visible = true;
                rblYesNo.SelectedValue = currentField.DefaultValue;
            }
            else
            {
                pnlSimpleField.Visible = false;
                pnlBoolean.Visible = true;
                if (currentField.DefaultValue == "True")
                    chkDefault.Checked = true;
            }
        }
        if (currentField.FieldType.ValueFormat.FormatName.Contains("Dimensions") || currentField.FieldType.ValueFormat.FormatName.Contains("Date"))
        {
            pnlSimpleField.Visible = false;
        }
        butAddFormField.Text = "Edit Field";
        formTitle.InnerText = "Edit Field";
    }



    protected void ddlAddFieldType_SelectedIndexChanged(object sender, EventArgs e)
    {
        pnlList.Visible = false;
        pnlSimpleField.Visible = false;
        pnlBoolean.Visible = false;
        pnlYesNo.Visible = false;
        switch (ddlAddFieldType.SelectedValue)
        {
            case "1":
            case "2":
            case "6":
            case "7":
                pnlSimpleField.Visible = true;
                break;
            case "3":
            case "5":
                pnlList.Visible = true;
                break;
            case "4":
                pnlBoolean.Visible = true;
                break;
            case "12":
                pnlYesNo.Visible = true;
                break;
        }
    }
    protected void butAddFormField_Click(object sender, EventArgs e)
    {
        if (FormSectionID == 0)
            throw new Exception("No form section loaded");
        DataClassesDataContext context = new DataClassesDataContext();
        FormField newField;
        if (FormFieldID == 0)
        {
            newField = new FormField();
        }
        else
        {
            newField = context.FormFields.Single(n => n.FormFieldID == FormFieldID);
        }
        newField.FormSectionID = FormSectionID;
        newField.Name = txtAddFieldName.Text;
        int sortOrder = Convert.ToInt32(hidSortOrder.Value);
        if (sortOrder == 0)
        {
            newField.SortOrder = context.FormFields.Where(n => n.FormSectionID == FormSectionID).Count() + 1;
        }
        newField.FieldTypeID = Convert.ToInt32(ddlAddFieldType.SelectedValue);
        newField.Suffix = "";
        switch (ddlAddFieldType.SelectedValue)
        {
            case "1":
            case "2":
            case "6":
            case "7":
                newField.DefaultValue = txtAddDefaultValue.Text;
                newField.AllowedValues = "";
                newField.Suffix = txtAddSuffix.Text;
                break;
            case "3":
            case "5":
                newField.DefaultValue = DefaultValue;
                newField.AllowedValues = ListValues;
                break;
            case "4":
                newField.DefaultValue = chkDefault.Checked.ToString();
                newField.AllowedValues = "";
                break;
            case "10":
            case "11":
            case "13":
                newField.DefaultValue = "";
                newField.AllowedValues = "";
                break;
            case "12":
                newField.DefaultValue = rblYesNo.SelectedValue;
                newField.AllowedValues = "";
                break;
        }
        newField.Required = chkRequired.Checked;
        newField.ToolTip = txtAddToolTip.Text;
        newField.Searchable = chkSearchable.Checked;

        if (FormFieldID == 0)
        {
            context.FormFields.InsertOnSubmit(newField);
            ResetEditor();
        }
        context.SubmitChanges();
        OnFieldAdded(new EventArgs());
        pnlWrapper.Visible = false;
    }

    protected void BuildListValues()
    {
        tblListValues.Controls.Clear();
        string[] valueArray = ListValues.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries);
        foreach (string value in valueArray)
        {
            TableRow newRow = new TableRow();

            TableCell lblCell = new TableCell { Text = value };
            newRow.Cells.Add(lblCell);

            TableCell delCell = new TableCell();
            newRow.Cells.Add(delCell);
            var lnkDelete = new Button { Text = "Delete", CommandArgument = value, CausesValidation = false, ID="delButton" + value };
            lnkDelete.Click += new EventHandler(lnkDelete_Click);
            delCell.Controls.Add(lnkDelete);
            
            TableCell defCell = new TableCell();
            newRow.Cells.Add(defCell);
            var lnkDefault = new Button { Text = "Make Default", CommandArgument = value, CausesValidation = false, ID="defButton" + value };
            lnkDefault.Click += new EventHandler(lnkDefault_Click);
            if (value == DefaultValue)
            {
                lnkDefault.Text = "Default Value";
                lnkDefault.Enabled = false;
            }
            defCell.Controls.Add(lnkDefault);
            tblListValues.Rows.Add(newRow);
        }
    }

    protected void butNewValue_Click(object sender, EventArgs e)
    {
        ListValues += ":" + txtNewValue.Text;
        txtNewValue.Text = "";
        BuildListValues();
    }
    protected void lnkDefault_Click(object sender, EventArgs e)
    {
        Button defButton = sender as Button;
        DefaultValue = defButton.CommandArgument;
        BuildListValues();
    }
    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        Button delButton = sender as Button;
        ListValues = ListValues.Replace(":" + delButton.CommandArgument, "");
        if (delButton.CommandArgument == DefaultValue)
            DefaultValue = string.Empty;
        BuildListValues();
    }
    protected void butOpenModal_Click(object sender, EventArgs e)
    {
        pnlAddField.Visible = true;
    }
    protected void butAddCancel_Click(object sender, EventArgs e)
    {
        pnlWrapper.Visible = false;
    }
    protected void ResetEditor()
    {
        txtAddDefaultValue.Text = "";
        txtAddFieldName.Text = "";
        txtAddToolTip.Text = "";
        ddlAddFieldType.SelectedIndex =0;
        pnlList.Visible = false;
        ListValues = "";
        DefaultValue = "";
        tblListValues.Controls.Clear();
        chkDefault.Checked = false;
        chkRequired.Checked = false;
        pnlBoolean.Visible = false;
        pnlSimpleField.Visible = true;
    }

    public void ActivateEditor()
    {
        if (FormFieldID > 0)
        {
            ResetEditor();
            FormFieldID = 0;
        }
        formTitle.InnerText = "Add Field";
        butAddFormField.Text = "Add Field";
        pnlWrapper.Visible = true;
    }

    public void ActivateEditor(int fieldId)
    {
        if(FormFieldID > 0)
            ResetEditor();
        FormFieldID = fieldId;
        UpdateFormData();
        pnlWrapper.Visible = true;
    }
}
