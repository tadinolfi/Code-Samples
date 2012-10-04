<%@ Page Title="" Language="C#" MasterPageFile="~/MyAZH/dashboard.master" AutoEventWireup="true" CodeFile="CancelSubscription.aspx.cs" Inherits="MyAZH_CancelSubscription" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <h1 id="hdrMyBilling">
        <asp:Image ID="imgBilling" runat="server" ImageUrl="~/images/headers/billing-information.gif" />
    </h1>  
	<hr />
	<asp:Panel ID="pnlStart" runat="server">
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
	<asp:LinkButton ID="imgCancel" runat="server" Text="Cancel Subscription" />
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="imgCancel" PopupControlID="pnlConfirm" CancelControlID="butNo" DropShadow="true" BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlConfirm" runat="server" Width="500px" CssClass="modalPopup">
        <h3>Cancel Confirmation</h3>
        <p>Are you sure that you would like to cancel your subscription to A Zillion Homes?</p>
        <asp:Button ID="butCancelSubcription" runat="server" Text="Yes, Cancel My Subscription" onclick="imgCancel_Click" />
        <asp:Button ID="butNo" runat="server" Text="No, DO NOT Cancel My Subscription" />
    </asp:Panel>
	</asp:Panel>
    	<asp:Panel ID="pnlSuccess" runat="server" Visible="false">
	<p>Your subscription has been cancelled and you will no longer be billed. You can continue posting until the end your current billing cycle on <asp:Label ID="lblDate" runat="server" /></p>
	<asp:HyperLink ID="lnkReturn" runat="server" Text="Return to Dashboard" NavigateUrl="~/MyAZH/Default.aspx" />
	</asp:Panel>
	<asp:Panel ID="pnlCancelled" runat="server" Visible="false">
	<p>Your subscription has already been cancelled and you will no longer be billed. You can continue posting until the end your current billing cycle on <asp:Label ID="lblCancelDate" runat="server" /></p>
	<asp:HyperLink ID="lnkReturn2" runat="server" Text="Return to Dashboard" NavigateUrl="~/MyAZH/Default.aspx" />
	</asp:Panel>
	<asp:Panel ID="pnlFree" runat="server" Visible="false">
	<p>You are currently using a free subscription which will expire on <asp:Label ID="lblFreeDate" runat="server" /></p>
	<asp:HyperLink ID="lnkReturn3" runat="server" Text="Return to Dashboard" NavigateUrl="~/MyAZH/Default.aspx" />
	</asp:Panel>
</asp:Content>

