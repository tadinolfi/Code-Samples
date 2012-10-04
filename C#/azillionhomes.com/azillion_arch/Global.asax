<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // Code that runs on application startup

    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }

    protected void Application_Error(Object sender, EventArgs e)
    {
        Exception ex = Server.GetLastError();

        // Don't bother if this is an unimportant error
        if (Request.ServerVariables["HTTP_HOST"].Contains("localhost:")
            || ex.Message.Contains("potentially dangerous Request.Form value")
            || (ex.Message.Contains("File does not exist.") && Request.Url.PathAndQuery.ToLower().EndsWith(".css")))
            return;

        StringBuilder sb = new StringBuilder();

        sb.Append("This message has been mailed to Amplify Studios " + Environment.NewLine + Environment.NewLine + Environment.NewLine);
        sb.Append("Current Server Time: " + DateTime.Now.ToString() + Environment.NewLine + Environment.NewLine);
        //sb.Append("Script Name: " + Request.ServerVariables["SCRIPT_NAME"].ToString() + Environment.NewLine + Environment.NewLine);
        sb.Append("Script Name: ");

        if (Request.ServerVariables["HTTPS"].ToLower() == "off")
            sb.Append("http://");
        else
            sb.Append("https://");
        sb.Append(Request.ServerVariables["HTTP_HOST"] + Request.ServerVariables["URL"] + Environment.NewLine + Environment.NewLine);
        sb.Append("Full Request URL: " + Request.Url.PathAndQuery + Environment.NewLine + Environment.NewLine);

        sb.Append("Client Browser: ");
        if (Request.Browser != null)
        {
            sb.Append(Request.Browser.Browser + " " + Request.Browser.Version);
            sb.Append(" (JavaScript " + (Request.Browser.JavaScript ? "enabled" : "DISABLED") + ")");
            sb.Append(Environment.NewLine);
        }
        else
            sb.Append("<unknown>");
        sb.Append(Environment.NewLine);
        sb.Append("Client Info: " + Request.UserHostName + " (" + Request.UserHostAddress + ")" + Environment.NewLine + Environment.NewLine);

        sb.Append("Help Link: " + ex.HelpLink + Environment.NewLine + Environment.NewLine);
        sb.Append("Caught Exception: " + ex.Message + Environment.NewLine + Environment.NewLine);
        sb.Append("Source: " + ex.Source + Environment.NewLine + Environment.NewLine);
        sb.Append("StackTrace: " + ex.StackTrace + Environment.NewLine + Environment.NewLine);
        sb.Append("TargetSite: " + ex.TargetSite + Environment.NewLine + Environment.NewLine);

        if (ex.InnerException != null)
        {
            sb.Append(Environment.NewLine);
            sb.Append("InnerException Details: ");

            GetInnerExceptionData(ex.InnerException, ref sb);
        }

        System.Security.SecurityException ex_security = ex as System.Security.SecurityException;

        if (ex_security != null)
        {
            sb.Append(Environment.NewLine);
            sb.Append("Security Exception Details: ");
            sb.Append(Environment.NewLine);
            sb.Append("===========================");
            sb.Append(Environment.NewLine);
            sb.Append("PermissionState: " + ex_security.PermissionState + Environment.NewLine + Environment.NewLine);
            sb.Append("PermissionType: " + ex_security.PermissionType + Environment.NewLine + Environment.NewLine);
            sb.Append("Source: " + ex_security.Source);
        }
        sb.Append(Environment.NewLine + Environment.NewLine);

        // Dump all the request-related variables
        sb.Append("=============================================================" + Environment.NewLine
            + Environment.NewLine + "Request-related Parameters:" + Environment.NewLine);
        foreach (string param in Request.Params)
        {
            try
            {
                sb.Append(param + ": " + Request.Params[param].ToString() + Environment.NewLine);
            }
            catch
            {
                // just go on to the next one
            }
        }
        sb.Append(Environment.NewLine);

        //System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings["mailServer"]);
        //smtp.Send("noreply@azillionhomes.com", ConfigurationManager.AppSettings["supportEmail"],"[AZH] Error in " + Request.ServerVariables["SCRIPT_NAME"], sb.ToString());

        Response.Redirect("~/Error.aspx");
    }
    
    public void GetInnerExceptionData(System.Exception ex, ref StringBuilder sb)
    {
        sb.Append(ex.Message);
        sb.Append(ex.StackTrace);

        if (ex.InnerException != null)
        {
            sb.Append(ex.InnerException);
            GetInnerExceptionData(ex.InnerException, ref sb);
        }
    }

    void Session_Start(object sender, EventArgs e) 
    {
    }

    void Session_End(object sender, EventArgs e) 
    {
    }
       
</script>
