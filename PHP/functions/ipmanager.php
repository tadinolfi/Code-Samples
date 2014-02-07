<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

/* *
 * Permissions:
 *     create
 *     read
 *     delete
 *     edit
 * */

class Ipmanager extends SmartMTA_Functions
{
	private $SearchFilter = '';
	private $DisplayPage = 1;

	public function Process()
	{
		if(!isset($_REQUEST['ajax']))
			$this->PrintHeader();
		
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		$this->SearchFilter = isset($_GET['SearchFilter']) ? strtolower($_GET['SearchFilter']) : '';
		
		switch($action)
		{
			case 'create':
				$ipobj = $this->GetApi();
				try {
					$ips = $_POST['ips'];
					$ipobj->shared = isset($_POST['shared']) ? 1 : 0;
					if(!$ipobj->shared && isset($_POST['accounts']))
						$ipobj->userids = $_POST['accounts'];
					$ipobj->vmta = $_POST['vmta'];
					$ipobj->mta = $_POST['mta'];
					$ipobj->notes = $_POST['notes'];
					$failed = false;
					foreach($ips as $ip)
					{
						if($ip != '')
						{ //the first ip might or might not be filled out. check first.
							$ipobj->ip = $ip;
							if(!$ipobj->Create()) {
								$failed = true;
								$this->Message('error', 'The IP '.$ip.' could not be added to the VMTA/Pool.');
							}
						}
					}
					if(!$failed)
						$this->Message('success', 'The VMTA/Pool has been created.');
				}
				catch(Exception $ex) {
					$this->Message('error', 'The IP could not be added to the pool. Missing form data');
				}
				$this->ManageIPs();
				break;
			case 'edit':
				if(isset($_POST['ipid']) && $_POST['ipid'] > 0)
				{
					try {
						$ipobj = $this->GetApi();
						$ips = $_POST['ips'];
						$ipobj->shared = isset($_POST['shared']) ? 1 : 0;
						if(!$ipobj->shared && isset($_POST['accounts']))
							$ipobj->userids = $_POST['accounts'];
						$ipobj->vmta = $_POST['vmta'];
						$ipobj->mta = $_POST['mta'];
						$ipobj->notes = $_POST['notes'];
						$failed = false;
						foreach($ips as $ip)
						{
							if($ip != '')
							{ //the first ip might or might not be filled out. check first.
								if(strpos($ip,'.') === false) //check if we got an id(edit) or an ip(create)
								{ //edit
									$ipobj->ip = '';
									$ipobj->id = $ip;
									if(!$ipobj->Update()) {
										$failed = true;
										$this->Message('error', 'An IP could not be edited.');
									}
								} else { //create
									$ipobj->id = 0;
									$ipobj->ip = $ip;
									if(!$ipobj->Create()) {
										$failed = true;
										$this->Message('error', 'The IP '.$ip.' could not be added to the VMTA/Pool.');
									}
								}
							}
						}
						if(isset($_POST['removedip']))
						{
							$removeips = $_POST['removedip'];
							if(!is_array($removeips))
								$removeips = array($removeips);
							$ipobj = $this->GetApi();
							foreach($removeips as $id)
							{
								if(!empty($id))
								{
									if(!$ipobj->Delete($id))
									{
										$failed = true;
										$this->Message('error', 'An IP could not be deleted from the pool.');
									}
								}
							}
						}
						if(!$failed)
							$this->Message('success', 'The VMTA/Pool has been edited.');
					}
					catch(Exception $ex) {
						$this->Message('error', 'The VMTA/Pool could not be edited. Missing form data');
					}
				}
				else
					$this->Message('error', 'The IP could not be edited. Missing IP Address ID');
				$this->ManageIPs();
				break;
			case 'delete':
				if(isset($_GET['id']) && $_GET['id'] != '')
				{
					$ipobj = $this->GetApi();
					if($ipobj->Delete($_GET['id']))
						$this->Message('success', 'The IP has been deleted from the pool.');
					else
						$this->Message('error', 'The IP could not be deleted from the pool.');
				}
				else
					$this->Message('error', 'The IP could not be deleted from the pool. No ID provided.');
				$this->ManageIPs();
				break;
			case 'getaccounts':
				if(isset($_GET['id']) && $_GET['id'] != '')
				{
					$api = $this->GetApi();
					$user = &GetUser();
					$users = $api->GetIPsAccounts($_GET['id'], false, $user);
					if($users)
						$json = array('Status' => 'OK', 'Message' => '', 'IPUsers' => $users);
					else
						$json = array('Status' => 'Error', 'Message' => 'There are no users associated with this IP Address.');
					echo json_encode($json);
				}
				break;
			case 'getextradetails':
				if(isset($_GET['id']) && $_GET['id'] != '')
				{
					$api = $this->GetApi();
					$user = &GetUser();
					$users = $api->GetIPsAccounts($_GET['id'], false, $user);
					$ips = $api->GetIPsByVMTA($_GET['id']);
					if($users || $ips)
						$json = array('Status' => 'OK', 'Message' => '', 'IPUsers' => $users, 'IPs' => $ips);
					else
						$json = array('Status' => 'Error', 'Message' => 'There are no users or IP addresses associated with this VMTA.');
					echo json_encode($json);
				}
				break;
			default:
					$this->ManageIPs();
			break;
		}
		
		if(!isset($_REQUEST['ajax']))
			$this->PrintFooter();
	}
	
	public function ManageIPs()
	{
		$session = &GetSession();
		$user = &GetUser();

		$this->DisplayPage = $this->GetCurrentPage();
		$perpage = $this->GetPerPage();
		$start = 0;
		if ($perpage != 'all'){
			$perpage = 100;
			$start = ($this->DisplayPage - 1) * $perpage;
		}
		
		$api = $this->GetApi();

		$calendar_restrictions = $session->Get('CalendarRestrictions');

		$ip_count = $api->GetIPs($user->userid, array(), true, $start, $perpage, array(), $this->SearchFilter);

		$this->SetupPaging($ip_count, $this->DisplayPage, $perpage, '&SearchFilter='.$this->SearchFilter);

		$sortinfo = $this->GetSortDetails();

		$ips = $api->GetIPs($user->userid, array(), false, $start, $perpage, $sortinfo, $this->SearchFilter);

		$ip_rows = '';
		foreach($ips as $key=>$ip)
			$ips[$key]['assigned'] = $ip['shared'] ? 'Shared' : '<a href="#'.$ip['ipid'].'" class="accountsip">Accounts</a>';

		$isadmin = $user->hasRole('ManageMTA');

		$this->tpl->Assign('isAdmin', $isadmin);
		$this->tpl->Assign('iprows', $ips);
		$this->tpl->Assign('deleteText', 'You are about to delete an IP address');
		
		$this->tpl->ParseTemplate('ipmanager_manage');
	}
}