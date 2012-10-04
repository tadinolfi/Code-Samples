<script src="includes/js/jquery/form.js"></script>
<script src="includes/js/jquery/thickbox.js"></script>
<link rel="stylesheet" type="text/css" href="includes/styles/thickbox.css" />
<script>
	$(function() {
		$("#tabbedNavigation > ul").tabs();

		$(document.users).submit(function() {
			if (this.username.value == "") {
				$("#tabbedNavigation > ul").tabsClick(1);
				alert("%%LNG_EnterUsername%%");
				this.username.focus();
				return false;
			}

			if (this.ss_p.value != "") {
				if (this.ss_p_confirm.value == "") {
					$("#tabbedNavigation > ul").tabsClick(1);
					alert("%%LNG_PasswordConfirmAlert%%");
					this.ss_p_confirm.focus();
					return false;
				}

				if (this.ss_p.value != this.ss_p_confirm.value) {
					$("#tabbedNavigation > ul").tabsClick(1);
					alert("%%LNG_PasswordsDontMatch%%");
					this.ss_p_confirm.select();
					this.ss_p_confirm.focus();
					return false;
				}
			}

			if (this.emailaddress.value == "") {
				$("#tabbedNavigation > ul").tabsClick(1);
				alert("%%LNG_EnterEmailaddress%%");
				this.emailaddress.focus();
				return false;
			}

			return true;
		});

		$('.CancelButton', document.users).click(function() { if(confirm('%%LNG_ConfirmCancel%%')) document.location.href='index.php?Page=Users'; });

		$(document.users.usewysiwyg).click(function() { $('#sectionUseXHTML')[this.checked? 'show' : 'hide'](); });
		$(document.users.limitmaxlists).click(function() { $('#DisplayMaxLists').toggle(); });
		$(document.users.limitperhour).click(function() { $('#DisplayEmailsPerHour').toggle(); });
		$(document.users.limitpermonth).click(function() { $('#DisplayEmailsPerMonth').toggle(); });
		$(document.users.unlimitedmaxemails).click(function() { $('#DisplayEmailsMaxEmails').toggle(); });

		$(document).ready(function() {
			populatePermBoxes();
		});

		$(document.users.admintype).change(function() {
			populatePermBoxes();
		});

		$('.PermissionOptionItems').click(function() {
			calcUserType();
		});

		$('.SelectOnFocus').focus(function() { this.select(); });

		$(document.users.listadmintype).change(function() { $('#PrintLists')[this.selectedIndex == 0? 'hide' : 'show'](); });
		$(document.users.templateadmintype).change(function() { $('#PrintTemplates')[this.selectedIndex == 0? 'hide' : 'show'](); });


	});

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
			switch (document.users.admintype.selectedIndex) {
				case 0: this.checked = true; break;
				case 1: this.checked = !!this.name.match(/list/); break;
				case 2: this.checked = !!this.name.match(/newsletter/); break;
				case 3: this.checked = !!this.name.match(/template/); break;
				case 4: this.checked = !!this.name.match(/user/); break;
			}
		});
	}

	/**
	 * Checks that all $(name)s matching 'pattern' are checked, or if
	 * reversed, checks that all $(name)s not matching 'pattern' are
	 * not checked.
	 */
	function allItemsChecked(name, pattern, reverse) {
		var all_checked = true;
		$(name).each(function() {
			if ((!reverse && this.name.match(pattern) && !this.checked) || (reverse && !this.name.match(pattern) && this.checked)) {
				all_checked = false;
				return false;
			}
		});
		return all_checked;
	}

	/**
	 * Calculates what type the user is based on which boxes are checked.
	 */
	function calcUserType() {
		document.users.admintype.selectedIndex = 5; // Custom
		patterns = [/./, /list/, /newsletter/, /template/, /user/];
		for (i=patterns.length-1; i>=0; i--) {
			if (allItemsChecked('.PermissionOptionItems', patterns[i], false) && allItemsChecked('.PermissionOptionItems', patterns[i], true)) {
				document.users.admintype.selectedIndex = i;
			}
		}
	}
</script>
<form name="users" method="post" action="index.php?Page=%%PAGE%%&%%GLOBAL_FormAction%%">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">%%GLOBAL_Heading%%</td>
		</tr>
		<tr>
			<td class="body">%%GLOBAL_Help_Heading%%</td>
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
					<br/>
					<ul id="tabbedNavigation" style="margin:0;padding:0;">
						<ul>
							<li><a href="#" class="active" id="tab1" onclick="ShowTab(1); return false;"><span>%%LNG_UserSettings_Heading%%</span></a></li>
							<li><a href="#" id="tab2" onclick="ShowTab(2); return false;"><span>%%LNG_UserRestrictions_Heading%%</span></a></li>
							<li><a href="#" id="tab2" onclick="ShowTab(2); return false;"><span>%%LNG_UserPermissions_Heading%%</span></a></li>
						</ul>
					</ul>

					<div id="div1" style="padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td class=Heading2 colspan=2>
									%%LNG_UserDetails%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_UserName%%:
								</td>
								<td>
									<input type="text" name="username" value="%%GLOBAL_UserName%%" id="username" class="Field250">
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
									<input type="text" name="fullname" value="%%GLOBAL_FullName%%" id="fullname" class="Field250">
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_EmailAddress%%:
								</td>
								<td>
									<input type="text" name="emailaddress" value="%%GLOBAL_EmailAddress%%" id="emailaddress" class="Field250">&nbsp;%%LNG_HLP_EmailAddress%%
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
									%%LNG_HTMLFooter%%:
								</td>
								<td>
									<textarea name="htmlfooter" rows="10" cols="50" wrap="virtual">%%GLOBAL_HTMLFooter%%</textarea>&nbsp;&nbsp;&nbsp;%%LNG_HLP_HTMLFooter%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">&nbsp;</td>
								<td>{$lang.ViewKB_ExplainDefaultFooter}</td>
							</tr>
							<tr>
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
							<tr>
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
						</table>
					</div>

					<div id="div2" style="display:none; padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">

							<tr>
								<td colspan="2" class="Heading2">
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
											%%LNG_LimitMaximumEmailsExplain%%
										</label>
										%%LNG_HLP_LimitMaximumEmails%%
									</div>
									<div id="DisplayEmailsMaxEmails" style="display: %%GLOBAL_DisplayEmailsMaxEmails%%;">
										<img src="images/nodejoin.gif" width="20" height="20">&nbsp;%%LNG_MaximumEmails%%:
										<input type="text" name="maxemails" value="%%GLOBAL_MaxEmails%%" class="Field50">
										%%LNG_HLP_MaximumEmails%%
									</div>
								</td>
							</tr>
						</table>
					</div>

					<div id="div3" style="display:none; padding-top:10px">
						<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
							<tr>
								<td class=Heading2 colspan=2>
									%%LNG_AccessPermissions%%
								</td>
							</tr>
							<tr>
								<td class="FieldLabel">
									{template="Required"}
									%%LNG_AdministratorType%%:
								</td>
								<td>
									<select name="admintype" class="Field250">
										%%GLOBAL_PrintAdminTypes%%
									</select>
									%%LNG_HLP_AdministratorType%%
								</td>
							</tr>
							<tr class="CustomPermissionOptions AutoresponderPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_AutoresponderPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="autoresponders_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][create]" id="autoresponders_create"%%GLOBAL_Permissions_Autoresponders_Create%%>&nbsp;%%LNG_CreateAutoresponders%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												<label for="autoresponders_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][approve]" id="autoresponders_approve"%%GLOBAL_Permissions_Autoresponders_Approve%%>&nbsp;%%LNG_ApproveAutoresponders%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="autoresponders_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][edit]" id="autoresponders_edit"%%GLOBAL_Permissions_Autoresponders_Edit%%>&nbsp;%%LNG_EditAutoresponders%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="autoresponders_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[autoresponders][delete]" id="autoresponders_delete"%%GLOBAL_Permissions_Autoresponders_Delete%%>&nbsp;%%LNG_DeleteAutoresponders%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions FormPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_FormPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="forms_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][create]" id="forms_create"%%GLOBAL_Permissions_Forms_Create%%>&nbsp;%%LNG_CreateForms%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="forms_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][edit]" id="forms_edit"%%GLOBAL_Permissions_Forms_Edit%%>&nbsp;%%LNG_EditForms%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="forms_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[forms][delete]" id="forms_delete"%%GLOBAL_Permissions_Forms_Delete%%>&nbsp;%%LNG_DeleteForms%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions ListPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_ListPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="lists_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][create]" id="lists_create"%%GLOBAL_Permissions_Lists_Create%%>&nbsp;%%LNG_CreateMailingLists%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												<label for="lists_bounce"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][bounce]" id="lists_bounce"%%GLOBAL_Permissions_Lists_Bounce%%>&nbsp;%%LNG_MailingListsBounce%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="lists_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][edit]" id="lists_edit"%%GLOBAL_Permissions_Lists_Edit%%>&nbsp;%%LNG_EditMailingLists%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td width="200">
												<label for="lists_bouncesettings"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][bouncesettings]" id="lists_bouncesettings"%%GLOBAL_Permissions_Lists_Bouncesettings%%>&nbsp;%%LNG_MailingListsBounceSettings%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="lists_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[lists][delete]" id="lists_delete"%%GLOBAL_Permissions_Lists_Delete%%>&nbsp;%%LNG_DeleteMailingLists%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions CustomFieldPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_CustomFieldPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="customfields_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][create]" id="customfields_create"%%GLOBAL_Permissions_Customfields_Create%%>&nbsp;%%LNG_CreateCustomFields%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="customfields_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][edit]" id="customfields_edit"%%GLOBAL_Permissions_Customfields_Edit%%>&nbsp;%%LNG_EditCustomFields%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="customfields_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[customfields][delete]" id="customfields_delete"%%GLOBAL_Permissions_Customfields_Delete%%>&nbsp;%%LNG_DeleteCustomFields%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions NewsletterPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_NewsletterPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="newsletters_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][create]" id="newsletters_create"%%GLOBAL_Permissions_Newsletters_Create%%>&nbsp;%%LNG_CreateNewsletters%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												<label for="newsletters_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][approve]" id="newsletters_approve"%%GLOBAL_Permissions_Newsletters_Approve%%>&nbsp;%%LNG_ApproveNewsletters%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="newsletters_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][edit]" id="newsletters_edit"%%GLOBAL_Permissions_Newsletters_Edit%%>&nbsp;%%LNG_EditNewsletters%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												<label for="newsletters_send"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][send]" id="newsletters_send"%%GLOBAL_Permissions_Newsletters_Send%%>&nbsp;%%LNG_SendNewsletters%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="newsletters_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[newsletters][delete]" id="newsletters_delete"%%GLOBAL_Permissions_Newsletters_Delete%%>&nbsp;%%LNG_DeleteNewsletters%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions SubscriberPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_SubscriberPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="subscribers_add"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][add]" id="subscribers_add"%%GLOBAL_Permissions_Subscribers_Add%%>&nbsp;%%LNG_AddSubscribers%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="subscribers_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][edit]" id="subscribers_edit"%%GLOBAL_Permissions_Subscribers_Edit%%>&nbsp;%%LNG_EditSubscribers%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="subscribers_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[subscribers][delete]" id="subscribers_delete"%%GLOBAL_Permissions_Subscribers_Delete%%>&nbsp;%%LNG_DeleteSubscribers%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions TemplatePermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_TemplatePermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="templates_create"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][create]" id="templates_create"%%GLOBAL_Permissions_Templates_Create%%>&nbsp;%%LNG_CreateTemplates%%</label>
											</td>
											<td width="35">
												&nbsp;
											</td>
											<td width="200">
												<label for="templates_approve"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][approve]" id="templates_approve"%%GLOBAL_Permissions_Templates_Approve%%>&nbsp;%%LNG_ApproveTemplates%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												<label for="templates_edit"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][edit]" id="templates_edit"%%GLOBAL_Permissions_Templates_Edit%%>&nbsp;%%LNG_EditTemplates%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												<label for="templates_global"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][global]" id="templates_global"%%GLOBAL_Permissions_Templates_Global%%>&nbsp;%%LNG_GlobalTemplates%%</label>
											</td>
											<td>
												%%LNG_HLP_GlobalTemplates%%
											</td>
										</tr>
										<tr>
											<td>
												<label for="templates_delete"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][delete]" id="templates_delete"%%GLOBAL_Permissions_Templates_Delete%%>&nbsp;%%LNG_DeleteTemplates%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												<label for="templates_builtin"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[templates][builtin]" id="templates_builtin"%%GLOBAL_Permissions_Templates_Builtin%%>&nbsp;%%LNG_BuiltInTemplates%%</label>
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions StatisticPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_StatisticsPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="statistics_newsletter"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][newsletter]" id="statistics_newsletter"%%GLOBAL_Permissions_Statistics_Newsletter%%>&nbsp;%%LNG_NewsletterStatistics%%</label>
											</td>
											<td width="35">&nbsp;</td>
											<td>
												<label for="statistics_user"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][user]" id="statistics_user"%%GLOBAL_Permissions_Statistics_User%%>&nbsp;%%LNG_UserStatistics%%</label>
											</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td width="170">
												<label for="statistics_autoresponder"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][autoresponder]" id="statistics_autoresponder"%%GLOBAL_Permissions_Statistics_Autoresponder%%>&nbsp;%%LNG_AutoresponderStatistics%%</label>
											</td>
											<td width="35">&nbsp;</td>
											<td>
												<label for="statistics_list"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[statistics][list]" id="statistics_list"%%GLOBAL_Permissions_Statistics_List%%>&nbsp;%%LNG_ListStatistics%%</label>
											</td>
											<td>&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="CustomPermissionOptions AdminPermissionOptions" style="display: %%GLOBAL_DisplayPermissions%%">
								<td class="FieldLabel">
									{template="Not_Required"}
									%%LNG_AdminPermissions%%:
								</td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="170">
												<label for="system_system"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][system]" id="system_system"%%GLOBAL_Permissions_System_System%%>&nbsp;%%LNG_SystemAdministrator%%</label>
											</td>
											<td width="35">
												%%LNG_HLP_SystemAdministrator%%
											</td>
											<td width="200">
												<label for="system_list"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][list]" id="system_list"%%GLOBAL_Permissions_System_List%%>&nbsp;%%LNG_ListAdministrator%%</label>
											</td>
											<td>
												%%LNG_HLP_ListAdministrator%%
											</td>
										</tr>
										<tr>
											<td>
												<label for="system_user"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][user]" id="system_user"%%GLOBAL_Permissions_System_User%%>&nbsp;%%LNG_UserAdministrator%%</label>
											</td>
											<td>
												&nbsp;
											</td>
											<td width="200">
												<label for="system_template"><input type="checkbox" class="PermissionOptionItems" value="1" name="permissions[system][template]" id="system_template"%%GLOBAL_Permissions_System_Template%%>&nbsp;%%LNG_TemplateAdministrator%%</label>
											</td>
											<td>
												%%LNG_HLP_TemplateAdministrator%%
											</td>
										</tr>
									</table>
								</td>
							</tr>

							<tr>
								<td class="EmptyRow" colspan=2>
									&nbsp;
								</td>
							</tr>

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
								<td class="EmptyRow" colspan=2>
									&nbsp;
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

				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel"Plain>
					<tr>
						<td width="200" class="FieldLabel">
							&nbsp;
						</td>
						<td height="30" valign="top">
							<input class="FormButton" type="submit" value="%%LNG_Save%%">
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

