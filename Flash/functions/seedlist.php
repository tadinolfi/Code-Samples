<?php

require(dirname(__FILE__) . '/sendstudio_functions.php');

class Seedlist extends SendStudio_Functions
{
	var $seedtype = '';
	
	function Seedlist()
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
		require_once 'api/seedlist.php';
		$seedapi = new Seedlist_API();
		//$seedapi = $this->GetApi('Seedlist');
		
		if ($action == 'processpaging') {
			$perpage = (int)$_GET['PerPageDisplay'];
			$display_settings = array('NumberToShow' => $perpage);
			$user->SetSettings('DisplaySettings', $display_settings);
			$action = '';
		}
		
		$this->PrintHeader();
		switch($action)
		{
			case 'create':
				$GLOBALS['Heading'] = "Create new Seed";
				$GLOBALS['SaveExitButton'] = $this->ParseTemplate('Seedlist_Save_Exit_Button', true, false);
				$this->ParseTemplate('Seedlist_Create_Step1');
				switch($subaction)
				{
					case 'saveadd':
					case 'save':
						$subscriber = $this->GetApi('Subscribers');
		
						$GLOBALS['Heading'] = "Create new Seed";
						$GLOBALS['SaveExitButton'] = $this->ParseTemplate('Seedlist_Save_Exit_Button', true, false);
						
						if (!$subscriber->ValidEmail($_POST['emailaddress'])) {
							$GLOBALS['Error'] = sprintf(GetLang('SeedlistAddFail_InvalidEmailAddress'), $_POST['emailaddress']);
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->ParseTemplate('Seedlist_Create_Step1');
							break;
							}
						
						$seedapi->Set('emailaddress', $_POST['emailaddress']);
		
						if($user->admintype == 'a' || $user->admintype == 'b')
						{
							$seedapi->Set('userid', $_SESSION['seed_userid']);
						} else {
							$seedapi->Set('userid', $user->userid);
						}
						
							$seedapi->CreateSeed();

						if ($subaction == 'saveadd')
						{
							?>
							<script language='javascript'>
								window.location = 'index.php?Page=Seedlist&Action=Create';
							</script>
							<?php
							exit();
						} else {
							?>
							<script language='javascript'>
								window.location = 'index.php?Page=Seedlist';
							</script>
							<?php
							exit();												
						}
					break;
				}
				
				break;
				
											
			case 'remove':
				$seedapi->RemoveSeed($seedid);
				$this->DisplaySeedlist();
			break;
			
			case 'edit':
				$GLOBALS['Heading'] = "Modify Seed";
				$GLOBALS['SaveExitButton'] = $this->ParseTemplate('Seedlist_Save_Exit_Button', true, false);
				$seed = $seedapi->GetSeed($seedid);
				$GLOBALS['emailaddress'] = $seed['email'];
				$GLOBALS['SeedID'] = $seedid;
				$this->ParseTemplate('Seedlist_Edit_Step1');

				switch($subaction)
				{
					case 'save':
					case 'saveadd':
						$subscriber = $this->GetApi('Subscribers');
												
						if (!$subscriber->ValidEmail($_POST['emailaddress'])) {
							$GLOBALS['Error'] = sprintf(GetLang('SeedlistAddFail_InvalidEmailAddress'), $_POST['emailaddress']);
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->ParseTemplate('Seedlist_Edit_Step1');
							break;
							}
						
						$seedapi->Set('emailaddress', $_POST['emailaddress']);
		
						if($user->admintype == 'a' || $user->admintype == 'b')
						{
							$seedapi->Set('userid', $_SESSION['seed_userid']);
						} else {
							$seedapi->Set('userid', $user->userid);
						}
						
						if ($seedapi->UpdateSeed($seedid))
						{
							if ($subaction == 'saveadd')
							{
								?>
								<script language='javascript'>
									window.location = 'index.php?Page=Seedlist';
								</script>
								<?php
								exit();
							}
						}
						break;
					}
			break;
			default:
				$this->DisplaySeedlist();
			break;
		}
	}
	
	function DisplaySeedlist()
	{
		//$perpage = $this->GetPerPage();

		//$DisplayPage = $this->GetCurrentPage();
		//$start = ($DisplayPage - 1) * $perpage;
		//$this->SetupPaging($NumberOfLists, $DisplayPage, $perpage);
		//$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		//$paging = $this->ParseTemplate('Paging', true, false);

		//$sortinfo = $this->GetSortDetails();
		$user = &GetUser();	
		
		$userid = isset($_REQUEST['userid']) ? $_REQUEST['userid'] : 0;
		
		require_once 'api/seedlist.php';
		$seedlistapi = new Seedlist_API();
		
		if($user->admintype == 'a' || $user->admintype == 'b')
		{
			if ($userid > 0)
			{
				$seedlist = $seedlistapi->GetSeedList(false, $userid);
			} else {
				$seedlist = $seedlistapi->GetSeedList(true);		
			}
			$_SESSION['seed_userid'] = $userid;		
		} else {
			$seedlist = $seedlistapi->GetSeedList(false, $user->userid);
			$GLOBALS['ShowUserSelector'] = 'none';
			$userid = $user->userid;
		}
		
		$historyuser = new User_API($userid);
		$userList = $historyuser->GetClientList($userid);
		//$userList = $historyuser->GetUsers();
		$userOptions = '<option value="0">Global Seeds</option>' . $userList;
		$GLOBALS['UserList'] = $userOptions;
		
		if($userid > 0)
		{
			$GLOBALS['UserAccount'] = $historyuser->companyname.'('.$historyuser->fullname.')';
		} else {
			$GLOBALS['UserAccount'] = 'Global Seeds';
		}
		
		$GLOBALS['CreateSeedButton'] = '<input type="button" name="create_seed" onclick="document.location=\'index.php?Page=Seedlist&Action=Create\'" value="Create a Seed" />';
		
		$template = $this->ParseTemplate('Seed_List',true,false);
			
		$rowdetails = '';
		
		//print_r($seedlist);
		foreach($seedlist as $seed)
		{	
			$GLOBALS['SeedEmail'] = $seed['email'];
			$GLOBALS['SeedCreatedOn'] = $seed['dateadded'];
			$GLOBALS['SeedActions'] = "<a href='index.php?Page=Seedlist&Action=Edit&Seed=".$seed['seedlistid']."'>Edit</a> | <a onclick=\"if(confirm('Are you sure?')) { document.location='index.php?Page=Seedlist&Action=remove&Seed=".$seed['seedlistid']."' }\" href='#'>Delete</a>";
			
			$rowdetails .= $this->ParseTemplate("Seed_List_Row",true,false);
			
		}
		
		$template = str_replace("%%TPL_SeedRow%%", $rowdetails, $template);
		
		//$template = str_replace('%%TPL_Paging%%', $paging, $template);
		
		echo $template;
	}
	
}
?>