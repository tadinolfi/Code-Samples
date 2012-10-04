using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Configuration;

public partial class Contact : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void imgSubmit_Click(object sender, EventArgs e)
    {
        string mailBody = "";
        if (!string.IsNullOrEmpty(txtName.Text))
            mailBody += "Name: " + txtName.Text + "\r\n";
        if (!string.IsNullOrEmpty(txtPhone.Text))
            mailBody += "Phone: " + txtPhone.Text + "\r\n";
        if (!string.IsNullOrEmpty(txtAddress.Text))
            mailBody += "Address: " + txtAddress.Text + "\r\n";
        mailBody += "------\r\n\r\n";
        mailBody += txtComments.Text;

        MailMessage contactMail = new MailMessage(txtEmail.Text, ConfigurationManager.AppSettings["contactEmail"], "Contact Request From AZH", mailBody);
        SmtpClient mailClient = new SmtpClient(ConfigurationManager.AppSettings["mailServer"]);
        mailClient.Send(contactMail);

        pnlForm.Visible = false;
        pnlResponse.Visible = true;
    }
}
