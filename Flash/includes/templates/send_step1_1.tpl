<script>
	var PAGE = {
		init:						function() {
			$(document.frmSend).submit(function(event) {
				event.preventDefault();
				event.stopPropagation();
			});

			$('.CancelButton').click(function() { PAGE.cancel(); });

			$('.SubmitButton').click(function() { PAGE.submit(); });

			$('#lists').dblclick(function() { PAGE.submit(); });

			$('.SendFilteringOption').click(function() { PAGE.selectSendingOption(this.value); });
			$('.SendFilteringOption_Label').click(function() {
				var id = $(this).attr('id');
				if($(id)) $(id).click();
			});


			PAGE.showMailingList();
		},
		submit:					function() {
				var elm = $('.SelectedLists').get(0);
				if(elm.selectedIndex == -1) alert("%%LNG_SelectList%%");
				else document.frmSend.submit();
		},
		cancel:					function() {
			if(confirm("%%LNG_Send_CancelPrompt%%"))
				document.location="index.php?Page=Newsletters";
		},
		selectSendingOption:	function(sendingOption) {
			this.showMailingList();
		},
		showMailingList:		function(transition) {
			$('#FilteringOptions').show(transition? 'slow' : '');
		}
	};

	$(function() { PAGE.init(); });
</script>
<form name="frmSend" method="post" action="index.php?Page=Send&Action=Step2">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">
				<div class="Heading1Image"><img src="images/headerimages/%%LNG_Send_Step1%%.jpg" alt="%%LNG_Send_Step1%%" /></div><div class="Heading1Text">%%LNG_Send_Step1%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
			</td>
		</tr>
		<tr>
			<td class="body pageinfo">
				<p>
					%%LNG_Send_Step1_Intro%%
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
				<input class="FormButton SubmitButton" type="button" value="%%LNG_Next%%" />
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					<tr>
						<td colspan="2" class="Heading2">
							&nbsp;&nbsp;%%LNG_FilterOptions_Send%%
						</td>
					</tr>
					<tr>
						<td class="FieldLabel">
							{template="Not_Required"}
							%%LNG_ShowFilteringOptions_Send%%&nbsp;
						</td>
						<td valign="top">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="350px;">
										<label class="SendFilteringOption_Label" for="DoNotShowFilteringOptions"><input type="radio" name="ShowFilteringOptions" id="DoNotShowFilteringOptions" class="SendFilteringOption" value="2" checked="checked" />%%LNG_SendDoNotShowFilteringOptionsExplain%%</label>
										%%LNG_HLP_ShowFilteringOptions%%
									</td>
								</tr>
								<tr>
									<td>
										<label class="SendFilteringOption_Label" for="ShowFilteringOptions"><input type="radio" name="ShowFilteringOptions" id="ShowFilteringOptions" class="SendFilteringOption" value="1" />%%LNG_SendShowFilteringOptionsExplain%%</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div id="FilteringOptions" %%GLOBAL_FilteringOptions_Display%%>
					<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
						<tr>
							<td colspan="2" class="Heading2">
								&nbsp;&nbsp;%%LNG_MailingListDetails%%
							</td>
						</tr>
						<tr>
							<td width="200" class="FieldLabel">
								{template="Not_Required"}
								%%LNG_SendMailingList%%:&nbsp;
							</td>
							<td>
								<select id="lists" name="lists[]" multiple="multiple" class="SelectedLists ISSelectReplacement ISSelectSearch">
									%%GLOBAL_SelectList%%
								</select>&nbsp;%%LNG_HLP_SendMailingList%%
							</td>
						</tr>
					</table>
				</div>
				<table width="100%" cellspacing="0" cellpadding="2" border="0" class="PanelPlain">
					<tr>
						<td width="200" class="FieldLabel"></td>
						<td>
							<input class="FormButton SubmitButton" type="button" value="%%LNG_Next%%" />
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
