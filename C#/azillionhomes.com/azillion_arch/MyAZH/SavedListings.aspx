<%@ Page Title="" Language="C#" MasterPageFile="~/MyAZH/dashboard.master" AutoEventWireup="true" CodeFile="SavedListings.aspx.cs" Inherits="MyAZH_SavedListings" Theme="azh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" runat="server">
    <style type="text/css">
		@import "../includes/css/my-account.css";
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="dashboardContent" Runat="Server">
    
    <ul id="horizontalSubNav">
        <li class="header">My Account:</li>
        <li><asp:HyperLink ID="lnkOverview" runat="server" NavigateUrl="~/MyAZH/MyAccount.aspx">Overview</asp:HyperLink></li>
        <li class="lastLink"><asp:HyperLink CssClass="selected" ID="lnkSaved" runat="server" NavigateUrl="~/MyAZH/SavedListings.aspx">Saved Searches/Listings</asp:HyperLink></li>
    </ul>
    
    <div>
        <h2>Saved Listings</h2>
        <asp:GridView ID="grdListings" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" 
            DataSourceID="ListingDataSource" DataKeyNames="SavedFormEntryID">
            <Columns>
                <asp:TemplateField HeaderText="Posting " SortExpression="FormEntryID">
                    <EditItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("FormEntryID") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="HyperLink1" runat="server" 
                            NavigateUrl='<%# "~/Posting.aspx?postid=" + Eval("FormEntryID") %>' 
                            Text='<%# ((FormEntry)Eval("FormEntry")).StreetNumber + " " + ((FormEntry)Eval("FormEntry")).StreetName %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" 
                            Text='<%# ((FormEntry)Eval("FormEntry")).ListingType.Name %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Created" DataFormatString="{0:d}" 
                    HeaderText="Created" ReadOnly="True" SortExpression="Created" />
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDeleteListing" runat="server" 
                            CommandArgument='<%# Eval("SavedFormEntryID") %>' 
                            onclick="lnkDeleteListing_Click">Delete</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:LinqDataSource ID="ListingDataSource" runat="server" 
            ContextTypeName="DataClassesDataContext" OrderBy="Created desc" 
            Select="new (FormEntry, Created, FormEntryID, SavedFormEntryID)" TableName="SavedFormEntries" 
            Where="UserInfoID == @UserInfoID">
            <WhereParameters>
                <asp:SessionParameter Name="UserInfoID" SessionField="azhuserid" Type="Int32" />
            </WhereParameters>
        </asp:LinqDataSource>
    </div>
    <div>
        <h2>Saved Searches</h2>
        <asp:GridView ID="grdSearches" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" 
            DataSourceID="SearchDataSource" DataKeyNames="SavedSearchID">
            <Columns>
                <asp:BoundField DataField="SearchName" HeaderText="SearchName" ReadOnly="True" 
                    SortExpression="SearchName" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" 
                            CommandArgument='<%# Eval("Criteria") %>' onclick="LinkButton1_Click">View</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Email New Listings" 
                    SortExpression="EmailListings">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" 
                            Checked='<%# Bind("EmailListings") %>' AutoPostBack="true" TabIndex='<%# Convert.ToInt16(Eval("SavedSearchID")) %>' oncheckedchanged="CheckBox1_CheckedChanged" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("EmailListings") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Created" DataFormatString="{0:d}" 
                    HeaderText="Created" ReadOnly="True" SortExpression="Created" />
                <asp:BoundField DataField="LastUsed" DataFormatString="{0:d}" 
                    HeaderText="LastUsed" ReadOnly="True" SortExpression="LastUsed" />
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDeleteSearch" runat="server" CausesValidation="False" 
                            CommandArgument='<%# Eval("SavedSearchID") %>' CommandName="Delete" 
                            onclick="lnkDeleteSearch_Click" Text="Delete"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:LinqDataSource ID="SearchDataSource" runat="server" 
            ContextTypeName="DataClassesDataContext" OrderBy="LastUsed desc" 
            Select="new (SearchName, Created, LastUsed, SavedSearchID, Criteria, EmailListings)" 
            TableName="SavedSearches" Where="UserInfoID == @UserInfoID">
            <WhereParameters>
                <asp:SessionParameter Name="UserInfoID" SessionField="azhuserid" Type="Int32" />
            </WhereParameters>
        </asp:LinqDataSource>
    </div>
    
</asp:Content>

