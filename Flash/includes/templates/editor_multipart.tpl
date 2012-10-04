<script>
	function ImportCheck(importtype) {
		if (importtype.toLowerCase() == 'html') {
			var checker = document.getElementById('newsletterurl');
		} else {
			var checker = document.getElementById('textnewsletterurl');
		}

		if (checker.value.length <= 7) {
			alert('%%LNG_Editor_ChooseWebsiteToImport%%');
			checker.focus();
			return false;
		}
		return true;
	}

	$(function() { if($('#myDevEditControl_html').is('textarea')) UsingWYSIWYG = false; });
</script>
	<tr>
		<td colspan="2">
			<table id="tabContents_HTMLEditor" width="100%">
				<tr>
					<td valign="top" width="150" class="FieldLabel">
						{template="Required"}
						%%LNG_HTMLContent%%:<br />
                        <br />
                        <a href="http://www.sendlabs.com/cheatSheet.html" target="_blank">Merge Tag Cheat Sheet</a>
					</td>
					<td valign="top">
						<table width="%%GLOBAL_EditorWidth%%" border="0" class="WISIWYG_Editor_Choices">
							<tr>
								<td width="20">
									<input onClick="switchContentSource('html', 1)" id="hct1" name="hct" type="radio" checked>
								</td>
								<td>
									<label for="hct1">%%LNG_HTML_Using_Editor%%</label>
								</td>
							</tr>
							<tr>
								<td width="20">
									<input onClick="switchContentSource('html', 2)" id="hct2" name="hct" type="radio">
								</td>
								<td>
									<label for="hct2">%%LNG_Editor_Upload_File%%</label>
								</td>
							</tr>
							<tr id="htmlNLFile" style="display:none">
								<td></td>
								<td>
									<img src="images/nodejoin.gif" alt="." align="top" />
									<iframe src="%%GLOBAL_APPLICATION_URL%%/admin/functions/remote.php?DisplayFileUpload&ImportType=HTML" frameborder="0" height="30" width="500" id="newsletterfile"></iframe>
								</td>
							</tr>
							<tr>
								<td width="20">
									<input onClick="switchContentSource('html', 3)" id="hct3" name="hct" type="radio">
								</td>
								<td>
									<label for="hct3">%%LNG_Editor_Import_Website%%</label>
								</td>
							</tr>
							<tr id="htmlNLImport" style="display:none">
								<td></td>
								<td>
									<img src="images/nodejoin.gif" alt="." />
									<input type="text" name="newsletterurl" id="newsletterurl" value="http://" class="Field" style="width:200px">
									<input class="FormButton" type="button" name="upload" value="%%LNG_ImportWebsite%%" onclick="ImportWebsite(this, '%%LNG_Editor_Import_Website_Wait%%', 'html', '%%LNG_Editor_ImportButton%%', '%%LNG_Editor_ProblemImportingWebsite%%')" class="Field" style="width:60px">
								</td>
							</tr>
						</table>
						<div id="htmlEditor" style="padding-top: 5px;">
							%%GLOBAL_HTMLContent%%
						</div>
					</td>
				</tr>
				<tr id="htmlCF">
					<td>&nbsp;
						
					</td>
					<td>
						<input type="button" onclick="javascript: ShowCustomFields('html', 'myDevEditControl', '%%PAGE%%'); return false;" value="%%LNG_ShowCustomFields%%..." class="FormButton_wide" style="width: 150px;" />
						<input type="button" onclick="javascript: InsertUnsubscribeLink('html'); return false;" value="%%LNG_InsertUnsubscribeLink%%" class="FormButton_wide" style="width: 150px;" />
					</td>
				</tr>
			</table>
			<table id="tabContents_TextEditor" width="100%">
				<tr>
					<td valign="top" width="150" class="FieldLabel">
						{template="Required"}
						%%LNG_TextContent%%:
					</td>
					<td valign="top">
						<table width="100%" border="0" class="WISIWYG_Editor_Choices">
							<tr>
								<td width="20">
									<input onClick="switchContentSource('text', 1)" id="tct1" name="tct" type="radio" checked>
								</td>
								<td>
									<label for="tct1">%%LNG_Text_Type%%</label>
								</td>
							</tr>
							<tr>
								<td width="20">
									<input onClick="switchContentSource('text', 2)" id="tct2" name="tct" type="radio">
								</td>
								<td>
									<label for="tct2">%%LNG_Editor_Upload_File%%</label>
								</td>
							</tr>
							<tr id="textNLFile" style="display:none">
								<td></td>
								<td>
									<img src="images/nodejoin.gif" alt="." align="top" />
									<iframe src="%%GLOBAL_APPLICATION_URL%%/admin/functions/remote.php?DisplayFileUpload&ImportType=Text" frameborder="0" height="30" width="500" id="newsletterfile"></iframe>
								</td>
							</tr>
							<tr>
								<td width="20">
									<input onClick="switchContentSource('text', 3)" id="tct3" name="tct" type="radio">
								</td>
								<td>
									<label for="tct3">%%LNG_Editor_Import_Website%%</label>
								</td>
							</tr>
							<tr id="textNLImport" style="display:none">
								<td></td>
								<td>
									<img src="images/nodejoin.gif" alt="." />
									<input type="text" name="textnewsletterurl" id="textnewsletterurl" value="http://" class="Field" style="width:200px">
									<input class="FormButton" type="button" name="upload" value="%%LNG_ImportWebsite%%" onclick="ImportWebsite(this, '%%LNG_Editor_Import_Website_Wait%%', 'text');" class="Field" style="width:60px">
								</td>
							</tr>
						</table>
						<div id="textEditor" style="padding-top: 5px;">
							<textarea name="TextContent" id="TextContent" rows="10" cols="60" class="ContentsTextEditor">%%GLOBAL_TextContent%%</textarea>
							<div class="aside">%%LNG_TextWidthLimit_Explaination%%</div>
						</div>
					</td>
				</tr>
				<tr id="textCF">
					<td>&nbsp;
						
					</td>
					<td>
						<input type="button" onclick="javascript: ShowCustomFields('TextContent', null, '%%PAGE%%'); return false;" value="%%LNG_ShowCustomFields%%..." class="FormButton_wide" style="width: 150px;" />
						<input type="button" onclick="javascript: InsertUnsubscribeLink('TextContent'); return false;" value="%%LNG_InsertUnsubscribeLink%%" class="FormButton_wide" style="width: 150px;" />
						<input class="FormButton_wider" type="button" name="" value="%%LNG_GetTextContent%%" style="width:170px" onClick="grabTextContent('TextContent','myDevEditControl');"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>