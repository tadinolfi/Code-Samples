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

public partial class control_forms_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void butInsertForm_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Form newForm = new Form();
        FormSection newSection = new FormSection { Active = true, FirstPage = true, Description = "", SectionName = "First Page", SortOrder = 1 };
        newForm.Active = chkActive.Checked;
        newForm.Description = txtDescription.Text;
        newForm.Name = txtName.Text;
        newForm.FormSections.Add(newSection);

        context.Forms.InsertOnSubmit(newForm);
        context.SubmitChanges();
        txtDescription.Text = "";
        txtName.Text = "";
        chkActive.Checked = true;
        GridView1.DataBind();
    }
}
