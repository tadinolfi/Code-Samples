<script>

	function l(Img)
	{
		if(navigator.userAgent.indexOf("MSIE") > -1) {
			xPos = eval(Img).offsetLeft;
			tempEl = eval(Img).offsetParent;

			while(tempEl != null)
			{
				xPos += tempEl.offsetLeft;
				tempEl = tempEl.offsetParent;
			}
		}
		else {
			xPos = Img.x;
		}

		return xPos - 43.25;
	}

	function t(Img)
	{
		if(navigator.userAgent.indexOf("MSIE") > -1) {
			yPos = eval(Img).offsetTop;
			tempEl = eval(Img).offsetParent;

			while(tempEl != null)
			{
				yPos += tempEl.offsetTop;
				tempEl = tempEl.offsetParent;
			}
		}
		else {
			yPos = Img.y;
		}

		return yPos - 35;
	}


</script>

	<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/view_templates.jpg" alt="%%LNG_TemplatesManageBuiltIn%%" /></div><div class="Heading1Text">%%LNG_TemplatesManageBuiltIn%%</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td>
	</tr>
	<tr>
		<td class="body pageinfo"><p>%%LNG_Help_TemplatesManageBuiltIn%%</p></td>
	</tr>
	<tr>
		<td class="body">
			%%TPL_Templates_BuiltIn_Manage_Row%%
		</td>
	</tr>
</table>
