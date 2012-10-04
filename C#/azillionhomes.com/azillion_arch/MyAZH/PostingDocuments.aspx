<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="PostingDocuments.aspx.cs" Inherits="myazh_PostingDocuments" %>

<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>
<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>

<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <asp:ScriptManagerProxy ID="myProxy" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/includes/js/Uploader.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
	<uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
    
    <h4><asp:Label ID="lblPostingBreadCrumb" runat="server" /> &raquo; Documents</h4>
	    
	<asp:Panel ID="pnlImages" runat="server" CssClass="myPostingsForms paddedForm">
		
		<div class="topContentNote">
			<a href="#" class="helpIcon"></a>
			<strong>Note:</strong> Document files must be in one of the following document formats (.doc, .docx, .xls, .xlsx, .pdf, .rtf) format.
		</div>
		<div style="clear:both;">
		    <asp:Repeater ID="rptImages" runat="server" DataSourceID="FormImageDataSource" >
		        <ItemTemplate>
		            <asp:Panel ID="pnlFormImage" runat="server" CssClass="formImage">
		                <asp:Label ID="lblFileName" runat="server" Text='<%# "<strong>" + Eval("Name") + "</strong> - " + Eval("Filename") %>' />
		                <asp:LinkButton ID="butFileDelete" runat="server" Text="Delete" CommandArgument='<%# Eval("FormDocumentID") %>' OnClick="butFileDelete_Click" CssClass="linkButton delete_lm" />
		            </asp:Panel>
		        </ItemTemplate>
		    </asp:Repeater>
		    <asp:LinqDataSource ID="FormImageDataSource" runat="server" 
                ContextTypeName="DataClassesDataContext" OrderBy="SortOrder" 
                Select="new (FormDocumentID, Name, Filename)" TableName="FormDocuments" 
                Where="FormEntryID == @FormEntryID">
                <WhereParameters>
                    <asp:SessionParameter Name="FormEntryID" SessionField="formEntryId" Type="Int32" />
                </WhereParameters>
            </asp:LinqDataSource>
		</div>
		<div style="clear:both;"></div>
		    <telerik:RadProgressManager ID="RadProgressManager1" Runat="server" />
            <telerik:RadUpload ID="RadUpload1" runat="server" 
            InitialFileInputsCount="3" Skin="Web20" 
                ControlObjectsVisibility="None" InputSize="60" MaxFileSize="17000000" 
            AllowedFileExtensions=".doc,.docx,.pdf,.odf,.xls,.xlsx" Width="100%" OnClientAdded="addTitle">
                <Localization Select="Browse" />
            </telerik:RadUpload>
            <telerik:RadProgressArea ID="RadProgressArea1" runat="server" Skin="Web20" 
            ForeColor="#333333" Width="100%">
                <Localization Uploaded="Uploaded" />
            </telerik:RadProgressArea><br /><br />
		<asp:LinkButton ID="lnkUpload" runat="server" CssClass="linkButton uploaddocs" onclick="lnkUpload_Click">Upload Documents</asp:LinkButton>
        <asp:LinkButton ID="lnkContinue" runat="server" CssClass="linkButton continue_m" onclick="lnkContinue_Click">Continue</asp:LinkButton>
		<div style="clear:both;"></div>		
	</asp:Panel>
</asp:Content>


