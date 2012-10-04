<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="MyBilling.aspx.cs" Inherits="myazh_MyBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <asp:Panel ID="pnlNoSubscription" runat="server" Visible="false">
        <h2>No Subscription</h2>
        <p>
            You are currently not an AZH subscriber. With a subscription, you can post and manage
            rentals, sales, open houses and auctions.
        </p>
        <asp:HyperLink ID="lnkCreateSubscription" runat="server" NavigateUrl="~/MyAZH/CreateSubscription.aspx">Create Subscription</asp:HyperLink>
    </asp:Panel>
    <asp:Panel ID="pnlHasSubscription" runat="server">
        <h2>Subscription Details</h2>
        <strong>Monthly Rate: </strong><asp:Label ID="lblRate" runat="server" /><br />
        <strong>Started On: </strong><asp:Label ID="lblStart" runat="server" /><br />
        <strong>Expires On: </strong><asp:Label ID="lblExpire" runat="server" /> - <asp:HyperLink ID="lnkRenew" runat="server" Text="renew" NavigateUrl="RenewSubscription.aspx" /><br />
        <asp:HyperLink ID="lnkCancel" runat="server" Text="Cancel Subscription" NavigateUrl="~/MyAZH/CancelSubscription.aspx" />
    </asp:Panel>
</asp:Content>

