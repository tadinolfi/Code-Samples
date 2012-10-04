<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" Inherits="App_Controls_Footer" %>

<div id="footer">
	<div id="footerLinks">
        <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Default.aspx">Home</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkAbout" runat="server" NavigateUrl="~/about/Default.aspx">About</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkForum" runat="server" NavigateUrl="~/forum/Default.aspx">Forum</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkSignup" runat="server" NavigateUrl="~/SignUp.aspx">Sign Up</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkSupport" runat="server" NavigateUrl="~/Contact.aspx">Support</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkSiteMap" runat="server" NavigateUrl="~/SiteMap.aspx">Site Map</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkLegal" runat="server" NavigateUrl="~/Legal/Default.aspx">Legal</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkContact" runat="server" NavigateUrl="~/Contact.aspx">Contact</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx">Login</asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; 
        <asp:HyperLink ID="lnkFair" runat="server" NavigateUrl="http://www.hud.gov">Fair Housing</asp:HyperLink>
    </div>
	<div id="footerContent">
	    &#169; 2008 A Zillion Homes &nbsp;---&nbsp; All Rights Reserved 
	    &nbsp;---&nbsp; 
	    <a href="http://www.lightfin.com" onclick="window.open(this.href); return false;" id="lightfin">Designed by: &nbsp;&nbsp; <span>Lightfin Studios</span></a>
	    &nbsp;---&nbsp; 
	    <a href="http://www.amplifystudios.com" onclick="window.open(this.href); return false;" id="amplify">Powered by: <span>Amplify</span></a>
	</div>	
</div>