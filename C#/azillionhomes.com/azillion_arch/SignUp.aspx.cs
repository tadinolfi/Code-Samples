using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class SignUp : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Section = AZHCore.PageSection.SignUp;
        if (!string.IsNullOrEmpty(Request.QueryString["code"]))
        {
            inviteCode.Visible = true;
            txtInvitation.Text = Request.QueryString["code"];
            rblAgent.SelectedIndex = 0;
            txtInvitation_TextChanged(txtInvitation, new EventArgs());
        }
    }
    
    protected void butCreate_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            DataClassesDataContext context = new DataClassesDataContext();
                string confirmCode = Guid.NewGuid().ToString().Substring(0, 10);
                UserInfo newUser = new UserInfo
                {
                    Active = true,
                    Address = txtAddress.Value,
                    AgencyID = Convert.ToInt32(hidAgencyId.Value),
                    CellPhone = txtCellPhone.Value,
                    CellPhoneProviderID = Convert.ToInt32(ddlCellProvider.SelectedValue),
                    City = txtCity.Value,
                    Company = txtCompany.Value,
                    ConfimCode = confirmCode,
                    Created = DateTime.Now,
                    Email = txtEmail.Value,
                    FirstName = txtFirstName.Value,
                    LastName = txtLastName.Value,
                    LastLogin = DateTime.Now,
                    Login = txtEmail.Value,
                    Password = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Value, "SHA1"),
                    Phone = txtPhone.Value,
                    SecurityAnswer = FormsAuthentication.HashPasswordForStoringInConfigFile(txtAnswer.Value, "SHA1"),
                    SecurityQuestion = ddlQuestion.SelectedValue,
                    StateID = Convert.ToInt32(ddlState.SelectedValue),
                    UserTypeID = 1,
                    ZipCode = txtZipCode.Text
                };

                context.UserInfos.InsertOnSubmit(newUser);
                context.SubmitChanges();

                UserAPI.AuthenticateUser(txtEmail.Value, false);

                Response.Redirect("~/myazh/Default.aspx");
        }
        else
        {
            lblMessage.Text = "Please correct the errors above to continue";
        }
    }

    protected void vldEmail_ServerValidate(object source, ServerValidateEventArgs args)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        if (context.UserInfos.Where(n => n.Email == txtEmail.Value).Count() > 0)
        {
            vldEmail.ErrorMessage = "That email address is already being used.";
            args.IsValid = false;
        }
    }
    protected void vldCaptcha_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string captchaVal = (string)Session["CaptchaImageText"];
        if (txtCaptcha.Text != captchaVal)
        {
            args.IsValid = false;
        }
    }
    protected void cusPassword_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (txtPassword.Value.Contains(' '))
            args.IsValid = false;
    }
    protected void txtZipCode_TextChanged(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<Zipcode> zips = context.Zipcodes.Where(n => n.Zipcode1 == txtZipCode.Text);
        if (zips.Count() > 0)
        {
            Zipcode currentZip = zips.First();
            //txtCity.Value = currentZip.City.Trim();
            State zipState = context.States.Single(n => n.Abbreviation == currentZip.Abbreviation.Trim());
            ddlState.SelectedValue = zipState.StateID.ToString();
        }
    }
    protected void rblAgent_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblAgent.SelectedIndex == 0)
        {
            inviteCode.Visible = true;
        }
        else
        {
            inviteCode.Visible = false;
        }
    }
    protected void txtInvitation_TextChanged(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        IQueryable<Agency> inviteAgency = context.Agencies.Where(n => n.InvitationCode == txtInvitation.Text);
        if (inviteAgency.Count() > 0)
        {
            lblInviteMessage.Text = "Agent for " + inviteAgency.First().Name;
            hidAgencyId.Value = inviteAgency.First().AgencyID.ToString();
        }
        else
        {
            lblInviteMessage.Text = "Invalid invitation code";
            hidAgencyId.Value = "0";
        }
    }

    protected void chkTerms_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (!chkTerms.Checked)
            args.IsValid = false;
    }
    
}
