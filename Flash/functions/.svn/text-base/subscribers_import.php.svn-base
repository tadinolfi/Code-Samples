<?php
/**
* This file imports subscribers. It prints out the forms you need to use and that's all it does.
*
* @version     $Id: subscribers_import.php,v 1.64 2008/02/25 23:42:34 chris Exp $
* @author Chris <chris@interspire.com>
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/

/**
* Include the base sendstudio functions.
*/
if (!defined('SENDSTUDIO_BASE_DIRECTORY')) {
	require(dirname(__FILE__) . '/sendstudio_functions.php');
}

ini_set('auto_detect_line_endings', true);

/**
* Class for importing subscribers. This only handles subscriber importing.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Subscribers_Import extends Subscribers
{

	/**
	* PerRefresh
	* The number of subscribers to import at once.
	*
	* @see HandleImportFile
	*
	* @var Int
	*/
	var $PerRefresh = 100;

	/**
	* DefaultFieldEnclosed
	* The default for the "enclosed by" field.
	*
	* @see ImportSubscribers_Step2
	*
	* @var String
	*/
	var $DefaultFieldEnclosed = '';

	/**
	* DefaultFieldSeparator
	* The default for the "field separator" field.
	*
	* @see ImportSubscribers_Step2
	*
	* @var String
	*/
	var $DefaultFieldSeparator = ',';

	/**
	* _ImportTypes An array of different import types. This can be expanded to include more later on quite easily.
	*
	* @see ImportSubscribers_Step2
	*
	* @var array
	*/
	var $_ImportTypes = array('file');

	/**
	* _customfields_loaded
	* An array of custom field objects that have been loaded. This is filled up on the fly once per refresh - each custom field is added to the array once.
	*
	* @see ImportSubscriberLine
	*/
	var $_customfields_loaded = array();

	/**
	* Process
	* Works out what you're trying to do and takes appropriate action.
	* Checks to make sure you have access to import subscribers before anything else.
	*
	* @param String $action Action to perform. This is usually 'step1', 'step2', 'step3' etc. This gets passed in by the Subscribers::Process function.
	*
	* @see Subscribers::Process
	* @see GetUser
	* @see User_API::HasAccess
	* @see ChooseList
	* @see ImportSubscribers_Step2
	* @see FileGetLine
	* @see ImportSubscriberLine
	* @see PrintStatusReport
	* @see LinkFields
	*
	* @return Void Prints out the step, doesn't return anything.
	*/
	function Process($action=null)
	{
		$user = &GetUser();

		$this->PrintHeader(false, false, false);

		if (!is_null($action)) {
			$action = strtolower($action);
		}

		$session = &GetSession();

		switch ($action) {
			case 'view_report':
				$importresults = $session->Get('ImportResults');

				$report_type = (isset($_GET['ReportType'])) ? strtolower($_GET['ReportType']) : null;
				switch ($report_type) {
					case 'duplicates':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Duplicates_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Duplicates_Intro');
						$email_list = '';
						foreach ($importresults['duplicateemails'] as $p => $email) {
							$email_list .= htmlspecialchars(trim($email), ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					case 'unsubscribes':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Unsubscribed_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Unsubscribed_Intro');
						$email_list = '';
						foreach ($importresults['unsubscribedemails'] as $p => $email) {
							$email_list .= htmlspecialchars(trim($email), ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					case 'bans':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Banned_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Banned_Intro');
						$email_list = '';
						foreach ($importresults['bannedemails'] as $p => $email) {
							$email_list .= htmlspecialchars(trim($email), ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					case 'failures':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Failures_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Failures_Intro');
						$email_list = '';
						foreach ($importresults['failedemails'] as $p => $email) {
							$email_list .= htmlspecialchars(trim($email), ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					case 'bads':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Bads_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Bads_Intro');
						$email_list = '';
						foreach ($importresults['baddata'] as $p => $badline) {
							$email_list .= htmlspecialchars($badline, ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					case 'bounces':
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Bounced_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Bounced_Intro');
						$email_list = '';
						foreach ($importresults['bounceemails'] as $p => $email) {
							$email_list .= htmlspecialchars($email, ENT_QUOTES, SENDSTUDIO_CHARSET) . "\n";
						}
						$GLOBALS['EmailList'] = $email_list;
					break;
					default:
						$GLOBALS['Heading'] = GetLang('ImportResults_Report_Invalid_Heading');
						$GLOBALS['Intro'] = GetLang('ImportResults_Report_Invalid_Intro');
						$GLOBALS['EmailList'] = GetLang('InvalidReportURL');
				}
				$this->ParseTemplate('Subscribers_Import_Results_View');
			break;

			case 'step2':
				$listid = (isset($_POST['list'])) ? (int)$_POST['list'] : (int)$_GET['list'];

				/**
				 * Check if user have access to the list
				 */
					$temp = $user->GetLists();
					if (!array($temp) || empty($temp)) {
						$this->DenyAccess();
						return;
					}

					$temp = array_keys($temp);
					if (!in_array($listid, $temp)) {
						$this->DenyAccess();
						return;
					}
				/**
				 * -----
				 */

				$importinfo = array();
				$importinfo['List'] = $listid;
				$session->Set('ImportInfo', $importinfo);
				$importresults = array(
					'duplicates' => 0,
					'success' => 0,
					'updates' => 0,
					'failures' => 0,
					'unsubscribes' => 0,
					'bans' => 0,
					'bads' => 0,
					'bounces' => 0,
					'duplicateemails' => array(),
					'unsubscribedemails' => array(),
					'failedemails' => array(),
					'bannedemails' => array(),
					'baddata' => array(),
					'bounceemails' => array()
				);
				$session->Set('ImportResults', $importresults);
				$this->ImportSubscribers_Step2();
			break;

			case 'step3':
				if (empty($_POST)) {
					$this->ImportSubscribers_Step2(GetLang('FileNotUploadedSuccessfully_TooBig'));
					break;
				}
				$importinfo = $session->Get('ImportInfo');
				$importinfo['Status'] = $_POST['status'];
				$importinfo['Confirmed'] = $_POST['confirmed'];
				$importinfo['Format'] = $_POST['format'];
				$importinfo['Type'] = $_POST['importtype'];
				$importinfo['Overwrite'] = (isset($_POST['overwrite'])) ? 1 : 0;
				$importinfo['Autoresponder'] = (isset($_POST['autoresponder'])) ? 1 : 0;
				$importinfo['Headers'] = (isset($_POST['headers'])) ? 1 : 0;
				$importinfo['FieldEnclosed'] = (isset($_POST['fieldenclosed'])) ? $_POST['fieldenclosed'] : false;
				$importinfo['FieldSeparator'] = $_POST['fieldseparator'];

				$session->Set('ImportInfo', $importinfo);

				$upload_status = false;

				switch (strtolower($importinfo['Type'])) {
					case 'file':
						$upload_status = $this->HandleImportFile();
					break;
				}
				if ($upload_status) {
					$this->LinkFields();
				}
			break;

			case 'step4':
				$emailcheck = false;
				$linkfields = $_POST['LinkField'];
				foreach ($linkfields as $id => $type) {
					if ($type == 'E') {
						$emailcheck = true;
						break;
					}
				}

				if (!$emailcheck) {
					$GLOBALS['Error'] = GetLang('EmailAddressNotLinked');
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					$this->LinkFields();
					break;
				}

				$importinfo = $session->Get('ImportInfo');
				$importinfo['LinkFields'] = $linkfields;
				$session->Set('ImportInfo', $importinfo);

				$GLOBALS['ImportTotalSubscribers'] = $importinfo['TotalSubscribers'];
				$GLOBALS['ImportTotalSubscribersMessage'] = $this->PrintStatusReport(true);
				$this->ParseTemplate('Subscribers_Import_Step4');
			break;

			case 'importiframe':
				$this->PrintHeader(false, false, false);

				$importresults = $session->Get('ImportResults');
				$importinfo = $session->Get('ImportInfo');

				$report = '';
				foreach (array('success', 'updates', 'duplicates', 'failures', 'bans', 'unsubscribes', 'bads', 'bounces') as $pos => $key) {
					$amount = $importresults[$key];
					if ($amount == 1) {
						$report .= GetLang('ImportSubscribers_InProgress_' . $key . '_One');
					} else {
						$report .= sprintf(GetLang('ImportSubscribers_InProgress_' . $key . '_Many'), $this->FormatNumber($importresults[$key]));
					}
					$report .= '<br/>';
				}

				$GLOBALS['ProgressTitle'] = GetLang('ImportResults_InProgress');
				$GLOBALS['ProgressMessage'] = sprintf(GetLang('ImportResults_InProgress_Message'), $this->FormatNumber($importinfo['TotalSubscribers']));
				$GLOBALS['ProgressReport'] = $report;
				$GLOBALS['ProgressURLAction'] = 'index.php?Page=Subscribers&Action=Import&SubAction=Import';

				$this->ParseTemplate('ProgresReport_Popup');
				$this->PrintFooter(true);
			break;

			case 'import':
				$totalProcessed = null;
				$percentProcessed = 0;

				$importinfo = $session->Get('ImportInfo');
				$subscriber_info = false;

				switch (strtolower($importinfo['Type'])) {
					case 'file':
							$filename = array_shift($importinfo['FileList']);
							$subscriber_info = $this->FileGetLine(TEMP_DIRECTORY . "/{$filename}", true);

							if (is_file(TEMP_DIRECTORY . '/' . $filename)) {
								unlink(TEMP_DIRECTORY . '/' . $filename);
							}

					break;
				}

				$db = IEM::getDatabase();

				$session->Set('ImportInfo', $importinfo);

				if ($subscriber_info) {
					foreach ($subscriber_info as $pos => $details) {

						$importresults = $session->Get('ImportResults');

						if ($importinfo['Headers'] && $details == $importinfo['ImportList']) {
							// we don't want to import the headers!
							continue;
						}

						if (sizeof($details) != sizeof($importinfo['ImportList'])) {
							if (sizeof($details) > sizeof($importinfo['ImportList'])) {
								$importresults['bads']++;
								$importresults['baddata'][] = implode($importinfo['FieldSeparator'], $details) . GetLang('InvalidSubscriberImportLine_TooMany');
							} else {
								$importresults['bads']++;
								$importresults['baddata'][] = implode($importinfo['FieldSeparator'], $details) . GetLang('InvalidSubscriberImportLine_NotEnough');
							}
							$session->Set('ImportResults', $importresults);
							continue;
						}
						$db->StartTransaction();
						$this->ImportSubscriberLine($details);
						$db->CommitTransaction();

						// ----- Calculate total records processed so far
							if (is_null($totalProcessed)) {
								$totalProcessed = 0;
								foreach (array('success', 'updates', 'duplicates', 'failures', 'bans', 'unsubscribes', 'bads', 'bounces') as $key) {
									$totalProcessed += $importresults[$key];
								}
							} else {
								++$totalProcessed;
							}
						// -----

						// Caclulate the percentage completed
						$percentProcessed = ceil(($totalProcessed / $importinfo['TotalSubscribers'])*100);

						// ----- Prepare report
							$report = '<ul>';
							foreach (array('success', 'updates', 'duplicates', 'failures', 'bans', 'unsubscribes', 'bads', 'bounces') as $pos => $key) {
								$amount = $importresults[$key];
								$report .= '<li>';
								if ($amount == 1) {
									$report .= GetLang('ImportSubscribers_InProgress_' . $key . '_One');
								} else {
									$report .= sprintf(GetLang('ImportSubscribers_InProgress_' . $key . '_Many'), $this->FormatNumber($importresults[$key]));
								}
								$report .= '</li>';
							}
							$report .= '</ul>';
						// -----

						// Update the status
						echo "<script>\n";
						echo sprintf("self.parent.UpdateStatusReport('%s');", addcslashes($report, "'\";/\\\0..\37!@\177..\377"));
						echo sprintf("self.parent.UpdateStatus('%s', %d);", '', $percentProcessed);
						echo "</script>\n";
						flush();
					}

					?>
						<script defer>
							setTimeout('window.location="index.php?Page=Subscribers&Action=Import&SubAction=Import&x=<?php echo rand(1,50); ?>;"', 10);
						</script>
					<?php

					exit();
				}

				?>
					<script>
						self.parent.parent.location = 'index.php?Page=Subscribers&Action=Import&SubAction=PrintReport';
					</script>
				<?php

				exit();
			break;

			case 'printreport':
				$this->PrintFinalReport();
			break;
			
			case 'chooselist':
				$esig = isset($_REQUEST['agreetoterms']) ? mysql_real_escape_string($_REQUEST['agreetoterms']) : null;
				if(!is_null($esig) && $esig != '')
				{
					$db = IEM::getDatabase();
					$query = "INSERT INTO ss_import_agreements (userid, eSignature, timestamp) VALUES ('$user->userid', '$esig', UNIX_TIMESTAMP())";
					$db->Query($query);
					$this->ChooseList('Import', 'Step2');
				} else {
					$this->ParseTemplate("import_permission");
				}
			break;

			default:
				$this->ParseTemplate("import_permission");
			break;
		}
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
		$importresults = $session->Get('ImportResults');
		$importinfo = $session->Get('ImportInfo');
		$report = '<ul class="importresult_list">';

		foreach (array('success', 'updates') as $pos => $key) {
			$amount = $importresults[$key];
			if($amount > 0)
			{
				$report .= "<li><img src='images/checkmark.gif' border='0' /><span>";
				if ($amount == 1) {
					$report .= GetLang('ImportSubscribers_' . $key . '_One');
				} else {
					$report .= sprintf(GetLang('ImportSubscribers_' . $key . '_Many'), $this->FormatNumber($importresults[$key]));
				}
				$report .= '</span></li>';
			}
		}

		foreach (array('duplicates', 'unsubscribes', 'bans', 'bads', 'failures', 'bounces') as $pos => $key) {
			if (!is_array($importresults[$key])) {
				$amount = $importresults[$key];
			} else {
				$amount = sizeof($importresults[$key]);
			}

			if ($amount > 0) {
				$report .= "<li><img src='images/checkmark.gif' border='0' /><span>";
				if ($amount == 1) {
					$report .= sprintf(GetLang('ImportSubscribers_' . $key . '_One_Link'), $key);
				} else {
					$report .= sprintf(GetLang('ImportSubscribers_' . $key . '_Many_Link'), $this->FormatNumber($amount), $key);
				}
				$report .= '</span></li>';
			} else {
				//$report .= sprintf(GetLang('ImportSubscribers_' . $key . '_Many'), $this->FormatNumber($amount));
			}
			
		}

		$report .= "</ul>";

		$GLOBALS['Message'] = $this->PrintSuccess('ImportResults_Intro');
		$GLOBALS['Report'] = $report;

		$this->ParseTemplate('Subscribers_Import_Results_Report');

		// make sure there are no other import files lying around from this attempt.
		if (isset($importinfo['Filename'])) {
			if (is_file(TEMP_DIRECTORY . '/' . $importinfo['Filename'])) {
				unlink(TEMP_DIRECTORY . '/' . $importinfo['Filename']);
			}
		}
		if (isset($importinfo['FileList'])) {
			foreach ($importinfo['FileList'] as $p => $filename) {
				if (is_file(TEMP_DIRECTORY . '/' . $filename)) {
					unlink(TEMP_DIRECTORY . '/' . $filename);
				}
			}
		}
	}

	/**
	* HandleImportFile
	* Uploads the file and breaks it up into little chunks. If the file wasn't uploaded properly or it can't be read, or it can't be broken up it takes you back a step and prints an error message. It sets some info in the session so it can be used for statistics.
	*
	* @see ImportSubscribers_Step2
	* @see GetSession
	* @see Session::Get
	* @see FileGetLine
	* @see Session::Set
	*
	* @return Void Doesn't return anything. If there is a problem it will take you back a step and print the reason why. If it worked ok it will set session variables and continue.
	*/
	function HandleImportFile()
	{
		$newfilename = '';
		$fromlocal = false;

		if (isset($_POST['useserver']) && $_POST['useserver']) {
			$newfilename = $_POST['serverfile'];
			$fromlocal = true;

			if (!is_file(SENDSTUDIO_IMPORT_DIRECTORY . "/{$newfilename}")) {
				$this->ImportSubscribers_Step2(GetLang('ImportFile_ServerFileDoesNotExist'));
				return false;
			}
		} else {
			if (!is_uploaded_file($_FILES['importfile']['tmp_name'])) {
				$this->ImportSubscribers_Step2(GetLang('FileNotUploadedSuccessfully'));
				return false;
			}

			while (true) {
				$newfilename = 'import-' . md5(uniqid(rand(), true) . SENDSTUDIO_LICENSEKEY);
				if (!is_file(TEMP_DIRECTORY . '/' . $newfilename)) {
					break;
				}
			}

			$uploadstatus = move_uploaded_file($_FILES['importfile']['tmp_name'], TEMP_DIRECTORY . '/' . $newfilename);
			if (!$uploadstatus) {
				$this->ImportSubscribers_Step2(GetLang('FileNotUploadedSuccessfully'));
				return false;
			}
		}

		$session = &GetSession();
		$importinfo = $session->Get('ImportInfo');
		$importinfo['Filename'] = $newfilename;
		$importinfo['FromLocal'] = $fromlocal;

		$topline = $this->FileGetLine((($fromlocal? SENDSTUDIO_IMPORT_DIRECTORY : TEMP_DIRECTORY) . "/{$newfilename}"), false);
		if (!$topline) {
			$this->ImportSubscribers_Step2(GetLang('FileNotUploadedSuccessfully'));
			return false;
		}

		$file_num = 1;
		$linecount = 1;

		$lines = array();
		$filelist = array();

		$fp = fopen((($fromlocal? SENDSTUDIO_IMPORT_DIRECTORY : TEMP_DIRECTORY) . "/{$newfilename}"), 'r');
		while (!feof($fp)) {
			$line = fgets($fp, 10240);
			if (($linecount % $this->PerRefresh) == 0) {
				$broken_filename = $newfilename . '.file.' . $file_num;
				$broken_filename_handle = fopen(TEMP_DIRECTORY . '/' . $broken_filename, 'w');
				fputs($broken_filename_handle, implode("", $lines));
				fclose($broken_filename_handle);

				array_push($filelist, $broken_filename);

				$lines = array();
				$file_num++;
			}
			$linecount++;
			$lines[] = $line;
		}

		if (!empty($lines)) {
			$file_num++;
			$broken_filename = $newfilename . '.file.' . $file_num;
			$broken_filename_handle = fopen(TEMP_DIRECTORY . '/' . $broken_filename, 'w');
			fputs($broken_filename_handle, implode("", $lines));
			fclose($broken_filename_handle);

			array_push($filelist, $broken_filename);
		}

		$topline = $topline[0];

		/**
		 * Since the linecount started at 1, we need to take one off
		 * as the first line in the imported file then becomes "linecount=2".
		 *
		 * We can't start at linecount=0 as this will cause an extra empty file to be written.
		 * Instead, just decrement the counter here.
		 */
		$linecount--;

		$importinfo['ImportList'] = $topline;
		$importinfo['FileList'] = $filelist;
		$importinfo['TotalSubscribers'] = $linecount;
		if ($importinfo['Headers']) {
			/**
			 * if there are headers, don't include them here - the first line will be another 'non-subscriber' entry.
			 */
			$importinfo['TotalSubscribers']--;
		}

		$session->Set('ImportInfo', $importinfo);
		return true;
	}

	/**
	* LinkFields
	* Prints out the 'link fields' page which allows you to map field name (from a CSV or database) to subscriber field in the database.
	*
	* @see GetSession
	* @see Session::Get
	* @see GetApi
	* @see Lists_API::GetCustomFields
	*
	* @return Void Prints out the form, doesn't return anything.
	*/
	function LinkFields()
	{
		$session = &GetSession();
		$importinfo = $session->Get('ImportInfo');

		$field_list = array();
		$field_list['N'] = GetLang('None');
		$field_list['E'] = GetLang('SubscriberEmailaddress');
		$field_list['F'] = GetLang('SubscriberFormat');
		$field_list['C'] = GetLang('SubscriberConfirmed');
		$field_list['SD_DMY'] = GetLang('SubscribeDate_DMY');
		$field_list['SD_MDY'] = GetLang('SubscribeDate_MDY');
		$field_list['SD_YMD'] = GetLang('SubscribeDate_YMD');

		if (SENDSTUDIO_IPTRACKING) {
			$field_list['IP'] = GetLang('SubscriberIPAddress');
		}

		$listApi = $this->GetApi('Lists');
		$listid = $importinfo['List'];
		$customfields = $listApi->GetCustomFields($listid);

		foreach ($customfields as $pos => $details) {
			$name = $details['name'];
			// work out the date format from the custom field and put it at the end of the field name.
			if ($details['fieldtype'] == 'date') {
				$name .= ' (';
				$settings = unserialize($details['fieldsettings']);
				foreach ($settings['Key'] as $k => $v) {
					if ($k > 3) {
						break;
					}
					switch ($v) {
						case 'day':
							$name .= 'dd/';
						break;
						case 'month':
							$name .= 'mm/';
						break;
						case 'year':
							$name .= 'yyyy/';
						break;
					}
				}
				$name = substr($name, 0, -1) . ')';
			}
			$field_list[$details['fieldid']] = $name;
		}

		$importlist = $importinfo['ImportList'];

		$fieldlist_output = '';
		$linkfield = 0;
		foreach ($importlist as $pos => $option) {
			$GLOBALS['FieldName'] = htmlspecialchars($option, ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['OptionName'] = 'LinkField[' . $linkfield . ']';
			$optionlist = '';
			foreach ($field_list as $val => $opt) {
				$selected = '';
				if ($importinfo['Headers'] && strtolower(trim($opt)) == strtolower(trim($option))) {
					$selected = ' SELECTED';
				}
				$optionlist .= '<option value="' . $val . '" ' . $selected . '>' . htmlspecialchars($opt, ENT_QUOTES, SENDSTUDIO_CHARSET) . '</option>';
			}
			$GLOBALS['OptionList'] = $optionlist;
			$linkfield++;

			$GLOBALS['HLP_MappingOption'] = $this->_GenerateMapTip($option);
			$fieldlist_output .= $this->ParseTemplate('Subscribers_Import_Step3_Options', true, false);
		}
		$GLOBALS['ImportFieldList'] = $fieldlist_output;
		$this->ParseTemplate('Subscribers_Import_Step3');
	}

	/**
	* ImportSubscribers_Step2
	* Prints out step 2 of importing subscribers where you choose the type you're importing from, the "enclosed by", "separator" fields etc.
	*
	* @param Mixed $msg If there is a message passed in, it will print that message and then print out the form.
	*
	* @see GetSession
	* @see Session::Get
	* @see GetApi
	* @see Lists_API::Load
	* @see Lists_API::GetListFormat
	* @see _getImportFileOptions
	*
	* @return Void Prints out the form, doesn't return anything.
	*/
	function ImportSubscribers_Step2($msg=false)
	{

		$GLOBALS['fieldenclosed'] = $this->DefaultFieldEnclosed;
		$GLOBALS['fieldseparator'] = $this->DefaultFieldSeparator;

		if ($msg) {
			$GLOBALS['Error'] = $msg;
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);

			if (isset($_POST['FieldEnclosed'])) {
				$GLOBALS['fieldenclosed'] = $_POST['FieldEnclosed'];
			}

			if (isset($_POST['FieldSeparator'])) {
				$GLOBALS['fieldseparator'] = $_POST['FieldSeparator'];
			}
		}

		$session = &GetSession();
		$importinfo = $session->Get('ImportInfo');

		$importtypes = '';
		foreach ($this->_ImportTypes as $pos => $importtype) {
			$importtypes .= '<option value="' . $importtype . '">' . GetLang('Import_From_' . $importtype) . '</option>';
		}
		$GLOBALS['ImportTypes'] = $importtypes;

		$listApi = $this->GetApi('Lists');
		$listApi->Load($importinfo['List']);
		$listformat = $listApi->GetListFormat();

		$importinfo['ListFormat'] = $listformat;
		$session->Set('ImportInfo', $importinfo);

		switch ($listformat) {
			case 't':
				$format = '<option value="t" SELECTED>' . GetLang('Format_Text') . '</option>';
			break;
			case 'h':
				$format = '<option value="h" SELECTED>' . GetLang('Format_HTML') . '</option>';
			break;
			case 'b':
				$format = '<option value="h" SELECTED>' . GetLang('Format_HTML') . '</option>';
				$format .= '<option value="t">' . GetLang('Format_Text') . '</option>';
			break;
		}
		$GLOBALS['ListFormats'] = $format;

		// if we're not running a recent version of php, don't show the "enclosed by" field at all.
		// will save some confusion!
		$phpversion = phpversion();
		$version_check = version_compare($phpversion, '4.3.0');
		if ($version_check < 0) {
			$GLOBALS['ShowFieldEnclosed'] = 'none';
		}
		
		$GLOBALS['ShowFieldEnclosed'] = 'none';
		

		
		$user = &GetUser();

		if ($user->HasAccess('Autoresponders')) {
			$GLOBALS['ShowAutoresponderImport'] = '';
		}
		
		$GLOBALS['ShowAutoresponderImport'] = 'none';

		// Get file list (ie scan directory) for uploaded import file
		$GLOBALS['fieldServerFiles'] = $this->_getImportFileOptions(SENDSTUDIO_IMPORT_DIRECTORY);

		$this->ParseTemplate('Subscribers_Import_Step2');
	}

	/**
	* FileGetLine
	* Gets a line from the filename passed in. If you prefer, it can read in the whole file instead.
	*
	* @param String $filename Filename to read from.
	* @param Boolean $wholefile Whether to read in the whole file or just the first line. By default it reads in the whole file.
	*
	* @see GetSession
	* @see Session::Get
	* @see GetApi
	* @see Lists_API::Load
	* @see Lists_API::GetListFormat
	*
	* @return Mixed Returns false if there is no filename supplied, if the file doesn't exist or if it can't be opened. Otherwise it returns an array - either with the whole file's contents or just the first line.
	*/
	function FileGetLine($filename=false, $wholefile=true)
	{
		if (!$filename) {
			return false;
		}

		if (!is_file($filename)) {
			return false;
		}

		$fp = fopen($filename, 'r');
		if (!$fp) {
			return false;
		}

		$session = &GetSession();
		$importinfo = $session->Get('ImportInfo');

		$length = filesize($filename) + 1;

		$filecontents = array();

		if ($importinfo['FieldSeparator'] == 'TAB') {
			$importinfo['FieldSeparator'] = "\t";
		}

		if (!empty($importinfo['FieldEnclosed'])) {
			while (($line = fgetcsv($fp, $length, $importinfo['FieldSeparator'], $importinfo['FieldEnclosed'])) !== false) {
				$filecontents[] = $line;
				if (!$wholefile) {
					break;
				}
			}
		} else {
			while (($line = fgetcsv($fp, $length, $importinfo['FieldSeparator'])) !== false) {
				$filecontents[] = $line;
				if (!$wholefile) {
					break;
				}
			}
		}
		fclose($fp);
		return $filecontents;
	}

	/**
	* ImportSubscriberLine
	* Imports a subscriber and sets appropriate customfield variables (if it needs to). Only handles one subscriber at a time.
	*
	* @param Array $subscriberinfo An array of the subscriber info to import. This includes format, confirmed status, custom field info.
	*
	* @see GetApi
	* @see Subscribers_API::IsDuplicate
	* @see Subscribers_API::UpdateEmailAddress
	* @see Subscribers_API::SubscriberExists
	* @see Subscribers_API::Create
	* @see Customfields_API::Load
	* @see Customfields_API::LoadSubField
	* @see _customfields_loaded
	* @see GetSession
	* @see Session::Get
	* @see Session::Set
	* @see _saveCustomFields
	*
	* @return Void Doesn't return anything, updates statistics in the session.
	*/
	function ImportSubscriberLine($subscriberinfo=array())
	{
		$user = &GetUser();
		$session = &GetSession();
		$importinfo = $session->Get('ImportInfo');

		$importresults = $session->Get('ImportResults');

		$importlist = $importinfo['ImportList'];
		$linkfields = $importinfo['LinkFields'];

		$list = $importinfo['List'];

		$subscriberformat = $importinfo['Format'];
		$subscriberconfirmed = strtolower($importinfo['Confirmed']);

		$email = '';
		$format = $subscriberformat;
		$confirmed = $subscriberconfirmed;

		$sd_m = $sd_d = $sd_y = 0;

		$customfields = array();

		$found_subscribedate = false;

		$subscriber_ip = '';

		foreach ($linkfields as $pos => $type) {
			switch ($type) {
				case 'E':
					$email = $subscriberinfo[$pos];
				break;
				case 'C':
					$subscriberconfirmed = strtolower($subscriberinfo[$pos]);
				break;
				case 'F':
					$format = strtolower($subscriberinfo[$pos]);
				break;
				case 'N':
				break;
				case 'SD_MDY':
					if (substr_count($subscriberinfo[$pos], '/') == 2) {
						$found_subscribedate = true;
						list($sd_m, $sd_d, $sd_y) = explode('/', $subscriberinfo[$pos]);
					}
				break;

				case 'SD_DMY':
					if (substr_count($subscriberinfo[$pos], '/') == 2) {
						$found_subscribedate = true;
						list($sd_d, $sd_m, $sd_y) = explode('/', $subscriberinfo[$pos]);
					}
				break;

				case 'SD_YMD':
					if (substr_count($subscriberinfo[$pos], '/') == 2) {
						$found_subscribedate = true;
						list($sd_y, $sd_m, $sd_d) = explode('/', $subscriberinfo[$pos]);
					}
				break;

				case 'IP':
					$subscriber_ip = $subscriberinfo[$pos];
				break;

				default:
					$customfields[$type] = $subscriberinfo[$pos];
			}
		}

		$valid_subscribedate = false;
		$subscribedate = 0;

		if ($found_subscribedate && $sd_y >= 0 && $sd_m >= 0 && $sd_d >= 0) {
			$valid_subscribedate = checkdate($sd_m, $sd_d, $sd_y);

			if ($valid_subscribedate) {
				$subscribedate = AdjustTime(array(0, 0, 1, $sd_m, $sd_d, $sd_y), true);
			} else {
				$subscriberinfo[] = GetLang('InvalidSubscribeDate');
				$importresults['bads']++;
				$importresults['baddata'][] = implode($importinfo['FieldSeparator'], $subscriberinfo);
			}
		}

		$SubscriberApi = $this->GetApi('Subscribers');

		if (!$SubscriberApi->ValidEmail($email)) {
			$subscriberinfo[] = GetLang('InvalidSubscriberEmailAddress');
			$importresults['bads']++;
			$importresults['baddata'][] = implode($importinfo['FieldSeparator'], $subscriberinfo);
			$session->Set('ImportResults', $importresults);
			return;
		}

		list($banned, $msg) = $SubscriberApi->IsBannedSubscriber($email, $list, false);
		if ($banned) {
			$importresults['bans']++;
			$importresults['bannedemails'][] = $email;
			$session->Set('ImportResults', $importresults);
			return;
		}
		
		//Check bounced
		
		$bounced = $SubscriberApi->CheckBounce($email, (int)$user->userid);
		if($bounced)
		{
			$subscriberinfo[] = GetLang('InvalidSubscriberBounce');
			$importresults['bounces']++;
			$importresults['bounceemails'][] = implode($importinfo['FieldSeparator'], $subscriberinfo);
			$session->Set('ImportResults', $importresults);
			return;
		}
	
		$SubscriberApi->emailaddress = $email;

		$SubscriberApi->Set('subscribedate', $subscribedate);
		$SubscriberApi->Set('confirmdate', $subscribedate);

		$listapi = $this->GetApi('Lists');
		$CustomFieldApi = $this->GetApi('CustomFields');

		$CustomFieldsValid = true;

		foreach ($customfields as $fieldid => $fielddata) {
			/**
			* See if we have loaded this custom field yet or not.
			* If we haven't then load it up.
			*
			* If we have, then use that instead for the checkdata calls.
			*
			* Doing it this way saves a lot of db queries/overhead especially with lots of custom fields.
			*/
			if (!in_array($fieldid, array_keys($this->_customfields_loaded))) {
				$field_options = $CustomFieldApi->Load($fieldid, false, true);
				$subfield = $CustomFieldApi->LoadSubField($field_options);
				$this->_customfields_loaded[$fieldid] = $subfield;
			}

			$subf = $this->_customfields_loaded[$fieldid];

			$fieldtype = $subf->Get('fieldtype');
			if ($fieldtype == 'checkbox') {
				if (strpos($fielddata, ':') !== false) {
					$fielddata = explode(':', $fielddata);
				}
				if (strpos($fielddata, ',') !== false) {
					$fielddata = explode(',', $fielddata);
				}
				$fielddata = $subf->CheckData($fielddata, true);
				$customfields[$fieldid] = $fielddata;
			}

			if ($subf->IsRequired() && ($fielddata == '' || !$subf->CheckData($fielddata))) {
				$subscriberinfo[] = sprintf(GetLang('InvalidCustomFieldData'), $subf->GetFieldName());
				$importresults['bads']++;
				$importresults['baddata'][] = implode($importinfo['FieldSeparator'], $subscriberinfo);
				$CustomFieldsValid = false;
				break;
			}

			if ($fieldtype == 'date') {
				$fielddata = $subf->CheckData($fielddata, true);
				$customfields[$fieldid] = $fielddata;
			}
		}

		if (!$CustomFieldsValid) {
			$session->Set('ImportResults', $importresults);
			return;
		}

		if ($format == 'html') {
			$format = 'h';
		}

		if ($format == 'text') {
			$format = 't';
		}

		if ($format != 'h' && $format != 't') {
			$format = $importinfo['Format'];
		}

		// if the list doesn't accept both formats, force them to use the list format.
		if ($importinfo['ListFormat'] != 'b') {
			$format = $importinfo['ListFormat'];
		}

		$SubscriberApi->format = $format;

		$confirmstatus = false;
		if ($subscriberconfirmed == 'yes' || $subscriberconfirmed == 'confirmed' || $subscriberconfirmed == '1') {
			$confirmstatus = true;
		}

		$SubscriberApi->confirmed = $confirmstatus;

		if ($confirmstatus == true) {
			$SubscriberApi->Set('confirmip', $subscriber_ip);
		} else {
			$SubscriberApi->Set('requestip', $subscriber_ip);
		}

		$subscribercheck = $SubscriberApi->IsDuplicate($email, $list);

		if ($subscribercheck) {
			$unsubscribe_check = $SubscriberApi->IsUnSubscriber($email, 0, 0, $user->userid);
			if (!$unsubscribe_check) {
				if ($importinfo['Overwrite']) {
					$SubscriberApi->UpdateEmailAddress($subscribercheck);
					$SubscriberApi->UpdateList($subscribercheck, $list);
					$result = $this->_SaveCustomFields($SubscriberApi, $subscribercheck, $customfields, $email, $importresults);
					if (!$result) {
						return;
					}
					if ($importinfo['Autoresponder']) {
						$SubscriberApi->AddToListAutoresponders($subscribercheck, $list);
					}
					$importresults['updates']++;
				} else {
					$importresults['duplicates']++;
					$importresults['duplicateemails'][] = $email;
				}
			} else {
				$importresults['unsubscribes']++;
				$importresults['unsubscribedemails'][] = $email;
			}
		} else {
			$subscriberid = $SubscriberApi->AddToList($email, $list, $importinfo['Autoresponder'], true);

			if (!$subscriberid) {
				$importresults['failures']++;
				$importresults['failedemails'][] = $email;
			} else {
				$result = $this->_SaveCustomFields($SubscriberApi, $subscriberid, $customfields, $email, $importresults);
				if (!$result) {
					return;
				}
				$importresults['success']++;
			}
		}

		$session->Set('ImportResults', $importresults);
	}

	/**
	* PrintStatusReport
	* Prints out the status report of what we're importing. So we can quickly see how many successful imports, updated subscribers, duplicate subscribers found, failures etc.
	*
	* @see GetSession
	* @see Session::Get
	*
	* @param Boolean $return Specify whether or not to return the report instead of printing it (Optional, default FALSE - print to screen)
	*
	* @return Void|String Depending on the parameter, it will either print out the report and return nothing or return the report as a string
	*/
	function PrintStatusReport($return = false)
	{
		$session = &GetSession();
		$importresults = $session->Get('ImportResults');
		$importinfo = $session->Get('ImportInfo');

		$GLOBALS['ImportResults_Message'] = sprintf(GetLang('ImportResults_InProgress_Message'), $this->FormatNumber($importinfo['TotalSubscribers']));

		$report = '';
		foreach (array('success', 'updates', 'duplicates', 'failures', 'bans', 'unsubscribes', 'bads') as $pos => $key) {
			$amount = $importresults[$key];
			if ($amount == 1) {
				$report .= GetLang('ImportSubscribers_InProgress_' . $key . '_One');
			} else {
				$report .= sprintf(GetLang('ImportSubscribers_InProgress_' . $key . '_Many'), $this->FormatNumber($importresults[$key]));
			}
			$report .= '<br/>';
		}
		$GLOBALS['Report'] = $report;

		$temp = $this->ParseTemplate('Subscribers_Import_ReportProgress', $return);
		return $temp;
	}

	/**
	* _GenerateMapTip
	* Generates a help tip specifically for import mapping of fields.
	*
	* @param String $fieldname The name of the field you want to appear in the helptip.
	*
	* @see LinkFields
	* @see GetRandomId
	*
	* @return String The help tip that is generated.
	*/
	function _GenerateMapTip($fieldname=false)
	{
		$rand = $this->GetRandomId();

		$tiptitle = GetLang('MappingOption');

		$tipname = sprintf(GetLang('HLP_MappingOption'), $fieldname);

		$helptip = '<img onMouseOut="HideHelp(\'' . $rand . '\');" onMouseOver="ShowHelp(\'' . $rand . '\', \'' . $tiptitle . '\', \'' . $tipname . '\');" src="images/help.gif" width="24" height="16" border="0"><div style="display:none" id="' . $rand . '"></div>';
		return $helptip;
	}

	/**
	 * Get import file HTML Options
	 *
	 * This method will scan given directory,
	 * and put the files as HTML Options
	 *
	 * @param String $directory The directory to scan
	 * @return String Returns HTML Options
	 *
	 * @access private
	 */
	function _getImportFileOptions($directory)
	{
		if (!is_dir($directory)) {
			return '';
		}
		$dh = @opendir($directory);
		if ($dh === false) {
			return '';
		}
		$html = '';
		while (($file = readdir($dh)) !== false)
			if (is_file("{$directory}/{$file}") && is_readable("{$directory}/{$file}")) {
				$html .= '<option value="'.$file.'">'.$file.'</option>';
		}
		closedir($dh);
		return $html;
	}

	/**
	 * _SaveCustomFields
	 * Loops through the imported custom fields for a subscribers and saves them.
	 *
	 * @param Object $SubscriberApi The Subscriber API with the existing subscriber details loaded.
	 * @param Int $subscriberid The ID of the existing or new subscriber.
	 * @param Array $customfields An array of imported custom field IDs and values.
	 * @param String $email The email address trying to be imported.
	 * @param Array $importresults The running tally of import results.
	 *
	 * @uses GetSession
	 * @uses Subscribers_API::SaveSubscriberCustomField
	 * @uses Session::Set
	 *
	 * @return Boolean True if the custom field settings were saved succesfully, otherwise false.
	 */
	function _SaveCustomFields($SubscriberApi, $subscriberid, $customfields, $email, $importresults)
	{
		$session = &GetSession();
		$info = '';
		foreach ($customfields as $fieldid => $fielddata) {
			if (!$SubscriberApi->SaveSubscriberCustomField($subscriberid, $fieldid, $fielddata)) {
				// This fix is for PostgreSQL (see bugid:2548).
				// If saving here failed it probably means the character set data is invalid for
				// the database. This also means we may not be able to successfully output the
				// bad data in the 'more information' box, so we'll just use the email address to
				// identify the record.
				$subf = $this->_customfields_loaded[$fieldid];
				$info .= $email . ' ' . sprintf(GetLang('InvalidCustomFieldData'), $subf->GetFieldName());
				$importresults['bads']++;
				$importresults['baddata'][] = $info;
				$session->Set('ImportResults', $importresults);
				return false;
			}
		}
		return true;
	}
}

?>
