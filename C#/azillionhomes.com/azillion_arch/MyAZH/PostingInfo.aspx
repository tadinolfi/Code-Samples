<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="PostingInfo.aspx.cs" Inherits="myazh_PostingInfo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>
<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>

<%@ Register src="../App_Controls/MultiDate.ascx" tagname="MultiDate" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
	<uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
	
	<h4><asp:Label ID="lblPostingBreadCrumb" runat="server" /> &raquo; Info</h4>
	<asp:Panel ID="pnlOnBehalf" runat="server" Visible="false">
	    <strong>Create posting under the following account:</strong>
	    <asp:DropDownList ID="ddlUserInfo" runat="server" AppendDataBoundItems="true">
	        <asp:ListItem Text="Post with my account" Value="0" />
	    </asp:DropDownList>
	</asp:Panel>
	<div class="myPostingsForms">
		<azh:AZHField ID="txtPrice" runat="server" FieldName="Price" Required="true" />
		<azh:AZHField ZIndex="100000" ID="txtDate" runat="server" FieldName="Date" Required="true" FormFieldType="Date" />
		<div id="divDate" runat="server" visible="false" class="formRow" style="z-index:99999;">
		    <uc3:MultiDate ID="MultiDate1" runat="server" />
		</div>
		<asp:Panel ID="pnlTimeStart" runat="server" CssClass="formRow">
		    <span class="required">*</span>
		    <label>Time Start:</label>
		    <asp:TextBox ID="txtStart" runat="server" />
            <cc1:MaskedEditExtender ID="maskStart" AutoComplete="true" MessageValidatorTip="true" runat="server" Mask="99:99" AcceptAMPM="true" MaskType="Time" TargetControlID="txtStart">
            </cc1:MaskedEditExtender>
		</asp:Panel>
		<asp:Panel ID="pnlTimeEnd" runat="server" CssClass="formRow">
		    <span class="required">*</span>
		    <label>Time End:</label>
		    &nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox ID="txtEnd" runat="server" />
            <cc1:MaskedEditExtender ID="maskEnd" AutoComplete="true" MessageValidatorTip="true" runat="server" AcceptAMPM="true" Mask="99:99" MaskType="Time" TargetControlID="txtEnd">
            </cc1:MaskedEditExtender>
		</asp:Panel>
		<azh:AZHField ID="txtNumber" ZIndex="99998" runat="server" FieldName="Street Number" ToolTip="Maps are only available for listings with a valid street number" AltRow="true" />
		<azh:AZHField ID="txtStreet" runat="server" FieldName="Street Name" Required="true" />
		<asp:UpdatePanel ID="pnlUpdate" runat="server">
		    <ContentTemplate>
		        <div class="formRow altRowColor">
		            <span class="required">*</span>
		            <label>Zip Code</label>
		            <asp:TextBox ID="txtZipCode" runat="server" AutoPostBack="true" OnTextChanged="txtZipCode_TextChanged"  />
		            <asp:RequiredFieldValidator CssClass="errorMessage" ID="reqZipCode" runat="server" ControlToValidate="txtZipCode" Display="Dynamic" ErrorMessage="Please enter a zip code" />
    		        </div>
		        <azh:AZHField ID="txtTown" runat="server" FieldName="Town" Required="true" />
        		
		        <div class="formRow altRowColor">
			        <span class="required">*</span>
			        <label for="state">State</label>
			        <asp:DropDownList ID="ddlState" runat="server" DataSourceID="LinqDataSource1" 
                        DataTextField="Name" DataValueField="StateID" AppendDataBoundItems="true">
			            <asp:ListItem Text="Select a State" Value="0" />
			        </asp:DropDownList>
		            <asp:LinqDataSource ID="LinqDataSource1" runat="server" 
                        ContextTypeName="DataClassesDataContext" OrderBy="Minor, Name" 
                        Select="new (StateID, Name)" TableName="States" Where="CountryID == @CountryID">
                        <WhereParameters>
                            <asp:Parameter DefaultValue="1" Name="CountryID" Type="Int32" />
                        </WhereParameters>
                    </asp:LinqDataSource>
		        </div>
		</ContentTemplate>
		</asp:UpdatePanel>
		<azh:AZHField ID="txtDirections" runat="server" MaxLength="2000" FieldName="Directions" Required="false" FormFieldType="TextBox:MultiLine" />
		<azh:AZHField ID="txtTotalRooms" runat="server" FieldName="Total Rooms" Requied="true" AltRow="true" ValueFormat="Number" />
		<azh:AZHField ID="txtBedrooms" runat="server" FieldName="Bedrooms" Required="true" ValueFormat="Number" />
		<azh:AZHField ID="txtBathrooms" runat="server" FieldName="Bathrooms" Required="true"  AltRow="true" ValueFormat="Number" />
		<azh:AZHField ID="txtDescription" runat="server" MaxLength="5000" Required="true" FieldName="Description" FormFieldType="TextBox:MultiLine" />
		
		<asp:Panel ID="pnlFields" runat="server">
		</asp:Panel>
				
		<div class="buttonRow">
			<asp:LinkButton ID="lnkContinue" runat="server" Text="Continue" CommandArgument="rental" CssClass="linkButton continue_m" OnClick="lnkPosting_Click" />
		</div>
		
		<div style="clear:both;"></div>
	</div>
	<div style="clear: both;"></div>
</asp:Content>

