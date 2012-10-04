using System;
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
using Telerik;
using Telerik.Web;
using Telerik.Web.UI;

public partial class _Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        pnlAuctions.Visible = false;
        pnlOpenHouses.Visible = false;
        pnlRentals.Visible = false;
        pnlSales.Visible = false;
        Session.Remove("currentsearch");
    }

    protected void lnkRentals_Click(object sender, EventArgs e)
    {
        pnlRentals.Visible = true;
    }

    protected void lnkSales_Click(object sender, EventArgs e)
    {
        pnlSales.Visible = true;
    }
    protected void lnkOpenHouses_Click(object sender, EventArgs e)
    {
        pnlOpenHouses.Visible = true;
    }
    protected void lnkAuctions_Click(object sender, EventArgs e)
    {
        pnlAuctions.Visible = true;
    }
}
