<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PublicTopbar.ascx.cs" Inherits="App_Controls_PublicTopbar" %>

<div id="topBar">
		
	<asp:HyperLink ID="lnkLogo" runat="server" NavigateUrl="~/Default.aspx"><img id="logo" src="/images/interface/logo.gif" alt="A Zillion Homes" /></asp:HyperLink>
	
	<ul id="secondaryNavigation">
		<li class="btnAboutUs">
		    <asp:HyperLink ID="lnkAbout" runat="server" NavigateUrl="~/about/Default.aspx"><span>about us</span></asp:HyperLink>
		</li>
		<li class="btnForum">
		    <asp:HyperLink ID="lnkForum" runat="server" NavigateUrl="~/forum/"><span>forum</span></asp:HyperLink>
		</li>
		<li class="btnSignUp" id="btnSignUp" runat="server">
		    <asp:HyperLink ID="lnkSignUp" runat="server" NavigateUrl="~/SignUp.aspx"><span>sign up</span></asp:HyperLink>
		</li>
		<li class="btnMyAZH" runat="server" id="btnMyAZH" visible="false">
		    <asp:HyperLink ID="lnkMyAZH" runat="server" NavigateUrl="~/MyAZH/Default.aspx"><span>MyAZH</span></asp:HyperLink>
		</li>
		<li id="btnLogin" runat="server" class="btnLogin">
		    <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx"><span>login</span></asp:HyperLink>
		</li>
		<li id="btnLogout" runat="server" class="btnLogout" visible="false">
		    <asp:LinkButton ID="lnkLogout" runat="server" onclick="lnkLogout_Click"><span>logout</span></asp:LinkButton>
		</li>
	</ul>
	
</div>