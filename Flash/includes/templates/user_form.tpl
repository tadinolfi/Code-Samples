<script src="includes/js/jquery/form.js"></script>
<script src="includes/js/jquery/thickbox.js"></script>
<link rel="stylesheet" type="text/css" href="includes/styles/thickbox.css" />
<script>
	$(function() {
		$(document.users).submit(function() {
			if ($('#username').val().length < 3) {
				ShowTab(1);
				alert("%%LNG_EnterUsername%%");
				$('#username').focus();
				return false;
			}

			if ($('#ss_p').val() != "") {
				if ($('#ss_p').val().length < 3) {
					ShowTab(1);
					alert("%%LNG_EnterPassword%%");
					$('#ss_p').focus().select();
					return false;
				}

				if ($('#ss_p').val() != $('#ss_p_confirm').val()) {
					ShowTab(1);
					alert("%%LNG_PasswordsDontMatch%%");
					$('#ss_p_confirm').focus().select();
					return false;
				}
			}

			if ($('#emailaddress').val().indexOf('@') == -1 || $('#emailaddress').val().indexOf('.') == -1) {
				ShowTab(1);
				alert("%%LNG_EnterEmailaddress%%");
				$('#emailaddress').focus().select();
				return false;
			}

			var gu = $('#googlecalendarusername');
			var gp = $('#googlecalendarpassword');
			if ((gu.val() != '' && gp.val() == '') || (gu.val() == '' && gp.val() != '')) {
				if (gu.val() == '') {
					alert('%%LNG_EnterGoogleCalendarUsername%%');
					ShowTab(5);
					gu.focus();
					return false;
				} else if (gp.val() == '') {
					alert('%%LNG_EnterGoogleCalendarPassword%%');
					ShowTab(5);
					gp.focus();
					return false;
				}
			}

			return true;
		});

		$('.CancelButton', document.users).click(function() { if(confirm('%%LNG_ConfirmCancel%%')) document.location.href='index.php?Page=Users'; });

		$(document.users.usewysiwyg).click(function() { $('#sectionUseXHTML')[this.checked? 'show' : 'hide'](); });
		$(document.users.limitmaxlists).click(function() { $('#DisplayMaxLists').toggle(); });
		$(document.users.limitperhour).click(function() { $('#DisplayEmailsPerHour').toggle(); });
		$(document.users.limitpermonth).click(function() { $('#DisplayEmailsPerMonth').toggle(); });
		$(document.users.unlimitedmaxemails).click(function() { $('#DisplayEmailsMaxEmails').toggle(); });
		$(document.users.returnpathenabled).click(function() { $('#DisplayReturnPathEmail').toggle(); });
		$(document.users.renderingtype).change(
							function() {
								switch($(document.users.renderingtype).val())
								{
									case '1':
										$('#DisplayReturnPath').hide();
										$('#DisplayLitmus').show();
										$('#returnpathenabled').removeAttr("checked");
									break;
									case '2':
										$('#DisplayLitmus').hide();
										$('#DisplayReturnPath').show();
									break;
								}
								
							});
		$(document.users.litmusunlimited).click(
							function() { 
									if($('#litmusunlimited').is(':checked'))
									{
										$('#DisplayLitmusUID').show();
										$('#DisplayLitmusCredits').hide();
									} else {
										$('#DisplayLitmusUID').hide();
										$('#DisplayLitmusCredits').show();
									}
								});
		

		$(document).ready(function() {
			populatePermBoxes();
		});

		$(document.users.admintype).change(function() {
			populatePermBoxes();
		});

		$('.PermissionOptionItems').click(function() {
			calcUserType();
		});
		
		$(document.users.mtaheader).change(function() {
			$('.DisplayCustomMTA')[(this.selectedIndex == 2? 'show':'hide')]();
		});

		$(document.users.xmlapi).click(function() {
			$('#sectionXMLToken').toggle();
			if(document.users.xmltoken.value == '') $('#hrefRegenerateXMLToken').click();
		});

		$('.SelectOnFocus').focus(function() { this.select(); });

		$('#hrefRegenerateXMLToken').click(function() {
			$.post('index.php?Page=Users&Action=GenerateToken',
					{	'username':	document.users.username.value,
						'fullname':	document.users.fullname.value,
						'emailaddress': document.users.emailaddress.value},
					function(token) { $("#xmltoken").val(token); });
			return false;
		});

		$(document.users.user_smtp).click(function() {
			document.users.user_smtpcom.disabled = !this.checked;
			document.users.user_smtpcom.checked = this.checked;
			calcUserType();
		});

		$(document.users.listadmintype).change(function() { $('#PrintLists')[this.selectedIndex == 0? 'hide' : 'show'](); });
		$(document.users.segmentadmintype).change(function() { $('#PrintSegments')[this.selectedIndex == 0? 'hide' : 'show'](); });
		$(document.users.templateadmintype).change(function() { $('#PrintTemplates')[this.selectedIndex == 0? 'hide' : 'show'](); });

		$('#subscribers_add, #subscribers_edit, #subscribers_delete').click(function() {
			$('#subscribers_manage').attr('checked', ($('#subscribers_add, #subscribers_edit, #subscribers_delete').filter(':checked').size() != 0));
		});

		$('#subscribers_manage').click(function(event) {
			if($('#subscribers_add, #subscribers_edit, #subscribers_delete').filter(':checked').size() != 0) {
				event.preventDefault();
				event.stopPropagation();
			}
		});

		$('#segment_create, #segment_edit, #segment_delete, #segment_send').click(function() {
			$('#segment_view').attr('checked', ($('#segment_create, #segment_edit, #segment_delete, #segment_send').filter(':checked').size() != 0));
		});

		$('#segment_view').click(function(event) {
			if($('#segment_create, #segment_edit, #segment_delete, #segment_send').filter(':checked').size() != 0) {
				event.preventDefault();
				event.stopPropagation();
			}
		});

		$('#cmdTestGoogleCalendar').click(function() {
			if ($('#googlecalendarusername').val() == '') {
				alert('%%LNG_EnterGoogleCalendarUsername%%');
				$('#googlecalendarusername').focus();
				return false;
			} else if ($('#googlecalendarpassword').val() == '') {
				alert('%%LNG_EnterGoogleCalendarPassword%%');
				$('#googlecalendarpassword').focus();
				return false;
			}

			$('#spanTestGoogleCalendar').show();
			$(this).attr('disabled', true);

			$.ajax({	type:		'GET',
						url:		'index.php',
						data:		{	Page: 		'Users',
										Action:		'TestGoogleCalendar',
										gcusername:	escape($('#googlecalendarusername').val()),
										gcpassword:	escape($('#googlecalendarpassword').val())},
						timeout:	10000,
						success:	function(data) {
										try {
											var d = eval('(' + data + ')');
											alert(d.message);
										} catch(e) { alert('{$lang.GooglecalendarTestError}'); }
									},
						error:		function() { alert('{$lang.GooglecalendarTestError}'); },
						complete:	function() {
										$('#spanTestGoogleCalendar').hide();
										$('#cmdTestGoogleCalendar').attr('disabled', false);
									}});

			return false;
		});

		$(document.users.smtptype).click(function() {
			$('.SMTPOptions')[document.users.smtptype[1].checked? 'show' : 'hide']();
			$('.sectionSignuptoSMTP')[document.users.smtptype[2].checked? 'show' : 'hide']();
		});

		$(document.users.cmdTestSMTP).click(function() {
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

			tb_show('%%LNG_SendPreview%%', 'index.php?Page=Users&Action=SendPreviewDisplay&keepThis=true&TB_iframe=true&height=250&width=420', '');
			return true;
		});

		document.users.user_smtpcom.disabled = !document.users.user_smtp.checked;
		document.users.smtptype[0].checked = !(document.users.smtptype[1].checked = (document.users.smtp_server.value != ''));

		if($('#subscribers_add, #subscribers_edit, #subscribers_delete').filter(':checked').size() != 0) {
			$('#subscribers_manage').attr('checked', true);
		}

		if($('#segment_create, #segment_edit, #segment_delete, #segment_send').filter(':checked').size() != 0) {
			$('#segment_view').attr('checked', true);
		}

		$('.SMTPOptions')[document.users.smtptype[1].checked? 'show' : 'hide']();
		$('.sectionSignuptoSMTP')[document.users.smtptype[2].checked? 'show' : 'hide']();
	});

	function getSMTPPreviewParameters() {
		var values = {};
		$($('.smtpSettings', document.users).fieldSerialize().split('&')).each(function(i,n) {
			var temp = n.split('=');
			if (temp.length == 2) values[temp[0]] = temp[1];
		});
		return values;
	}

	function closePopup() {
		tb_remove();
	}

	/**
	 * Fills in the checkboxes based on the selected user type when not
	 * 'Custom'.
	 */
	function populatePermBoxes()
	{
		$('.PermissionOptionItems').each(function() {
			switch (document.users.admintype.value) {
				case 0: this.checked = false; break;
				case 'a': this.checked = true; $('.CustomPermissionOptions').hide(); break;
				case 'b': this.checked = true; $('.CustomPermissionOptions').hide(); break;
				case 'c':
					$('.CustomPermissionOptions').hide(); 
					if(this.name.match(/system/) || this.name.match(/smtp/) || this.name.match(/bounce/)) 
					{						
							this.checked = false;
					} else {
							this.checked = true;
					}
				break;
				case 'd':
					$('.CustomPermissionOptions').show();
				break;
				case 'o':
					$('.CustomPermissionOptions').hide();
					this.checked = !!this.name.match(/statistics/); break;
			}
		});
	}

	/**
	 * Checks that all $(name)s matching 'pattern' are checked, or if
	 * reversed, checks that all $(name)s not matching 'pattern' are
	 * not checked.
	 */
	function allItemsChecked(opts, pattern, reverse)
	{
		var all_checked = true;
		$(opts).each(function() {
			if ((!reverse && this.name.match(pattern) && !this.checked) || (reverse && !this.name.match(pattern) && this.checked)) {
				all_checked = false;
				return false;
			}
		});
		return all_checked;
	}

	/**
	 * Loads/caches the checked state of boxes into bucket.
	 */
	function loadCheckboxes(opts)
	{
		var bucket = [];
		opts.each(function() {
			bucket.push({"name": this.name, "checked": this.checked});
		});
		return bucket;
	}

	/**
	 * Calculates what type the user is based on which boxes are checked.
	 */
	function calcUserType()
	{
		document.users.admintype.selectedIndex = 5; // Custom
		var patterns = [/./, /list/, /newsletter/, /template/, /user/];
		var bucket = loadCheckboxes($('input.PermissionOptionItems', $('div#div3')));
		for (i=patterns.length-1; i>=0; i--) {
			if (allItemsChecked(bucket, patterns[i], false) && allItemsChecked(bucket, patterns[i], true)) {
				document.users.admintype.selectedIndex = i;
			}
		}
	}

	// This is called by the ShowTab function in javascript.js
	function onShowTab(tab) {
		// Google tab
		if (tab == 5) {
			$('#cmdTestGoogleCalendar').show();
		} else {
			$('#cmdTestGoogleCalendar').hide();
		}
	}

</script>
<style type="text/css">
	.PermissionColumn1 {
		width: 200px;
	}
	.PermissionColumn2 {
		width: 35px;
	}
	.PermissionColumn3 {
		width: 200px;
	}
	.PermissionColumn4 {
		width: 35px;
	}
</style>
<form name="users" method="post" action="index.php?Page=%%PAGE%%&%%GLOBAL_FormAction%%">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/my_account.jpg" alt="%%%GLOBAL_Heading%%" /></div><div class="Heading1Text">%%GLOBAL_Heading%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td>
		</tr>
		<tr>
			<td class="body pageinfo"><p>%%GLOBAL_Help_Heading%%</p></td>
		</tr>
		<tr>
			<td>
				%%GLOBAL_Message%%
			</td>
		</tr>
		<tr>
			<td class=body>
				<input class="FormButton" type="submit" value="%%LNG_Save%%"/>
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%"/>
			</td>
		</tr>
		<tr>
			<td>
				<div>
					<br />
					<ul id="tabnav">
						<li><a href="#" class="active" id="tab1" onclick="ShowTab(1); return false;"><span>%%LNG_UserSettings_Heading%%</span></a></li>
						<li><a href="#" id="tab2" onclick="ShowTab(2); return false;"><span>%%LNG_UserRestrictions_Heading%%</span></a></li>
						<li><a href="#" id="tab3" onclick="ShowTab(3); return false;"><span>%%LNG_UserPermissions_Heading%%</span></a></li>
						<li><a href="#" id="tab4" onclick="ShowTab(4); return false;"><span>%%LNG_EmailSettings_Heading%%</span></a></li>
						<li style="display:none"><a href="#" id="tab5" onclick="ShowTab(5); return false;"><span>%%LNG_GoogleSettings_Heading%%</span></a></li>
					</ul>

					<div id="div1" style="padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td class=Heading2 colspan=2 style="padding-left:10px">
									%%LNG_UserDetails%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_UserName%%:
								</td>
								<td>
									<input type="text" name="username" id="username" value="%%GLOBAL_UserName%%" id="username" class="Field250">
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_Password%%:
								</td>
								<td>
									<input type="password" name="ss_p" id="ss_p" value="" class="Field250" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_PasswordConfirm%%:
								</td>
								<td>
									<input type="password" name="ss_p_confirm" id="ss_p_confirm" value="" class="Field250" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_FullName%%:
								</td>
								<td>
									<input type="text" name="fullname" value="%%GLOBAL_FullName%%" id="fullname" class="Field250">
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_EmailAddress%%:
								</td>
								<td>
									<input type="text" name="emailaddress" id="emailaddress" value="%%GLOBAL_EmailAddress%%" class="Field250">&nbsp;%%LNG_HLP_EmailAddress%%
								</td>
							</tr>
							<tr>
                                <td class="FieldLabel">
                                    {template="Required"}
                                    %%LNG_CompanyName%%:
                                </td>
                                <td>
                                    <input type="text" name="companyname" value="%%GLOBAL_CompanyName%%" class="field250">&nbsp;%%LNG_HLP_CompanyName%%
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="FieldLabel">
                                    {template="Required"}
                                    %%LNG_CompanyAddress1%%:
                                </td>
                                <td>
                                    <input type="text" name="companyaddress1" value="%%GLOBAL_CompanyAddress1%%" class="field250">&nbsp;%%LNG_HLP_CompanyAddress1%%
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="FieldLabel">
                                    {template="Not_Required"}
                                    %%LNG_CompanyAddress2%%:
                                </td>
                                <td>
                                    <input type="text" name="companyaddress2" value="%%GLOBAL_CompanyAddress2%%" class="field250">
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="FieldLabel">
                                    {template="Required"}
                                    %%LNG_CompanyCity%%:
                                </td>
                                <td>
                                    <input type="text" name="companycity" value="%%GLOBAL_CompanyCity%%" class="field250">&nbsp;%%LNG_HLP_CompanyCity%%
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="FieldLabel">
                                    {template="Required"}
                                    %%LNG_CompanyState%%:
                                </td>
                                <td>
                                    <select name="companystate">
                                    	<option value="0">Please select a State</option>
                                        %%GLOBAL_StateList%%
                                    </select>
                                    &nbsp;%%LNG_HLP_CompanyState%%
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="FieldLabel">
                                    {template="Required"}
                                    %%LNG_CompanyPostCode%%:
                                </td>
                                <td>
                                    <input type="text" name="companypostcode" value="%%GLOBAL_CompanyPostCode%%" class="field250">&nbsp;%%LNG_HLP_CompanyPostCode%%
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
							<tr style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_HTMLFooter%%:
								</td>
								<td>
									<textarea name="htmlfooter" rows="10" cols="50" wrap="virtual">%%GLOBAL_HTMLFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_HTMLFooter%%
								</td>
							</tr>
							<tr style="display:none">
								<td class="FieldLabel">&nbsp;</td>
								<td>{$lang.ViewKB_ExplainDefaultFooter}</td>
							</tr>
							<tr style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_TextFooter%%:
								</td>
								<td>
									<textarea name="textfooter" rows="10" cols="50" wrap="virtual">%%GLOBAL_TextFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_TextFooter%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.EventTypeList}:
								</td>
								<td>
									<textarea name="eventactivitytype" rows="10" cols="50" wrap="virtual">%%GLOBAL_EventActivityType%%</textarea>&nbsp;&nbsp;&nbsp;{$lnghlp.EventTypeList}
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_Active%%:
								</td>
								<td>
									<label for="status"><input type="checkbox" name="status" id="status" value="1"%%GLOBAL_StatusChecked%%> %%LNG_YesIsActive%%</label> %%LNG_HLP_Active%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_EditOwnSettings%%:
								</td>
								<td>
									<label for="editownsettings"><input type="checkbox" name="editownsettings" id="editownsettings" value="1"%%GLOBAL_EditOwnSettingsChecked%%> %%LNG_YesEditOwnSettings%%</label> %%LNG_HLP_EditOwnSettings%%
								</td>
							</tr>
							<tr style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_ShowInfoTips%%:
								</td>
								<td>
									<label for="infotips"><input type="checkbox" name="infotips" id="infotips" value="1"%%GLOBAL_InfoTipsChecked%%> %%LNG_YesShowInfoTips%%</label> %%LNG_HLP_ShowInfoTips%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_UseWysiwygEditor%%:
								</td>
								<td>
									<div><label for="usewysiwyg"><input type="checkbox" name="usewysiwyg" id="usewysiwyg" value="1" %%GLOBAL_UseWysiwyg%%> %%LNG_YesUseWysiwygEditor%%</label> %%LNG_HLP_UseWysiwygEditor%%</div>
									<div id="sectionUseXHTML"%%GLOBAL_UseXHTMLDisplay%%><img src="images/nodejoin.gif" width="20" height="20"><label for="usexhtml"><input type="checkbox" name="usexhtml" id="usexhtml" value="1"%%GLOBAL_UseXHTMLCheckbox%%> %%LNG_YesUseXHTML%%</label> %%LNG_HLP_UseWysiwygXHTML%%</div>
								</td>
							</tr>
							 <tr>
                            	<td class="FieldLabel">
                                	{template="Not_Required"}
                                    %%LNG_HeaderOptions%%
                                </td>
                                <td>
                                	<input type="checkbox" name="enableheader" id="enableheader" value="1" %%GLOBAL_EnableHeaderChecked%% /><label for="enableheader">%%LNG_EnableHeader%%</label>%%LNG_HLP_EnableHeader%%
                                </td>
                            </tr>
                            <tr>
                            	<td class="FieldLabel">
                                	{template="Not_Required"}
                                    %%LNG_FooterOptions%%
                                </td>
                                <td>
                                	<input type="checkbox" name="enablefooter" id="enablefooter" value="1" %%GLOBAL_EnableFooterChecked%% /><label for="enablefooter">%%LNG_EnableFooter%%</label>%%LNG_HLP_EnableFooter%%
                                </td>
                            </tr>
                              <tr>
                            	<td class="FieldLabel">
                                </td>
                                <td>
                                	<input type="checkbox" name="enablefooterlogo" id="enablefooterlogo" value="1" %%GLOBAL_EnableFooterLogoChecked%% /><label for="enablefooterlogo">%%LNG_EnableFooterLogo%%</label>%%LNG_HLP_EnableFooterLogo%%
                                </td>
                            </tr>
							<tr style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.EnableActivityLog}:
								</td>
								<td>
									<label for="enableactivitylog"><input type="checkbox" name="enableactivitylog" id="enableactivitylog" value="1" %%GLOBAL_EnableActivityLog%%> {$lang.YesEnableActivityLog}</label> {$lnghlp.EnableActivityLog}
								</td>
							</tr>
						</table>
					</div>

					<div id="div2" style="display:none; padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">

							<tr>
								<td colspan="2" class="Heading2" style="padding-left:10px">
									%%LNG_UserRestrictions%%
								</td>
							</tr>

							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_LimitLists%%:
								</td>
								<td>
									<div>
										<label for="limitmaxlists">
											<input type="checkbox" name="limitmaxlists" id="limitmaxlists" value="1"%%GLOBAL_LimitListsChecked%%/>
											%%LNG_LimitListsExplain%%
										</label>
										%%LNG_HLP_LimitLists%%
									</div>
									<div id="DisplayMaxLists" style="display: %%GLOBAL_DisplayMaxLists%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_MaximumLists%%:
										<input type="text" name="maxlists" value="%%GLOBAL_MaxLists%%" class="Field50"/>
										%%LNG_HLP_MaximumLists%%
									</div>
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_LimitEmailsPerHour%%:
								</td>
								<td>
									<div>
										<label for="limitperhour">
											<input type="checkbox" name="limitperhour" id="limitperhour" value="1"%%GLOBAL_LimitPerHourChecked%%/>
											%%LNG_LimitEmailsPerHourExplain%%
										</label>
										%%LNG_HLP_LimitEmailsPerHour%%
									</div>
									<div id="DisplayEmailsPerHour" style="display: %%GLOBAL_DisplayEmailsPerHour%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_EmailsPerHour%%:
										<input type="text" name="perhour" value="%%GLOBAL_PerHour%%" class="Field50">
										%%LNG_HLP_EmailsPerHour%%
									</div>
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_LimitEmailsPerMonth%%:
								</td>
								<td>
									<div>
										<label for="limitpermonth">
											<input type="checkbox" name="limitpermonth" id="limitpermonth" value="1"%%GLOBAL_LimitPerMonthChecked%%/>
											%%LNG_LimitEmailsPerMonthExplain%%
										</label>
										%%LNG_HLP_LimitEmailsPerMonth%%
									</div>
									<div id="DisplayEmailsPerMonth" style="display: %%GLOBAL_DisplayEmailsPerMonth%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_EmailsPerMonth%%:
										<input type="text" name="permonth" value="%%GLOBAL_PerMonth%%" class="Field50">
										%%LNG_HLP_EmailsPerMonth%%
									</div>
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_LimitMaximumEmails%%:
								</td>
								<td>
									<div>
										<label for="unlimitedmaxemails">
											<input type="checkbox" name="unlimitedmaxemails" id="unlimitedmaxemails" value="1" %%GLOBAL_LimitMaximumEmailsChecked%%/>
											{$lang.LimitMaximumEmailsExplain}
										</label>
										{$lnghlp.LimitMaximumEmails}
									</div>
									<div id="DisplayEmailsMaxEmails" style="display: %%GLOBAL_DisplayEmailsMaxEmails%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;{$lang.MaximumEmails}:
										<input type="text" name="maxemails" value="%%GLOBAL_MaxEmails%%" class="Field50">
										{$lnghlp.MaximumEmails}
									</div>
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_RenderingType%%
								</td>
								<td>
									<label for="renderingtype">
										<select name="rendingtype" id="renderingtype">
										%%GLOBAL_RenderingTypes%%
										</select>
							<tr style="display: %%GLOBAL_DisplayReturnPath%%" id="DisplayReturnPath">
                            	<td class="FieldLabel">
                                	{template="Not_Required"}
                                    %%LNG_ReturnPathEnabled%%
                                </td>
                                <td>
                                	<div>
										<label for="returnpathenabled">
											<input type="checkbox" name="returnpathenabled" id="returnpathenabled" value="1" %%GLOBAL_ReturnPathEnabledChecked%%/>
                                            %%LNG_ReturnPathEnabledExplain%%
										</label>
										%%LNG_HLP_ReturnPathEnabled%%
									</div>
									<div id="DisplayReturnPathEmail" style="display: %%GLOBAL_DisplayReturnPathEmail%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_ReturnPathEmail%%:
										<input type="text" name="returnpathemail" value="%%GLOBAL_ReturnPathEmail%%" class="field250">
										%%LNG_HLP_ReturnPathEmail%%
									</div>
                                </td>
                            </tr>
                            
                            <tr style="display: %%GLOBAL_DisplayLitmus%%" id="DisplayLitmus">
                            	<td class="FieldLabel">
                            		{template="Not_Required"}
                                    %%LNG_Litmus%%
                                </td>
                                <td>
                                	<div>
                                	<label for="litmusunlimited">
											<input type="checkbox" name="litmusunlimited" id="litmusunlimited" value="1" %%GLOBAL_LitmusChecked%%/>
                                            %%LNG_LitmusExplain%%
										</label>
										
									</div>
									<div id="DisplayLitmusUID" style="display: %%GLOBAL_DisplayLitmusUID%%">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_LitmusUID%%:
										<input type="text" name="litmusuid" value="%%GLOBAL_LitmusUID%%" class="field250">
										%%LNG_HLP_LitmusUID%%
									</div>
									<div id="DisplayLitmusCredits" style="display: %%GLOBAL_DisplayLitmusCredits%%">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_LitmusCredits%%:
										<input type="text" name="litmuscredits" value="%%GLOBAL_LitmusCredits%%" class="field250">
										%%LNG_HLP_LitmusCredits%%
									</div>
								</td>
							</tr>
							
                            <tr style="display: %%GLOBAL_DisplayMTA%%">
                            	<td class="FieldLabel">
                                	{template="Not_Required"}
                                    %%LNG_MTAHeader%%
                                </td>
                                <td>
                                	<select name="mtaheader" id="mtaheader">
                                    	%%GLOBAL_MTAOptions%%
                                    </select>%%LNG_HLP_MTAHeader%%
                                    <div class="DisplayCustomMTA" style="display: %%GLOBAL_ShowCustomMTA%%">
                                    	<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_CustomMTA%%:
										<input type="text" name="custommta" value="%%GLOBAL_CustomMTA%%" class="field250">
                                        %%LNG_HLP_CustomMTA%%
                                    </div>
                                </td>
                            </tr>
						</table>
					</div>

					<div id="div3" style="display:none; padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td class=Heading2 colspan=2 style="padding-left:10px">
									{$lang.AccessPermissions}
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									{$lang.AdministratorType}:
								</td>
								<td>
									<select name="admintype" class="Field250">
										%%GLOBAL_PrintAdminTypes%%
									</select>
									{$lnghlp.AdministratorType}
								</td>
							</tr>
							<tr class="CustomPermissionOptions AutoresponderPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.AutoresponderPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="autoresponders_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][create]" id="autoresponders_create"%%GLOBAL_Permissions_Autoresponders_Create%%>&nbsp;%%LNG_CreateAutoresponders%%</label>
												{$lnghlp.CreateAutoresponderHelp}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="autoresponders_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][approve]" id="autoresponders_approve"%%GLOBAL_Permissions_Autoresponders_Approve%%>&nbsp;{$lang.ApproveAutoresponders}</label>
												{$lnghlp.ApproveAutoresponderHelp}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="autoresponders_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][edit]" id="autoresponders_edit"%%GLOBAL_Permissions_Autoresponders_Edit%%>&nbsp;{$lang.EditAutoresponders}</label>
												{$lnghlp.EditAutoresponderHelp}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="autoresponders_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][delete]" id="autoresponders_delete"%%GLOBAL_Permissions_Autoresponders_Delete%%>&nbsp;{$lang.DeleteAutoresponders}</label>
												{$lnghlp.DeleteAutoresponderHelp}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions FormPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.FormPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="forms_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][create]" id="forms_create"%%GLOBAL_Permissions_Forms_Create%%>&nbsp;{$lang.CreateForms}</label>
												{$lnghlp.CreateForms}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="forms_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][edit]" id="forms_edit"%%GLOBAL_Permissions_Forms_Edit%%>&nbsp;{$lang.EditForms}</label>
												{$lnghlp.EditForms}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="forms_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][delete]" id="forms_delete"%%GLOBAL_Permissions_Forms_Delete%%>&nbsp;{$lang.DeleteForms}</label>
												{$lnghlp.DeleteForms}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions ListPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.ListPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="lists_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][create]" id="lists_create"%%GLOBAL_Permissions_Lists_Create%%>&nbsp;{$lang.CreateMailingLists}</label>
												{$lnghlp.CreateMailingLists}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="lists_bounce"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][bounce]" id="lists_bounce"%%GLOBAL_Permissions_Lists_Bounce%%>&nbsp;{$lang.MailingListsBounce}</label>
												{$lnghlp.MailingListsBounce}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="lists_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][edit]" id="lists_edit"%%GLOBAL_Permissions_Lists_Edit%%>&nbsp;{$lang.EditMailingLists}</label>
												{$lnghlp.EditMailingLists}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="lists_bouncesettings"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][bouncesettings]" id="lists_bouncesettings"%%GLOBAL_Permissions_Lists_Bouncesettings%%>&nbsp;{$lang.MailingListsBounceSettings}</label>
												{$lnghlp.MailingListsBounceSettings}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="lists_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][delete]" id="lists_delete"%%GLOBAL_Permissions_Lists_Delete%%>&nbsp;{$lang.DeleteMailingLists}</label>
												{$lnghlp.DeleteMailingLists}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions SegmentPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.SegmentPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="segment_view"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[segments][view]" id="segment_view"%%GLOBAL_Permissions_Segments_View%%>&nbsp;{$lang.SegmentViewPermission}</label>
												{$lnghlp.SegmentViewPermission}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="segment_send"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[segments][send]" id="segment_send"%%GLOBAL_Permissions_Segments_Send%%>&nbsp;{$lang.SegmentSendPermission}</label>
												{$lnghlp.SegmentSendPermission}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="segment_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[segments][create]" id="segment_create"%%GLOBAL_Permissions_Segments_Create%%>&nbsp;{$lang.SegmentCreatePermission}</label>
												{$lnghlp.SegmentCreatePermission}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="segment_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[segments][edit]" id="segment_edit"%%GLOBAL_Permissions_Segments_Edit%%>&nbsp;{$lang.SegmentEditPermission}</label>
												{$lnghlp.SegmentEditPermission}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="segment_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[segments][delete]" id="segment_delete"%%GLOBAL_Permissions_Segments_Delete%%>&nbsp;{$lang.SegmentDeletePermission}</label>
												{$lnghlp.SegmentDeletePermission}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions CustomFieldPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.CustomFieldPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="customfields_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][create]" id="customfields_create"%%GLOBAL_Permissions_Customfields_Create%%>&nbsp;{$lang.CreateCustomFields}</label>
												{$lnghlp.CreateCustomFields}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="customfields_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][edit]" id="customfields_edit"%%GLOBAL_Permissions_Customfields_Edit%%>&nbsp;{$lang.EditCustomFields}</label>
												{$lnghlp.EditCustomFields}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="customfields_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][delete]" id="customfields_delete"%%GLOBAL_Permissions_Customfields_Delete%%>&nbsp;{$lang.DeleteCustomFields}</label>
												{$lnghlp.DeleteCustomFields}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions NewsletterPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.NewsletterPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="newsletters_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][create]" id="newsletters_create"%%GLOBAL_Permissions_Newsletters_Create%%>&nbsp;{$lang.CreateNewsletters}</label>
												{$lnghlp.CreateNewsletters}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="newsletters_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][approve]" id="newsletters_approve"%%GLOBAL_Permissions_Newsletters_Approve%%>&nbsp;{$lang.ApproveNewsletters}</label>
												{$lnghlp.ApproveNewsletters}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="newsletters_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][edit]" id="newsletters_edit"%%GLOBAL_Permissions_Newsletters_Edit%%>&nbsp;{$lang.EditNewsletters}</label>
												{$lnghlp.EditNewsletters}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="newsletters_send"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][send]" id="newsletters_send"%%GLOBAL_Permissions_Newsletters_Send%%>&nbsp;{$lang.SendNewsletters}</label>
												{$lnghlp.SendNewsletters}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="newsletters_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][delete]" id="newsletters_delete"%%GLOBAL_Permissions_Newsletters_Delete%%>&nbsp;{$lang.DeleteNewsletters}</label>
												{$lnghlp.DeleteNewsletters}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions TriggeremailsPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.Permissions_Triggeremails}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="triggeremails_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[triggeremails][create]" id="triggeremails_create"%%GLOBAL_Permissions_Triggeremails_Create%%>&nbsp;{$lang.Permissions_Triggeremails_Create}</label>
												{$lnghlp.Permissions_Triggeremails_Create}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="triggeremails_activate"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[triggeremails][activate]" id="triggeremails_activate"%%GLOBAL_Permissions_Triggeremails_Activate%%>&nbsp;{$lang.Permissions_Triggeremails_Activate}</label>
												{$lnghlp.Permissions_Triggeremails_Activate}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="triggeremails_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[triggeremails][edit]" id="triggeremails_edit"%%GLOBAL_Permissions_Triggeremails_Edit%%>&nbsp;{$lang.Permissions_Triggeremails_Edit}</label>
												{$lnghlp.Permissions_Triggeremails_Edit}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="triggeremails_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[triggeremails][delete]" id="triggeremails_delete"%%GLOBAL_Permissions_Triggeremails_Delete%%>&nbsp;{$lang.Permissions_Triggeremails_Delete}</label>
												{$lnghlp.Permissions_Triggeremails_Delete}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">&nbsp;
												
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions SubscriberPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.SubscriberPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="subscribers_manage"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][manage]" id="subscribers_manage"%%GLOBAL_Permissions_Subscribers_Manage%%>&nbsp;{$lang.ManageSubscribers}</label>
												{$lnghlp.ManageSubscribers}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="subscribers_import"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][import]" id="subscribers_import"%%GLOBAL_Permissions_Subscribers_Import%%>&nbsp;{$lang.ImportSubscribers}</label>
												{$lnghlp.ImportSubscribers}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="subscribers_add"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][add]" id="subscribers_add"%%GLOBAL_Permissions_Subscribers_Add%%>&nbsp;{$lang.AddSubscribers}</label>
												{$lnghlp.AddSubscribers}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="subscribers_export"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][export]" id="subscribers_export"%%GLOBAL_Permissions_Subscribers_Export%%>&nbsp;{$lang.ExportSubscribers}</label>
												{$lnghlp.ExportSubscribers}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="subscribers_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][edit]" id="subscribers_edit"%%GLOBAL_Permissions_Subscribers_Edit%%>&nbsp;{$lang.EditSubscribers}</label>
												{$lnghlp.EditSubscribers}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="subscribers_banned"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][banned]" id="subscribers_banned"%%GLOBAL_Permissions_Subscribers_Banned%%>&nbsp;{$lang.ManageBannedSubscribers}</label>
												{$lnghlp.ManageBannedSubscribers}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="subscribers_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][delete]" id="subscribers_delete"%%GLOBAL_Permissions_Subscribers_Delete%%>&nbsp;{$lang.DeleteSubscribers}</label>
												{$lnghlp.DeleteSubscribers}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="subscribers_event_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][eventdelete]" id="subscribers_event_delete"%%GLOBAL_Permissions_Subscribers_Eventdelete%%>&nbsp;{$lang.EventDelete}</label>
												{$lnghlp.EventDelete}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="subscribers_event_save"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][eventsave]" id="subscribers_event_save"%%GLOBAL_Permissions_Subscribers_Eventsave%%>&nbsp;{$lang.EventAdd}</label>
												{$lnghlp.EventAdd}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="subscribers_event_update"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][eventupdate]" id="subscribers_event_update"%%GLOBAL_Permissions_Subscribers_Eventupdate%%>&nbsp;{$lang.EventEdit}</label>
												{$lnghlp.EventEdit}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions TemplatePermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.TemplatePermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="templates_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][create]" id="templates_create"%%GLOBAL_Permissions_Templates_Create%%>&nbsp;{$lang.CreateTemplates}</label>
												{$lnghlp.CreateTemplates}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="templates_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][approve]" id="templates_approve"%%GLOBAL_Permissions_Templates_Approve%%>&nbsp;{$lang.ApproveTemplates}</label>
												{$lnghlp.ApproveTemplates}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="templates_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][edit]" id="templates_edit"%%GLOBAL_Permissions_Templates_Edit%%>&nbsp;{$lang.EditTemplates}</label>
												{$lnghlp.EditTemplates}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3" colspan="2">
												<label for="templates_global"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][global]" id="templates_global"%%GLOBAL_Permissions_Templates_Global%%>&nbsp;{$lang.GlobalTemplates}</label>
												{$lnghlp.GlobalTemplates}
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="templates_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][delete]" id="templates_delete"%%GLOBAL_Permissions_Templates_Delete%%>&nbsp;{$lang.DeleteTemplates}</label>
												{$lnghlp.DeleteTemplates}
											</td>
											<td class="PermissionColumn2">&nbsp;
												
											</td>
											<td class="PermissionColumn3">
												<label for="templates_builtin"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][builtin]" id="templates_builtin"%%GLOBAL_Permissions_Templates_Builtin%%>&nbsp;{$lang.BuiltInTemplates}</label>
												{$lnghlp.BuiltInTemplates}
											</td>
											<td class="PermissionColumn4">&nbsp;
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions StatisticPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.StatisticsPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="statistics_newsletter"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][newsletter]" id="statistics_newsletter"%%GLOBAL_Permissions_Statistics_Newsletter%%>&nbsp;{$lang.NewsletterStatistics}</label>
												{$lnghlp.NewsletterStatistics}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
											<td class="PermissionColumn3">
												<label for="statistics_user"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][user]" id="statistics_user"%%GLOBAL_Permissions_Statistics_User%%>&nbsp;{$lang.UserStatistics}</label>
												{$lnghlp.UserStatistics}
											</td>
											<td class="PermissionColumn4">&nbsp;</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="statistics_autoresponder"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][autoresponder]" id="statistics_autoresponder"%%GLOBAL_Permissions_Statistics_Autoresponder%%>&nbsp;{$lang.AutoresponderStatistics}</label>
												{$lnghlp.AutoresponderStatistics}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
											<td class="PermissionColumn3">
												<label for="statistics_list"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][list]" id="statistics_list"%%GLOBAL_Permissions_Statistics_List%%>&nbsp;{$lang.ListStatistics}</label>
												{$lnghlp.ListStatistics}
											</td>
											<td class="PermissionColumn4">&nbsp;</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="statistics_triggeremails"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][triggeremails]" id="statistics_triggeremails"%%GLOBAL_Permissions_Statistics_Triggeremails%%>&nbsp;{$lang.Permissions_Triggeremails_Statistics}</label>
												{$lnghlp.Permissions_Triggeremails_Statistics}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
											<td class="PermissionColumn3">&nbsp;
											</td>
											<td class="PermissionColumn4">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions AdminPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.AdminPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="system_system"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][system]" id="system_system"%%GLOBAL_Permissions_System_System%%>&nbsp;{$lang.SystemAdministrator}</label>
												{$lnghlp.SystemAdministrator}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
											<td class="PermissionColumn3">
												<label for="system_list"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][list]" id="system_list"%%GLOBAL_Permissions_System_List%%>&nbsp;{$lang.ListAdministrator}</label>
												{$lnghlp.ListAdministrator}
											</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="system_user"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][user]" id="system_user"%%GLOBAL_Permissions_System_User%%>&nbsp;{$lang.UserAdministrator}</label>
												{$lnghlp.UserAdministrator}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
											<td class="PermissionColumn3">
												<label for="system_template"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][template]" id="system_template"%%GLOBAL_Permissions_System_Template%%>&nbsp;{$lang.TemplateAdministrator}</label>
												{$lnghlp.TemplateAdministrator}
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions OtherPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.OtherPermissions}:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="PermissionColumn1">
												<label for="user_smtp"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[user][smtp]" id="user_smtp"%%GLOBAL_Permissions_User_Smtp%%>&nbsp;{$lang.User_SMTP}</label>
												{$lnghlp.User_SMTP}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
										</tr>
										<tr>
											<td class="PermissionColumn1">
												<label for="user_smtpcom"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[user][smtpcom]" id="user_smtpcom"%%GLOBAL_Permissions_User_Smtpcom%%>&nbsp;{$lang.SettingsShowSMTPCOMLabel}</label>
												{$lnghlp.SettingsShowSMTPCOM}
											</td>
											<td class="PermissionColumn2">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Not_Required"}
									{$lang.UseXMLAPI}:
								</td>
								<td>
									<label for="xmlapi"><input type="checkbox" name="xmlapi" id="xmlapi" value="1" %%GLOBAL_Xmlapi%%> {$lang.YesUseXMLAPI}</label> {$lnghlp.UseXMLAPI}<br/>
									<table id="sectionXMLToken"%%GLOBAL_XMLTokenDisplay%% border="0" cellspacing="0" cellpadding="2" class="Panel">
										<tr>
											<td width="100">
												<img src="images/nodejoin.gif" width="20" height="20">&nbsp;{$lang.XMLPath}:
											</td>
											<td>
												<input type="text" name="xmlpath" id="xmlpath" value="%%GLOBAL_XmlPath%%" class="Field250 SelectOnFocus" readonly/> {$lnghlp.XMLPath}
											</td>
										</tr>
										<tr>
											<td>
												<img src="images/blank.gif" width="20" height="20">&nbsp;{$lang.XMLUsername}:
											</td>
											<td>
												<input type="text" name="xmlusername" id="xmlusername" value="%%GLOBAL_UserName%%" class="Field250 SelectOnFocus" readonly/> {$lnghlp.XMLUsername}
											</td>
										</tr>
										<tr>
											<td>
												<img src="images/blank.gif" width="20" height="20">&nbsp;{$lang.XMLToken}:
											</td>
											<td>
												<input type="text" name="xmltoken" id="xmltoken" value="%%GLOBAL_XmlToken%%" class="Field250 SelectOnFocus" readonly/> {$lnghlp.XMLToken}
											</td>
										</tr>
										<tr>
											<td>&nbsp;
												
											</td>
											<td>
												<a href="#" id="hrefRegenerateXMLToken" style="color: gray;">%%LNG_XMLToken_Regenerate%%</a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="EmptyRow" colspan=2>&nbsp;
									
								</td>
							</tr>
							%%GLOBAL_AddonPermissionDisplay%%
							<tr>
								<td class=Heading2 colspan=2>
									%%LNG_MailingListAccessPermissions%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_ChooseMailingLists%%:
								</td>
								<td height="35">
									<select name="listadmintype">
										%%GLOBAL_PrintListAdminList%%
									</select>&nbsp;&nbsp;%%LNG_HLP_ChooseMailingLists%%
								</td>
							</tr>
							<tr id="PrintLists" style="display: %%GLOBAL_ListDisplay%%">
								<td class="FieldLabel">
									{template="Not_Required"}
								</td>
								<td style="padding-bottom:10px">
									%%GLOBAL_PrintMailingLists%%
								</td>
							</tr>

							<tr>
								<td class="EmptyRow" colspan=2>&nbsp;
									
								</td>
							</tr>
							<tr>
								<td class=Heading2 colspan=2>
									%%LNG_SegmentAccessPermissions%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_ChooseAllowedSegments%%:
								</td>
								<td height="35">
									<select name="segmentadmintype">
										%%GLOBAL_PrintSegmentAdminList%%
									</select>&nbsp;&nbsp;%%LNG_HLP_ChooseAllowedSegments%%
								</td>
							</tr>
							<tr id="PrintSegments" style="display: %%GLOBAL_SegmentDisplay%%">
								<td class="FieldLabel">
									{template="Not_Required"}
								</td>
								<td style="padding-bottom:10px">
									%%GLOBAL_PrintSegmentLists%%
								</td>
							</tr>

							<tr>
								<td class="EmptyRow" colspan=2>&nbsp;
									
								</td>
							</tr>
							<tr>
								<td class=Heading2 colspan=2>
									%%LNG_TemplateAccessPermissions%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel" height="35">
									{template="Required"}
									%%LNG_ChooseTemplates%%:
								</td>
								<td>
									<select name="templateadmintype">
										%%GLOBAL_PrintTemplateAdminList%%
									</select>&nbsp;&nbsp;%%LNG_HLP_ChooseTemplates%%
								</td>
							</tr>
							<tr id="PrintTemplates" style="display: %%GLOBAL_TemplateDisplay%%">
								<td class="FieldLabel">
									{template="Not_Required"}
								</td>
								<td style="padding-bottom:10px">
									%%GLOBAL_PrintTemplateLists%%
								</td>
							</tr>
						</table>
					</div>

					<div id="div4" style="display:none; padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td colspan="2" class="Heading2" style="padding-left:10px">
									%%LNG_SmtpServerIntro%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel" width="10%">
									<img src="images/blank.gif" width="200" height="1" /><br />
									{template="Not_Required"}
									%%LNG_SmtpServer%%:
								</td>
								<td width="90%">
									<label for="usedefaultsmtp">
										<input type="radio" name="smtptype" id="usedefaultsmtp" value="0"/>
										%%LNG_SmtpDefault%%
									</label>
									%%LNG_HLP_UseDefaultMail%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">&nbsp;</td>
								<td>
									<label for="usecustomsmtp">
										<input type="radio" name="smtptype" id="usecustomsmtp" value="1"/>
										%%LNG_SmtpCustom%%
									</label>
									%%LNG_HLP_UseSMTP_User%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_SmtpServerName%%:
								</td>
								<td>
									<img width="20" height="20" src="images/nodejoin.gif"/>
									<input type="text" name="smtp_server" value="%%GLOBAL_SmtpServer%%" class="Field250 smtpSettings"> %%LNG_HLP_SmtpServerName%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_SmtpServerUsername%%:
								</td>
								<td>
									<img width="20" height="20" src="images/blank.gif"/>
									<input type="text" name="smtp_u" value="%%GLOBAL_SmtpUsername%%" class="Field250 smtpSettings"> %%LNG_HLP_SmtpServerUsername%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_SmtpServerPassword%%:
								</td>
								<td>
									<img width="20" height="20" src="images/blank.gif"/>
									<input type="password" name="smtp_p" value="%%GLOBAL_SmtpPassword%%" class="Field250 smtpSettings" autocomplete="off" /> %%LNG_HLP_SmtpServerPassword%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_SmtpServerPort%%:
								</td>
								<td>
									<img width="20" height="20" src="images/blank.gif"/>
									<input type="text" name="smtp_port" value="%%GLOBAL_SmtpPort%%" class="field50 smtpSettings"> %%LNG_HLP_SmtpServerPort%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_TestSMTPSettings%%:
								</td>
								<td>
									<img width="20" height="20" src="images/blank.gif"/>
									<input type="text" name="smtp_test" id="smtp_test" value="" class="Field250 smtpSettings"> %%LNG_HLP_TestSMTPSettings%%
								</td>
							</tr>
							<tr class="SMTPOptions" style="display:none">
								<td class="FieldLabel">&nbsp;
									
								</td>
								<td>
									<img width="20" height="20" src="images/blank.gif"/>
									<input type="button" name="cmdTestSMTP" value="%%LNG_TestSMTPSettings%%" class="FormButton" style="width: 120px;"/>
								</td>
							</tr>
							<tr style="display:%%GLOBAL_ShowSMTPCOMOption%%">
								<td class="FieldLabel">&nbsp;</td>
								<td>
									<label for="signtosmtp">
										<input type="radio" name="smtptype" id="signtosmtp" value="2"/>
										%%LNG_SMTPCOM_UseSMTPOption%%
									</label>
									%%LNG_HLP_UseSMTPCOM%%
								</td>
							</tr>
							<tr class="sectionSignuptoSMTP" style="display: none;">
								<td colspan="2" class="EmptyRow">&nbsp;
									
								</td>
							</tr>
							<tr class="sectionSignuptoSMTP" style="display: none;">
								<td colspan="2" class="Heading2">
									&nbsp;&nbsp;%%LNG_SMTPCOM_Header%%
								</td>
							</tr>
							<tr class="sectionSignuptoSMTP" style="display: none;">
								<td colspan="2" style="padding-left: 10px; padding-top:10px">%%LNG_SMTPCOM_Explain%%</td>
							</tr>
						</table>
					</div>
				</div>

					<div id="div5" style="display:none; padding-top:10px">
					<p class="HelpInfo">%%LNG_GoogleCalendarIntroText%%</p>
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td colspan="2" class="Heading2" style="padding-left:10px">
									%%LNG_GoogleCalendarIntro%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel" width="10%">
									<img src="images/blank.gif" width="200" height="1" /><br />
									{template="Not_Required"}
									%%LNG_GoogleCalendarUsername%%:
								</td>
								<td width="90%">
									<label for="googlecalendarusername">
										<input type="text" class="Field250 googlecalendar" name="googlecalendarusername" id="googlecalendarusername" value="%%GLOBAL_googlecalendarusername%%" autocomplete="off" />
									</label>
									%%LNG_HLP_GoogleCalendarUsername%%
								</td>
							</tr>

							<tr>
								<td class="FieldLabel" width="10%">
									<img src="images/blank.gif" width="200" height="1" /><br />
									{template="Not_Required"}
									%%LNG_GoogleCalendarPassword%%:
								</td>
								<td width="90%">
									<label for="googlecalendarpassword">
										<input type="password" class="Field250 googlecalendar" name="googlecalendarpassword" id="googlecalendarpassword" value="%%GLOBAL_googlecalendarpassword%%" autocomplete="off" />
									</label>
									%%LNG_HLP_GoogleCalendarPassword%%
								</td>
							</tr>
						</table>
					</div>
				</div>

				<table border="0" cellspacing="0" cellpadding="2" width="100%" class=PanelPlain>
					<tr>
						<td width="200" class="FieldLabel">&nbsp;
							
						</td>
						<td height="30" valign="top">
							<input type="button" id="cmdTestGoogleCalendar" value="%%LNG_TestLogin%%" class="FormButton" style="display: none;"/>
							<input class="FormButton" type="submit" value="%%LNG_Save%%">
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%"/>
							<span id="spanTestGoogleCalendar" style="display:none;">&nbsp;&nbsp;<img src="images/searching.gif" alt="wait" /></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

