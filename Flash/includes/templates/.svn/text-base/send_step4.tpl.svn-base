<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td class="Heading1">
			<div class="Heading1Image"><img src="images/headerimages/%%LNG_Send_Step4%%.jpg" alt="%%LNG_Send_Step4%%" /></div><div class="Heading1Text">%%LNG_Send_Step4%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
		</td>
	</tr>
	<tr>
		<td class="body pageinfo">
			<p>
				%%GLOBAL_SentToTestListWarning%%
				%%GLOBAL_ImageWarning%%
				%%GLOBAL_EmailSizeWarning%%
				%%LNG_Send_Step4_Intro%%
			</p>
			<ul style="margin-bottom:0px">
				<li>%%GLOBAL_Send_NewsletterName%%</li>
				<li>%%GLOBAL_Send_NewsletterSubject%%</li>
				<li>%%GLOBAL_Send_SubscriberList%%</li>
				<li>%%GLOBAL_Send_TotalRecipients%%</li>
				%%GLOBAL_ApproximateSendSize%%
				<li>%%LNG_Send_Not_Completed%%</li>
			</ul>
			<br />
		</td>
	</tr>
	<tr>
		<td class="body">
			<input type="button" value="%%LNG_StartSending%%" class="SmallButton" style="font-weight:bold; width:190px" onclick="javascript: PopupWindow();">
			<input type="button" value="%%LNG_Cancel%%" class="FormButton" onclick="if(confirm('%%LNG_ConfirmCancelSend%%')) {document.location='index.php?Page=Newsletters';}">
		</td>
	</tr>
</table>
<script>
	function PopupWindow() {
		var top = screen.height / 2 - (170);
		var left = screen.width / 2 - (225);

		if(confirm('%%LNG_PopupSendWarning%%')) {
			window.open("index.php?Page=Send&Action=Send&Job=%%GLOBAL_JobID%%","sendWin","left=" + left + ",top="+top+",toolbar=false,status=no,directories=false,menubar=false,scrollbars=false,resizable=false,copyhistory=false,width=450,height=290");
		}
	}
</script>
