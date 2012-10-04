<%@ Page Title="" Language="C#" MasterPageFile="~/Search.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="sales_Search" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Search Real Estate Sales Online - azillionhomes.com</title>
    <meta name="keywords" content="real estate sales online , customize searches, property" />
    <meta name="description" content="Search online real estate sales. Find the type of property, location, and price that best suits you. Customize searches and find your property now!" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="topContent" Runat="Server">
    <div class="headerIcon" id="salesSearchIcon"></div>
	<h1>
	    <asp:Image ID="imgIcon" runat="server" ImageUrl="~/images/headers/sale-search.gif" />
	</h1>
</asp:Content>