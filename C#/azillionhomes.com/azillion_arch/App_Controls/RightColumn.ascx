<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RightColumn.ascx.cs" Inherits="App_Controls_RightColumn" %>
<div id="rightColumn">
    <asp:Panel ID="pnlWelcomeBack" runat="server" Visible="false" CssClass="welcomeBackFocus focusContent">
	    <h2><span>Welcome Back</span></h2>	
		<p><asp:Label ID="lblName" runat="server" /></p>
		
		<ul class="linkList">
		    <li>
		        <asp:HyperLink ID="lnkDashboard" runat="server" NavigateUrl="~/MyAZH/Default.aspx">Your Dashboard</asp:HyperLink>
		    </li>
			<li>
			    <asp:HyperLink ID="lnkAccount" runat="server" NavigateUrl="~/MyAZH/MyAccount.aspx">Your Account Info</asp:HyperLink>
			</li>
			<li>
			    <asp:HyperLink ID="lnkSearches" runat="server" NavigateUrl="~/MyAZH/SavedListings.aspx">Your Saved Listings</asp:HyperLink>
			</li>
		</ul>					
	</asp:Panel>
	<div class="focusContent">
	    <img src="/images/right-column/focus_feedback.jpg" style="float:right" />
		<img src="/images/right-column/focus_feedback.gif" />
		<p>Please <a href="/Contact.aspx">tell us how we are doing.</a> We welcome your feedback and look forward to hearing from you.</p>
	</div><!-- first focus area -->
	<div class="focusContent">
	    <img src="/images/right-column/focus_sign.jpg" style="float:right" />
		<img src="/images/right-column/focus_selling.gif" />
		<p>For just $29.95 you can <asp:HyperLink runat="server" ID="lnkPost" NavigateUrl="~/SignUp.aspx">post and advertise</asp:HyperLink> your property at A Zillion Homes for 30 days. Add an open house to your posting for FREE. It’s fast, easy and affordable.</p>
	</div>
	<div class="focusContent">
	    <img src="../images/right-column/FAQs.jpg" id="ctl00_Img3" style="float:right" alt="FAQs" />
		<img src="../images/right-column/FAQs.gif" id="ctl00_Img4" alt="FAQs" />
		<p>Take a look at our <a href="javascript:window.open('/faqs.html', 'FAQs','scrollbars=yes,height=500,width=490',false);void(0);">frequently asked questions.</a></p>
	</div>
	
</div>