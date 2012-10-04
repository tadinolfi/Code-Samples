<script language="javascript" type="text/javascript">

	function ValidatePackage(thisform) {
		// place any other field validations that you require here
		// validate myradiobuttons
		myOption = -1;
		for (i=thisform.packageid.length-1; i > -1; i--) {
			if (thisform.packageid[i].checked) {
				myOption = i; i = -1;
			}
		}
		if (myOption == -1) {
			alert("You must select an amount");
			return false;
		}
	}
	
	function clearRadio(type)
	{
		switch(type)
		{
			case 'renders':
				$("input[@name='renders']").each(function() {
				this.checked = false;
				});
			break;
			case 'credits':
				$("input[@name='credits']").each(function() {
				this.checked = false;
				});
			break;
		}
	}
			
</script>

<style type="text/css">

.subheading
{
	font-size:20px;
	color:#008AE0;
	font-family:Georgia, Tahoma, San-Serif;
}
</style>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
    	<td class="Heading1"><div class="Heading1Image"><img src="images/headerimages/purchase_credits.jpg" alt="Purchase Credits" /></div><div class="Heading1Text">Purchase Credits</div><div class="Heading1Links"> <a href="#"><img src="images/help2.gif" alt="Help" border="0" /></a><a href="#"><img src="images/bulb.jpg" alt="Tip" border="0" /></a></div></td>
    </tr>
    <tr><td class="body pageinfo"><p>Choose the amount of credits you would like to add to your account below.</p></td></tr>
    <tr>
        <td class="fakeTabs">
            <ul id="tabnav">
                <li><a href="index.php?Page=ManageAccount" id="tab1">My Account</a></li>
                <li><a href="index.php?Page=Credits&Action=purchase" class="active" id="tab2">Purchase Credits and/or Render Tests</a></li>
                <li><a href="index.php?Page=Credits" id="tab3">Credit History</a></li>
            </ul>
        </td>
    </tr>
    <tr>
    	<td class="subheading">Step 1: Select Credit Amount</td>
    </tr>
	<form action="index.php?Page=Credits&Action=purchase&Subaction=step2" method="post" enctype="application/x-www-form-urlencoded" onSubmit="return ValidatePackage(this);">
    <tr>
    	<td>
        <table class="text" width="100%" align="left" border="0">
        <tr>
        	<td width="40%">
        		<table class="text" width="100%" align="left" cellpadding="0" cellspacing="0">
		            <thead>
		            	<tr>
		            		<td colspan="3" class="Heading1">Email Credits</td>
		            	</tr>
		                <tr class="Heading3" style="height:30px">
		                    <td width="10"><a href="javascript:clearRadio('credits')">Clear</a></td>
		                    <td>Credits</td>
		                    <td>Price</td>
		                </tr>
		            </thead>
		            <tbody>
		            %%TPL_CreditsPackage_Row%%
		            </tbody>
        		</table>
        	</td>
        	<td width="100">&nbsp;</td>
        	<td align="left" valign="top" width="400">
        		<table class="text" width="100%" align="left" cellpadding="0" cellspacing="0">
		            <thead>
		            	<tr>
		            		<td colspan="3" class="Heading1">Rendering Test Tokens</td>
		            	</tr>
		                <tr class="Heading3" style="height:30px">
		                    <td width="10"><a href="javascript:clearRadio('renders')">Clear</a></td>
		                    <td>Reports</td>
		                    <td>Price</td>
		                </tr>
		            </thead>
		            <tbody>
		            %%TPL_RenderPackage_Row%%
		            </tbody>
        		</table>
        	</td>
        	<td align="left" valign="middle" width="300">
        		<table cellspacing="0" cellpadding="0" border="0" width="300" style="padding:5px 0 0 25px;">
	        		<tr>
	        			<td class="subheading" style="font-size:16px;font-weight:bold;font-family: Georgia, Tahoma, Sans-Serif;">How Sendlabs Credits Work</td>
	        		</tr>
	        		<tr>
	        			<td style="color:#333333;font-size:11px;padding-top:0">You simply pre-pay for "email credits" then we deduct one credit from your account for each recipient you send to. There are no monthly fees. You only buy email credits when you need them. Credits "roll over" and they never expire.</td>
	        		</tr>
	        	</table> 
	        </td>
   		</tr>
   		<tr>
   			<td colspan="4" style="padding:10px 0 10px 0;">&nbsp;</td>
   		</tr>
   		<tr>
   			<td colspan="4" align="center">
   				<table cellspacing="0" cellpadding="0" border="0" width="300">
   					<tr>
		                <td colspan="3" style="padding:5px;">
		                    <input type="submit" class="FormButton FormButton_wide" value="Continue to Step 2" />
                            <input type="button" onclick='if(confirm("Are you sure you want to cancel purchasing credits?")) { document.location="index.php?Page=Credits" }' value="Cancel" class="FormButton"/>
		                </td>
		            </tr>
		         </table>
		     </td>
		</tr>
   		</table>     		
        </td>
    </tr>
    </form>
</table>
