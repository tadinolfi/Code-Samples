<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Contact Us - Online Real Estate Resource - azillionhomes.com</title>
    <meta name="description" content="Contact azillionhomes.com! See how to access online real estate resources and tools that will make property searching or selling easy. Sign up today!" />
    <meta name="keywords" content="contact us, online real estate resource tools" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mainContent" Runat="Server">
    <div id="innerContent">
    <h1><img src="/images/headers/contact-us.gif" alt="Contact Us" /></h1>
	
	<div id="introText">Contact A Zillion Homes for inquiries about our business.</div>
    <h2>Contact Information</h2>
    <p>To contact us please email us at <a href="mailto:support@azillionhomes.com?subject=AZH Support Request">support@azillionhomes.com</a></p>
    <p>If you would like us to contact you, please fill in the following fields and we will get back to you shortly.</p>

	<h2>Request Information</h2>
        <asp:Panel ID="pnlForm" runat="server">
   		<div id="contactRightColumn" style="border-left:none; float:none; padding: 0 0 0 0 ">
	
			<div class="contactFormRow">
				<label for="">Name:</label>
				<asp:TextBox ID="txtName" runat="server" />
			</div>
			
			<div class="contactFormRow">
				<label for="">Address:</label>
				<asp:TextBox ID="txtAddress" runat="server" />
			</div>
			
			<div class="contactFormRow">
				<label for="">Phone:</label>
				<asp:TextBox ID="txtPhone" runat="server" />
			</div>
			
			<div class="contactFormRow">
				<label for="">Email:</label>
				<asp:RequiredFieldValidator ID="reqEmail" runat="server" ErrorMessage="Please enter an e-mail address" ControlToValidate="txtEmail" Display="Dynamic" />
				<asp:RegularExpressionValidator ID="regEmail" runat="server" 
                    ErrorMessage="The email address is not valid" ControlToValidate="txtEmail" 
                    Display="Dynamic" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
				<asp:TextBox ID="txtEmail" runat="server" />
			</div>
			
			<div class="contactFormRow textArea">
				<label for="">Comments:</label>
				<asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" />
			</div>
			
			<div id="contactFormButtons">
			    <asp:LinkButton ID="imgSubmit" runat="server" Text="Submit" CssClass="linkButton submit"
                    onclick="imgSubmit_Click" />
			</div>
        </div>
        </asp:Panel>
        <asp:Panel ID="pnlResponse" runat="server" Visible="false">
            <h3>Message Recieved</h3>
            <p class="noDots">
                Your message has been sent. Our staff will respond shortly.
            </p>
        </asp:Panel>    
        </div>
</asp:Content>

