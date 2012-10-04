using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_PreviewPosting : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        previewPost.FormEntryID = (int)Session["formEntryId"];
    }
}
