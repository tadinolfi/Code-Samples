<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="PostingPreview.aspx.cs" Inherits="myazh_PostingPreview" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>

<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/search-detail.css";
	</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
    <uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
    <asp:Panel ID="pnlPreview" runat="server">
        <p>
            Stating a Discriminatory preference in a housing post is illegal and is prohibited on AZH. Section 804(c) of the Fair Housing Act prohibits the making, printing and publishing of advertisements which state a preference, limitation or discrimination on the basis of race, color, religion, sex, handicap, familial status, or national origin. The prohibition applies to publishers, as well as to persons and entities who place real estate advertisements. Please see www.hud.gov for more information.
        </p>
        <p><a href="http://www.hud.gov">HUD.gov</a></p>
        <asp:LinkButton ID="imgComplete" runat="server" Text="Approve and Continue" CssClass="linkButton approve" onclick="imgComplete_Click" /><br />
        <iframe src="IFramePreview.aspx" class="previewFrame"></iframe>
        <br />
    </asp:Panel>
    <asp:Panel ID="pnlNoSubscription" runat="server" Visible="false">
	    <h4>Subscribe to AZH to Create a Listing</h4>
	    <p>
	        You need to have an active subscription to AZH to create listings.
	    </p>
	    <asp:ImageButton ID="imgCreateSubscription" runat="server" ImageUrl="~/images/buttons/create-subscription.gif" onclick="imgCreateSubscription_Click" />
	  </asp:Panel>
</asp:Content>

