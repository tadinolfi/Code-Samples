<style type="text/css">
				body {background:#000;padding:0;margin:0;text-align:center;font-family: "Lucida Grande","Lucida Sans Unicode",Arial,Verdana,sans-serif !important;}
				.popupBody{background-color:#000;border:none;}
				.popupContainer{background-color:#000;border:none;}
				td{font-family:Trebuchet MS, Tahoma, Arial; font-size:12px;} 
				a:link, a:visited {font-size:11px; font-family: "Lucida Grande","Lucida Sans Unicode",Arial,Verdana,sans-serif; color:#00f; text-decoration:underline;}
				a:hover, a:active {text-decoration:none;}
				#loginContainer {width:600px; margin:20% auto;}
				#loginBox { padding:30px 40px 50px; border:1px solid #333; margin-bottom:10px;background:#000;}
				.message{background-color:#3C8DCE;color:#FFF;}
				#needAccount, #haveAccount, #compatibility {font-family: "Lucida Grande","Lucida Sans Unicode",Arial,Verdana,sans-serif; font-size:11px; color:#666; text-align:center;}
				.login_txt {color:#666; }
				#needAccount a{color:#666;}
				.LoginError{color:#FFF;}
</style>
<div id="loginContainer">
	<p id="LogMessage" class="message">%%GLOBAL_Message%%</p>
    <div id="loginBox"> 
		<form action="index.php?Page=%%PAGE%%&Action=%%GLOBAL_SubmitAction%%" method="post" name="frmLogin" onSubmit="return CheckLogin()">
        <input name="ss_takemeto" type="hidden" value="%%LNG_TakeMeTo_HomePage%%" />
            <table cellpadding="2" cellspacing="1" border="0" width="100%" style="margin-left:10px">    
                <tr valign="top">
                    <td align="left" rowspan="4" style="padding:17px 0 0 0"><img src="images/logo.jpg" border="0" /></td>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                	<td align="right" class="login_txt">%%LNG_UserName%%:</td>
                    <td width="150">
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
                    <td colspan="3" align="right" style="">
                        <label for="rememberme" style="color:#666;">%%LNG_RememberMe%%</label><input type="checkbox" name="rememberme" value="1" id="rememberme">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="right" style=""><input type="submit" name="Login" value="%%LNG_Login%%" class="FormButton"></td>
                </tr>
            </table> 
		</form>
	</div>
    <div id="needAccount">
     	<a href="http://www.sendlabs.com/FreeTrial">Get your own account</a> | <a href="index.php?Action=forgotpass">Forgot Password?</a>
    </div>
    
    <div id ="compatibility">
    	<p>Sendlabs is optimized for use in Internet Explorer 7.0 and above as well as<br/> Firefox 2.0 and up and at a screen resolution of at least 1024x768.</p>
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
	$(document).ready(function(){
		if($('#LogMessage').text() == 'Login with your username and password below.')
		{
			$('#LogMessage').css('display', 'none');
		}
	});

</script>
</body>
</html>