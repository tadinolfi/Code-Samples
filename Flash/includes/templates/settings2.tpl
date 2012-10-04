<script src="includes/js/jquery/form.js"></script>
<script src="includes/js/jquery/thickbox.js"></script>
<link rel="stylesheet" type="text/css" href="includes/styles/thickbox.css" />
<script>
	$(function() {
		$(document.settings).submit(function(event) {
			if ($(document.settings.email_address).val().trim() == '') {
				alert('%%LNG_ErrorAlertMessage_BlankContactEmail%%');
				document.settings.email_address.focus();
				event.preventDefault();
				event.stopPropagation();
				return false;
			}

			if ($(document.settings.licensekey).val().trim() == '') {
				alert('%%LNG_ErrorAlertMessage_BlankLicenseKey%%');
				document.settings.licensekey.focus();
				event.preventDefault();
				event.stopPropagation();
				return false;
			}

			if (!this.usesmtp['usesmtp'].checked) {
				$('form#frmSettings .smtpSettings').attr('value', '');
			}

			return true;
		});

		$('input.CancelButton', document.settings).click(function() {
			if (confirm("%%LNG_ConfirmCancel%%")) {
				document.location.href='index.php';
			} else {
				return false;
			}
		});

		$(document.settings.cmdPreviewEmail).click(function() {
			var f = document.forms[0];
			if (f.PreviewEmail.value == "") {
				alert("%%LNG_EnterPreviewEmail%%");
				f.PreviewEmail.focus();
				return false;
			}

			tb_show('', 'index.php?Page=Settings&Action=SendPreviewDisplay&keepThis=true&TB_iframe=true&height=250&width=420&modal=true', '');
			return true;
		});

		$(document.settings.allow_attachments).click(function() { $('#ShowAttachmentSize').toggle(); });

		$(document.settings.allow_embedimages).click(function() { $('#ShowDefaultEmbeddedImages')[this.checked? 'show' : 'hide' ](); });

		$(document.settings.usesmtp).click(function() {
			$('.SMTPOptions')[$('#usesmtp').attr('checked') ? 'show' : 'hide']();
			$('.sectionSignuptoSMTP')[$('#signtosmtp').attr('checked') ? 'show' : 'hide']();
			$('#sectionSMTPComOption').html($('#signtosmtp').attr('checked') ? '%%LNG_SMTPCOM_UseSMTPOption%% %%LNG_SMTPCOM_UseSMTPOptionSeeBelow%%' : '%%LNG_SMTPCOM_UseSMTPOption%%');
		});

		$(document.settings.cmdTestSMTP).click(function() {
			var f = document.forms[0];
			if (f.smtp_server.value == '') {
				alert("%%LNG_EnterSMTPServer%%");
				f.smtp_server.focus();
				return false;
			}

			if (f.smtp_test.value == '') {
				alert("%%LNG_EnterTestEmail%%");
				f.smtp_test.focus();
				return false;
			}

			tb_show('', 'index.php?Page=Settings&Action=SendSMTPPreviewDisplay&keepThis=true&TB_iframe=tue&height=250&width=420&modal=true', '');
			return true;
		});

		$('input.OnFocusSelect', document.settings).focus(function() { this.select(); });

	});

	function getPreviewParameters() {
		var values = getSMTPPreviewParameters();
		$($('form#frmSettings .emailPreviewSettings').fieldSerialize().split('&')).each(function(i,n) {
			var temp = n.split('=');
			if (temp.length == 2) values[temp[0]] = temp[1];
		});
		return values;
	}

	function getSMTPPreviewParameters() {
		var values = {};
		$($('form#frmSettings .smtpSettings').fieldSerialize().split('&')).each(function(i,n) {
			var temp = n.split('=');
			if (temp.length == 2) values[temp[0]] = temp[1];
		});
		return values;
	}

	function closePopup()
	{
		tb_remove();
	}
</script>

<form name="settings" id="frmSettings" method="post" action="index.php?Page=%%PAGE%%&%%GLOBAL_FormAction%%">
<table cellspacing="0" cellpadding="0" width="100%" align="center" style="margin-left: 4px;">
	<tr>
		<td class="Heading1">%%LNG_Settings%%</td>
	</tr>
	<tr>
		<td class="body">%%LNG_Help_Settings%%</td>
	</tr>
	<tr>
		<td>
			%%GLOBAL_Message%%
			<span style="display: %%GLOBAL_DisplayDbUpgrade%%">
				%%GLOBAL_DbUpgradeMessage%%
			</span>
			<span style="display: %%GLOBAL_DisplayAttachmentsMessage%%">
				%%GLOBAL_Attachments_Message%%
			</span>
			%%GLOBAL_Send_TestMode_Report%%
		</td>
	</tr>
	<tr>
		<td class="body">
			<input class="FormButton SubmitButton" type="submit" value="%%LNG_Save%%" />
			<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
		</td>
	</tr>
	<tr>
		<td>
			<div>
				<br/>
				<ul id="tabnav">
						<li><a class="active" href="#" onClick="ShowTab(1); return false;" id="tab1"><span>%%LNG_ApplicationSettings_Heading%%</span></a></li>
						<li><a href="#" onClick="ShowTab(2); return false;" id="tab2"><span>%%LNG_EmailSettings_Heading%%</span></a></li>
				</ul>
				<div id="div1" style="padding-top:10px">
					<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_Miscellaneous%%
							</td>
						</tr>
						<tr>
							<td width="200" class="FieldLabel">
								{template="Required"}
								%%LNG_ApplicationURL%%:
							</td>
							<td>
								<input type="hidden" name="application_url" value="%%GLOBAL_ApplicationURL%%" />
								<input type="text" value="%%GLOBAL_ApplicationURL%%" class="Field250" readonly="readonly"> %%LNG_HLP_ApplicationURL%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								<span class=required>*</span> %%LNG_ApplicationEmail%%:
							</td>
							<td>
								<input type="text" name="email_address" value="%%GLOBAL_EmailAddress%%" class="Field250"> %%LNG_HLP_ApplicationEmail%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_IpTracking%%:
							</td>
							<td>
								<label for="iptracking"><input type="checkbox" name="iptracking" id="iptracking" value="1"%%GLOBAL_IpTracking%%>%%LNG_IpTrackingExplain%%</label> %%LNG_HLP_IpTracking%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_Charset%%:
							</td>
							<td>
								<input type="hidden" name="defaultcharset" value="%%GLOBAL_DefaultCharset%%">
								%%GLOBAL_CharsetDescription%%&nbsp;&nbsp;&nbsp;%%LNG_HLP_Charset%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_ServerTimeZone%%:
							</td>
							<td valign="top">
								<input type="hidden" name="servertimezone" value="%%GLOBAL_ServerTimeZone%%">
								%%GLOBAL_ServerTimeZoneDescription%%&nbsp;&nbsp;&nbsp;%%LNG_HLP_ServerTimeZone%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_CurrentServerTime%%:
							</td>
							<td>
								%%GLOBAL_ServerTime%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_SystemMessage%%:
							</td>
							<td>
								<textarea name="system_message" rows="3" cols="28" wrap="virtual" style="width: 250px;">%%GLOBAL_System_Message%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_SystemMessage%%
							</td>
						</tr>
						<tr>
							<td colspan="2" class="EmptyRow">
								&nbsp;
							</td>
						</tr>
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_DatabaseIntro%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_DatabaseType%%:
							</td>
							<td class=body>
								[%%GLOBAL_DatabaseType%%]
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Required"}
								%%LNG_DatabaseUser%%:
							</td>
							<td>
								<input type="hidden" name="database_u" value="%%GLOBAL_DatabaseUser%%" />
								<input type="text" value="%%GLOBAL_DatabaseUser%%" class="Field250 OnFocusSelect" readonly="readonly" disabled="disabled"> %%LNG_HLP_DatabaseUser%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_DatabasePassword%%:
							</td>
							<td>
								<input type="hidden" name="database_p" value="%%GLOBAL_DatabasePass%%" />
								<input type="password" value="%%GLOBAL_DatabasePass%%" class="Field250 OnFocusSelect" readonly="readonly" disabled="disabled" autocomplete="off" /> %%LNG_HLP_DatabasePassword%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Required"}
								%%LNG_DatabaseHost%%:
							</td>
							<td>
								<input type="hidden" name="database_host" value="%%GLOBAL_DatabaseHost%%" />
								<input type="text" value="%%GLOBAL_DatabaseHost%%" class="Field250 OnFocusSelect" readonly="readonly" disabled="disabled"> %%LNG_HLP_DatabaseHost%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Required"}
								%%LNG_DatabaseName%%:
							</td>
							<td>
								<input type="hidden" name="database_name" value="%%GLOBAL_DatabaseName%%" />
								<input type="text" value="%%GLOBAL_DatabaseName%%" class="Field250 OnFocusSelect" readonly="readonly" disabled="disabled"> %%LNG_HLP_DatabaseName%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_DatabaseTablePrefix%%:
							</td>
							<td>
								<input type="hidden" name="tableprefix" value="%%GLOBAL_DatabaseTablePrefix%%" />
								<input type="text" value="%%GLOBAL_DatabaseTablePrefix%%" class="Field250 OnFocusSelect" readonly="readonly" disabled="disabled"> %%LNG_HLP_DatabaseTablePrefix%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_DatabaseVersion%%:
							</td>
							<td>
								%%GLOBAL_DatabaseVersion%%
							</td>
						</tr>
						<tr>
							<td colspan="2" class="EmptyRow">
								&nbsp;
							</td>
						</tr>
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_LicenseKeyIntro%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Required"}
								%%LNG_LicenseKey%%:
							</td>
							<td>
								<input type="text" name="licensekey" id="licensekey" value="%%GLOBAL_LicenseKey%%" class="Field250"> %%LNG_HLP_LicenseKey%%
							</td>
						</tr>
						<tr>
							<td colspan="2" class="EmptyRow">
								&nbsp;
							</td>
						</tr>
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_SendTestIntro%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_TestEmailAddress%%:
							</td>
							<td>
								<input type="text" name="PreviewEmail" value="" class="Field250 emailPreviewSettings" />
								<input type="button" name="cmdPreviewEmail" value="%%LNG_Send%%" class="Field" />
								%%LNG_HLP_TestEmailAddress%%
							</td>
						</tr>
					</table>
				</div>
				<div id="div2" style="padding-top:10px; display:none;">
					<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_EmailSettings%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_EmailSize_Warning%%:
							</td>
							<td>
								<input type="text" name="emailsize_warning" value="%%GLOBAL_EmailSize_Warning%%" class="Field250" style="width: 50px;">%%LNG_EmailSize_Warning_KB%% %%LNG_HLP_EmailSize_Warning%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_EmailSize_Maximum%%:
							</td>
							<td>
								<input type="text" name="emailsize_maximum" value="%%GLOBAL_EmailSize_Maximum%%" class="Field250" style="width: 50px;">%%LNG_EmailSize_Maximum_KB%% %%LNG_HLP_EmailSize_Maximum%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_MaxHourlyRate%%:
							</td>
							<td>
								<input type="text" name="maxhourlyrate" value="%%GLOBAL_MaxHourlyRate%%" class="Field250" style="width: 50px;"> %%LNG_HLP_MaxHourlyRate%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_MaxOverSize%%:
							</td>
							<td>
								<input type="text" name="maxoversize" value="%%GLOBAL_MaxOverSize%%" class="Field250" style="width: 50px;"> %%LNG_HLP_MaxOverSize%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_Resend_Maximum%%:
							</td>
							<td>
								<input type="text" name="resend_maximum" value="%%GLOBAL_Resend_Maximum%%" class="Field250" style="width: 50px;"> %%LNG_HLP_Resend_Maximum%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_MaxImageWidth%%:
							</td>
							<td>
								<input type="text" name="max_imagewidth" value="%%GLOBAL_MaxImageWidth%%" class="Field250" style="width: 50px;"> %%LNG_HLP_MaxImageWidth%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_MaxImageHeight%%:
							</td>
							<td>
								<input type="text" name="max_imageheight" value="%%GLOBAL_MaxImageHeight%%" class="Field250" style="width: 50px;"> %%LNG_HLP_MaxImageHeight%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_GlobalHTMLFooter%%:
							</td>
							<td>
								<textarea name="htmlfooter" rows="3" cols="28" wrap="virtual" style="width: 250px;">%%GLOBAL_HTMLFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_GlobalHTMLFooter%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_GlobalTextFooter%%:
							</td>
							<td>
								<textarea name="textfooter" rows="3" cols="28" wrap="virtual" style="width: 250px;">%%GLOBAL_TextFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_GlobalTextFooter%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_ForceUnsubLink%%:
							</td>
							<td>
								<label for="force_unsublink"><input type="checkbox" name="force_unsublink" id="force_unsublink" value="1"%%GLOBAL_ForceUnsubLink%%>%%LNG_ForceUnsubLinkExplain%%</label> %%LNG_HLP_ForceUnsubLink%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_AllowAttachments%%:
							</td>
							<td>
								<div>
									<label for="allow_attachments">
										<input type="checkbox" name="allow_attachments" id="allow_attachments" value="1"%%GLOBAL_AllowAttachments%%>%%LNG_AllowAttachmentsExplain%%
									</label>
									%%LNG_HLP_AllowAttachments%%
								</div>
								<div id="ShowAttachmentSize" style="display: %%GLOBAL_ShowAttachmentSize%%">
									<div>
										<img width="20" height="20" src="images/nodejoin.gif"/>
										%%LNG_MaxAttachmentSize%%
										<input type="text" name="attachment_size" value="%%GLOBAL_AttachmentSize%%" class="Field250" style="width: 50px;">%%LNG_MaxAttachmentSizeKB%%
										%%LNG_HLP_MaxAttachmentSize%%
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_AllowEmbeddedImages%%:
							</td>
							<td>
								<div>
									<label for="allow_embedimages">
										<input type="checkbox" name="allow_embedimages" id="allow_embedimages" value="1"%%GLOBAL_AllowEmbedImages%%>%%LNG_AllowEmbeddedImagesExplain%%
									</label>
									%%LNG_HLP_AllowEmbeddedImages%%
								</div>
								<div id="ShowDefaultEmbeddedImages" style="display: %%GLOBAL_ShowDefaultEmbeddedImages%%">
									<div>
										<img width="20" height="20" src="images/nodejoin.gif"/>
										<label for="default_embedimages">
											<input type="checkbox" name="default_embedimages" id="default_embedimages" value="1"%%GLOBAL_DefaultEmbedImages%%>%%LNG_DefaultEmbeddedImagesExplain%%
										</label>
										%%LNG_HLP_DefaultEmbeddedImages%%
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_Send_TestMode%%:
							</td>
							<td>
								<label for="send_test_mode">
									<input type="checkbox" name="send_test_mode" id="send_test_mode" value="1"%%GLOBAL_SendTestMode%%>%%LNG_Send_TestModeExplain%%
								</label>
								%%LNG_HLP_Send_TestMode%%
							</td>
						</tr>
						<tr>
							<td colspan="2" class="EmptyRow">
								&nbsp;
							</td>
						</tr>
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_SmtpServerIntro%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_UseSMTP%%:
							</td>
							<td>
								<label for="usephpmail">
									<input type="radio" name="usesmtp" id="usephpmail" value="0"%%GLOBAL_UseDefaultMail%%/>
									%%LNG_SmtpDefaultSettings%%
								</label>
								%%LNG_HLP_UseDefaultMail%%
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">&nbsp;</td>
							<td>
								<label for="usesmtp">
									<input type="radio" name="usesmtp" id="usesmtp" value="1"%%GLOBAL_UseSMTP%%/>
									%%LNG_SmtpCustom%%
								</label>
								%%LNG_HLP_UseSMTP%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								{template="Required"}
								%%LNG_SmtpServerName%%:
							</td>
							<td>
								<img width="20" height="20" src="images/nodejoin.gif"/>
								<input type="text" name="smtp_server" id="smtp_server" value="%%GLOBAL_Smtp_Server%%" class="Field250 smtpSettings"> %%LNG_HLP_SmtpServerName%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_SmtpServerUsername%%:
							</td>
							<td>
								<img width="20" height="20" src="images/blank.gif"/>
								<input type="text" name="smtp_u" id="smtp_u" value="%%GLOBAL_Smtp_Username%%" class="Field250 smtpSettings"> %%LNG_HLP_SmtpServerUsername%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_SmtpServerPassword%%:
							</td>
							<td>
								<img width="20" height="20" src="images/blank.gif"/>
								<input type="password" name="smtp_p" id="smtp_p" value="%%GLOBAL_Smtp_Password%%" class="Field250 smtpSettings" autocomplete="off" /> %%LNG_HLP_SmtpServerPassword%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_SmtpServerPort%%:
							</td>
							<td>
								<img width="20" height="20" src="images/blank.gif"/>
								<input type="text" name="smtp_port" id="smtp_port" value="%%GLOBAL_Smtp_Port%%" class="Field250 smtpSettings"> %%LNG_HLP_SmtpServerPort%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								{template="Not_Required"}
								%%LNG_TestSendTo%%:
							</td>
							<td>
								<img width="20" height="20" src="images/blank.gif"/>
								<input type="text" name="smtp_test" id="smtp_test" value="" class="Field250 smtpSettings"> %%LNG_HLP_TestSMTPSettings%%
							</td>
						</tr>
						<tr class="SMTPOptions" style="display: %%GLOBAL_DisplaySMTP%%">
							<td class="FieldLabel">
								&nbsp;
							</td>
							<td>
								<img width="20" height="20" src="images/blank.gif"/>
								<input type="button" name="cmdTestSMTP" value="%%LNG_TestSMTPSettings%%" class="FormButton" style="width: 120px;" />
							</td>
						</tr>
						<tr>
							<td class="FieldLabel">&nbsp;</td>
							<td>
								<label for="signtosmtp">
									<input type="radio" name="usesmtp" id="signtosmtp" value="2" />
									<span id="sectionSMTPComOption">%%LNG_SMTPCOM_UseSMTPOption%%</span>
								</label>
								%%LNG_HLP_UseSMTPCOM%%
							</td>
						</tr>
						<tr class="sectionSignuptoSMTP" style="display: none;">
							<td colspan="2" class="EmptyRow">
								&nbsp;
							</td>
						</tr>
						<tr class="sectionSignuptoSMTP" style="display: none;">
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_SMTPCOM_Header%%
							</td>
						</tr>
						<tr class="sectionSignuptoSMTP" style="display: none;">
							<td colspan="2" style="padding-left: 20px;">%%LNG_SMTPCOM_Explain%%</td>
						</tr>
						{template="bounce_details"}
					</table>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="2" width="100%" class=PanelPlain>
				<tr>
					<td width="200" class="FieldLabel">
						&nbsp;
					</td>
					<td>
						<input type="hidden" name="database_type" value="%%GLOBAL_DatabaseType%%" />
						<input class="FormButton SubmitButton" type="submit" value="%%LNG_Save%%" />
						<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

	<script>
	function UpgradeDb()
	{
		f = document.forms[0];
		var top = screen.height / 2 - (100);
		var left = screen.width / 2 - (200);

		f.target = "upgradeDb";
		window.open("","upgradeDb","left=" + left + ",top="+top+",toolbar=false,status=no,directories=false,menubar=false,scrollbars=false,resizable=false,copyhistory=false,width=400,height=200");

		prevAction = f.action;
		f.action = "index.php?Page=Settings&Action=UpgradeDb";
		f.submit();

		f.target = "";
		f.action = prevAction;
	}

	function ShowReport(reporttype)
	{
		var link = 'index.php?Page=Settings&Action=ViewDisabled&Report=' + reporttype;

		var top = screen.height / 2 - (230);
		var left = screen.width / 2 - (250);

		window.open(link,"reportWin","left=" + left + ",top="+top+",toolbar=false,status=no,directories=false,menubar=false,scrollbars=false,resizable=false,copyhistory=false,width=500,height=460");
	}

	</script>

%%GLOBAL_ExtraScript%%
