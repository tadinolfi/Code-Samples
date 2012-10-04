using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Net.Mail;
using System.Web.Security;

public partial class App_Controls_Login : System.Web.UI.UserControl
{
    public string Username
    {
        get
        {
            if (ViewState["Username"] != null)
            {
                return (string)ViewState["Username"];
            }
            else
            {
                return string.Empty;
            }
        }
        set
        {
            ViewState["Username"] = value;
        }
    }

    public string LoginUrl
    {
        get
        {
            if (ViewState["LoginUrl"] != null)
            {
                return (string)ViewState["LoginUrl"];
            }
            else
            {
                return "~/myazh/";
            }
        }
        set
        {
            ViewState["LoginUrl"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void butLogin_Click(object sender, EventArgs e)
    {
        try
        {
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo loginUser = context.UserInfos.Single(n => n.Login == txtUsername.Text);
            string userPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Text, "SHA1");
            if (loginUser.Password.Trim() == userPassword)
            {
                UserAPI.AuthenticateUser(loginUser.Login, chkRemember.Checked);
                if (!string.IsNullOrEmpty(Request.QueryString["returnurl"]))
                {
                    Response.Redirect(Server.UrlDecode(Request.QueryString["returnurl"]));
                }
                else
                {
                    Response.Redirect(LoginUrl);
                }
            }
            else
            {
                valPassword.IsValid = false;
            }
        }
        catch
        {
            valPassword.IsValid = false;
        }
    }
    protected void butForgot_Click(object sender, EventArgs e)
    {
        pnlLogin.Visible = false;
        pnlEnter.Visible = true;
    }
    protected void butStep2_Click(object sender, EventArgs e)
    {
        try
        {
            Username = txtUsername2.Text;
            DataClassesDataContext context = new DataClassesDataContext();
            UserInfo checkUser = context.UserInfos.Single(n => n.Login == Username);
            switch (rblMethod.SelectedValue)
            {
                case "email":
                    string emailText = File.ReadAllText(Server.MapPath("~/App_Files/email.txt"));
                    emailText = emailText.Replace("%%%RESETLINK%%%", "http://www.azillionhomes.com/myazh/resetpassword.aspx?cc=" + checkUser.ConfimCode);
                    MailMessage pwMessage = new MailMessage("noreply@azillionhomes.com", checkUser.Email, "Password Reset Information", emailText);
                    SmtpClient mailClient = new SmtpClient("mail.amplifyhosting.com");
                    mailClient.Send(pwMessage);
                    pnlEmail.Visible = true;
                    break;
                case "question":
                    lblQuestion.Text = checkUser.SecurityQuestion;
                    pnlQuestion.Visible = true;
                    break;
            }
            pnlEnter.Visible = false;
        }
        catch
        {
            valUsername.IsValid = false;
        }
    }
    protected void butAnswer_Click(object sender, EventArgs e)
    {
        string hashedAnswer = FormsAuthentication.HashPasswordForStoringInConfigFile(txtAnswer.Text, "SHA1");
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo checkUser = context.UserInfos.Single(n => n.Login == Username);
        if (checkUser.SecurityAnswer == hashedAnswer)
        {
            pnlQuestion.Visible = false;
            pnlNewPass.Visible = true;
        }
        else
        {
            valAnswer.IsValid = false;
        }
    }
    protected void butResetPassword_Click(object sender, EventArgs e)
    {
        string newPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(txtNewPassword.Text, "SHA1");
        DataClassesDataContext context = new DataClassesDataContext();
        UserInfo changeUser = context.UserInfos.Single(n => n.Login == Username);
        changeUser.Password = newPassword;
        context.SubmitChanges();
        UserAPI.AuthenticateUser(Username, false);
        pnlNewPass.Visible = false;
        pnlSuccess.Visible = true;
    }
    
}
