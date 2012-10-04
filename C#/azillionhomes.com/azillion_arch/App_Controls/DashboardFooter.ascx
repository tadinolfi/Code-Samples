<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DashboardFooter.ascx.cs" Inherits="App_Controls_DashboardFooter" %>
<div id="bottomFocusAreas">
    <div class="focus">
	    <h3>How to Create a Posting</h3>
	    <p>Creating a Posting is very easy! All you have to do is select the type of Posting you'd like and then fill in the appropriate information and images and you're done! 
	    <asp:HyperLink ID="lnkCreate" runat="server" NavigateUrl="~/MyAZH/ChoosePostingType.aspx">&raquo; Create One Now</asp:HyperLink>
    </div>

    <div class="focus">
	    <h3>Feedback</h3>
	    <p>We welcome your suggestions on how we could improve the site. Send us your feedback and let us know how we are doing.</p>
	    <asp:HyperLink ID="lnkFeedback" runat="server" NavigateUrl="~/Contact.aspx">&raquo; Learn More</asp:HyperLink>
	    
    </div>

    <div class="focus">
	    <h3>Flexible, Easy &amp; Robust</h3>
	    <p>A Zillion Homes provides the most extensive real estate advertising resource available on the web today. For the first time ever it is now possible to advertise every detail about a property.</p>
	    <asp:HyperLink ID="lnkBenefits" runat="server" NavigateUrl="~/About/Benefits.aspx">&raquo; Learn More</asp:HyperLink>
    </div>

    <div class="focus" id="last">
	    <h3>FAQs</h3>
	    <p>Taka a look at our Frequently Asked Questions for additional information. </p>
	    <a href="javascript:window.open('/faqs.html', 'FAQs','scrollbars=yes,height=500,width=490',false);void(0);">&raquo; Learn More</a>
    </div>
</div>