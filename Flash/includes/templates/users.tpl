<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td class="Heading1">%%LNG_Users%%</td>
	</tr>
	<tr>
		<td class="body pageinfo"><p>%%LNG_Help_Users%%</p></td>
	</tr>
	<tr>
		<td>
			%%GLOBAL_Message%%
		</td>
	</tr>
	<tr>
		<td>
			<div class="UserInfo">
				<img src="images/user.gif" style="margin-top: -3px;" align="left">%%GLOBAL_UserReport%%
			</div>
		</td>
	</tr>
	<tr>
		<td class=body>
			<form name="userform" method="post" action="index.php?Page=Users&Action=Delete" onsubmit="return DeleteSelectedUsers(this);">
			<table border="0" width="100%" style="padding-top:5px">
				<tr>
					<td>
						%%GLOBAL_Users_AddButton%%
						%%GLOBAL_Users_DeleteButton%%
					</td>
					<td align="right" valign="bottom">
						%%TPL_Paging%%
					</td>
				</tr>
			</table>
			<table border=0 cellspacing="0" cellpadding="0" width=100% class="Text">
				<tr class="Heading3">
					<td width="5" nowrap align="center">
						<input type="checkbox" name="toggle" class="UICheckboxToggleSelector" />
					</td>
					<td width="5">&nbsp;</td>
					<td width="30%">
						%%LNG_UserName%%&nbsp;<a href='index.php?Page=%%PAGE%%&SortBy=UserName&Direction=Up&%%GLOBAL_SearchDetails%%'><img src="images/sortup.gif" border=0></a>&nbsp;<a href='index.php?Page=%%PAGE%%&SortBy=UserName&Direction=Down&%%GLOBAL_SearchDetails%%'><img src="images/sortdown.gif" border=0></a>
					</td>
					<td width="30%">
						%%LNG_CompanyName%%&nbsp;<a href='index.php?Page=%%PAGE%%&SortBy=Name&Direction=Up&%%GLOBAL_SearchDetails%%'><img src="images/sortup.gif" border=0></a>&nbsp;<a href='index.php?Page=%%PAGE%%&SortBy=Name&Direction=Down&%%GLOBAL_SearchDetails%%'><img src="images/sortdown.gif" border=0></a>
					</td>
					<td width="20%">
						%%LNG_Status%%
					</td>
					<td width="20%">
						%%LNG_UserType%%
					</td>
					<td width="70">
						%%LNG_Action%%
					</td>
				</tr>
			%%TPL_Users_List_Row%%
			</table>
		%%TPL_Paging_Bottom%%
		</td>
	</tr>
</table>

<script>
	$(function() {
		Application.Ui.CheckboxSelection(	'input.UICheckboxToggleSelector',
											'input.UICheckboxToggleRows');
	});

	function DeleteSelectedUsers(formObj) {
		users_found = 0;
		for (var i=0;i < formObj.length;i++)
		{
			fldObj = formObj.elements[i];
			if (fldObj.type == 'checkbox')
			{
				if (fldObj.checked) {
					users_found++;
					break;
				}
			}
		}

		if (users_found <= 0) {
			alert("%%LNG_ChooseUsersToDelete%%");
			return false;
		}

		if (confirm("%%LNG_ConfirmRemoveUsers%%")) {
			return true;
		}
		return false;
	}

	function ConfirmDelete(UserID) {
		if (!UserID) {
			return false;
		}
		if (confirm("%%LNG_DeleteUserPrompt%%")) {
			document.location='index.php?Page=%%PAGE%%&Action=Delete&id=' + UserID;
			return true;
		}
	}

</script>
