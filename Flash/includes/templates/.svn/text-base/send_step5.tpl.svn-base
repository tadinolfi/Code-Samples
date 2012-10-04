<table cellspacing="0" cellpadding="3" width="100%" align="center">
	<tr>
		<td class="Heading1">
			<div class="Heading1Image"><img src="images/headerimages/%%LNG_Send_Step5%%.jpg" alt="%%LNG_Send_Step5%%" /></div><div class="Heading1Text">%%LNG_Send_Step5%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
		</td>
	</tr>
	<tr>
		<td class="body pageinfo">
			%%LNG_Send_Step5_KeepBrowserWindowOpen%%
		</td>
	</tr>
	<tr>
		<td class="body">
			<ul style="line-height:1.5; margin-left:30px; padding-left:0px">
				<li>%%GLOBAL_Send_NumberAlreadySent%%</li>
				<li>%%GLOBAL_Send_NumberLeft%%</li>
				<li>%%GLOBAL_SendTimeSoFar%%</li>
				<li>%%GLOBAL_SendTimeLeft%%</li>
			</ul>
			<input type="button" class="SmallButton" style="width:260px" value="%%LNG_PauseSending%%" onclick="PauseSending()" />
		</td>
	</tr>
</table>
<script>
	function PauseSending() {
		window.opener.document.location = 'index.php?Page=Send&Action=PauseSend&Job=%%GLOBAL_JobID%%';
		window.opener.focus();
		window.close();
	}
</script>

<script>
	setTimeout('window.location="index.php?Page=Send&Action=Send&Job=%%GLOBAL_JobID%%&Started=1"', 1);
</script>
