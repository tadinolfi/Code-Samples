<%@ Page Title="" Language="C#" MasterPageFile="~/Search.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="openhouses_Search" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Search Real Estate Open Houses Online - azillionhomes.com</title>
    <meta name="keywords" content="real estate open houses online " />
    <meta name="description" content="Search real estate open houses online and find the type of property, location, and price that best suits you. Customize your online searches today!" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="topContent" Runat="Server">
    <div class="headerIcon" id="openHouseSearchIcon"></div>
	<h1>
	    <asp:Image ID="imgIcon" runat="server" ImageUrl="~/images/headers/search-open-houses.gif" />
	</h1>
</asp:Content>