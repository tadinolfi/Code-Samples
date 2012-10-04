<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="myazh_Default" Theme="azh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">

<h1 id="hdrWelcome"><img src="../images/headers/welcome.gif" alt="Welcome" /></h1>
		
		<!-- three column top focus areas -->
		<div id="topFocusContent">
			
			<div id="realEstateNews">
				
				<h3>Create a posting</h3>
				<p>For just $29.95, you can post your property for 30 days. Click the Create Posting button below to get started.</p>
				<p>
				    <asp:HyperLink ID="lnkCreateNew" runat="server" NavigateUrl="~/myazh/ChoosePostingType.aspx" Text="Create a New Posting" CssClass="linkButton createnew" />
				</p>
			</div><!-- realEstateNews -->
			
			<div id="productAnnouncements">				
				
				<h3><asp:Hyperlink runat="server" ID="lnkAccount" NavigateUrl="~/MyAZH/MyAccount.aspx">View Your Account</asp:Hyperlink></h3>
				<p>Manage your username, password and personal settings.</p>
				
				<h3><asp:HyperLink runat="server" ID="lnkBilling" NavigateUrl="~/MyAZH/MyBilling.aspx"></asp:HyperLink></h3>
				<p>Manage the expiration and renewal of your postings.</p>
			</div>
			
			<div id="welcomeContent">
				
				<h2>to your A Zillion Homes Account Dashboard</h2>
				<p>
                    A Zillion Homes is an online marketplace for real estate sellers, buyers, 
                    property managers, landlords, renters and real estate agents. For only $29.95 
                    you can post properties at A Zillion Homes for up to 30 days at a time. You can 
                    also search for properties for free, any time you would like, including 
                    properties for auction.</p>
                <p>
                    From here you can post new properties, view your existing postings, edit 
                    postings and look at reports. You can also manage your account details by 
                    visiting My Account.</p>
                <p>
                    Thanks for using our website. Don&#8217;t forget to let us know how we are doing by 
                    visiting the <asp:HyperLink ID="lnkFeedback" runat="server" NavigateUrl="~/Contact.aspx">Feedback section</asp:HyperLink>.</p>
			</div><!-- #welcomeContent -->
			
			<div style="clear: both;"></div>
			
		</div><!-- #topFocusContent -->
		

</asp:Content>

