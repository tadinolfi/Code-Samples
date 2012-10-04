<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CopyForm.aspx.cs" Inherits="CopyForm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <p>
        Old Form ID:<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
    </p>
    <p>
        New Form ID:
        <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
    </p>
    <p>
        <asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
            Text="OMG MAKE ME A FORM BECAUSE THIS IS GETTING OLD!" />
    </p>
    <div>
    
    </div>
    </form>
</body>
</html>
