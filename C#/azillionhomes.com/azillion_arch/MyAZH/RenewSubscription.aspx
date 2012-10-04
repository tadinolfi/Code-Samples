<%@ Page Title="" Language="C#" MasterPageFile="~/MyAZH/dashboard.master" AutoEventWireup="true" CodeFile="RenewSubscription.aspx.cs" Inherits="MyAZH_RenewSubscription" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <h3>Subscription Renewal</h3>
    <asp:Panel ID="pnlRenew" runat="server">
        <ul>
            <li>You can cancel at anytime by going to Billing Information under My Account.</li>
            <li>By choosing to renew your subscription, your account will be active for one (1) year beginning today, automatically billed every month for the next 12 months.</li>
            <li>After that one (1) year is complete (referred to as Expiration Date), you can then renew for another 12 months.</li>
        </ul>
        <p>Would you like to renew?</p>
        <asp:HyperLink ID="butYes" runat="server" Text="Yes" CssClass="linkButton floatButton yes" NavigateUrl="~/MyAZH/CreateSubscription.aspx" />
        <asp:HyperLink ID="butNo" runat="server" Text="No" CssClass="linkButton floatButton no" NavigateUrl="~/MyAZH/Default.aspx" />
    </asp:Panel>
    <asp:Panel ID="pnlNoRenew" runat="server">
        Your subscription has 12 months remaining. You are at the maximum subscription length and cannot renew at this time.
    </asp:Panel>
</asp:Content>

