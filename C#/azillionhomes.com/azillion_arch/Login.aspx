<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<%@ Register src="App_Controls/Login.ascx" tagname="Login" tagprefix="uc1" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Account Login - Online Real Estate Tools - azillionhomes.com</title>
    <meta name="description" content="With your azillionhomes.com account, you'll have access to online real estate tools that will make property searching or selling easy. Sign up today!" />
    <meta name="keywords" content="account login, online real estate tools, property searching" />
</asp:Content>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/secondary.css";
	</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="mainContent" Runat="Server">
	<h1><span>Login</span></h1>
	
	<!-- innerContent added to add padding around content -->
	<div id="innerContent">
	
		<div id="introText">Login to Your AZH.com and get access to all of your account information.</div>
		
		<p class="noDots"><strong>Please provide your username and password.</strong></p>
	
	    <div class="notAMemberFocus">
	        <img src="./images/headers/focus-not-a-member.gif" width="170" height="44" alt="Not a Member? Then Sign Up Today!" />
	        <p>
	            <strong>It's FREE and Easy!</strong><br />
	            With your own A Zillion Homes account, you will have access to tools that will make home searching or selling easy.
	        </p>
	        <p>
	            <asp:HyperLink ID="lnkSignUp" CssClass="linkButton signup" runat="server" NavigateUrl="~/SignUp.aspx" Text="Sign Up" />
	        </p>
        </div>
	
	    <uc1:Login ID="Login1" runat="server" />
	</div>
</asp:Content>
