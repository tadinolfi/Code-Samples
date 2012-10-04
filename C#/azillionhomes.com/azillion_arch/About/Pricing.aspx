<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Pricing.aspx.cs" Inherits="About_Pricing" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/secondary.css";
	</style>
</asp:Content>

<asp:Content ContentPlaceHolderID="mainContent" ID="Content1" runat="server">
    <h1><span>About Us</span></h1>		
	<!-- innerContent added to add padding around content -->
	<div id="innerContent">
	
		<ul id="jumpLinks">
			<li><strong>About Us:</strong></li>
			<li class="overview"><a href="Default.aspx">Overview</a></li>
			<li><a href="Benefits.aspx">Benefits</a></li>
			<li class="last"><a href="Pricing.aspx" id="selectedPage">Pricing</a></li>
			<!-- <li class="last"><a href="Investors.aspx">Investors</a></li> -->
		</ul>
		<h2>Properties for sale, rent, auction and open houses.</h2>
		<div id="introText">A Zillion Homes is the online marketplace for real estate Sellers, Buyers, Real Estate Agents, Landlords, Renters and Property Managers.
		<br /><br />
		For only $29.95, you can post unlimited properties at A Zillion Homes for up to 30 days at a time. </div>
		<p class="noDots">And, because this is an online marketplace, Sellers have the freedom to post multiple images, and offer as much detail regarding their properties as they would like. In turn, Buyers can search the comprehensive postings until they have found the perfect home, in the right location, at the right price <asp:Hyperlink ID="lnkSignUp" runat="server" NavigateUrl="~/SignUp.aspx">Sign Up Now</asp:Hyperlink>….</p>		
	</div>
</asp:Content>	