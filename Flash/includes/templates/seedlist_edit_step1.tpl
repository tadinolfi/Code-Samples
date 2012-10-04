<form method="post" action="index.php?Page=Seedlist&Action=Edit&SubAction=Save&Seed=%%GLOBAL_SeedID%%" onsubmit="return CheckForm()">
	<table cellspacing="0" cellpadding="3" width="95%" align="center">
		<tr>
			<td class="heading1">
				%%GLOBAL_Heading%%
			</td>
		</tr>
		<tr>
			<td class="Intro">
				%%LNG_Seedlist_Create_Step1_Intro%%
			</td>
		</tr>
		<tr>
			<td>
				%%GLOBAL_Message%%
			</td>
		</tr>
		<tr>
			<td>
				<input class="formbutton" type="button" value="%%LNG_Cancel%%" onClick='if(confirm("%%LNG_Seedlist_Add_CancelPrompt%%")) { document.location="index.php?Page=Seedlist" }'>
				<input class="formbutton" type="button" value="%%LNG_Save%%" onClick="SaveAdd();">
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="panel">
					<tr>
						<td colspan="2" class="heading2">
							&nbsp;&nbsp;%%LNG_NewSeedDetails%%
						</td>
					</tr>
					<tr>
						<td width="200" class="FieldLabel">
							%%TPL_Required%%
							%%LNG_Email%%:&nbsp;
						</td>
						<td>
							<input type="text" name="emailaddress" value="%%GLOBAL_emailaddress%%" class="field250">
						</td>
					</tr>
					
					<tr>
						<td>&nbsp;
							
						</td>
						<td height="35">
							<input class="formbutton" type="button" value="%%LNG_Cancel%%" onClick='if(confirm("%%LNG_Seedlist_Add_CancelPrompt%%")) { document.location="index.php?Page=Seedlist" }'>
							<input class="formbutton" type="button" value="%%LNG_Save%%" onClick="SaveAdd();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<script language="javascript">
	function SaveAdd() {
		if (!CheckForm()) {
			return false;
		}
		var f = document.forms[0];
		f.action = 'index.php?Page=Seedlist&Action=Edit&SubAction=SaveAdd&Seed=%%GLOBAL_SeedID%%';
		f.submit();
	}

	function CheckForm() {
		var f = document.forms[0];
		if (f.emailaddress.value == "") {
			alert("%%LNG_Seedlist_EnterEmailAddress%%");
			f.emailaddress.focus();
			return false;
		}
		%%GLOBAL_ExtraJavascript%%
		return true;
	}

</script>