<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftNav.ascx.cs" Inherits="App_Controls_LeftNav" %>

<%@ Register src="QuickSearch.ascx" tagname="QuickSearch" tagprefix="uc1" %>

<div id="leftColumn">
	<ul id="mainNavigation">
		<li id="btnRentals" runat="server">
		    <asp:LinkButton ID="lnkRentals" runat="server" onclick="lnkRentals_Click" CausesValidation="false"><span>rentals</span></asp:LinkButton>
            <uc1:QuickSearch ListingTypeID="1" ID="pnlRentalSearch" runat="server" Visible="false" />
		</li>
		<li id="btnSales" runat="server">
		    <asp:LinkButton ID="lnkSales" runat="server" onclick="lnkSales_Click" CausesValidation="false"><span>sales</span></asp:LinkButton>
            <uc1:QuickSearch ListingTypeID="2" ID="pnlSalesSearch" runat="server" Visible="false" />
		</li>
		<li id="btnOpenHouses" runat="server">
		    <asp:LinkButton ID="lnkOpenHouses" runat="server" onclick="lnkOpenHouses_Click" CausesValidation="false"><span>open houses</span></asp:LinkButton>
            <uc1:QuickSearch ListingTypeID="3" ID="pnlOpenHouseSearch" runat="server" Visible="false" />
		</li>
		<li id="btnAuctions" runat="server">
		    <asp:LinkButton ID="lnkAuctions" runat="server" onclick="lnkAuctions_Click" CausesValidation="false"><span>auctions</span></asp:LinkButton>
            <uc1:QuickSearch ListingTypeID="4" ID="pnlAuctionsSearch" runat="server" Visible="false" />
		</li>
	</ul>
</div>

