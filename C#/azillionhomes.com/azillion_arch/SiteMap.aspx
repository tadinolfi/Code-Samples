<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="SiteMap.aspx.cs" Inherits="SiteMap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mainContent" Runat="Server">
    <div id="innerContent">
		
			<h1><img src="../images/headers/site-map.gif" alt="Site Map" /></h1>
			
			<div id="introText"><span class="note">Note:</span> If you are not logged in to A Zillion Homes you cannot access your secured information through the Site Map page.</div>
			
			<div class="siteMapContent" id="privateLinks">
			
				<h2>My AZH Home Page</h2>
				<ul>
				    <li><a href="/myazh/Default.aspx">&raquo;&nbsp; AZH Home Page</a></li>
				</ul>
				
				<h2>My Account Information</h2>
				<ul>
					<li><a href="/myazh/MyAccount.aspx">&raquo;&nbsp; Overview</a></li>
				</ul>
				
				<h2>My Saved Searches/Listings</h2>
				<ul>
					<li><a href="/myazh/SavedListings.aspx">&raquo;&nbsp; Overview</a></li>
				</ul>
				
				<h2>My Postings</h2>
				<ul>
					<li><a href="/myazh/MyPostings.aspx">&raquo;&nbsp; My Postings</a></li>
				</ul>
			</div>
			
			<div class="siteMapContent" id="publicLinks">
			
				<h2>Rentals</h2>
				<ul><li><a href="/rentals/Search.aspx">&raquo;&nbsp; Rental Search</a></li></ul>
				
				<h2>Sales</h2>
				<ul>
					<li><a href="/sales/Search.aspx">&raquo;&nbsp; Sales Search</a></li>
				</ul>
				
				<h2>Open Houses</h2>
				<ul>
					<li><a href="/openhouses/Search.aspx">&raquo;&nbsp; Open House Search</a></li>
				</ul>
				
				<h2>Auctions</h2>
				<ul>
					<li><a href="/auctions/Search.aspx">&raquo;&nbsp; Auctions</a></li>
				</ul>
				
				<h2>About Us</h2>
				<ul>
					<li><a href="/about/">&raquo;&nbsp; Overview</a></li>
					<li><a href="/about/benefits.aspx">&raquo;&nbsp; Benefits</a></li>
				</ul>
			
				<h2>Forum</h2>
				<ul>
					<li><a href="/forum/">&raquo;&nbsp; Overview</a></li>
				</ul>
			
				<h2>Sign Up</h2>
				<ul>
					<li><a href="/signup.aspx">&raquo;&nbsp; Sign Up Form</a></li>
				</ul>
			
				<h2>Login</h2>
				<ul class="lastList">
					<li><a href="/login.aspx">&raquo;&nbsp; Login Form</a></li>
				</ul>
			</div>
		</div>
</asp:Content>

