<style type="text/css">
	body {background:#000;}
	.popupBody{background-color:#000;border:none;}
	.popupContainer{background-color:#000;border:none;}
	td{font-family:Trebuchet MS, Tahoma, Arial; font-size:12px;} 
	#loginContainer {width:600px; margin:20% auto;}
</style>
<form action="index.php?Page=%%PAGE%%&Action=%%GLOBAL_SubmitAction%%" method="post" name="frmLogin" id="frmLogin">
	<div id="box" class="loginBox">
		<table><tr><td style="border:solid 1px #333; padding:20px 30px 30px; background-color:#000; width:300px;">
		<table>
			<tr>
			<td class="Heading1">
				<img src="images/logo.jpg" alt="Interspire Logo" />
			</td>
		</tr>
		<tr>
			<td style="padding:10px 0px 5px 0px">%%GLOBAL_Message%%</td>
		</tr>
		<tr>
			<td>
				<table>

				<tr>
					<td nowrap="nowrap" style="padding:0px 10px 0px 10px">%%LNG_UserName%%:</td>
					<td>
					<input type="text" name="ss_username" id="username" class="Field150" value="%%GLOBAL_ss_username%%">
					</td>
				</tr>
					<tr>
					<td>&nbsp;</td>
					<td>
						<input type="submit" name="SubmitButton" value="%%LNG_SendPassword%%" class="FormButton">
					</td>
					</tr>

					<tr><td class="Gap"></td></tr>
				</table>
			</td>
			</tr>
		</table>
		</td></tr>
		</table>

	</div>

	</form>

	<script>

		$('#frmLogin').submit(function() {
				var f = document.frmLogin;
				
				if(f.ss_username.value == '')
				{
					alert('%%LNG_NoUsername%%');
					f.ss_username.focus();
					return false;
				}

				// Everything is OK
				return true;
		});

		function sizeBox() {
			var w = $(window).width();
			var h = $(window).height();
			$('#box').css('position', 'absolute');
			$('#box').css('top', h/2-($('#box').height()/2)-50);
			$('#box').css('left', w/2-($('#box').width()/2));
		}

		$(document).ready(function() {
			sizeBox();
			$('#ss_username').focus();
			$('#ss_username').select();
		});

		$(window).resize(function() {
			//sizeBox();
		});
		createCookie("screenWidth", screen.availWidth, 1);
		
	</script>