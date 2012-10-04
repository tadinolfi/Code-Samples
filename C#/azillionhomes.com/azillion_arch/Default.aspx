<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="App_Controls/QuickSearch.ascx" tagname="QuickSearch" tagprefix="uc1" %>
<%@ Register src="App_Controls/Footer.ascx" tagname="Footer" tagprefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head runat="server">

	<title>azillionhomes.com - Your Online Real Estate Marketplace</title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<meta name="keywords" content="azillionhomes.com, online real estate marketplace" />
	<meta name="description" content="azillionhomes.com is an online real estate marketplace for everyone. Promote real estate on azillionhomes; a fast, affordable and efficient place." />
	<meta name="robots" content="all" />
	<meta name="revisit-after" content="10 days" />
	<meta name="distribution" content="global" />
	<meta http-equiv="Content-Language" content="en-us" />
	<meta name="language" content="English" />
	<meta name="copyright" content="Copyright 2008 - A Zillion Homes" />
	<link href="http://www.azillionhomes.com/" rel="top" />
	<link href="http://www.azillionhomes.com/site-map.htm" rel="toc" />

	<style type="text/css">
		@import "/includes/css/base.css";
		@import "/includes/css/interface.css";
		@import "/includes/css/home.css";
		@import "/includes/css/rollovers.css";
	</style>
	
	<link rel="stylesheet" type="text/css" href="../includes/css/print.css" media="print" />
	
	<script language="JavaScript" src="/includes/js/ufo.js" type="text/javascript"></script>
	<script language="JavaScript" type="text/javascript">
    	var FO = { movie:"includes/flash/azh_hp_flash-a.swf", width:"453", height:"359", majorversion:"8", build:"40", quality:"best", wmode: "transparent"};
		UFO.create(FO, "flashTop");
    </script>	
</head>
<body>
    <form runat="server" id="form1">
    <asp:ScriptManager ID="ScriptManager1" runat="server" ></asp:ScriptManager>
    <div id="envelope">
    <div id="flashTop">
	    <asp:HyperLink ID="lnkLearnWhy" NavigateUrl="~/about/Default.aspx" runat="server" CssClass="learnWhy">learn why <strong>&raquo;</strong></asp:HyperLink>
	    <img id="logo" src="/images/home/logo.gif" alt="A Zillion Homes" />
	    <img id="tagline"src="/images/home/tagline.gif" alt="Your Online Real Estate Marketplace" />
	</div>
	
	<div id="mainImage">
		<a href="About/Pricing.aspx" class="advertiseWithUs">Advertise With Us</a>
	</div>
	
	<asp:UpdatePanel ID="pnlNav" runat="server">
	    <ContentTemplate>
	    
	
	<div id="mainNavigation">
		
		<div id="btnRentals">
			<asp:LinkButton OnClick="lnkRentals_Click" ID="lnkRentalPage" runat="server" CssClass="button">The most powerful rental search there is.</asp:LinkButton>
			<asp:LinkButton Visible="false" ID="lnkRentals" runat="server" CssClass="quickSearch" OnClick="lnkRentals_Click">quick search <span>&raquo;</span></asp:LinkButton>
		</div>
		
		<div id="btnSales">
			<asp:LinkButton OnClick="lnkSales_Click" ID="HyperLink1" runat="server" CssClass="button">View hundreds of residential properties for sale in your area.</asp:LinkButton>
			<asp:LinkButton Visible="false" ID="lnkSales" runat="server" CssClass="quickSearch" OnClick="lnkSales_Click">quick search <span>&raquo;</span></asp:LinkButton>
		</div>
		
		<div id="btnOpenHouses">
			<asp:LinkButton OnClick="lnkOpenHouses_Click" ID="HyperLink2" runat="server" CssClass="button">Want to visit? Search for open houses in your area.</asp:LinkButton>
			<asp:LinkButton Visible="false" ID="lnkOpenHouses" runat="server" CssClass="quickSearch" OnClick="lnkOpenHouses_Click">quick search <span>&raquo;</span></asp:LinkButton>
		</div>
		
		<div id="btnAuctions">
			<asp:LinkButton OnClick="lnkAuctions_Click" ID="HyperLink3" runat="server" CssClass="button">Search for auctions in your area.</asp:LinkButton>
			<asp:LinkButton Visible="false" ID="lnkAuctions" runat="server" CssClass="quickSearch" OnClick="lnkAuctions_Click">quick search <span>&raquo;</span></asp:LinkButton>
		</div>
		
		<div id="btnPostWithUs">
			<asp:HyperLink NavigateUrl="~/SignUp.aspx" ID="HyperLink4" runat="server" CssClass="button">Use A Zillion Homes to post your property for sale, rent, open house or auction.</asp:HyperLink>
			<asp:HyperLink NavigateUrl="~/SignUp.aspx" ID="HyperLink6" runat="server" CssClass="quickSearch">sign up <span>&raquo;</span></asp:HyperLink>	
		</div>
		
		<div id="btnLogin">
			<asp:HyperLink NavigateUrl="~/Login.aspx" ID="HyperLink5" runat="server" CssClass="button">Already a member? Login here to gain access to your account.</asp:HyperLink>
			<asp:HyperLink NavigateUrl="~/Login.aspx" ID="HyperLink7" runat="server" CssClass="quickSearch">login <span>&raquo;</span></asp:HyperLink>	
		</div>		
		
	</div>

    <uc1:QuickSearch ListingTypeID="1" ID="pnlRentals" runat="server" />
    <uc1:QuickSearch ListingTypeID="2" ID="pnlSales" runat="server" />
    <uc1:QuickSearch ListingTypeID="3" ID="pnlOpenHouses" runat="server" />
    <uc1:QuickSearch ListingTypeID="4" ID="pnlAuctions" runat="server" />
            
	</ContentTemplate>
	</asp:UpdatePanel>
	<div id="flash">
        <img src="/images/home/main-image.jpg" alt="" /></div>

	<uc2:Footer ID="Footer1" runat="server" />

</div><!-- #envelope -->
</form>
    <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
        try {
            var pageTracker = _gat._getTracker("UA-6524282-1");
            pageTracker._trackPageview();
        } catch (err) { }
    </script>
</body>
</html>
