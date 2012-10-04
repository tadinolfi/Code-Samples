<form method="post" action="index.php?Page=Bounce&Action=Step2" onsubmit="return CheckForm();">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">
				%%LNG_Bounce_Step1%%
			</td>
		</tr>
		<tr>
			<td class="body pageinfo">
				<p>
					%%LNG_Bounce_Step1_Intro%%
				</p>
			</td>
		</tr>
		<tr>
			<td>
				%%GLOBAL_Message%%
			</td>
		</tr>
		<tr>
			<td>
				<input class="FormButton" type="submit" value="%%LNG_Next%%">
				<input class="FormButton" type="button" value="%%LNG_Cancel%%" onClick='if(confirm("%%LNG_Bounce_CancelPrompt%%")) { document.location="index.php?Page=Bounce" }'>
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_SelectAContactList%%
						</td>
					</tr>
					<tr>
						<td width="200" class="FieldLabel">
							{template="Required"}
							%%LNG_SelectContactList_Explain%%:&nbsp;
						</td>
						<td>
							<select name="list" style="width: 350px" size="9" onDblClick="CheckForm() && this.form.submit()">
								%%GLOBAL_SelectList%%
							</select>&nbsp;%%LNG_HLP_MailingList%%
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input class="FormButton" type="submit" value="%%LNG_Next%%">
							<input class="FormButton" type="button" value="%%LNG_Cancel%%" onClick='if(confirm("%%LNG_Bounce_CancelPrompt%%")) { document.location="index.php?Page=Bounce" }'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<script>
	function CheckForm() {
		var f = document.forms[0];
		if (f.list.selectedIndex < 0) {
			alert("%%LNG_SelectList%%");
			f.list.focus();
			return false;
		}
		return true;
	}
</script>
