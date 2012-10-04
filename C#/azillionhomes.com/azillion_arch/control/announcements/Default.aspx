﻿<%@ Page Title="" Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="control_announcements_Default" Theme="azh" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="preBody" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="pnlUpdate" runat="server">
        <ContentTemplate>
        
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" 
        DataSourceID="AnnouncementDataSource">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" ReadOnly="True" 
                SortExpression="Title" />
            <asp:BoundField DataField="Teaser" HeaderText="Teaser" ReadOnly="True" 
                SortExpression="Teaser" />
            <asp:TemplateField HeaderText="Author" SortExpression="UserInfoID">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# ((UserInfo)Eval("UserInfo")).FirstName %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Created" HeaderText="Created On" ReadOnly="True" 
                SortExpression="Created" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEdit" CommandArgument='<%# Eval("AnnouncementID") %>' runat="server" CausesValidation="false">Edit</asp:LinkButton> - 
                    <asp:LinkButton ID="lnkDelete" CommandArgument='<%# Eval("AnnouncementID") %>' runat="server" onclick="lnkDelete_Click" CausesValidation="false">Delete</asp:LinkButton>
                    <cc1:ModalPopupExtender ID="modalEdit" runat="server" BackgroundCssClass="modalBackground" DropShadow="false" TargetControlID="lnkEdit" PopupControlID="pnlEdit"></cc1:ModalPopupExtender>
                    <asp:Panel ID="pnlEdit" runat="server" CssClass="modalPopup" Width="500px">
                        <h3>Edit Announcement</h3>
                        <strong>Title: </strong><asp:RequiredFieldValidator ID="reqTitle" runat="server" ErrorMessage="Please enter a title"  Display="Dynamic" ControlToValidate="txtTitle" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' /><br />
                        <asp:TextBox ID="txtTitle" runat="server" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' Text='<%# Eval("Title") %>' /><br />
                        <strong>Teaser:</strong><br />
                        <asp:TextBox ID="txtTeaser" runat="server" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' TextMode="MultiLine" Text='<%# Eval("Teaser") %>' /><br />
                        <strong>Body: </strong><asp:RequiredFieldValidator ID="reqBody" runat="server" ErrorMessage="Please enter a body" Display="Dynamic" ControlToValidate="txtBody" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' /><br />
                        <asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' Text='<%# Eval("Body") %>' /><br />
                        <asp:Button ID="butEdit" runat="server" Text="Edit Announcement" onclick="butEdit_Click" CommandArgument='<%# Eval("AnnouncementID") %>' />
                        <asp:Button ID="butCancel" runat="server" Text="Cancel" CausesValidation="False" ValidationGroup='<%# "edit" + Eval("AnnouncementID") %>' />
                    </asp:Panel>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Button ID="butAddNew" runat="server" Text="Add New Announcement" 
                CausesValidation="False" />
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" PopupControlID="pnlAddNew" BackgroundCssClass="modalBackground" DropShadow="false" TargetControlID="butAddNew" >
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddNew" runat="server" CssClass="modalPopup" Width="500px">
        <h3>Add a New Announcement</h3>
        <strong>Title: </strong><asp:RequiredFieldValidator ID="reqTitle" runat="server" ErrorMessage="Please enter a title"  Display="Dynamic" ControlToValidate="txtTitle" ValidationGroup="add" /><br />
        <asp:TextBox ID="txtTitle" runat="server" ValidationGroup="add" /><br />
        <strong>Teaser:</strong><br />
        <asp:TextBox ID="txtTeaser" runat="server" ValidationGroup="add" 
            TextMode="MultiLine" /><br />
        <strong>Body: </strong><asp:RequiredFieldValidator ID="reqBody" runat="server" ErrorMessage="Please enter a body" Display="Dynamic" ControlToValidate="txtBody" ValidationGroup="add" /><br />
        <asp:TextBox ID="txtBody" runat="server" ValidationGroup="add" TextMode="MultiLine" /><br />
        <asp:Button ID="butAdd" runat="server" Text="Add Announcement" 
            onclick="butAdd_Click" />
        <asp:Button ID="butCancel" runat="server" Text="Cancel" 
            CausesValidation="False" ValidationGroup="add" />
    </asp:Panel>
    <asp:LinqDataSource ID="AnnouncementDataSource" runat="server" 
        ContextTypeName="DataClassesDataContext" OrderBy="Created desc" 
        Select="new (AnnouncementID, UserInfoID, Title, Created, Teaser, Body, UserInfo)" 
        TableName="Announcements" EnableDelete="True" EnableUpdate="True">
    </asp:LinqDataSource>
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
