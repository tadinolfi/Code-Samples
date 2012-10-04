using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using AjaxControlToolkit;

public partial class myazh_MyAccount : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["azhuserid"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
        AdminSection = AZHCore.AZHSection.MyAccount;
        if (!IsPostBack)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
            lblCell.Text = currentUser.CellPhone;
            txtCell.Text = currentUser.CellPhone;
            ddlCellProvider.SelectedValue = currentUser.CellPhoneProviderID.ToString();
            lblCity.Text = currentUser.City;
            txtCity.Text = currentUser.City;
            if (currentUser.AgencyID > 0)
            {
                lblCompany.Text = context.Agencies.SingleOrDefault(n => n.AgencyID == currentUser.AgencyID).Name;
                txtCompanyName.Text = lblCompany.Text;
                txtCompanyName.Enabled = false;
            }
            else
            {
                lblCompany.Text = currentUser.Company;
                txtCompanyName.Text = currentUser.Company;
            }
            lblName.Text = currentUser.FirstName + " " + currentUser.LastName;
            txtFirstName.Text = currentUser.FirstName;
            txtLastName.Text = currentUser.LastName;
            lblEmail.Text = currentUser.Email;
            txtEmail.Text = currentUser.Email;
            lblPhone.Text = currentUser.Phone;
            txtPhone.Text = currentUser.Phone;
            if(currentUser.StateID > 0)
                lblState.Text = currentUser.State.Abbreviation;
            ddlState.DataBind();
            ddlState.SelectedValue = currentUser.StateID.ToString();
            lblStreet.Text = currentUser.Address;
            txtAddress.Text = currentUser.Address;
            lblZip.Text = currentUser.ZipCode;
            txtZip.Text = currentUser.ZipCode;

            if (currentUser.Subscriptions.Count > 0)
            {
                Subscription currentSubscription = currentUser.Subscriptions.OrderByDescending(n => n.Expires).FirstOrDefault();
                if (currentSubscription.Expires > DateTime.Now)
                {
                    lblExpire.Text = currentSubscription.Expires.ToShortDateString();
                    lblRate.Text = "$" + currentSubscription.SubscriptionType.BillingAmount.ToString();
                    lblStart.Text = currentSubscription.Created.ToShortDateString();
                }
            }
            else
            {
                pnlHasSubscription.Visible = false;
                pnlNoSubscription.Visible = true;
            }

            if (currentUser.AgencyID > 0)
            {
                Agency userAgency = context.Agencies.Single(n => n.AgencyID == currentUser.AgencyID);
                pnlAgencyUser.Visible = true;
                lblAgencyName.Text = userAgency.Name;
                litAgencyAddress.Text = userAgency.Address1 + "<br />";
                if (!string.IsNullOrEmpty(userAgency.Address2))
                    litAgencyAddress.Text += userAgency.Address2 + "<br />";
                litAgencyAddress.Text += userAgency.City + ", " + userAgency.State.Abbreviation + " " + userAgency.ZipCode + "<br />";
                litAgencyAddress.Text += userAgency.Phone + "<br />";
                litAgencyAddress.Text += userAgency.Website;

                if (userAgency.OwnerUserInfoID == currentUser.UserInfoID)
                {
                    pnlAgencyOwner.Visible = true;

                    txtAgencyAddress1.Text = userAgency.Address1;
                    txtAgencyAddress2.Text = userAgency.Address2;
                    txtAgencyCity.Text = userAgency.City;
                    txtAgencyDescription.Text = userAgency.Description;
                    txtAgencyEmail.Text = userAgency.Email;
                    txtAgencyFax.Text = userAgency.Fax;
                    txtAgencyName.Text = userAgency.Name;
                    txtAgencyPhone.Text = userAgency.Phone;
                    txtAgencyWebsite.Text = userAgency.Website;
                    txtAgencyZip.Text = userAgency.ZipCode;
                    ddlAgencyState.SelectedValue = userAgency.StateID.ToString();
                    lblInvitationCode.Text = userAgency.InvitationCode;

                    txtAddAddress.Text = userAgency.Address1;
                    txtAddCity.Text = userAgency.City;
                    txtAddPhone.Text = userAgency.Phone;
                    txtAddZip.Text = userAgency.ZipCode;
                    ddlAddState.SelectedValue = userAgency.StateID.ToString();

                    IQueryable<UserInfo> agencyUsers = context.UserInfos.Where(n => n.AgencyID == userAgency.AgencyID);
                    grdAgencyUsers.DataSource = agencyUsers;
                    grdAgencyUsers.DataBind();
                }
                else
                {
                    pnlAgencyEditor.Visible = false;
                }
            }
            else
            {
                pnlNoAgency.Visible = true;
            }
        }
    }
    protected void PostingDataSource_Selecting(object sender, LinqDataSourceSelectEventArgs e)
    {
        e.Arguments.MaximumRows = 3;
    }
    protected void lnkSearch_Click(object sender, EventArgs e)
    {
        LinkButton searchButton = sender as LinkButton;
        string searchString = searchButton.CommandArgument;
        Session["currentsearch"] = searchString;
        string searchType = searchString.Substring(0, 1);
        switch (searchType)
        {
            case "1":
                Response.Redirect("~/rentals/");
                break;
            case "2":
                Response.Redirect("~/sales/");
                break;
            case "3":
                Response.Redirect("~/openhouses/");
                break;
            case "4":
                Response.Redirect("~/auctions/");
                break;
        }

    }
    protected void butEdit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo editUser = context.UserInfos.Single(n => n.UserInfoID == (int)Session["azhuserid"]);
            editUser.Address = txtAddress.Text;
            editUser.CellPhone = txtCell.Text;
            editUser.City = txtCity.Text;
            editUser.Company = txtCompanyName.Text;
            editUser.Email = txtEmail.Text;
            editUser.FirstName = txtFirstName.Text;
            editUser.LastName = txtLastName.Text;
            editUser.Phone = txtPhone.Text;
            editUser.StateID = Convert.ToInt32(ddlState.SelectedValue);
            editUser.ZipCode = txtZip.Text;
            context.SubmitChanges();

            lblCell.Text = editUser.CellPhone;
            lblCity.Text = editUser.City;
            lblName.Text = editUser.FirstName + " " + editUser.LastName;
            lblPhone.Text = editUser.Phone;
            lblState.Text = editUser.State.Abbreviation;
            lblStreet.Text = editUser.Address;
            lblZip.Text = editUser.ZipCode;
        }
        else
        {
            ModalPopupExtender1.Show();
        }
    }
    protected void butAgencySave_Click(object sender, EventArgs e)
    {
        int currentUserID = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == currentUserID);
        string invitationCode = Guid.NewGuid().ToString().Substring(0, 10);
        while (context.Agencies.Where(n => n.InvitationCode == invitationCode).Count() > 0)
        {
            invitationCode = Guid.NewGuid().ToString().Substring(0, 10);
        }
        if (currentUser.AgencyID > 0)
        {
            //Edit Agency
            Agency editAgency = context.Agencies.Single(n => n.AgencyID == currentUser.AgencyID);
            editAgency.Address1 = txtAgencyAddress1.Text;
            editAgency.Address2 = txtAgencyAddress2.Text;
            editAgency.City = txtAgencyCity.Text;
            editAgency.Description = txtAgencyDescription.Text;
            editAgency.Email = txtAgencyEmail.Text;
            editAgency.Fax = txtAgencyFax.Text;
            editAgency.Name = txtAgencyName.Text;
            editAgency.Phone = txtAgencyPhone.Text;
            editAgency.StateID = Convert.ToInt32(ddlAgencyState.SelectedValue);
            editAgency.Website = txtAgencyWebsite.Text;
            editAgency.ZipCode = txtAgencyZip.Text;
            context.SubmitChanges();

            txtAgencyAddress1.Text = editAgency.Address1;
            txtAgencyAddress2.Text = editAgency.Address2;
            txtAgencyCity.Text = editAgency.City;
            txtAgencyDescription.Text = editAgency.Description;
            txtAgencyEmail.Text = editAgency.Email;
            txtAgencyFax.Text = editAgency.Fax;
            txtAgencyName.Text = editAgency.Name;
            txtAgencyPhone.Text = editAgency.Phone;
            txtAgencyWebsite.Text = editAgency.Website;
            txtAgencyZip.Text = editAgency.ZipCode;
            ddlAgencyState.SelectedValue = editAgency.StateID.ToString();
            lblInvitationCode.Text = editAgency.InvitationCode;

            litAgencyAddress.Text = editAgency.Address1 + "<br />";
            if (!string.IsNullOrEmpty(editAgency.Address2))
                litAgencyAddress.Text += editAgency.Address2 + "<br />";
            litAgencyAddress.Text += editAgency.City + ", " + editAgency.State.Abbreviation + " " + editAgency.ZipCode + "<br />";
            litAgencyAddress.Text += editAgency.Phone + "<br />";
            litAgencyAddress.Text += editAgency.Website;
            lblAgencyName.Text = editAgency.Name;

        }
        else
        {
            //Create Agency
            Agency newAgency = new Agency
            {
                Address1 = txtAgencyAddress1.Text,
                Address2 = txtAgencyAddress2.Text,
                City = txtAgencyCity.Text,
                Description = txtAgencyDescription.Text,
                Email = txtAgencyEmail.Text,
                Fax = txtAgencyFax.Text,
                InvitationCode = invitationCode,
                Name = txtAgencyName.Text,
                OwnerUserInfoID = currentUser.UserInfoID,
                Phone = txtAgencyPhone.Text,
                StateID = Convert.ToInt32(ddlAgencyState.SelectedValue),
                Website = txtAgencyWebsite.Text,
                ZipCode = txtAgencyZip.Text
            };
            context.Agencies.InsertOnSubmit(newAgency);
            context.SubmitChanges();
            currentUser.AgencyID = newAgency.AgencyID;
            context.SubmitChanges();
            

            txtAgencyAddress1.Text = newAgency.Address1;
            txtAgencyAddress2.Text = newAgency.Address2;
            txtAgencyCity.Text = newAgency.City;
            txtAgencyDescription.Text = newAgency.Description;
            txtAgencyEmail.Text = newAgency.Email;
            txtAgencyFax.Text = newAgency.Fax;
            txtAgencyName.Text = newAgency.Name;
            txtAgencyPhone.Text = newAgency.Phone;
            txtAgencyWebsite.Text = newAgency.Website;
            txtAgencyZip.Text = newAgency.ZipCode;
            ddlAgencyState.SelectedValue = newAgency.StateID.ToString();
            lblInvitationCode.Text = newAgency.InvitationCode;

            litAgencyAddress.Text = newAgency.Address1 + "<br />";
            if (!string.IsNullOrEmpty(newAgency.Address2))
                litAgencyAddress.Text += newAgency.Address2 + "<br />";
            litAgencyAddress.Text += newAgency.City + ", " + newAgency.State.Abbreviation + " " + newAgency.ZipCode + "<br />";
            litAgencyAddress.Text += newAgency.Phone + "<br />";
            litAgencyAddress.Text += newAgency.Website;
            lblAgencyName.Text = newAgency.Name;

            pnlAgencyOwner.Visible = true;
            pnlAgencyUser.Visible = true;
            pnlNoAgency.Visible = false;
        }

    }
    protected void butAddUser_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        int userId = (int)Session["azhuserid"];
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
        UserInfo newUser = new UserInfo
        {
            Active = true,
            Address = txtAddAddress.Text,
            AgencyID = currentUser.AgencyID,
            CellPhone = txtAddCellPhone.Text,
            City = txtAddCity.Text,
            ConfimCode = Guid.NewGuid().ToString().Substring(0, 10),
            Created = DateTime.Now,
            Email = txtAddEmail.Text,
            FirstName = txtAddFirstName.Text,
            LastLogin = DateTime.Now,
            LastName = txtAddLastName.Text,
            Login = txtAddEmail.Text,
            Password = FormsAuthentication.HashPasswordForStoringInConfigFile(txtAddPassword.Text, "SHA1"),
            Phone = "",
            SecurityAnswer = "",
            SecurityQuestion = "",
            StateID = Convert.ToInt32(ddlAddState.SelectedValue),
            UserTypeID = 1,
            ZipCode = txtAddZip.Text
        };
        context.UserInfos.InsertOnSubmit(newUser);
        context.SubmitChanges();
        grdAgencyUsers.DataSource = context.UserInfos.Where(n => n.AgencyID == currentUser.AgencyID);
        grdAgencyUsers.DataBind();
    }
    protected void butRemoveUser_Click(object sender, EventArgs e)
    {
        LinkButton lnkRemove = sender as LinkButton;
        int userId = Convert.ToInt32(lnkRemove.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
        currentUser.AgencyID = 0;
        context.SubmitChanges();
        grdAgencyUsers.DataBind();
    }
    protected void butInvite_Click(object sender, EventArgs e)
    {
        int userId = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(n => n.UserInfoID == userId);
        string inviteMessage = "You have been invited to join A Zillion homes as an agent for " + currentUser.Agencies.First().Name + ". The link below will allow you to sign up with this agency.";
        EmailSender mailSender = new EmailSender
        {
            FromAddress = currentUser.Email,
            MessageBody = inviteMessage,
            MessageUrl = "http://www.azillionhomes.com/Signup.aspx?code=" + currentUser.Agencies.First().InvitationCode,
            Subject = "An invitation from " + currentUser.Agencies.First().Name,
            TemplateFile = Server.MapPath("~/App_Data/InviteEmail.txt"),
            ToAddress = txtInviteEmail.Text
        };

        mailSender.SendEmail();
        lblInviteMessage.Text = "The invitation has been sent";
    }
    protected void butEditUser_Click(object sender, EventArgs e)
    {
        Button editButton = sender as Button;
        int userId = Convert.ToInt32(editButton.CommandArgument);
        if (Page.IsValid)
        {
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo editUser = context.UserInfos.Single(n => n.UserInfoID == userId);
            TextBox txtEditFirstName = editButton.Parent.FindControl("txtEditFirstName") as TextBox;
            TextBox txtEditLastName = editButton.Parent.FindControl("txtEditLastName") as TextBox;
            TextBox txtEditEmail = editButton.Parent.FindControl("txtEditEmail") as TextBox;
            TextBox txtEditPhone = editButton.Parent.FindControl("txtEditPhone") as TextBox;
            TextBox txtEditCellPhone = editButton.Parent.FindControl("txtEditCellPhone") as TextBox;
            TextBox txtEditAddress = editButton.Parent.FindControl("txtEditAddress") as TextBox;
            TextBox txtEditCity = editButton.Parent.FindControl("txtEditCity") as TextBox;
            DropDownList ddlEditState = editButton.Parent.FindControl("ddlEditState") as DropDownList;
            TextBox txtEditZip = editButton.Parent.FindControl("txtEditZip") as TextBox;

            editUser.Address = txtEditAddress.Text;
            editUser.CellPhone = txtEditCellPhone.Text;
            editUser.City = txtEditCity.Text;
            editUser.Email = txtEditEmail.Text;
            editUser.FirstName = txtEditFirstName.Text;
            editUser.LastName = txtEditLastName.Text;
            editUser.Login = txtEditEmail.Text;
            editUser.Phone = txtEditPhone.Text;
            editUser.StateID = Convert.ToInt32(ddlEditState.SelectedValue);
            editUser.ZipCode = txtZip.Text;

            context.SubmitChanges();
        }
        else
        {
            ModalPopupExtender modal = editButton.Parent.FindControl("popEditUser") as ModalPopupExtender;
            modal.Show();
        }
    }
    protected void lnkUserSubscription_Click(object sender, EventArgs e)
    {
        LinkButton subButton = sender as LinkButton;
        Response.Redirect("CreateSubscription.aspx?UserInfoId=" + subButton.CommandArgument);
    }
    protected void cusEmail_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string checkEmail = args.Value;
        int currentUserId = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(u => u.UserInfoID == currentUserId);
        if (currentUser.Email == checkEmail)
            return;
        int checkCount = context.UserInfos.Where(u => u.Email == checkEmail && u.UserInfoID != currentUserId).Count();
        if (checkCount > 0)
            args.IsValid = false;
    }
    protected void cusAddEmail_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string checkEmail = args.Value;
        int currentUserId = (int)Session["azhuserid"];
        DataClassesDataContext context = new DataClassesDataContext();
        int checkCount = context.UserInfos.Where(u => u.Email == checkEmail && u.UserInfoID != currentUserId).Count();
        if (checkCount > 0)
            args.IsValid = false;
    }
    protected void cusEditEmail_validate(object source, ServerValidateEventArgs args)
    {
        BaseValidator validator = source as BaseValidator;
        string checkEmail = args.Value;
        int currentUserId = Convert.ToInt32(((Button)validator.Parent.FindControl("butEditUser")).CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo currentUser = context.UserInfos.Single(u => u.UserInfoID == currentUserId);
        if (currentUser.Email == checkEmail)
            return;
        int checkCount = context.UserInfos.Where(u => u.Email == checkEmail && u.UserInfoID != currentUserId).Count();
        if (checkCount > 0)
            args.IsValid = false;
    }
}
