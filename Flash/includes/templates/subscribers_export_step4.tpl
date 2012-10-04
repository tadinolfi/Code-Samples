<script>
	$(function() {
		$('input#startExportSubscriber').click(function(event) {
			tb_show('', 'index.php?Page=Subscribers&Action=Export&SubAction=ExportIFrame&keepThis=true&TB_iframe=tue&height=260&width=450&modal=true', '');
			event.preventDefault();
			event.stopPropagation();
		});
	});
</script>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td class="Heading1">
			
            <div class="Heading1Image"><img src="images/headerimages/export_contacts.jpg" alt="%%LNG_Subscribers_Export_Step4%%" /></div><div class="Heading1Text">%%LNG_Subscribers_Export_Step4%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div>
		</td>
	</tr>
	<tr>
		<td class="body pageinfo">
			<p>
				%%GLOBAL_SubscribersReport%%
				<input id="startExportSubscriber" type="button" value="%%LNG_ExportStart%%" class="FormButton_wide" style="margin-top: 5px;"/>
			</p>
		</td>
	</tr>
</table>
