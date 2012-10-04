<script>
	$(function() {
		if(%%GLOBAL_DisplayCreateButton%%)
			$('#sectionCreateButton').show();
	});
</script>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr><td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/view_segments.jpg" alt="%%LNG_SegmentManage%%" /></div><div class="Heading1Text">%%LNG_SegmentManage%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td></tr>
	<tr><td class="Intro">%%LNG_Help_SegmentManage%%</td></tr>
	<tr><td class="body">%%GLOBAL_Message%%</td></tr>
	<tr id="sectionCreateButton" style="display:none;">
		<td class="body">
			<form name="frmCommands" action="index.php" method="get">
				<input type="hidden" name="Page" value="Segment" />
				<input type="hidden" name="Action" value="Create" />
				<input type="submit" value="%%LNG_SegmentManageCreateNew%%" title="%%LNG_SegmentManageCreateNew_Title%%" class="SmallButton" />
			</form>
		</td>
	</tr>
</table>

