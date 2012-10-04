{* On the Lists page, each option has 20px padding, so we need to factor this out. *}
{capture name=style}{if $IEM.CurrentPage == 'lists'}padding-left:20px;{/if}{/capture}
<tr>
	<td class="EmptyRow" colspan="2" style="display: %%GLOBAL_ShowBounceInfo%%">
		<script>
			Application.Page.BounceInfo = {
				process_form: ('%%GLOBAL_ShowBounceInfo%%' == ''),
				bounce_form: null,
				bounce_process: null,
				bounce_agreedelete: null,
				extraSettingsPattern: {'notls': 'notls',
										'novalidate-cert': 'novalidate',
										'nossl': 'nossl'},

				eventDOMReady: function(event) {
					// we cannot use 'this' because the event overrides it with the DOM
					var bi = Application.Page.BounceInfo;

					if (bi.process_form) {
						// setup data members that need DOM elements
						bi.bounce_form = $('#bounce_server').parents().filter("form").get(0);
						bi.bounce_process = $('#bounce_process').get(0);
						bi.bounce_agreedelete = $('#bounce_agreedelete').get(0);
						// setup the DOM
						bi.SetupClickEvents();
						bi.SetupSubmitEvents();
						bi.RevealBounceOptions();
						bi.RevealExtraMailSettings();
					}
				},

				/**
				 * Closes the bounce test thickbox.
				 */
				closeBounceTest: function() {
					tb_remove();
				},

				/**
				 * Collects the parameters to connect to the bounce server.
				 *
				 * @return String A parameter string to use in a query string.
				 */
				getBounceParameters: function() {
					if (!this.evaluateExtraSettings()) {
						return false;
					}
					var options = '&';
					$($('.bounceSettings').fieldSerialize().split('&')).each(function(i, n) {
						var temp = n.split('=');
						if (temp.length == 2) {
							options = options + temp[0] + '=' + escape(temp[1]) + '&';
						}
					});
					return options;
				},

				/**
				 * Transforms the extra mail settings into their corresponding checkbox settings.
				 *
				 * @return Boolean True if the checkboxes were adjusted successfully, otherwise false.
				 */
				evaluateExtraSettings: function() {
					try {
						if (this.bounce_form.bounce_extraoption.checked) {
							if (this.bounce_form.extramail_others.checked && !this.bounce_form.extramail_others_value.value.match(/^\//)) {
								alert("{$lang.InvalidExtraMailSettings}");
								this.bounce_form.extramail_others_value.focus();
								return false;
							}
							var tempSettings = [];
							for (var i in this.extraSettingsPattern) {
								if(this.bounce_form['extramail_' + this.extraSettingsPattern[i]].checked) {
									tempSettings.push(i);
								}
							}
							this.bounce_form.bounce_extrasettings.value = (tempSettings.length > 0? '/' + tempSettings.join('/') : '') + (this.bounce_form.extramail_others.checked ? this.bounce_form.extramail_others_value.value : '');
						} else {
							for(var i in this.extraSettingsPattern) {
								this.bounce_form['extramail_' + this.extraSettingsPattern[i]].checked = false;
							}
							this.bounce_form.bounce_extrasettings.value = '';
						}
						if (this.bounce_form.bounce_extrasettings.value == '0') {
							this.bounce_form.bounce_extrasettings.value = '';
						}
					} catch (e) {
						alert('{$lang.UnableEvaluateExtraMailSettings}');
						return false;
					}

					return true;
				},

				/**
				 * Set up the various onClick event handlers.
				 */
				SetupClickEvents: function() {
					var bi = this;
					var f = bi.bounce_form;
					// Toggle the extra mail settings
					$(f.bounce_extraoption).click(function() { $('#showextramailsettings').toggle(); });
					// Enable extra mail settings when revealed
					$(f.extramail_others).click(function() { f.extramail_others_value.disabled = !this.checked;  });
					// Perform the bounce test if the button is there
					f.cmdTestBounce && $(f.cmdTestBounce).click(function() {
						if (f.bounce_server.value == '') {
							alert("{$lang.TestBounceSettings_Server_Alert}");
							f.bounce_server.focus();
							return false;
						}
						if (f.bounce_username.value == '') {
							alert("{$lang.TestBounceSettings_Username_Alert}");
							f.bounce_username.focus();
							return false;
						}
						if (f.bounce_password.value == '') {
							alert("{$lang.TestBounceSettings_Password_Alert}");
							f.bounce_password.focus();
							return false;
						}
						var url = 'index.php?Page=Lists&Action=TestBounceDisplay&keepThis=true&' + bi.getBounceParameters() + '&TB_iframe=true&height=250&width=420&modal=true';
						tb_show('', url, '');
						return true;
					});
					// Reveal all of the bounce options if they want to process bounces
					$('#bounce_process').click(function() {
						$('.YesProcessBounce').toggle();
						if (!this.checked) {
							$('.SubmitButton').attr('disabled', false);
							/*$('#bounce_agreedelete').attr('checked', false);
							$('#bounce_agreedeleteall').attr('checked', false);*/
							Application.Page.BounceInfo.ClearBounceSettings();
						} else {
							$('.SubmitButton').attr('disabled', true);
						}
					});
					// Enable the submit button if they understand it will delete emails
					$('#bounce_agreedelete').click(function() {
						$('.SubmitButton').attr('disabled', !this.checked);
						var div = $('#bounce_agreedeleteall_div');
						var checkbox = $('#bounce_agreedeleteall');
						// show the option to delete *all* emails
						if (this.checked) {
							div.show();
						} else {
							checkbox.attr('checked', false);
							div.hide();
						}
					});
					$('#bounce_agreedeleteall').click(function() {
						// give them a warning after they check the option
						if (this.checked) {
							{if $IEM.CurrentPage == 'bounce'}
							var prompter = '{$lang.ProcessBounceDeleteAll_ManualPrompt}';
							{else}
							var prompter = '{$lang.ProcessBounceDeleteAll_AutoPrompt}';
							{/if}
							this.checked = confirm(prompter);
						}
					});
				},

				/**
				 * Set up the various onSubmit event handlers.
				 */
				SetupSubmitEvents: function() {
					// ensure the Bounce Details Fields are populated
					var bounce_details = this;

					$(bounce_details.bounce_form).submit(function(event) {
						try {
							var bounceFrm = bounce_details.bounce_form;
							// don't check if they're not doing bounce processing
							if (!bounceFrm.bounce_process || (bounceFrm.bounce_process && bounceFrm.bounce_process.checked)) {

								// check that a bounce server name has been entered
								if (bounceFrm.bounce_server.value.trim() == '') {
									alert("{$lang.EnterBounceServer}");
									bounceFrm.bounce_server.focus();
									return false;
								}

								// check that a username has been entered1
								if  (bounceFrm.bounce_username.value.trim() == '') {
									alert("{$lang.EnterBounceUsername}");
									bounceFrm.bounce_username.focus();
									return false;
								}

								// check that a password has been entered for the bounce email account
								if  (bounceFrm.bounce_password.value.trim() == '') {
									alert("{$lang.EnterBounceEmailAddress}");
									bounceFrm.bounce_password.focus();
									return false;
								}

								return bounce_details.evaluateExtraSettings();
							}
						} catch (e) {
							alert('Unable to validate');
							return false;
						}
					});
				},

				/**
				 * Reveal the bounce options if applicable, otherwise hide them.
				 */
				RevealBounceOptions: function() {
					// make sure the Delete All Emails option is visible if applicable
					if ($('#bounce_agreedelete').attr('checked')) {
						$('#bounce_agreedeleteall_div').show();
					} else {
						$('#bounce_agreedeleteall').attr('checked', false);
					}
					// if showing the bounce options is optional, check if we should show them
					if (!this.bounce_process) {
						return;
					}
					if (this.bounce_process.checked && '%%GLOBAL_ShowBounceInfo%%' != 'none') {
						$('.YesProcessBounce').show();
						if (this.bounce_form.bounce_agreedelete.checked) {
							$('.SubmitButton').attr('disabled', false);
						} else {
							$('.SubmitButton').attr('disabled', true);
						}
					} else {
						$('.YesProcessBounce').hide();
					}
				},

				/**
				 * Reveal the extra mail settings if applicable, otherwise hide them.
				 */
				RevealExtraMailSettings: function() {
					if (this.bounce_form.bounce_extraoption.checked || (this.bounce_form.bounce_extrasettings && this.bounce_form.bounce_extrasettings != '')) {
						this.bounce_form.bounce_extraoption.checked = true;
						if (this.bounce_form.bounce_extrasettings.value == '') {
							this.bounce_form.bounce_extraoption.checked = false;
							$('#showextramailsettings').hide();
						} else {
							var tempSettings = this.bounce_form.bounce_extrasettings.value.split('/');
							var tempOthers = [];
							for (var i=0, j=tempSettings.length; i<j; i++) {
								if (tempSettings[i] == '') {
									continue;
								}
								if (!this.extraSettingsPattern[tempSettings[i]]) {
									tempOthers.push(tempSettings[i]);
								} else {
									this.bounce_form['extramail_' + this.extraSettingsPattern[tempSettings[i]]].checked = true;
								}
							}
							if (tempOthers.length > 0) {
								this.bounce_form.extramail_others.checked = true;
								this.bounce_form.extramail_others_value.value = '/' + tempOthers.join('/');
								this.bounce_form.extramail_others_value.disabled = false;
							} else {
								this.bounce_form.extramail_others.checked = false;
								this.bounce_form.extramail_others_value.disabled = true;
							}
						}
					}
				},

				/**
				 * Clears all the bounce options. This is useful to avoid stale values getting saved when we don't want to process bounces any more.
				 */
				ClearBounceSettings: function() {
					$('.YesProcessBounce input[type!=button]').each(function() {
						if (this.value) {
							this.value = null;
						}
						if (this.checked) {
							this.checked = false;
						}
					});
				}
			};

			Application.init.push(Application.Page.BounceInfo.eventDOMReady);

		</script>
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%">
	<td colspan="2" class="Heading2">
		&nbsp;&nbsp;%%LNG_BounceAccountDetails%%
	</td>
</tr>
{if in_array($IEM.CurrentPage, array('lists', 'settings'))}
<tr style="display: %%GLOBAL_ShowBounceInfo%%">
	<td class="FieldLabel">
		{template="Not_Required"}
		{if $IEM.CurrentPage == 'settings'}%%LNG_SetDefaultBounceAccountDetails%%{else}%%LNG_ProcessBouncesLabel%%{/if}:&nbsp;
	</td>
	<td>
		<input type="checkbox" name="bounce_process" id="bounce_process" value="1" %%GLOBAL_ProcessBounceChecked%%/><label for="bounce_process">{if $IEM.CurrentPage == 'settings'}%%LNG_SetDefaultBounceAccountDetailsExplain%%{else}%%LNG_YesProcessBounces%%{/if}</label>
		{if $IEM.CurrentPage == 'settings'}
		%%LNG_HLP_SetDefaultBounceAccountDetails%%
		{else}
		<br/><a href="#" onClick="LaunchHelp('798'); return false;" style="margin-left:30px; color: gray;">%%LNG_ProcessBounceGuideLink%%</a>
		{/if}
	</td>
</tr>
{/if}
{if $IEM.CurrentPage == 'settings'}
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{template="Not_Required"}
		%%LNG_DefaultBounceAddress%%:
	</td>
	<td>
		<input type="text" name="bounce_address" id="bounce_address" value="%%GLOBAL_Bounce_Address%%" class="Field250 bounceSettings"> %%LNG_HLP_DefaultBounceAddress%%
	</td>
</tr>
{/if}
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{if $IEM.CurrentPage == 'settings'}{template="Not_Required"}{else}{template="Required"}{/if}
		{if $IEM.CurrentPage == 'settings'}%%LNG_DefaultBounceServer%%{else}%%LNG_ListBounceServer%%{/if}:&nbsp;
	</td>
	<td style="{$style}">
		<input type="text" name="bounce_server" id="bounce_server" class="Field250 form_text bounceSettings" value="%%GLOBAL_Bounce_Server%%">&nbsp;{if $IEM.CurrentPage == 'settings'}%%LNG_HLP_DefaultBounceServer%%{else}%%LNG_HLP_ListBounceServer%%{/if}
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{if $IEM.CurrentPage == 'settings'}{template="Not_Required"}{else}{template="Required"}{/if}
		{if $IEM.CurrentPage == 'settings'}%%LNG_DefaultBounceUsername%%{else}%%LNG_ListBounceUsername%%{/if}:&nbsp;
	</td>
	<td style="{$style}">
		<input type="text" name="bounce_username" class="Field250 form_text bounceSettings" value="%%GLOBAL_Bounce_Username%%">&nbsp;{if $IEM.CurrentPage == 'settings'}%%LNG_HLP_DefaultBounceUsername%%{else}%%LNG_HLP_ListBounceUsername%%{/if}
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{if $IEM.CurrentPage == 'settings'}{template="Not_Required"}{else}{template="Required"}{/if}
		{if $IEM.CurrentPage == 'settings'}%%LNG_DefaultBouncePassword%%{else}%%LNG_ListBouncePassword%%{/if}:&nbsp;
	</td>
	<td style="{$style}">
		<input type="password" name="bounce_password" class="Field250 form_password bounceSettings" value="%%GLOBAL_Bounce_Password%%" autocomplete="off" />&nbsp;{if $IEM.CurrentPage == 'settings'}%%LNG_HLP_DefaultBouncePassword%%{else}%%LNG_HLP_ListBouncePassword%%{/if}
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{template="Not_Required"}
		%%LNG_IMAPAccount%%:&nbsp;
	</td>
	<td style="{$style}">
		<label for="bounce_imap"><input type="checkbox" name="bounce_imap" id="bounce_imap" class="bounceSettings" value="1" %%GLOBAL_Bounce_Imap%%>%%LNG_IMAPAccountExplain%%</label> %%LNG_HLP_IMAPAccount%%
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{template="Not_Required"}
		%%LNG_UseExtraMailSettings%%:&nbsp;
	</td>
	<td style="{$style}">
		<div>
			<label for="bounce_extraoption">
				<input type="checkbox" name="bounce_extraoption" id="bounce_extraoption" value="1" class="bounceSettings"%%GLOBAL_Bounce_ExtraOption%% />%%LNG_UseExtraMailSettingsExplain%%
			</label> %%LNG_HLP_UseExtraMailSettings%%
		</div>
		<div id="showextramailsettings" style="display: %%GLOBAL_DisplayExtraMailSettings%%">
			<input type="hidden" name="bounce_extrasettings" class="bounceSettings" value="%%GLOBAL_Bounce_ExtraSettings%%" />
			<div>
				<img width="20" height="20" src="images/nodejoin.gif"/>
				<label for="extramail_novalidate">
					<input type="checkbox" name="extramail_novalidate" id="extramail_novalidate" value="validate" />%%LNG_ExtraMailSettingsNoValidate_field%%
				</label>&nbsp;%%LNG_HLP_ExtraMailSettingsNoValidate%%
			</div>
			<div>
				<img width="20" height="20" src="images/blank.gif"/>
				<label for="extramail_notls">
					<input type="checkbox" name="extramail_notls" id="extramail_notls" value="tls" />%%LNG_ExtraMailSettingsNoTLS_field%%
				</label>&nbsp;%%LNG_HLP_ExtraMailSettingsNoTLS%%
			</div>
			<div>
				<img width="20" height="20" src="images/blank.gif"/>
				<label for="extramail_nossl">
					<input type="checkbox" name="extramail_nossl" id="extramail_nossl" value="ssl" />%%LNG_ExtraMailSettingsNoSSL_field%%
				</label>&nbsp;%%LNG_HLP_ExtraMailSettingsNoSSL%%
			</div>
			<div>
				<img width="20" height="20" src="images/blank.gif"/>
				<label for="extramail_others">
					<input type="checkbox" name="extramail_others" id="extramail_others" value="others" />%%LNG_ExtraMailSettingsOthers_field%%
				</label>
				<input type="text" name="extramail_others_value" class="Field250 form_text" value="" disabled="disabled" />&nbsp;%%LNG_HLP_ExtraMailSettingsOthers%%
			</div>
		</div>
	</td>
</tr>
<tr style="display: %%GLOBAL_ShowBounceInfo%%" class="YesProcessBounce">
	<td class="FieldLabel">
		{template="Not_Required"}
		%%LNG_AgreeDeleteLabel%%:&nbsp;
	</td>
	<td style="{$style}">
		<input type="checkbox" name="bounce_agreedelete" id="bounce_agreedelete" value="1"%%GLOBAL_Bounce_AgreeDelete%%/><label for="bounce_agreedelete">%%LNG_ProcessBounceDelete%%</label>
		<div style="display:none;" id="bounce_agreedeleteall_div">
			<img width="20" height="20" src="images/nodejoin.gif" /><input type="checkbox" name="bounce_agreedeleteall" id="bounce_agreedeleteall" value="1"%%GLOBAL_Bounce_AgreeDeleteAll%%/><label for="bounce_agreedeleteall">%%LNG_ProcessBounceDeleteAll%%</label>&nbsp;%%LNG_HLP_ProcessBounceDeleteAll%%
			{if $IEM.CurrentPage == 'bounce'}
			<br/><span style="margin-left:40px; color:gray;">%%LNG_ExplainBounceDeleteAll%%</span>
			{/if}
		</div>
	</td>
</tr>
{if $IEM.CurrentPage == 'bounce'}
<tr>
	<td class="FieldLabel">
		{template="Not_Required"}
		%%LNG_SaveBounceServerDetails%%:&nbsp;
	</td>
	<td style="{$style}">
		<label for="savebounceserverdetails"><input type="checkbox" name="savebounceserverdetails" id="savebounceserverdetails" value="1">%%LNG_SaveBounceServerDetailsExplain%%</label> %%LNG_HLP_SaveBounceServerDetails%%
	</td>
</tr>
{/if}
{if in_array($IEM.CurrentPage, array('lists', 'settings'))}
<tr class="YesProcessBounce" style="display: %%GLOBAL_ShowBounceInfo%%">
	<td class="FieldLabel">
		{template="Not_Required"}
		{if $IEM.CurrentPage == 'settings'}%%LNG_TestBounceSettings%%:{/if}&nbsp;
	</td>
	<td><input name="cmdTestBounce" type="button" value="%%LNG_TestBounceSettings%%" class="FormButton YesProcessBounce" style="width: 120px;" style="display: %%GLOBAL_ShowBounceInfo%%"/></td>
</tr>
{/if}