<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1><span>News</span></h1>
    <div id="innerContent">
    <asp:ListView ID="ListView1" runat="server" DataSourceID="NewsDataSource">
    <ItemTemplate>
        <div class="listItem">
            <h3>
                <asp:HyperLink ID="lnkTitle" runat="server" Text='<%# Eval("Title") %>' NavigateUrl='<%# "NewsItem.aspx?id=" + Eval("NewsID") %>' />
            </h3>
            <strong><asp:Label ID="CreatedLabel" runat="server" Text='<%# Eval("Created") %>' /></strong>
            <div class="teaser">
                <asp:Label ID="TeaserLabel" runat="server" Text='<%# Eval("Teaser") %>' />
            </div>
        </div>
    </ItemTemplate>
    <AlternatingItemTemplate>
        <div class="listItem altColor">
            <h3>
                <asp:HyperLink ID="lnkTitle" runat="server" Text='<%# Eval("Title") %>' NavigateUrl='<%# "NewsItem.aspx?id=" + Eval("NewsID") %>' />
            </h3>
            <strong><asp:Label ID="CreatedLabel" runat="server" Text='<%# Eval("Created") %>' /></strong>
            <div class="teaser">
                <asp:Label ID="TeaserLabel" runat="server" Text='<%# Eval("Teaser") %>' />
            </div>
        </div>
    </AlternatingItemTemplate>
    <EmptyDataTemplate>
        <span>No data was returned.</span>
    </EmptyDataTemplate>
    <LayoutTemplate>
        <div style="dataPager">
            <asp:DataPager ID="DataPager1" runat="server">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" 
                        ShowNextPageButton="False" ShowPreviousPageButton="False" />
                    <asp:NumericPagerField />
                    <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="True" 
                        ShowNextPageButton="False" ShowPreviousPageButton="False" />
                </Fields>
            </asp:DataPager>
        </div>
        <div ID="itemPlaceholderContainer" runat="server" style="">
            <span ID="itemPlaceholder" runat="server" />
        </div>
        <div style="dataPager">
            <asp:DataPager ID="DataPager2" runat="server">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                    <asp:NumericPagerField />
                    <asp:NextPreviousPagerField ButtonType="Link" ShowLastPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                </Fields>
            </asp:DataPager>
        </div>
    </LayoutTemplate>
</asp:ListView>
</div>
<asp:LinqDataSource ID="NewsDataSource" runat="server" 
    ContextTypeName="DataClassesDataContext" OrderBy="Created desc" 
    Select="new (NewsID, UserInfoID, Title, Created, Teaser, UserInfo)" 
    TableName="News">
</asp:LinqDataSource>

</asp:Content>



