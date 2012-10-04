<script src="includes/js/jquery/form.js"></script>
<script>
	$(function() {
		$('.CancelButton', document.frmProcessBounce).click(function() { if (confirm("%%LNG_Bounce_CancelPrompt%%")) { document.location="index.php?Page=Bounce" } });
	});
</script>
<form name="frmProcessBounce" method="post" action="index.php?Page=Bounce&Action=Step3">
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td class="Heading1">
				%%LNG_Bounce_Step2%%
			</td>
		</tr>
		<tr>
			<td class="body pageinfo">
				<p>
					%%LNG_Bounce_Step2_Intro%%
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
				<input class="FormButton SubmitButton" type="submit" value="%%LNG_Next%%" disabled="disabled" />
				<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
				<br />
				&nbsp;
				<table border="0" cellspacing="0" cellpadding="2" width="100%" class="Panel">
					{template="bounce_details"}
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input class="FormButton SubmitButton" type="submit" value="%%LNG_Next%%" disabled="disabled" />
							<input class="FormButton CancelButton" type="button" value="%%LNG_Cancel%%" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
