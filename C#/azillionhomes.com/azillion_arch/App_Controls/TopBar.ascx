<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TopBar.ascx.cs" Inherits="App_Controls_TopBar" %>

<div id="topBar">
	<a href="/myazh/">
	    <img id="logo" src="../images/dashboard/logo.gif" alt="A Zillion Homes" />
	</a>
	<div id="welcomeMessage">
	    Welcome back <asp:HyperLink ID="lnkUser" runat="server" NavigateUrl="~/MyAZH/MyAccount.aspx"></asp:HyperLink>
	</div>
	<ul id="secondaryNavigation">
		<li class="btnAZH">
		    <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Default.aspx"><span>AZH.com</span></asp:HyperLink>
		</li>
		<li class="btnMyAZH" id="myAZHButton" runat="server">
		    <asp:HyperLink ID="lnkMyAZH" runat="server" NavigateUrl="~/MyAZH/Default.aspx"><span>MyAZH</span></asp:HyperLink>
		</li>
		<li class="btnLogout">
		    <asp:LinkButton ID="lnkLogout" CausesValidation="false" runat="server" onclick="lnkLogout_Click"><span>logout</span></asp:LinkButton>
		</li>
	</ul>
	<ul id="mainNavigation">
		<li class="welcome">
		    <asp:HyperLink ID="lnkWelcome" runat=server NavigateUrl="~/myazh/"><span>Welcome</span></asp:HyperLink>
		</li>
		<li class="myAccount">
		    <asp:HyperLink ID="lnkAccount" runat="server" NavigateUrl="~/myazh/MyAccount.aspx"><span>My Account</span></asp:HyperLink>
		</li>
		<li class="myPostings">
		    <asp:HyperLink ID="lnkPostings" runat="server" NavigateUrl="~/myazh/MyPostings.aspx"><span>My Postings</span></asp:HyperLink>
		</li>
	</ul>
</div>