<?php
/**
* This file has the user editing forms in it.
*
* @version     $Id: users.php,v 1.55 2008/03/05 04:00:38 chris Exp $
* @author Chris <chris@interspire.com>
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/

/**
* Include the base sendstudio functions.
*/
require(dirname(__FILE__) . '/sendstudio_functions.php');

/**
* Class for the users management page.
* This checks whether you are allowed to manage users or whether you are only allowed to manage your own account. This also handles editing, deleting, checks to make sure you're not removing the 'last' user and so on.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Users extends SendStudio_Functions
{

	/**
	* PopupWindows
	* An array of popup windows used in this class. Used to work out what sort of header and footer to print.
	*
	* @see Process
	*
	* @var Array
	*/
	var $PopupWindows = array('sendpreview', 'sendpreviewdisplay', 'generatetoken','testgooglecalendar');

	/**
	* _DefaultDirection
	* Override the default sort direction for users.
	*
	* @see _DefaultSort
	* @see GetSortDetails
	*
	* @var String
	*/
	var $_DefaultDirection = 'asc';

	/**
	* Constructor
	* Loads the 'users' and 'timezones' language files
	*
	* @return Void Doesn't return anything.
	*/
	function Users()
	{
		$this->LoadLanguageFile('Users');
		$this->LoadLanguageFile('Timezones');
	}

	/**
	* Process
	* Works out what's going on.
	* The API does the loading, saving, updating - this page just displays the right form(s), checks password validation and so on.
	* After that, it'll print a success/failure message depending on what happened.
	* It also checks to make sure that you're an admin before letting you add or delete.
	* It also checks you're not going to delete your own account.
	* If you're not an admin user, it won't let you edit anyone elses account and it won't let you delete your own account either.
	*
	* @see PrintHeader
	* @see ParseTemplate
	* @see GetSession
	* @see Session::Get
	* @see IEM::getDatabase()
	* @see GetUser
	* @see GetLang
	* @see User_API::Set
	* @see PrintEditForm
	* @see CheckUserSystem
	* @see PrintManageUsers
	* @see User_API::Find
	* @see User_API::Admin
	* @see PrintFooter
	*
	* @return Void Doesn't return anything, passes control over to the relevant function and prints that functions return message.
	*/
	function Process()
	{

		$action = (isset($_GET['Action'])) ? strtolower($_GET['Action']) : '';

		if (!in_array($action, $this->PopupWindows)) {
			$this->PrintHeader();
		}

		$session = &GetSession();
		$thisuser = $session->Get('UserDetails');

		$checkaction = $action;
		if ($action == 'generatetoken') {
			$checkaction = 'manage';
		}

		$access = $thisuser->HasAccess('users', $checkaction);

		if (!$access) {
			$this->DenyAccess();
		}

		if ($action == 'processpaging') {
			$this->SetPerPage($_GET['PerPageDisplay']);
			$action = '';
		}

		switch ($action) {
			case 'generatetoken':
				$check_fields = array('username', 'fullname', 'emailaddress');
				foreach ($check_fields as $field) {
					if (!isset($_POST[$field])) {
						exit;
					}
					$$field = $_POST[$field];
				}
				$user = &GetUser();
				echo htmlspecialchars(sha1($username . $fullname . $emailaddress . $user->GetRealIp(true) . time() . microtime()), ENT_QUOTES, SENDSTUDIO_CHARSET);
				exit;
			break;

			case 'save':
				$userid = (isset($_GET['UserID'])) ? $_GET['UserID'] : 0;
				if (empty($_POST)) {
					$GLOBALS['Error'] = GetLang('UserNotUpdated');
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					$this->PrintEditForm($userid);
					break;
				}

				$user = &GetUser($userid);
				$username = false;
				if (isset($_POST['username'])) {
					$username = $_POST['username'];
				}
				$userfound = $user->Find($username);

				$error = false;
				$template = false;

				$duplicate_username = false;
				if ($userfound && $userfound != $userid) {
					$duplicate_username = true;
					$error = GetLang('UserAlreadyExists');
				}

				$warnings = array();
				$GLOBALS['Message'] = '';

				if (!$duplicate_username) {

					$to_check = array();
					foreach (array('status' => 'LastActiveUser', 'admintype' => 'LastAdminUser') as $area => $desc) {
						if (!isset($_POST[$area])) {
							$to_check[] = $desc;
						}
						if (isset($_POST[$area]) && $_POST[$area] == '0') {
							$to_check[] = $desc;
						}
					}

					if ($_POST['admintype'] != 'a') {
						$to_check[] = 'LastAdminUser';
					}

					$error = $this->CheckUserSystem($userid, $to_check);

					if (!$error) {

						$smtptype = (isset($_POST['smtptype'])) ? $_POST['smtptype'] : 0;
						$mtaheader = (isset($_POST['mtaheader'])) ? $_POST['mtaheader'] : '';

						// Make sure smtptype is eiter 0 or 1
						if ($smtptype != 1) {
							$smtptype = 0;
						}

						/**
						 * This was added, because User's API uses different names than of the HTML form names.
						 * HTML form names should stay the same to keep it consistant throught the application
						 *
						 * This will actually map HTML forms => User's API fields
						 */
							$areaMapping = array(
								'username' => 'username',
								'fullname' => 'fullname',
								'emailaddress' => 'emailaddress',
								'companyname' => 'companyname',
								'companyaddress1' => 'companyaddress1',
								'companyaddress2' => 'companyaddress2',
								'companycity' => 'companycity',
								'companystate' => 'companystate',
								'companypostcode' => 'companypostcode',
								'mtaheader' => 'mtaheader',
								'status' => 'status',
								'admintype' => 'admintype',
								'listadmintype' => 'listadmintype',
								'segmentadmintype' => 'segmentadmintype',
								'templateadmintype' => 'templateadmintype',
								'editownsettings' => 'editownsettings',
								'usertimezone' => 'usertimezone',
								'textfooter' => 'textfooter',
								'htmlfooter' => 'htmlfooter',
								'unlimitedmaxemails' => 'unlimitedmaxemails',
								'infotips' => 'infotips',
								'smtp_server' => 'smtpserver',
								'smtp_u' => 'smtpusername',
								'smtp_p' => 'smtppassword',
								'smtp_port' => 'smtpport',
								'usewysiwyg' => 'usewysiwyg',
								'usexhtml' => 'usexhtml',
								'enableactivitylog' => 'enableactivitylog',
								'xmlapi' => 'xmlapi',
								'xmltoken' => 'xmltoken',
								'googlecalendarusername' => 'googlecalendarusername',
								'googlecalendarpassword' => 'googlecalendarpassword',
								'user_language' => 'user_language',
								'returnpathemail' => 'returnpathemail',
								'returnpathenabled'=> 'returnpathenabled',
								'enableheader' => 'enableheader',
								'enablefooter' => 'enablefooter',
								'enablefooterlogo' => 'enablefooterlogo',
								'litmuscredits'	=> 'litmuscredits',
								'litmusuid' => 'litmusuid',
								'litmusunlimited' => 'litmusunlimited' 
							);

							foreach ($areaMapping as $p => $area) {
								$val = (isset($_POST[$p])) ? $_POST[$p] : '';
								if (in_array($area, array('status', 'editownsettings'))) {
									if ($userid == $thisuser->userid) {
										$val = $thisuser->$area;
									}
								}
								
								$user->Set($area, $val);
								
								if ($area == 'unlimitedmaxemails') {
									$maxemails = 0;
									if ($val == 0 && isset($_POST['maxemails'])) {
										$maxemails = (int)$_POST['maxemails'];
									}
									$user->Set('maxemails', $maxemails);
								}
								
								
								// Begin SL7 Mod
								if($area == 'mtaheader')
								{
									// Added 2/9/09 Our Virtual MTA System
									if($mtaheader == 'novice' || $mtaheader == 'expert')
									{
										$user->Set('mtaheader', $mtaheader);
									} else {
										$user->Set('mtaheader', $_POST['custommta']);
									}
								}
								
								// End SL7 Mod
								
								
							}
						/**
						 * -----
						 */

						// ----- Activity type
							$activity = IEM::requestGetPOST('eventactivitytype', '', 'trim');
							if (!empty($activity)) {
								$activity_array = explode("\n", $activity);
								for ($i = 0, $j = count($activity_array); $i < $j; ++$i) {
									$activity_array[$i] = trim($activity_array[$i]);
								}
							} else {
								$activity_array = array();
							}
							$user->Set('eventactivitytype', $activity_array);
						// -----

						// the 'limit' things being on actually means unlimited. so check if the value is NOT set.
						foreach (array('permonth', 'perhour', 'maxlists') as $p => $area) {
							$limit_check = 'limit' . $area;
							$val = 0;
							if (!isset($_POST[$limit_check])) {
								$val = (isset($_POST[$area])) ? $_POST[$area] : 0;
							}
							$user->Set($area, $val);
						}

						if (SENDSTUDIO_MAXHOURLYRATE > 0) {
							if ($user->Get('perhour') == 0 || ($user->Get('perhour') > SENDSTUDIO_MAXHOURLYRATE)) {
								$user_hourly = $this->FormatNumber($user->Get('perhour'));
								if ($user->Get('perhour') == 0) {
									$user_hourly = GetLang('UserPerHour_Unlimited');
								}
								$warnings[] = sprintf(GetLang('UserPerHourOverMaxHourlyRate'), $this->FormatNumber(SENDSTUDIO_MAXHOURLYRATE), $user_hourly);
							}
						}

						if ($smtptype == 0) {
							$user->Set('smtpserver', '');
							$user->Set('smtpusername', '');
							$user->Set('smtppassword', '');
							$user->Set('smtpport', 25);
						}
						
						
						

						if ($_POST['ss_p'] != '') {
							if ($_POST['ss_p_confirm'] != '' && $_POST['ss_p_confirm'] == $_POST['ss_p']) {
								$user->Set('password', $_POST['ss_p']);
							} else {
								$error = GetLang('PasswordsDontMatch');
							}
						}
					}

					if (!$error) {
						$user->RevokeAccess();

						$temp = array();
						if (!empty($_POST['permissions'])) {
							foreach ($_POST['permissions'] as $area => $p) {
								foreach ($p as $subarea => $k) {
									$temp[$subarea] = $user->GrantAccess($area, $subarea);
								}
							}
						}

						if ($_POST['listadmintype'] == 'c') {
							$user->RevokeListAccess();
							if (!empty($_POST['lists'])) {
								$user->GrantListAccess($_POST['lists']);
							}
						}

						if (isset($_POST['segmentadmintype'])) {
							if ($_POST['segmentadmintype'] == 'c') {
								$user->RevokeSegmentAccess();
								if (!empty($_POST['segments'])) {
									$user->GrantSegmentAccess($_POST['segments']);
								}
							}
						}

						if ($_POST['templateadmintype'] == 'c') {
							$user->RevokeTemplateAccess();
							if (!empty($_POST['templates'])) {
								$user->GrantTemplateAccess($_POST['templates']);
							}
						}
					}
				}

				if (!$error) {
					$result = $user->Save();
					if ($result) {
						$GLOBALS['Message'] = $this->PrintSuccess('UserUpdated') . '<br/>';
					} else {
						$GLOBALS['Error'] = GetLang('UserNotUpdated');
						$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					}
				} else {
					$GLOBALS['Error'] = $error;
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
				}

				if (!empty($warnings)) {
					$GLOBALS['Warning'] = implode('<br/>', $warnings);
					$GLOBALS['Message'] .= $this->ParseTemplate('WarningMsg', true, false);
				}

				// if we're editing our own user, reload our settings.
				if ($userid == $thisuser->userid) {
					$new_user = &GetUser($userid);
					$session->Set('UserDetails', $new_user);
				}

				$this->PrintEditForm($userid);
			break;

			case 'add':
				$this->PrintEditForm(0);
			break;

			case 'delete':
				$users = (isset($_POST['users'])) ? $_POST['users'] : array();
				if (isset($_GET['id'])) {
					$users = array((int)$_GET['id']);
				}

				$this->DeleteUsers($users);
			break;

			case 'create':
				$user = New User_API();
				$warnings = array();

				if (!$user->Find($_POST['username'])) {
					foreach (array('username', 'fullname', 'emailaddress', 'companyname', 'companyaddress1', 'companyaddress2', 'companycity', 'companystate', 'companypostcode', 'status', 'admintype', 'editownsettings', 'listadmintype', 'segmentadmintype', 'usertimezone', 'textfooter', 'htmlfooter', 'templateadmintype', 'unlimitedmaxemails', 'infotips', 'smtpserver', 'smtpusername', 'smtpport', 'usewysiwyg', 'enableactivitylog', 'xmlapi', 'xmltoken','googlecalendarusername','googlecalendarpassword', 'enableheader', 'enablefooter', 'mtaheader', 'enablefooterlogo', 'returnpathemail', 'returnpathenabled', 'litmusunlimited', 'litmuscredits', 'litmusuid') as $p => $area) {
						$val = (isset($_POST[$area])) ? $_POST[$area] : '';

						if ($area == 'unlimitedmaxemails') {
							$maxemails = 0;
							if ($val == 0 && isset($_POST['maxemails'])) {
								$maxemails = (int)$_POST['maxemails'];
							}
							$user->Set('maxemails', $maxemails);
						}
						
						
						// Begin SL7 Mod
						if($area == 'mtaheader')
						{
							// Added 2/9/09 Our Virtual MTA System
							if($mtaheader == 'novice' || $mtaheader == 'expert')
							{
								$user->Set('mtaheader', $mtaheader);
							} else {
								$user->Set('mtaheader', $_POST['custom_mta']);
							}
						}
						// End SL7 Mod
						
						$user->Set($area, $val);
					}
					
					// ----- Activity type
						$activity = IEM::requestGetPOST('eventactivitytype', '', 'trim');
						if (!empty($activity)) {
							$activity_array = explode("\n", $activity);
							for ($i = 0, $j = count($activity_array); $i < $j; ++$i) {
								$activity_array[$i] = trim($activity_array[$i]);
							}
						} else {
							$activity_array = array();
						}
						$user->Set('eventactivitytype', $activity_array);
					// -----

					// the 'limit' things being on actually means unlimited. so check if the value is NOT set.
					foreach (array('permonth', 'perhour', 'maxlists') as $p => $area) {
						$limit_check = 'limit' . $area;
						$val = 0;
						if (!isset($_POST[$limit_check])) {
							$val = (isset($_POST[$area])) ? $_POST[$area] : 0;
						}
						$user->Set($area, $val);
					}

					if (SENDSTUDIO_MAXHOURLYRATE > 0) {
						if ($user->Get('perhour') == 0 || ($user->Get('perhour') > SENDSTUDIO_MAXHOURLYRATE)) {
							$user_hourly = $this->FormatNumber($user->Get('perhour'));
							if ($user->Get('perhour') == 0) {
								$user_hourly = GetLang('UserPerHour_Unlimited');
							}
							$warnings[] = sprintf(GetLang('UserPerHourOverMaxHourlyRate'), $this->FormatNumber(SENDSTUDIO_MAXHOURLYRATE), $user_hourly);
						}
					}

					// this has a different post value otherwise firefox tries to pre-fill it.
					$smtp_password = '';
					if (isset($_POST['smtp_p'])) {
						$smtp_password = $_POST['smtp_p'];
					}
					$user->Set('smtppassword', $smtp_password);

					$error = false;

					if ($_POST['ss_p'] != '') {
						if ($_POST['ss_p_confirm'] != '' && $_POST['ss_p_confirm'] == $_POST['ss_p']) {
							$user->Set('password', $_POST['ss_p']);
						} else {
							$error = GetLang('PasswordsDontMatch');
						}
					}

					if (!$error) {
						if (!empty($_POST['permissions'])) {
							foreach ($_POST['permissions'] as $area => $p) {
								foreach ($p as $subarea => $k) {
									$user->GrantAccess($area, $subarea);
								}
							}
						}

						if (!empty($_POST['lists'])) {
							$user->GrantListAccess($_POST['lists']);
						}

						if (!empty($_POST['templates'])) {
							$user->GrantTemplateAccess($_POST['templates']);
						}

						if (!empty($_POST['segments'])) {
							$user->GrantSegmentAccess($_POST['segments']);
						}

						$GLOBALS['Message'] = '';

						if (!empty($warnings)) {
							$GLOBALS['Warning'] = implode('<br/>', $warnings);
							$GLOBALS['Message'] .= $this->ParseTemplate('WarningMsg', true, false);
						}

						$user->Set('gettingstarted',0);

						$result = $user->Create();
						if ($result == '-1') {
							$GLOBALS['Error'] = GetLang('UserNotCreated_License');
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->PrintManageUsers();
							break;
						} else {
							if ($result) {
								$GLOBALS['Message'] .= $this->PrintSuccess('UserCreated') . '<br/>';
								$this->PrintManageUsers();
								break;
							} else {
								$GLOBALS['Error'] = GetLang('UserNotCreated');
							}
						}
					} else {
						$GLOBALS['Error'] = $error;
					}
				} else {
					$GLOBALS['Error'] = GetLang('UserAlreadyExists');
				}
				$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);

				$details = array();
				foreach (array('FullName', 'EmailAddress', 'CompanyName', 'CompanyAddress1', 'CompanyAddress2', 'CompanyCity', 'CompanyState', 'CompanyPostCode', 'Status', 'AdminType', 'ListAdminType', 'SegmentAdminType', 'TemplateAdminType', 'InfoTips', 'smtpserver', 'smtpusername', 'smtpport', 'returnpathemail', 'returnpathenabled', 'enableheader', 'enablefooter', 'enablefooterlogo', 'mtaheader') as $p => $area) {
					$lower = strtolower($area);
					$val = (isset($_POST[$lower])) ? $_POST[$lower] : '';
					$details[$area] = $val;
				}
				$this->PrintEditForm(0, $details);
			break;

			case 'edit':
				$userid = (isset($_GET['UserID'])) ? $_GET['UserID'] : 0;
				$this->PrintEditForm($userid);
			break;

			case 'sendpreviewdisplay':
				$this->PrintHeader(true);
				$this->SendTestPreviewDisplay('index.php?Page=Users&Action=SendPreview', 'self.parent.getSMTPPreviewParameters()');
				$this->PrintFooter(true);
			break;

			case 'testgooglecalendar':
				$status = array(
					'status' => false,
					'message' => ''
				);
				try {
					$details = array(
						'username' => $_REQUEST['gcusername'],
						'password' => $_REQUEST['gcpassword']
					);

					$this->GoogleCalendarAdd($details, true);

					$status['status'] = true;
					$status['message'] = GetLang('GooglecalendarTestSuccess');
				} catch (Exception $e) {
					$status['message'] = GetLang('GooglecalendarTestFailure');
				}

				print GetJSON($status);
			break;

			case 'sendpreview':
				$this->SendTestPreview();
			break;

			default:
				$this->PrintManageUsers();
			break;
		}

		if (!in_array($action, $this->PopupWindows)) {
			$this->PrintFooter();
		}
	}

	/**
	* PrintManageUsers
	* Prints a list of users to manage. If you are only allowed to manage your own account, only shows your account in the list. This allows you to edit, delete and so on.
	*
	* @see GetSession
	* @see Session::Get
	* @see GetApi
	* @see GetPerPage
	* @see GetSortDetails
	* @see User_API::Admin
	* @see GetUsers
	* @see SetupPaging
	*
	* @return Void Prints out the list, doesn't return anything.
	*/
	function PrintManageUsers()
	{
		$session = &GetSession();
		$thisuser = $session->Get('UserDetails');

		$userapi = $this->GetApi('User');

		$perpage = $this->GetPerPage();

		$DisplayPage = $this->GetCurrentPage();
		$start = 0;
		if ($perpage != 'all') {
			$start = ($DisplayPage - 1) * $perpage;
		}

		$sortinfo = $this->GetSortDetails();

		$userowner = ($thisuser->UserAdmin()) ? 0 : $thisuser->userid;

		$usercount = $userapi->GetUsers($userowner, $sortinfo, true);
		$myusers = $userapi->GetUsers($userowner, $sortinfo, false, $start, $perpage);

		if ($thisuser->UserAdmin()) {
			//$licensecheck = ssk23twgezm2();
			$licensecheck = '';
			$GLOBALS['UserReport'] = $licensecheck;
		}

		$this->SetupPaging($usercount, $DisplayPage, $perpage);
		$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		$paging = $this->ParseTemplate('Paging', true, false);

		$display = '';

		foreach ($myusers as $pos => $userdetails) {
			$GLOBALS['UserID'] = $userdetails['userid'];
			$GLOBALS['UserName'] = htmlspecialchars($userdetails['username'], ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['CompanyName'] = htmlspecialchars($userdetails['companyname'], ENT_QUOTES, SENDSTUDIO_CHARSET);
			if (!$userdetails['companyname']) {
				$GLOBALS['CompanyName'] = GetLang('N/A');
			}
			$GLOBALS['Status'] = ($userdetails['status'] == 1) ? GetLang('Active') : GetLang('Inactive');

			$usertype = $thisuser->GetAdminType($userdetails['admintype']);
			if ($usertype == 'c') {
				$usertype = 'RegularUser';
			}

			$GLOBALS['UserType'] = GetLang('AdministratorType_' . $usertype);

			$action = '<a href="index.php?Page=Users&Action=Edit&UserID=' . $userdetails['userid'] . '">' . GetLang('Edit') . '</a>';

			if ($thisuser->UserAdmin()) {
				if ($userdetails['userid'] == $thisuser->Get('userid')) {
					$action .= $this->DisabledItem('Delete', 'User_Delete_Own_Disabled');
				} else {
					$action .= '&nbsp;&nbsp;<a href="javascript: ConfirmDelete(' . $userdetails['userid'] . ');">' . GetLang('Delete') . '</a>';
				}
			} else {
				$action .= $this->DisabledItem('Delete', 'User_Delete_Own_Disabled');
			}

			$GLOBALS['UserAction'] = $action;

			$template = $this->ParseTemplate('Users_List_Row', true, false);
			$display .= $template;
		}

		if ($thisuser->UserAdmin()) {
			$GLOBALS['Users_AddButton'] = $this->ParseTemplate('User_Add_Button', true, false);
			$GLOBALS['Users_DeleteButton'] = $this->ParseTemplate('User_Delete_Button', true, false);
		}

		$user_list = $this->ParseTemplate('Users', true, false);

		$user_list = str_replace('%%TPL_Paging%%', $paging, $user_list);
		$user_list = str_replace('%%TPL_Paging_Bottom%%', $GLOBALS['PagingBottom'], $user_list);
		$user_list = str_replace('%%TPL_Users_List_Row%%', $display, $user_list);

		echo $user_list;
	}

	/**
	* PrintEditForm
	* Prints a form to edit a user. If you pass in a userid, it will load up that user and print their information. If you pass in the details array, it will prefill the form with that information (eg if you tried to create a user with a duplicate username). Also checks whether you are allowed to edit this user. If you are not an admin, you are only allowed to edit your own account.
	*
	* @param Int $userid Userid to load up.
	* @param Array $details Details to prefill the form with (in case there was a problem creating the user).
	*
	* @see GetSession
	* @see Session::Get
	* @see User_API::Admin
	* @see User_API::Status
	* @see User_API::ListAdmin
	* @see User_API::EditOwnSettings
	* @see GetUser
	*
	* @return Void Returns nothing. If you don't have access to edit a particular user, it prints an error message and exits. Otherwise it prints the correct form (either edit-own or edit) and then exits.
	*/
	function PrintEditForm($userid = 0, $details = array())
	{
		$session = &GetSession();
		$thisuser = $session->Get('UserDetails');
		if (!$thisuser->UserAdmin()) {
			if ($userid != $thisuser->userid) {
				$GLOBALS['ErrorMessage'] = GetLang('NoAccess');
				$this->ParseTemplate('AccessDenied');
				return;
			}

			if (!$thisuser->EditOwnSettings()) {
				$GLOBALS['ErrorMessage'] = GetLang('NoAccess');
				$this->ParseTemplate('AccessDenied');
				return;
			}
		}

		$listapi = $this->GetApi('Lists');
		$all_lists = $listapi->GetLists(0, array('SortBy' => 'name', 'Direction' => 'asc'), false, 0, 0);

		$segmentapi = $this->GetApi('Segment');
		$all_segments = $segmentapi->GetSegments(array('SortBy' => 'segmentname', 'Direction' => 'asc'), false, 0, 'all');

		$templateapi = $this->GetApi('Templates');
		$all_templates = $templateapi->GetTemplates(0, array('SortBy' => 'name', 'Direction' => 'asc'), false, 0, 0);

		$GLOBALS['CustomSmtpServer_Display'] = '0';

		$GLOBALS['XmlPath'] = SENDSTUDIO_APPLICATION_URL . '/xml.php';

		if ($userid > 0) {
			$user = &GetUser($userid);
			if ($user->Get('userid') <= 0) {
				$GLOBALS['ErrorMessage'] = GetLang('UserDoesntExist');
				$this->DenyAccess();
				return;
			}
			$GLOBALS['UserID'] = $user->Get('userid');
			$GLOBALS['UserName'] = htmlspecialchars($user->Get('username'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['FullName'] = htmlspecialchars($user->Get('fullname'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['EmailAddress'] = htmlspecialchars($user->Get('emailaddress'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['EmailAddress'] = htmlspecialchars($user->Get('emailaddress'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			
			
			// Begin SL7 Mod
			$GLOBALS['CompanyName'] = htmlspecialchars($user->Get('companyname'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['CompanyAddress1'] = htmlspecialchars($user->Get('companyaddress1'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['CompanyAddress2'] = htmlspecialchars($user->Get('companyaddress2'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['CompanyCity'] = htmlspecialchars($user->Get('companycity'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['CompanyState'] = htmlspecialchars($user->Get('companystate'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['StateList'] = $user->GetStatesList($user->Get('companystate'));
			$GLOBALS['CompanyPostCode'] = htmlspecialchars($user->Get('companypostcode'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['mtaheader'] = htmlspecialchars($user->Get('mtaheader'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['LitmusUID'] = htmlspecialchars($user->Get('litmusuid'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['LitmusCredits'] = htmlspecialchars($user->Get('litmuscredits'), ENT_QUOTES, SENDSTUDIO_CHARSET);		
			$GLOBALS['ShowCustomMTA'] = 'none';
			if($user->Get('returnpathenabled'))
			{
				$GLOBALS['DisplayReturnPath'] = '';
				$GLOBALS['DisplayLitmus'] = 'none';
				$GLOBALS['RenderingTypes'] = "<option value='2' SELECTED>ReturnPath</option><option value='1'>Litmus</option>";
			} else {
				$GLOBALS['RenderingTypes'] = "<option value='2'>ReturnPath</option><option value='1' SELECTED>Litmus</option>";
				$GLOBALS['DisplayReturnPath'] = 'none';
				$GLOBALS['DisplayLitmus'] = '';
			}
 			if($user->Get('litmusunlimited') == 1)
			{
				$GLOBALS['LitmusChecked'] = 'CHECKED';
				$GLOBALS['DisplayLitmusUID'] = '';
				$GLOBALS['DisplayLitmusCredits'] = 'none';
				
			} else {
				$GLOBALS['DisplayLitmusUID'] = 'none';
				$GLOBALS['DisplayLitmusCredits'] = '';
			}
				
			

			switch($user->Get('mtaheader'))
			{
				case '':
				case 'novice':
					$GLOBALS['MTAOptions'] = "<option value='novice' selected>Novice MTA</option><option value='expert'>Expert MTA</option><option value='custom'>Custom MTA</option>";
				break;
				
				case 'expert':
					$GLOBALS['MTAOptions'] = "<option value='novice'>Novice MTA</option><option value='expert' selected>Expert MTA</option><option value='custom'>Custom MTA</option>";
				break;
				
				default:
					$GLOBALS['MTAOptions'] = "<option value='novice'>Novice MTA</option><option value='expert'>Expert MTA</option><option value='custom' selected>Custom MTA</option>";
					$GLOBALS['ShowCustomMTA'] = '';
					$GLOBALS['CustomMTA'] = $user->Get('mtaheader');
				break;
			}
			
			$GLOBALS['ReturnPathEnabledChecked'] = '';
			$GLOBALS['DisplayReturnPathEmail'] = 'none';
			$GLOBALS['ReturnPathEmail'] = $user->Get('returnpathemail');

			if ($user->Get('returnpathenabled')) {
				$GLOBALS['ReturnPathEnabledChecked'] = ' CHECKED';
				$GLOBALS['DisplayReturnPathEmail'] = '';
			}
			
			$GLOBALS['EnableHeaderChecked'] = 'CHECKED';
			$GLOBALS['EnableFooterChecked'] = 'CHECKED';
			$GLOBALS['EnableFooterLogoChecked'] = 'CHECKED';
			
			if(!$user->Get('enableheader'))
			{
				$GLOBALS['EnableHeaderChecked'] = '';
			}
			
			if(!$user->Get('enablefooter'))
			{
				$GLOBALS['EnableFooterChecked'] = '';
			}
			
			if(!$user->Get('enablefooterlogo'))
			{
				$GLOBALS['EnableFooterLogoChecked'] = '';
			}
			// End SL7 Mod
			
			
			$activity = $user->GetEventActivityType();
			if (!is_array($activity)) {
				$activity = array();
			}
			$GLOBALS['EventActivityType'] = implode("\n", $activity);

			$GLOBALS['MaxLists'] = $user->Get('maxlists');
			$GLOBALS['MaxEmails'] = $user->Get('maxemails');
			$GLOBALS['PerMonth'] = $user->Get('permonth');
			$GLOBALS['PerHour'] = $user->Get('perhour');


			$GLOBALS['DisplayMaxLists'] = '';
			if ($user->Get('maxlists') == 0) {
				$GLOBALS['LimitListsChecked'] = ' CHECKED';
				$GLOBALS['DisplayMaxLists'] = 'none';
			}

			$GLOBALS['DisplayEmailsPerHour'] = '';
			if ($user->Get('perhour') == 0) {
				$GLOBALS['LimitPerHourChecked'] = ' CHECKED';
				$GLOBALS['DisplayEmailsPerHour'] = 'none';
			}

			$GLOBALS['DisplayEmailsPerMonth'] = '';
			if ($user->Get('permonth') == 0) {
				$GLOBALS['LimitPerMonthChecked'] = ' CHECKED';
				$GLOBALS['DisplayEmailsPerMonth'] = 'none';
			}

			$GLOBALS['LimitMaximumEmailsChecked'] = ' CHECKED';
			$GLOBALS['DisplayEmailsMaxEmails'] = 'none';

			if (!$user->Get('unlimitedmaxemails')) {
				$GLOBALS['LimitMaximumEmailsChecked'] = '';
				$GLOBALS['DisplayEmailsMaxEmails'] = '';
			}

			if ($user->Get('usewysiwyg')) {
				$GLOBALS['UseWysiwyg'] = ' CHECKED';
				$GLOBALS['UseXHTMLDisplay'] = ' style="display:block;"';
			} else {
				$GLOBALS['UseXHTMLDisplay'] = ' style="display:none;"';
			}

			if ($user->Get('enableactivitylog')) {
				$GLOBALS['EnableActivityLog'] = ' CHECKED';
			} else {
				$GLOBALS['EnableActivityLog'] = '';
			}

			$GLOBALS['UseXHTMLCheckbox'] = $user->Get('usexhtml')? ' CHECKED' : '';

			$GLOBALS['Xmlapi'] = $user->Get('xmlapi')? ' CHECKED' : '';
			$GLOBALS['XMLTokenDisplay'] = ' style="display:none;"';

			if ($user->Get('xmlapi')) {
				$GLOBALS['XMLTokenDisplay'] = ' style="display:block;"';
			}
			$GLOBALS['XmlToken'] = htmlspecialchars($user->Get('xmltoken'), ENT_QUOTES, SENDSTUDIO_CHARSET);

			$GLOBALS['TextFooter'] = $user->Get('textfooter');
			$GLOBALS['HTMLFooter'] = $user->Get('htmlfooter');

			$GLOBALS['SmtpServer'] = $user->Get('smtpserver');
			$GLOBALS['SmtpUsername'] = $user->Get('smtpusername');
			$GLOBALS['SmtpPassword'] = $user->Get('smtppassword');
			$GLOBALS['SmtpPort'] = $user->Get('smtpport');

			if ($GLOBALS['SmtpServer']) {
				$GLOBALS['CustomSmtpServer_Display'] = '1';
			}

			$GLOBALS['googlecalendarusername'] = htmlspecialchars($user->Get('googlecalendarusername'), ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['googlecalendarpassword'] = htmlspecialchars($user->Get('googlecalendarpassword'), ENT_QUOTES, SENDSTUDIO_CHARSET);

			$GLOBALS['FormAction'] = 'Action=Save&UserID=' . $user->userid;

			if (!$thisuser->UserAdmin()) {

				$smtp_access = $thisuser->HasAccess('User', 'SMTP');

				$GLOBALS['ShowSMTPInfo'] = 'none';
				$GLOBALS['DisplaySMTP'] = '0';

				if ($smtp_access) {
					$GLOBALS['ShowSMTPInfo'] = '';
				}

				if ($GLOBALS['SmtpServer']) {
					$GLOBALS['CustomSmtpServer_Display'] = '1';
					if ($smtp_access) {
						$GLOBALS['DisplaySMTP'] = '1';
					}
				}

				$this->ParseTemplate('User_Edit_Own');
				return;
			}

			$GLOBALS['StatusChecked'] = ($user->Status()) ? ' CHECKED' : '';

			$GLOBALS['InfoTipsChecked'] = ($user->InfoTips()) ? ' CHECKED' : '';

			$editown = '';
			if ($user->UserAdmin()) {
				$editown = ' CHECKED';
			} else {
				if ($user->EditOwnSettings()) {
					$editown = ' CHECKED';
				}
			}
			$GLOBALS['EditOwnSettingsChecked'] = $editown;

			$timezone = $user->usertimezone;

			$GLOBALS['TimeZoneList'] = $this->TimeZoneList($timezone);

			$admintype = $user->AdminType();
			$listadmintype = $user->ListAdminType();
			$segmentadmintype = $user->SegmentAdminType();
			$templateadmintype = $user->TemplateAdminType();

			$admin = $user->Admin();
			$listadmin = $user->ListAdmin();
			$segmentadmin = $user->SegmentAdmin();
			$templateadmin = $user->TemplateAdmin();

			$permissions = $user->Get('permissions');
			$area_access = $user->Get('access');

			$GLOBALS['Heading'] = GetLang('EditUser');
			$GLOBALS['Help_Heading'] = GetLang('Help_EditUser');

			// Log this to "User Activity Log"
			IEM::logUserActivity(IEM::urlFor('users', array('Action' => 'Edit', 'UserID' => $userid)), 'images/user.gif', $user->username);

		} else {
			$GLOBALS['StateList'] = $thisuser->GetStatesList();
			$timezone = (isset($details['timezone'])) ? $details['timezone'] : SENDSTUDIO_SERVERTIMEZONE;
			$GLOBALS['TimeZoneList'] = $this->TimeZoneList($timezone);

			$activity = $thisuser->defaultEventActivityType;
			if (!is_array($activity)) {
				$activity = array();
			}
			$GLOBALS['EventActivityType'] = implode("\n", $activity);

			$GLOBALS['FormAction'] = 'Action=Create';

			if (!empty($details)) {
				foreach ($details as $area => $val) {
					$GLOBALS[$area] = $val;
				}
			}
			$GLOBALS['Heading'] = GetLang('CreateUser');
			$GLOBALS['Help_Heading'] = GetLang('Help_CreateUser');

			$listadmintype = 'c';
			$segmentadmintype = 'c';
			$admintype = 'c';
			$templateadmintype = 'c';
			
			$GLOBALS['EnableHeaderChecked'] = 'CHECKED';
			$GLOBALS['EnableFooterChecked'] = 'CHECKED';
			$GLOBALS['EnableFooterLogoChecked'] = 'CHECKED';
			$GLOBALS['LitmusChecked'] = 'CHECKED';
			
			$GLOBALS['RenderingTypes'] = "<option value='1'>Litmus</option><option value='2'>ReturnPath</option>";
			
			$GLOBALS['DisplayReturnPath'] = 'none';
			$GLOBALS['DisplayLitmus'] = '';
			$GLOBALS['DisplayMaxLists'] = 'none';
			$GLOBALS['DisplayEmailsPerHour'] = 'none';
			$GLOBALS['DisplayEmailsPerMonth'] = 'none';
			$GLOBALS['DisplayEmailsMaxEmails'] = 'none';
			$GLOBALS['DisplayReturnPathEmail'] = 'none';
			$GLOBALS['DisplayLitmusCredits'] = 'none';
			$GLOBALS['DisplayLitmusUID'] = '';
			

			$GLOBALS['MaxLists'] = '0';
			$GLOBALS['PerHour'] = '0';
			$GLOBALS['PerMonth'] = '0';
			$GLOBALS['MaxEmails'] = '50';
			$GLOBALS['ShowCustomMTA'] = 'none';
			$GLOBALS['MTAOptions'] = "<option value='novice'>Novice MTA</option><option value='expert' selected>Expert MTA</option><option value='custom'>Custom MTA</option>";
			

			$GLOBALS['StatusChecked'] = ' CHECKED';
			$GLOBALS['InfoTipsChecked'] = ' CHECKED';
			$GLOBALS['EditOwnSettingsChecked'] = ' CHECKED';

			$GLOBALS['LimitListsChecked'] = ' CHECKED';
			$GLOBALS['LimitPerHourChecked'] = ' CHECKED';
			$GLOBALS['LimitPerMonthChecked'] = ' CHECKED';
			$GLOBALS['LimitMaximumEmailsChecked'] = ' CHECKED';

			$GLOBALS['UseWysiwyg'] = ' CHECKED';
			$GLOBALS['EnableLastViewed'] = '';
			$GLOBALS['UseXHTMLCheckbox'] = ' CHECKED';
			$GLOBALS['ReturnPathEnabledChecked' ] = '';
			

			$GLOBALS['HTMLFooter'] = GetLang('Default_Global_HTML_Footer');
			$GLOBALS['TextFooter'] = GetLang('Default_Global_Text_Footer');

			$GLOBALS['EnableActivityLog'] = ' CHECKED';

			$GLOBALS['Xmlapi'] = '';
			$GLOBALS['XMLTokenDisplay'] = ' style="display:none;"';

			$admin = $listadmin = $segmentadmin = $templateadmin = false;
			$permissions = array();
			$area_access = array('lists' => array(), 'templates' => array(), 'segments' => array());
		}

		$permission_types = $thisuser->getPermissionTypes();

		$addon_permissions = array();
		if (isset($permission_types['addon_permissions'])) {
			$addon_permissions = $permission_types['addon_permissions'];
			unset($permission_types['addon_permissions']);
		}

		foreach ($permission_types as $area => $sub) {
			foreach ($sub as $p => $subarea) {
				if (in_array($area, array_keys($permissions))) {
					if (in_array($subarea, $permissions[$area])) {
						$GLOBALS['Permissions_' . ucwords($area) . '_' . ucwords($subarea)] = ' CHECKED';
					}
				}
			}
		}

		$GLOBALS['PrintAdminTypes'] = '';
		foreach ($thisuser->GetAdminTypes() as $option => $desc) {
			$selected = '';
			if ($option == $admintype) {
				$selected = ' SELECTED';
			}

			$GLOBALS['PrintAdminTypes'] .= '<option value="' . $option . '"' . $selected . '>' . GetLang('AdministratorType_' . $desc) . '</option>';
		}

		$GLOBALS['AddonPermissionDisplay'] = '';
		$addon_header = $this->ParseTemplate('User_Permissions_Addons_Header', true, false);

		$addon_footer = $this->ParseTemplate('User_Permissions_Addons_Footer', true, false);

		if (!empty($addon_permissions)) {

			$addon_display_permissions = array();

			foreach ($addon_permissions as $addon_id => $details) {
				$addon_line = '
					<tr class="CustomPermissionOptions">
						<td class="FieldLabel">
							' . htmlspecialchars($details['addon_description'], ENT_QUOTES, SENDSTUDIO_CHARSET) . '
						</td>
						<td>
							<table cellspacing="0" cellpadding="0" border="0">
								<tr>
				';
				unset($details['addon_description']);
				$permission_count = 1;
				$permission_cell = 1;
				foreach ($details as $addon_permission => $addon_description) {
					$extra_tr = '';
					if ($permission_cell > 4) {
						$extra_tr = '</tr>' . "\n" . '<tr>' . "\n";
						$permission_cell = 1;
					}
					$checked = '';
					if (in_array($addon_id, array_keys($permissions))) {
						if (in_array($addon_permission, $permissions[$addon_id])) {
							$checked = ' CHECKED';
						}
					}
					$label = $addon_id . '_' . $addon_permission;

					$line = $extra_tr;

					$line .= '<td  class="PermissionColumn' . $permission_cell . '">' . "\n";
					$line .= '<label for="' . $label . '">' . "\n";
					$line .= '<input id="' . $label . '"  class="PermissionOptionItems" type="checkbox" name="permissions[' . $addon_id . '][' . $addon_permission . '] value="1"' . $checked . '>' . "\n";
					$line .= htmlspecialchars($addon_description['name'], ENT_QUOTES, SENDSTUDIO_CHARSET);
					$line .= '</label>' . "\n";
					$line .= '</td>' . "\n";

					$helptip = '';
					if (isset($addon_description['help'])) {
						$helptip = $this->_GenerateHelpTip(null, $addon_description['name'], $addon_description['help']);
					}

					$line .= '<td class="PermissionColumn' . ++$permission_cell . '">' . $helptip . '</td>' . "\n";

					$addon_line .= $line;
					$permission_count++;
					$permission_cell++;
				}

				while ($permission_cell < 4) {
					// add one for the "description"
					$addon_line .= '<td class="PermissionColumn' . $permission_cell . '">&nbsp;</td>';

					// add one for the helptip
					$addon_line .= '<td class="PermissionColumn' . ++$permission_cell . '">&nbsp;</td>';
					$permission_cell++;
				}

				$addon_line .= '</tr></table></td></tr>';
				$addon_display_permissions[] = $addon_line;
			}
			$GLOBALS['AddonPermissionDisplay'] = $addon_header . implode($addon_display_permissions) . $addon_footer;
		}

		$GLOBALS['PrintListAdminList'] = '';
		foreach ($thisuser->GetListAdminTypes() as $option => $desc) {
			$selected = '';
			if ($listadmin) {
				if ($option == 'a') {
					$selected = ' SELECTED';
				}
			} else {
				if ($option == $listadmintype) {
					$selected = ' SELECTED';
				}
			}
			$GLOBALS['PrintListAdminList'] .= '<option value="' . $option . '"' . $selected . '>' . GetLang('ListAdministratorType_' . $desc) . '</option>';
		}

		$GLOBALS['DisplayPermissions'] = '';
		
		if ($user->admintype != 'a') {
			$GLOBALS['DisplayPermissions'] = 'none';
		}

		if ($listadmin || $listadmintype == 'a') {
			$GLOBALS['ListDisplay'] = 'none';
		} else {
			$GLOBALS['ListDisplay'] = '';
		}

		/**
		 * Working out how segment is going to be displayed
		 */
			$GLOBALS['PrintSegmentAdminList'] = '';
			foreach ($thisuser->GetSegmentAdminTypes() as $option => $desc) {
				$selected = '';
				if ($segmentadmin) {
					if ($option == 'a') {
						$selected = ' selected="selected"';
					}
				} else {
					if ($option == $segmentadmintype) {
						$selected = ' selected="selected"';
					}
				}
				$GLOBALS['PrintSegmentAdminList'] .= '<option value="' . $option . '"' . $selected . '>' . GetLang('SegmentAdministratorType_' . $desc) . '</option>';
			}

			if ($segmentadmin || $segmentadmintype == 'a') {
				$GLOBALS['SegmentDisplay'] = 'none';
			} else {
				$GLOBALS['SegmentDisplay'] = '';
			}

			$segment_rows = '';
			if (empty($all_segments)) {
				$GLOBALS['NoOptionAvailable'] = GetLang('NoSegmentsAvailable');
				$segment_rows .= $this->ParseTemplate('User_No_Option_Available', true, true);
			} else {
				foreach ($all_segments as $p => $segmentdetails) {
					$segmentOwner = ($segmentdetails['ownerid'] == $userid);

					$GLOBALS['CheckBoxOption'] = htmlspecialchars($segmentdetails['segmentname'], ENT_QUOTES, SENDSTUDIO_CHARSET);
					$GLOBALS['CheckBoxName'] = 'segments[' . $segmentdetails['segmentid'] . ']';
					$GLOBALS['CheckBoxChecked'] = '';

					if ($segmentOwner) {
						$GLOBALS['CheckBoxRowAttribute'] = ' style="display:none;"';
					} else {
						$GLOBALS['CheckBoxRowAttribute'] = '';
					}

					if (in_array($segmentdetails['segmentid'], $area_access['segments']) || $segmentOwner) {
						$GLOBALS['CheckBoxChecked'] = ' checked="checked"';
					}
					$segment_rows .= $this->ParseTemplate('User_Permission_Option_Option', true, false);
				}
			}
			$GLOBALS['IndividualOption'] = $segment_rows;
			$GLOBALS['PrintSegmentLists'] = $this->ParseTemplate('User_Permission_Option', true, false);
		/**
		 * -----
		 */

		$list_rows = '';
		if (empty($all_lists)) {
			$GLOBALS['NoOptionAvailable'] = GetLang('NoListsAvailable');
			$list_rows .= $this->ParseTemplate('User_No_Option_Available', true, false);
		} else {
			foreach ($all_lists as $p => $listdetails) {
				$listOwner = ($listdetails['ownerid'] == $userid);

				$GLOBALS['CheckBoxOption'] = htmlspecialchars($listdetails['name'], ENT_QUOTES, SENDSTUDIO_CHARSET);
				$GLOBALS['CheckBoxName'] = 'lists[' . $listdetails['listid'] . ']';
				$GLOBALS['CheckBoxChecked'] = '';

				if ($listOwner) {
					$GLOBALS['CheckBoxRowAttribute'] = ' style="display:none;"';
				} else {
					$GLOBALS['CheckBoxRowAttribute'] = '';
				}

				if (in_array($listdetails['listid'], $area_access['lists']) || $listOwner) {
					$GLOBALS['CheckBoxChecked'] = ' CHECKED';
				}
				$list_rows .= $this->ParseTemplate('User_Permission_Option_Option', true, false);
			}
		}
		$GLOBALS['IndividualOption'] = $list_rows;
		$GLOBALS['PrintMailingLists'] = $this->ParseTemplate('User_Permission_Option', true, false);

		$GLOBALS['PrintTemplateAdminList'] = '';
		foreach ($thisuser->GetTemplateAdminTypes() as $option => $desc) {
			$selected = '';
			if ($templateadmin) {
				if ($option == 'a') {
					$selected = ' SELECTED';
				}
			} else {
				if ($option == $templateadmintype) {
					$selected = ' SELECTED';
				}
			}
			$GLOBALS['PrintTemplateAdminList'] .= '<option value="' . $option . '"' . $selected . '>' . GetLang('TemplateAdministratorType_' . $desc) . '</option>';
		}

		if ($templateadmin) {
			$GLOBALS['TemplateDisplay'] = 'none';
		} else {
			$GLOBALS['TemplateDisplay'] = '';
		}

		$template_rows = '';
		if (empty($all_templates)) {
			$GLOBALS['NoOptionAvailable'] = GetLang('NoTemplatesAvailable');
			$template_rows .= $this->ParseTemplate('User_No_Option_Available', true, false);
		} else {
			$GLOBALS['CheckBoxRowAttribute'] = '';
			foreach ($all_templates as $p => $templatedetails) {
				$GLOBALS['CheckBoxOption'] = htmlspecialchars($templatedetails['name'], ENT_QUOTES, SENDSTUDIO_CHARSET);
				$GLOBALS['CheckBoxName'] = 'templates[' . $templatedetails['templateid'] . ']';
				$GLOBALS['CheckBoxChecked'] = '';
				if (in_array($templatedetails['templateid'], $area_access['templates'])) {
					$GLOBALS['CheckBoxChecked'] = ' CHECKED';
				}
				$template_rows .= $this->ParseTemplate('User_Permission_Option_Option', true, false);
			}
		}
		$GLOBALS['IndividualOption'] = $template_rows;
		$GLOBALS['PrintTemplateLists'] = $this->ParseTemplate('User_Permission_Option', true, false);

		$this->ParseTemplate('User_Form');
	}

	/**
	* CheckUserSystem
	* Checks the user system to make sure that this particular user isn't the last user, last active user or last admin user. This just ensures a bit of system integrity.
	*
	* @param Int $userid Userid to check.
	* @param Array $to_check Which areas you want to check. This can be LastActiveUser, LastUser and/or LastAdminUser.
	*
	* @see GetUser
	* @see User_API::LastActiveUser
	* @see User_API::LastUser
	* @see User_API::LastAdminUser
	*
	* @return False|String Returns false if you are not the last 'X', else it returns an error message about why the user can't be edited/deleted.
	*/
	function CheckUserSystem($userid=0, $to_check = array('LastActiveUser', 'LastUser', 'LastAdminUser'))
	{
		$return_error = false;

		$user_system = &GetUser($userid);

		if (in_array('LastActiveUser', $to_check)) {
			if ($user_system->LastActiveUser()) {
				$return_error = GetLang('LastActiveUser');
			}
		}

		if (in_array('LastUser', $to_check)) {
			if (!$return_error && $user_system->LastUser()) {
				$return_error = GetLang('LastUser');
			}
		}

		if (in_array('LastAdminUser', $to_check)) {
			if (!$return_error && $user_system->LastAdminUser()) {
				$return_error = GetLang('LastAdminUser');
			}
		}
		return $return_error;
	}

	/**
	* DeleteUsers
	* Deletes a list of users from the database via the api. Each user is checked to make sure you're not going to accidentally delete your own account and that you're not going to delete the 'last' something (whether it's the last active user, admin user or other).
	* If you aren't an admin user, you can't do anything at all.
	*
	* @param Array $users An array of userid's to delete
	*
	* @see GetUser
	* @see User_API::UserAdmin
	* @see DenyAccess
	* @see CheckUserSystem
	* @see PrintManageUsers
	*
	* @return Void Doesn't return anything. Works out the relevant message about who was/wasn't deleted and prints that out. Returns control to PrintManageUsers.
	*/
	function DeleteUsers($users=array())
	{
		$thisuser = &GetUser();
		if (!$thisuser->UserAdmin()) {
			$this->DenyAccess();
			return;
		}

		if (!is_array($users)) {
			$users = array($users);
		}

		$not_deleted_list = array();
		$not_deleted = $deleted = 0;
		foreach ($users as $p => $userid) {
			if ($userid == $thisuser->Get('userid')) {
				$not_deleted++;
				$not_deleted_list[$userid] = array('username' => $thisuser->Get('username'), 'reason' => GetLang('User_CantDeleteOwn'));
				continue;
			}
			$user = &GetUser($userid);

			$error = $this->CheckUserSystem($userid);
			if (!$error) {
				$result = $user->Delete();
				if ($result) {
					$deleted++;
				} else {
					$not_deleted++;
				}
			} else {
				$not_deleted++;
				$not_deleted_list[$userid] = array('username' => $user->Get('username'), 'reason' => $error);
			}
		}

		$msg = '';

		if ($not_deleted > 0) {
			foreach ($not_deleted_list as $uid => $details) {
				$GLOBALS['Error'] = sprintf(GetLang('UserDeleteFail'), htmlspecialchars($details['username'], ENT_QUOTES, SENDSTUDIO_CHARSET), htmlspecialchars($details['reason'], ENT_QUOTES, SENDSTUDIO_CHARSET));
				$msg .= $this->ParseTemplate('ErrorMsg', true, false);
			}
		}

		if ($deleted > 0) {
			if ($deleted == 1) {
				$msg .= $this->PrintSuccess('UserDeleteSuccess_One') . '<br/>';
			} else {
				$msg .= $this->PrintSuccess('UserDeleteSuccess_Many', $this->FormatNumber($deleted)) . '<br/>';
			}
		}
		$GLOBALS['Message'] = $msg;
		$this->PrintManageUsers();
	}
}

?>
