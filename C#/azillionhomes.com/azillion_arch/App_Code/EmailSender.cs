using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Configuration;
using System.IO;

/// <summary>
/// Summary description for EmailSender
/// </summary>
public class EmailSender
{
    
    public string FromAddress { get; set; }
    public string MessageBody { get; set; }
    public string MessageUrl { get; set; }
    public string Subject { get; set; }
    public string TemplateFile { get; set; }
    public string ToAddress { get; set; }

    public void SendEmail()
    {
        //Instantiate Client
        SmtpClient myClient = new SmtpClient(ConfigurationManager.AppSettings["mailServer"]);

        //Process Template File
        string templateText = File.ReadAllText(TemplateFile);
        string messageLink = "<a href=\"" + MessageUrl + "\">" + MessageUrl + "</a>";
        templateText = templateText.Replace("%%MESSAGE%%", MessageBody);
        templateText = templateText.Replace("%%LINK%%", messageLink);
        templateText = templateText.Replace("%%FROMADDRESS%%", FromAddress);
        templateText = templateText.Replace("%%TOADDRESS%%", ToAddress);

        //Create Message and Send
        MailMessage emailMessage = new MailMessage(FromAddress, ToAddress, Subject, templateText);
        emailMessage.IsBodyHtml = true;
        myClient.Send(emailMessage);

    }
}
