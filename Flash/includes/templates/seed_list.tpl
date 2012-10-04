
<script type="text/javascript" language="javascript">
	function changeUser(selectuserinput)
	{
		var userid = selectuserinput.value;
		var currentLocation = window.location + '';
		var concatChar =  '?';
		if(currentLocation.indexOf('?') > 0){
			concatChar = '&';
		}
		window.open(window.location + concatChar + 'userid='+userid, '_self');
	}
</script>

<table cellspacing="0" cellpadding="3" width="95%" align="center">
	<tr>
    	<td class="Heading1">Seedlist for %%GLOBAL_UserAccount%%</td>
    </tr>
    <tr>
    	<td class="Intro">
        	%%GLOBAL_SeedlistType%%
        </td>
    </tr>
    <tr style="display: %%GLOBAL_ShowUserSelector%%;">
    	<td class="Intro">
        	<label for="selectuser">Filter by User</label>
            <select name="selectuser" onchange="changeUser(this);">
            	%%GLOBAL_UserList%%
            </select>
        </td>
    </tr>
    <tr>
    	<td>%%GLOBAL_CreateSeedButton%%</td>
    </tr>	
    <tr>
        <table width="95%" align="center" class="Text">
            <thead>
                <tr class="Heading3" style="height:25px">
                    <td>Email</td>
                    <td>Created on</td>
                    <td>Actions</td>
                </tr>
            </thead>
            <tbody>
            %%TPL_SeedRow%%
            </tbody>
        </table>
    </tr>
</table>