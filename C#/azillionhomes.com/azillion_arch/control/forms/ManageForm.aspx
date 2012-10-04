<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="ManageForm.aspx.cs" Inherits="control_forms_ManageForm" Title="FormBuilder" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="../../App_Controls/FormFieldEditor.ascx" tagname="FormFieldEditor" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="ContentTop" ContentPlaceHolderID="preBody" runat="server">
    <uc1:FormFieldEditor ID="addEditor" runat="server" OnFieldAdded="addEditor_FieldAdded" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="pnlFormFields" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td valign="top">
                        <asp:GridView ID="grdSections" runat="server" AutoGenerateColumns="False" 
                            DataSourceID="FormSectionSource" DataKeyNames="FormSectionID" 
                            onselectedindexchanged="grdSections_SelectedIndexChanged" Width="200px">
                        
                            <Columns>
                                <asp:TemplateField ShowHeader="False" HeaderText="Select a Section">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                                            CommandName="Select" Text='<%# Eval("SectionName") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        
                        </asp:GridView>

                        <asp:LinqDataSource ID="FieldTypeSource" runat="server" 
                            ContextTypeName="DataClassesDataContext" Select="new (FieldTypeID, Name)" 
                            TableName="FieldTypes">
                        </asp:LinqDataSource>
                        <asp:LinqDataSource ID="FormSectionSource" runat="server" 
                            ContextTypeName="DataClassesDataContext" 
                            Select="new (SectionName, FormSectionID)" TableName="FormSections" 
                            Where="FormID == @FormID" OrderBy="SortOrder">
                            <WhereParameters>
                                <asp:QueryStringParameter Name="FormID" QueryStringField="formid" 
                                    Type="Int32" />
                            </WhereParameters>
                        </asp:LinqDataSource>
                        <asp:Button ID="butReturn" runat="server" CausesValidation="false" OnClick="butReturn_Click" Text="Return to Listing" />
                    </td>
                    <td valign="top">
                        <asp:Repeater ID="rptFields" runat="server" DataSourceID="FormFieldSource">
                            <AlternatingItemTemplate>
                                <div class="fieldBox altBox">
                                    <h3><asp:Label ID="lblFieldName" runat="server" Text='<%# Eval("Name") %>' /></h3>
                                    <strong><asp:Label ID="lblFieldType" runat="server" Text='<%# GetFieldType(Eval("FieldType")) %>' /></strong>
                                    <asp:Label ID="lblRequired" runat="server" Text=" Required" Visible='<%# Eval("Required") %>' />
                                    <asp:Button ID="butDelete" runat="server" CausesValidation="false" ForeColor="Red" Text="Delete Field" OnClick="butDelete_Click" CommandArgument='<%# Eval("FormFieldID") %>' />
                                    <div class="fieldButtons">
                                        <asp:Button ID="butMoveUp" runat="server" CausesValidation="false" Text="Move Up" OnClick="butMoveUp_Click" CommandArgument='<%# Eval("FormFieldID") %>' Enabled='<%# Convert.ToInt32(Eval("SortOrder")) > 1 %>' />
                                        <asp:Button ID="butEdit" runat="server" CausesValidation="false" Text="Edit Field" OnClick="butEdit_Click" CommandArgument='<%# Eval("FormFieldID") %>' />
                                        <asp:Button ID="butMoveDown" runat="server" CausesValidation="false" Text="Move Down" OnClick="butMoveDown_Click" CommandArgument='<%# Eval("FormFieldID") %>' Enabled='<%# Convert.ToInt32(Eval("SortOrder")) < MaxSortOrder %>' />
                                    </div>
                                </div>
                            </AlternatingItemTemplate>
                            <ItemTemplate>
                                <div class="fieldBox">
                                    <h3><asp:Label ID="lblFieldName" runat="server" Text='<%# Eval("Name") %>' /></h3>
                                    <strong><asp:Label ID="lblFieldType" runat="server" Text='<%# GetFieldType(Eval("FieldType")) %>' /></strong>
                                    <asp:Label ID="lblRequired" runat="server" Text=" Required" Visible='<%# Eval("Required") %>' />
                                    <asp:Button ID="butDelete" runat="server" CausesValidation="false" ForeColor="Red" Text="Delete Field" OnClick="butDelete_Click" CommandArgument='<%# Eval("FormFieldID") %>' />
                                    <div class="fieldButtons">
                                        <asp:Button ID="butMoveUp" runat="server" CausesValidation="false" Text="Move Up" OnClick="butMoveUp_Click" CommandArgument='<%# Eval("FormFieldID") %>' Enabled='<%# Convert.ToInt32(Eval("SortOrder")) > 1 %>' />
                                        <asp:Button ID="butEdit" runat="server" CausesValidation="false" Text="Edit Field" OnClick="butEdit_Click" CommandArgument='<%# Eval("FormFieldID") %>' />
                                        <asp:Button ID="butMoveDown" runat="server" CausesValidation="false" Text="Move Down" OnClick="butMoveDown_Click" CommandArgument='<%# Eval("FormFieldID") %>' Enabled='<%# Convert.ToInt32(Eval("SortOrder")) < MaxSortOrder %>' />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:LinqDataSource ID="FormFieldSource" runat="server" 
                            ContextTypeName="DataClassesDataContext" OrderBy="SortOrder" 
                            Select="new (FieldTypeID, FormFieldID, FormSectionID, Name, DefaultValue, AllowedValues, SortOrder, FieldType, Required)" 
                            TableName="FormFields" Where="FormSectionID == @FormSectionID">
                            <WhereParameters>
                                <asp:ControlParameter ControlID="grdSections" DefaultValue="0" Name="FormSectionID" PropertyName="SelectedValue" Type="Int32" />
                            </WhereParameters>
                        </asp:LinqDataSource>
                        <asp:Button ID="butAddField" runat="server" Text="Add Field" Enabled="false" 
                            onclick="butAddField_Click" />
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="prgUpdate" runat="server" AssociatedUpdatePanelID="pnlFormFields">
        <ProgressTemplate>
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

