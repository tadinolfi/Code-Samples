<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

class Integration extends SmartMTA_Functions
{
	
	public function Process()
	{
		
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		
		if($action != 'generateapikey')
		{
			$this->PrintHeader();
		}
		
		switch($action)
		{
			case 'generateapikey':
				echo md5('smtplabs123' . rand(0,1000));
			break;
			
			case 'update':
				$this->UpdateIntegration();
			break;
			default:
				$this->ManageIntegration();
			break;
		}
		
		if($action != 'generateapikey')
		{
			$this->PrintFooter();
		}
	}
	
	
	public function ManageIntegration($error=false)
	{
		$user = &GetUser();
		
		$this->tpl->Assign('BounceURL', $user->bounceurl);
		$this->tpl->Assign('SpamURL', $user->spamurl);
		$this->tpl->Assign('ApiKey', $user->apikey);
		$xheader_template = '';
		
		$xheaders = $user->GetUserXheaders();
		$dispxheaders = array();
		for($i=1; $i <= 4; $i++)
		{
			$dispxheader = array('count' => $i);

			if(!$error)
			    $dispxheader['value'] = (isset($xheaders[$i-1]) ? $xheaders[$i-1] : '');
			else
			{
			    // Read existing form values since we have a validation error
			    $dispxheader['value'] = $_POST['xheader'][$i];
			}

			$dispxheaders[] = $dispxheader;
		}
				
		$this->tpl->Assign('Xheaders', $dispxheaders);
		$this->tpl->ParseTemplate('integration');
	}
	
	public function UpdateIntegration()
	{
		$user = &GetUser();
		$bounceurl = isset($_POST['bounceurl']) ? $_POST['bounceurl'] : '';
		$spamurl = isset($_POST['spamurl']) ? $_POST['spamurl'] : '';
		$apikey = isset($_POST['apikey']) ? $_POST['apikey'] : '';
		$xheaders = isset($_POST['xheader']) ? $_POST['xheader'] : array();
		
		$xheader_error = false;
		$ct = 0;
		foreach($xheaders as $key => $xheader)
		{
			// strip out any colons if they are included.
			$xheaders[$key] = str_replace(':', '', $xheaders[$key]);
			
			if($ct > 3)
			{
				$this->Message('error', 'SmartMTA currently supports up to four custom X-Headers.');
				$xheader_error = true;
				break;
			}
				
			if($xheader != '' && substr($xheader, 0, 2) !== 'X-')
			{
				$xheader_error = true;
				$this->Message('error', 'Each X-Header must start with "X-"; for example, X-UserData1</span><br />');
			}
			$ct++;
		}
			
		$user->Set('bounceurl', $bounceurl);
		$user->Set('spamurl', $spamurl);
		$user->Set('apikey', $apikey);
		
		
		$result = $user->Save();
		
		if(!$result)
		{
			$this->Message('error', 'Unable to update integration settings. Please try again in a few minutes.');
		}
		
		if($xheader_error)
		{
			return $this->ManageIntegration(true);
		}
		
		$user->Set('xheaders', $xheaders);
		$user->SaveUserXheaders();

		$this->Message('success', 'Update successful.');
		
		$this->ManageIntegration();
	}	
	
	
	
}