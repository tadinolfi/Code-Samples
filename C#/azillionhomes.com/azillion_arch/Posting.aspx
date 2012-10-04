<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Posting.aspx.cs" Inherits="Posting" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/search-detail.css";
	</style>
	<script language="javascript" type="text/javascript" src="includes/js/imageSwap.js"></script>
	<script language="javascript" type="text/javascript" src="includes/js/postingTabs.js"></script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="mainContent" Runat="Server">
    <asp:Panel ID="pnlRental" runat="server" Visible="false">
        <div class="headerIcon" id="rentalSearchIcon"></div>
	    <h1>
	        <asp:Image ID="Image3" runat="server" ImageUrl="~/images/headers/rental-search-results.gif" />
	    </h1>
	</asp:Panel>
	<asp:Panel ID="pnlSales" runat="server" Visible="false">
        <div class="headerIcon" id="salesSearchIcon"></div>
	    <h1>
	        <asp:Image ID="imgIcon" runat="server" ImageUrl="~/images/headers/sales-search-results.gif" />
	    </h1>
	</asp:Panel>
	<asp:Panel ID="pnlOpenHouses" runat="server" Visible="false">
        <div class="headerIcon" id="openHouseSearchIcon"></div>
	    <h1>
	        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/headers/open-house-search-results.gif" />
	    </h1>
	</asp:Panel>
	<asp:Panel ID="pnlAuctions" runat="server" Visible="false">
        <div class="headerIcon" id="auctionsSearchIcon"></div>
	    <h1>
	        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/headers/auctions-search-results.gif" />
	    </h1>
	</asp:Panel>
	<ul id="previousNextButtons">
		<li id="previous">
		    <asp:HyperLink ID="lnkPrev" runat="server"><span>previous</span></asp:HyperLink>
		</li>
		<li id="next">
		    <asp:HyperLink ID="lnkNext" runat="server"><span>next</span></asp:HyperLink>
		</li>
	</ul>
    <azh:Posting ID="mainPosting" runat="server" />
</asp:Content>

