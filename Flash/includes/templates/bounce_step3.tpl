<script>
	$(function() {
		$('#cmdStartProcess').click(function() {
			//window.open("index.php?Page=Bounce&Action=Bounce","sendWin","left=" + left + ",top="+top+",toolbar=false,status=no,directories=false,menubar=false,scrollbars=false,resizable=false,copyhistory=false,width=360,height=200");
			tb_show('', 'index.php?Page=Bounce&Action=BounceDisplay&keepThis=true&TB_iframe=tue&height=320&width=450&modal=true', '');
		});
	});

	function closePopup() {
		tb_remove();
	}
</script>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td class="Heading1">
			%%LNG_Bounce_Step3%%
		</td>
	</tr>
	<tr>
		<td class="body pageinfo">
			<p>
				%%LNG_Bounce_Step3_Intro%%
			</p>
		</td>
	</tr>
	<tr>
		<td>
			%%GLOBAL_Message%%
			<input type="button" id="cmdStartProcess" value="%%LNG_StartProcessing%%" class="SmallButton" style="margin-top:5px;"/>
		</td>
	</tr>
</table>