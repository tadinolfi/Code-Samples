<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FormFieldEditor.ascx.cs" Inherits="App_Controls_FormFieldEditor" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:UpdatePanel ID="pnlPanel" runat="server">
    <ContentTemplate>
        <asp:Panel ID="pnlWrapper" runat="server" Visible="false">
            <asp:Panel ID="pnlBG" runat="server" CssClass="modalBackground" Height="1200px"></asp:Panel>
            <asp:Panel ID="pnlAddField" runat="server" CssClass="modalPopup manualPopup" Width="500">
               <h3 id="formTitle" runat="server">Add Field</h3>
               <strong>Name:</strong>
               <asp:RequiredFieldValidator ID="reqAddFieldName" runat="server" ControlToValidate="txtAddFieldName" ErrorMessage="Please enter a name" Display="Dynamic" /><br />
               <asp:TextBox ID="txtAddFieldName" runat="server" ValidationGroup="formGroup<%= FormFieldID %>" /><br />
               <strong>Field Type:</strong><br />
               <asp:DropDownList ID="ddlAddFieldType" AutoPostBack="true" runat="server" DataSourceID="FieldTypeSource" DataTextField="Name" DataValueField="FieldTypeID" onselectedindexchanged="ddlAddFieldType_SelectedIndexChanged"></asp:DropDownList>
               <asp:LinqDataSource ID="FieldTypeSource" runat="server" ContextTypeName="DataClassesDataContext" Select="new (FieldTypeID, Name)" TableName="FieldTypes">
               </asp:LinqDataSource>
               <asp:HiddenField ID="hidSortOrder" runat="server" Value="0" />
               
               <asp:Panel ID="pnlSimpleField" runat="server">
                    <strong>Default Value:</strong><br />
                    <asp:TextBox ID="txtAddDefaultValue" runat="server" /><br />
                    <strong>Suffix:</strong><br />
                    <asp:TextBox ID="txtAddSuffix" runat="server" /><br />
               </asp:Panel>
               <asp:Panel ID="pnlYesNo" runat="server" Visible="false">
                    <strong>Default Value:</strong><br />
                    <asp:RadioButtonList ID="rblYesNo" runat="server">
                        <asp:ListItem Text="Yes" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                    </asp:RadioButtonList>
               </asp:Panel>
               <asp:Panel ID="pnlBoolean" runat="server" Visible="false">
                    <asp:CheckBox ID="chkDefault" runat="server" Text="Checked by Default" /><br />
               </asp:Panel>
               <asp:Panel ID="pnlList" runat="server" Visible="false">
                    <asp:Table ID="tblListValues" runat="server"></asp:Table>
                    <asp:TextBox ID="txtNewValue" runat="server" />
                    <asp:Button ID="butNewValue" runat="server" Text="Add Value" onclick="butNewValue_Click" CausesValidation="False" UseSubmitBehavior="False" />
                    <asp:HiddenField ID="hidValues" runat="server" />
               </asp:Panel>
               <asp:Panel ID="pnlAllFields" runat="server">
                    <asp:CheckBox ID="chkRequired" runat="server" Text="Required" /><br />
                    <asp:CheckBox ID="chkSearchable" runat="server" Text="Searchable" /><br />
                    <strong>Tool Tip:</strong>
                    <asp:TextBox ID="txtAddToolTip" runat="server" /><br />
               </asp:Panel>
               <asp:Button ID="butAddFormField" runat="server" Text="Add Field" onclick="butAddFormField_Click" />
               <asp:Button ID="butAddCancel" runat="server" Text="Cancel" CausesValidation="False" onclick="butAddCancel_Click" />
            </asp:Panel>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>