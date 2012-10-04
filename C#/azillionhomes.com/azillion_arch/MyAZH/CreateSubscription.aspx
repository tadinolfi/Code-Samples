<%@ Page Title="" Language="C#" MasterPageFile="~/MyAZH/dashboard.master" AutoEventWireup="true" CodeFile="CreateSubscription.aspx.cs" Inherits="MyAZH_CreateSubscription" Theme="azh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Namespace="AZHControls" TagPrefix="azh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="dashboardContent" Runat="Server">
    <h1 id="hdrMyBilling">
        <asp:Image ID="imgBilling" runat="server" ImageUrl="~/images/headers/billing-information.gif" />
    </h1>  
	<hr />
	<asp:Panel ID="pnlAgencySubscription" runat="server" Visible="false" >
	    <h2>You are creating this subscription on behalf of <asp:Label ID="lblBehalfUser" runat="server" /></h2>
	</asp:Panel>
	<asp:UpdatePanel ID="pnlUpdateSubscription" runat="server">
	    <ContentTemplate>
	        <asp:Panel ID="pnlSubscriptionDetails" runat="server">
	            <h3>Subscription Details</h3>
	            <dl class="pairedValueList">
	                <dt>Subscription Price:</dt>
	                <dd><asp:Label ID="lblPrice" runat="server" /></dd>
	            </dl>
	            <asp:Panel ID="pnlCoupon" runat="server">
	            <label style="clear:both;">Coupon Code:</label>
	            <asp:TextBox ID="txtCoupon" runat="server" ValidationGroup="coupon" />
	            <asp:Button ID="butCoupon" runat="server" Text="Enter Coupon" onclick="butCoupon_Click" ValidationGroup="coupon" /><br />
	            <strong><asp:Label ID="lblCoupon" runat="server" /></strong>
	            <br /><br />
	            </asp:Panel>
	            <asp:HiddenField ID="hidPrice" runat="server" />
	            <asp:HiddenField ID="hidMonths" runat="server" Value="0" />
	            <asp:HiddenField ID="couponUsed" runat="server" Value="0" />
	        </asp:Panel>
	    </ContentTemplate>
	</asp:UpdatePanel>
	<asp:UpdatePanel ID="pnlUpdate" runat="server">
	    <ContentTemplate>    
	        <asp:Panel ID="pnlSubscription" runat="server">
	            <h3 id="createHeading" runat="server" style="clear:both;">Please enter the following billing information to subscribe to AZH.</h3>
	            <asp:Panel ID="pnlRenew" runat="server" Visible="false" style="clear:both;">
	                <h3>Please enter the following billing information to renew your subscription with AZH.</h3>
	                <p>This subscription renewal will extend your current subscription to <asp:Literal ID="litRenewDate" runat="server" /></p>
	            </asp:Panel>            
	            <div class="myPostingsForms">
	                <azh:AZHField ID="txtFirstName" runat="server" FieldName="First Name:" Required="true" />
	                <azh:AZHField ID="txtLastName" runat="server" FieldName="Last Name:" Required="true" AltRow="true" />
	                <azh:AZHField ID="txtCardNumber" runat="server" FieldName="Card Number:" Required="true" />
	                <azh:AZHField ID="txtCVN" runat="server" FieldName="CVN Number:" Required="true" AltRow="true" />
	                <div class="formRow expDate">
	                    <span class="required">*</span>
	                    <strong>Expiration Date:</strong>
	                    <asp:DropDownList ID="ddlMonth" Width="60" runat="server">
	                        <asp:ListItem Text="Jan" Value="01" />
	                        <asp:ListItem Text="Feb" Value="02" />
	                        <asp:ListItem Text="Mar" Value="03" />
	                        <asp:ListItem Text="Apr" Value="04" />
	                        <asp:ListItem Text="May" Value="05" />
	                        <asp:ListItem Text="Jun" Value="06" />
	                        <asp:ListItem Text="Jul" Value="07" />
	                        <asp:ListItem Text="Aug" Value="08" />
	                        <asp:ListItem Text="Sep" Value="09" />
	                        <asp:ListItem Text="Oct" Value="10" />
	                        <asp:ListItem Text="Nov" Value="11" />
	                        <asp:ListItem Text="Dec" Value="12" />
	                    </asp:DropDownList>
	                    <asp:DropDownList ID="ddlYear" Width="80" runat="server">
	                    </asp:DropDownList>
	                </div>
	            </div>
	            <h2>Billing Address</h2><div class="myPostingsForms">
	                <azh:AZHField ID="txtEmail" runat="server" FieldName="Email" />
	                <azh:AZHField ID="txtAddress" runat="server" FieldName="Address" AltRow="true" Required="true" />
	                <azh:AZHField ID="txtCity" runat="server" FieldName="City" Required="true" />
	                <div class="formRow altRowColor">
	                    <label>State:</label>
	                    <asp:DropDownList ID="ddlState" runat="server" DataSourceID="StateDataSource" 
                            DataTextField="Name" DataValueField="Abbreviation">
            	        
	                    </asp:DropDownList>
	                    <asp:LinqDataSource ID="StateDataSource" runat="server" 
                            ContextTypeName="DataClassesDataContext" OrderBy="Name" 
                            Select="new (Name, Abbreviation)" TableName="States" 
                            Where="Minor == @Minor &amp;&amp; CountryID == @CountryID">
                            <WhereParameters>
                                <asp:Parameter DefaultValue="false" Name="Minor" Type="Boolean" />
                                <asp:Parameter DefaultValue="1" Name="CountryID" Type="Int32" />
                            </WhereParameters>
                        </asp:LinqDataSource>
	                </div>
	                <azh:AZHField ID="txtZip" runat="server" FieldName="Zip" Required="true" />
	            </div>
	            <asp:ImageButton ID="imgSubmit" runat="server" ImageUrl="~/images/buttons/submit.gif" OnClick="imgSubmit_Click" />
	            <asp:ImageButton ID="imgCancel" CausesValidation="false" runat="server" ImageUrl="~/images/buttons/cancel.gif" onclick="imgCancel_Click" />
	            <asp:LinkButton ID="butMPE" runat="server" />
                <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="butMPE" CancelControlID="butCancel" PopupControlID="pnlConfirm" DropShadow="false" BackgroundCssClass="modalBackground">
                </cc1:ModalPopupExtender>
                <asp:Panel ID="pnlConfirm" runat="server" CssClass="modalPopup" Width="500px">
                    <h3>Please confirm your payment amount</h3>
                    <p>Your card will be charged <strong><asp:Label ID="lblConfirmAmount" runat="server" /></strong> every month on the <strong><asp:Label ID="lblConfirmDay" runat="server" /></strong>.
                    Please click the confirm button below to confirm your subscription billing.</p>
                    <asp:Button ID="butConfirm" runat="server" Text="Confirm Subscription" onclick="butConfirm_Click" />
                    <asp:Button ID="butCancel" runat=server Text="Cancel" />
                </asp:Panel>
            </asp:Panel>
            <asp:Panel ID="pnlFreeSubscription" runat="server" Visible="false">
                <p>No billing information is required for free subscriptions. You subscription is now active.</p>
                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/MyAZH/Default.aspx">Return to the Dashboard</asp:HyperLink>
            </asp:Panel>
            <asp:Panel ID="pnlNewSubscription" runat="server" Visible="false">
                <h2>Your subscription has been created</h2>
                <p>Your subscription has been created and is active.</p>
            </asp:Panel>
        </ContentTemplate>  
	</asp:UpdatePanel>
	<asp:UpdateProgress ID="prgUpdate" runat="server">
	    <ProgressTemplate>
	        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
	    </ProgressTemplate>
	</asp:UpdateProgress>
</asp:Content>

