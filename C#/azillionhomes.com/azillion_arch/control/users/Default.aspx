<%@ Page Language="C#" MasterPageFile="~/control/control.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="control_users_Default" Title="User Management" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="preBody" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="pnlUsers" runat="server">
    <ContentTemplate>
    
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="UserDataSource" Width="100%">
        <Columns>
            <asp:TemplateField HeaderText="Name" SortExpression="FirstName">
                <ItemTemplate>
                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("FirstName") + " " + Eval("LastName") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Email" HeaderText="Email" ReadOnly="True" SortExpression="Email" />
            <asp:BoundField DataField="Login" HeaderText="Login" ReadOnly="True" SortExpression="Login" />
            <asp:BoundField DataField="Created" HeaderText="Created" 
                SortExpression="Created" DataFormatString="{0:d}" />
            <asp:BoundField DataField="LastLogin" HeaderText="Last Login" ReadOnly="True" 
                SortExpression="LastLogin" DataFormatString="{0:d}" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="lnkUpdate" CausesValidation="false" runat="server">Update 
                    User</asp:LinkButton> -
                    <asp:LinkButton ID="lnkSecurity" CausesValidation="false" runat="server">Security 
                    Info</asp:LinkButton> -
                    <asp:LinkButton ID="lnkDeactivate" CausesValidation="false" CommandArgument='<%# Eval("UserInfoID") %>' Text='<%# (Convert.ToBoolean(Eval("Active")) ? "Deactivate" : "Activate") %>' runat="server" onclick="lnkDeactivate_Click"></asp:LinkButton>
                    
                    <cc1:ModalPopupExtender ID="modalEdit" TargetControlID="lnkUpdate" PopupControlID="pnlEditUser" runat="server" DropShadow="false" BackgroundCssClass="modalBackground">
                    </cc1:ModalPopupExtender>
                    
                    <asp:Panel ID="pnlEditUser" runat="server" CssClass="modalPopup" Width="500px">
                        <h3>Edit User</h3>
                        <strong>User Type:</strong><br />
                        <asp:DropDownList ID="ddlUserType" runat="server" 
                            DataSourceID="UserTypeDataSource" DataTextField="TypeName" 
                            DataValueField="UserTypeID" SelectedValue='<%# Eval("UserTypeID") %>'>
                        </asp:DropDownList><br />
                        <asp:LinqDataSource ID="UserTypeDataSource" runat="server" ContextTypeName="DataClassesDataContext" OrderBy="TypeName" Select="new (UserTypeID, TypeName)" TableName="UserTypes">
                        </asp:LinqDataSource>
                        
                        <strong>Agency:</strong><br />
                        <asp:DropDownList ID="ddlAgency" runat="server" AppendDataBoundItems="True" 
                            DataSourceID="AgencyDataSource" DataTextField="Name" DataValueField="AgencyID" 
                            SelectedValue='<%# Eval("AgencyID") %>'>
                            <asp:ListItem Text="No Agency" Value="0" />
                        </asp:DropDownList><br />
                        <asp:LinqDataSource ID="AgencyDataSource" runat="server" ContextTypeName="DataClassesDataContext" OrderBy="Name" Select="new (AgencyID, Name)" TableName="Agencies">
                        </asp:LinqDataSource>
                        
                        <strong>Login:</strong><asp:RequiredFieldValidator ID="reqLogin" ControlToValidate="txtLogin" runat="server" Display="Dynamic" ErrorMessage="Please enter a login" ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        <asp:TextBox ID="txtLogin" runat="server" Text='<%# Eval("Login") %>' ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>First:</strong><asp:RequiredFieldValidator ID="reqFirstName" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" ErrorMessage="Please enter a first name" ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        <asp:TextBox ID="txtFirstName" runat="server" Text='<%# Eval("FirstName") %>' ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Last:</strong><asp:RequiredFieldValidator ID="reqLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" ErrorMessage="Please enter a last name" ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        <asp:TextBox ID="txtLastName" runat="server" Text='<%# Eval("LastName") %>' ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Email:</strong>
                        <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="Please enter an e-mail address" ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' />
                        <asp:RegularExpressionValidator ID="regEmail" runat="server" 
                            ControlToValidate="txtEmail" Display="Dynamic" 
                            ErrorMessage="That e-mail address is not valid" 
                            ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' 
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" /><br />
                        <asp:TextBox ID="txtEmail" runat="server" Text='<%# Eval("Email") %>' ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' /><br />
                        
                        <asp:Button ID="butEdit" runat="server" Text="Edit" CommandArgument='<%# Eval("UserInfoID") %>' OnClick="butEdit_Click" ValidationGroup='<%# "valEdit" + Eval("UserInfoID") %>' />
                        <asp:Button ID="butCancel" runat="server" Text="Cancel" CausesValidation="false" />
                    </asp:Panel>
                    
                    <cc1:ModalPopupExtender ID="modalSecurity" TargetControlID="lnkSecurity" runat="server" PopupControlID="pnlSecurity" DropShadow="false" BackgroundCssClass="modalBackground">
                    </cc1:ModalPopupExtender>
                    
                    <asp:Panel ID="pnlSecurity" runat="server" Width="500px" CssClass="modalPopup">
                        <h3>Edit Security</h3>
                        <strong>Password:</strong>
                        <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ErrorMessage="Please enter a password" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  /><br />
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"  ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Confirm Password:</strong>
                        <asp:RequiredFieldValidator ID="reqConfimPassword" runat="server" ControlToValidate="txtConfirmPassword" Display="Dynamic" ErrorMessage="Please enter a password" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  />
                        <asp:CompareValidator ID="cmpPassword" runat="server" Display="Dynamic" ErrorMessage="Passwords do not match" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" Operator="Equal" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  /><br />
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"  ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Security Question:</strong>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter a security question" ControlToValidate="txtQuestion" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  Display="Dynamic"></asp:RequiredFieldValidator><br />
                        <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Text='<%# Eval("SecurityQuestion") %>'  ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Security Answer:</strong>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtAnswer" runat="server" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  ErrorMessage="Please enter an answer to your security question" Display="Dynamic"></asp:RequiredFieldValidator><br />
                        <asp:TextBox ID="txtAnswer" runat=server TextMode="Password"  ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' /><br />
                        
                        <strong>Confirm Answer:</strong>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please confirm your answer" ControlToValidate="txtConfirmAnswer" Display="Dynamic" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' ></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic" ErrorMessage="Answers do not match" ControlToCompare="txtAnswer" ControlToValidate="txtConfirmAnswer" Operator="Equal" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>'  /><br />
                        <asp:TextBox ID="txtConfirmAnswer" runat=server TextMode="Password"  ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' /><br />
                        
                        <asp:Button ID="butEditSecurity" runat="server" CommandArgument='<%# Eval("UserInfoID") %>' Text="Edit" ValidationGroup='<%# "valSecure" + Eval("UserInfoID") %>' onclick="butEditSecurity_Click" />
                        <asp:Button ID="butCancelSecurity" runat="server" Text="Cancel" CausesValidation="false" />
                    </asp:Panel>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Button ID="butAddModal" runat="server" Text="Add User" />
    <cc1:ModalPopupExtender ID="modalAddField" runat="server" DropShadow="false" BackgroundCssClass="modalBackground" TargetControlID="butAddModal" PopupControlID="pnlAddField"></cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddField" runat="server" CssClass="modalPopup" Width="500px">
        <h3>Add User</h3>
        <strong>User Type:</strong><br />
        <asp:DropDownList ID="ddlUserType" runat="server" DataSourceID="UserTypeDataSource" DataTextField="TypeName" DataValueField="UserTypeID">
        </asp:DropDownList><br />
        <asp:LinqDataSource ID="UserTypeDataSource" runat="server" ContextTypeName="DataClassesDataContext" OrderBy="TypeName" Select="new (UserTypeID, TypeName)" TableName="UserTypes">
        </asp:LinqDataSource>
        
        <strong>Agency:</strong><br />
        <asp:DropDownList ID="ddlAgency" runat="server" AppendDataBoundItems="True" DataSourceID="AgencyDataSource" DataTextField="Name" DataValueField="AgencyID">
            <asp:ListItem Text="No Agency" Value="0" />
        </asp:DropDownList><br />
        <asp:LinqDataSource ID="AgencyDataSource" runat="server" ContextTypeName="DataClassesDataContext" OrderBy="Name" Select="new (AgencyID, Name)" TableName="Agencies">
        </asp:LinqDataSource>
        
        <strong>Login:</strong>
        <asp:RequiredFieldValidator ID="reqLogin" runat="server" ControlToValidate="txtLogin" Display="Dynamic" ErrorMessage="Please enter a Login" ValidationGroup="addUser" /><br />
        <asp:TextBox ID="txtLogin" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>Password:</strong>
        <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ErrorMessage="Plese enter password" ValidationGroup="addUser" /><br />
        <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>Confirm Password:</strong>
        <asp:RequiredFieldValidator ID="reqConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" Display="Dynamic" ErrorMessage="Please confirm the password" ValidationGroup="addUser" /> 
        <asp:CompareValidator ID="cmpPassword" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" Display="Dynamic" ErrorMessage="The passwords don't match" ValidationGroup="addUser" /><br />
        <asp:TextBox ID="txtConfirmPassword" TextMode="Password" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>Email:</strong>
        <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter an email address" />
        <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter a valid e-mail address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" /><br />
        <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>First Name:</strong>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter a first name" /><br />
        <asp:TextBox ID="txtFirstName" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>Last Name:</strong>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtLastName" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter a last name" /><br />
        <asp:TextBox ID="txtLastName" runat="server" ValidationGroup="addUser" /><br />
        
        <strong>Security Question:</strong>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtQuestion" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter a security question" /><br />
        <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" /><br />
        
        <strong>Security Answer:</strong>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtAnswer" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please enter an answer" /><br />
        <asp:TextBox ID="txtAnswer" runat="server" TextMode="Password" /><br />
        
        <strong>Confirm Answer:</strong>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtAnswer" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="Please confirm your answer" />
        <asp:CompareValidator ID="cmpConfirmAnswer" runat="server" ControlToCompare="txtAnswer" ControlToValidate="txtConfirmAnswer" Display="Dynamic" ValidationGroup="addUser" ErrorMessage="The answers do no match" Operator="Equal" /><br />
        <asp:TextBox ID="txtConfirmAnswer" runat="server" TextMode="Password" /><br />
        
        <asp:Button ID="butAddUser" runat="server" Text="Add User" onclick="butAddUser_Click" />
        <asp:Button ID="butCancel" runat="server" Text="Cancel" CausesValidation ="false" />
    </asp:Panel>
    
    <asp:LinqDataSource ID="UserDataSource" runat="server" ContextTypeName="DataClassesDataContext" Select="new (FirstName, LastName, Login, UserType, LastLogin, UserInfoID, Active, Email, UserTypeID, AgencyID, SecurityQuestion, Created)" TableName="UserInfos">
    </asp:LinqDataSource>
    
    </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="prgUpdate" runat="server">
        <ProgressTemplate>
            <h3>Loading</h3>
            <asp:Image ID="imgLoader" runat="server" ImageUrl="~/images/ajax-loader.gif" AlternateText="Loading..." />
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

