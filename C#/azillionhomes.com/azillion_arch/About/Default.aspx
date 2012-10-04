<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AboutUs_Default" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Sell and Buy Real Estate Online - About - azillionhomes.com</title>
    <meta name="keywords" content="about azillionhomes.com, sell buy real estate, search online postings free" />
    <meta name="description" content="azillionhomes.com, a valuable and efficient way to sell and buy real estate online. Buyers and renters, search online postings for free. Try us today!" />
</asp:Content>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/secondary.css";
	</style>
</asp:Content>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="mainContent">
    <h1><span>About Us</span></h1>
	<!-- innerContent added to add padding around content -->
	<div id="innerContent">
	
		<ul id="jumpLinks">
			<li><strong>About Us:</strong></li>
	        <li class="overview"><a href="Default.aspx" id="selectedPage">Overview</a></li>
	        <li><a href="Benefits.aspx">Benefits</a></li>
	        <li class="last"><a href="Pricing.aspx">Pricing</a></li>
	        <!-- <li class="last"><a href="Investors.aspx">Investors</a></li> -->
		</ul>
		
		<div id="introText">About Us</div>
		
		<p>A Zillion Homes is an online marketplace for real estate that is available 
            to everyone. Anyone with real estate to promote will find A Zillion Homes a 
            fast, affordable and efficient place to feature their properties. Buyers and 
            renters are welcome to search our detailed postings free of charge then contact 
            the posters at their convenience.</p>
		
		<div class="rightAlignFocus">
			<div id="focus1"><span>A Zillion Homes is a valuable and efficient way to buy and sell real estate.</span></div>
		</div>
		
		<p>
            <strong>For only $29.95 per month individual posters can post as many properties as 
            they like.</strong></p>
        <p class="noDots">&#8220;<strong>OPEN HOUSE</strong>&#8221; postings are <strong>FREE </strong>to post and free to view.</p>
        <p class="noDots">
            Our goal at A Zillion Homes is to create a real estate advertising site that is well 
            organized, easy to use, and an effective way for interested parties to 
            communicate.</p>
        <p class="noDots">Thank you for using A Zillion Homes.</p>
		<p class="noDots"><a href="benefits.aspx" class="linkButton benefits"></a></p>
	</div>
</asp:Content>
