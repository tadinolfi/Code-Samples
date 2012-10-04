using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PrintListing : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["postingid"]))
        {
            mainPosting.FormEntryID = Convert.ToInt32(Request.QueryString["postingid"]);
        }
    }
}
