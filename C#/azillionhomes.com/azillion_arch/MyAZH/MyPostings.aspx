<%@ Page Title="" Language="C#" MasterPageFile="~/myazh/dashboard.master" AutoEventWireup="true" CodeFile="MyPostings.aspx.cs" Inherits="myazh_MyPostings" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dashboardContent" Runat="Server">
        <h1 id="hdrMyPostings"><img src="../images/headers/my-postings.gif" alt="My Postings" /></h1>
        <asp:Label ID="lblExpiredNotice" runat="server" Visible="false" CssClass="expiredNotice">Some of your postings have expired.</asp:Label>
		<asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="postingHeader">
		    <p>You need to have an active supscription to activate listings. Please click on the My Billing tab to create a 
		    subscription.</p>
		</asp:Panel>
        <div id="createANewPosting">
            <asp:HyperLink ID="lnkCreate" runat="server" NavigateUrl="~/MyAZH/ChoosePostingType.aspx" Text="Create New Posting" CssClass="linkButton createnew" />
        </div>   
		<ul id="tableTabs">			
			<li id="selectedTab">
			    <asp:LinkButton ID="lnkAll" runat="server" onclick="lnkAll_Click">All Postings</asp:LinkButton>
			</li>
			<li>
			    <asp:LinkButton ID="lnkRentals" runat="server" onclick="lnkRentals_Click">Rentals</asp:LinkButton>
    		</li>
			<li>
			    <asp:LinkButton ID="lnkSales" runat="server" onclick="lnkSales_Click">Sales</asp:LinkButton>
			</li>
			<li>
			    <asp:LinkButton ID="lnkOpenHouses" runat="server" onclick="lnkOpenHouses_Click">Open Houses</asp:LinkButton>
			</li>
			<li>
			    <asp:LinkButton ID="lnkAuctions" runat="server" onclick="lnkAuctions_Click">Auctions</asp:LinkButton>
			</li>
			<li runat="server" id="liAgency" visible="false">
			    <asp:LinkButton ID="lnkViewAgency" runat="server" CssClass="viewAgencyButton" Text="View Agency Posts" onclick="lnkViewAgency_Click" />
			</li>
			<li runat="server" id="liMine" visible="false">
			    <asp:LinkButton ID="lnkViewMine" runat="server" CssClass="viewMyPostsButton" Text="View My Posts" onclick="lnkViewMine_Click" />
			</li>
		</ul>
    <asp:GridView ID="grdPostings" runat="server" AutoGenerateColumns="False" 
            AllowPaging="True" AllowSorting="True" PageSize="25" Width="100%" 
            PagerStyle-CssClass="myPostingsPagination" 
            onpageindexchanging="grdPostings_PageIndexChanging" 
            onsorting="grdPostings_Sorting">
        <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" />
        <Columns>
            <asp:BoundField DataField="EntryDate" DataFormatString="{0:d}" HeaderText="Date:" ReadOnly="True" SortExpression="EntryDate" />
            <asp:TemplateField HeaderText="Views Today:">
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" 
                        Text='<%# GetViews(Convert.ToInt32(Eval("FormEntryID")), true) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Total Views:">
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" 
                        Text='<%# GetViews(Convert.ToInt32(Eval("FormEntryID")), false) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="AZHID" HeaderText="AZH #:" ReadOnly="True" SortExpression="AZHID" />
            <asp:TemplateField HeaderText="Title/Address:" SortExpression="StreetName">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" 
                        Text='<%# Eval("StreetNumber") + " " + Eval("StreetName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="City" HeaderText="Town:" ReadOnly="True" SortExpression="City" />
            <asp:BoundField DataField="Price" HeaderText="Price:" ReadOnly="True" SortExpression="Price" />
            <asp:TemplateField HeaderText="Status:" SortExpression="Active">
                <ItemTemplate>
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/dashboard/post-icon-live.gif" Visible='<%# ((bool)Eval("Active") && (bool)Eval("Completed") && (DateTime)Eval("Expires") >= DateTime.Now) %>' />
                    <asp:Image ID="Image2" runat="server" ImageUrl="~/images/dashboard/post-icon-pending.gif" Visible='<%# !(bool)Eval("Completed") %>' />
                    <asp:Image ID="Image3" runat="server" ImageUrl="~/images/dashboard/post-icon-inactive.gif" Visible='<%# (!(bool)Eval("Active") && (bool)Eval("Completed")) %>' />
                    <asp:Image ID="Image4" runat="server" ImageUrl="~/images/dashboard/post-icon-expired.gif" Visible='<%# ((bool)Eval("Active") && (bool)Eval("Completed") && (DateTime)Eval("Expires") < DateTime.Now) %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Actions:">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkActivate" runat="server" Text="activate" 
                        CommandArgument='<%# Eval("FormEntryID") %>' 
                        Visible='<%# (!(bool)Eval("Active") || !(bool)Eval("Completed"))%>' 
                        onclick="lnkActivate_Click" />
                    <asp:LinkButton ID="lnkRenew" runat="server" Text="renew" 
                        CommandArgument='<%# Eval("FormEntryID") %>' 
                        Visible='<%# ((bool)Eval("Active") && (bool)Eval("Completed") && (DateTime)Eval("Expires") < DateTime.Now) %>' 
                        onclick="lnkRenew_Click" />
                    <asp:LinkButton ID="lnkDeactivate" runat="server" Text="de-activate" 
                        CommandArgument='<%# Eval("FormEntryID") %>' 
                        Visible='<%# ((bool)Eval("Active") && (bool)Eval("Completed") && (DateTime)Eval("Expires") >= DateTime.Now) %>' 
                        onclick="lnkDeactivate_Click" />
                    -
                    <asp:LinkButton ID="lnkEdit" runat="server" OnClientClick="return confirm('All edits must be approved on the preview page before they will take affect.');" Text="edit" OnClick="lnkEdit_Click" CommandArgument='<%# Eval("FormEntryID") %>' />
                    -
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# "~/Posting.aspx?postid=" + Eval("FormEntryID") %>'>view</asp:HyperLink>
                    -
                    <asp:LinkButton ID="lnkDelete" runat="server" Text="delete" />
                    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="butCancel" BackgroundCssClass="modalBackground" DropShadow="true" PopupControlID="pnlDelete" TargetControlID="lnkDelete">
                    </cc1:ModalPopupExtender>
                    <asp:Panel ID="pnlDelete" runat="server" CssClass="modalPopup" Width="500px" style="display:none;">
                        <h2>Please let us know why you're deleting this listing</h2>
                        <asp:DropDownList ID="ddlReason" runat="server" CssClass="bigDrop">
                            <asp:ListItem Value="sold">This property has been sold or rented</asp:ListItem>
                            <asp:ListItem Value="unlisted">This property is no longer for sale</asp:ListItem>
                            <asp:ListItem Value="other">Other</asp:ListItem>
                        </asp:DropDownList>
                        <div style="text-align:center">
                            <asp:Button ID="butDelete" CssClass="azhButton" runat="server" 
                                CommandArgument='<%# Eval("FormEntryID") %>' Text="Delete Listing" 
                                onclick="butDelete_Click" />
                            <asp:Button ID="butCancel" CssClass="azhButton" runat="server" Text="Cancel" />
                        </div>
                    </asp:Panel>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
	
	    <PagerStyle CssClass="myPostingsPagination" />
	
	</asp:GridView>
	<asp:Panel ID="pnlIconKey" runat="server" CssClass="iconKey">
            <ul>
                <li><asp:Image ID="Image1" runat="server" ImageUrl="~/images/dashboard/post-icon-live.gif" /> Live</li>
                <li><asp:Image ID="Image2" runat="server" ImageUrl="~/images/dashboard/post-icon-pending.gif" /> Incomplete</li>
                <li><asp:Image ID="Image3" runat="server" ImageUrl="~/images/dashboard/post-icon-inactive.gif" /> Inactive</li>
                <li><asp:Image ID="Image4" runat="server" ImageUrl="~/images/dashboard/post-icon-expired.gif" /> Expired</li>
            </ul>
        </asp:Panel>
</asp:Content>

