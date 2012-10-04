using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class App_Controls_MultiDate : System.Web.UI.UserControl
{
    public List<DateTime> Dates
    {
        get
        {
            if (ViewState["Dates"] != null)
            {
                return (List<DateTime>)ViewState["Dates"];
            }
            else
            {
                return new List<DateTime>();
            }
        }
        set { ViewState["Dates"] = value; }
    }

    public bool Dirty
    {
        get
        {
            if (ViewState["Dirty"] != null)
            {
                return (bool)ViewState["Dirty"];
            }
            else
            {
                return true;
            }
        }
        set { ViewState["Dirty"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        int fieldIndex = 1;
        if (Dates.Count > 0)
        {
            foreach (DateTime date in Dates)
            {
                AZHControls.AZHField field = FindControl("txtDate" + fieldIndex.ToString()) as AZHControls.AZHField;
                field.Value = date.ToShortDateString();
                fieldIndex++;
            }
        }
    }

    public List<DateTime> GetValue()
    {
        return Dates;
    }
    protected void txtDate_ValueChanged(object sender, EventArgs e)
    {
        if (Dirty)
        {
            Dates = new List<DateTime>();
            Dirty = false;
        }
        AZHControls.AZHField txtDateBox = sender as AZHControls.AZHField;
        DateTime thisDate = DateTime.Parse(txtDateBox.GetFieldValue());
        Dates.Add(thisDate);
    }
}
