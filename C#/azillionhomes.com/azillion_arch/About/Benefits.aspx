<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Benefits.aspx.cs" Inherits="AboutUs_Benefits" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Easy and Efficient Online Real Estate - azillionhomes.com</title>
    <meta name="description" content="azillionhomes.com is the easiest and most efficient site of its kind in the real estate industry. Explore our affordable approach. Sign up today!" />
    <meta name="keywords" content="easy, efficient, online real estate industry" />
</asp:Content>

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
			<li><a href="Benefits.aspx" id="selectedPage">Benefits</a></li>
			<li class="last"><a href="Pricing.aspx">Pricing</a></li>
			<!-- <li class="last"><a href="Investors.aspx">Investors</a></li> -->
		</ul>
		
		<div id="introText">The A Zillion Homes website is the easiest and most efficient site of its kind in the real estate industry. Although there are a multitude of benefits offered by A Zillion Homes, below you will find a sampling of some of the key components.</div>
		
		<div class="twoColumnContent">
		
			<div class="rightColumn">
				
				<h3 id="viewerBenefits"><img src="/images/headers/viewer-benefits.gif" alt="viewer benefits" /></h3>
				<ul class="benefitsList">
					<li class="firstItem"><strong>Ease:</strong> In a matter of seconds, you can view detailed home postings.</li>
					<li><strong>Results:</strong> By using A Zillion Homes' search engines, you will only get results for the locations and price levels you choose.</li>
					<li><strong>Convenience:</strong> From the comfort of your own home, you can take as much time as you like to review A Zillion Homes' postings.</li>
					<li><strong>One-stop-shop:</strong> At A Zillion Homes, you can search homes for sale, rentals, auctions and open houses; this is information that is typically difficult to find in one place.</li>	
					<li><strong>Communication:</strong> Every posting has clear contact information allowing you to easily communicate with the agents and owners representing the properties.</li>
				</ul>
										
			</div><!-- .rightColumn -->
			
			<div class="leftColumn">
				
				<h3 id="posterBenefits"><img src="/images/headers/poster-benefits.gif" alt="poster benefits" /></h3>
				<ul class="benefitsList">
					<li class="firstItem"><strong>Value:</strong> For only $29.95/month, your property will be posted for 30 days, giving you greater exposure at a far better value than traditional advertising.</li>
					<li><strong>Detail:</strong> With an online posting, you can offer viewers as much property detail as you would like, and up to 12 images. As opposed to traditional print classifieds, at A Zillion Homes you have the space and flexibility to give more information.</li>
					<li><strong>Ease of use:</strong> Following A Zillion Homes' straightforward instructions, you can have your property posted in a matter of minutes.</li>
					<li><strong>Convenience:</strong> From the comfort of your own home, you can post a property any time of day, any day of the week.</li>
					<li><strong>Exposure:</strong> According to the USA Today, 77% of users today start their searches for a house or apartment online.&sup1;</li>
					<li><strong>Flexibility:</strong> Internet postings offer more information and images than classified advertising.</li>
				</ul>
				
			</div>
			
			<div style="clear:both;"></div>
			
		</div><!-- .twoColumnContent -->
		
	</div>
</asp:Content>	