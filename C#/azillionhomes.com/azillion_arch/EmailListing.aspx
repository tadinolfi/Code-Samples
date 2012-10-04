<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="EmailListing.aspx.cs" Inherits="EmailListing" %>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/secondary.css";
	</style>
	<style type="text/css" media="all">
	    .emailListing
	    {background-color:#ebebeb; clear:both; border-top:4px solid #3a6495; border-bottom:4px solid #3a6495; padding:5px; margin:10px 0; position:relative;}
	    .emailListing img {border:1px solid #333; display:block; padding:1px; float:left; margin-right:10px;}
	    .emailListing .details { float:left; width:300px; margin:0; padding:0;}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="mainContent" Runat="Server">
    <div class="headerIcon" id="salesSearchIcon"></div>
	<h1 class="normal"><img src="/images/headers/send-to-a-friend.gif" alt="Send to a Friend" /></h1>
    <div id="innerContent">

            <asp:UpdatePanel ID="pnlUpdate" runat="server">
                <ContentTemplate>
                	    
    		<asp:Panel ID="pnlForm" runat="server" CssClass="signUpForm">
    		<asp:HyperLink ID="lnkBack" runat="server">Back to posting details</asp:HyperLink>
		    <asp:Panel ID="pnlDetails" runat="server" CssClass="emailListing">
		        <asp:Image ID="imgListing" runat="server" />
		        <div class="details">
		        <h2><asp:Label ID="lblPrice" runat="server" /></h2>
		        <strong><asp:Label ID="lblAddress" runat="server" /></strong><br />
		        <strong><asp:Label ID="lblCity" runat="server" />, <asp:Label ID="lblState" runat="server" /></strong><br />
		        <span class="azhnumber">AZH#: <asp:Label ID="lblAZH" runat="server" /></span>
		        </div>
		        <div style="clear:both;"></div>
		    </asp:Panel>
		    <div class="formRow altRowColor">
		        <span class="required">*</span>
			    <label class="question" for="txtFriendEmail">Friend's Email:</label>
			    <asp:TextBox ID="txtEmail" runat="server" />
			    <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" Display="None" ErrorMessage="Please enter a friend's email" />
			    <asp:RegularExpressionValidator ID="regEmail" runat="server" 
                    ControlToValidate="txtEmail" Display="None" 
                    ErrorMessage="Please enter a valid email address" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
		    </div>
		    <div class="formRow">
		        <span class="required">*</span>
			    <label class="question" for="txtFriendEmail">Your Email:</label>
			    <asp:TextBox ID="txtFromEmail" runat="server" />
			    <asp:RequiredFieldValidator ID="reqFromEmail" runat="server" ControlToValidate="txtFromEmail" Display="None" ErrorMessage="Please enter a friend's email" />
			    <asp:RegularExpressionValidator ID="regFromEmail" runat="server" 
                    ControlToValidate="txtFromEmail" Display="None" 
                    ErrorMessage="Please enter a valid email address" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
		    </div>
		    <div class=" formRow altRowColor" style="height: 70px;">
		        <span class="required">*</span>
			    <label class="question" for="txtMessage">Message:</label>
			    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" />
			    <asp:RequiredFieldValidator ID="reqMessage" runat="server" ControlToValidate="txtMessage" Display="None" ErrorMessage="Please enter a message" />
		    </div>
            <div id="buttonRow" style="border: 0;">
                <asp:ValidationSummary ID="summary" runat="server" DisplayMode="BulletList" />
	            <asp:ImageButton ID="butSendEmail" runat="server" ImageUrl="~/images/buttons/submit.gif" onclick="butSendEmail_Click" />
            </div>
    		</asp:Panel>
    		<asp:Panel ID="pnlSent" runat="server" Visible="false">
    		    <h3>Your e-mail has been sent. Would you like to send this to another person?</h3>
    		    <asp:LinkButton ID="lnkAgain" runat="server" CausesValidation="false" Text="Yes" onclick="lnkAgain_Click" /> - 
    		    <asp:LinkButton ID="lnkNo" runat="server" CausesValidation="false" Text="No, Return to listing details" onclick="lnkNo_Click" />
    		</asp:Panel>
    		
    		</ContentTemplate>
        </asp:UpdatePanel>	
    </div>
</asp:Content>

