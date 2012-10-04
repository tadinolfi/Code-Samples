<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="MyAccount.aspx.cs" Inherits="myazh_MyAccount" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="headContent" runat="server">
    <style type="text/css">
		@import "../includes/css/my-account.css";
	</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
    
    <ul id="horizontalSubNav">
        <li class="header">My Account:</li>
        <li><asp:HyperLink ID="lnkOverview" CssClass="selected" runat="server" NavigateUrl="~/MyAZH/MyAccount.aspx">Overview</asp:HyperLink></li>
        <li class="lastLink"><asp:HyperLink ID="lnkSaved" runat="server" NavigateUrl="~/MyAZH/SavedListings.aspx">Saved Searches/Listings</asp:HyperLink></li>
    </ul>
    
    <div id="topRow">
        <div class="overviewBox" id="azhAccountInformation">
            <h2>Your AZH Account Information</h2>
            <p>
                <strong>This area of A Zillion Homes is designed to allow you to manage your account details.</strong> For any questions about your account please visit the <a href="javascript:window.open('/faqs.html', 'FAQs','scrollbars=yes,height=500,width=490',false);void(0);">FAQ</a> section or contact our support team <a href="mailto:support@azillionhomes.com">support@azillionhomes.com</a> for direct customer service.
            </p>
        </div>
        
        <div class="overviewBox" id="recentlySavedPosting">
            <h3>Recently Saved Postings</h3>
            <asp:GridView ID="grdPostings" CssClass="myAcctSaved" runat="server" 
                AutoGenerateColumns="False" DataSourceID="PostingDataSource">
                <Columns>
                    <asp:TemplateField HeaderText="Address">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkAddress" runat="server" Text='<%# ((FormEntry)Eval("FormEntry")).StreetName %>' NavigateUrl='<%# "/Posting.aspx?postid=" + Eval("FormEntryID") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="firstColumn" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="Created">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Created") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPosting" runat="server" NavigateUrl='<%# "/Posting.aspx?id=" + Eval("FormEntryID") %>'>view</asp:HyperLink>
                        </ItemTemplate>
                        <ItemStyle CssClass="lastColumn" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:LinqDataSource ID="PostingDataSource" runat="server" 
                ContextTypeName="DataClassesDataContext" 
                Select="new (UserInfo, FormEntry, Created, FormEntryID)" 
                TableName="SavedFormEntries" onselecting="PostingDataSource_Selecting" 
                OrderBy="Created desc" Where="UserInfoID == @UserInfoID">
                <WhereParameters>
                    <asp:SessionParameter Name="UserInfoID" SessionField="azhuserid" Type="Int32" />
                </WhereParameters>
            </asp:LinqDataSource>
            <asp:HyperLink ID="lnkPostings" runat="server" NavigateUrl="~/MyAZH/SavedListings.aspx" CssClass="viewAll">View All &raquo;&raquo;</asp:HyperLink>
        </div>
        
        <div class="overviewBox" id="recentlySavedSearches">
            <h3>Recently Saved Searches</h3>
            <asp:GridView ID="grdSearches" CssClass="myAcctSaved" runat="server" 
                AutoGenerateColumns="False" DataSourceID="SearchesDataSource">
                <Columns>
                    <asp:TemplateField HeaderText="Title" SortExpression="SearchName">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkSearchName" runat="server" CommandArgument='<%# Eval("Criteria") %>' onclick="lnkSearch_Click" Text='<%# Eval("SearchName") %>'></asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle CssClass="firstColumn" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="Created">
                        <ItemTemplate>
                            <asp:Label ID="lblSearchDate" runat="server" Text='<%# Bind("Created") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkSearch" runat="server" 
                                CommandArgument='<%# Eval("Criteria") %>' onclick="lnkSearch_Click">Load Search</asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle CssClass="lastColumn" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:LinqDataSource ID="SearchesDataSource" runat="server" 
                ContextTypeName="DataClassesDataContext" OrderBy="Created desc" 
                Select="new (SearchName, Created, SavedSearchID, Criteria)" 
                TableName="SavedSearches" Where="UserInfoID == @UserInfoID">
                <WhereParameters>
                    <asp:SessionParameter Name="UserInfoID" SessionField="azhuserid" Type="Int32" />
                </WhereParameters>
            </asp:LinqDataSource>
            <asp:HyperLink ID="lnkSearches" runat="server" NavigateUrl="~/MyAZH/SavedListings.aspx" CssClass="viewAll">View All &raquo;&raquo;</asp:HyperLink>
        </div>
    </div>
    <div id="bottomRow">
        <div id="memberInfoForm" class="overviewBox">
            <h3>Member Information</h3>
            <dl class="pairedValueList">
                <dt>Name:</dt>
                <dd><asp:Label ID="lblName" runat="server" /></dd>
                
                <dt>Email:</dt>
                <dd><asp:Label ID="lblEmail" runat="server" /></dd>
                
                <dt>Company:</dt>
                <dd><asp:Label ID="lblCompany" runat="server" /></dd>
                
                <dt>Street Address:</dt>
                <dd><asp:Label ID="lblStreet" runat="server" /></dd>
                
                <dt>City:</dt>
                <dd><asp:Label ID="lblCity" runat="server" /></dd>
                
                <dt>State:</dt>
                <dd><asp:Label ID="lblState" runat="server" /></dd>
                
                <dt>Zip:</dt>
                <dd><asp:Label ID="lblZip" runat="server" /></dd>
                
                <dt>Phone:</dt>
                <dd><asp:Label ID="lblPhone" runat="server" /></dd>
                
                <dt>Cell Phone:</dt>
                <dd><asp:Label ID="lblCell" runat="server" /></dd>
            </dl>
            <asp:LinkButton ID="lnkEditButton" runat="server" CausesValidation="false" CssClass="linkButton editprofile">Edit Profile</asp:LinkButton>
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" DropShadow="false" BackgroundCssClass="modalBackground" TargetControlID="lnkEditButton" PopupControlID="pnlEditAccount" CancelControlID="butCancel">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="pnlEditAccount" runat="server" CssClass="modalPopup" Width="400px" style="display:none;">
                <asp:LinkButton ID="lnkCloseEdit" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                <table>
                    <tr>
                        <td colspan="2">
                        <h3>Edit Account</h3>
                        <p>Fields marked with an "*" are required</p>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*First Name:</td>
                        <td>
                            <asp:TextBox ID="txtFirstName" runat="server" ValidationGroup="editAccount" />
                            <asp:RequiredFieldValidator ID="reqFirstName" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" ErrorMessage="Please enter a first name" ValidationGroup="editAccount"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*Last Name:</td>
                        <td>
                            <asp:TextBox ID="txtLastName" runat="server" ValidationGroup="editAccount" />
                            <asp:RequiredFieldValidator ID="reqLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" ErrorMessage="Please enter a last name" ValidationGroup="editAccount"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*Email:</td>
                        <td>
                            <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="editAccount" />
                            <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="Please enter an email address" ValidationGroup="editAccount"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="The email address entered is invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="editAccount" />
                            <asp:CustomValidator ID="cusEmail" runat="server" ControlToValidate="txtEmail" 
                                Display="Dynamic" 
                                ErrorMessage="That E-mail address is in use by another account" 
                                ValidationGroup="editAccount" onservervalidate="cusEmail_ServerValidate"></asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">Company:</td>
                        <td>
                            <asp:TextBox ID="txtCompanyName" runat="server" ValidationGroup="editAccount" />
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">Address:</td>
                        <td>
                            <asp:TextBox ID="txtAddress" runat="server" ValidationGroup="editAccount" />
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*City:</td>
                        <td>
                            <asp:TextBox ID="txtCity" runat="server" ValidationGroup="editAccount" />
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*State:</td>
                        <td>
                            <asp:DropDownList ID="ddlState" runat="server" DataSourceID="LinqDataSource1" DataTextField="Name" DataValueField="StateID" ValidationGroup="editAccount">
                            </asp:DropDownList>
                            <asp:LinqDataSource ID="LinqDataSource1" runat="server" 
                                ContextTypeName="DataClassesDataContext" OrderBy="Name" 
                                Select="new (StateID, Name, Abbreviation)" TableName="States" 
                                Where="CountryID == @CountryID &amp;&amp; Minor == @Minor">
                                <WhereParameters>
                                    <asp:Parameter DefaultValue="1" Name="CountryID" Type="Int32" />
                                    <asp:Parameter DefaultValue="false" Name="Minor" Type="Boolean" />
                                </WhereParameters>
                            </asp:LinqDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*Zip:</td>
                        <td>
                            <asp:TextBox ID="txtZip" runat="server" ValidationGroup="editAccount" />
                            <asp:RequiredFieldValidator ID="reqZip" runat="server" ControlToValidate="txtZip" Display="Dynamic" ErrorMessage="Please enter a zip code" ValidationGroup="editAccount"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">*Phone:</td>
                        <td>
                            <asp:TextBox ID="txtPhone" runat="server" ValidationGroup="editAccount" />
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">Cell Phone:</td>
                        <td>
                            <asp:TextBox ID="txtCell" runat="server" ValidationGroup="editAccount" />
                        </td>
                    </tr>
                    <tr>
                        <td class="heading">Cell Phone Provider:</td>
                        <td>
                            <asp:DropDownList ID="ddlCellProvider" runat="server" ValidationGroup="editAccount" AppendDataBoundItems="true">
                                <asp:ListItem Text="Please select your cell phone provider" Value="0" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:LinkButton ID="butEdit" runat="server" Text="Edit Account" onclick="butEdit_Click" ValidationGroup="editAccount" CssClass="linkButton floatButton editprofile_lm" />
                            <asp:LinkButton ID="butCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="linkButton floatButton cancel_lm" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        
            
        <div class="overviewBox" id="contactInformation">
        <asp:UpdatePanel ID="pnlUpdate" runat="server">
            <ContentTemplate>
            <h3>Agency Information</h3>
            <asp:Panel ID="pnlNoAgency" runat="server" Visible="false">
                <strong>No Agency Created</strong>
                <p>
                    You are not a member of an Agency. Creating an agency allows multiple user accounts to be
                    grouped together.
                </p>
                <asp:LinkButton ID="lnkCreateAgency" runat="server" Text="Create Agency" CausesValidation="false" CssClass="createagency linkButton" />
                <cc1:ModalPopupExtender CancelControlID="butAgencyCancel" ID="agencyModal" runat="server" TargetControlID="lnkCreateAgency" PopupControlID="pnlAgencyEditor" DropShadow="false" BackgroundCssClass="modalBackground"></cc1:ModalPopupExtender>
            </asp:Panel>
            <asp:Panel ID="pnlAgencyUser" runat="server" Visible="false">
                <strong>You are a member of <asp:Label ID="lblAgencyName" runat="server" /></strong>
                <address>
                    <asp:Literal ID="litAgencyAddress" runat="server" />
                </address>   
            </asp:Panel>
            <asp:Panel ID="pnlAgencyOwner" runat="server" Visible="false">
                <asp:LinkButton ID="lnkEditAgency" runat="server" Text="Edit Agency Details" CssClass="linkButton editagency" />
                <cc1:ModalPopupExtender CancelControlID="butAgencyCancel" ID="ModalPopupExtender2" runat="server" TargetControlID="lnkEditAgency" PopupControlID="pnlAgencyEditor" DropShadow="false" BackgroundCssClass="modalBackground"></cc1:ModalPopupExtender>
                <h3>Agency Users</h3>
                <asp:GridView ID="grdAgencyUsers" CssClass="myAcctSaved" runat="server" AllowSorting="True" Width="100%" AutoGenerateColumns="False">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" SortExpression="LastName">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("FirstName") + " " + Eval("LastName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="firstColumn" />
                            <HeaderStyle CssClass="firstColumn" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEditUser" runat="server" CausesValidation="false" CommandArgument='<%# Eval("UserInfoID") %>'>Edit</asp:LinkButton>
                                -
                                <asp:LinkButton ID="lnkUserSubscription" runat="server" CausesValidation="false" CommandArgument='<%# Eval("UserInfoID") %>' onclick="lnkUserSubscription_Click">Subscribe</asp:LinkButton>
                                -
                                <asp:LinkButton ID="lnkRemoveUser" runat="server" CausesValidation="false">Remove</asp:LinkButton>
                                
                                <cc1:ModalPopupExtender ID="popEditUser" runat="server" TargetControlID="lnkEditUser" PopupControlID="pnlEditUser" CancelControlID="butCancelEditUser" DropShadow="false" BackgroundCssClass="modalBackground"></cc1:ModalPopupExtender>
                                <asp:Panel ID="pnlEditUser" runat="server" CssClass="modalPopup" Width="100px" style="display:none;">
                                
                                    <asp:LinkButton ID="lnkCloseEdit" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                                    
                                    <table>
                                        <tr>
                                        <td colspan="2">
                                            <h3>Edit Agency User</h3>
                                            <p>Fields marked with an "*" are required</p>    
                                        </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*First Name: </strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditFirstName" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("FirstName") %>' />            
                                                <asp:RequiredFieldValidator ID="reqEditFirstName" runat="server" ControlToValidate="txtEditFirstName" Display="Dynamic" ErrorMessage="Please enter a first name" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' />        
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*Last Name:</strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditLastName" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("LastName") %>' />
                                                <asp:RequiredFieldValidator ID="reqEditLastName" runat="server" ControlToValidate="txtEditLastName" Display="Dynamic" ErrorMessage="Please enter a last name" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*Email: </strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditEmail" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("Email") %>' />
                                                <asp:RequiredFieldValidator ID="reqEditEmail" runat="server" ControlToValidate="txtEditEmail" Display="Dynamic" ErrorMessage="Please enter an email editress" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' />
                                                <asp:CustomValidator ID="cusEditEmail" runat="server" ControlToValidate="txtEditEmail" Display="Dynamic" ErrorMessage="That email address is already in use by another account" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' OnServerValidate="cusEditEmail_validate" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*Phone: </strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditPhone" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("Phone") %>' />
                                                <asp:RequiredFieldValidator ID="reqEditPhone" runat="server" ControlToValidate="txtEditPhone" Display="Dynamic" ErrorMessage="Please enter a phone number" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Cell Phone: </strong></td>
                                            <td><asp:TextBox ID="txtEditCellPhone" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("CellPhone") %>' /></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Address: </strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditAddress" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("Address") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*City: </strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditCity" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("City") %>' />
                                                <asp:RequiredFieldValidator ID="reqEditCity" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Display="Dynamic" ControlToValidate="txtEditCity" ErrorMessage="Please enter a city" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*State: </strong></td>
                                            <td>
                                                <asp:DropDownList ID="ddlEditState" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' DataSourceID="LinqDataSource1" DataTextField="Name" DataValueField="StateID" SelectedValue='<%# Eval("StateID") %>' AppendDataBoundItems="true" >
                                                    <asp:ListItem Text="Please select a State" Value="0" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>*Zip Code:</strong></td>
                                            <td>
                                                <asp:TextBox ID="txtEditZip" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text='<%# Eval("ZipCode") %>' />
                                                <asp:RequiredFieldValidator ID="reqEditZip" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Display="Dynamic" ControlToValidate="txtEditZip" ErrorMessage="Please enter a zip code" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:LinkButton ID="butEditUser" runat="server" ValidationGroup='<%# "editAgencyUser" + Eval("UserInfoID") %>' Text="Edit User" onclick="butEditUser_Click" CommandArgument='<%# Eval("UserInfoId") %>' CssClass="linkButton floatButton edituser_lm" />
                                                <asp:LinkButton ID="butCancelEditUser" runat="server" Text="Cancel" CausesValidation="false" CssClass="linkButton floatButton cancel_lm" />
                                            </td>
                                        </tr>
                                    </table>
                                    </div>
                                </asp:Panel>
                                <cc1:ModalPopupExtender ID="popRemoveUser" runat="server" TargetControlID="lnkRemoveUser" PopupControlID="pnlRemoveUser" CancelControlID="butCancelRemoveUser" DropShadow="false" BackgroundCssClass="modalBackground"></cc1:ModalPopupExtender>
                                <asp:Panel ID="pnlRemoveUser" runat="server" Width="200px" CssClass="modalPopup" style="display:none;">
                                    <asp:LinkButton ID="butCancelRemoveUser" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                                    <h3>Remove Agency User Confirmation</h3>
                                    <p>Are you sure you want to remove this user from your agency?</p>
                                    <asp:LinkButton ID="lnkRemoveYes" runat="server" CommandArgument='<%# Eval("UserInfoID") %>' CssClass="linkButton yes" Text="Yes" OnClick="butRemoveUser_Click" />
                                    <asp:LinkButton ID="lnkRemoveNo" runat="server" CssClass="linkButton no" Text="No" />
                                </asp:Panel>
                            </ItemTemplate>
                            <ItemStyle CssClass="lastColumn" />
                            <HeaderStyle CssClass="lastColumn" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:LinkButton ID="lnkAddAgencyUser" runat="server" Text="Add Agency User" CausesValidation="false" CssClass="linkButton addagencyuser" />
                <cc1:ModalPopupExtender ID="addUserModal" runat="server" TargetControlID="lnkAddAgencyUser" PopupControlID="pnlAddAgencyUser" DropShadow="false" BackgroundCssClass="modalBackground" CancelControlID="butCancelAddUser"></cc1:ModalPopupExtender>
                <asp:Panel ID="pnlAddAgencyUser" runat="server" Width="500px" CssClass="modalPopup" style="display:none;">
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                    <table>
                        <tr>
                            <td colspan="2">
                                <h3>Add Agency User</h3>
                            </td>
                        </tr>
                        <tr>
                            <td class="heading">*First Name: </td>
                            <td><asp:TextBox ID="txtAddFirstName" runat="server" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddFirstName" runat="server" ControlToValidate="txtAddFirstName" Display="Dynamic" ErrorMessage="Please enter a first name" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*Last Name: </td>
                            <td><asp:TextBox ID="txtAddLastName" runat="server" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddLastName" runat="server" ControlToValidate="txtAddLastName" Display="Dynamic" ErrorMessage="Please enter a last name" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*Email: </td>
                            <td>
                                <asp:TextBox ID="txtAddEmail" runat="server" ValidationGroup="addAgencyUser" />
                                <asp:RequiredFieldValidator ID="reqAddEmail" runat="server" ControlToValidate="txtAddEmail" Display="Dynamic" ErrorMessage="Please enter an email address" ValidationGroup="addAgencyUser" />
                                <asp:CustomValidator ID="cusAddEmailValidator" runat="server" ControlToValidate="txtAddEmail" Display="Dynamic" ErrorMessage="That E-mail address is in use by another account" ValidationGroup="addAgencyUser" onservervalidate="cusAddEmail_ServerValidate"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="heading">*Password:</td>
                            <td><asp:TextBox ID="txtAddPassword" runat="server" TextMode="Password" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddPassword" runat="server" ControlToValidate="txtAddPassword" ErrorMessage="Please enter a password" Display="Dynamic" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*Confirm Password:</td>
                            <td><asp:TextBox ID="txtAddConfirmPassword" runat="server" TextMode="Password" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqConfirmPassword" runat="server" ControlToValidate="txtAddConfirmPassword" ErrorMessage="Please confirm your password" Display="Dynamic" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*Phone:</td>
                            <td><asp:TextBox ID="txtAddPhone" runat="server" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddPhone" runat="server" ControlToValidate="txtAddPhone" Display="Dynamic" ErrorMessage="Please enter a phone number" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">Cell Phone:</td>
                            <td><asp:TextBox ID="txtAddCellPhone" runat="server" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">Address:</td>
                            <td><asp:TextBox ID="txtAddAddress" runat="server" ValidationGroup="addAgencyUser" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*City:</td>
                            <td><asp:TextBox ID="txtAddCity" runat="server" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddCity" runat="server" ValidationGroup="addAgencyUser" Display="Dynamic" ControlToValidate="txtAddCity" ErrorMessage="Please enter a city" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*State: </td>
                            <td><asp:DropDownList ID="ddlAddState" runat="server" ValidationGroup="addAgencyUser" DataSourceID="LinqDataSource1" DataTextField="Name" DataValueField="StateID" /></td>
                        </tr>
                        <tr>
                            <td class="heading">*Zip Code:</td>
                            <td><asp:TextBox ID="txtAddZip" runat="server" ValidationGroup="addAgencyUser" /><asp:RequiredFieldValidator ID="reqAddZip" runat="server" ValidationGroup="addAgencyUser" Display="Dynamic" ControlToValidate="txtAddZip" ErrorMessage="Please enter a zip code" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:LinkButton ID="butAddUser" runat="server" Text="Add User" ValidationGroup="addAgencyUser" onclick="butAddUser_Click" CssClass="linkButton floatButton adduser_lm" />
                                <asp:LinkButton ID="butCancelAddUser" runat="server" Text="Cancel" CssClass="linkButton floatButton cancel_lm" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <hr />
                <h3>Invite Agents</h3>
                <strong>Invitation Code: </strong> <asp:Label ID="lblInvitationCode" runat="server" />
                <asp:Label ID="lblInviteMessage" runat="server" />
                <asp:LinkButton ID="lnkInvitation" runat="server" CausesValidation="false" CssClass="linkButton sendinvite">Send Invitation</asp:LinkButton>
                <cc1:ModalPopupExtender ID="extInvitePopup" runat="server" TargetControlID="lnkInvitation" CancelControlID="butInviteCancel" DropShadow="false" BackgroundCssClass="modalBackground" PopupControlID="pnlInvite">
                </cc1:ModalPopupExtender>
                <asp:Panel ID="pnlInvite" runat="server" CssClass="modalPopup" Width="500px" style="display:none;">
                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                    <table>
                        <tr>
                            <td colspan="2"><h3>Send Agency Invitation</h3></td>
                        </tr>
                        <tr>
                            <td class="heading">*Email Address:</td>
                            <td><asp:TextBox ID="txtInviteEmail" runat="server" ValidationGroup="invite" /><asp:RequiredFieldValidator ControlToValidate="txtInviteEmail" ID="reqInviteEmail" runat="server" Display="Dynamic" ErrorMessage="Please enter an email address" ValidationGroup="invite" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:LinkButton ID="butInvite" runat="server" Text="Send Invitation" onclick="butInvite_Click" CssClass="linkButton floatButton sendinvite_lm" ValidationGroup="invite" />
                                <asp:LinkButton ID="butInviteCancel" runat="server" Text="Cancel" CssClass="linkButton floatButton cancel_lm" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </asp:Panel>
            <asp:Panel ID="pnlAgencyEditor" runat="server" CssClass="modalPopup" Width="500px">
                <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="false" CssClass="modalClose">close</asp:LinkButton>
                <table>
                    <tr>
                        <td colspan="2"><h3>Agency Details</h3></td>
                    </tr>
                    <tr>
                        <td><strong>Agency Name:</strong></td>
                        <td>
                            <asp:TextBox ID="txtAgencyName" runat="server" ValidationGroup="createAgency"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txtAgencyName" Display="Dynamic" ErrorMessage="Please enter an Agency Name" ValidationGroup="createAgency" />
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Desciption:</strong></td>
                        <td><asp:TextBox ID="txtAgencyDescription" runat="server" TextMode="MultiLine" Width="300px" Height="150px" ValidationGroup="createAgency"></asp:TextBox></td>   
                    </tr>
                    <tr>
                        <td><strong>Address Line 1:</strong></td>
                        <td><asp:TextBox ID="txtAgencyAddress1" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>Address Line 2:</strong></td>
                        <td><asp:TextBox ID="txtAgencyAddress2" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>City:</strong></td>
                        <td><asp:TextBox ID="txtAgencyCity" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>State</strong></td>
                        <td><asp:DropDownList ID="ddlAgencyState" runat="server" ValidationGroup="createAgency" DataSourceID="LinqDataSource1" DataTextField="Name" DataValueField="StateID"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><strong>Zip Code:</strong></td>
                        <td><asp:TextBox ID="txtAgencyZip" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>Website:</strong></td>
                        <td><asp:TextBox ID="txtAgencyWebsite" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>Contact Email:</strong></td>
                        <td><asp:TextBox ID="txtAgencyEmail" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>Phone:</strong></td>
                        <td><asp:TextBox ID="txtAgencyPhone" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><strong>Fax:</strong></td>
                        <td><asp:TextBox ID="txtAgencyFax" runat="server" ValidationGroup="createAgency"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:LinkButton ID="butAgencySave" runat="server" Text="Save" onclick="butAgencySave_Click" ValidationGroup="createAgency" CssClass="linkButton floatButton createagency_lm" />
                            <asp:LinkButton ID="butAgencyCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="linkButton floatButton cancel_lm" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
        </div>
        
        <div class="overviewBox" id="billingInformation">
            <h3>Billing Information</h3>
            <asp:Panel ID="pnlNoSubscription" runat="server" Visible="false">
                <h2>No Subscription</h2>
                <p>
                    You are currently not an AZH subscriber. With a subscription, you can post and manage
                    rentals, sales, open houses and auctions.
                </p>
                <asp:HyperLink ID="lnkCreateSubscription" runat="server" NavigateUrl="~/MyAZH/CreateSubscription.aspx">Create Subscription</asp:HyperLink>
            </asp:Panel>
            <asp:Panel ID="pnlHasSubscription" runat="server">
                <h2>Subscription Details</h2>
                <strong>Monthly Rate: </strong><asp:Label ID="lblRate" runat="server" />
                <strong>Started On: </strong><asp:Label ID="lblStart" runat="server" />
                <strong>Expires On: </strong><asp:Label ID="lblExpire" runat="server" /> - <asp:HyperLink ID="lnkRenew" runat="server" Text="renew" NavigateUrl="~/MyAZH/RenewSubscription.aspx" />
                <asp:HyperLink ID="lnkCancel" runat="server" Text="Cancel Subscription" NavigateUrl="~/MyAZH/CancelSubscription.aspx" />
            </asp:Panel>
        </div>
    </div>
    
</asp:Content>

