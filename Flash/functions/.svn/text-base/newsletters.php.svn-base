<?php
/**
* This file has the newsletters page in it. This allows you to manage your newsletters, send and so on.
*
* @version     $Id: newsletters.php,v 1.77 2008/02/21 00:48:59 chris Exp $
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
* Class for management of newsletters.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Newsletters extends SendStudio_Functions
{
	/**
	 * A list of actions that will have header and footer suppressed
	 * @var Array
	 */
	var $SuppressHeaderFooter = array('checkspam', 'sendpreview', 'preview', 'viewcompatibility');

	/**
	* ValidSorts
	* An array of sorts you can use with newsletter management.
	*
	* @var Array
	*/
	var $ValidSorts = array('name', 'createdate', 'subject', 'owner');

	/**
	* Constructor
	* Loads the language file and adds "sendpreview" to the safe popup window list. This is used by the header/footer to work out which ones to print out.
	*
	* @see LoadLanguageFile
	* @see PrintHeader
	* @see PrintFooter
	*
	* @return Void Doesn't return anything.
	*/
	function Newsletters()
	{
		$this->PopupWindows[] = 'sendpreviewdisplay';
		$this->PopupWindows[] = 'checkspamdisplay';
		$this->PopupWindows[] = 'viewcompatibility';
		$this->LoadLanguageFile();
	}

	/**
	* Process
	* This handles working out what stage you are up to and so on with workflow.
	* It handles creating, editing, deleting, copying etc.
	* It also uses the session to remember what you've done (eg chosen a text newsletter) so it only has to do one update at a time rather than doing everything separately.
	*
	* @see GetSession
	* @see Session::Get
	* @see Session::Set
	* @see GetUser
	* @see User_API::HasAccess
	* @see PrintHeader
	* @see GetApi
	* @see Newsletter_API::Load
	* @see Newsletter_API::GetBody
	* @see Newsletter_API::Copy
	* @see Newsletter_API::Create
	* @see Newsletter_API::Save
	* @see Newsletter_API::Delete
	* @see ManageNewsletters
	* @see PreviewWindow
	* @see MoveFiles
	* @see CreateNewsletter
	* @see DisplayEditNewsletter
	* @see EditNewsletter
	*
	* Doesn't return anything, handles processing (with the api) and prints out the results.
	*/
	function Process()
	{
		$GLOBALS['Message'] = '';

		$action = (isset($_GET['Action'])) ? strtolower(urldecode($_GET['Action'])) : null;
		$user = &GetUser();

		$check_access = $action;
		$secondary_actions = array('activate', 'deactivate', 'activatearchive', 'deactivatearchive');
		if (in_array($check_access, $secondary_actions)) {
			$check_access = 'approve';
		}

		// with 'change' actions, each separate action is checked further on, so we'll just check they can manage anything in this area.
		if (in_array($action, array('change', 'checkspam', 'viewcompatibility', 'processpaging', 'sendpreview', 'preview'))) {
			$check_access = 'manage';
		}

		$access = $user->HasAccess('newsletters', $check_access);


		$popup = (in_array($action, $this->PopupWindows)) ? true : false;
		if (!in_array($action, $this->SuppressHeaderFooter)) {
			$this->PrintHeader($popup);
		}

		if (!$access) {
			if (!$popup) {
				$this->DenyAccess();
				return;
			}
		}

		$session = &GetSession();


		/**
		 * Check user permissions to determine if the user can access this newsletter
		 */
			$tempAPI = null;
			$tempCheckActions = array('change', 'checkspam', 'viewcompatibility', 'processpaging', 'sendpreview', 'view', 'preview', 'edit', 'send', 'delete', 'copy', 'update');
			$tempID = null;

			if (isset($_GET['id'])) {
				$tempID = $_GET['id'];
			} elseif(isset($_POST['newsletters'])) {
				$tempID = $_POST['newsletters'];
			}

			if (!is_null($tempID)) {
				$_GET['id'] = $tempID;
				$_POST['newsletters'] = $tempID;

				if (!$user->Admin() && in_array($action, $tempCheckActions)) {
					if (!is_array($tempID)) {
						$tempID = array($tempID);
					}

					$tempAPI = $this->GetApi();

					foreach ($tempID as $tempEachID) {
						$tempEachID = intval($tempEachID);
						if ($tempEachID == 0) {
							continue;
						}

						if (!$tempAPI->Load($tempEachID)) {
							continue;
						}

						if ($tempAPI->ownerid != $user->userid) {
							$this->DenyAccess();
							return;
						}
					}
				}
			}

			unset($tempID);
			unset($tempCheckActions);
			unset($tempAPI);
		/**
		 * -----
		 */

		if ($action == 'processpaging') {
			$this->SetPerPage($_GET['PerPageDisplay']);
			$action = '';
		}

		switch ($action) {
			case 'viewcompatibility':
				$session = &GetSession();
				$newsletter_info = $session->Get('Newsletters');

				$html = (isset($_POST['myDevEditControl_html'])) ? $_POST['myDevEditControl_html'] : false;
				$text = (isset($_POST['TextContent'])) ? $_POST['TextContent'] : false;
				$showBroken = isset($_REQUEST['ShowBroken']) && $_REQUEST['ShowBroken'] == 1;
				$details = array();
				$details['htmlcontent'] = $html;
				$details['textcontent'] = $text;
				$details['format'] = $newsletter_info['Format'];

				$this->PreviewWindow($details, $showBroken);
				exit;
			break;

			case 'checkspamdisplay':
				$this->CheckContentForSpamDisplay();
			break;

			case 'checkspam':
				$this->CheckContentForSpam();
			break;

			case 'activate':
			case 'deactivate':
			case 'activatearchive':
			case 'deactivatearchive':
				$id = (int)$_GET['id'];
				$newsletterapi = $this->GetApi();
				$newsletterapi->Load($id);

				$message = '';

				if ($user->HasAccess('newsletters', 'approve')) {
					switch ($action) {
						case 'activatearchive':
							$newsletterapi->Set('archive', 1);
							if (!$newsletterapi->Active()) {
								$GLOBALS['Error'] = GetLang('NewsletterCannotBeInactiveAndArchive');
								$message .= $this->ParseTemplate('ErrorMsg', true, false);
							}
							$message .= $this->PrintSuccess('NewsletterArchive_ActivatedSuccessfully');
						break;
						case 'deactivatearchive':
							$newsletterapi->Set('archive', 0);
							$message .= $this->PrintSuccess('NewsletterArchive_DeactivatedSuccessfully');
						break;
						case 'activate':
							$allow_attachments = $this->CheckForAttachments($id, 'newsletters');
							if ($allow_attachments) {
								$newsletterapi->Set('active', $user->Get('userid'));
								$message .= $this->PrintSuccess('NewsletterActivatedSuccessfully');
							} else {
								$GLOBALS['Error'] = GetLang('NewsletterActivateFailed_HasAttachments');
								$message .= $this->ParseTemplate('ErrorMsg', true, false);
							}
						break;
						default:
							$newsletterapi->Set('active', 0);
							if ($newsletterapi->Archive()) {
								$GLOBALS['Error'] = GetLang('NewsletterCannotBeInactiveAndArchive');
								$message .= $this->ParseTemplate('ErrorMsg', true, false);
							}
							$message .= $this->PrintSuccess('NewsletterDeactivatedSuccessfully');
						}
					$newsletterapi->Save();

					$GLOBALS['Message'] = $message;
				}
				$this->ManageNewsletters();
			break;

			case 'sendpreviewdisplay':
				$this->SendPreviewDisplay();
			break;

			case 'sendpreview':
				$this->SendPreview();
			break;

			case 'delete':
				$id = (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
				$newsletters = array($id);
				$this->DeleteNewsletters($newsletters);
			break;

			case 'view':
				$id = (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
				$type = strtolower(get_class($this));
				$newsletter = $this->GetApi();
				if (!$newsletter->Load($id)) {
					break;
				}

				// Log this to "User Activity Log"
				IEM::logUserActivity($_SERVER['REQUEST_URI'], 'images/newsletters_view.gif', $newsletter->name);

				$details = array();
				$details['htmlcontent'] = $newsletter->GetBody('HTML');
				$details['textcontent'] = $newsletter->GetBody('Text');
				$details['format'] = $newsletter->format;

				$this->PreviewWindow($details);
				exit;
			break;

			case 'preview':
				$id = $this->_getGETRequest('id', 0);
				$type = strtolower(get_class($this));
				$newsletter = $this->GetApi();
				if (!$newsletter->Load($id)) {
					break;
				}

				$details = array();
				$details['htmlcontent'] = $newsletter->GetBody('HTML');
				$details['textcontent'] = $newsletter->GetBody('Text');
				$details['format'] = $newsletter->format;

				$this->PreviewWindow($details, false, $id);
				exit;
			break;

			case 'copy':
				$id = (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
				$api = $this->GetApi();
				list($newsletter_result, $files_copied) = $api->Copy($id);
				if (!$newsletter_result) {
					$GLOBALS['Error'] = GetLang('NewsletterCopyFail');
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
				} else {
					$changed = false;
					// check the permissions.
					// if we can't make archive a newsletter, disable this aspect of it.
					if (!$user->HasAccess('Newsletters', 'Approve')) {
						$changed = true;
						$api->Set('archive', 0);
					}

					// if we can't approve newsletters, then make sure we disable it.
					if (!$user->HasAccess('Newsletters', 'Approve')) {
						$changed = true;
						$api->Set('active', 0);
					}

					if ($changed) {
						$api->Save();
					}
					$GLOBALS['Message'] = $this->PrintSuccess('NewsletterCopySuccess');
					if (!$files_copied) {
						$GLOBALS['Error'] = GetLang('NewsletterFilesCopyFail');
						$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
					}
				}
				$this->ManageNewsletters();
			break;

			case 'edit':
				$session = &GetSession();
				$newsletter = $this->GetApi();

				$id = (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
				$newsletter->Load($id);

				$subaction = (isset($_GET['SubAction'])) ? strtolower(urldecode($_GET['SubAction'])) : '';
				switch ($subaction) {
					case 'step2':
						$editnewsletter = array('id' => $id);

						$checkfields = array('Name', 'Format');
						$valid = true; $errors = array();
						foreach ($checkfields as $p => $field) {
							if (!isset($_REQUEST[$field])) {
								$valid = false;
								$errors[] = GetLang('Newsletter'.$field.'IsNotValid');
								break;
							}
							if ($_REQUEST[$field] == '') {
								$valid = false;
								$errors[] = GetLang('Newsletter'.$field.'IsNotValid');
								break;
							} else {
								$value = urldecode($_REQUEST[$field]);
								$editnewsletter[$field] = $value;
							}
						}
						if (!$valid) {
							$GLOBALS['Error'] = GetLang('UnableToUpdateNewsletter') . '<br/>- ' . implode('<br/>- ',$errors);
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->EditNewsletter($id);
							break;
						}

						$session->Set('Newsletters', $editnewsletter);
						$this->DisplayEditNewsletter($id);
					break;

					case 'save':
					case 'complete':
						$user = $session->Get('UserDetails');
						$session_newsletter = $session->Get('Newsletters');

						$text_unsubscribelink_found = true;
						$html_unsubscribelink_found = true;

						if (isset($_POST['TextContent'])) {
							$textcontent = $_POST['TextContent'];
							if($_POST['textHeaderContent'] != '')
								$textcontent = $_POST['textHeaderContent'].chr(10).'-----'.chr(10).$textcontent;
							if($_POST['textFooterContent'] != '')
								$textcontent = $textcontent.chr(10).'-----'.chr(10).$_POST['textFooterContent'];
							$newsletter->SetBody('Text', $textcontent);
							$text_unsubscribelink_found = $this->CheckForUnsubscribeLink($textcontent, 'text');
							$session_newsletter['contents']['text'] = $textcontent;
						}

						if (isset($_POST['myDevEditControl_html'])) {
							$htmlcontent = $_POST['myDevEditControl_html'];

							/**
							 * This is an effort not to overwrite the eixsting HTML contents
							 * if there isn't any contents in it (DevEdit will have '<html><body></body></html>' as a minimum
							 * that will be passed to here)
							 */
							if($_POST['htmlHeaderContent'] != '')
							{
								$htmlparts = array();
								$bodyopenstart = strpos($htmlcontent,'<body');
								$bodyopenend = strpos($htmlcontent,'>',$bodyopenstart) + 1;
								$bodytag = substr($htmlcontent,$bodyopenstart,($bodyopenend-$bodyopenstart));
								$htmlparts[0] = substr($htmlcontent,0,$bodyopenstart);
								$htmlparts[1] = substr($htmlcontent,$bodyopenend);
								$htmlheader = str_replace('%%headeralign%%',$_POST['headeralignment'],$_POST['htmlHeaderContent']);
								$htmlcontent = $htmlparts[0].$bodytag.chr(10).'<!--Section-->'.chr(10).$htmlheader.chr(10).'<!--Section-->'.chr(10).$htmlparts[1];
							}
							if($_POST['htmlFooterContent'] != '')
							{
								$htmlparts = explode('</body>',$htmlcontent);
								$htmlfooter = str_replace('%%footeralign%%', $_POST['footeralignment'],$_POST['htmlFooterContent']);
								$htmlcontent = $htmlparts[0].chr(10).'<!--Section-->'.chr(10).$htmlfooter.chr(10).'<!--Section-->'.chr(10).'</body>'.$htmlparts[1];
							}
							
							if (trim($htmlcontent) == '') {
								$GLOBALS['Error'] = GetLang('UnableToUpdateNewsletter');
								$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
								$this->DisplayEditNewsletter($id);
								break;
							}

							$newsletter->SetBody('HTML', $htmlcontent);
							$html_unsubscribelink_found = $this->CheckForUnsubscribeLink($htmlcontent, 'html');
							$session_newsletter['contents']['html'] = $htmlcontent;
						}

						if (isset($_POST['subject'])) {
							$newsletter->Set('subject', $_POST['subject']);
						}

						foreach (array('Name', 'Format') as $p => $area) {
							$newsletter->Set(strtolower($area), $session_newsletter[$area]);
						}

						$newsletter->Set('active', 0);
						if ($user->HasAccess('newsletters', 'approve')) {
							if (isset($_POST['active'])) {
								$newsletter->Set('active', $user->Get('userid'));
							}
						}
						
						
						$newsletter->Set('archive', 0);

						if (isset($_POST['archive'])) {
							$newsletter->Set('archive', 1);
						}

						$dest = strtolower(get_class($this));
						$movefiles_result = $this->MoveFiles($dest, $id);
						if ($movefiles_result) {
							if (isset($textcontent)) {
								$textcontent = $this->ConvertContent($textcontent, $dest, $id);
								$newsletter->SetBody('Text', $textcontent);
							}
							if (isset($htmlcontent)) {
								$htmlcontent = $this->ConvertContent($htmlcontent, $dest, $id);
								$newsletter->SetBody('HTML', $htmlcontent);
							}
						}

						$result = $newsletter->Save();

						if (!$result) {
							$GLOBALS['Error'] = GetLang('UnableToUpdateNewsletter');
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->ManageNewsletters();
							break;
						}

						$newsletter_info = $session_newsletter;
						$newsletter_info['embedimages'] = true;
						$newsletter_info['multipart'] = true;

						list($newsletter_size, $newsletter_img_warnings) = $this->GetSize($newsletter_info);

						if (SENDSTUDIO_ALLOW_EMBEDIMAGES) { $size_message = GetLang('Newsletter_Size_Approximate'); }
						else { $size_message = GetLang('Newsletter_Size_Approximate_Noimages'); }
						$GLOBALS['Message'] = $this->PrintSuccess('NewsletterUpdated', sprintf($size_message, $this->EasySize($newsletter_size)));

						if (SENDSTUDIO_EMAILSIZE_WARNING > 0) {
							$warning_size = SENDSTUDIO_EMAILSIZE_WARNING * 1024;
							if ($newsletter_size > $warning_size) {
								$GLOBALS['Message'] .= $this->PrintWarning('Newsletter_Size_Over_EmailSize_Warning', $this->EasySize($warning_size));
							}
						}

						// Delete any attachments we're meant to first
						list($del_attachments_status, $del_attachments_status_msg) = $this->CleanupAttachments($dest, $id);

						if ($del_attachments_status) {
							if ($del_attachments_status_msg) {
								$GLOBALS['Success'] = $del_attachments_status_msg;
								$GLOBALS['Message'] .= $this->ParseTemplate('SuccessMsg', true, false);
							}
						} else {
							$GLOBALS['Error'] = $del_attachments_status_msg;
							$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
						}

						// Only save the new attachments after deleting the old ones
						list($attachments_status, $attachments_status_msg) = $this->SaveAttachments($dest, $id);

						if ($attachments_status) {
							if ($attachments_status_msg != '') {
								$GLOBALS['Success'] = $attachments_status_msg;
								$GLOBALS['Message'] .= $this->ParseTemplate('SuccessMsg', true, false);
							}
						} else {
							$GLOBALS['Error'] = $attachments_status_msg;
							$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
						}

						if (!$newsletter->Active() && isset($_POST['archive'])) {
							$GLOBALS['Error'] = GetLang('NewsletterCannotBeInactiveAndArchive');
							$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
						}

						if ($newsletter_img_warnings) {
							$GLOBALS['Message'] .= $this->PrintWarning('UnableToLoadImage_Newsletter_List', $newsletter_img_warnings);
						}

						if (!$html_unsubscribelink_found) {
							$GLOBALS['Message'] .= $this->PrintWarning('NoUnsubscribeLinkInHTMLContent');
						}

						if (!$text_unsubscribelink_found) {
							$GLOBALS['Message'] .= $this->PrintWarning('NoUnsubscribeLinkInTextContent');
						}

						$GLOBALS['Message'] = str_replace('<br><br>', '<br>', $GLOBALS['Message']);

						($subaction == 'save') ? $this->DisplayEditNewsletter($id) : $this->ManageNewsletters();
					break;

					default:
					case 'step1':
						$this->EditNewsletter($id);
					break;
				}
			break;

			case 'create':
				$session = &GetSession();

				$subaction = (isset($_GET['SubAction'])) ? strtolower(urldecode($_GET['SubAction'])) : '';

				switch ($subaction) {
					case 'step2':
						$newnewsletter = array();
						$checkfields = array('Name', 'Format');
						$valid = true; $errors = array();
						foreach ($checkfields as $p => $field) {
							if ($_POST[$field] == '') {
								$valid = false;
								$errors[] = GetLang('Newsletter'.$field.'IsNotValid');
								break;
							} else {
								$value = $_POST[$field];
								$newnewsletter[$field] = $value;
							}
						}
						if (!$valid) {
							$GLOBALS['Error'] = GetLang('UnableToCreateNewsletter') . '<br/>- ' . implode('<br/>- ',$errors);
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->CreateNewsletter();
							break;
						}
						if (isset($_POST['TemplateID'])) {
							$newnewsletter['TemplateID'] = $_POST['TemplateID'];
						}
						$session->Set('Newsletters', $newnewsletter);
						$this->DisplayEditNewsletter();
					break;

					case 'save':
					case 'complete':
						$user = $session->Get('UserDetails');
						$session_newsletter = $session->Get('Newsletters');

						$newnewsletter = $this->GetApi();

						$text_unsubscribelink_found = true;
						$html_unsubscribelink_found = true;

						if (isset($_POST['TextContent'])) {
							$textcontent = $_POST['TextContent'];
							if($_POST['textHeaderContent'] != '')
								$textcontent = $_POST['textHeaderContent'].chr(10).'-----'.chr(10).$textcontent;
							if($_POST['textFooterContent'] != '')
								$textcontent = $textcontent.chr(10).'-----'.chr(10).$_POST['textFooterContent'];
							$newnewsletter->SetBody('Text', $textcontent);
							$text_unsubscribelink_found = $this->CheckForUnsubscribeLink($textcontent, 'text');
							$session_newsletter['contents']['text'] = $textcontent;
						}

						if (isset($_POST['myDevEditControl_html'])) {
							$htmlcontent = $_POST['myDevEditControl_html'];
							if($_POST['htmlHeaderContent'] != '')
							{
								$htmlparts = array();
								$bodyopenstart = strpos($htmlcontent,'<body');
								$bodyopenend = strpos($htmlcontent,'>',$bodyopenstart) + 1;
								$bodytag = substr($htmlcontent,$bodyopenstart,($bodyopenend-$bodyopenstart));
								$htmlparts[0] = substr($htmlcontent,0,$bodyopenstart);
								$htmlparts[1] = substr($htmlcontent,$bodyopenend);
								$htmlheader = str_replace('%%headeralign%%',$_POST['headeralignment'],$_POST['htmlHeaderContent']);
								$htmlcontent = $htmlparts[0].$bodytag.chr(10).'<!--Section-->'.chr(10).$htmlheader.chr(10).'<!--Section-->'.chr(10).$htmlparts[1];
							}
							if($_POST['htmlFooterContent'] != '')
							{
								$htmlparts = explode('</body>',$htmlcontent);
								$htmlfooter = str_replace('%%footeralign%%', $_POST['footeralignment'],$_POST['htmlFooterContent']);
								$htmlcontent = $htmlparts[0].chr(10).'<!--Section-->'.chr(10).$htmlfooter.chr(10).'<!--Section-->'.chr(10).'</body>'.$htmlparts[1];
							}
							$newnewsletter->SetBody('HTML', $htmlcontent);
							$html_unsubscribelink_found = $this->CheckForUnsubscribeLink($htmlcontent, 'html');
							$session_newsletter['contents']['html'] = $htmlcontent;
						}

						if (isset($_POST['subject'])) {
							$newnewsletter->Set('subject', $_POST['subject']);
						}

						foreach (array('Name', 'Format') as $p => $area) {
							$newnewsletter->Set(strtolower($area), $session_newsletter[$area]);
						}

						$newnewsletter->Set('active', 0);
						if ($user->HasAccess('newsletters', 'approve')) {
							if (isset($_POST['active'])) {
								$newnewsletter->Set('active', $user->Get('userid'));
							}
						}

						$newnewsletter->Set('archive', 0);
						if (isset($_POST['archive'])) {
							$newnewsletter->Set('archive', 1);
						}

						$newnewsletter->ownerid = $user->userid;
						$result = $newnewsletter->Create();

						if (!$result) {
							$GLOBALS['Error'] = GetLang('UnableToCreateNewsletter');
							$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
							$this->ManageNewsletters();
							break;
						}

						$newsletter_info = $session_newsletter;
						$newsletter_info['embedimages'] = true;
						$newsletter_info['multipart'] = true;

						list($newsletter_size, $newsletter_img_warnings) = $this->GetSize($newsletter_info);

						if (SENDSTUDIO_ALLOW_EMBEDIMAGES) { $size_message = GetLang('Newsletter_Size_Approximate'); }
						else { $size_message = GetLang('Newsletter_Size_Approximate_Noimages'); }
						$GLOBALS['Message'] = $this->PrintSuccess('NewsletterUpdated', sprintf($size_message, $this->EasySize($newsletter_size)));

						if (SENDSTUDIO_EMAILSIZE_WARNING > 0) {
							$warning_size = SENDSTUDIO_EMAILSIZE_WARNING * 1024;
							if ($newsletter_size > $warning_size) {
								$GLOBALS['Message'] .= $this->PrintWarning('Newsletter_Size_Over_EmailSize_Warning', $this->EasySize($warning_size));
							}
						}

						$dest = strtolower(get_class($this));

						$movefiles_result = $this->MoveFiles($dest, $result);

						if ($movefiles_result) {
							if (isset($textcontent)) {
								$textcontent = $this->ConvertContent($textcontent, $dest, $result);
								$newnewsletter->SetBody('Text', $textcontent);
							}
							if (isset($htmlcontent)) {
								$htmlcontent = $this->ConvertContent($htmlcontent, $dest, $result);
								$newnewsletter->SetBody('HTML', $htmlcontent);
							}
						}
						$newnewsletter->Save();

						list($attachments_status, $attachments_status_msg) = $this->SaveAttachments($dest, $result);

						if ($attachments_status) {
							if ($attachments_status_msg != '') {
								$GLOBALS['Success'] = $attachments_status_msg;
								$GLOBALS['Message'] .= $this->ParseTemplate('SuccessMsg', true, false);
							}
						} else {
							$GLOBALS['Error'] = $attachments_status_msg;
							$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
						}

						if (!$newnewsletter->Active() && isset($_POST['archive'])) {
							$GLOBALS['Error'] = GetLang('NewsletterCannotBeInactiveAndArchive');
							$GLOBALS['Message'] .= $this->ParseTemplate('ErrorMsg', true, false);
						}

						if ($newsletter_img_warnings) {
							$GLOBALS['Message'] .= $this->PrintWarning('UnableToLoadImage_Newsletter_List', $newsletter_img_warnings);
						}

						if (!$html_unsubscribelink_found) {
							$GLOBALS['Message'] .= $this->PrintWarning('NoUnsubscribeLinkInHTMLContent');
						}

						if (!$text_unsubscribelink_found) {
							$GLOBALS['Message'] .= $this->PrintWarning('NoUnsubscribeLinkInTextContent');
						}

						$GLOBALS['Message'] = str_replace('<br><br>', '<br>', $GLOBALS['Message']);

						if ($subaction == 'save') {
							$this->DisplayEditNewsletter($result);
						} else {
							$this->ManageNewsletters();
						}
					break;

					default:
						$this->CreateNewsletter();
				}
			break;

			case 'addnewsletter':
				$newsletter = $this->GetApi();
				$session = &GetSession();
				$user = $session->Get('UserDetails');

				$valid = true; $errors = array();
				if (!$valid) {
					$GLOBALS['Error'] = GetLang('UnableToCreateNewsletter') . '<br/>- ' . implode('<br/>- ',$errors);
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					$this->CreateNewsletter();
					break;
				}

				$newsletter->ownerid = $user->userid;

				$create = $newsletter->Create();
				if (!$create) {
					$GLOBALS['Error'] = GetLang('UnableToCreateNewsletter');
					$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
					$this->CreateNewsletter();
				} else {
					$GLOBALS['Message'] = $this->PrintSuccess('NewsletterCreated');
					$this->EditNewsletter($create);
				}
			break;

			case 'change':
				$subaction = strtolower($_POST['ChangeType']);
				$newsletterlist = $_POST['newsletters'];

				switch ($subaction) {
					case 'delete':
						$access = $user->HasAccess('Newsletters', 'Delete');
						if ($access) {
							$this->DeleteNewsletters($newsletterlist);
						} else {
							$this->DenyAccess();
						}
					break;

					case 'approve':
					case 'disapprove':
						$access = $user->HasAccess('Newsletters', 'Approve');
						if ($access) {
							$this->ActionNewsletters($newsletterlist, $subaction);
						} else {
							$this->DenyAccess();
						}
					break;

					case 'archive':
					case 'unarchive':
						$access = $user->HasAccess('Newsletters', 'Archive');
						if ($access) {
							$this->ActionNewsletters($newsletterlist, $subaction);
						} else {
							$this->DenyAccess();
						}
					break;
				}
			break;

			default:
				$this->ManageNewsletters();
			break;
		}

		if (!in_array($action, $this->SuppressHeaderFooter)) {
			$this->PrintFooter($popup);
		}
	}

	/**
	* ManageNewsletters
	* Prints out the newsletters for management. Depending on your access levels you can edit, delete, send, schedule and so on.
	*
	* @see GetSession
	* @see Session::Get
	* @see GetPerPage
	* @see GetSortDetails
	* @see GetApi
	* @see User_API::Admin
	* @see Newsletter_API::GetNewsletters
	* @see SetupPaging
	* @see PrintDate
	* @see User_API::HasWriteAccess
	* @see Jobs_API::FindJob
	*
	* @return Void Doesn't return anything, just prints out the results and that's it.
	*
	* @uses EventData_IEM_NEWSLETTERS_MANAGENEWSLETTERS
	*/
	function ManageNewsletters()
	{
		$session = &GetSession();
		$user = &GetUser();
		$perpage = $this->GetPerPage();

		$DisplayPage = $this->GetCurrentPage();
		$start = 0;
		if ($perpage != 'all') {
			$start = ($DisplayPage - 1) * $perpage;
		}

		$sortinfo = $this->GetSortDetails();

		$newsletterapi = $this->GetApi();

		$newsletterowner = ($user->Admin() || $user->AdminType() == 'n' || $user->UserAdmin()) ? 0 : $user->userid;
		$NumberOfNewsletters = $newsletterapi->GetNewsletters($newsletterowner, $sortinfo, true);
		$mynewsletters = $newsletterapi->GetNewsletters($newsletterowner, $sortinfo, false, $start, $perpage);

		if ($user->HasAccess('Newsletters', 'Create')) {
			$GLOBALS['Newsletters_AddButton'] = $this->ParseTemplate('Newsletter_Create_Button', true, false);
			$GLOBALS['Newsletters_Heading'] = GetLang('Help_NewslettersManage_HasAccess');
		}

		if (!isset($GLOBALS['Message'])) {
			$GLOBALS['Message'] = '';
		}

		/**
		 * Trigger event
		 */
			$tempEventData = new EventData_IEM_NEWSLETTERS_MANAGENEWSLETTERS();
			$tempEventData->displaymessage = &$GLOBALS['Message'];
			$tempEventData->trigger();

			unset($tempEventData);
		/**
		 * -----
		 */

		if ($NumberOfNewsletters == 0) {
			if ($user->HasAccess('Newsletters', 'Create')) {
				$GLOBALS['Message'] .= $this->PrintSuccess('NoNewsletters', GetLang('NoNewsletters_HasAccess'));
			} else {
				$GLOBALS['Message'] .= $this->PrintSuccess('NoNewsletters', '');
			}
			$this->ParseTemplate('Newsletters_Manage_Empty');
			return;
		}

		$this->SetupPaging($NumberOfNewsletters, $DisplayPage, $perpage);
		$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		$paging = $this->ParseTemplate('Paging', true, false);

		if ($user->HasAccess('Newsletters', 'Delete')) {
			$GLOBALS['Option_DeleteNewsletter'] = '<option value="Delete">' . GetLang('Delete') . '</option>';
		}

		if ($user->HasAccess('Newsletters', 'Approve')) {
			$GLOBALS['Option_ActivateNewsletter'] = '<option value="Approve">' . GetLang('ApproveNewsletters') . '</option>';
			$GLOBALS['Option_ActivateNewsletter'] .= '<option value="Disapprove">' . GetLang('DisapproveNewsletters') . '</option>';
			$GLOBALS['Option_ArchiveNewsletter'] = '<option value="Archive">' . GetLang('ArchiveNewsletters') . '</option>';
			$GLOBALS['Option_ArchiveNewsletter'] .= '<option value="Unarchive">' . GetLang('UnarchiveNewsletters') . '</option>';
		}

		$newsletter_manage = $this->ParseTemplate('Newsletters_Manage', true, false);

		$newsletterdisplay = '';

		$jobapi = $this->GetApi('Jobs');

		foreach ($mynewsletters as $pos => $newsletterdetails) {
			$newsletterid = $newsletterdetails['newsletterid'];
			$GLOBALS['Name'] = htmlspecialchars($newsletterdetails['name'], ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['Short_Name'] = htmlspecialchars($this->TruncateName($newsletterdetails['name'], 34), ENT_QUOTES, SENDSTUDIO_CHARSET);

			$GLOBALS['Created'] = $this->PrintDate($newsletterdetails['createdate']);
			$GLOBALS['Format'] = GetLang('Format_' . $newsletterapi->GetFormat($newsletterdetails['format']));
			$GLOBALS['Owner'] = $newsletterdetails['owner'];

			$GLOBALS['Subject'] = htmlspecialchars($newsletterdetails['subject'], ENT_QUOTES, SENDSTUDIO_CHARSET);
			$GLOBALS['Short_Subject'] = htmlspecialchars($this->TruncateName($newsletterdetails['subject'], 37), ENT_QUOTES, SENDSTUDIO_CHARSET);

			$GLOBALS['id'] = $newsletterid;

			$GLOBALS['NewsletterIcon'] = '<img src="images/m_newsletters.gif">';

			$GLOBALS['NewsletterAction']  = '<a href="index.php?Page=Newsletters&Action=View&id=' . $newsletterid . '" target="_blank">' . GetLang('View') . '</a>';

			$send_inprogress = false;
			$send_fully_completed = true;
			$last_sent_details = $newsletterapi->GetLastSent($newsletterid);

			$job = false;
			if ($last_sent_details['jobid'] > 0) {
				$job = $jobapi->LoadJob($last_sent_details['jobid']);
			}
			
			// we need to check if there is a job in the queue, if this is the first scheduling of this job so we can display accordingly
			if (!$job || empty($job) || (is_array($job) && $job['jobstatus'] == 'c'))
			{
				$job = $jobapi->FindJob('send', 'newsletter', $newsletterid, true, false);
			}
			

			$GLOBALS['LastSentTip'] = $GLOBALS['LastSentTip_Extra'] = $GLOBALS['Job'] = '';

			if ($last_sent_details['starttime'] > 0) {
				$GLOBALS['LastSent'] = $this->PrintDate($last_sent_details['starttime']);

				$GLOBALS['TipName'] = $this->GetRandomId();

				if ($last_sent_details['finishtime'] > 0) {
					$GLOBALS['LastSentTip'] = sprintf(GetLang('AlreadySentTo'), $this->FormatNumber($last_sent_details['total_recipients']), $this->FormatNumber($last_sent_details['sendsize']));
					if ($last_sent_details['total_recipients'] < $last_sent_details['sendsize'] && $job) {
						$send_fully_completed = false;
						$GLOBALS['ResendTipName'] = $this->GetRandomId();
						$GLOBALS['Job'] = $job['jobid'];
						if ($job['resendcount'] < SENDSTUDIO_RESEND_MAXIMUM) {
							$GLOBALS['NewsletterIcon'] = $this->ParseTemplate('Newsletters_Send_Resend_Tip', true, false);
							$GLOBALS['LastSentTip_Extra'] = GetLang('AlreadySentTo_Partial');
						}
					}
				} else {
					$GLOBALS['LastSentTip'] = sprintf(GetLang('AlreadySentTo_SoFar'), $this->FormatNumber($last_sent_details['total_recipients']), $this->FormatNumber($last_sent_details['sendsize']));
				}

				$already_sent_tip = $this->ParseTemplate('Newsletters_Send_Tip', true, false);

				$GLOBALS['LastSent'] = $already_sent_tip;
			} else {
				$GLOBALS['LastSent'] = GetLang('NotSent');
			}

			if ($user->HasAccess('Newsletters', 'Send')) {
				if ($newsletterdetails['active']) {
					if (!$job || empty($job)) {
						$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&id=' . $newsletterid . '">' . GetLang('Send') . '</a>';
						$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Test=true&id=' . $newsletterid . '"> Send Test '.$newsletterdetails['currenttest'].'</a>';
						if ($user->returnpathenabled == true)
						{
							$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Action=returnpath&id=' . $newsletterid . '"> Send Rendering Test</a>';					
						} else {
							$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Addons&Addon=litmus&Action=Create&litmus_campaigns=' . $newsletterid . '"> Send Rendering Test</a>';
						}
					} else {
						$jobstate = $jobapi->GetJobStatus($job['jobstatus']);
						switch ($job['jobstatus']) {
							case 'i':
								$send_inprogress = true;
								if (SENDSTUDIO_CRON_ENABLED && SENDSTUDIO_CRON_SEND > 0) {
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Schedule">' . $jobstate . '</a>';
								} else {
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Action=PauseSend&Job=' . $job['jobid'] . '">' . $jobstate . '</a>';
								}
							break;
							case 'p':
								$send_inprogress = true;
								if (SENDSTUDIO_CRON_ENABLED && SENDSTUDIO_CRON_SEND > 0) {
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Schedule">' . $jobstate . '</a>';
								} else {
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Action=ResumeSend&Job=' . $job['jobid'] . '">' . $jobstate . '</a>';
								}
							break;
							case 'w':
								$send_inprogress = true;
								// this is only applicable for scheduled newsletters (waiting to send).
								$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Schedule">' . GetLang('Waiting') . '</a>';
							break;
							default:
								if ($send_fully_completed) {
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&id=' . $newsletterid . '">' . GetLang('Send') . '</a>';
									$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Test=true&id=' . $newsletterid . '"> Send Test '.$newsletterdetails['currenttest'].'</a>';					
									if ($user->returnpathenabled == true)
									{
										$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Action=returnpath&id=' . $newsletterid . '"> Send Rendering Test</a>';					
									}
								} else {
									if ($job['resendcount'] < SENDSTUDIO_RESEND_MAXIMUM) {
										$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Send&Action=Resend&Job=' . $job['jobid']. '">' . GetLang('Resend') . '</a>';
									} else {
										$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Resend', 'Newsletter_Send_Disabled_Resend_Maximum');
									}
								}
						}
					}
				} else {
					$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Send', 'Newsletter_Send_Disabled_Inactive');
				}
			} else {
				$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Send');
			}

			if ($user->HasAccess('Newsletters', 'Edit')) {
				if (!$send_inprogress) {
					$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Newsletters&Action=Edit&id=' . $newsletterid . '">' . GetLang('Edit') . '</a>';
				} else {
					$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Edit', 'Newsletter_Edit_Disabled_SendInProgress');
				}
			} else {
				$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Edit');
			}

			if ($user->HasAccess('Newsletters', 'Create')) {
				$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="index.php?Page=Newsletters&Action=Copy&id=' . $newsletterid . '">' . GetLang('Copy') . '</a>';
			} else {
				$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Copy');
			}

			if ($user->HasAccess('Newsletters', 'Delete')) {
				if (!$send_inprogress) {
					$GLOBALS['NewsletterAction'] .= '&nbsp;&nbsp;<a href="javascript: ConfirmDelete(' . $newsletterid . ');">' . GetLang('Delete') . '</a>';
				} else {
					$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Delete', 'Newsletter_Delete_Disabled_SendInProgress');
				}
			} else {
				$GLOBALS['NewsletterAction'] .= $this->DisabledItem('Delete');
			}

			if ($newsletterdetails['active'] > 0) {
				$statusaction = 'deactivate';
				$activeicon = 'tick';
				if ($user->HasAccess('Newsletters', 'Approve')) {
					$activetitle = GetLang('Newsletter_Title_Disable');
				} else {
					$activetitle = GetLang('NoAccess');
				}
			} else {
				$statusaction = 'activate';
				$activeicon = 'cross';
				if ($user->HasAccess('Newsletters', 'Approve')) {
					$activetitle = GetLang('Newsletter_Title_Enable');
				} else {
					$activetitle = GetLang('NoAccess');
				}
			}

			if ($user->HasAccess('Newsletters', 'Approve')) {
				if (!$send_inprogress) {
					$GLOBALS['ActiveAction'] = '<a href="index.php?Page=Newsletters&Action=' . $statusaction . '&id=' . $newsletterid . '" title="' . $activetitle . '"><img src="images/' . $activeicon . '.gif" border="0"></a>';
				} else {
					$activetitle = GetLang('Newsletter_ChangeActive_Disabled_SendInProgress');
					$GLOBALS['ActiveAction'] = '<span title="' . $activetitle . '"><img src="images/' . $activeicon . '.gif" border="0"></span>';
				}
			} else {
				$GLOBALS['ActiveAction'] = '<span title="' . $activetitle . '"><img src="images/' . $activeicon . '.gif" border="0"></span>';
			}

			if ($newsletterdetails['archive'] > 0) {
				$statusaction = 'deactivatearchive';
				$activeicon = 'tick';
				$activetitle = GetLang('Newsletter_Title_Archive_Disable');
			} else {
				$statusaction = 'activatearchive';
				$activeicon = 'cross';
				$activetitle = GetLang('Newsletter_Title_Archive_Enable');
			}

			if ($user->HasAccess('Newsletters', 'Approve')) {
				$GLOBALS['ArchiveAction'] = '<a href="index.php?Page=Newsletters&Action=' . $statusaction . '&id=' . $newsletterid . '" title="' . $activetitle . '"><img src="images/' . $activeicon . '.gif" border="0"></a>';
			} else {
				$GLOBALS['ArchiveAction'] = '<span title="' . $activetitle . '"><img src="images/' . $activeicon . '.gif" border="0"></span>';
			}

			$newsletterdisplay .= $this->ParseTemplate('Newsletters_Manage_Row', true, false);
		}
		$newsletter_manage = str_replace('%%TPL_Newsletters_Manage_Row%%', $newsletterdisplay, $newsletter_manage);
		$newsletter_manage = str_replace('%%TPL_Paging%%', $paging, $newsletter_manage);
		$newsletter_manage = str_replace('%%TPL_Paging_Bottom%%', $GLOBALS['PagingBottom'], $newsletter_manage);

		echo $newsletter_manage;
	}

	/**
	* ActionNewsletters
	* Actions newsletters based on the action passed in. This can be activate, inactivate, enable archiving or disable archiving.
	*
	* @param Array $newsletterids An array of newsletter id's to action. If it's a single item, it's turned into an array for easy processing.
	* @param String $action The action to perform. Can be approve, disapprove, acthive, unarchive. Anything else is dropped.
	*
	* @see ManageNewsletters
	* @see GetUser
	* @see GetApi
	* @see Newsletters_API::Set
	* @see Newsletters_API::Load
	* @see Newsletters_API::Save
	* @see FormatNumber
	*
	* @return Void Prints out a message based on what happened and then prints out the list of newsletters again.
	*/
	function ActionNewsletters($newsletterids=array(), $action='')
	{
		if (!is_array($newsletterids)) {
			$newsletterids = array($newsletterids);
		}

		if (empty($newsletterids)) {
			$GLOBALS['Error'] = GetLang('NoNewslettersToAction');
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
			$this->ManageNewsletters();
			return;
		}

		$action = strtolower($action);

		if (!in_array($action, array('approve', 'disapprove', 'archive', 'unarchive'))) {
			$GLOBALS['Error'] = GetLang('InvalidNewsletterAction');
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
			$this->ManageNewsletters();
			return;
		}

		$user = &GetUser();

		$newsletterapi = $this->GetApi();

		$update_ok = $update_fail = $update_not_done = 0;
		foreach ($newsletterids as $p => $newsletterid) {
			$newsletterapi->Load($newsletterid);

			$save_newsletter = true;

			switch ($action) {
				case 'approve':
					$allow_attachments = $this->CheckForAttachments($newsletterid, 'newsletters');
					if ($allow_attachments) {
						$langvar = 'Approved';
						$newsletterapi->Set('active', $user->Get('userid'));
					} else {
						$update_not_done++;
						$save_newsletter = false;
					}

				break;
				case 'disapprove':
					$langvar = 'Disapproved';
					$newsletterapi->Set('active', 0);
				break;
				case 'archive':
					$langvar = 'Archived';
					$newsletterapi->Set('archive', 1);
				break;
				case 'unarchive':
					$langvar = 'Unarchived';
					$newsletterapi->Set('archive', 0);
				break;
			}
			if ($save_newsletter) {
				$status = $newsletterapi->Save();
				if ($status) {
					$update_ok++;
				} else {
					$update_fail++;
				}
			}
		}

		$msg = '';

		if ($update_not_done > 0) {
			if ($update_not_done == 1) {
				$GLOBALS['Error'] = GetLang('NewsletterActivateFailed_HasAttachments');
			} else {
				$GLOBALS['Error'] = sprintf(GetLang('NewsletterActivateFailed_HasAttachments_Multiple'), $this->FormatNumber($update_not_done));
			}
			$msg .= $this->ParseTemplate('ErrorMsg', true, false);
		}

		if ($update_fail > 0) {
			if ($update_fail == 1) {
				$GLOBALS['Error'] = GetLang('Newsletter_Not' . $langvar);
			} else {
				$GLOBALS['Error'] = sprintf(GetLang('Newsletters_Not' . $langvar), $this->FormatNumber($update_fail));
			}
			$msg .= $this->ParseTemplate('ErrorMsg', true, false);
		}

		if ($update_ok > 0) {
			if ($update_ok == 1) {
				$msg .= $this->PrintSuccess('Newsletter_' . $langvar);
			} else {
				$msg .= $this->PrintSuccess('Newsletters_' . $langvar, $this->FormatNumber($update_ok));
			}
		}

		$GLOBALS['Message'] = $msg;

		$this->ManageNewsletters();
	}

	/**
	* DeleteNewsletters
	* Deletes a list of newsletter id's passed in.
	*
	* @param Array $newsletterids An array of newsletters you want to delete. If it's a single id, it's turned into an array for easy processing.
	*
	* @see GetApi
	* @see Newsletters_API::Delete
	* @see ManageNewsletters
	*
	* @return Void Doesn't return anything. Prints out a message based on what happened and prints out the list of newsletters again.
	*/
	function DeleteNewsletters($newsletterids=array())
	{
		if (!is_array($newsletterids)) {
			$newsletterids = array($newsletterids);
		}

		$api = $this->GetApi();
		$jobapi = $this->GetApi('Jobs');

		$newsletterids = $api->CheckIntVars($newsletterids);

		if (empty($newsletterids)) {
			$GLOBALS['Error'] = GetLang('NoNewslettersToDelete');
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
			$this->ManageNewletters();
			return;
		}

		$user = &GetUser();

		$sends_in_progress = array();
		$delete_ok = $delete_fail = 0;
		foreach ($newsletterids as $p => $newsletterid) {

			$job = $jobapi->FindJob('send', 'newsletter', $newsletterid);
			if ($job) {
				if ($job['jobstatus'] == 'i') {
					$api->Load($newsletterid);
					$newsletter_name = $api->Get('name');
					$sends_in_progress[] = $newsletter_name;
					continue;
				}
				$jobapi->Delete($job['jobid']);

				while ($job = $jobapi->FindJob('send', 'newsletter', $newsletterid)) {
					if ($job['jobstatus'] == 'i') {
						$api->Load($newsletterid);
						$newsletter_name = $api->Get('name');
						$sends_in_progress[] = $newsletter_name;
						break;
					}
					$jobapi->Delete($job['jobid']);
				}
			}

			$status = $api->Delete($newsletterid, $user->Get('userid'));
			if ($status) {
				$delete_ok++;
			} else {
				$delete_fail++;
			}
		}

		$msg = '';

		if (!empty($sends_in_progress)) {
			if (sizeof($sends_in_progress) == 1) {
				$GLOBALS['Error'] = sprintf(GetLang('Newsletter_NotDeleted_SendInProgress'), current($sends_in_progress));
			} else {
				$GLOBALS['Error'] = sprintf(GetLang('Newsletters_NotDeleted_SendInProgress'), implode('\',\'', $sends_in_progress));
			}
			$msg .= $this->ParseTemplate('ErrorMsg', true, false);
		}

		if ($delete_ok > 0) {
			if ($delete_ok == 1) {
				$msg .= $this->PrintSuccess('Newsletter_Deleted');
			} else {
				$msg .= $this->PrintSuccess('Newsletters_Deleted', $this->FormatNumber($delete_ok));
			}
		}
		$GLOBALS['Message'] = $msg;

		$this->ManageNewsletters();
	}

	/**
	* EditNewsletter
	* Loads up stage 1 of editing a newsletter (choosing format, templates etc).
	*
	* @param Int $newsletterid Newsletter to load up.
	*
	* @see GetApi
	* @see GetTemplateList
	* @see Newsletter_API::Load
	* @see Newsletter_API::GetAllFormats
	*
	* @return Void Prints out the form, doesn't return anything.
	*/
	function EditNewsletter($newsletterid=0)
	{
		$newsletter = $this->GetApi();

		if ($newsletterid <= 0 || !$newsletter->Load($newsletterid)) {
			$GLOBALS['Error'] = GetLang('UnableToLoadNewsletter');
			$GLOBALS['Message'] = $this->ParseTemplate('ErrorMsg', true, false);
			$this->ManageNewsletters();
			return;
		}

		// Log this to "User Activity Log"
		IEM::logUserActivity($_SERVER['REQUEST_URI'], 'images/newsletters_view.gif', $newsletter->name);

		$GLOBALS['Action'] = 'Edit&SubAction=Step2&id=' . $newsletterid;
		$GLOBALS['CancelButton'] = GetLang('EditNewsletterCancelButton');
		$GLOBALS['Heading'] = GetLang('EditNewsletter');
		$GLOBALS['Intro'] = GetLang('EditNewsletterIntro');
		$GLOBALS['NewsletterDetails'] = GetLang('EditNewsletterHeading');

		$GLOBALS['FormatList'] = '';
		$allformats = $newsletter->GetAllFormats();
		foreach ($allformats as $id => $name) {
			$selected = '';
			if ($id == $newsletter->format) {
				$selected = ' SELECTED';
			}

			if ($name == 'TextAndHTML') {
				$recommended = ' ' . GetLang('Recommended');
			} else {
				$recommended = '';
			}

			$GLOBALS['FormatList'] .= '<option value="' . $id . '"' . $selected . '>' . GetLang('Format_' . $name) . $recommended . '</option>';
		}

		$GLOBALS['Name'] = htmlspecialchars($newsletter->name, ENT_QUOTES, SENDSTUDIO_CHARSET);

		$GLOBALS['DisplayTemplateList'] = 'none';

		$this->ParseTemplate('Newsletter_Form_Step1');
	}

	/**
	* CreateNewsletter
	* Loads up stage 1 of creating a newsletter (choosing format, templates etc).
	*
	* @see GetApi
	* @see GetTemplateList
	* @see Newsletter_API::GetAllFormats
	*
	* @return Void Prints out the form, doesn't return anything.
	*/
	function CreateNewsletter()
	{
		$newsletterapi = $this->GetApi();

		$GLOBALS['Action'] = 'Create&SubAction=Step2';
		$GLOBALS['CancelButton'] = GetLang('CreateNewsletterCancelButton');
		$GLOBALS['Heading'] = GetLang('CreateNewsletter');
		$GLOBALS['Intro'] = GetLang('CreateNewsletterIntro');
		$GLOBALS['NewsletterDetails'] = GetLang('CreateNewsletterHeading');

		$GLOBALS['FormatList'] = '';
		$allformats = $newsletterapi->GetAllFormats();
		foreach ($allformats as $id => $name) {
			if ($name == 'TextAndHTML') {
				$recommended = ' ' . GetLang('Recommended');
			} else {
				$recommended = '';
			}
			$GLOBALS['FormatList'] .= '<option value="' . $id . '">' . GetLang('Format_' . $name) . $recommended .'</option>';
		}

		$templateselects = $this->GetTemplateList();
		$GLOBALS['TemplateList'] = $templateselects;

		$this->ParseTemplate('Newsletter_Form_Step1');
	}

	/**
	* DisplayEditNewsletter
	* Prints out the editor for stage 2 of editing a newsletter (the wysiwyg area or textarea depending on the format chosen in stage 1). If you have selected a template in the previous step, the content from that template will be displayed here.
	*
	* @param Int $newsletterid Newsletter to load up. If there is one, it will pre-load that content. If there is no newsletterid, it displays a blank area to create your content.
	*
	* @see CreateNewsletter
	* @see EditNewsletter
	* @see GetSession
	* @see Session::Get
	* @see Session::Set
	* @see GetApi
	* @see Newsletter_API::Load
	* @see Newsletter_API::GetBody
	* @see GetAttachments
	* @see FetchEditor
	*
	* @return Void Prints out the form, doesn't return anything.
	*/
	function DisplayEditNewsletter($newsletterid=0)
	{
		$newsletter = $this->GetApi();
		$newslettercontents = array('text' => '', 'html' => '');

		$user = &GetUser();

		$GLOBALS['FromPreviewEmail'] = $user->Get('emailaddress');

		$GLOBALS['DisplayAttachmentsHeading'] = 'none';

		$session = &GetSession();
		if ($newsletterid > 0) {
			$GLOBALS['SaveAction'] = 'Edit&SubAction=Save&id=' . $newsletterid;
			$GLOBALS['Heading'] = GetLang('EditNewsletter');
			$GLOBALS['Intro'] = GetLang('EditNewsletterIntro_Step2');
			$GLOBALS['Action'] = 'Edit&SubAction=Complete&id=' . $newsletterid;
			$GLOBALS['CancelButton'] = GetLang('EditNewsletterCancelButton');

			$newsletter->Load($newsletterid, true);
			$GLOBALS['IsActive'] = ($newsletter->Active()) ? ' CHECKED' : '';
			$GLOBALS['Archive'] = ($newsletter->Archive()) ? ' CHECKED' : '';
			
			if($newsletter->htmlheader != '' && strpos($newsletter->htmlheader,'emailHeader" align="center"'))
			{
				$GLOBALS['HeaderAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center" selected>Center Aligned</option>';
				$headeralign = 'center';
			}else{
				$GLOBALS['HeaderAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center">Center Aligned</option>';
				$headeralign = 'left';
			}
			
			if($newsletter->htmlfooter != '' && strpos($newsletter->htmlfooter,'emailFooter" align="center"'))
			{
				$footeralign = 'center';
				$GLOBALS['FooterAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center" selected>Center Aligned</option>';
			}else{
				$footeralign = 'left';
				$GLOBALS['FooterAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center">Center Aligned</option>';
			}
			if($user->enableheader)
			{
				$GLOBALS['HtmlHeader'] = $this->ParseTemplate("Default_EmailHeader",true,false);
				$GLOBALS['HtmlDisplayHeader'] = str_replace('%%headeralign%%',$headeralign,$this->ParseTemplate("Default_EmailHeader",true,false));
			}else{
				$GLOBALS['HtmlHeader'] = '';
				$GLOBALS['ShowHeader'] = 'none';
			}
			
			if($user->enablefooter)
			{
				$defaultFooter = $this->ParseTemplate("Default_EmailFooter", true, false);
				$defaultFooter = $this->ParseEmailFooter($defaultFooter, $user);
				$GLOBALS['HtmlFooter'] = $defaultFooter;
				$GLOBALS['HtmlDisplayFooter'] = str_replace('%%footeralign%%',$footeralign,$defaultFooter);
			} else {
				$GLOBALS['HtmlFooter'] = '';
				$GLOBALS['ShowFooter'] = 'none';
			}
			
			
			$newslettercontents['text'] = $newsletter->GetBody('text');
			$newslettercontents['html'] = $newsletter->GetBody('html');

			$GLOBALS['Subject'] = htmlspecialchars($newsletter->subject, ENT_QUOTES, SENDSTUDIO_CHARSET);

			$attachmentsarea = strtolower(get_class($this));
			$attachments_list = $this->GetAttachments($attachmentsarea, $newsletterid);
			if ($attachments_list !== false) {
				$GLOBALS['DisplayAttachmentsHeading'] = '';
			}
			$GLOBALS['AttachmentsList'] = $attachments_list;
		} else {
			$GLOBALS['SaveAction'] = 'Create&SubAction=Save&id=' . $newsletterid;
			$GLOBALS['Heading'] = GetLang('CreateNewsletter');
			$GLOBALS['Intro'] = GetLang('CreateNewsletterIntro_Step2');
			$GLOBALS['Action'] = 'Create&SubAction=Complete';
			$GLOBALS['CancelButton'] = GetLang('CreateNewsletterCancelButton');

			$GLOBALS['IsActive'] = ' CHECKED';
			$GLOBALS['Archive'] = ' CHECKED';
			
			$GLOBALS['HeaderAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center">Center Aligned</option>';
			$headeralign = 'left';
			
			$footeralign = 'left';
			$GLOBALS['FooterAlignmentOptions'] = '<option value="left">Left Aligned</option><option value="center">Center Aligned</option>';
			
			if($user->enableheader)
			{
				$GLOBALS['HtmlHeader'] = $this->ParseTemplate("Default_EmailHeader",true,false);
				$GLOBALS['HtmlDisplayHeader'] = str_replace('%%headeralign%%',$headeralign,$this->ParseTemplate("Default_EmailHeader",true,false));
			}else{
				$GLOBALS['HtmlHeader'] = '';
				$GLOBALS['ShowHeader'] = 'none';
			}
			if($user->enablefooter)
			{
				$defaultFooter = $this->ParseTemplate("Default_EmailFooter", true, false);
				$defaultFooter = $this->ParseEmailFooter($defaultFooter, $user);
				$GLOBALS['HtmlFooter'] = $defaultFooter;
				$GLOBALS['HtmlDisplayFooter'] = str_replace('%%footeralign%%',$footeralign,$defaultFooter);
			}else{
				$GLOBALS['HtmlFooter'] = '';
				$GLOBALS['ShowFooter'] = 'none';
			}
		}

		$GLOBALS['PreviewID'] = $newsletterid;
		// we don't really need to get/set the stuff here.. we could use references.
		// if we do though, it segfaults! so we get and then set the contents.
		$session_newsletter = $session->Get('Newsletters');
		$session_newsletter['id'] = (int)$newsletterid;

		if (isset($session_newsletter['TemplateID'])) {
			$templateApi = $this->GetApi('Templates');
			if (is_numeric($session_newsletter['TemplateID'])) {
				$templateApi->Load($session_newsletter['TemplateID']);
				$newslettercontents['text'] = $templateApi->textbody;
				$newslettercontents['html'] = $templateApi->htmlbody;
			} else {
				$newslettercontents['html'] = $templateApi->ReadServerTemplate($session_newsletter['TemplateID']);
			}
			unset($session_newsletter['TemplateID']);
		}

		$GLOBALS['DisplayAttachments'] = 'none';
		if (SENDSTUDIO_ALLOW_ATTACHMENTS) {
			$GLOBALS['DisplayAttachmentsHeading'] = '';
			$GLOBALS['DisplayAttachments'] = '';
		}

		$session_newsletter['contents'] = $newslettercontents;
		$session->Set('Newsletters', $session_newsletter);
		$editor = $this->FetchEditor();
		$GLOBALS['Editor'] = $editor;

		$this->ParseTemplate('Newsletter_Form_Step2');
	}
	
	/**
	* ParseEmailFooter
	*
	* Inserts Company information into the footer
	*
	*/
	function ParseEmailFooter($footerContent, $user)
	{
		$retFooter = str_replace('%%CompanyName%%',$user->companyname,$footerContent);
		$retFooter = str_replace('%%CompanyAddress1%%',$user->companyaddress1, $retFooter);
		if($user->companyaddress2 != '')
		{
			$retFooter = str_replace('%%CompanyAddress2%%',$user->companyaddress2.'<br />', $retFooter);
		}else{
			$retFooter = str_replace('%%CompanyAddress2%%','', $retFooter);
		}
		$retFooter = str_replace('%%City%%',$user->companycity, $retFooter);
		$retFooter = str_replace('%%State%%',$user->companystate, $retFooter);
		$retFooter = str_replace('%%Zip%%',$user->companypostcode, $retFooter);
		if($user->enablefooterlogo){
			$retFooter = str_replace('%%FooterLogo%%',$this->ParseTemplate('Default_EmailFooterLogo',true,false), $retFooter);
		}else{
			$retFooter = str_replace('%%FooterLogo%%','',$retFooter);
		}
		return $retFooter;
	}
}
?>
