<script src="includes/js/jquery/form.js"></script>
<script src="includes/js/jquery/thickbox.js"></script>
<link rel="stylesheet" type="text/css" href="includes/styles/thickbox.css" />
<script>
	$(function() {
		$(document.settings).submit(function() {
			if (this.ss_p.value != "") {
				if (this.ss_p_confirm.value == "") {
					alert("%%LNG_PasswordConfirmAlert%%");
					this.ss_p_confirm.focus();
					return false;
				}
				if (this.ss_p.value != this.ss_p_confirm.value) {
					alert("%%LNG_PasswordsDontMatch%%");
					this.ss_p_confirm.select();
					this.ss_p_confirm.focus();
					return false;
				}
			}
			return true;
		});

		$('.CancelButton', document.settings).click(function() { if(confirm('Are you sure you want to cancel?')) document.location.href='index.php?Page=ManageAccount'; });

		$('#usewysiwyg').click(function() { $('#sectionUseXHTML').toggle(); });
	});

	function closePopup() {
		tb_remove();
	}
</script>
<form name="settings" method="post" action="index.php?Page=%%PAGE%%&%%GLOBAL_FormAction%%">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/my_account.jpg" alt="%%LNG_MyAccount%%" /></div><div class="Heading1Text">%%LNG_MyAccount%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td>
		</tr>
		<tr>
			<td class="body">%%LNG_Help_MyAccount%%</td>
		</tr>
		<tr>
			<td>
				%%GLOBAL_Message%%
			</td>
		</tr>
		<tr>
			<td class=body>
				<input class="FormButton" type="submit" value="%%LNG_Save%%">
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%">
			</td>
		</tr>
		<tr>
			<td><br>
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					<tr><td class=Heading2 colspan=2>%%LNG_UserDetails%%</td></tr>
					<tr>
						<td class="FieldLabel">
							{template="Required"}
							%%LNG_UserName%%:
						</td>
						<td>
							%%GLOBAL_UserName%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Required"}
							%%LNG_Password%%:
						</td>
						<td>
							<input type="password" name="ss_p" value="" class="Field250" autocomplete="off" />
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Required"}
							%%LNG_PasswordConfirm%%:
						</td>
						<td>
							<input type="password" name="ss_p_confirm" value="" class="Field250" autocomplete="off" />
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_FullName%%:
						</td>
						<td>
							<input type="text" name="fullname" value="%%GLOBAL_FullName%%" class="Field250">
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Required"}
							%%LNG_EmailAddress%%:
						</td>
						<td>
							<input type="text" name="emailaddress" value="%%GLOBAL_EmailAddress%%" class="Field250">&nbsp;%%LNG_HLP_EmailAddress%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Required"}
							%%LNG_TimeZone%%:
						</td>
						<td>
							<select name="usertimezone">
								%%GLOBAL_TimeZoneList%%
							</select>&nbsp;&nbsp;&nbsp;%%LNG_HLP_TimeZone%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_ShowInfoTips%%:
						</td>
						<td>
							<label for="infotips"><input type="checkbox" id="infotips" name="infotips" value="1"%%GLOBAL_InfoTipsChecked%%> %%LNG_YesShowInfoTips%%</label> %%LNG_HLP_ShowInfoTips%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_UseWysiwygEditor%%:
						</td>
						<td>
							<div>
								<label for="usewysiwyg">
									<input type="checkbox" name="usewysiwyg" id="usewysiwyg" value="1"%%GLOBAL_UseWysiwyg%% />
									%%LNG_YesUseWysiwygEditor%%
								</label>
								%%LNG_HLP_UseWysiwygEditor%%
							</div>
							<div id="sectionUseXHTML"%%GLOBAL_UseXHTMLDisplay%%>
								<img width="20" height="20" src="images/nodejoin.gif"/>
								<label for="usexhtml">
									<input type="checkbox" name="usexhtml" id="usexhtml" value="1"%%GLOBAL_UseXHTMLCheckbox%% />
									%%LNG_YesUseXHTML%%
								</label>
								%%LNG_HLP_UseWysiwygXHTML%%
							</div>
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_HTMLFooter%%:
						</td>
						<td>
							<textarea name="htmlfooter" rows="3" cols="28" wrap="virtual">%%GLOBAL_HTMLFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_HTMLFooter%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_TextFooter%%:
						</td>
						<td>
							<textarea name="textfooter" rows="3" cols="28" wrap="virtual">%%GLOBAL_TextFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_TextFooter%%
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>