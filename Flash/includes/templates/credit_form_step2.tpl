<script language="javascript" type="text/javascript">

	function checkCCNum(formfield, messageElement)
	{
		var ccn = formfield.value;
		while(ccn.indexOf('-') > -1)
		{
			ccn = ccn.replace(/-/,'');
		}
		formfield.value = ccn;
		
		var ccndigits = ccn.split('');
		var checksum = 0;
		var offset = 0;
		if(ccn.length % 2 != 0)
			offset = 1;
		for(var i = 0; i < ccn.length; i++)
		{
			var thisdigit = parseInt(ccndigits[i]);
			if((i+offset) % 2 == 0)
			{
				var doubled = thisdigit * 2;
				if(doubled >= 10)
				{
					checksum = checksum + 1;
					checksum = checksum + (doubled - 10);
				}else{
					checksum = checksum + doubled;
				}
			}else{
				checksum = checksum + thisdigit;
			}
		}
		infobox = document.getElementById(messageElement);
		if(checksum % 10 != 0)
		{
			infobox.innerHTML = "Invalid credit card number";
			return false; 
		}
		if(ccn.length == 16 && ccn.indexOf('5') == 0)
		{
			infobox.innerHTML = "Valid Mastercard Number";
			return true;
		}
		
		if((ccn.length == 16 || ccn.length == 13 ) && ccn.indexOf('4') == 0)
		{
			infobox.innerHTML = "Valid Visa Number";
			return true;
		}
		
		if(ccn.length == 15 && ccn.indexOf('3') == 0)
		{
			infobox.innerHTML = "Valid Amex Number";
			return true;
		}
		
		if(ccn.length == 16 && ccn.indexOf('6011') == 0)
		{
			infobox.innerHTML = "Valid Discover Number";
			return true;
		}
		
		infobox.innerHTML = "Invalid credit card number";
		return false;
	}
	
	function validateForm(theForm)
	{
		if(theForm.fname.value == '')
		{
			alert("Please enter a first name.");
			theForm.fname.focus();
			return false;
		}
		if(theForm.lname.value == '')
		{
			alert("Please enter a last name.");
			theForm.lname.focus();
			return false;
		}
		if(theForm.cvn.value == '')
		{
			alert("Please enter your card's CVN number.");
			theForm.cvn.focus();
			return false;
		}
		if(theForm.address.value == '')
		{
			alert("Please enter an address.");
			theForm.address.focus();
			return false;
		}
		if(theForm.city.value == '')
		{
			alert("Please enter a city.");
			theForm.city.focus();
			return false;
		}
		if(theForm.zip.value == '')
		{
			alert("Please enter a zip code.");
			theForm.zip.focus();
			return false;
		}
		var today = new Date();
		var year = today.getFullYear();
		var selectedYear = parseInt(theForm.expyear.value);
		var month = today.getMonth();
		var selectedMonth = parseInt(theForm.expmonth.value);
		if(selectedYear == year)
		{
			if(selectedMonth < month){
				alert("The expiration date entered has passed");
				return false;
			} 
		}
		
			return true;
	}
	
	function showCvnPanel()
	{
		var Panel = document.getElementById('cvnPanel');
		Panel.style.display = "block";
	}
	
	function hideCvnPanel()
	{
		var Panel = document.getElementById('cvnPanel');
		Panel.style.display = "none";
	}
</script>

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
    	<td class="subheading">Step 2: Enter Payment Information</td>
    </tr>
    

    <tr style="display:%%GLOBAL_ShowMessage%%">
    	<td style="color:c00;">
        	<strong>%%GLOBAL_Message%%</strong>
        </td>
    </tr>
    <tr>
    	<td>
        	<form action="index.php?Page=Credits&Action=processpayment" method="post" enctype="application/x-www-form-urlencoded" onsubmit="return validateForm(this);">
            	<table>
                	<tr>
                    	<td colspan="2">
                    		<table cellspacing="0" cellpadding="0" border="0" class="credits_chosen">
                    			%%TPL_CreditsChosen%%
                    			%%TPL_RenderCreditsChosen%%
                    		</table>
                    	</td>
                       <input type="hidden" name="credits" value="%%GLOBAL_Credits%%" />
                       <input type="hidden" name="price" value="%%GLOBAL_Price%%" />
                    </tr>
				</table>
				
				<table cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
					<table cellspacing="0" cellpadding="0" border="0" style="margin-top:15px">
	                    <tr>
	                    	<td colspan="2" class="Heading3" style="padding-left:10px">
	                        	<strong>Credit Card Information</strong>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<td class="SmallFieldLabel">First Name:</td>
	                        <td><input type="text" name="fname" size="20" /></td>
	                    </tr>
	                    <tr>
	                    	<td class="SmallFieldLabel">Last Name:</td>
	                        <td><input type="text" name="lname" size="20" /></td>
	                    </tr>
	                    <tr>
	                    	<td class="SmallFieldLabel">Card Type:</td>
	                    	<td>
	                    		<select name="cctype" style="width:157px">
	                    			<option value="MasterCard">MasterCard</option>
	                    			<option value="Visa">Visa</option>
	                    			<option value="AMEX">American Express</option>
	                    			<option value="Discover">Discover</option>
	                    		</select>
	                    	</td>
	                    </tr>                     			
	                    <tr>
	                    	<td class="SmallFieldLabel">Card Number:</td>
	                        <td><input type="text" name="ccnum" size="20" /><span style="font-size:70%; color:#999;" id="ccnInfo"></span></td>
	                    </tr>
	                    <tr>
	                    	<td class="SmallFieldLabel">Expiration:</td>
	                        <td>
	                        	<select name="expmonth" style="width:100px">
	                            	<option value="01">01 - January</option>
	                                <option value="02">02 - February</option>
	                                <option value="03">03 - March</option>
	                                <option value="04">04 - April</option>
	                                <option value="05">05 - May</option>
	                                <option value="06">06 - June</option>
	                                <option value="07">07 - July</option>
	                                <option value="08">08 - August</option>
	                                <option value="09">09 - September</option>
	                                <option value="10">10 - October</option>
	                                <option value="11">11 - November</option>
	                                <option value="12">12 - December</option>
	                            </select>
	                            <select name="expyear" style="width:70px">
	                            	%%GLOBAL_YearList%%
	                            </select>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<td class="SmallFieldLabel">CVN Number:</td>
	                        <td>
	                        	<input type="text" name="cvn"  style="width:30px" />
	                            <a href="#" onClick="showCvnPanel();">?</a>
	                            <div id="cvnPanel" style="display:none; width:300px; font-size:70%; height:170px; border:1px solid #999; position:absolute; top:430px; left:310px; background-color:#eee;">
	                            	<table>
	                                <tr>
	                                	<td style="font-size:80%;"><strong>What is a CVN number?</strong></td>
	                                 </tr>
	                                 <tr>
	                                     <td style="font-size:70%;">The CVN number is printed on the signature panel on the back of your credit card.</td>
	                                     </tr><tr>
	                                     <td><img width="280" hspace="10" vspace="5" src="/admin/images/creditcard_CVN2.gif" alt="CVN Location" /></td>
	                                 </tr>
	                                 <tr>
	                                 	<td align="center"><a href="#" onclick="hideCvnPanel();">close</a></td>
	                                 </tr>
	                                 </table>
	                            </div>
	                        </td>
	                    </tr>
                    	</table>
                    	</td>
                    	<td width="60">&nbsp;</td>
                    	<td align="right"><img src="/admin/images/acceptedcards.jpg" border="0" /></td>
                    	</tr>
                    </table>
                    
                    <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    	<td class="SmallFieldLabel">Billing Address:</td>
                        <td>
                        	<table cellpadding="0" cellspacing="0">
                            	<tr>
                                	<td colspan="3">
                                    	<input type="text" width="400" style="width:400px;" name="address">
                                    </td>
                                </tr>
                                <tr>
                                	<td colspan="3">
                                    	<small style="font-size:70%; display:block; padding-bottom:10px;">Street address or PO Box</small>
                                    </td>
                                </tr>
                                <tr>
                                	<td><input type="text" style="width:180px; margin-right:10px;" name="city"></td>
                                    <td><select name="state"  style="width:130px; margin-right:10px;">%%GLOBAL_StateList%%</select></td>
                                    <td><input type="text"  style="width:100px" name="zip"></td>
                                </tr>
                                <tr>
                                	<td><small style="font-size:70%;">City</small></td>
                                    <td><small style="font-size:70%;">State</small></td>
                                    <td><small style="font-size:70%;">Zip</small></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
                    </table>
                    <table cellspacing="0" cellpadding="0" border="0" width="630">
                    <tr>
                    	<td colspan="2" style="padding:10px 10px 10px 0;">
                        	<input type="submit" name="processpayment" class="FormButton FormButton_wide" value="Process Payment" />
                            <input type="button" onclick='if(confirm("Are you sure you want to cancel purchasing credits?")) { document.location="index.php?Page=Credits" }' value="Cancel" class="FormButton"/>
                        </td>
                    </tr>
                </table>
            </form>
        </td>
    </tr>
</table>