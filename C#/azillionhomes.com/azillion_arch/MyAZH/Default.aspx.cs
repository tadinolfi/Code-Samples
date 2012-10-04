using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.IsSecureConnection)
        {
            Response.Redirect("http://www.azillionhomes.com/myazh/Default.aspx");
        }
    }

    protected string ConvertDate(DateTime dateToConvert)
    {
        string returnDate;
        returnDate = dateToConvert.Month < 10 ? "0" + dateToConvert.Month.ToString() : dateToConvert.Month.ToString();
        returnDate += "." + (dateToConvert.Day < 10 ? "0" + dateToConvert.Day.ToString() : dateToConvert.Day.ToString());
        returnDate += "." + dateToConvert.Year.ToString().Substring(2);
        return returnDate;
    }
}
