<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="control_forms_Default" Title="Form Manager" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="pnlUpdate" runat="server">
    <ContentTemplate>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="FormsDataSource" Width="900px">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" 
                    SortExpression="Name" ReadOnly="True" >
                    <ItemStyle Width="250px" />
                </asp:BoundField>
                <asp:BoundField DataField="Description" HeaderText="Description" 
                    ReadOnly="True" SortExpression="Description" />
                <asp:CheckBoxField DataField="Active" HeaderText="Active" 
                    SortExpression="Active" ReadOnly="True" >
                    <ItemStyle Width="125px" />
                </asp:CheckBoxField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:HyperLink ID="HyperLink1" runat="server" 
                            NavigateUrl='<%# "EditForm.aspx?formid=" + Eval("FormID") %>'>Edit</asp:HyperLink> 
                        - 
                        <asp:HyperLink ID="HyperLink2" runat="server" 
                            NavigateUrl='<%# "ManageForm.aspx?formid=" + Eval("FormID") %>'>FormBuilder</asp:HyperLink>
                    </ItemTemplate>
                    <ItemStyle Width="125px" CssClass="lastColumn" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:LinqDataSource ID="FormsDataSource" runat="server" 
            ContextTypeName="DataClassesDataContext" OrderBy="Name" 
            Select="new (FormID, Name, Description, Active)" TableName="Forms">
        </asp:LinqDataSource>
        <asp:Button ID="butAddForm" runat="server" CausesValidation="false" Text="Add New Form" />
        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="butAddForm" PopupControlID="pnlAdd" CancelControlID="butAddCancel" BackgroundCssClass="modalBackground" DropShadow="false">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlAdd" runat="server" CssClass="modalPopup" Width="450">
            <h3>Add New Form</h3>
            <strong>Name:</strong><asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txtName" ErrorMessage="Please enter a name" Display="Dynamic" /><br />
            <asp:TextBox ID="txtName" runat="server"></asp:TextBox><br />
            <strong>Description:</strong>
            <asp:RequiredFieldValidator ID="reqDescription" runat="server" ControlToValidate="txtDescription" ErrorMessage="Please enter a description" Display="Dynamic" /><br />
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="400" Height="300" /><br />
            <asp:CheckBox ID="chkActive" runat="server" Text="Active" Checked="true" /><br />
            <asp:Button ID="butInsertForm" runat="server" Text="Add Form" 
                onclick="butInsertForm_Click" />
            <asp:Button ID="butAddCancel" CausesValidation="false" runat="server" Text="Cancel" />
        </asp:Panel>
    </ContentTemplate>    
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

