<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="control_coupons_Default" Title="Coupon Manager" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="preBody" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Label ID="lblMessage" runat="server" />
            <asp:GridView ID="grdCoupons" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="CouponDataSource" Width="100%">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="True" SortExpression="Name" />
                    <asp:BoundField DataField="CouponCode" HeaderText="CouponCode" ReadOnly="True" SortExpression="CouponCode" />
                    <asp:BoundField DataField="CouponType" HeaderText="CouponType" ReadOnly="True" SortExpression="CouponType" />
                    <asp:BoundField DataField="CouponAmount" HeaderText="CouponAmount" ReadOnly="True" SortExpression="CouponAmount" />
                    <asp:BoundField DataField="Used" HeaderText="Times Used" 
                        SortExpression="Used" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="false">Edit</asp:LinkButton> -  
                            <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="lnkEdit" PopupControlID="pnlEditCoupon" BackgroundCssClass="modalBackground" DropShadow ="false" />
                            <asp:Panel ID="pnlEditCoupon" runat="server" CssClass="modalPopup" Width="500px">
                                <strong>Name:</strong><asp:RequiredFieldValidator ValidationGroup='<%# "edit" + Eval("CouponID") %>' ID="reqEditName" runat="server" ControlToValidate="txtEditName" Display="Dynamic" ErrorMessage="Please enter a name" /><br />
                                <asp:TextBox ValidationGroup='<%# "edit" + Eval("CouponID") %>' ID="txtEditName" runat="server" Text='<%# Eval("Name") %>' /><br />
                                
                                <strong>Description:</strong><br />
                                <asp:TextBox ID="txtEditDescription"  ValidationGroup='<%# "edit" + Eval("CouponID") %>' runat="server" TextMode="MultiLine" Text='<%# Eval("Description") %>' /><br />
                                
                                <strong>Coupon Code:</strong><asp:RequiredFieldValidator ValidationGroup='<%# "edit" + Eval("CouponID") %>' ID="reqEditCoupon" runat="server" ControlToValidate="txtEditCode" Display="Dynamic" ErrorMessage="Please enter a coupon code" /><br />
                                <asp:TextBox ID="txtEditCode" runat="server" ValidationGroup='<%# "edit" + Eval("CouponID") %>' Text='<%# Eval("CouponCode") %>' /><br />
                                
                                <strong>Coupon Type:</strong><br />
                                <asp:DropDownList ID="ddlEditType" ValidationGroup='<%# "edit" + Eval("CouponID") %>' runat="server" SelectedValue='<%# Eval("CouponType") %>'>
                                    <asp:ListItem Text="Free Months" Value="month" />
                                    <asp:ListItem Text="Dollar Value" Value="value" />
                                    <asp:ListItem Text="Percentage" Value="percent" />
                                </asp:DropDownList><br />
                                
                                <strong>Coupon Amount:</strong><br />
                                <asp:TextBox ID="txtEditAmount" ValidationGroup='<%# "edit" + Eval("CouponID") %>' runat="server" Text='<%# Eval("CouponAmount") %>' /><br />
                                <asp:CompareValidator ID="cmpAmount" runat="server" ControlToValidate="txtEditAmount" ValidationGroup='<%# "edit" + Eval("CouponID") %>' Operator="DataTypeCheck" Type="Integer" ErrorMessage="Amount must be a whole number value" />
                                <asp:RequiredFieldValidator ID="reqAmount" runat="server" ControlToValidate="txtEditAmount" ErrorMessage="Please enter an amount" ValidationGroup='<%# "edit" + Eval("CouponID") %>' />
                                
                                <strong>Uses:</strong> <small>Enter 0 for unlimited uses</small><br />
                                <asp:TextBox ID="txtEditUses" ValidationGroup='<%# "edit" + Eval("CouponID") %>' runat="server" Text='<%# Eval("TotalUses") %>' /><br />
                                
                                <strong>Expires:</strong><small>Leave blank for no expiration.</small><br />
                                <asp:TextBox ID="txtExpires" ValidationGroup='<%# "edit" + Eval("CouponID") %>' runat="server" Text='<%# GetDate(Eval("Expires")) %>' /><br />
                                <cc1:CalendarExtender ID="extExpire" runat="server" TargetControlID="txtExpires" /> 
                                
                                <asp:Button ID="butEdit" runat="server" Text="Edit Coupon" ValidationGroup='<%# "edit" + Eval("CouponID") %>' CommandArgument='<%# Eval("CouponID") %>' onclick="butEdit_Click" />
                                <asp:Button ID="butEditCancel" runat="server" Text="Cancel" CausesValidation="false" />
                            </asp:Panel>
                            <asp:LinkButton ID="lnkReset" runat="server" CausesValidation="false" OnClick="lnkReset_Click" CommandArgument='<%# Eval("CouponID") %>' Text="Reset Uses" Enabled='<%# Eval("TotalUses") != "0" %>' /> -
                            <asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="false">Delete</asp:LinkButton>
                            <cc1:ModalPopupExtender ID="delPopup" runat="server" TargetControlID="lnkDelete" PopupControlID="pnlDelete" CancelControlID="butCancelDelete" BackgroundCssClass="modalBackground" DropShadow="false" />
                            <asp:Panel ID="pnlDelete" runat="server" CssClass="modalPopup" Width="500px">
                                <h3>Delete Confirmation</h3>
                                <p>Are you sure you want to delete this coupon? It cannot be undone.</p>
                                <asp:Button ID="butYes" CommandArgument='<%# Eval("CouponID") %>' runat="server" Text="Yes" onclick="butYes_Click" />
                                <asp:Button ID="butCancelDelete" runat="server" Text="No" />
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Button ID="butAddCoupon" runat="server" Text="Add Coupon" CausesValidation="false" />
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="butAddCoupon" PopupControlID="pnlAddCoupon" BackgroundCssClass="modalBackground" DropShadow="false">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="pnlAddCoupon" runat="server" Width="500px" CssClass="modalPopup">
                <strong>Name:</strong><asp:RequiredFieldValidator ValidationGroup="addCoupon" ID="reqName" runat="server" ControlToValidate="txtAddName" Display="Dynamic" ErrorMessage="Please enter a name" /><br />
                <asp:TextBox ValidationGroup="addCoupon" ID="txtAddName" runat="server" /><br />
                <strong>Description:</strong><br />
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"  ValidationGroup="addCoupon"/><br />
                <strong>Coupon Code:</strong><asp:RequiredFieldValidator ValidationGroup="addCoupon" ID="reqCoupon" runat="server" ControlToValidate="txtAddCode" Display="Dynamic" ErrorMessage="Please enter a coupon code" /><br />
                <asp:TextBox ID="txtAddCode" runat="server" ValidationGroup="addCoupon" /><br />
                <strong>Coupon Type:</strong><br />
                <asp:DropDownList ID="ddlType" ValidationGroup="addCoupon" runat="server">
                    <asp:ListItem Text="Free Months" Value="month" />
                    <asp:ListItem Text="Free Listings" Value="listing" />
                    <asp:ListItem Text="Dollar Value" Value="value" />
                    <asp:ListItem Text="Percentage" Value="percent" />
                </asp:DropDownList><br />
                <strong>Coupon Amount:</strong><br />
                <asp:TextBox ID="txtAmount" ValidationGroup="addCoupon" runat="server" /><br />
                    <asp:CompareValidator Display="Dynamic" ID="cmpAddAmount" runat="server" ControlToValidate="txtAmount" ValidationGroup='addCoupon' Operator="DataTypeCheck" Type="Integer" ErrorMessage="Amount must be a whole number value" />
                    <asp:RequiredFieldValidator Display="Dynamic" ID="reqAddAmount" runat="server" ControlToValidate="txtAmount" ErrorMessage="Please enter an amount" ValidationGroup='addCoupon' /><br />
                <strong>Uses:</strong> <small>Enter 0 for unlimited uses</small><br />
                <asp:TextBox ID="txtUses" ValidationGroup="addCoupon" runat="server" Text="0" /><br />
                <strong>Expires:</strong><small>Leave blank for no expiration.</small><br />
                <asp:TextBox ID="txtAddExpires" ValidationGroup="addCoupon" runat="server" /><br />
                <cc1:CalendarExtender ID="extAddExpire" runat="server" TargetControlID="txtAddExpires" /> 
                <asp:Button ID="butAdd" runat="server" Text="Add Coupon" 
                    ValidationGroup="addCoupon" onclick="butAdd_Click" />
                <asp:Button ID="butAddCancel" runat="server" Text="Cancel" CausesValidation="false" />
            </asp:Panel>
            <asp:LinqDataSource ID="CouponDataSource" runat="server" 
                ContextTypeName="DataClassesDataContext" OrderBy="CouponID desc" 
                Select="new (CouponID, Name, Description, CouponCode, CouponType, CouponAmount, TotalUses, Used, Expires)" 
                TableName="Coupons">
            </asp:LinqDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <asp:Image ID="imgLoader" runat="server" ImageUrl="~/images/ajax-loader.gif" />
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

