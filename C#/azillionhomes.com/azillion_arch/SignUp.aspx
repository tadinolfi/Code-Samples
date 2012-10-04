<%@ Page Title="A Zillion Homes - Sign Up" Language="C#" MasterPageFile="main.master" AutoEventWireup="true" CodeFile="SignUp.aspx.cs" Inherits="SignUp" %>

<%@ Register Namespace="AZHControls" TagPrefix="azh" %>
<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="metaContent" runat="server" ContentPlaceHolderID="metaContent">
    <title>Free Sign Up - Real Estate Tools Online - azillionhomes.com</title>
    <meta name="keywords"  content="free sign up, real estate tools, online options" />
    <meta name="description"  content="Sign up for free now, enjoy your real estate tools and options at azillionhomes.com. Post unlimited properties online for just $29.95 for 30 days." />
</asp:Content>

<asp:Content ID="headContent" runat="server" ContentPlaceHolderID="headContent">
    <style type="text/css">
		@import "/includes/css/forms.css";
		@import "/includes/css/secondary.css";
		@import "/includes/css/modaldbox.css";
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mainContent" Runat="Server">
    <h1><span>Sign Up</span></h1>

	<div id="innerContent" class="innerContent">
	    <h2>Sign Up</h2>
		<div id="introText">Subscription at A Zillion Homes allows you to post as many properties as you would like for just $29.95 for 30 days. It costs nothing- all you have to do is complete the fields below.</div>
		
	    <asp:UpdatePanel ID="pnlUpdate" runat="server">
	        <ContentTemplate>
	        
	        
		<asp:Panel ID="pnlBasicInfo" runat="server" CssClass="signUpForm">
		    <p class="noDots">
		        &nbsp;<asp:ValidationSummary ID="vldSummary" runat="server" DisplayMode="BulletList" ValidationGroup="signup" /><p>
                    <asp:CustomValidator ID="vldEmail" runat="server" 
                        onservervalidate="vldEmail_ServerValidate" ValidationGroup="signup" 
                        ControlToValidate="ddlQuestion" Display="None" />
                    <asp:CustomValidator ID="cusPassword" runat="server" ValidationGroup="signup" ControlToValidate="ddlCellProvider" Display="None" ErrorMessage="Your password can't contain spaces" onservervalidate="cusPassword_ServerValidate" />
                </p>
                <azh:AZHField ID="txtFirstName" runat="server" AltRow="true" FieldName="First Name" Required="true" ValidationGroup="signup" />
                <azh:AZHField ID="txtLastName" runat="server" FieldName="Last Name" Required="true" ValidationGroup="signup" />
                <azh:AZHField ID="txtEmail" runat="server" AltRow="true" FieldName="Email" Required="true" ValidationGroup="signup" />
                <azh:AZHField ID="txtCompany" runat="server" FieldName="Company" ValidationGroup="signup" />
                <azh:AZHField ID="txtAddress" runat="server" FieldName="Address" ValidationGroup="signup" />
                <div class="formRow altRowColor">
                    <span class="required">*</span>
                    <label>Zip Code:</label>
                    <asp:TextBox ID="txtZipCode" runat="server" ValidationGroup="signup"  AutoPostBack="True" ontextchanged="txtZipCode_TextChanged" />
                    <asp:RequiredFieldValidator ID="reqZip" runat="server" CssClass="errorMessage" ControlToValidate="txtZipCode" ValidationGroup="signup" ErrorMessage="Please enter a zip code" />
                </div>
                <azh:AZHField ID="txtCity" runat="server" FieldName="City" Required="true" ValidationGroup="signup" />
                <div class="formRow altRowColor">
                    <span class="required">*</span>
                    <label>State</label>
                    <asp:DropDownList ID="ddlState" runat="server" DataSourceID="StateDataSource" DataTextField="Name" DataValueField="StateID" ValidationGroup="signup" AppendDataBoundItems="true">
                        <asp:ListItem Text="Please Select a State" Value="0" />
                    </asp:DropDownList>
                    <asp:CompareValidator ID="cmpState" runat="server" ControlToValidate="ddlState" CssClass="errorMessage" ErrorMessage="Please select a state" Operator="NotEqual" Type="Integer" ValidationGroup="signup" ValueToCompare="0" />
                    <asp:LinqDataSource ID="StateDataSource" runat="server" 
                        ContextTypeName="DataClassesDataContext" OrderBy="Name" 
                        Select="new (StateID, Abbreviation, Name, Minor)" TableName="States" 
                        Where="CountryID == @CountryID &amp;&amp; Minor == @Minor">
                        <WhereParameters>
                            <asp:Parameter DefaultValue="1" Name="CountryID" Type="Int32" />
                            <asp:Parameter DefaultValue="false" Name="Minor" Type="Boolean" />
                        </WhereParameters>
                    </asp:LinqDataSource>
                </div>
                <azh:AZHField ID="txtPhone" runat="server" FieldName="Phone" ValidationGroup="signup" Required="true" />
                <azh:AZHField ID="txtCellPhone" AltRow="true" runat="server" FieldName="Cell Phone" ValidationGroup="signup" />
                <div class="formRow">
                    <label>Cell Phone Provider</label>
                    <asp:DropDownList ID="ddlCellProvider" runat="server" 
                        AppendDataBoundItems="True" DataSourceID="CellProviderDataSource" 
                        DataTextField="Name" DataValueField="CellPhoneProviderID">
                        <asp:ListItem Text="Please select your cell phone provider" Value="0" />
                    </asp:DropDownList>
                    <asp:LinqDataSource ID="CellProviderDataSource" runat="server" 
                        ContextTypeName="DataClassesDataContext" OrderBy="Name" 
                        Select="new (CellPhoneProviderID, Name)" TableName="CellPhoneProviders">
                    </asp:LinqDataSource>
                    <azh:HelpButton ID="hlpCell" runat="server" Message="In the near future we will be adding the ability to send you text messages about saved searches or contact requests on properties. In order to do this we will need to know your cell phone provider. Before sending any text messages, we will double check that you want to recieve them." Title="Why do we ask about Cell Phone providers?" /> 
                </div>
                <div class="formRow radioButtons altRowColor">
                    <label class="wide">
                    Can we contact you?</label>
                    <asp:RadioButtonList ID="rblContact" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ValidationGroup="signup">
                        <asp:ListItem Text="Yes" Value="1" />
                        <asp:ListItem Selected="True" Text="No" Value="0" />
                    </asp:RadioButtonList>
                </div>
                <div class="formRow radioButtons">
                    <label class="wide">
                    Are you an agent?</label>
                    <asp:RadioButtonList ID="rblAgent" runat="server" RepeatDirection="Horizontal" 
                        RepeatLayout="Flow" ValidationGroup="signup" AutoPostBack="true" 
                        onselectedindexchanged="rblAgent_SelectedIndexChanged">
                        <asp:ListItem Text="Yes" Value="1" />
                        <asp:ListItem Selected="True" Text="No" Value="0" />
                    </asp:RadioButtonList>
                </div>
                <div id="inviteCode" runat="server" visible="false" class="formRow highlightRowColor">
                    <label>Invitation Code</label>
                    <asp:TextBox ID="txtInvitation" runat="server" AutoPostBack="true" 
                        ontextchanged="txtInvitation_TextChanged" />
                    <asp:HiddenField ID="hidAgencyId" runat="server" Value="0" />
                    <asp:Label ID="lblInviteMessage" runat="server"></asp:Label>
                </div>
                <azh:AZHField ID="txtPassword" AltRow="true" runat="server" FieldName="Password" FormFieldType="TextBox:Password" Required="true" ValidationGroup="signup" />
                <azh:AZHField ID="txtConfirmPassword" runat="server" FieldName="Confirm Password" FormFieldType="TextBox:Password" Required="true" ValidationGroup="signup" />
                <div class="formRow altRowColor">
                    <span class="required">*</span>
                    <label for="txtFirstName_fieldControl">Security Question</label>
                    <asp:DropDownList ID="ddlQuestion" runat="server" ValidationGroup="signup">
                        <asp:ListItem Text="What was your first pet's name?" />
                        <asp:ListItem Text="What street do you live on?" />
                        <asp:ListItem Text="What is your mother's maiden name?" />
                        <asp:ListItem Text="What are the last 4 characters in your driver's license number?" />
                        <asp:ListItem Text="What city were you born in?" />
                    </asp:DropDownList>
                </div>
                <azh:AZHField ID="txtAnswer" runat="server" FieldName="Answer" FormFieldType="TextBox:Password" Required="true" ValidationGroup="signup" />
                <azh:AZHField ID="txtConfirmAnswer" runat="server" AltRow="true" FieldName="Confirm Answer" FormFieldType="TextBox:Password" Required="true" ValidationGroup="signup" />
                
                <div class="formRow altRowColor" id="enterCode">
                    <p class="noDots"></p>
                    <p class="noDots"><asp:Image ID="imgCaptcha" runat="server" ImageUrl="~/CaptchaImageGen.aspx" /></p>
                    
                    <p class="noDots"><strong>Enter the code shown above:</strong></p>
                    <p class="noDots">
                        <asp:TextBox ID="txtCaptcha" runat="server" ValidationGroup="signup" />
                    <asp:CustomValidator ID="vldCaptcha" runat="server" 
                        ControlToValidate="txtCaptcha" 
                        ErrorMessage="Please enter the numbers in the picture above" Display="None" 
                        onservervalidate="vldCaptcha_ServerValidate" ValidationGroup="signup" />
                    <asp:RequiredFieldValidator ID="reqCaptcha" runat="server" ControlToValidate="txtCaptcha" ErrorMessage="Please enter the numbers in the picture above" ValidationGroup="signup" Display="None" />
                    </p>

                    <p class="noDots" style="clear:both;"><em class="notice">(Note: If you cannot read the numbers in the<br />above image, reload the page to generate a new one.)</em></p>

                </div>
                <div class="formRow">
                    <asp:CheckBox ID="chkTerms" runat="server" ValidationGroup="signup"  /><strong>Please check here if you agree with our <asp:LinkButton ID="lnkTerms" runat="server">terms and conditions</asp:LinkButton></strong>.
                    <asp:CustomValidator ID="reqTerms" runat="server" ValidationGroup="signup" Display="None" ErrorMessage="You must accept the terms and conditions" OnServerValidate="chkTerms_ServerValidate" />
                </div>
                <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="lnkClose" PopupControlID="pnlTerms" TargetControlID="lnkTerms">
                </cc1:ModalPopupExtender>
    	<asp:Panel ID="pnlTerms" runat="server" CssClass="modalPopup scrollPopup" Width="600px" Height="500px">
    	    <asp:LinkButton ID="lnkClose" runat="server" CssClass="modalClose">close</asp:LinkButton>
    	    <h2>Terms &amp; Conditions</h2>
    	    <div id="Div1">Before you use the A Zillion Homes.com website, you must read and agree to abide by the <a href="javascript:window.open('http://www.azillionhomes.com/terms/', 'Terms','scrollbars=yes,height=650,width=650',false);void(0);">Terms of Use.</a></div>
				
			<p>This policy describes the types of information A Zillion Homes, LLC gathers from its users of the A Zillion Homes, LLC Web site at www.azillionhomes.com and how that information is used. Please read this policy carefully before you provide us with any personal information. If you have questions about this policy, please email us at support@azillionhomes.com. </p>
	        <p class="noDots"><strong>Information We Collect </strong></p>	
			<p>We log your IP address in order to help diagnose problems with our server, administer our Web site and track usage statistics. Your IP address may vary each time you visit, or it may be the same, depending on whether you access our site through an always-on type of Internet connection (e.g., cable modem or DSL), or through a dial-up connection (e.g., AOL or Earthlink). Either way, it would be extremely difficult for us to identify you through your IP address, and we make no attempt to do so. If you reached our site by clicking on a link or advertisement on another site, then we also log that information. This helps us maximize our Internet exposure, and understand our users' interests. All of this information is collected and used only in the aggregate; that is, it is entered into our database, where we can use it to generate overall reports on our visitors, but not individual reports that identify you personally. </p>
			<p>We also place a small text file known as a "cookie" on your computer's hard drive. A cookie may contain information that allows us to track your path through our Web site and to determine whether you have visited us before. However, unless you register with us, it contains no personally identifiable information that would allow us to identify you. Cookies cannot be used to read data off of your hard drive, and cannot retrieve information from any other cookies created by other Web sites. We use cookies in this manner to help us understand how visitors use our site, and to help us to improve our site. You may refuse to accept a cookie from us by following the procedures specific to your Web browser. Although you may do so, you may find that your browser reacts strangely when visiting not only our Web site, but other Web sites as well. Since cookies don't provide us with any information from which we can identify you, we suggest you allow us to place one on your computer.</p>	
			<p>We may use Web beacons on our site or other sites and may permit third parties to place them on our site to monitor the effectiveness of advertising or for other legitimate purposes. A Web beacon, also known as a "Web bug," is a small, graphic image on a Web page, Web-based document or in an e-mail message that is designed to allow the site owner or a third party to monitor who is visiting a site. Web beacons are often invisible to the user because they are typically very small (only 1-by-1 pixel) and the same color as the background of the Web page, document or e-mail message. Web beacons are represented as HTML IMG tags in the Web page; users can click on "view profiles" of the Web page to see whether the page is using a Web beacon. Web beacons collect the IP address of the computer that the Web beacon is sent to, the URL of the page the Web beacon comes from and the time it was viewed. Web beacons can also be linked to personal information. For example, advertising networks use Web bugs to add information to a personal profile of what sites a person is visiting and to determine what banner ads to display based on the profile. Another use of Web bugs is to provide an independent accounting of how many people have visited a particular Web site. Web bugs are also used to gather statistics about Web browser usage at different places on the Internet.</p>
	        <p>We also give you the option to give us your email address and other personal information so we can send you relevant real estate news and information on behalf of A Zillion Homes, LLC, our affiliates or third parties.</p>	
	        <p class="noDots"><strong>How We Use The Information We Collect </strong></p>	
	        <p class="noDots">We use the information we collect to help you</p>
	        <ul style="padding:0 20px 0 20px;">
	        <li>find the most relevant information by organizing the Web site optimally</li>
	        <li>find relevant real estate-related news and information via email (if you have registered your email address</li>
	        </ul>
	        <p>You can control whether you receive such emails by following the instructions at the end of each email we send. You may also opt-out by sending an email to support@azillionhomes.com. We may also use the information you provide to allow us to contact you for administrative purposes; for example, to tell you about changes to our privacy policy. </p>
        	
            <p>We may also use certain information that you provide in order to present you with advertising that you may find interesting. This benefits both of us. It benefits us because advertising helps pay the bills, and we can charge our advertisers more if they know that their ads will be seen by somebody more likely to find them useful. It benefits you because you see advertising that may actually be interesting to you, rather than annoying. </p>
            <p class="noDots"><strong>Disclosure Of Information </strong></p>
        	
	        <p>A Zillion Homes, LLC does not rent or sell personal information about you with other people or non-affiliated companies, except when we have your consent to do so, as necessary to complete a transaction you have requested, for marketing purposes (unless you have chosen not to receive such communications, in certain business transactions), when required by law, or when permitted to protect our rights or property. We reserve the right to use in any manner and disclose any non-personal information that we collect including cookie and traffic data. We do not combine personal information with any of the non-personal information gathered on our site.</p>

            <p>We may release personal information when we believe release is appropriate to comply with the law (e.g., a lawful subpoena, warrant or court order); to enforce or apply our policies; to initiate, render, bill, and collect for amounts owed to us; to protect our rights or property, or to protect our user from fraudulent, abusive, or unlawful use of, our site or services; or if we reasonably believe that an emergency involving immediate danger of death or serious physical injury to any person requires disclosure of communications or justifies disclosure of records without delay.</p>	

            <p>We may use third party service providers to assist us with the administration of the site or otherwise perform services on our behalf, including transaction processing and sending email. Such third parties may be supplied with or have access to your personal information solely to provide services to us or on our behalf. </p>

            <p>We may use third parties, called third-party ad servers or ad networks, to deliver ads to you on our behalf. These third-party ad servers may collect and use non-personally identifiable information about your visits to our site in order to present advertisements that may be of interest to you. If you would like more information about this practice or to opt out of having this information used by third-party ad servers to provide targeted ads, please visit http://www.networkadvertising.org/optout_nonppii.asp</p>

            <p>Information about our users and the site is a business asset of A Zillion Homes, LLC. Therefore, information about our users, including personal information, will be disclosed as part of any merger or acquisition, creation of a separate business to provide the site, our services or fulfill products, sale or pledge of company assets as well as in the event of an insolvency, bankruptcy or receivership in which personal information would be transferred as one of the business assets of the company</p>
	        <p class="noDots"><strong>Security</strong></p>
	        <p>We use commercially reasonable security measures to protect the loss, misuse, and alteration of the information under our control. However, we cannot guarantee the protection of information against interception, misappropriation, misuse, or alteration or that your information may be not be disclosed or accessed by accidental circumstances or by the unauthorized acts of others. You should be aware that we have no control over the security of other sites on the Internet you might visit, interact with, or from which you buy products or services.</p>

            <p class="noDots"><strong>Policy Changes </strong></p>	
        	
			<p class="noDots">We reserve the right to change this policy should we deem it advisable to do so. If we make significant changes that affect the use or disclosure of your personal information, we will make reasonable efforts to notify you of the changes and to give you the opportunity to cancel your registration</p>
    	</asp:Panel>
                <asp:LinkButton ID="butCreate" runat="server" CssClass="linkButton signup" Text="SignUp" onclick="butCreate_Click" ValidationGroup="signup" />
                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
    	        
    	</asp:Panel>
    	
    	</ContentTemplate>
	    </asp:UpdatePanel>
	</div>
</asp:Content>

