<script>
	$(function() {
		$('#myForm').submit(function(event) {
			if (!CheckForm()) {
				event.preventDefault();
				event.stopPropagation();
			}

			if ($('#DoNotShowFilteringOptions:checked').size() != 0) {
				var url = 'index.php?Page=Subscribers&Action=Manage&SubAction=step3';

				var list = $('#lists').get(0);
				for (var i = 0, j = list.options.length; i < j; i++) {
					if (list.options[i].selected){
						url += '&Lists[]=' + list.options[i].value;
					}
				}
				list = null;

				$('#myForm').attr('action', url);
			}

			return true;
		});

		$('.CancelButton').click(function(event) {
			if(confirm("%%LNG_Subscribers_Manage_CancelPrompt%%")) {
				document.location="index.php?Page=Subscribers";
			}
		});
	});

	function CheckForm() {
		var listbox = $('#lists').get(0);
		if (listbox.selectedIndex < 0) {
			alert("%%LNG_SelectList%%");
			listbox.focus();
			return false;
		}
		return true;
	}
</script>
<form method="post" action="index.php?Page=Subscribers&Action=Manage&SubAction=step2" id="myForm">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">
				<div class="Heading1Image"><img src="images/headerimages/search_for_contacts.jpg" alt="%%LNG_Subscribers_AdvancedSearch%%" /></div><div class="Heading1Text">%%LNG_Subscribers_AdvancedSearch%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
			</td>
		</tr>
		<tr>
			<td class="body pageinfo">
				<p>
					%%LNG_Subscribers_Manage_Intro%%
				</p>
			</td>
		</tr>
		<tr>
			<td>
				<input class="FormButton" type="submit" value="%%LNG_Next%%" />
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_FilterOptions_Subscribers%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_ShowFilteringOptionsLabel_Manage%%&nbsp;
						</td>
						<td valign="top">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="350px;">
										<label for="DoNotShowFilteringOptions"><input type="radio" name="ShowFilteringOptions" id="DoNotShowFilteringOptions" value="2" />%%LNG_SubscribersDoNotShowFilteringOptionsExplain%%</label>
									</td>
									<td>
										%%LNG_HLP_ShowFilteringOptions%%
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<label for="ShowFilteringOptions"><input type="radio" name="ShowFilteringOptions" id="ShowFilteringOptions" value="1" checked="checked" />%%LNG_SubscribersShowFilteringOptionsExplain%% </label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel" id="FilteringOptions">
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_MailingListDetails%%
						</td>
					</tr>
					<tr>
						<td width="200" class="FieldLabel">
							{template="Not_Required"}
							%%LNG_MailingList%%:&nbsp;
						</td>
						<td>
							<select id="lists" name="lists[]" onDblClick="this.form.submit()" multiple="multiple" class="ISSelectReplacement ISSelectSearch" style="%%GLOBAL_SelectListStyle%%">
								%%GLOBAL_SelectList%%
							</select>&nbsp;%%LNG_HLP_MailingList%%
						</td>
					</tr>
				</table>
				<table width="100%" cellspacing="0" cellpadding="2" border="0" class="PanelPlain">
					<tr>
						<td width="200" class="FieldLabel">&nbsp;</td>
						<td valign="top" height="30">
							<input class="FormButton SubmitButton" type="submit" value="%%LNG_Next%%" />
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>