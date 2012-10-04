<%@ Page Title="" Language="C#" MasterPageFile="~/Search.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="rentals_Search" %>
<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Search Real Estate Rentals Online - azillionhomes.com</title>
    <meta name="keywords" content="real estate rentals online " />
    <meta name="description" content="Search real estate rentals online and find the type of property, location, and price that best suits you. Customize your online rental searches here!" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="topContent" Runat="Server">
    <div class="headerIcon" id="rentalSearchIcon"></div>
	<h1>
	    <asp:Image ID="imgIcon" runat="server" ImageUrl="~/images/headers/rental-search.gif" />
	</h1>
</asp:Content>
