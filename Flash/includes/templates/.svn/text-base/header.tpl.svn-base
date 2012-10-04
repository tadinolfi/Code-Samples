<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>%%GLOBAL_ApplicationTitle%%</title>
<link rel="shortcut icon" href="images/favicon.ico" type="image/vnd.microsoft.icon">
<link rel="icon" href="images/favicon.ico" type="image/vnd.microsoft.icon">
<meta http-equiv="Content-Type" content="text/html; charset=%%GLOBAL_CHARSET%%">
<link rel="stylesheet" href="includes/styles/stylesheet.css" type="text/css">
<link rel="stylesheet" href="includes/styles/tabmenu.css" type="text/css">
<link rel="stylesheet" href="includes/styles/thickbox.css" type="text/css">

<!--[if IE]>
<link rel="stylesheet" href="includes/styles/ie.css" type="text/css">
<![endif]-->

<script src="includes/js/jquery.js"></script>
<script src="includes/js/jquery/thickbox.js"></script>
<script src="includes/js/javascript.js"></script>
<script>
	var UnsubLinkPlaceholder = "%%LNG_UnsubLinkPlaceholder%%";
	var UsingWYSIWYG = '%%GLOBAL_UsingWYSIWYG%%';
	var Searchbox_Type_Prompt = "%%LNG_Searchbox_Type_Prompt%%";
	var Searchbox_List_Info = '%%GLOBAL_Searchbox_List_Info%%';
	var Application_Title = '%%LNG_ApplicationTitle%%';
	
	
	function setClient(clientSelect)
	{
		var clientId = clientSelect.value;
		var currentLocation = window.location + '';
		var concatChar =  '?';
		if(currentLocation.indexOf('?') > 0){
			concatChar = '&';
		}
		window.open(window.location + concatChar + 'clientid='+clientId, '_self');
	}

	Application.Misc.specifyDocumentMinWidth(1000);
	Application.Misc.setPingServer('ping.php', 120000);
</script>
</head>

<body>
<div class="Header">
	<div class="Header_Top"></div>

	<div class="logo">
		<a href="index.php"><img id="logo" src="images/logo.jpg" alt="logo" border="0" /></a>
	</div>
	
	<div class="clientSelect" style="display: %%GLOBAL_ShowClientList%%">
    	<strong>Select Client</strong>
        <select %%GLOBAL_DisableClientList%% name="clientSelect" onChange="setClient(this);">
        <option>Please select a client to work with</option>
         %%GLOBAL_ClientList%%
        </select>
    </div>

	<div class="textlinks" align="right">
		<div class="MenuText">
			%%GLOBAL_TextLinks%%
			<div class="loggedinas">
				%%GLOBAL_UserLoggedInAs%%
			</div>
			<span class="emailcredits">%%GLOBAL_MonthlyEmailCredits%%</span>
			<span class="emailcredits">%%GLOBAL_TotalEmailCredits%%</span>
		</div>
	</div>
	
	
	

	<div class="Header_Bottom"></div>
	
	<div class="menuBar">
		<div style="height:0px;">&nbsp;</div>
		<div>%%GLOBAL_MenuLinks%%</div>
	</div>
		
</div>



<div class="ContentContainer">
	<div class="BodyContainer">
		{if $ShowTestModeWarning}
			<div style="display: " class="TestModeEnabled"><div style="valign: top"><img src="images/critical.gif"  align="left" hspace="5">{$SendTestWarningMessage}</div></div>
		{/if}

%%GLOBAL_BodyAddons%%