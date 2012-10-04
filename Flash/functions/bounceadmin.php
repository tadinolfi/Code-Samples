<?php

require(dirname(__FILE__) . '/sendstudio_functions.php');

class Bounceadmin extends SendStudio_Functions
{
	
	function Bounceadmin()
	{
		$this->LoadLanguageFile();
	}
	
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower(urldecode($_GET['Action'])) : null;
		$subaction = (isset($_GET['SubAction'])) ? strtolower(urldecode($_GET['SubAction'])) : null;
		$list_type = (isset($_GET['ListType'])) ? $this->seedtype = strtolower(urldecode($_GET['ListType'])) : null;
		$seedid = (isset($_GET['Seed'])) ? strtolower(urldecode($_GET['Seed'])) : null;
		
		$session = &GetSession();
		$user = &GetUser();
		
		if ($action == 'processpaging') {
			$thispage = $this->SetPerPage($_GET['PerPageDisplay']);
			$action = '';
		}
		
		require_once 'api/bounceadmin.php';
		$bounceadmin_api = new Bounceadmin_API();
		//$seedapi = $this->GetApi('Seedlist');
		
		
		
		$this->PrintHeader();
		switch($action)
		{
			case 'showspamcomplaints':
				$this->DisplaySpamComplaints();
			break;
			default:
				$this->DisplayBounceAdmin();
			break;
		}
	}
	
	/**
	 * DisplaySpamComplaints
	 * Show the latest spam complaints
	 * 
	 * @return Void Prints out the form does not return anything
	 */
	
	function DisplaySpamComplaints()
	{
		$session = &GetSession();
		$user = &GetUser();			
		$perpage = $this->GetPerPage();
		$DisplayPage = $this->GetCurrentPage();
		$sortinfo = $this->GetSortDetails();
		$start = 0;
		if ($perpage != 'all') {
			$start = ($DisplayPage - 1) * $perpage;
		}
		
		
		$userid = isset($_REQUEST['userid']) ? $_REQUEST['userid'] : 0;
		$bounce_userid = $session->Get('bounce_userid');		
		require_once 'api/bounceadmin.php';
		$bounceadminapi = new Bounceadmin_API();
		
		if($user->admintype == 'a' || $user->admintype == 'b')
		{
			if ($userid > 0)
			{	
				$bounces = $bounceadminapi->GetSpamComplaints(false, $userid, $start, $perpage);
				$bounce_count = $bounceadminapi->GetSpamComplaints(false, $userid, 0, 0, true);
			} else {
				$bounces = $bounceadminapi->GetSpamComplaints(true, 0, $start, $perpage);
				$bounce_count = $bounceadminapi->GetSpamComplaints(true, 0, 0, 0, true);
			}
		} else {
			$bounces = $bounceadminapi->GetSpamComplaints(false, $user->userid, $start, $perpage);
			$bounce_count = $bounceadminapi->GetSpamComplaints(false, $user->userid, 0, 0, true);
			$GLOBALS['ShowUserSelector'] = 'none';
			$userid = $user->userid;
		}
		
		$this->SetupPaging($bounce_count, $DisplayPage, $perpage);
		$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		$paging = $this->ParseTemplate('Paging', true, false);
		
		$historyuser = new User_API($userid);
		$userList = $historyuser->GetClientList($userid);
		//$userList = $historyuser->GetUsers();
		$userOptions = '<option value="0">Global Bounces</option>' . $userList;
		$GLOBALS['UserList'] = $userOptions;
		
		if($userid > 0)
		{
			$GLOBALS['UserAccount'] = $historyuser->companyname.'('.$historyuser->fullname.')';
		} else {
			$GLOBALS['UserAccount'] = 'Global Seeds';
		}
				
		$template = $this->ParseTemplate('Bounce_Admin',true,false);
			
		$rowdetails = '';
		
		//print_r($seedlist);
		foreach($bounces as $bounce)
		{
			$GLOBALS['CompanyName'] = $bounce['username'];	
			$GLOBALS['BounceEmail'] = $bounce['emailaddress'];
			$GLOBALS['BounceDate'] = date('M d, Y', $bounce['bouncetime']);
			$GLOBALS['BounceMessage'] = $bounce['bouncemessage'];
			
			$rowdetails .= $this->ParseTemplate("Bounce_Admin_Row",true,false);
			
		}
		
		$template = str_replace("%%TPL_Bounce_Admin_Row%%", $rowdetails, $template);
		$template = str_replace('%%TPL_Paging%%', $paging, $template);
		$template = str_replace('%%TPL_Paging_Bottom%%', $GLOBALS['PagingBottom'], $template);
		
		
		echo $template;
	}
	
	/**
	 * DisplayBounceAdmin
	 * Show the latest hard bounces
	 * 
	 * @return Void Prints out the form does not return anything
	 *
	 */
	
	function DisplayBounceAdmin()
	{		
		$session = &GetSession();
		$user = &GetUser();			
		$perpage = $this->GetPerPage();
		$DisplayPage = $this->GetCurrentPage();
		$sortinfo = $this->GetSortDetails();
		$start = 0;
		if ($perpage != 'all') {
			$start = ($DisplayPage - 1) * $perpage;
		}
		
		
		$userid = isset($_REQUEST['userid']) ? $_REQUEST['userid'] : 0;
		$bounce_userid = $session->Get('bounce_userid');		
		require_once 'api/bounceadmin.php';
		$bounceadminapi = new Bounceadmin_API();
		
		if($user->admintype == 'a' || $user->admintype == 'b')
		{
			if ($userid > 0)
			{	
				$bounces = $bounceadminapi->GetBounces(false, $userid, $start, $perpage);
				$bounce_count = $bounceadminapi->GetBounces(false, $userid, 0, 0, true);
			} else {
				$bounces = $bounceadminapi->GetBounces(true, 0, $start, $perpage);
				$bounce_count = $bounceadminapi->GetBounces(true, 0, 0, 0, true);
			}
		} else {
			$bounces = $bounceadminapi->GetBounces(false, $user->userid, $start, $perpage);
			$bounce_count = $bounceadminapi->GetBounces(false, $user->userid, 0, 0, true);
			$GLOBALS['ShowUserSelector'] = 'none';
			$userid = $user->userid;
		}
		
		$this->SetupPaging($bounce_count, $DisplayPage, $perpage);
		$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		$paging = $this->ParseTemplate('Paging', true, false);
		
		$historyuser = new User_API($userid);
		$userList = $historyuser->GetClientList($userid);
		//$userList = $historyuser->GetUsers();
		$userOptions = '<option value="0">Global Bounces</option>' . $userList;
		$GLOBALS['UserList'] = $userOptions;
		
		if($userid > 0)
		{
			$GLOBALS['UserAccount'] = $historyuser->companyname.'('.$historyuser->fullname.')';
		} else {
			$GLOBALS['UserAccount'] = 'Global Seeds';
		}
				
		$template = $this->ParseTemplate('Bounce_Admin',true,false);
			
		$rowdetails = '';
		
		//print_r($seedlist);
		foreach($bounces as $bounce)
		{
			$GLOBALS['CompanyName'] = $bounce['username'];	
			$GLOBALS['BounceEmail'] = $bounce['emailaddress'];
			$GLOBALS['BounceDate'] = date('M d, Y', $bounce['bouncetime']);
			$GLOBALS['BounceMessage'] = $bounce['bouncemessage'];
			
			$rowdetails .= $this->ParseTemplate("Bounce_Admin_Row",true,false);
			
		}
		
		$template = str_replace("%%TPL_Bounce_Admin_Row%%", $rowdetails, $template);
		$template = str_replace('%%TPL_Paging%%', $paging, $template);
		$template = str_replace('%%TPL_Paging_Bottom%%', $GLOBALS['PagingBottom'], $template);
		
		
		echo $template;
	}
	
}
?>