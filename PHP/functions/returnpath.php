<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

/**
 * Returnpath Interface Layer Class
 * 
 * This class controls all of the interface interaction for returnpaths
 * 
 * @package InterfaceLayer
 */
class Returnpath extends SmartMTA_Functions
{
	/**
	 * Search Filter
	 * @var string
	 */
	private $SearchFilter = '';
	
	/**
	 * Display Page Number
	 * @var int 
	 */
	private $DisplayPage = 1;

	/**
	 * Director function determines what action we load.
	 */
	public function Process()
	{
		if(!isset($_GET['ajax']))
			$this->PrintHeader();
		
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		$this->SearchFilter = isset($_GET['SearchFilter']) ? strtolower($_GET['SearchFilter']) : '';

		switch($action)
		{
			case 'delete':
				if(isset($_GET['id']))
					$this->Delete($_GET['id']);
				else
					$this->Message('error', 'Missing returnpath ID.');
 				$this->Redirect();				
				break;
				
			case 'activate':
				if(isset($_GET['id']) && isset($_GET['mode']))
					$this->Activate($_GET['id'], $_GET['mode']);
				else
					$this->Message('error', 'Missing valid fields.');
 				$this->Redirect();				
				break;
				
			case 'create':
				$this->Create();
				break;
			
			default:
				$this->Manage();
				break;
		}

		if(!isset($_GET['ajax']))
			$this->PrintFooter();
	}
	
	/**
	 * Display the manage screen for returnpath
	 */
	public function Manage()
	{
		$session = &GetSession();
		$user = &GetUser();

		$this->DisplayPage = $this->GetCurrentPage();
		$perpage = $this->GetPerPage();
		$start = 0;
		if ($perpage != 'all'){
			$perpage = 25;
			$start = ($this->DisplayPage - 1) * $perpage;
		}

		$api = $this->GetApi();

		//$calendar_restrictions = $session->Get('CalendarRestrictions');

		$returnpath_count = $api->GetReturnpaths(0, array(), true, $start, $perpage, array(), $this->SearchFilter);

		$this->SetupPaging($returnpath_count, $this->DisplayPage, $perpage, '&SearchFilter='.$this->SearchFilter);

		$sortinfo = $this->GetSortDetails();
		
		$returnpaths = $api->GetReturnpaths(0, array(), false, $start, $perpage, $sortinfo, $this->SearchFilter);
		
		$this->tpl->Assign('Returnpaths', $returnpaths);
		$this->tpl->Assign('deleteText', 'Are you sure you want to delete this return path?');

		$this->tpl->ParseTemplate('returnpath_manage');
	}
	
	/**
	 * Create a returnpath and redirect to the manage screen.
	 */
	public function Create()
	{
		$api = $this->GetApi();
		
		if(isset($_POST))
		{
			/// TODO: add regex validation check 
			if(isset($_POST['masterid']) && $_POST['masterid'] != '')
			{
				if(!$api->Exists(0,$_POST['masterid']))
				{
					$active = 0;
					if(isset($_POST['active']) && $_POST['active'] == 1)
						$active = 1;
					$returnpath = $api->Create($_POST['masterid'], $_POST['domain'], $active);

					$this->Message('success', 'A returnpath was created.');
				}
				else
					$this->Message('error', 'A returnpath already exists for that master user.');
			}
			else
				$this->Message('error', 'You need to provide a user.');
		}
		else
			$this->Message('error', 'A form was submitted with no data.');
		$this->Redirect();
	}
	
	/**
	 * Delete a returnpath by ID
	 * 
	 * @param int $returnpathid The ID of the returnpath to delete
	 */
	public function Delete($returnpathid)
	{
		if(isset($returnpathid))
		{
			$api = $this->GetApi();
			if($api->Exists($returnpathid))
			{
				if($api->Delete($returnpathid))
					$this->Message('success', 'The returnpath was deleted.');
				else
					$this->Message('error', 'The return path could not be deleted.');
			} else
				$this->Message('error', 'A returnpath with that ID does not exist.');
		} else
			$this->Message('error', 'Missing returnpath ID.');
	}
	
	/**
	 * Activate a returnpath by ID
	 * 
	 * @param int $returnpathid The ID of the returnpath to activate
	 * @param int $mode "1" to activate "0" to deactivate
	 */
	public function Activate($returnpathid, $mode)
	{
		if(isset($returnpathid))
		{
			$api = $this->GetApi();
			if($api->Exists($returnpathid))
			{
				if($api->Activate($returnpathid, $mode))
					$this->Message('success', 'The returnpath was ' . ($mode == 1 ? 'activated' : 'deactivated') . '.');
				else
					$this->Message('error', 'The return path could not be ' . ($mode == 1 ? 'activated' : 'deactivated') . '.');
			} else
				$this->Message('error', 'A returnpath with that ID does not exist.');
		} else
			$this->Message('error', 'Missing returnpath ID.');
	}
}