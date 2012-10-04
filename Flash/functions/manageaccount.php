<?php
/**
* This file has the user editing forms in it if you can only manage your own account.
*
* @version     $Id: manageaccount.php,v 1.26 2008/02/01 08:02:36 hendri Exp $
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
* Class for the manage-own-account page.
* Handles permission checks, making sure you only update certain aspects of your account (email, password, name)
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class ManageAccount extends SendStudio_Functions
{

	/**
	* PopupWindows
	* An array of popup windows used in this class. Used to work out what sort of header and footer to print.
	*
	* @see Process
	*
	* @var Array
	*/
	var $PopupWindows = array('sendpreviewdisplay', 'sendpreview','testgooglecalendar');

	/**
	* Constructor
	* Loads up the "Users" and "Timezones" language file.
	*
	* @see LoadLanguageFile
	*
	* @return Void Doesn't return anything.
	*/
	function ManageAccount()
	{
		$this->LoadLanguageFile('Users');
		$this->LoadLanguageFile('Timezones');
	}


	/**
	* Process
	* Lets a user manage their own account - to a certain extent.
	* The API itself manages saving and updating, this just works out displaying of forms etc.
	*
	* @see PrintHeader
	* @see ParseTemplate
	* @see GetSession
	* @see Session::Get
	* @see IEM::getDatabase()
	* @see GetUser
	* @see User_API::Set
	* @see GetLang
	* @see PrintEditForm
	* @see PrintFooter
	*
	* @return Void Doesn't return anything, hands the processing off to the appropriate subarea and lets it do the work.
	*/
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower($_GET['Action']) : '';

		if (!in_array($action, $this->PopupWindows)) {
			$this->PrintHeader();
		}

		$session = &GetSession();
		$user = &$session->Get('UserDetails');
		$db = IEM::getDatabase();

		switch ($action) {
		case 'save':
				if (!$user->EditOwnSettings()) {
					$GLOBALS['ErrorMessage'] = GetLang('NoAccess');
					$this->ParseTemplate('AccessDenied');
					return;
				}

				$smtptype = 0;
				if ($user->HasAccess('User', 'SMTP')) {
					$smtptype = (isset($_POST['smtptype'])) ? $_POST['smtptype'] : 0;
				}

				// Make sure smtptype is eiter 0 or 1
				if ($smtptype != 1) {
					$smtptype = 0;
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

				/**
				 * This was added, because User's API uses different names than of the HTML form names.
				 * HTML form names should stay the same to keep it consistant throught the application
				 *
				 * This will actually map HTML forms => User's API fields
				 */
					$areaMapping = array(
						'fullname' => 'fullname',
						'emailaddress' => 'emailaddress',
						'usertimezone' => 'usertimezone',
						'companyname' => 'companyname',
						'companyaddress1' => 'companyaddress1',
						'companyaddress2' => 'companyaddress2',
						'companycity' => 'companycity',
						'companystate' => 'companystate',
						'companypostcode' => 'companypostcode',
						'infotips' => 'infotips',
						'usewysiwyg' => 'usewysiwyg',
						'enableactivitylog' => 'enableactivitylog',
						'usexhtml' => 'usexhtml',
						'googlecalendarusername' => 'googlecalendarusername',
						'googlecalendarpassword' => 'googlecalendarpassword'
					);

					if ($user->HasAccess('User', 'SMTP')) {
						$areaMapping['smtp_server'] = 'smtpserver';
						$areaMapping['smtp_u'] = 'smtpusername';
						$areaMapping['smtp_p'] = 'smtppassword';
						$areaMapping['smtp_port'] = 'smtpport';
					}

					foreach ($areaMapping as $p => $area) {
						$val = (isset($_POST[$p])) ? $_POST[$p] : '';
						$user->Set($area, $val);
					}
				/**
				 * -----
				 */

				if ($user->HasAccess('User', 'SMTP')) {
					if ($smtptype == 0) {
						$user->Set('smtpserver', '');
						$user->Set('smtpusername', '');
						$user->Set('smtppassword', '');
						$user->Set('smtpport', 0);
					}
				}

				$error = false;
				$template = false;

				if (!$error) {
					if ($_POST['ss_p'] != '') {
						if ($_POST['ss_p_confirm'] != '' && $_POST['ss_p_confirm'] == $_POST['ss_p']) {
							$user->Set('password', $_POST['ss_p']);
						} else {
							$error = GetLang('PasswordsDontMatch');
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

				$userid = $user->Get('userid');
				$new_user = &GetUser($userid);
				$session->Set('UserDetails', $new_user);

				$this->PrintEditForm($userid);
			break;

			case 'sendpreviewdisplay':
				$this->PrintHeader(true);
				$this->SendTestPreviewDisplay('index.php?Page=ManageAccount&Action=SendPreview', 'self.parent.getSMTPPreviewParameters()');
				$this->PrintFooter(true);
			break;

			case 'sendpreview':
				$this->SendTestPreview();
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

			default:
				$userid = $user->userid;
				$this->PrintEditForm($userid);
			break;
		}

		if (!in_array($action, $this->PopupWindows)) {
			$this->PrintFooter();
		}
	}


	/**
	* PrintEditForm
	* Prints the editing form for the userid passed in.
	* If the user doesn't have access to edit their details, it will only display them.
	* Also makes sure that the user doesn't try to edit another users' details.
	*
	* @param Int $userid UserID to show the form for. This will load up the user and use their details as the defaults.
	*
	* @see GetSession
	* @see Session::Get
	* @see User_API::Admin
	* @see GetLang
	* @see GetUser
	*
	* @return Void Doesn't return anything, prints out the appropriate form and that's it.
	*/
	function PrintEditForm($userid=0)
	{
		$session = &GetSession();
		$thisuser = $session->Get('UserDetails');
		if (!$thisuser->Admin()) {
			if ($userid != $thisuser->userid) {
				$GLOBALS['ErrorMessage'] = GetLang('NoAccess');
				$this->ParseTemplate('AccessDenied');
				return false;
			}
		}

		$user = &GetUser($userid);

		$activity = $user->GetEventActivityType();
		if (!is_array($activity)) {
			$activity = array();
		}
		$GLOBALS['EventActivityType'] = implode("\n", $activity);

		$GLOBALS['UserID'] = $user->userid;
		$GLOBALS['UserName'] = $user->username;
		$GLOBALS['FullName'] = $user->fullname;
		$GLOBALS['EmailAddress'] = $user->emailaddress;
		$GLOBALS['CompanyName'] = $user->Get('companyname');
		$GLOBALS['CompanyAddress1'] = $user->Get('companyaddress1');
		$GLOBALS['CompanyAddress2'] = $user->Get('companyaddress2');
		$GLOBALS['CompanyCity'] = $user->Get('companycity');
		$GLOBALS['StateList'] = $user->GetStatesList($user->Get('companystate'));
		$GLOBALS['CompanyPostCode'] = $user->Get('companypostcode');
		

		$GLOBALS['CustomSmtpServer_Display'] = '0';

		if ($user->HasAccess('User', 'SMTP')) {
			$GLOBALS['SmtpServer'] = $user->Get('smtpserver');
			$GLOBALS['SmtpUsername'] = $user->Get('smtpusername');
			$GLOBALS['SmtpPassword'] = $user->Get('smtppassword');
			$GLOBALS['SmtpPort'] = $user->Get('smtpport');
			$smtp_access = true;
		} else {
			$GLOBALS['SmtpServer'] = '';
			$GLOBALS['SmtpUsername'] = '';
			$GLOBALS['SmtpPassword'] = '';
			$GLOBALS['SmtpPort'] = '';
			$smtp_access = false;
		}

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
		
		if ($user->Get('permonth') > 0)
		{
			$GLOBALS['ShowCreditPurchaseTab'] = 'none';
		}

		$GLOBALS['UseXHTMLCheckbox'] = $user->Get('usexhtml')? ' CHECKED' : '';

		$GLOBALS['FormAction'] = 'Action=Save&UserID=' . $user->userid;

		$timezone = $user->usertimezone;
		$GLOBALS['TimeZoneList'] = $this->TimeZoneList($timezone);

		$GLOBALS['InfoTipsChecked'] = ($user->InfoTips()) ? ' CHECKED' : '';

		if ($smtp_access && $user->HasAccess('User', 'SMTPCOM')) {
		} else {
			$GLOBALS['ShowSMTPCOMOption'] = 'none';
		}
		$GLOBALS['googlecalendarusername'] = $user->googlecalendarusername;
		$GLOBALS['googlecalendarpassword'] = $user->googlecalendarpassword;

		if ($thisuser->EditOwnSettings()) {
			$this->ParseTemplate('User_Edit_Own');
		} else {
			$this->ParseTemplate('User_Display_Own');
		}
	}
}
