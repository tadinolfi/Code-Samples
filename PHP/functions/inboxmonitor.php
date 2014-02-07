<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

/* *
 * Permissions:
 *     delete
 *     read
 *     add
 *     activate
 *     deactivate
 * */

class Inboxmonitor extends SmartMTA_Functions
{
	private $SearchFilter = '';
	private $DisplayPage = 1;

	function Process()
	{
		// Retrieve request-related data that any action will likely require
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		$this->SearchFilter = isset($_GET['SearchFilter']) ? strtolower($_GET['SearchFilter']) : '';

		if(!isset($_GET['ajax']))
			$this->PrintHeader();

		switch($action)
		{
			case 'delete':
				$id = isset($_GET['id']) ? $_GET['id'] : false;
				if($id)
				{
					$api = $this->GetApi();
					$api->DeleteInbox($id);
					$this->Message('success', 'The inbox has been removed from the seed list.');
				} else
					$this->Message('error', 'There has been an error removing the inbox. Please try again.');
 				$this->Redirect();
				break;
			case 'create':
				//TODO: Refactor to validate input fields. this was quick and dirty
				$api = $this->GetApi();
				$worked = $api->CreateInbox($_POST['emailaddress'],$_POST['username'],$_POST['password'],$_POST['host'],1,0);
				if($worked)
					$this->Message('success', 'The inbox has been added to the seed list.');
				else
					$this->Message('error', 'There has been an error adding the inbox. Please try again.');
				$this->Redirect();
				break;
			case 'activate':
				$id = isset($_GET['id']) ? $_GET['id'] : false;
				if($id)
				{
					$api = $this->GetApi();
					$api->UpdateInboxStatus($id,1);
				}
				$this->Redirect();
				break;
			case 'deactivate':
				$id = isset($_GET['id']) ? $_GET['id'] : false;
				if($id)
				{
					$api = $this->GetApi();
					$api->UpdateInboxStatus($id,0);
				}
				$this->Redirect();
				break;
			case 'setup':
				$id = isset($_GET['id']) ? $_GET['id'] : false;
				if($id)
				{
					$inbox = $this->GetApi();
					if($inbox->Load($id))
					{ //we loaded the inbox
						if($inbox->Login()) 
						{
							if($inbox->Setup()) 
								$this->Message('success', 'Inbox setup.');
							else
								$this->Message('error', 'Inbox setup failed.');
							$inbox->Logout(true); //we gotta log out if we logged in.
						} else //we didn't login
							$this->Message('error', 'Could not login to inbox.');
					} else //we didnt load
						$this->Message('error', 'Could not load inbox details. Invalid ID passed');
				} else
					$this->Message('error', 'No inbox ID provided.');
				$this->Redirect();
				break;
		    default:
				$this->DisplayPage = $this->GetCurrentPage();
				$this->ManageInboxes();
				break;
		}

		if(!isset($_GET['ajax']))
			$this->PrintFooter();
	}
	
	function ManageInboxes()
	{
		//TODO: Refactor this function to sue the full search/paging features. this was a quick and dirty job so we could have this festure now.
		$user = &GetUser();
		$session = &GetSession();
		$api = $this->GetApi();
		
		$boxes = $api->GetInboxMonitorSeedlist(false);

		$this->tpl->Assign('BoxList', $boxes);
		$this->tpl->Assign('deleteText', 'Remove this inbox.');
		$this->tpl->ParseTemplate('inboxmonitor_manage');
	}
}