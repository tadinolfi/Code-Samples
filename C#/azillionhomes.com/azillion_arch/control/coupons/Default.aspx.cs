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

public partial class control_coupons_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Guid codeGen = Guid.NewGuid();
            string checkCode = "";
            int checkCount = 1;
            DataClassesDataContext context = new DataClassesDataContext();
            while (checkCount > 0)
            {
                checkCode = codeGen.ToString().Substring(0, 6);
                IQueryable<Coupon> couponList = context.Coupons.Where(n => n.CouponCode == checkCode);
                checkCount = couponList.Count();
            }
            txtAddCode.Text = checkCode;
        }
    }
    protected void butAdd_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Coupon newCoupon = new Coupon { CouponAmount = Convert.ToInt32(txtAmount.Text), CouponCode = txtAddCode.Text, CouponType = ddlType.SelectedValue, Description = txtDescription.Text, Name = txtAddName.Text, TotalUses = Convert.ToInt32(txtUses.Text), Used = 0 };
        if (!string.IsNullOrEmpty(txtAddExpires.Text))
            newCoupon.Expires = DateTime.Parse(txtAddExpires.Text);
        context.Coupons.InsertOnSubmit(newCoupon);
        context.SubmitChanges();
        grdCoupons.DataBind();
        txtAddCode.Text = "";
        Guid codeGen = Guid.NewGuid();
        string checkCode = "";
        int checkCount = 1;
        while (checkCount > 0)
        {
            checkCode = codeGen.ToString().Substring(0, 6);
            IQueryable<Coupon> couponList = context.Coupons.Where(n => n.CouponCode == checkCode);
            checkCount = couponList.Count();
        }
        txtAddCode.Text = checkCode;
        txtAddExpires.Text = "";
        txtAddName.Text = "";
        txtAmount.Text = "";
        txtDescription.Text = "";
        txtUses.Text = "0";
    }
    protected void butEdit_Click(object sender, EventArgs e)
    {
        if (IsValid)
        {
            Button editButton = sender as Button;
            int couponId = Convert.ToInt32(editButton.CommandArgument);
            DataClassesDataContext context = new DataClassesDataContext();
            Coupon editCoupon = context.Coupons.Single(n => n.CouponID == couponId);
            TextBox txtEditName = editButton.Parent.FindControl("txtEditName") as TextBox;
            TextBox txtEditCoupon = editButton.Parent.FindControl("txtEditButton") as TextBox;
            TextBox txtEditDescription = editButton.Parent.FindControl("txtEditDescription") as TextBox;
            TextBox txtEditCode = editButton.Parent.FindControl("txtEditCode") as TextBox;
            DropDownList ddlEditType = editButton.Parent.FindControl("ddlEditType") as DropDownList;
            TextBox txtEditAmount = editButton.Parent.FindControl("txtEditAmount") as TextBox;
            TextBox txtEditUses = editButton.Parent.FindControl("txtEditUses") as TextBox;
            TextBox txtEditExpires = editButton.Parent.FindControl("txtExpires") as TextBox;

            editCoupon.CouponAmount = Convert.ToInt32(txtEditAmount.Text);
            editCoupon.CouponCode = txtEditCode.Text;
            editCoupon.CouponType = ddlEditType.SelectedValue;
            editCoupon.Description = txtEditDescription.Text;
            editCoupon.Name = txtEditName.Text;
            editCoupon.TotalUses = Convert.ToInt32(txtEditUses.Text);
            if (!string.IsNullOrEmpty(txtEditExpires.Text))
            {
                editCoupon.Expires = DateTime.Parse(txtEditExpires.Text);
            }
            else
            {
                editCoupon.Expires = null;
            }

            context.SubmitChanges();
            grdCoupons.DataBind();
        }
        else
        {

        }
    }
    protected void lnkReset_Click(object sender, EventArgs e)
    {
        LinkButton resetButton = sender as LinkButton;
        int couponId = Convert.ToInt32(resetButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        Coupon resetCoupon = context.Coupons.Single(n => n.CouponID == couponId);
        resetCoupon.Used = 0;
        context.SubmitChanges();
        lblMessage.Text = "The " + resetCoupon.Name + " coupon has been reset.";
    }
    protected string GetDate(object PossibleDate)
    {
        if (PossibleDate == null)
        {
            return "";
        }
        else
        {
            return PossibleDate.ToString().Replace(" 12:00:00 AM", "");
        }
    }
    protected void butYes_Click(object sender, EventArgs e)
    {
        Button delButton = sender as Button;
        int couponId = Convert.ToInt32(delButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        context.Coupons.DeleteOnSubmit(context.Coupons.Single(c => c.CouponID == couponId));
        context.SubmitChanges();
        grdCoupons.DataBind();
    }
}
