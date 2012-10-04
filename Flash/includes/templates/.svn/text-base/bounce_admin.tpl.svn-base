
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
    	<td class="Heading1">Bounce Admin for %%GLOBAL_UserAccount%%</td>
    </tr>
    <tr>
    	<td class="Intro">
        	This is a listing of bounces with the status message.
        </td>
        
    </tr>
    
    <tr>
    	<td>&nbsp;</td>
    	<td align="right" valign="bottom">
			%%TPL_Paging%%
		</td>
	</tr>
   
</table>
<table cellspacing="0" cellpadding="3" width="95%" align="center"> 
    <tr>
        	<td class="fakeTabs">
            	<ul id="tabnav">
                    <li><a href="index.php?Page=Bounceadmin" class="active" id="tab1">Bounce Admin</a></li>
                    <li><a href="index.php?Page=Bounceadmin&Action=ShowSpamComplaints" id="tab2">SPAM Complaints</a></li>
				</ul>
			</td>
    </tr>
</table>
<table cellspacing="0" cellpadding="3" width="95%" align="center">

    <tr style="display: %%GLOBAL_ShowUserSelector%%;">
    	<td class="Intro" style="padding:5px 0 15px 0">
        	<label for="selectuser">Filter by User</label>
            <select name="selectuser" onchange="changeUser(this);">
            	%%GLOBAL_UserList%%
            </select>
        </td>
    </tr>
     	
    <tr>
        <table class="text" width="95%" align="center">
            <thead>
                <tr class="Heading3">
                    <td>Company / User</td>
                    <td>Email</td>
                    <td>Date &amp; Time Bounced</td>
                    <td>Status Message</td>
                </tr>
            </thead>
            <tbody>
            %%TPL_Bounce_Admin_Row%%
            </tbody>
        </table>
    </tr>
    <tr>
    	<td>
    	%%TPL_Paging_Bottom%%
    	</td>
    </tr>
</table>