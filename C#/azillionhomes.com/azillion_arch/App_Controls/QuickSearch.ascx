<%@ Control Language="C#" AutoEventWireup="true" CodeFile="QuickSearch.ascx.cs" Inherits="App_Controls_QuickSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Panel ID="pnlSearch" runat="server">
    	<asp:LinkButton ID="lnkClose" OnClick="closePanel" runat="server" CssClass="close">close &nbsp;&nbsp;&nbsp;&nbsp;</asp:LinkButton>
		<asp:TextBox ID="txtStart" runat="server" CssClass="minMax firstMinMax"></asp:TextBox>
		<cc1:CalendarExtender ID="calExtStart" runat="server" TargetControlID="txtStart" />
		<cc1:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server" TargetControlID="txtStart" WatermarkText="Start">
        </cc1:TextBoxWatermarkExtender>
		<asp:TextBox ID="txtEnd" runat="server" CssClass="minMax"></asp:TextBox>
		<cc1:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender2" runat="server" TargetControlID="txtEnd" WatermarkText="End">
        </cc1:TextBoxWatermarkExtender>
		<cc1:CalendarExtender ID="calExtEnd" runat="server" TargetControlID="txtEnd" />
		<asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Text="All Types" Value="0" />
        </asp:DropDownList>
        <asp:TextBox ID="txtZip" runat="server"></asp:TextBox>
        <cc1:TextBoxWatermarkExtender ID="watermarkZip" TargetControlID="txtZip" WatermarkText="Town, State or Zip Code" runat="server"></cc1:TextBoxWatermarkExtender>
        <asp:DropDownList CssClass="minMax" ID="ddlMin" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Text="No Min $" Value="0" />
        </asp:DropDownList>
        <asp:DropDownList CssClass="minMax" ID="ddlMax" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Text="No Max $" Value="0" />
        </asp:DropDownList>
        <asp:TextBox ID="txtKeyword" runat="server" />
        <cc1:TextBoxWatermarkExtender ID="watermarkKeyword" TargetControlID="txtKeyword" WatermarkText="AZH#" runat="server"></cc1:TextBoxWatermarkExtender>
		<asp:HyperLink CssClass="advancedSearchLink" ID="lnkAdvancedSearch" runat="server">advanced <strong>&raquo;</strong></asp:HyperLink>
		<asp:LinkButton ID="imgSearch" Text="Search" runat="server" CssClass="quickSearchButton linkButton search_d" ImageUrl="~/images/buttons/quick-search.gif" OnClick="imgSearch_Click" />
</asp:Panel>