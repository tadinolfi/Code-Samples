<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="EditForm.aspx.cs" Inherits="control_forms_EditForm" Title="Edit Form Sections" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table>
        <tr>
            <td valign="top">
                <asp:UpdatePanel ID="pnlUpdateWrapper" runat="server">
                    <ContentTemplate>
                    <asp:Panel ID="pnlFormEditor" runat="server" DefaultButton="butSubmit">
                        <table>
                            <tr>
                                <td colspan="3">
                                <asp:Label ID="lblMessage" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Name:</strong></td>
                                <td><asp:TextBox ID="txtName" runat="server" ValidationGroup="Form"></asp:TextBox></td>
                                <td><asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txtName" ErrorMessage="Please enter a name" Display="Dynamic" /></td>
                            </tr>
                            <tr>
                                <td><strong>Description:</strong></td>
                                <td colspan="2"><asp:RequiredFieldValidator ID="reqDescription" runat="server" ControlToValidate="txtDescription" ErrorMessage="Please enter a description" Display="Dynamic" /></td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" 
                                        Width="400" Height="300" ValidationGroup="Form" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <asp:CheckBox ID="chkActive" runat="server" Text="Active" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <asp:Button ID="butSubmit" runat="server" Text="Edit Form" 
                                        ValidationGroup="Form" onclick="butSubmit_Click" />
                                    <asp:Button ID="butCancel" runat="server" Text="Return to Listing" 
                                        CausesValidation="False" onclick="butCancel_Click" />
                                    <asp:Button ID="butManager" runat="server" OnClick="butManager_Click" Text="Go to Form Manager" CausesValidation="false" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
            <td valign="top">
                <asp:UpdatePanel ID="pnlSecions" runat="server" >
                <ContentTemplate>
                <asp:GridView ID="grdSections" runat="server" 
                    AutoGenerateColumns="False" DataSourceID="FormSectionSource" >
                    <Columns>
                        <asp:BoundField DataField="SectionName" HeaderText="SectionName" 
                            ReadOnly="True" SortExpression="SectionName" />
                        <asp:CheckBoxField DataField="Active" HeaderText="Active" ReadOnly="True" 
                            SortExpression="Active" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" CommandName="Edit" runat="server">Edit</asp:LinkButton> 
                                - 
                                <asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="false" CommandArgument='<%# Eval("FormSectionID") %>' OnClick="lnkDelete_Click">Delete</asp:LinkButton>
                                -
                                <asp:LinkButton ID="lnkMoveUp" runat="server" CausesValidation="False" 
                                    CommandArgument='<%# Eval("FormSectionID") %>' OnClick="lnkMoveUp_Click" 
                                    Enabled="<%# ((FormSection)Container.DataItem).SortOrder > 1 %>">Up</asp:LinkButton>
                                |
                                <asp:LinkButton ID="lnkMoveDown" runat="server" CausesValidation="False" 
                                    CommandArgument='<%# Eval("FormSectionID") %>' OnClick="lnkMoveDown_Click" 
                                    Enabled="<%# ((FormSection)Container.DataItem).SortOrder < GetMaxSortOrder() %>">Down</asp:LinkButton>
                                <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="lnkEdit" PopupControlID="pnlEditSection" CancelControlID="butEditCancel" DropShadow="false" BackgroundCssClass="modalBackground" />
                                <asp:Panel ID="pnlEditSection" runat="server" CssClass="modalPopup" Width="500">
                                    <h3>Edit Form Section</h3>
                                    <strong>Name:</strong>
                                    <asp:RequiredFieldValidator ID="reqName" ControlToValidate="txtEditName" runat="server" ErrorMessage="Please enter a name" Display="Dynamic" /><br />
                                    <asp:TextBox ID="txtEditName" ValidationGroup='<%# "edit" + Eval("FormSectionID") %>' Text='<%# Eval("SectionName") %>' runat="server" /><br />
                                    <strong>Description:</strong>
                                    <asp:RequiredFieldValidator ID="reqEditDescription" runat="server" ControlToValidate="txtEditDescription" Display="Dynamic" ErrorMessage="Please enter a description" /><br />
                                    <asp:TextBox ID="txtEditDescription" ValidationGroup='<%# "edit" + Eval("FormSectionID") %>' Text='<%# Eval("Description") %>' runat="server" TextMode="MultiLine" Width="400" Height="300" /><br />
                                    <asp:CheckBox ID="chkEditActive" runat="server" Text="Active" Checked='<%# Eval("Active") %>' /><br />
                                    <asp:CheckBox ID="chkEditFirstPage" runat="server" Text="Show on First Page" Checked='<%# Eval("FirstPage") %>' /><br />
                                    <asp:Button ID="butUpdateSection" runat="server" Text="Update Section" CommandArgument= '<%# Eval("FormSectionID") %>' ValidationGroup='<%# "edit" + Eval("FormSectionID") %>' onclick="butUpdateSection_Click" />
                                    <asp:Button ID="butEditCancel" runat="server" Text="Cancel" CausesValidation="false" />
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                    <asp:ObjectDataSource ID="FormSectionSource" runat="server" 
                        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
                        SelectMethod="GetFormSectionsByFormId" TypeName="FormSectionAPI" 
                        UpdateMethod="Update">
                        <UpdateParameters>
                            <asp:Parameter Name="SectionName" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:Parameter Name="original_FormSectionID" Type="Int32" />
                        </UpdateParameters>
                        <SelectParameters>
                            <asp:QueryStringParameter Name="FormID" QueryStringField="formid" 
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="SectionName" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:Parameter Name="FormID" Type="Int32" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                <cc1:ModalPopupExtender ID="ModalPopupExtender1" BackgroundCssClass="modalBackground" DropShadow="false" TargetControlID="butAddSection" PopupControlID="pnlAddSection" CancelControlID="butCancelAdd" runat="server">
                </cc1:ModalPopupExtender>
                <asp:Button ID="butAddSection" runat="server" Text="Add Section" 
                    CausesValidation="False" />
                <asp:Panel ID="pnlAddSection" runat="server" CssClass="modalPopup" Width="500" DefaultButton="butInsertSection">
                    <strong>Name:</strong><asp:RequiredFieldValidator ID="reqSectionName" runat="server" ControlToValidate="txtSectionName" ErrorMessage="Please enter a section name" Display="Dynamic" /><br />
                    <asp:TextBox ID="txtSectionName" runat="server" ValidationGroup="AddSection" /><br />
                    <strong>Description:</strong><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtSectionDescription" ErrorMessage="Please enter a description" Display="Dynamic" /><br />
                    <asp:TextBox ID="txtSectionDescription" runat="server" TextMode="MultiLine"  ValidationGroup="AddSection" Width="400" Height="200px" /><br />
                    <asp:CheckBox ID="txtSectionActive" runat="server" Text="Active" ValidationGroup="AddSection" Checked="true" /><br />
                    <asp:Button ID="butInsertSection" runat="server" Text="Add Section" 
                        ValidationGroup="AddSection" onclick="butInsertSection_Click" />
                    <asp:Button ID="butCancelAdd" runat="server" Text="Cancel" CausesValidation="false" />
                </asp:Panel>
                </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>
</asp:Content>

