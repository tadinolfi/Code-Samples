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

public partial class control_users_Default : AZHCore.AZHPage 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void lnkDeactivate_Click(object sender, EventArgs e)
    {
        LinkButton activeButton = sender as LinkButton;
        int userInfoID = Convert.ToInt32(activeButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo activeUser = context.UserInfos.Single(n => n.UserInfoID == userInfoID);
        activeUser.Active = !activeUser.Active;
        context.SubmitChanges();
        GridView1.DataBind();
    }
    protected void butEdit_Click(object sender, EventArgs e)
    {
        Button editButton = sender as Button;
        int userInfoId = Convert.ToInt32(editButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo editUser = context.UserInfos.Single(n => n.UserInfoID == userInfoId);
        DropDownList ddlEditUserType = editButton.Parent.FindControl("ddlUserType") as DropDownList;
        DropDownList ddlEditAgency = editButton.Parent.FindControl("ddlAgency") as DropDownList;
        TextBox txtEditLogin = editButton.Parent.FindControl("txtLogin") as TextBox;
        TextBox txtEditEmail = editButton.Parent.FindControl("txtEmail") as TextBox;
        TextBox txtEditFirstName = editButton.Parent.FindControl("txtFirstName") as TextBox;
        TextBox txtEditLastName = editButton.Parent.FindControl("txtLastName") as TextBox;
        editUser.AgencyID = Convert.ToInt32(ddlEditAgency.SelectedValue);
        editUser.Email = txtEditEmail.Text;
        editUser.FirstName = txtEditFirstName.Text;
        editUser.LastName = txtEditLastName.Text;
        editUser.Login = txtEditLogin.Text;
        editUser.UserTypeID = Convert.ToInt32(ddlEditUserType.SelectedValue);
        context.SubmitChanges();
        GridView1.DataBind();
    }
    protected void butEditSecurity_Click(object sender, EventArgs e)
    {
        Button editButton = sender as Button;
        int userInfoId = Convert.ToInt32(editButton.CommandArgument);
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo editUser = context.UserInfos.Single(n => n.UserInfoID == userInfoId);
        TextBox txtEditPassword = editButton.Parent.FindControl("txtPassword") as TextBox;
        TextBox txtEditAnswer = editButton.Parent.FindControl("txtAnswer") as TextBox;
        TextBox txtEditQuestion = editButton.Parent.FindControl("txtQuestion") as TextBox;
        string password = FormsAuthentication.HashPasswordForStoringInConfigFile(txtEditPassword.Text, "SHA1");
        string answer = FormsAuthentication.HashPasswordForStoringInConfigFile(txtEditAnswer.Text, "SHA1");
        editUser.Password = password;
        editUser.SecurityAnswer = answer;
        editUser.SecurityQuestion = txtEditQuestion.Text;
        context.SubmitChanges();
        GridView1.DataBind();

    }
    protected void butAddUser_Click(object sender, EventArgs e)
    {
        DataClassesDataContext context = new DataClassesDataContext();
        Guid confirmGuid = Guid.NewGuid();
        string confirmCode = confirmGuid.ToString().Substring(0,8);
        string password = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Text,"SHA1");
        string answer = FormsAuthentication.HashPasswordForStoringInConfigFile(txtAnswer.Text,"SHA1");
        int agencyId = Convert.ToInt32(ddlAgency.SelectedValue);
        int userTypeId = Convert.ToInt32(ddlUserType.SelectedValue);
        UserInfo newUser = new UserInfo { 
                            Active = true,
                            AgencyID = agencyId,
                            Created = DateTime.Now, 
                            ConfimCode = confirmCode, 
                            Email = txtEmail.Text,
                            FirstName = txtFirstName.Text, 
                            LastLogin = DateTime.Now, 
                            LastName = txtLastName.Text, 
                            Login = txtLogin.Text, 
                            Password = password, 
                            Phone = "",
                            CellPhone = "",
                            SecurityAnswer = answer, 
                            SecurityQuestion = txtQuestion.Text,
                            UserTypeID = userTypeId
                        };
        context.UserInfos.InsertOnSubmit(newUser);
        context.SubmitChanges();
        GridView1.DataBind();
    }
}
