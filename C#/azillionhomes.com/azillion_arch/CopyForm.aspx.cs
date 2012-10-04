using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CopyForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Form oldForm = context.Forms.Single(n => n.FormID == Convert.ToInt32(TextBox1.Text));
        Form newForm = context.Forms.Single(n => n.FormID == Convert.ToInt32(TextBox2.Text));

        foreach (FormSection section in oldForm.FormSections)
        {
            FormSection newSection = new FormSection
            {
                Active = section.Active,
                Description = section.Description,
                FirstPage = section.FirstPage,
                FormID = newForm.FormID,
                SectionName = section.SectionName,
                SortOrder = section.SortOrder
            };

            Response.Write("<h2>SECTION CREATED: " + newSection.SectionName + "</h2>");

            context.FormSections.InsertOnSubmit(newSection);
            context.SubmitChanges();

            foreach (FormField field in section.FormFields)
            {
                FormField newField = new FormField
                {
                    AllowedValues = field.AllowedValues,
                    DefaultValue = field.DefaultValue,
                    FieldTypeID = field.FieldTypeID,
                    FormSectionID = newSection.FormSectionID,
                    Name = field.Name,
                    Regex = field.Regex,
                    Required = field.Required,
                    SortOrder = field.SortOrder,
                    ToolTip = field.ToolTip
                };
                context.FormFields.InsertOnSubmit(newField);
                Response.Write("<h4>Field Added: " + newField.Name + "</h4>");
            }
            context.SubmitChanges();
            
        }
    }
}
