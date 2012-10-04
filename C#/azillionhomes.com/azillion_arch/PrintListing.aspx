<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintListing.aspx.cs" Inherits="PrintListing" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print AZH Listing</title>
    <link rel="Stylesheet" media="all" type="text/css" href="includes/css/NewPrintStyle.css" />
</head>
<body onload="window.print();">
    <div class="printContainer">
    <azh:PrintPosting ID="mainPosting" runat="server" EnableViewState="false" />
    </div>
</body>
</html>
