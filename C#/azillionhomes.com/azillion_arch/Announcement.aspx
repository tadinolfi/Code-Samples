<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Announcement.aspx.cs" Inherits="Announcement_Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1><span>About Us</span></h1>
    <div id="innerContent">
    <h2><asp:Label ID="lblTitle" runat="server"></asp:Label></h2>
    <h3>Posted on <asp:Label ID="lblDate" runat="server"></asp:Label></h3>
    <h3>By <asp:Label ID="lblAuthor" runat="server"></asp:Label></h3>
    <asp:Literal ID="litBody" runat="server" />
    </div>
</asp:Content>

