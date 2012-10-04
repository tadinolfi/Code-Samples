<style type="text/css">
				body {background:#fff;padding:0;margin:0;}
				td{font-family:Trebuchet MS, Tahoma, Arial; font-size:12px;} 
				a:link, a:visited {font-size:11px; font-family: Tahoma, Arial; color:#00f; text-decoration:underline;}
				a:hover, a:active {text-decoration:none;}
				#loginContainer {width:520px; margin:20% auto;background:#000;}
				#loginBox {height:175px; padding-top:25px; border:5px solid #C8DCE6; margin-bottom:10px;}
				#needAccount, #haveAccount, #compatibility {font-family: Tahoma, Arial; font-size:11px; color:Black; text-align:right;}
				.login_txt {color:#A1B7CE; }
</style>
<div id="loginContainer">
	<p class="message">%%GLOBAL_Message%%</p>
    <div id="loginBox"> 
		<form action="index.php?Page=%%PAGE%%&Action=%%GLOBAL_SubmitAction%%" method="post" name="frmLogin" onSubmit="return CheckLogin()">
            <table cellpadding="2" cellspacing="1" border="0" width="95%" style="margin-left:10px">    
                <tr valign="top">
                    <td align="left" rowspan="4"><img src="images/logo.jpg" border="0" /></td>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                	<td align="right" class="login_txt">%%LNG_UserName%%:</td>
                    <td>
                        <input type="text" id="ss_username" name="ss_username" class="Field150" value="%%GLOBAL_ss_username%%">             
                    </td>
                </tr>
                <tr>
                    <td align="right" class="login_txt">%%LNG_Password%%:</td>
                    <td>
                        <input type="password" id="ss_password" name="ss_password" class="Field150" value="">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right" style="padding-right:12px;">
                        <label for="rememberme" style="color:#A1B7CE;">%%LNG_RememberMe%%</label><input type="checkbox" name="rememberme" value="1" id="rememberme">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="right" style="padding-right:12px"><input type="submit" name="Login" value="%%LNG_Login%%" class="FormButton"></td>
                </tr>
            </table> 
		</form>
	</div>
    <div id="needAccount">
    	Looking for a simple, yet powerful email marketing solution?<br />
     	<a href="http://www.sendlabs.com/FreeTrial">Get your own account</a> | <a href="index.php?Action=forgotpass">Forgot Password?</a>
    </div>
    
    <div id ="compatibility">
    	<p style="color:#9DC0D2">Sendlabs is optimized for use in Internet Explorer 7.0 and above as well as Firefox 2.0 and up and at a screen resolution of at least 1024x768.</p>
    </div>
</div>
<script language=JavaScript>

	var f = document.frmLogin;
	f.ss_username.focus();
	if (f.ss_username.value != '') {
		f.ss_password.focus();
	}

	function CheckLogin()
	{
		if(f.ss_username.value == '')
		{
			alert('%%LNG_NoUsername%%');
			f.ss_username.focus();
			f.ss_username.select();
			return false;
		}
		
		if(f.ss_password.value == '')
		{
			alert('%%LNG_NoPassword%%');
			f.ss_password.focus();
			f.ss_password.select();
			return false;
		}
		
		// Everything is OK
		return true;
	}

	// Needed to resize editor for 800x600
	//createCookie("screenWidth", screen.availWidth, 1);

</script>
</body>
</html>