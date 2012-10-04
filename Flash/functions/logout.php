<?php
/**
* This file has the logout functions in it. After logging you out it will redirect you back to the login form.
*
* @version     $Id: logout.php,v 1.7 2006/08/18 04:07:44 chris Exp $
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
* Class for the logout page. After logging you out it will redirect you back to the login form.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class Logout extends SendStudio_Functions
{

	/**
	* Constructor
	* Does nothing when called directly.
	*
	* @return Void Doesn't return anything.
	*/
	function Logout()
	{
	}
	
	/**
	* Process
	* Logs you out and redirects you back to the login page.
	*
	* @see Login::Process
	* @see GetSession
	* @see Session::Set
	*
	* @return Void Doesn't return anything. Unsets session variables, removes the "remember me" cookie if it's set and redirects you back to the login page.
	*/
	function Process()
	{
		$session = &GetSession();
		$sessionuser = $session->Get('UserDetails');
		$userid = $sessionuser->userid;
		$user = &GetUser($userid);
		$user->settings = $sessionuser->settings;
		$user->SaveSettings();
		unset($user);
		$session->Set('UserDetails', '');

		if (isset($_COOKIE['SendStudioLogin'])) {
			$oneyear = time() - (3600 * 265 * 24);
			setcookie('SendStudioLogin', '', $oneyear, '/');
		}

		$_SESSION = array();
		session_destroy();
		header('Location: ' . $_SERVER['PHP_SELF'] . '?Page=Login&Action=Logout');
	}
}

?>
