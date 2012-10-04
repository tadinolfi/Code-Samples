<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Error" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mainContent" Runat="Server">
    <div class="headerIcon" id="errorIcon"></div>
	<h1>
	    <asp:Image ID="imgIcon" runat="server" ImageUrl="~/images/headers/error.gif" />
	</h1>
	<div id="innerContent">
	    <h2>Our technical team has been notified.</h2>
	    <p class="noDots">
	        At A Zillion Homes, we work to ensure the highest level of quality for our site, but in some cases errors can occur. Our technical staff
	        has been notified about this error and will be investigating it shortly.
	    </p>
	    <p>
	        If you encounter additional errors, please try again later or contact us.
	    </p>
	</div>
</asp:Content>

