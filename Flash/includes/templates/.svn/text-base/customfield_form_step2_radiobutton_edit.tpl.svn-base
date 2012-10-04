	%%GLOBAL_CurrentList%%

	%%GLOBAL_ExtraList%%

	<script>
		var CurrentSize = '%%GLOBAL_CurrentSize%%';

		function AddOption() {
			var table = document.getElementById('customFieldsTable');
			var lastRow = table.rows.length;
			var row = table.insertRow(lastRow - 2);
			var cell = row.insertCell(0);

			var row2 = table.insertRow(lastRow - 1);
			var cell2 = row2.insertCell(0);
			var cell3 = row2.insertCell(1);

			var row3 = table.insertRow(lastRow);
			var cell4 = row3.insertCell(0);
			var cell5 = row3.insertCell(1);

			CurrentSize++;

			cell.colspan = "2"
			cell.className = "FieldLabel";

			cell2.width= "200";
			cell2.className = "FieldLabel";

			cell4.width= "200";
			cell4.className = "FieldLabel";

			cell.innerHTML = '&nbsp;&nbsp;<b>%%LNG_Checkbox%% ' + CurrentSize + '</b>';
			cell.style.display = 'none';

			cell2.innerHTML = '&nbsp;&nbsp;{template="Not_Required"}\n%%LNG_Checkbox%% ' + CurrentSize + ' ' + ' %%LNG_Value%%:';
			cell3.innerHTML = '<input type="text" name="Value[' + CurrentSize + ']" class="Field250" id="value_' + CurrentSize + '">';

			cell4.innerHTML = '&nbsp;&nbsp;{template="Not_Required"}\n%%LNG_Value%%&nbsp;:&nbsp;';
			cell5.innerHTML = '<input type=hidden name=Key[' + CurrentSize + '] class=Field250 id="key_' + CurrentSize + '">&nbsp;';

			cell4.style.display = 'none';
			cell5.style.display = 'none';
		}

	</script>

	<tr id="additionalOption">
		<td>&nbsp;</td>
		<td><a href="javascript:AddOption()"><img src="images/plus.gif" border="0" style="margin-right: 5px"></a><a href="javascript:AddOption()">%%LNG_AddMore%%</a></td>
	</tr>