<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HelpTest.aspx.cs" Inherits="HelpTest" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="Stylesheet" media="all" type="text/css" href="includes/css/modaldbox.css" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
    <azh:HelpButton ID="hlpTest" runat="server" Title="Help Test" Message="This is a test of the help button system" />
    </div>
    </form>
</body>
</html>
