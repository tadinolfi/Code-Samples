<?php
/**
* This file has the bounce management pages in it.
*
* @version     $Id: bounce.php,v 1.10 2008/03/05 03:00:17 scott Exp $
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
* Class for management of bouncing email addresses.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Bounce extends SendStudio_Functions
{
	/**
	* Suppress Header and Footer for these actions
	*
	* @see Process
	*
	* @var Array
	*/
	var $SuppressHeaderFooter = array('bounce');

	/**
	* EmailsPerRefresh
	* Number of emails to process per refresh.
	*
	* @var Int
	*/
	var $EmailsPerRefresh = 20;

	/**
	* Constructor
	* Loads the language file.
	*
	* @see LoadLanguageFile
	* @see PrintHeader
	* @see PrintFooter
	*
	* @return Void Loads up the language file and adds 'send' as a valid popup window type.
	*/
	function Bounce()
	{
		$this->PopupWindows[] = 'bouncedisplay';
		$this->PopupWindows[] = 'bounce';
		$this->LoadLanguageFile();
	}

	/**
	* Process
	* This works out where you are up to in the bounce process and takes the appropriate action. Most is passed off to other methods in this class for processing and displaying the right forms.
	*
	* @return Void Doesn't return anything.
	*/
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower(urldecode($_GET['Action'])) : null;
		$user = &GetUser();
		$access = $user->HasAccess('Lists', 'Bounce');

		$popup = (in_array($action, $this->PopupWindows)) ? true : false;
		if (!in_array($action, $this->SuppressHeaderFooter)) {
			$this->PrintHeader($popup);
		}

		if (!$access) {
			$this->DenyAccess();
			return;
		}

		$session = &GetSession();

		switch ($action) {
			case 'bouncefinished':
				$this->PrintFinalReport();
			break;

			case 'bouncedisplay':
				$session = &GetSession();
				$bounce_info = $session->Get('BounceInfo');

				$GLOBALS['ProgressTitle'] = GetLang('BounceResults_InProgress');
				$GLOBALS['ProgressMessage'] = sprintf(GetLang('BounceResults_InProgress_Message'), $bounce_info['EmailCount']);
				$GLOBALS['ProgressReport'] = $this->GetStatusReport();
				$GLOBALS['ProgressStatus'] = sprintf(GetLang('BounceResults_InProgress_Progress'), 0, $this->FormatNumber($bounce_info['EmailCount']));
				$GLOBALS['ProgressURLAction'] = 'index.php?Page=Bounce&Action=Bounce';

				$this->ParseTemplate('ProgresReport_Popup');
			break;

			case 'bounce':
				$session = &GetSession();
				$bounce_info = $session->Get('BounceInfo');

				$bounce_api = $this->GetApi('Bounce');

				$bounce_api->Set('bounceserver', $bounce_info['BounceServer']);
				$bounce_api->Set('bounceuser', $bounce_info['BounceUser']);
				$bounce_api->Set('bouncepassword', $bounce_info['BouncePassword']);
				$bounce_api->Set('imapaccount', $bounce_info['IMAPAccount']);
				$bounce_api->Set('extramailsettings', $bounce_info['ExtraMailSettings']);

				$start_position = 1;
				if (isset($_GET['Email'])) {
					$start_position = (int)$_GET['Email'];
				}

				if ($start_position > $bounce_info['EmailCount']) {
					?>
						<script>
							self.parent.parent.location = 'index.php?Page=Bounce&Action=BounceFinished';
						</script>
					<?php
					break;
				}

				$inbox = $bounce_api->Login();

				if (!$inbox) {
					$GLOBALS['Error'] = sprintf(GetLang('BadLogin_Details'), $bounce_api->Get('ErrorMessage'));
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					break;
				}

				for ($bouncecount = 0; $bouncecount < $this->EmailsPerRefresh; $bouncecount++) {
					$emailid = $start_position + $bouncecount;

					if ($emailid > $bounce_info['EmailCount']) {
						$session->Set('BounceInfo', $bounce_info);
						?>
							<script>
								self.parent.parent.location = 'index.php?Page=Bounce&Action=BounceFinished';
							</script>
						<?php
						$bounce_api->Logout();
						exit();
					}

					// Caclulate the percentage completed
					$percentProcessed = ceil(($emailid / $bounce_info['EmailCount'])*100);

					/**
					 * Update status
					 */
						$report = $this->GetStatusReport();
						// Update the status
						echo "<script>\n";
						echo sprintf("self.parent.UpdateStatusReport('%s');", addcslashes($report, "'\";/\\\0..\37!@\177..\377"));
						echo sprintf("self.parent.UpdateStatus('%s', %d);", (sprintf(GetLang('BounceResults_InProgress_Progress'), $emailid, $this->FormatNumber($bounce_info['EmailCount']))), $percentProcessed);
						echo "</script>\n";
						flush();
					/**
					 * -----
					 */

					$processed = $bounce_api->ProcessEmail($emailid, $bounce_info['List']);

					if ($processed == 'hard') {
						$bounce_info['EmailsToDelete'][] = $emailid;
						$bounce_info['Report']['HardBounces']++;
					}

					if ($processed == 'soft') {
						$bounce_info['EmailsToDelete'][] = $emailid;
						$bounce_info['Report']['SoftBounces']++;
					}

					// see api/bounce.php for what 'delete' means.
					if ($processed == 'delete' || ($processed == 'ignore' && $bounce_info['AgreeDeleteAll'] === true)) {
						$bounce_info['EmailsToDelete'][] = $emailid;
						$bounce_info['Report']['EmailsDeleted']++;
					} elseif ($processed == 'ignore') {
						$bounce_info['Report']['EmailsIgnored']++;
					}

					$session->Set('BounceInfo', $bounce_info);
				}
				$bounce_api->Logout();
				$session->Set('BounceInfo', $bounce_info);

				// need to increment emailid because emails actually start counting at 1 not 0.
				// otherwise every $this->perrefresh emails would be processed twice.
				// eg email '20' would be processed twice - which stuffs up reporting....
				?>
					<script defer>
						setTimeout('window.location="index.php?Page=Bounce&Action=Bounce&Email=<?php echo $emailid+1; ?>&bx=<?php echo rand(1,50); ?>;"', 2);
					</script>
				<?php
				exit();
			break;

			case 'step3':
				$bounce_info = $session->Get('BounceInfo');
				$list = $bounce_info['List'];

				$errors = array();
				$Bounce_Server = false;
				if (!isset($_POST['bounce_server']) || $_POST['bounce_server'] == '') {
					$errors[] = GetLang('EnterBounceServer');
				} else {
					$Bounce_Server = $_POST['bounce_server'];
				}

				$Bounce_Username = false;
				if (!isset($_POST['bounce_username']) || $_POST['bounce_username'] == '') {
					$errors[] = GetLang('EnterBounceUsername');
				} else {
					$Bounce_Username = $_POST['bounce_username'];
				}

				$Bounce_Password = false;
				if (!isset($_POST['bounce_password']) || $_POST['bounce_password'] == '') {
					$errors[] = GetLang('EnterBouncePassword');
				} else {
					$Bounce_Password = $_POST['bounce_password'];
				}

				$imap = false;
				if (isset($_POST['bounce_imap']) && $_POST['bounce_imap'] == 1) {
					$imap = true;
				}

				$extramailsettings = false;
				if (isset($_POST['bounce_extraoption']) && $_POST['bounce_extraoption'] == 1) {
					$extramailsettings = $_POST['bounce_extrasettings'];
				}

				$delete_bounce_emails = false;
				$delete_all_emails = false;
				if (!isset($_POST['bounce_agreedelete']) || $_POST['bounce_agreedelete'] != 1) {
					$errors[] = GetLang('AgreeToDelete');
				} else {
					$delete_bounce_emails = true;
					if (isset($_POST['bounce_agreedeleteall']) && $_POST['bounce_agreedeleteall'] == 1) {
						$delete_all_emails = true;
					}
				}

				if (!empty($errors)) {
					$errormsg = implode('<br/>', $errors);
					$this->GetBounceInformation($list, $errormsg);
					break;
				}

				$bounce_api = $this->GetApi('Bounce');
				$bounce_api->Set('bounceserver', $Bounce_Server);
				$bounce_api->Set('bounceuser', $Bounce_Username);
				$bounce_api->Set('bouncepassword', @base64_encode($Bounce_Password));
				$bounce_api->Set('imapaccount', $imap);
				$bounce_api->Set('extramailsettings', $extramailsettings);

				$inbox = $bounce_api->Login();

				if (!$inbox) {
					$this->GetBounceInformation($list, sprintf(GetLang('BadLogin_Details'), $bounce_api->Get('ErrorMessage')));
					break;
				}

				if (isset($_POST['savebounceserverdetails']) && $_POST['savebounceserverdetails']) {
					$list_api = $this->GetApi('Lists');
					$list_api->Load($list);
					$list_api->Set('bounceserver', $Bounce_Server);
					$list_api->Set('bounceusername', $Bounce_Username);
					$list_api->Set('bouncepassword', $Bounce_Password);
					$list_api->Set('imapaccount', $imap);
					$list_api->Set('extramailsettings', $extramailsettings);
					$list_api->Set('processbounce', $delete_bounce_emails);
					$list_api->Set('agreedelete', $delete_bounce_emails);
					$list_api->Set('agreedeleteall', $delete_all_emails);
					$list_api->Save();
					$GLOBALS['Message'] = $this->PrintSuccess('BounceDetailsSaved');
				}

				$emailcount = $bounce_api->GetEmailCount();

				$bounce_api->Logout();

				if ($emailcount <= 0) {
					$this->GetBounceInformation($list, false, 'BounceAccountEmpty');
					break;
				}

				$session = &GetSession();
				$bounce_info = $session->Get('BounceInfo');

				$bounce_info['BounceServer'] = $Bounce_Server;
				$bounce_info['BounceUser'] = $Bounce_Username;
				$bounce_info['BouncePassword'] = base64_encode($Bounce_Password);
				$bounce_info['IMAPAccount'] = $imap;
				$bounce_info['ExtraMailSettings'] = $extramailsettings;
				$bounce_info['AgreeDeleteAll'] = $delete_all_emails;

				$bounce_info['EmailCount'] = $emailcount;

				$bounce_info['EmailsToDelete'] = array();

				$bounce_info['Report']['HardBounces'] = 0;
				$bounce_info['Report']['SoftBounces'] = 0;
				$bounce_info['Report']['EmailsIgnored'] = 0;
				$bounce_info['Report']['EmailsDeleted'] = 0;

				$session->Set('BounceInfo', $bounce_info);

				$this->ParseTemplate('Bounce_Step3');
			break;

			case 'step2':
				$listid = (isset($_POST['list'])) ? (int)$_POST['list'] : (int)$_GET['list'];
				$bounce_info = array('List' => $listid);
				$session->Set('BounceInfo', $bounce_info);
				$this->GetBounceInformation($listid);
			break;

			default:
				if (!function_exists('imap_open')) {
					$GLOBALS['Warning'] = GetLang('Bounce_No_ImapSupport_Intro');
					$GLOBALS['ErrorMessage'] = $this->ParseTemplate('WarningMsg', true);
					$this->ParseTemplate('Bounce_NoImapSupport');
					break;
				}
				$session->Remove('BounceInfo');
				$this->ChooseList('Bounce', 'Step2');
			break;
		}

		if (!in_array($action, $this->SuppressHeaderFooter)) {
			$this->PrintFooter($popup);
		}
	}

	/**
	* GetBounceInformation
	* Obtains the bounce information for a list and prints the form.
	*
	* @param Int $listid The list ID to get bounce information for.
	* @param String|Boolean $errormsg The error message (false if none).
	* @param String|Boolea $warningmsg The warning message (false if none).
	*
	* @return Void Doesn't return anything.
	*/
	function GetBounceInformation($listid, $errormsg=false, $warningmsg=false)
	{
		$listid = (int)$listid;
		if ($listid <= 0) {
			return $this->ChooseList('Bounce', 'Step2');
		}

		$list = $this->GetApi('Lists');
		$loaded = $list->Load($listid);
		if (!$loaded) {
			return $this->ChooseList('Bounce', 'Step2');
		}

		if ($errormsg) {
			$GLOBALS['Error'] = $errormsg;
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
		}

		if ($warningmsg) {
			$GLOBALS['Message'] = $this->PrintWarning($warningmsg);
		}

		$GLOBALS['Bounce_Server'] = $list->bounceserver;
		$GLOBALS['Bounce_Username'] = $list->bounceusername;
		$GLOBALS['Bounce_Password'] = $list->bouncepassword;
		$GLOBALS['Bounce_Imap'] = ($list->imapaccount) ? ' CHECKED' : '';

		$GLOBALS['DisplayExtraMailSettings'] = 'none';
		if ($list->extramailsettings) {
			$GLOBALS['DisplayExtraMailSettings'] = '';
			$GLOBALS['Bounce_ExtraOption'] = ' CHECKED';
			$GLOBALS['Bounce_ExtraSettings'] = $list->extramailsettings;
		}

		if (isset($_POST['Bounce_Server'])) {
			$GLOBALS['BounceServer'] = $_POST['Bounce_Server'];

			$GLOBALS['Bounce_Imap'] = '';
			if (isset($_POST['Bounce_Imap'])) {
				$GLOBALS['Bounce_Imap'] = ' CHECKED';
			}

			if (isset($_POST['Bounce_ExtraOption'])) {
				$GLOBALS['DisplayExtraMailSettings'] = '';
				$GLOBALS['Bounce_ExtraOption'] = ' CHECKED';
				$GLOBALS['Bounce_ExtraSettings'] = $_POST['Bounce_ExtraSettings'];
			} else {
				$GLOBALS['DisplayExtraMailSettings'] = 'none';
				$GLOBALS['Bounce_ExtraOption'] = '';
				$GLOBALS['Bounce_ExtraSettings'] = '';
			}
		}

		if (isset($_POST['Bounce_Username'])) {
			$GLOBALS['Bounce_Username'] = $_POST['Bounce_Username'];
		}

		if (isset($_POST['Bounce_Password'])) {
			$GLOBALS['Bounce_Password'] = $_POST['Bounce_Password'];
		}

		$this->ParseTemplate('Bounce_Step2');
	}

	/**
	* GetStatusReport
	* Grabs the bounce report information from the session.
	*
	* @return String The report in HTML.
	*/
	function GetStatusReport()
	{
		$session = &GetSession();
		$bounceinfo = $session->Get('BounceInfo');

		$report = '';
		foreach (array('HardBounces', 'SoftBounces', 'EmailsIgnored', 'EmailsDeleted') as $pos => $key) {
			$amount = $bounceinfo['Report'][$key];
			if ($amount == 1) {
				$report .= GetLang('BounceResults_InProgress_' . $key . '_One');
			} else {
				$report .= sprintf(GetLang('BounceResults_InProgress_' . $key . '_Many'), $this->FormatNumber($amount));
			}
			$report .= '<br/>';
		}

		return $report;
	}

	/**
	* PrintFinalReport
	* Prints out the report of what's happened.
	* If there are any problems, the item becomes a link the user can click to get more information about what broke and why.
	*
	* @return Void Doesn't return anything, prints out the report only.
	*/
	function PrintFinalReport()
	{
		$session = &GetSession();
		$bounceinfo = $session->Get('BounceInfo');

		$report = '<ul>';

		if ($bounceinfo['EmailCount'] == 1) {
			$report .= '<li>' . GetLang('BounceResults_Message_One') . '</li>';
		} else {
			$report .= '<li>' . sprintf(GetLang('BounceResults_Message_Multiple'), $this->FormatNumber($bounceinfo['EmailCount'])) . '</li>';
		}

		foreach (array('HardBounces', 'SoftBounces', 'EmailsIgnored', 'EmailsDeleted') as $pos => $key) {
			$amount = $bounceinfo['Report'][$key];
			$report .= "<li>";
			if ($amount == 1) {
				$report .= GetLang('BounceResults_' . $key . '_One');
			} else {
				$report .= sprintf(GetLang('BounceResults_' . $key . '_Many'), $this->FormatNumber($amount));
			}
			$report .= '</li>';
		}

		$report .= '</ul>';

		$GLOBALS['Message'] = $this->PrintSuccess('BounceResults_Intro');
		$GLOBALS['Report'] = $report;

		$user = &GetUser();
		if ($user->HasAccess('Statistics', 'List')) {
			$GLOBALS['ListID'] = $bounceinfo['List'];
			$GLOBALS['Statistics_Button'] = $this->ParseTemplate('Bounce_Statistics_Button', true);
		}

		$this->ParseTemplate('Bounce_Results_Report');

		$bounce_api = $this->GetApi('Bounce');

		$bounce_api->Set('bounceserver', $bounceinfo['BounceServer']);
		$bounce_api->Set('bounceuser', $bounceinfo['BounceUser']);
		$bounce_api->Set('bouncepassword', $bounceinfo['BouncePassword']);
		$bounce_api->Set('imapaccount', $bounceinfo['IMAPAccount']);
		$bounce_api->Set('extramailsettings', $bounceinfo['ExtraMailSettings']);
		$inbox = $bounce_api->Login();

		foreach ($bounceinfo['EmailsToDelete'] as $p => $emailid) {
			$bounce_api->DeleteEmail($emailid);
		}
		$bounce_api->Logout(true);
	}

}
?>
