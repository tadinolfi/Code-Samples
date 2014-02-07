<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

/* *
 * Permissions:
 *     delete
 *     read
 * */

class Suppression extends SmartMTA_Functions
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
				$user = &GetUser();
				$id = isset($_GET['id']) ? $_GET['id'] : false;
				if($id)
				{
					$api = $this->GetApi();
					$api->Delete($id);
					$this->Message('success', 'The email has been removed from the suppression list.');
				} else
					$this->Message('error', 'There has been an error removing the email. Please try again.');
 				$this->ManageSuppression();
				break;
		    default:
				$this->DisplayPage = $this->GetCurrentPage();
				$this->ManageSuppression();
				break;
		}

		if(!isset($_GET['ajax']))
			$this->PrintFooter();
	}
	
	function ManageSuppression()
	{
		$user = &GetUser();
		$session = &GetSession();
		$suppressionsapi = $this->GetApi();

		$perpage = $this->GetPerPage();
		$start = 0;
		if ($perpage != 'all') {
			$start = ($this->DisplayPage - 1) * $perpage;
		}
		
		$calendar_restrictions = array(); //$session->Get('CalendarRestrictions');
		
		$userid = $user->userid;
		$isMaster = $user->hasRole('Master');
		
		if(isset($_GET['Searching']))
		{
			if(isset($_GET['showall']))
				$session->Set('SuppressionShowAll', true);
			else
				$session->Set('SuppressionShowAll', false);
		}
		$showall = $session->Get('SuppressionShowAll');
		
		if($user->hasRole('ManageMTA'))
			$userid = 0;
		elseif($showall && $isMaster)
		{
			$userid = array();
			$users = $user->GetSubUsers(true);
			foreach($users as $oneuser)
				$userid[] = $oneuser['id'];
		}
		
		$supp_count = $suppressionsapi->GetSuppressions($userid, $calendar_restrictions, true, $start, $perpage, array(), $this->SearchFilter);
		
		$this->SetupPaging($supp_count, $this->DisplayPage, $perpage, '&SearchFilter='.$this->SearchFilter);
		
		$sortinfo = $this->GetSortDetails();
		
		$supps = $suppressionsapi->GetSuppressions($userid, $calendar_restrictions, false, $start, $perpage, $sortinfo, $this->SearchFilter);
		if($supps)
		{
			foreach($supps as $key=>$supp)
				$supps[$key]['suppresstime'] = $this->ConvertDate($supp['suppresstime'], true, $user->timezone);
		}

		$this->tpl->Assign('SuppList', $supps);
		$this->tpl->Assign('ShowAllResults', $showall ? true : false);
		$this->tpl->Assign('isAdmin', ($userid == 0));
		$this->tpl->Assign('isMaster', !($userid == 0) && $isMaster);
		$this->tpl->Assign('deleteText', 'Remove this email address from the suppression list? By doing this you will be able to send to this email address again. <strong>Please note:</strong> it may take 3-5 minutes before the system is updated with this change.');
		$this->tpl->ParseTemplate('suppression_manage');
	}
}