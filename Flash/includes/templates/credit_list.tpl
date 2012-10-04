
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

<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
    	<td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/credit_history.jpg" alt="Credit History" /></div><div class="Heading1Text">Credit History</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td>
    </tr>
	<tr><td class="body pageinfo"><p>The purchase (+ ) and sending ( - ) of email credits from your account are shown below.</p></td></tr>
    <tr>
        <td class="fakeTabs">
            <ul id="tabnav">
                <li><a href="index.php?Page=ManageAccount" id="tab1">My Account</a></li>
                <li style="display: %%GLOBAL_ShowCreditPurchaseTab%%"><a href="index.php?Page=Credits&Action=purchase" id="tab2">Purchase Credits</a></li>
                <li><a href="index.php?Page=Credits" class="active" id="tab3">Credit History</a></li>
            </ul>
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
        <table class="text" width="100%" align="center" cellspacing="0" cellpadding="0">
            <thead>
                <tr class="Heading3">
                    <td style="display:none;">Company / User</td>
                    <td style="padding: 4px 8px;">Credits (+/-)</td>
                    <td style="padding: 4px 8px;">Total</td>
                    <td style="padding: 4px 8px;">Date &amp; Time</td>
                    <td style="padding: 4px 8px;">Details</td>
                </tr>
            </thead>
            <tbody>
            %%TPL_Credit_Row%%
            </tbody>
        </table>
    </tr>
</table>