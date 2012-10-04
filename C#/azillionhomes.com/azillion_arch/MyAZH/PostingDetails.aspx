<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="PostingDetails.aspx.cs" Inherits="myazh_PostingDetails" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>
<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
	<uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
	<asp:Panel ID="pnlDetails" runat="server">
	    
     	<asp:UpdateProgress ID="prgUpdateSection" runat="server">
	        <ProgressTemplate>
	            <asp:Image ID="imgLoader" runat="server" ImageUrl="~/images/ajax-loader.gif" />
	        </ProgressTemplate>
	    </asp:UpdateProgress>
	    <asp:UpdatePanel ID="pnlUpdateSection" runat="server">
	        <ContentTemplate>
	            <h4><asp:Label ID="lblPostingBreadCrumb" runat="server" /> &raquo; Details &raquo <asp:Label ID="lblSection" runat="server" /></h4>
	            <div class="myPostingsForms">
	                <asp:Panel ID="pnlSections" runat="server" CssClass="detailsExpandCollapse">
            	    
	                </asp:Panel>
	            </div>    
	        </ContentTemplate>
	    </asp:UpdatePanel>
	</asp:Panel>
	<asp:Panel ID="pnlNoDetails" runat="server" Visible="false">
	    <h3>No Additional Details Are Required</h3>
	    <asp:HyperLink ID="lnkContinue" runat="server" NavigateUrl="~/MyAZH/PostingPhotos.aspx">
	        <asp:Image ID="imgContinue" runat="server" ImageUrl="~/images/buttons/continue-white.gif" />
	    </asp:HyperLink>
	</asp:Panel>
</asp:Content>

