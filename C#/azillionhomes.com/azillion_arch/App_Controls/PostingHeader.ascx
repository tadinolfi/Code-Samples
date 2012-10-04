<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PostingHeader.ascx.cs" Inherits="App_Controls_PostingHeader" %>

<h1 id="hdrCreateANewPosting"><img src="../images/headers/create-a-new-posting.gif" alt="My Postings | Create a New Posting" /></h1>	
<ul id="postingSteps">
	<li class="type">
	    <asp:HyperLink ID="lnkType" runat="server" NavigateUrl="~/myazh/ChoosePostingType.aspx"><span>type</span></asp:HyperLink>
	</li>
	<li class="info">
	    <asp:HyperLink ID="lnkInfo" runat="server" NavigateUrl="~/myazh/PostingInfo.aspx"><span>info</span></asp:HyperLink>
	</li>
	<li class="details">
	    <asp:HyperLink ID="lnkDetails" runat="server" NavigateUrl="~/myazh/PostingDetails.aspx"><span>details</span></asp:HyperLink>
	</li>
	<li class="photos">
	    <asp:HyperLink ID="lnkPhotos" runat="server" NavigateUrl="~/myazh/PostingPhotos.aspx"><span>photos</span></asp:HyperLink>
    </li>
    <li class="documents">
	    <asp:HyperLink ID="lnkDocuments" runat="server" NavigateUrl="~/myazh/PostingDocuments.aspx"><span>documents</span></asp:HyperLink>
    </li>
	<li class="preview">
	    <asp:HyperLink ID="lnkPreview" runat="server" NavigateUrl="~/myazh/PostingPreview.aspx"><span>preview</span></asp:HyperLink>
	</li>
</ul>