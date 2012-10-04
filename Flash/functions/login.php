<?php
/**
* This file has the login functions in it. Shows the login page and then authenticates upon submission.
*
* @version     $Id: login.php,v 1.21 2007/09/18 01:22:22 chris Exp $
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
* Class for the login page. Will show the login screen, authenticate and set the session details as it needs to.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Login extends SendStudio_Functions
{

	/**
	* Constructor
	* Loads the language file.
	*
	* @see LoadLanguageFile
	*
	* @return Void Doesn't return anything.
	*/
	function Login()
	{
		$this->LoadLanguageFile();
	}

	/**
	* Process
	* All the action happens here.
	* If you are not logged in, it will print the login form.
	* Submitting that form will then try to authenticate you.
	* If you are successfully authenticated, you get redirected back to the main index page (quickstats etc).
	* Otherwise, will show an error message and the login form again.
	*
	* @see ShowLoginForm
	* @see GetAuthenticationSystem
	* @see AuthenticationSystem::Authenticate
	* @see GetUser
	* @see GetSession
	* @see Session::Set
	*
	* @return Void Doesn't return anything. Checks the action and passes it off to the appropriate area.
	*/
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower($_GET['Action']) : '';
		switch ($action) {
			case 'forgotpass':
				$this->ShowForgotForm();
			break;

			case 'changepassword':
				$session = &GetSession();
				if (!$session->Get('ForgotUser')) {
					$this->ShowForgotForm('login_error', GetLang('BadLogin_Link'));
					break;
				}

				$userapi = &GetUser(-1);
				$loaded = $userapi->Load($session->Get('ForgotUser'));

				if (!$loaded) {
					$this->ShowForgotForm('login_error', GetLang('BadLogin_Link'));
					break;
				}
				$password = false;
				$confirm = false;
				if (isset($_POST['ss_password'])) {
					$password = $_POST['ss_password'];
				}

				if (isset($_POST['ss_password_confirm'])) {
					$confirm = $_POST['ss_password_confirm'];
				}

				if ($password == false || ($password != $confirm)) {
					$this->ShowForgotForm_Step2($userapi->Get('username'), 'login_error', GetLang('PasswordsDontMatch'));
					break;
				}

				$userapi->password = $password;
				$userapi->Save();

				$code = md5(uniqid(rand(), true));

				$userapi->ResetForgotCode($code);

				$this->ShowLoginForm('login_success', GetLang('PasswordUpdated'));
			break;

			case 'sendpass':
				$user = &GetUser(-1);
				$username = $_POST['ss_username'];

				/**
				 * Fix vulnerabilities with MySQL
				 * Documented here: http://www.suspekt.org/2008/08/18/mysql-and-sql-column-truncation-vulnerabilities/
				 *
				 * Basically MySQL is truncating values in a column
				 */
					$username = preg_replace('/\s+/', ' ', $username);
					$username = trim($username);
				/**
				 * -----
				 */

				$founduser = $user->Find($username);
				if (!$founduser) {
					$this->ShowForgotForm('login_error', GetLang('BadLogin_Forgot'));
					break;
				}

				$user->Load($founduser, false);

				$code = md5(uniqid(rand(), true));

				$user->ResetForgotCode($code);

				$link = SENDSTUDIO_APPLICATION_URL . '/admin/index.php?Page=Login&Action=ConfirmCode&user=' . $founduser . '&code=' . $code;

				$message = sprintf(GetLang('ChangePasswordEmail'), $link);

				$email_api = $this->GetApi('Email');
				$email_api->Set('CharSet', SENDSTUDIO_CHARSET);
				$email_api->Set('Multipart', false);
				$email_api->AddBody('text', $message);
				$email_api->Set('Subject', GetLang('ChangePasswordSubject'));

				$email_api->Set('FromAddress', SENDSTUDIO_EMAIL_ADDRESS);
				$email_api->Set('ReplyTo', SENDSTUDIO_EMAIL_ADDRESS);
				$email_api->Set('BounceAddress', SENDSTUDIO_EMAIL_ADDRESS);

				$email_api->SetSmtp(SENDSTUDIO_SMTP_SERVER, SENDSTUDIO_SMTP_USERNAME, @base64_decode(SENDSTUDIO_SMTP_PASSWORD), SENDSTUDIO_SMTP_PORT);

				$user_fullname = $user->Get('fullname');

				$email_api->AddRecipient($user->emailaddress, $user_fullname, 't');

				$email_api->Send();

				$this->ShowForgotForm_Step2($username,'login_success', sprintf(GetLang('ChangePassword_Emailed'), $user->emailaddress));
			break;

			case 'confirmcode':
				$user = (isset($_GET['user'])) ? (int)$_GET['user'] : false;
				$code = (isset($_GET['code'])) ? $_GET['code'] : false;

				if (!$user || !$code) {
					$this->ShowForgotForm('login_error', GetLang('BadLogin_Link'));
					break;
				}

				$userapi = &GetUser(-1);
				$loaded = $userapi->Load($user, false);

				if (!$loaded || $userapi->Get('forgotpasscode') != $code) {
					$this->ShowForgotForm('login_error', GetLang('BadLogin_Link'));
					break;
				}

				$session = &GetSession();
				$session->Set('ForgotUser', $user);

				$this->ShowForgotForm_Step2($userapi->Get('username'));
			break;

			case 'login':
				$auth_system = &GetAuthenticationSystem();
				$username = isset($_POST['ss_username']) ? $_POST['ss_username'] : '';
				$password = isset($_POST['ss_password']) ? $_POST['ss_password'] : '';
				$result = $auth_system->Authenticate($username, $password);
				if ($result === -1) {
					$this->ShowLoginForm('login_error', GetLang('PleaseWaitAWhile'));
					break;
				} elseif (!$result) {
					$this->ShowLoginForm('login_error', GetLang('BadLogin'));
					break;
				}

				$rememberdetails = (isset($_POST['rememberme'])) ? true : false;

				$user = &GetUser($result['userid']);

				$rand_check = uniqid(true);

				$user->settings['LoginCheck'] = $rand_check;
				$user->SaveSettings();

				$user->UpdateLoginTime();

				$session = &GetSession();
				$session->Set('UserDetails', $user);

				$oneyear = 365 * 24 * 3600; // one year's time.

				$redirect = 'index.php';
				if (isset($_POST['ss_takemeto'])) {
					$redirect = $this->_validateTakeMeToRedirect($_POST['ss_takemeto']);
				}

				if ($rememberdetails) {
					$usercookie_info = array('user' => $user->userid, 'time' => time(), 'rand' => $rand_check, 'takemeto' => $redirect);
					IEM::requestSetCookie('SendStudioLogin', $usercookie_info, $oneyear);
					$usercookie_info = array('takemeto' => $redirect);
					IEM::requestSetCookie('SendStudioLoginPref', $usercookie_info, $oneyear);
				}
				
				if($user->admintype == 'b')
				{
					session_register("agencylogged");
					$agencylogged = $user->userid;
					$_SESSION['agencylogged'] = $agencylogged;
				}

				header('Location: ' . SENDSTUDIO_APPLICATION_URL . '/admin/' . $redirect);
			break;

			default:
				$msg = false; $template = false;
				if ($action == 'logout') {
					$this->LoadLanguageFile('Logout');
				}
				$this->ShowLoginForm($template, $msg);
		}
	}

	/**
	* ShowLoginForm
	* This shows the login form.
	* If there is a template to use in the data/templates folder it will use that as the login form.
	* Otherwise it uses the default one below. If you pass in a message it will show that message above the login form.
	*
	* @param String $template Uses the template passed in for the message (eg success / error).
	* @param String $msg Prints the message passed in above the login form (eg unsuccessful attempt).
	*
	* @see FetchTemplate
	* @see GetSession
	* @see Session::LoggedIn
	* @see PrintHeader
	* @see PrintFooter
	*
	* @return Void Doesn't return anything, just prints the login form.
	*/
	function ShowLoginForm($template=false, $msg=false)
	{
		$session = &GetSession();
		if (!$session->LoggedIn()) {
			$this->GlobalAreas['InfoTips'] = '';
		}

		$this->PrintHeader(true);

		$GLOBALS['Message'] = GetLang('Help_Login');

		if ($template && $msg) {
			switch ($template) {
				case 'login_error':
					$GLOBALS['Error'] = $msg;
				break;
				case 'login_success':
					$this->GlobalAreas['Success'] = $msg;
				break;
			}
			$GLOBALS['Message'] = $this->ParseTemplate($template,true);
		}

		if (isset($_POST['ss_username'])) {
			$GLOBALS['ss_username'] = htmlspecialchars($_POST['ss_username'], ENT_QUOTES, SENDSTUDIO_CHARSET);
		}

		$GLOBALS['ss_takemeto'] = 'index.php';
		$loginPreference = IEM::requestGetCookie('SendStudioLoginPref', array());
		if (is_array($loginPreference) && isset($loginPreference['takemeto'])) {
			$GLOBALS['ss_takemeto'] = $loginPreference['takemeto'];
		}

		$this->GlobalAreas['SubmitAction'] = 'Login';

		$this->ParseTemplate('login');

		$this->PrintFooter(true);
	}

	/**
	* ShowForgotForm
	* This shows the forgot password form and handles the multiple stages of actions. If the template and message are passed in, there will be a success/error message shown. If one is not present, nothing is shown.
	*
	* @param String $template If there is a template (will either be success or error template) use that as a message.
	* @param String $msg This also tells us what's going on (password has been reset and so on).
	*
	* @see PrintHeader
	* @see ParseTemplate
	* @see PrintFooter
	*
	* @return Void Doesn't return anything, only prints out the form.
	*/
	function ShowForgotForm($template=false, $msg=false)
	{
		$this->PrintHeader(true);

		$GLOBALS['Message'] = GetLang('Help_ForgotPassword');

		if ($template && $msg) {
			switch (strtolower($template)) {
				case 'login_error':
					$GLOBALS['Error'] = $msg;
				break;
				case 'login_success':
					$this->GlobalAreas['Success'] = $msg;
				break;
			}
			$GLOBALS['Message'] = $this->ParseTemplate($template, true, false);
		}

		$GLOBALS['SubmitAction'] = 'SendPass';

		$this->ParseTemplate('ForgotPassword');

		$this->PrintFooter(true);
	}

	/**
	* ShowForgotForm_Step2
	* This shows the form for changing the password. It will show the password/password confirm boxes for the user to fill in.
	*
	* @param String $username The username to show in the form. This is not editable, it is just shown for reference.
	* @param String $template If there is a template (will either be success or error template) use that as a message.
	* @param String $msg This also tells us what's going on (password has been reset and so on).
	*
	* @see PrintHeader
	* @see ParseTemplate
	* @see PrintFooter
	*
	* @return Void Doesn't return anything, only prints out the form.
	*/
	function ShowForgotForm_Step2($username='', $template=false, $msg=false)
	{
		$this->PrintHeader(true);

		$GLOBALS['UserName'] = htmlspecialchars($username, ENT_QUOTES, SENDSTUDIO_CHARSET);

		if ($template && $msg) {
			switch (strtolower($template)) {
				case 'login_error':
					$GLOBALS['Error'] = $msg;
					$template_page = 'ForgotPassword_Step2';
				break;
				case 'login_success':
					$GLOBALS['Message'] = $msg;
					$template = false;
					$template_page = 'ForgotPassword_Sendpass';
				break;
			}
			if ($template) {
				$GLOBALS['Message'] = $this->ParseTemplate($template, true, false);
			}
		} else {
			$template_page = 'ForgotPassword_Step2';
			$GLOBALS['Message'] = GetLang('Help_ForgotPassword');
		}

		$GLOBALS['SubmitAction'] = 'ChangePassword';

		$this->ParseTemplate($template_page);

		$this->PrintFooter(true);
	}

	/**
	 * _validateTakeMeToRedirect
	 * Validate wheter or not "Take Me To" redirect string is a valid re-direct
	 *
	 * @param String $redirectString Re-direct string
	 * @return String Return a valid re-direct string
	 *
	 * @access private
	 */
	function _validateTakeMeToRedirect($redirectString)
	{
		$defaultRedirect = 'index.php';
		$urlParts = parse_url($redirectString);

		// Must begin with index.php
		if (!preg_match('/^index.php/', $redirectString)) {
			return $defaultRedirect;
		}

		// Path must be index.php
		if (!isset($urlParts['path']) || strtolower($urlParts['path']) != 'index.php') {
			return $defaultRedirect;
		}

		// Query must exists
		if (!isset($urlParts['query'])) {
			return $defaultRedirect;
		}

		// Make into REQUEST string
		parse_str($urlParts['query'], $redirectRequest);

		// REQUEST redirect must have "Page" variable in it
		if (!isset($redirectRequest['Page'])) {
			return $defaultRedirect;
		}

		// Check if function exists
		if (!is_file(SENDSTUDIO_FUNCTION_DIRECTORY . '/' . strtolower($redirectRequest['Page']) . '.php')) {
			return $defaultRedirect;
		}

		return $redirectString;
	}
}

?>
