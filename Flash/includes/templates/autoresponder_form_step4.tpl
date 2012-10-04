<script>
	var Page = {
		CheckForm: 			function() {
								if (document.frmAutoresponderForm.subject.value == "") {
									alert("%%LNG_PleaseEnterAutoresonderSubject%%");
									document.frmAutoresponderForm.subject.focus();
									return false;
								}

								return isDEReady('%%LNG_Editor_WaitToLoad%%');
							},
		Save:				function() {
								if (this.CheckForm()) {
									document.frmAutoresponderForm.action = 'index.php?Page=Autoresponders&Action=%%GLOBAL_SaveAction%%';
									document.frmAutoresponderForm.submit();
								}
							},
		CheckSpam:			function() {
								tb_show('%%LNG_Spam_Guide_Heading%%', 'index.php?Page=Autoresponders&Action=CheckSpamDisplay&keepThis=true&TB_iframe=tue&height=480&width=600', '');
								return true;

								var f = document.frmAutoresponderForm;
								var top = screen.height / 2 - (230);
								var left = screen.width / 2 - (300);

								f.target = "checkSpam";
								window.open("","checkSpam","left=" + left + ",top="+top+",toolbar=false,status=no,directories=false,menubar=false,scrollbars=1,resizable=false,copyhistory=false,width=600,height=460");

								prevAction = f.action;
								f.action = "index.php?Page=Autoresponders&Action=CheckSpam";
								f.submit();

								f.target = "";
								f.action = prevAction;
							},
		ViewCompatibility: 	function() {
								var f = document.frmAutoresponderForm;
								f.target = "_blank";

								prevAction = f.action;
								f.action = "index.php?Page=Autoresponders&Action=ViewCompatibility&ShowBroken=1";
								f.submit();

								f.target = "";
								f.action = prevAction;
							},
		SendPreview:		function() {
								if (document.frmAutoresponderForm.PreviewEmail.value == "") {
									alert("%%LNG_EnterPreviewEmail%%");
									document.frmAutoresponderForm.PreviewEmail.focus();
									return false;
								}

								tb_show('%%LNG_SendPreview%%', 'index.php?Page=Autoresponders&Action=SendPreviewDisplay&keepThis=true&TB_iframe=tue&height=250&width=550', '');
								return true;
							}
	};


	$(function() {
		$(document.frmAutoresponderForm).submit(function() { return Page.CheckForm(); });
		$('.SaveButton').click(function() { Page.Save(); });
		$('.SaveExitButton').click(function() { $(document.frmAutoresponderCreation).submit(); });
		$('.CancelButton').click(function() { if(confirm("%%GLOBAL_CancelButton%%")) document.location="index.php?Page=Autoresponders&Action=Step2&list=%%GLOBAL_List%%"; });
		$(document.frmAutoresponderForm.cmdCheckSpam).click(function() { Page.CheckSpam(); });
		$(document.frmAutoresponderForm.cmdViewCompatibility).click(function() { Page.ViewCompatibility(); });
		$(document.frmAutoresponderForm.cmdSendPreview).click(function() { Page.SendPreview(); });
	});

	// Create an instance of the multiSelector class, pass it the output target and the max number of files
	$(function() {
		var multi_selector = new MultiSelector( document.getElementById( 'files_list' ), 5 );
		multi_selector.addElement( document.getElementById( 'fileUpload' ) );
	});

	function Upload() {
		if (document.frmAutoresponderForm.autoresponderfile.value == "") {
			alert('%%LNG_AutoresponderFileEmptyAlert%%');
			document.frmAutoresponderForm.autoresponderfile.focus();
			return false;
		}
		Page.Save();
	}

	function Import() {
		if (document.frmAutoresponderForm.autoresponderurl.value == "" || document.frmAutoresponderForm.autoresponderurl.value == 'http://') {
			alert('%%LNG_AutoresponderURLEmptyAlert%%');
			document.frmAutoresponderForm.autoresponderurl.focus();
			return false;
		}
		Page.Save();
	}

	function closePopup() {
		tb_remove();
	}

	function getMessage() {
		var message = {};
		if(document.frmAutoresponderForm.myDevEditControl_html) message['myDevEditControl_html'] = document.frmAutoresponderForm.myDevEditControl_html.value;
		if(document.frmAutoresponderForm.TextContent) message['TextContent'] = document.frmAutoresponderForm.TextContent.value;
		return message;
	}

	function getSendPreviewParam() {
		var f = document.frmAutoresponderForm;
		var html = f.myDevEditControl_html ? f.myDevEditControl_html.value : '';
		// if the WYSIWYG editor is not disabled and not in 'WebKit unsupported mode', get the very latest HTML
		if (typeof(myDevEditControl) != 'undefined' && typeof(myDevEditControl.getHTMLContent) != 'undefined') {
			html = myDevEditControl.getHTMLContent();
		}
		return {	'subject': f.subject.value,
					'myDevEditControl_html': html,
					'TextContent': f.TextContent ? f.TextContent.value : '',
					'PreviewEmail': f.PreviewEmail.value,
					'FromPreviewEmail': f.FromPreviewEmail.value,
					'id': %%GLOBAL_PreviewID%%
				};
	}

	var de_ready = false;
	$(document).ready(function() {
		waitForDE();
	});
</script>
<form name="frmAutoresponderForm" method="post" action="index.php?Page=Autoresponders&Action=%%GLOBAL_Action%%" enctype="multipart/form-data">
	<input type="hidden" name="MAX_FILE_SIZE" value="%%GLOBAL_MaxFileSize%%">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">
				<div class="Heading1Image"><img src="images/headerimages/autoresponders_triggers_email.jpg" alt="%%GLOBAL_Heading%%" /></div><div class="Heading1Text">%%GLOBAL_Heading%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
			</td>
		</tr>
		<tr>
			<td class="body pageinfo">
				<p>
				%%GLOBAL_Intro%%
				</p>
				%%GLOBAL_Message%%
			</td>
		</tr>
		<tr>
			<td>
				%%GLOBAL_CronWarning%%
			</td>
		</tr>
		<tr>
			<td>
				<input class="FormButton FormButton_wide" type="button" value="%%LNG_SaveAndKeepEditing%%" style="width:130px" />
				<input class="FormButton_wide SaveExitButton" type="submit" value="%%LNG_SaveAndExit%%"/>
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%"/>
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_Autoresponder_Details%%
						</td>
					</tr>
					<tr>
						<td width="10%" class="FieldLabel">
							<img src="images/blank.gif" width="205" height="1" /><br />
							{template="Required"}
							%%LNG_AutoresponderSubject%%:
						</td>
						<td width="90%">
							<input type="text" name="subject" value="%%GLOBAL_Subject%%" class="Field250" style="width:300px">&nbsp;%%LNG_HLP_AutoresponderSubject%%
							<br/>%%LNG_Subject_Guide_Link%%
						</td>
					</tr>

					%%GLOBAL_Editor%%

					<tr style="display: %%GLOBAL_DisplayAttachmentsHeading%%">
						<td colspan="2" class="EmptyRow">&nbsp;
							
						</td>
					</tr>
					<tr style="display: %%GLOBAL_DisplayAttachmentsHeading%%">
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_Attachments%%
						</td>
					</tr>
					<tr style="display: %%GLOBAL_DisplayAttachments%%">
						<td valign="top" class="FieldLabel">
							{template="Not_Required"}
							%%LNG_Attachments%%:&nbsp;
						</td>
						<td>
							<table border="0" cellspacing="0" cellpadding="0" id="AttachmentsTable">
								<tr>
									<td>
										<input type="file" name="attachments[]" value="" class="FormButton" id="fileUpload" style="width: 200px">&nbsp;%%LNG_HLP_Attachments%%
										<div id="files_list" style="margin-top: 5px"></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="left" style="display: %%GLOBAL_DisplayAttachmentsHeading%%">
							%%GLOBAL_AttachmentsList%%
						</td>
					</tr>
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_EmailValidation%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_SpamKeywordsCheck%%:
						</td>
						<td>
							<input type="button" name="cmdCheckSpam" class="Field300" value="%%LNG_SpamKeywordsCheck_Button%%"/>
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_EmailClientCompatibility%%:
						</td>
						<td>
							<input type="button" name="cmdViewCompatibility" class="Field300" value="%%LNG_EmailClientCompatibility_Button%%"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="EmptyRow">&nbsp;
							
						</td>
					</tr>
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_SendPreview%%
						</td>
					</tr>
					<tr>
						<td valign="top" class="FieldLabel">
							{template="Not_Required"}
							%%LNG_From%%:
						</td>
						<td>
							<input type="text" name="FromPreviewEmail" value="%%GLOBAL_FromPreviewEmail%%" class="Field" style="width:150px">
						</td>
					</tr>
					<tr>
						<td valign="top" class="FieldLabel">
							{template="Not_Required"}
							%%LNG_To%%:
						</td>
						<td>
							<input type="text" name="PreviewEmail" value="" class="Field" style="width:150px">&nbsp;<input type="button" name="cmdSendPreview" value="%%LNG_SendPreview%%" class="Field"/>&nbsp;%%LNG_HLP_SendPreview%%
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;
							
						</td>
					</tr>
				</table>
				<table width="100%" cellspacing="0" cellpadding="2" border="0" class="PanelPlain">
					<tr>
						<td width="200" class="FieldLabel"></td>
						<td>
							<input class="FormButton FormButton_wide" type="button" value="%%LNG_SaveAndKeepEditing%%" style="width:130px" />
							<input class="FormButton_wide SaveExitButton" type="submit" value="%%LNG_SaveAndExit%%" />
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
