using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class myazh_ChoosePostingType : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        Session.Remove("formentryid");
        AdminSection = AZHCore.AZHSection.MyPosting;
        ShowSearch = false;
        DataClassesDataContext context = new DataClassesDataContext();
        if (!IsPostBack)
        {
            var form1Types = context.FormListingTypes.Where(n => n.ListingTypeID == 1).Join(context.Forms, o => o.FormID, i => i.FormID, (i, o) => new { id = o.FormID, name = o.Name });
            ddl1.DataSource = form1Types;
            ddl1.DataTextField = "name";
            ddl1.DataValueField = "id";
            ddl1.DataBind();

            var form2Types = context.FormListingTypes.Where(n => n.ListingTypeID == 2).Join(context.Forms, o => o.FormID, i => i.FormID, (i, o) => new { id = o.FormID, name = o.Name });
            ddl2.DataSource = form2Types;
            ddl2.DataTextField = "name";
            ddl2.DataValueField = "id";
            ddl2.DataBind();

            var form3Types = context.FormListingTypes.Where(n => n.ListingTypeID == 3).Join(context.Forms, o => o.FormID, i => i.FormID, (i, o) => new { id = o.FormID, name = o.Name });
            ddl3.DataSource = form3Types;
            ddl3.DataTextField = "name";
            ddl3.DataValueField = "id";
            ddl3.DataBind();

            var form4Types = context.FormListingTypes.Where(n => n.ListingTypeID == 4).Join(context.Forms, o => o.FormID, i => i.FormID, (i, o) => new { id = o.FormID, name = o.Name });
            ddl4.DataSource = form4Types;
            ddl4.DataTextField = "name";
            ddl4.DataValueField = "id";
            ddl4.DataBind();
        }
    }
    protected void lnkPosting_Click(object sender, EventArgs e)
    {
        LinkButton lnkForward = sender as LinkButton;
        int listingTypeID = Convert.ToInt32(lnkForward.CommandArgument);
        Session.Add("listingTypeID", listingTypeID);
        DropDownList postingType = lnkForward.Parent.FindControl("ddl" + listingTypeID.ToString()) as DropDownList;
        Session.Add("editPostingType", postingType.SelectedValue);
        Response.Redirect("PostingInfo.aspx");
    }
}
