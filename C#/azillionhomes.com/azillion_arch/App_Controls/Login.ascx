<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Login.ascx.cs" Inherits="App_Controls_Login" %>
<div class="loginForm">
<asp:UpdatePanel ID="pnlLoginUpdate" runat="server">
    <ContentTemplate>
        <asp:Panel ID="pnlLogin" runat="server" DefaultButton="butLogin">
	            <div class="loginError">
	                <asp:CustomValidator ID="valPassword" runat="server" Display="Dynamic" ErrorMessage="The username and password provided are not valid" ValidationGroup="login" ControlToValidate="txtPassword" />
	            </div>
	            
	            <div class="loginRow">
		            <label class="question">Email Address:</label>
		            <asp:TextBox ID="txtUsername" runat="server" ValidationGroup="login" CssClass="textbox" />
		            <asp:RequiredFieldValidator ID="reqUsername" runat="server" ControlToValidate="txtUsername" Display="Dynamic" ErrorMessage="Please enter a username" ValidationGroup="login" />
	            </div>
            	
	            <div class="loginRow">
		            <label class="question" for="Password">Password:</label>
		            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" ValidationGroup="login" CssClass="password" />
		            <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ErrorMessage="Please enter a password" ValidationGroup="login" />
	            </div>
	            
	            <div class="loginRow">
	                <asp:CheckBox ID="chkRemember" runat="server" Text="Remember Me" CssClass="checkbox" />    
	            </div>
            	
	            <div class="buttonRow">
	                <asp:LinkButton ID="butLogin" runat="server" CssClass="linkButton login"  onclick="butLogin_Click" ValidationGroup="login" Text="Login" />
                    <asp:LinkButton CssClass="forgotPassword" ID="butForgot" runat="server" Text="Forgot Password" onclick="butForgot_Click" CausesValidation="false" />
	            </div>            
        </asp:Panel>
        <asp:Panel ID="pnlEnter" runat="server" Visible="false">
            <h3>Please enter your username</h3>
            <strong>Username:</strong>
            <asp:CustomValidator ID="valUsername" runat="server" ControlToValidate="txtUsername2" Display="Dynamic" ErrorMessage="Invalid username" ValidationGroup="enter" />
            <asp:RequiredFieldValidator ID="reqUsername2" runat="server" ControlToValidate="txtUsername2" Display="Dynamic" ErrorMessage="Please enter a username" ValidationGroup="enter" /><br />
            <asp:TextBox ID="txtUsername2" runat="server" ValidationGroup="login" /><br />
            <strong>Reset Method:</strong><asp:RequiredFieldValidator ID="reqReset" runat="server" ControlToValidate="rblMethod" Display="Dynamic" ErrorMessage="Please select a password reset method" ValidationGroup="enter" /><br />
            <asp:RadioButtonList ID="rblMethod" runat="server" ValidationGroup="enter">
                <asp:ListItem Value="email" Selected="true">Reset password via e-mail</asp:ListItem>
                <asp:ListItem Value="question">Reset password by answering security question</asp:ListItem>
            </asp:RadioButtonList><br />
            <asp:Button ID="butStep2" runat="server" Text="Continue to Step 2" 
                ValidationGroup="enter" onclick="butStep2_Click" /><br />
        </asp:Panel>
        <asp:Panel ID="pnlQuestion" runat="server" Visible="false">
            <h3>Please answer the security question</h3>
            <strong>Question:</strong><br />
            <asp:Label ID="lblQuestion" runat="server" /><br />
            <strong>Answer:</strong><asp:RequiredFieldValidator ID="reqAnswer" runat="server" Display="Dynamic" ControlToValidate="txtAnswer" ErrorMessage="Please provide an answer for the security question" ValidationGroup="answer" /><br />
            <asp:TextBox ID="txtAnswer" runat="server" ValidationGroup="answer" /><br />
            <asp:Button ID="butAnswer" runat="server" Text="Submit Answer" 
                ValidationGroup="answer" onclick="butAnswer_Click" /><br />
            <asp:CustomValidator ID="valAnswer" runat="server" Display="Dynamic" ControlToValidate="txtAnswer" ErrorMessage="The answer provided is incorrect" ValidationGroup="answer" />
        </asp:Panel>
        <asp:Panel ID="pnlNewPass" runat="server" Visible="false">
            <h3>Choose a new password</h3>
            <strong>New Password:</strong><asp:RequiredFieldValidator ID="reqNewPassword" runat="server" ControlToValidate="txtNewPassword" Display="Dynamic" ErrorMessage="Please enter a new password" ValidationGroup="reset" /><br />
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" ValidationGroup="reset" /><br />
            <strong>Confirm Password:</strong><asp:RequiredFieldValidator ID="reqConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" Display="Dynamic" ErrorMessage ="Please confirm your new password" ValidationGroup="reset" />
            <asp:CompareValidator ID="cmpPassword" runat="server" ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmPassword" Display="Dynamic" Operator="Equal" ErrorMessage="The passwords entered do not match" ValidationGroup="reset" /><br />
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" ValidationGroup="reset" /><br />
            <asp:Button ID="butResetPassword" runat="server" Text="Reset Password" 
                ValidationGroup="reset" onclick="butResetPassword_Click" />
        </asp:Panel>
        <asp:Panel ID="pnlEmail" runat="server" Visible="false">
            <h3>Email Sent</h3>
            <p>An email has been sent to the address associated with your account. This e-mail contains instructions for reseting your password.</p>
        </asp:Panel>
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <h3>Password Reset</h3>
            <p>Your password has been reset and you are now logged in.</p>
        </asp:Panel>
        </ContentTemplate>
</asp:UpdatePanel>
</div>