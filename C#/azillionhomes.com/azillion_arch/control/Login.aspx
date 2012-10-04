<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="control_Login" Title="Please Login" Theme="azh" %>

<%@ Register src="../App_Controls/Login.ascx" tagname="Login" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="preBody" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <uc1:Login ID="Login1" runat="server" LoginUrl="~/control/" />
    
</asp:Content>

