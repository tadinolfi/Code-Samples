using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.ComponentModel;

/// <summary>
/// Summary description for FormSectionAPI
/// </summary>
/// 
[DataObject]
public class FormSectionAPI
{
    [DataObjectMethodAttribute(DataObjectMethodType.Select)]
    public static IQueryable<FormSection> GetFormSectionsByFormId(int FormID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.FormSections.Where(n => n.FormID == FormID).OrderBy(n => n.SortOrder);
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Select)]
    public static FormSection GetFormSectionById(int FormSectionID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        return context.FormSections.Single(n => n.FormSectionID == FormSectionID);
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Insert)]
    public static int Insert(string SectionName, string Description, bool Active, int FormID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection newSection = new FormSection { SectionName = SectionName, Description = Description, Active = Active, FormID = FormID };
        context.FormSections.InsertOnSubmit(newSection);
        context.SubmitChanges();
        return newSection.FormSectionID;
    }

    [DataObjectMethodAttribute(DataObjectMethodType.Update)]
    public static void Update(string SectionName, string Description, bool Active, int original_FormSectionID)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        FormSection updateSection = context.FormSections.Single(n => n.FormSectionID == original_FormSectionID);
        updateSection.SectionName = SectionName;
        updateSection.Description = Description;
        updateSection.Active = Active;
        context.SubmitChanges();
    }
}
