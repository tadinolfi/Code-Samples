<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="ChoosePostingType.aspx.cs" Inherits="myazh_ChoosePostingType" %>

<%@ Register src="../App_Controls/PostingHeader.ascx" tagname="PostingHeader" tagprefix="uc1" %>
<%@ Register src="../App_Controls/PostingSidebar.ascx" tagname="PostingSidebar" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <uc1:PostingHeader ID="PostingHeader1" runat="server" />
	<uc2:PostingSidebar ID="PostingSidebar1" runat="server" />
	<asp:Panel ID="pnlChoosePosting" runat="server">
	    <h4>Select the type of posting you'd like to create.</h4>
	    <div id="postingTypesFocusArea">
    		
		    <div id="postingRental">
			    <p>If you would like to advertise the availability ofo a property for rent then start by selecting the type of available property from the drop down menu below and click continue.</p>
			    <asp:DropDownList ID="ddl1" runat="server" AppendDataBoundItems="True" ValidationGroup="rental">
			        <asp:ListItem Text="Select a Type" Value="0" />
			    </asp:DropDownList>
                <br />
			    <asp:CompareValidator ID="cmpRental" runat="server" ControlToValidate="ddl1" Display="Dynamic" ErrorMessage="Please select a type" Operator="NotEqual" ValueToCompare="0" ValidationGroup="rental" />
			    <asp:LinkButton ID="lnkRental" runat="server" Text="Continue" CommandArgument="1" CssClass="linkButton continue_m" OnClick="lnkPosting_Click" ValidationGroup="rental" />
		    </div>
    		
		    <div id="postingSale">
			    <p>If you are an owner or realtor and would like to advertise a piece of real estate for sale then begin by selecting the type of real estate from the drop down menu below and click continue.</p>
			    <asp:DropDownList ID="ddl2" runat="server" AppendDataBoundItems="True" ValidationGroup="sales">
			        <asp:ListItem Text="Select a Type" Value="0" />
			    </asp:DropDownList>
			    <br />
			    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="ddl2" Display="Dynamic" ErrorMessage="Please select a type" Operator="NotEqual" ValueToCompare="0" ValidationGroup="sales" />
			    <asp:LinkButton ID="lnkSale" runat="server" Text="Continue" CommandArgument="2" CssClass="linkButton continue_m" OnClick="lnkPosting_Click" ValidationGroup="sales" />
		    </div>
    		
		    <div id="postingOpenHouse">
			    <p>If you are a home owner or realtor and would like to advertise an open house then start by selecting the type of property the open house pertains to.</p>
			    <asp:DropDownList ID="ddl3" runat="server" AppendDataBoundItems="True" ValidationGroup="openhouse">
			        <asp:ListItem Text="Select a Type" Value="0" />
			    </asp:DropDownList>
			    <br />
			    <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="ddl3" Display="Dynamic" ErrorMessage="Please select a type" Operator="NotEqual" ValueToCompare="0" ValidationGroup="openhouse" />
			    <asp:LinkButton ID="lnkOpenhouse" runat="server" Text="Continue" CommandArgument="3" CssClass="linkButton continue_m" OnClick="lnkPosting_Click" ValidationGroup="openhouse" />
		    </div>
    		
		    <div id="postingAuctions">
			    <p>If you are a realtor or <a href="#">Certified Auctioneer</a> and would like to advertise a home or piece of real estate for auction then start by selecting the type in the drop down menu below.</p>
			    <asp:DropDownList ID="ddl4" runat="server" AppendDataBoundItems="True" ValidationGroup="auction">
			        <asp:ListItem Text="Select a Type" Value="0" />
			    </asp:DropDownList>
			    <br />
			    <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="ddl4" Display="Dynamic" ErrorMessage="Please select a type" Operator="NotEqual" ValueToCompare="0" ValidationGroup="auction" />
			    <asp:LinkButton ID="lnkAuctions" runat="server" Text="Continue" CommandArgument="4" CssClass="linkButton continue_m" OnClick="lnkPosting_Click" ValidationGroup="auction" />
		    </div>
    		
		    <div style="clear:both;"></div>
		    <asp:LinqDataSource ID="PostingType" runat="server" ContextTypeName="DataClassesDataContext" Select="new (FormID, Name)" TableName="Forms" Where="Active == @Active">
                <WhereParameters>
                    <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                </WhereParameters>
            </asp:LinqDataSource>
	    </div>
	  </asp:Panel>
</asp:Content>

