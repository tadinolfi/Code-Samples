<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="PostingPhotos.aspx.cs" Inherits="myazh_PostingPhotos" Theme="azh" %>

<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>
<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <asp:ScriptManagerProxy ID="myProxy" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/includes/js/Uploader.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
	<uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
    
    <h4><asp:Label ID="lblPostingBreadCrumb" runat="server" /> &raquo; Photos</h4>
	    
	<asp:Panel ID="pnlImages" runat="server" CssClass="myPostingsForms paddedForm">
		
		<div class="topContentNote">
			<azh:HelpButton ID="hlpPhotos" runat="server" Title="Image Tips" Message="For the best image quality, please upload photos without resizing them. Images will be automatically resized and low quality images may become blurry." />
			<strong>Note:</strong> Digital photo files must be in JPEG (.jpg, .jpeg) format. Each listing can have up to 12 images.
		</div>
		<asp:Panel ID="pnlMax" runat="server" Visible="false">
		    <br />
		    <strong>You have uploaded the maximum number of photos (12).</strong>
		    <br />
		</asp:Panel>
		<div style="clear:both;">
		    <asp:Repeater ID="rptImages" runat="server" DataSourceID="FormImageDataSource">
		        <ItemTemplate>
		            <asp:Panel ID="pnlFormImage" runat="server" CssClass="formImage">
		                <asp:Image ID="imgForm" runat="server" ImageUrl='<%# ConfigurationManager.AppSettings["imagesdir"] + "icons/" + Eval("filename") %>' /><br />
		                <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Caption") %>' /><br />
		                <asp:LinkButton ID="butImgDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FormImageID") %>' OnClick="butImgDelete_Click" CssClass="linkButton delete_lm" />
		            </asp:Panel>
		        </ItemTemplate>
		    </asp:Repeater>
		    <asp:LinqDataSource ID="FormImageDataSource" runat="server" ContextTypeName="DataClassesDataContext" OrderBy="SortOrder" Select="new (Filename, Caption, SortOrder, FormImageID)" TableName="FormImages" Where="FormEntryID == @FormEntryID">
                <WhereParameters>
                    <asp:SessionParameter Name="FormEntryID" SessionField="formEntryId" Type="Int32" />
                </WhereParameters>
            </asp:LinqDataSource>
		</div>
		<div style="clear:both;"></div>
		    <telerik:RadProgressManager ID="RadProgressManager1" Runat="server" />
            <telerik:RadUpload ID="RadUpload1" runat="server" 
            InitialFileInputsCount="3" Skin="Web20" 
                ControlObjectsVisibility="AddButton" InputSize="60" MaxFileSize="17000000" 
            AllowedFileExtensions=".jpg,.jpeg" Width="100%" OnClientAdded="addTitle">
                <Localization Select="Browse" Add="Upload More Files" />
            </telerik:RadUpload>
            <telerik:RadProgressArea ID="RadProgressArea1" runat="server" Skin="Web20" ForeColor="#333333" Width="100%">
                <Localization Uploaded="Uploaded" />
            </telerik:RadProgressArea><br /><br />
		
		<asp:LinkButton ID="lnkUpload" runat="server" CssClass="linkButton floatButton uploadphotos" onclick="lnkUpload_Click">Upload Photos</asp:LinkButton>
        <asp:LinkButton ID="lnkContinue" runat="server" CssClass="linkButton floatButton continue_m" onclick="lnkContinue_Click">Continue</asp:LinkButton>
		
		<div style="clear:both;"></div>		
	</asp:Panel>
</asp:Content>

