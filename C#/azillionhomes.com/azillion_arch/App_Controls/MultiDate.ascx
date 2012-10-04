<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MultiDate.ascx.cs" Inherits="App_Controls_MultiDate" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Namespace="AZHControls" TagPrefix="azh" %>

<asp:Panel ID="pnlDates" runat="server" CssClass="formRow altRowColor">
    <asp:LinkButton ID="lnkDates" CssClass="multiDateLink" runat="server">Click Here to Edit Dates <asp:Image ID="imgCal" runat="server" ImageUrl="~/images/content/Calendar.gif" /></asp:LinkButton>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="butClose" DropShadow="false" BackgroundCssClass="modalBackground" TargetControlID="lnkDates" PopupControlID="pnlPopup">
    </cc1:ModalPopupExtender>
    <div style="z-index: 100000001;position:relative;">
        <asp:Panel ID="pnlPopup" runat="server" Width="500px" CssClass="modalPopup">
            <h3>Select Open House Dates</h3>
            <p>Please select up to 10 dates for your open house.</p>
            <asp:Panel ID="pnlDateFields" runat="server">
                <azh:AZHField ID="txtDate1" ZIndex="80000" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 1" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate2" ZIndex="79999" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 2" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate3" ZIndex="79998" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 3" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate4" ZIndex="79997" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 4" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate5" ZIndex="79996" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 5" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate6" ZIndex="79995" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 6" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate7" ZIndex="79994" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 7" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate8" ZIndex="79993" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 8" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate9" ZIndex="79992" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 9" onvaluechanged="txtDate_ValueChanged" />
                <azh:AZHField ID="txtDate10" ZIndex="79991" runat="server" FormFieldType="Date" Value="blank" FieldName="Open House Date 10" onvaluechanged="txtDate_ValueChanged" />
            </asp:Panel>
            <asp:Button ID="butClose" runat="server" Text="Close" CausesValidation="false" />
        </asp:Panel>
    </div>
</asp:Panel>