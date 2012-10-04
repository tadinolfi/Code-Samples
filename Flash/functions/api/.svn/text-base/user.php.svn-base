<?php
/**
* The User API.
*
* @version     $Id: user.php,v 1.71 2008/02/24 22:11:51 hendri Exp $
* @author Chris <chris@interspire.com>
*
* @package API
* @subpackage User_API
*/

/**
* Include the base api class if we need to.
*/
require_once(dirname(__FILE__) . '/api.php');

/**
* This will load a user, save a user, set details and get details.
* It will also check access areas.
*
* @package API
* @subpackage User_API
*/
class User_API extends API
{
	/**
	 * Default event activity type
	 *
	 * @var Array
	 */
	var $defaultEventActivityType = array('Phone Call', 'Meeting', 'Email');


	/**
	* The User that is loaded. By default is 0 (no user).
	*
	* @var Int
	*/
	var $userid = 0;

	/**
	* Username of the user that we've loaded.
	*
	* @var String
	*/
	var $username = '';

	/**
	* Full name of the user.
	*
	* @var String
	*/
	var $fullname = '';

	/**
	* Email address of the user.
	*
	* @var String
	*/
	var $emailaddress = '';

	/**
	* Whether this user is active or not.
	*
	* @var Boolean
	*/
	var $status = false;

	/**
	* Whether this user is an admin or not.
	*
	* @var Boolean
	*/
	var $admin = null;

	/**
	* The 'admintype'.
	*
	* @see AdminTypes
	*
	* @var Char
	*/
	var $admintype = 'c';

	/**
	* Whether this user is a list-admin or not. List-admins have access to all lists but not necessarily other functionality.
	*
	* @var Boolean
	*/
	var $listadmin = null;

	/**
	* The 'listadmintype'.
	*
	* @see ListAdminTypes
	*
	* @var Char
	*/
	var $listadmintype = 'c';

	/**
	* Whether this user is a template-admin or not. Template-admins can create, approve, globalise any template in the system.
	*
	* @var Boolean
	*/
	var $templateadmin = null;

	/**
	* Whether this user is a user-admin or not.
	*
	* @var Boolean
	*/
	var $useradmin = null;

	/**
	* The 'templateadmintype'.
	*
	* @see TemplateAdminTypes
	*
	* @var Char
	*/
	var $templateadmintype = 'c';

	/**
	 * Whether this uses is a segment-admin or not. Segment-admins have access to all segments but not necessarily other functionalities.
	 *
	 * @var Boolean
	 */
	var $segmentadmin = null;

	/**
	 * The "SegmentAdminType"
	 *
	 * @see SegmentAdminTypes
	 *
	 * @var Char
	 */
	var $segmentadmintype = 'c';

	/**
	* Whether the user can edit it's own settings.
	*
	* @var Boolean
	*/
	var $editownsettings = false;

	/**
	* Whether the user can use the xml api or not.
	*
	* @var Boolean
	*/
	var $xmlapi = false;

	/**
	* A random token for the user to use the xml api.
	*/
	var $xmltoken = null;

	/**
	* Whether the user has access to the wysiwyg editor or not.
	*
	* @var Boolean
	*/
	var $usewysiwyg = true;

	/**
	* Whether or not to disable XHTML editing when using wysiwyg editor
	*
	* This option is derived from usewysiwyg.
	* If usewysiwyg is other than 2, usexhtml will be set to true,
	* If usewysiwyg is EQUAL to 2, usexhtml will be set to false
	*
	* @var Boolean
	*/
	var $usexhtml = true;

	/**
	 * Whether or not to enable "Activity Log" activity tracking
	 * @var Boolean
	 */
	var $enableactivitylog = false;

	/**
	* The array of user permissions.
	*
	* @var Array
	*/
	var $permissions = array();

	/**
	* Settings The array of user settings.
	*
	* @var Array
	*/
	var $settings = array();

	/**
	* The users password. This is only set by the users area after updating.
	*
	* @var String
	*/
	var $password = null;

	/**
	* The timezone the user is in.
	*
	* @var String
	*/
	var $usertimezone = 'GMT';

	/**
	* The text footer that the user has. This gets included at the bottom of every text email sent.
	*
	* @var String
	*/
	var $textfooter = '';

	/**
	* The html footer that the user has. This gets included at the bottom of every html email sent.
	*
	* @var String
	*/
	var $htmlfooter = '';

	/**
	 * A unique token assigned to the user
	 *
	 * @var String
	 */
	var $unique_token = '';

	/**
	* Which steps of the Getting Started wizard the user has completed. This is set to 0 for none, 2 for the getting started guide step and 1 for all steps.
	*
	* @var Int
	*/
	var $gettingstarted = 1;

	/**
	* Default Order to show users in.
	*
	* @see GetUsers
	*
	* @var String
	*/
	var $DefaultOrder = 'username';

	/**
	* Default direction to show users in.
	*
	* @see GetUsers
	*
	* @var String
	*/
	var $DefaultDirection = 'up';

	/**
	* An array of valid sorts that we can use here. This makes sure someone doesn't change the query to try and create an sql error.
	*
	* @see GetTemplates
	*
	* @var Array
	*/
	var $ValidSorts = array('username' => 'UserName', 'name' => 'FullName');

	/**
	* An array of administrator types and their language variables.
	*
	* @see GetAdminTypes
	*
	* @var Array
	*/
	//var $AdminTypes = array('a' => 'SystemAdministrator', 'l' => 'ListAdministrator', 'n' => 'NewsletterAdministrator', 't' => 'TemplateAdministrator', 'u' => 'UserAdministrator', 'c' => 'Custom');
	var $AdminTypes = array('a' => 'SystemAdministrator', 'b' => 'AgencyAdministrator', 'c' => 'RegularUser', 'd' => 'Custom', 'o' => 'ReportUser');
	/**
	* An array of list administrator types and their language variables.
	*
	* @see GetListAdminTypes
	*
	* @var Array
	*/
	var $ListAdminTypes = array('a' => 'AllLists', 'c' => 'Custom');

	/**
	 * An array of segment administrator types and their language variables.
	 *
	 * @see User_API::GetSegmentAdminTypes()
	 *
	 * @var Array
	 */
	var $SegmentAdminTypes = array('a' => 'AllSegments', 'c' => 'Custom');

	/**
	* An array of template administrator types and their language variables.
	*
	* @see GetTemplateAdminTypes
	*
	* @var Array
	*/
	var $TemplateAdminTypes = array('a' => 'AllTemplates', 'c' => 'Custom');

	/**
	* An array of permission types a user can have.
	* This allows fine grain control over what the user can do.
	*
	* @see LoadPermissions
	* @see SavePermissions
	* @see GrantAccess
	* @see RevokeAccess
	*
	* @var Array
	*/
	var $PermissionTypes = array(
		'autoresponders' => array(
			'create', 'edit', 'delete', 'approve'
		),
		'forms' => array(
			'create', 'edit', 'delete'
		),
		'newsletters' => array(
			'create', 'edit', 'delete', 'approve', 'send'
		),
		'templates' => array(
			'create', 'edit', 'delete', 'approve', 'import', 'global', 'builtin'
		),
		'subscribers' => array(
			'manage', 'add', 'edit', 'delete', 'import', 'export', 'banned', 'eventsave', 'eventdelete', 'eventupdate'
		),
		'lists' => array(
			'create','edit','delete', 'bounce', 'bouncesettings'
		),
		'customfields' => array(
			'create','edit','delete'
		),
		'system' => array(
			'system', 'list', 'user', 'template'
		),
		'statistics' => array(
			'newsletter', 'user', 'autoresponder', 'list', 'triggeremails'
		),
		'user' => array(
			'smtp', 'smtpcom'
		),
		'segments' => array(
			'view', 'create', 'edit', 'delete', 'send'
		),
		'triggeremails' => array(
			'create', 'edit', 'delete', 'activate'
		)
	);

	/**
	* access
	* The areas this user has specific access to, mainly lists and templates.
	* This allows fine-grain control over what the user can do.
	*
	* @see LoadPermissions
	* @see SavePermissions
	*
	* @var Array
	*/
	var $access = array('lists' => array(), 'templates' => array(), 'segments' => array());

	/**
	* maxlists
	* The number of lists this user can create.
	*
	* @var int
	*/
	var $maxlists = 0;

	/**
	* unlimitedmaxemails
	* Whether the user has a maximum number of emails they are allowed to send.
	* We need an extra check here because the maxemails variable changes as emails get sent out.
	* If it reaches 0 then they would be allowed to send unlimited emails.
	*
	* @var int
	*/
	var $unlimitedmaxemails = true;

	/**
	* maxemails
	* The number of emails this user can send in total.
	*
	* @var int
	*/
	var $maxemails = 0;

	/**
	* permonth
	* The number of emails this user can send per month.
	*
	* @var int
	*/
	var $permonth = 0;

	/**
	* perhour
	* The number of emails this user can send per hour.
	*
	* @var int
	*/
	var $perhour = 0;

	/**
	* infotips
	* Whether this user wants to see info tips or not.
	*
	* @var boolean
	*/
	var $infotips = false;

	/**
	* The smtp server name specific for this user.
	*
	* @var String
	*/
	var $smtpserver = '';

	/**
	* The smtp username specific for this user.
	*
	* @var String
	*/
	var $smtpusername = '';

	/**
	* The smtp password specific for this user.
	*
	* @var String
	*/
	var $smtppassword = '';

	/**
	* The smtp port specific for this user.
	*
	* @var String
	*/
	var $smtpport = 25;

	/**
	* createdate
	* When the user was created
	*
	* @var int
	*/
	var $createdate = 0;

	/**
	* lastloggedin
	* When the user last logged in.
	*
	* @var int
	*/
	var $lastloggedin = 0;

	/**
	* forgotpasscode
	* A random code sent to the user when they forget their password.
	*
	* @var string
	*/
	var $forgotpasscode = '';

	/**
	* googlecalendarusername
	* Username to login to Google calendar
	*
	* @var String
	*/
	var $googlecalendarusername = '';

	/**
	* googlecalendarpassword
	* Password to login to Google calendar
	*
	* @var String
	*/
	var $googlecalendarpassword = '';

	/**
	* user_language
	* Language chosen by current user to be used for display
	*
	* @var String
	*/
	var $user_language = '';

	/**
	 * eventactivitytype
	 * Event Activity type
	 *
	 * @var String Serialized array of event activity type
	 */
	var $eventactivitytype = '';
	
	
	/* BEGIN VARIABLE MOD 2/9/09 */
	/**
	* Company Name used for CANN spam
	*
	* @var String
	*/
	var $companyname = '';
	
	/**
	* First line of company address for CANN spam
	*
	* @var String
	*/
	var $companyaddress1 = '';
	
	/**
	* Second line of company address for CANN spam
	*
	* @var String
	*/
	var $companyaddress2 = '';
	
	/**
	* City of the company address for CANN spam
	*
	* @var String
	*/
	var $companycity = '';
	
	/**
	* State abbreviation of the company address for CANN spam
	*
	* @var String
	*/
	var $companystate = '';
	
	/**
	* Postal/Zip code of the company address for CANN spam
	*
	* @var String
	*/
	var $companypostcode = '';
	
	/**
	 * mtaheader
	 * Our Virtual MTA Header - Sendlabs
	 * 
	 * @var String custom header to select a VMTA
	 */
	var $mtaheader = '';
	
	/**
	 * enableheader
	 * Enable Standard Header
	 * 
	 * Addon 2/9/09
	 * @var Boolean
	 */
	var $enableheader = true;
	
	/**
	 * enablefooter
	 * Enable Standard Footer
	 * 
	 * Addon 2/9/09
	 * @var Boolean
	 */
	var $enablefooter = true;
	
	/**
	 * enablefooterlogo
	 * Enable Standard Footer Logo
	 * 
	 * Addon 2/9/09
	 * @var Boolean
	 */
	var $enablefooterlogo = true;
	
	/**
	 * returnpathemail
	 * The returnpath e-mail to use for rendering tests.
	 * 
	 * Addon 2/9/09
	 * @var String
	 */
	var $returnpathemail = '';
	
	/**
	 * returnpathenabled
	 * Determines if the client has return path enabled
	 * 
	 * Addon 2/9/09
	 * @var Boolean
	 */
	var $returnpathenabled = false;

	/* END VARIABLE MOD 2/9/09 */
	
	/**
	 * litmusuid
	 * Unique litmus id
	 */
	
	var $litmusuid = '';
	
	/**
	 * litmuscredits
	 * Total litmus credits / tokens
	 */
	
	var $litmuscredits = 0;
	
	/**
	 * litmusunlimited
	 * Determines if litmus is set to unlimited
	 */
	var $litmusunlimited = 0;
	
	/**
	* Constructor
	* Sets up the database object, loads the user if the ID passed in is not 0.
	*
	* @param Int $userid The userid of the user to load. If it is 0 then you get a base class only. Passing in a userid > 0 will load that user.
	*
	* @see GetDb
	* @see Load
	*
	* @return True|Load If no userid is present, this always returns true. Otherwise it returns the status from Load
	*/
	function User_API($userid=0)
	{
		$this->GetDb();
		if ($userid > 0) {
			return $this->Load($userid);
		}
		return true;
	}

	/**
	* Load
	* Loads up the user and sets the appropriate class variables. Calls LoadPermissions to load up access to areas and items.
	*
	* @param Int $userid The userid to load up. If the userid is not present then it will not load up. If the userid doesn't exist in the database, then this will also return false.
	* @param Boolean $load_permissions Whether to load the users permissions or not. This defaults to true (so they are loaded) but the stats area doesn't need to load up permissions so it will pass in false.
	*
	* @see LoadPermissions
	*
	* @return Boolean Will return false if the userid is not present, or the user can't be found, otherwise it set the class vars and return true.
	*/
	function Load($userid=0, $load_permissions=true)
	{
		$userid = intval($userid);

		if ($userid <= 0) {
			return false;
		}

		$query = 'SELECT * FROM ' . SENDSTUDIO_TABLEPREFIX . 'users WHERE userid=\'' . $userid . '\'';
		$result = $this->Db->Query($query);
		if (!$result) {
			return false;
		}

		$user = $this->Db->Fetch($result);
		if (empty($user)) {
			return false;
		}

		$this->userid = $user['userid'];
		$this->username = $user['username'];
		$this->unique_token = isset($user['unique_token']) ? $user['unique_token'] : '';
		$this->status = ($user['status'] == 1) ? true : false;
		$this->admintype = $user['admintype'];
		$this->listadmintype = $user['listadmintype'];
		$this->templateadmintype = $user['templateadmintype'];
		$this->editownsettings = ($user['editownsettings'] == 1) ? true : false;
		$this->infotips = ($user['infotips'] == 1) ? true : false;
		$this->fullname = $user['fullname'];
		$this->emailaddress = $user['emailaddress'];
		$this->usertimezone = $user['usertimezone'];
		$this->textfooter = '';
		$this->htmlfooter = '';
		$this->maxlists = $user['maxlists'];
		$this->maxemails = $user['maxemails'];
		$this->perhour = $user['perhour'];
		$this->permonth = $user['permonth'];
		$this->unlimitedmaxemails = (int)$user['unlimitedmaxemails'];
		// SL7
		$this->companyname = $user['companyname'];
		$this->companyaddress1 = $user['companyaddress1'];
		$this->companyaddress2 = $user['companyaddress2'];
		$this->companycity = $user['companycity'];
		$this->companystate = $user['companystate'];
		$this->companypostcode = $user['companypostcode'];
		$this->usertimezone = $user['usertimezone'];
		$this->enableheader = $user['enableheader'] == 1;
		$this->enablefooter = $user['enablefooter'] == 1;
		$this->enablefooterlogo = $user['enablefooterlogo'] == 1;
		$this->returnpathemail = $user['returnpathemail'];
		$this->returnpathenabled = $user['returnpathenabled'] == 1;
		$this->mtaheader = $user['mtaheader'];
		
		$litmusquery = "SELECT * FROM " . SENDSTUDIO_TABLEPREFIX . "litmus WHERE userid='" . $this->userid . "'";
		$litmusresult = $this->Db->Query($litmusquery);
		if($litmusresult)
		{
			$litmus = $this->Db->Fetch($litmusresult);
			$this->litmuscredits = $litmus['litmuspoints'];
			$this->litmusunlimited = $litmus['unlimited'];
			$this->litmusuid = $litmus['litmuskey'];
		}
		

		if (isset($user['eventactivitytype'])) {
			$this->eventactivitytype = $user['eventactivitytype'];
		} else {
			$this->eventactivitytype = array();
		}

		if (isset($user['user_language'])) {
			$this->user_language = $user['user_language'];
		}

		if (isset($user['usewysiwyg'])) {
			$wysiwyg = intval($user['usewysiwyg']);
			if ($wysiwyg == 0) {
				$this->usewysiwyg = 0;
			} else {
				$this->usewysiwyg = 1;
				if ($wysiwyg == 2) {
					$this->usexhtml = false;
				}
			}
		}

		if (isset($user['xmltoken']) && isset($user['xmlapi'])) {
			if ($user['xmlapi'] == 1) {
				$this->xmlapi = 1;
			}

			if ($user['xmltoken'] != null && $user['xmltoken'] != '') {
				$this->xmltoken = $user['xmltoken'];
			}
		}

		$this->enableactivitylog = false;
		if (isset($user['enableactivitylog']) && $user['enableactivitylog'] == 1) {
			 $this->enableactivitylog = true;
		}

		$this->smtpserver = $user['smtpserver'];
		$this->smtpusername = $user['smtpusername'];
		$this->smtppassword = base64_decode($user['smtppassword']);
		$this->smtpport = (int)$user['smtpport'];
		if ($this->smtpport <= 0) {
			$this->smtpport = 25;
		}

		/**
		 * Only set the google details if they are available.
		 */
		if (isset($user['googlecalendarusername'])) {
			$this->googlecalendarusername = $user['googlecalendarusername'];
			$this->googlecalendarpassword = $user['googlecalendarpassword'];
		}

		$this->lastloggedin = (int)$user['lastloggedin'];
		$this->createdate = (int)$user['createdate'];

		$this->forgotpasscode = $user['forgotpasscode'];

		/**
		 * Only load the gettingstarted option if it's available
		 * It was added as part of an upgrade so may not necessarily be there all the time.
		*/
		if (isset($user['gettingstarted'])) {
			$this->gettingstarted = $user['gettingstarted'];
		}

		/**
		 * Only load the segmentadmintype if it's available
		 * It was added as part of an upgrade so may not necessarily be there all the time.
		 */
		if (isset($user['segmentadmintype'])) {
			$this->segmentadmintype = $user['segmentadmintype'];
		}

		if ($load_permissions) {
			$this->LoadPermissions($userid);
		}

		if ($user['settings'] != '') {
			$this->settings = unserialize($user['settings']);
		}

		if (is_null($this->segmentadmintype)) {
			$this->segmentadmintype = $this->AdminType();
		}

		return true;
	}

	
	
	/**
	* GetStatesList
	* Gets a list of options for states and selects the passed in state.
	*
	* @param String $stateabbr The abbreviation of the state to mark as selected.
	* 
	* @return String The list of options for the state select
	*
	*/
	function GetStatesList($stateabbr = false)
	{
		$optionList = '';
		$stateQuery = 'SELECT stateabbr, statename FROM '. SENDSTUDIO_TABLEPREFIX .'states';
		$stateRes = $this->Db->Query($stateQuery);
		while($stateRow = $this->Db->Fetch($stateRes))
		{
			$selected = $stateRow['stateabbr'] == $stateabbr ? 'SELECTED':'';
			$optionList .= '<option value="'.$stateRow['stateabbr']."\" $selected >".$stateRow['stateabbr'] .' - '. ucwords(strtolower($stateRow['statename'])).'</option>';
		}
		return $optionList;
	}
	
	
	/**
	* LoadPermissions
	* Loads up user permissions for the userid passed in.
	* This loads up specific areas (lists -> create/edit/delete, newsletters -> create/edit/delete) and access to specific items (lists with id's 1,2,3 and templates with id's 4,5,6).
	*
	* @param Int $userid Userid to load up permissions for.
	*
	* @see permissions
	* @see access
	*
	* @return True if permissions are loaded correctly. Otherwise returns false.
	*/
	function LoadPermissions($userid=0)
	{
		$userid = (int)$userid;
		if ($userid <= 0) {
			return false;
		}

		$query = "SELECT area, subarea FROM " . SENDSTUDIO_TABLEPREFIX . "user_permissions WHERE userid='" . (int)$userid . "'";
		$result = $this->Db->Query($query);
		$permissions = array();
		while ($row = $this->Db->Fetch($result)) {
			// reset the permissions array if it's not a proper array
			if (!in_array($row['area'], array_keys($permissions))) {
				$permissions[$row['area']] = array();
			}
			array_push($permissions[$row['area']], $row['subarea']);
		}
		$this->permissions = $permissions;


		$access = $this->access;

		$query = "SELECT area, id FROM " . SENDSTUDIO_TABLEPREFIX . "user_access WHERE userid='" . (int)$userid . "'";
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			// reset the access array if it's not a proper array
			if (!in_array($row['area'], array_keys($access))) {
				$access[$row['area']] = array();
			}
			array_push($access[$row['area']], $row['id']);
		}
		$this->access = $access;

		return true;
	}

	/**
	* SavePermissions
	* This saves the user permissions and access based on the class variables already set. It revokes all permissions and access then re-adds them one by one according to this->permissions and this->access.
	* Lists and templates in this->access are all revoked then re-added.
	*
	* @see GetDb
	* @see permissions
	* @see access
	*
	* @return Boolean Returns false if the user isn't loaded. Otherwise, returns true.
	*/
	function SavePermissions()
	{
		if ($this->userid <= 0) {
			return false;
		}

		$this->GetDb();

		$this->Db->StartTransaction();

		$qry = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "user_permissions WHERE userid='" . (int)$this->userid . "'";
		$this->Db->Query($qry);

		foreach ($this->permissions as $area => $p) {
			foreach ($p as $k => $subarea) {
				$qry = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "user_permissions (userid, area, subarea) VALUES('" . (int)$this->userid . "', '" . $this->Db->Quote($area) . "', '" . $this->Db->Quote($subarea) . "')";
				$this->Db->Query($qry);
			}
		}

		$qry = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "user_access WHERE userid='" . (int)$this->userid . "'";
		$this->Db->Query($qry);

		foreach ($this->access['lists'] as $p => $listid) {
			$listid = (int)$listid;
			if ($listid <= 0) {
				continue;
			}

			$qry = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "user_access (userid, area, id) VALUES('" . (int)$this->userid . "', 'lists', '" . $this->Db->Quote($listid) . "')";
			$this->Db->Query($qry);
		}

		foreach ($this->access['templates'] as $p => $templateid) {
			$templateid = (int)$templateid;
			if ($templateid <= 0) {
				continue;
			}

			$qry = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "user_access (userid, area, id) VALUES('" . (int)$this->userid . "', 'templates', '" . $this->Db->Quote($templateid) . "')";
			$this->Db->Query($qry);
		}

		foreach ($this->access['segments'] as $p => $segmentid) {
			$segmentid = (int)$segmentid;
			if ($segmentid <= 0) {
				continue;
			}

			$qry = 'INSERT INTO ' . SENDSTUDIO_TABLEPREFIX . 'user_access (userid, area, id) VALUES(' . intval($this->userid) . ", 'segments', " . intval($segmentid) . ')';
			$this->Db->Query($qry);
		}

		$this->Db->CommitTransaction();

		return true;
	}

	/**
	* FilterData
	* Filters the object variables before they are used in a Create or a Save operation.
	*
	* @return Void Does not return anything.
	*/
	function FilterData()
	{
		// Username and password should be trimmed, because we trim it on authentication
		$this->username = trim($this->username);
		$this->password = trim($this->password);
	}

	/**
	* Validate
	* Checks that the supplied object variables match model requirements.
	*
	* @param String $action The action being performed, e.g. create, save.
	*
	* @return Boolean True if all tested data validates, otherwise false.
	*/
	function Validate($action)
	{
		$fields = array(
			'username' => '/\w{3}/',
			'password' => '/[^\s]{3}/',
			);
		// A blank password during a save means they are not updating the password.
		if ($action == 'save' && empty($this->password)) {
			$fields['password'] = '//';
		}
		foreach ($fields as $field=>$pattern) {
			if (!preg_match($pattern, $this->$field)) {
				return false;
			}
		}
		return true;
	}

	/**
	* Create
	* This function creates a user based on the current class vars and then save permissions once it has a new userid from the database.
	*
	* @return False|Int Returns false if it couldn't create a user, otherwise returns the new userid.
	*/
	function Create()
	{
		/*if (!ss9024kwehbehb()) {
			return -1;
		}*/

		$this->FilterData();

		if (!$this->Validate('create')) {
			return false;
		}

		require_once (SENDSTUDIO_API_DIRECTORY . '/authentication.php');
		$authentication_api = new AuthenticationSystem();

		$processed_unique_token = $authentication_api->GetNewUniqueToken(SENDSTUDIO_LICENSEKEY . $this->username);
		$processed_password = $authentication_api->GeneratePasswordHash($this->password, $processed_unique_token);

		if (!is_array($this->eventactivitytype)) {
			$this->eventactivitytype = array();
		}

		$query = "
			INSERT INTO [|PREFIX|]users (
				username, password, unique_token, status, emailaddress, fullname,
				admintype, listadmintype, templateadmintype, segmentadmintype,
				editownsettings, usertimezone,
				textfooter, htmlfooter,
				maxlists, maxemails, unlimitedmaxemails, perhour, permonth,
				infotips,
				smtpserver, smtpusername, smtppassword, smtpport,
				createdate, lastloggedin,
				usewysiwyg, xmlapi, xmltoken,
				gettingstarted, googlecalendarusername, googlecalendarpassword, eventactivitytype, companyname, companyaddress1, companyaddress2, companycity, companystate, companypostcode, returnpathemail, returnpathenabled, enableheader,  enablefooter, enablefooterlogo, mtaheader)
			VALUES (
				'" . $this->Db->Quote($this->username) . "', '" . $this->Db->Quote($processed_password) . "', '" . $this->Db->Quote($processed_unique_token) . "', '" . intval($this->status) . "', '" . $this->Db->Quote($this->emailaddress) . "', '" . $this->Db->Quote($this->fullname) . "',
				'" . $this->Db->Quote($this->admintype) . "', '" . $this->Db->Quote($this->listadmintype) . "', '" . $this->Db->Quote($this->templateadmintype) . "', '" . $this->Db->Quote($this->segmentadmintype) . "',
				'" . intval($this->editownsettings) . "', '" . $this->Db->Quote($this->usertimezone) . "',
				'" . $this->Db->Quote($this->textfooter) . "', '" . $this->Db->Quote($this->htmlfooter) . "',
				" . intval($this->maxlists) . ", " . intval($this->maxemails) . ", '" . intval($this->unlimitedmaxemails) . "', " . intval($this->perhour) . ", " . intval($this->permonth) . ",
				'" . intval($this->infotips) . "',
				'" . $this->Db->Quote($this->smtpserver) . "', '" . $this->Db->Quote($this->smtpusername) . "', '" . $this->Db->Quote(base64_encode($this->smtppassword)) . "', " . intval($this->smtpport) . ",
				" . time() . ", 0,
				'" . intval($this->usewysiwyg) . "', '" . intval($this->xmlapi) . "', '" . $this->Db->Quote($this->xmltoken) . "'
				," . intval($this->gettingstarted) . ", '" . $this->Db->Quote($this->googlecalendarusername) . "', '" . $this->Db->Quote($this->googlecalendarpassword) . "', '" . serialize($this->eventactivitytype) . "',
				'" . $this->Db->Quote($this->companyname) . "', '" . $this->Db->Quote($this->companyaddress1) . "','" . $this->Db->Quote($this->companyaddress2) . "','" . $this->Db->Quote($this->companycity) . "', 
				'" . $this->Db->Quote($this->companystate) . "', '" . $this->Db->Quote($this->companypostcode) . "', '".$this->returnpathemail."','".(int)$this->returnpathenabled."','".(int)$this->enableheader."','".(int)$this->enablefooter."','".(int)$this->enablefooterlogo."', '".$this->mtaheader."')";

		$result = $this->Db->Query($query);

		if ($result) {
			$userid = $this->Db->LastId(SENDSTUDIO_TABLEPREFIX . 'users_sequence');
			$this->userid = $userid;
			$this->SavePermissions();
			create_user_dir($userid);
			
			// Add litmus
			$litmusquery = "INSERT INTO [|PREFIX|]litmus (litmuskey, litmuspoints, enabled, unlimited, userid) VALUES ('". $this->Db->Quote($this->litmusuid) ."', '". $this->Db->Quote($this->litmuscredits) . "', '1', '" . $this->Db->Quote($this->litmusunlimited) . "', '". $this->userid . "')";
			$this->Db->Query($litmusquery);
			
			// Add to credit history
			if($this->maxemails > 0)
			{
				require_once(dirname(__FILE__) . '/credits.php');
				$credit = new Credit_API();
				$credit->userid = $this->userid;
				$credit->creditamount = $this->maxemails;
				$credit->note = "Credits added at user creation";
				$credit->Create();
			}
			return $userid;
		}

		return false;
	}

	/**
	* Find
	* This function finds a user based on the username passed in. If they exist, it will return their userid. If they don't exist, this will return false.
	*
	* @param String $username The username to find.
	*
	* @return Int|False Will return the userid if it's found, otherwise returns false.
	*/
	function Find($username='')
	{
		if (!$username) {
			return false;
		}

		$this->GetDb();

		$query = "SELECT userid FROM " . SENDSTUDIO_TABLEPREFIX . "users WHERE username='" . $this->Db->Quote($username) . "'";
		$result = $this->Db->Query($query);
		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}
		$row = $this->Db->Fetch($result);
		if (empty($row)) {
			return false;
		}

		return $row['userid'];
	}

	/**
	* Delete
	* Delete a user from the database and revokes all of their access. Checks are done elsewhere to make sure this isn't the last active user or last admin user.
	*
	* @see LastUser
	* @see LastActiveUser
	* @see LastAdminUser
	*
	* @param Int $userid Userid of the user to delete. If not passed in, it will delete 'this' user.
	*
	* @return Boolean True if it deleted the user, false otherwise.
	*
	*/
	function Delete($userid=0)
	{
		if ($userid == 0) {
			$userid = $this->userid;
		}

		$query = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "users WHERE userid='" . $userid . "'";
		$result = $this->Db->Query($query);
		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}
		
		$query = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "litmus WHERE userid='" . $userid . "'";
		$result = $this->Db->Query($query);

		del_user_dir($userid);

		$this->access = array('lists' => array(), 'templates' => array(), 'segments' => array());
		$this->permissions = array();
		$this->SavePermissions();

		$this->userid = 0;
		$this->username = '';
		$this->fullname = '';
		$this->emailaddress = '';
		$this->status = false;
		$this->admin = false;
		$this->listadmin = false;
		$this->templateadmin = false;
		$this->infotips = false;
		$this->segmentadmin = false;

		$this->admintype = 'c';
		$this->listadmintype = 'c';
		$this->templateadmintype = 'c';

		$this->unlimitedmaxemails = true;
		$this->editownsettings = false;
		$this->password = null;
		$this->usertimezone = false;
		$this->textfooter = '';
		$this->htmlfooter = '';
		$this->maxlists = 0;
		$this->maxemails = 0;
		$this->perhour = 0;
		$this->permonth = 0;
		$this->usewysiwyg = true;
		$this->enableactivitylog = false;
		$this->gettingstarted = 1;

		$this->xmlapi = false;
		$this->xmltoken = null;

		return true;
	}

	/**
	* Save
	* This function saves the current class vars to the user.
	* It will also save permissions by calling SavePermissions unless $update_perms is false.
	*
	* @see SavePermissions
	*
	* @param Boolean $update_perms Defaults to true to save permissions, false will skip this.
	*
	* @return Boolean Returns true if it worked, false if it fails.
	*/
	function Save($update_perms = true)
	{
		$oldvalues = new User_API($this->userid);
		
		$this->FilterData();

		if (!$this->Validate('save')) {
			return false;
		}

		/**
		* @see usexhtml for what a value of 2 means.
		*/
		$useWYSIWYG = (int)$this->usewysiwyg;
		if ($this->usewysiwyg && !$this->usexhtml) {
			$useWYSIWYG = 2;
		}

		$enableactivitylog = ($this->enableactivitylog ? 1 : 0);
		if (!is_array($this->eventactivitytype)) {
			$this->eventactivitytype = array();
		}

		$this->GetDb();
		// unique_token is intentionally left out
		$query = "UPDATE [|PREFIX|]users SET username='" . $this->Db->Quote($this->username) . "', status='" . (int)$this->status . "'";
		$query .= ", fullname='" . $this->Db->Quote($this->fullname) . "', emailaddress='" . $this->Db->Quote($this->emailaddress) . "'";
		$query .= ", admintype='" . $this->admintype . "', listadmintype='" . $this->listadmintype . "', templateadmintype='" . $this->templateadmintype . "', segmentadmintype='" . $this->segmentadmintype . "'";
		$query .= ", editownsettings='" . (int)$this->editownsettings . "', usertimezone='" . $this->Db->Quote($this->usertimezone) . "'";
		$query .= ", textfooter='" . $this->Db->Quote($this->textfooter) . "', htmlfooter='" . $this->Db->Quote($this->htmlfooter) . "'";
		$query .= ", maxlists=" . (int)$this->maxlists . ", unlimitedmaxemails='" . (int)$this->unlimitedmaxemails . "', maxemails=" . (int)$this->maxemails . ", perhour=" . (int)$this->perhour . ", permonth=" . (int)$this->permonth;
		$query .= ", infotips='" . (int)$this->infotips . "', smtpserver='" . $this->Db->Quote($this->smtpserver) . "', smtpusername='" . $this->Db->Quote($this->smtpusername) . "', smtppassword='" . $this->Db->Quote(base64_encode($this->smtppassword)) . "', smtpport=" . (int)$this->smtpport;
		$query .= ", usewysiwyg='" . $useWYSIWYG . "', enableactivitylog='" . $enableactivitylog . "'";
		$query .= ", xmlapi='" . (int)$this->xmlapi . "', xmltoken='" . $this->Db->Quote($this->xmltoken) . "', gettingstarted=" . intval($this->gettingstarted);
		$query .= ", googlecalendarusername='" . $this->Db->Quote($this->googlecalendarusername) . "', googlecalendarpassword='" . $this->Db->Quote($this->googlecalendarpassword) . "'";
		$query .= ", eventactivitytype = '" . $this->Db->Quote(serialize($this->eventactivitytype)) . "',companyname='" . $this->Db->Quote($this->companyname) . "', companyaddress1='" . $this->Db->Quote($this->companyaddress1) . "'";
		$query .= ", companyaddress2='" . $this->Db->Quote($this->companyaddress2) . "', companycity='" . $this->Db->Quote($this->companycity) . "', companystate='" . $this->Db->Quote($this->companystate) . "', companypostcode='" . $this->Db->Quote($this->companypostcode) . "'";
		$query .= ", returnpathemail = '". $this->returnpathemail."', returnpathenabled = '".(int)$this->returnpathenabled."', enableheader = '".(int)$this->enableheader."', enablefooter = '".(int)$this->enablefooter."', enablefooterlogo = '".(int)$this->enablefooterlogo."', mtaheader = '".$this->mtaheader."'";

		if (!empty($this->password)) {
			require_once (SENDSTUDIO_API_DIRECTORY . '/authentication.php');
			$authentication_api = new AuthenticationSystem();

			$processedPassword = $authentication_api->GeneratePasswordHash($this->password, $this->unique_token);
			$query .= ', password=\'' . $this->Db->Quote($processedPassword) . '\'';
		}

		$query .= ' WHERE userid=\'' . $this->userid . '\'';

		$result = $this->Db->Query($query);
		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		if ($update_perms) {
			$this->SavePermissions();
		}
		
		// Update Litmus
		if($this->LitmusUserExists())
		{
			$litmusquery = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "litmus SET litmuskey='" . $this->litmusuid . "', litmuspoints='" . $this->litmuscredits . "', unlimited='" . $this->litmusunlimited . "' WHERE userid='" . $this->userid . "'";
			$res = $this->Db->Query($litmusquery);
		} else {
			$litmusquery = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "litmus (litmuskey, litmuspoints, enabled, unlimited, userid) VALUES ('". $this->Db->Quote($this->litmusuid) ."', '". $this->Db->Quote($this->litmuscredits) . "', '1', '" . $this->Db->Quote($this->litmusunlimited) . "', '". $this->userid . "')";
			$this->Db->Query($litmusquery);
		}
			
		// Update credit history
		if($this->maxemails != $oldvalues->maxemails)
		{
			require_once(dirname(__FILE__) . '/credits.php');
			$credit = new Credit_API();
			$credit->userid = $this->userid;
			$credit->creditamount = ($this->maxemails - $oldvalues->maxemails);
			$credit->note = "Credits adjusted by administrator";
			$credit->Create();
		}

		check_user_dir($this->userid);

		$this->password = null;
		return true;
	}

	/**
	* SetForgotCode
	* Changes the forgot password code sent to a user when they forget their password.
	* Returns false if the user hasn't been loaded previously.
	*
	* @see forgotpasscode
	*
	* @return Boolean Returns false if the user isn't loaded. Otherwise tries to do an update of the random code and returns the result from that.
	*/
	function ResetForgotCode($code='')
	{
		if ($this->userid <= 0) {
			return false;
		}

		if ($code == '') {
			return false;
		}

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "users SET forgotpasscode='" . $this->Db->Quote($code) . "' WHERE userid='" . (int)$this->userid . "'";
		return $this->Db->Query($query);
	}

	/**
	* UpdateLoginTime
	* Updates the time the user last logged in.
	* This is used for stats only so we can quickly see how often a particular user is logging in.
	* The user object must already be loaded. If the user is not loaded, this returns false.
	*
	* @see lastloggedin
	*
	* @return Boolean Returns false if the user isn't loaded. Otherwise tries to do an update and returns the result from that.
	*/
	function UpdateLoginTime()
	{
		if ($this->userid <= 0) {
			return false;
		}

		$timenow = $this->GetServerTime();

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX. "users SET lastloggedin='" . $this->Db->Quote($timenow) . "' WHERE userid='" . $this->Db->Quote($this->userid) . "'";
		$result = $this->Db->Query($query);

		$this->lastloggedin = $timenow;
		return $result;
	}

	/**
	* SaveSettings
	* Saves a users settings to the database (for example paging, sorting etc) based on the current class vars.
	*
	* @see GetDb
	*
	* @return Boolean Returns true if it worked ok, otherwise false.
	*/
	function SaveSettings()
	{
		$this->GetDb();
		$query = 'UPDATE ' . SENDSTUDIO_TABLEPREFIX . 'users SET settings=\'' . $this->Db->Quote(serialize($this->settings)) . '\' WHERE userid=\'' . $this->userid . '\'';

		$result = $this->Db->Query($query);
		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}
		return true;
	}

	/**
	* Status
	* Returns the users status.
	*
	* @return Boolean The users status (active/inactive).
	*/
	function Status()
	{
		return $this->status;
	}

	/**
	* InfoTips
	* Returns the users info tips choice.
	*
	* @return Boolean The users info tips choice (on/off).
	*/
	function InfoTips()
	{
		return $this->infotips;
	}

	/**
	* HasAccess
	* Make sure the current user has access to this area.
	* This will check whether the user is a listadmin, templateadmin or a full admin. If they are and you are checking the same area, then this will immediately return true.
	* If you are not any of the above (ie you are a custom user), then more specific checks are done.
	*
	* <b>Example</b>
	* <code>
	* HasAccess('Lists', 'Create');
	* </code>
	* will return true if you are a full admin, or a list admin. If you are neither, then this will check your individual permissions to see whether you can create a list.
	*
	* <b>Example</b>
	* <code>
	* HasAccess('Newsletters', 'Edit', 5);
	* </code>
	* will return true if you can edit newsletter with id '5'.
	*
	* @param String $area Name of the area to check
	* @param String $subarea Name of the SubArea to check
	* @param Int $id The specific item to check. This allows you to check whether you can edit or delete a specific item from the list (eg newsletter '1').
	*
	* @see Admin
	* @see ListAdmin
	* @see PermissionTypes
	*
	* @return Boolean True if the user has access, false if not.
	*/
	function HasAccess($area=null, $subarea=null, $id=0)
	{
		$id = (int)$id;

		/*if (!gz0pen($area, $subarea, $id, $this->userid)) {
			return false;
		}*/

		if (is_null($area)) {
			return false;
		}

		/**
		* If the area is the xmlapi, regardless of whether the user is an admin or not see if they have a token set.
		* This is an extra safe-guard so an admin user can disable the xmlapi altogether and not have any 'backdoor' sort of access.
		*/
		if ($area == 'xmlapi') {
			if ($this->xmlapi && $this->xmltoken != null) {
				return true;
			}
			return false;
		}

		if ($this->Admin()) {
			return true;
		}

		$area = strtolower($area);

		if ($area == 'lists') {
			if ($this->ListAdmin()) {
				return true;
			}
		}

		if ($area == 'segments') {
			if ($this->SegmentAdmin()) {
				return true;
			}

			if ($this->SegmentAdminType() == 'a') {
				return true;
			}
		}

		if ($area == 'users') {
			if ($this->UserAdmin()) {
				return true;
			}
		}

		if ($area == 'templates') {
			if ($this->TemplateAdmin()) {
				return true;
			}
		}

		if (empty($this->permissions)) {
			return false;
		}

		if (!in_array($area, array_keys($this->permissions))) {
			return false;
		}

		// if we're checking just a parent (eg lists) - since we are this far (it checks we have access to something) - then we'll be fine.
		if (is_null($subarea)) {
			return true;
		}

		$subarea = strtolower($subarea);

		/**
		 * if you can manage an area, you can edit the area too.
		 * This excludes "Subscribers" where there is a special permission called manage that
		 * is used to give "view" access to users
		 */
		if ($area != 'subscribers' && $subarea == 'manage') {
			$subarea = 'edit';
		}

		if ($subarea == 'copy') {
			$subarea = 'create';
		}

		if (in_array($subarea, $this->permissions[$area])) {
			if ($id <= 0) {
				return true;
			}

			// if we're checking a specific item, do it here.
			if ($area == 'templates' || $area == 'lists' || $area == 'segments') {
				if (in_array($id, $this->access[$area])) {
					return true;
				}
				if ($area == 'templates') {
					if ($this->templateadmintype == 'a') {
						return true;
					}
				}
				if ($area == 'lists') {
					if ($this->listadmintype == 'a') {
						return true;
					}
				}
				// since we're checking a specific item, if they don't have access to it already, they don't have access to it
				// so deny access.
				return false;
			} else {
				// if we happen to pass in an id for something other than templates or lists, then return true.
				// we've already checked they have access to the area with the in_array check above.
				return true;
			}
		}
		return false;
	}

	/**
	 * getPermissionTypes
	 * This gets permissions from the addons for displaying in the main area for easy assignment
	 * They are put into an 'addon_permissions' section for permissions to be displayed.
	 * This is used by the calling script to work out which permissions are built in and which are addon based permissions.
	 *
	 * @uses InterspireEvent::Trigger
	 * @see PermissionTypes
	 *
	 * @return Array Returns the built in permission types and also the extra addon permissions
	 *
	 * @uses EventData_IEM_USERAPI_GETPERMISSIONTYPES
	 */
	function getPermissionTypes()
	{
		$extra_permissions = array();

		/**
		 *
		 */
			$tempEventData = new EventData_IEM_USERAPI_GETPERMISSIONTYPES();
			$tempEventData->extra_permissions = &$extra_permissions;
			$tempEventData->trigger();

			unset($tempEventData);
		/**
		 * -----
		 */

		$this->PermissionTypes['addon_permissions'] = $extra_permissions;
		return $this->PermissionTypes;
	}
	
	/**
	* GetClientList
	* Gets a list of options for non-admin user accounts 
	*
	* @param Int Selected client Id.
	*
	* @return String The list of options for client select
	*
	*/
	function GetClientList($clientId)
	{
		$optionList = '';
		$clientQuery = "SELECT userid, companyname, fullname, admintype FROM ". SENDSTUDIO_TABLEPREFIX.'users WHERE admintype != \'a\' AND admintype != \'b\' order by companyname';
		$this->GetDb();
		$clientRes = $this->Db->Query($clientQuery) or die("IT BROKE - ".mysql_error());
		
		while($clientRow = $this->Db->Fetch($clientRes))
		{
			$selected = $clientRow['userid'] == $clientId ? 'SELECTED' : '';
			$optionList .= '<option value="'.$clientRow['userid']."\" $selected >".$clientRow['companyname'] .' ('. $this->GetAdminType($clientRow['admintype'], 1).')</option>'; 
		}
		return $optionList;
	}

	/**
	* GrantAccess
	* RevoGrantke access for this user to a particular area and possibly subarea.
	* If the area is not specified, nothing is granted.
	* If an area is specified but no subarea is specified, the whole section of permissions is granted.
	* If an area and subarea are specified, that specific permission is granted.
	*
	* <b>Example</b>
	* <code>
	* GrantAccess('Newsletters');
	* </code>
	* Will grant all access to newsletters (creating, editing, deleting, sending and so on).
	*
	* <b>Example</b>
	* <code>
	* GrantAccess('Lists', 'Create');
	* </code>
	* Will grant all access to creating new mailing lists only.
	*
	* @param String $area Area to grant access to. If not specified, this will fail.
	* @param String $subarea SubArea of area to grant access to. If not specified, all permissions for that area are granted.
	*
	* @see permissions
	* @see PermissionTypes
	*
	* @return Boolean Returns false if the area is not a valid permissions area. Otherwise permissions are granted and this will return true.
	*/
	function GrantAccess($area=null, $subarea=null)
	{
		if (is_null($area)) {
			return false;
		}

		$permission_types = $this->getPermissionTypes();

		$area = strtolower($area);

		// if it's not a base permission, check it's an addon permission.
		if (!in_array($area, array_keys($permission_types))) {

			// there are no addon permissions? bail out.
			if (!isset($permission_types['addon_permissions'])) {
				return false;
			}

			if (!isset($permission_types['addon_permissions'][$area])) {
				return false;
			}
		}

		if (is_null($subarea)) {
			$subarea = $permission_types[$area];
		}
		if (!is_array($subarea)) {
			$subarea = array($subarea);
		}

		if (!in_array($area, array_keys($this->permissions))) {
			$this->permissions[$area] = array();
		}

		foreach ($subarea as $p => $sub) {
			if (!in_array($sub, $this->permissions[$area])) {
				array_push($this->permissions[$area], $sub);
			}
		}
		return true;
	}

	/**
	* RevokeAccess
	* Revoke access for this user from a particular area and possibly subarea.
	* If the area is not specified, access to everything is revoked.
	* If an area is specified but no subarea is specified, the whole section of permissions is removed.
	*
	* <b>Example</b>
	* <code>
	* RevokeAccess('Newsletters');
	* </code>
	* Will revoke all access to newsletters (creating, editing, deleting, sending and so on).
	*
	* <b>Example</b>
	* <code>
	* RevokeAccess('Lists', 'Create');
	* </code>
	* Will revoke all access to creating new mailing lists only.
	*
	* @param String $area Area to revoke access from. If not specified, all permissions are revoked.
	* @param String $subarea SubArea of area to revoke. If not specified, all permissions for that area are revoked.
	*
	* @see permissions
	* @see PermissionTypes
	*
	* @return Boolean Returns false if the area is not a valid permissions area. Otherwise permissions are revoked and this will return true.
	*/
	function RevokeAccess($area=null, $subarea=null)
	{
		if (is_null($area)) {
			$this->permissions = array();
		}

		$area = strtolower($area);
		if (!in_array($area, array_keys($this->PermissionTypes))) {
			return false;
		}

		if (is_null($subarea)) {
			$subarea = $this->PermissionTypes[$area];
		}

		if (!is_array($subarea)) {
			$subarea = array($subarea);
		}

		if (!in_array($area, array_keys($this->permissions))) {
			$this->permissions[$area] = array();
		}

		foreach ($subarea as $p => $sub) {
			if (in_array($sub, array_keys($this->permissions[$area]))) {
				unset($this->permissions[$area][$p]);
			}
		}
		return true;
	}

	/**
	* GrantListAccess
	* Grants user access to specific lists passed in.
	*
	* @param Array $lists An array of listid's to grant access to for this user.
	*
	* @see access
	* @see GetSession
	* @see Session::Remove
	*
	* @return True Always returns true.
	*/
	function GrantListAccess($lists=array())
	{
		// reset the session so it can be set up again next time GetLists is called.
		$session = &GetSession();
		$session->Remove('UserLists');

		if (!is_array($lists)) {
			if (!in_array($lists, $this->access['lists'])) {
				array_push($this->access['lists'], $lists);
			}
			return true;
		}

		foreach ($lists as $listid => $p) {
			if (!in_array($listid, $this->access['lists'])) {
				array_push($this->access['lists'], $listid);
			}
		}
	}

	/**
	* RevokeListAccess
	* Revokes user access to specific lists passed in. If no listid's are passed in, all access is revoked.
	*
	* @param Array $lists_to_remove An array of listid's to revoke access from for this user. If none are passed in, all access is revoked.
	*
	* @see access
	* @see GetSession
	* @see Session::Remove
	*
	* @return True Always returns true.
	*/
	function RevokeListAccess($lists_to_remove=array())
	{
		// reset the session so it can be set up again next time GetLists is called.
		$session = &GetSession();
		$session->Remove('UserLists');

		if (!is_array($this->access['lists'])) {
			return true;
		}

		if (!$lists_to_remove) {
			$lists_to_remove = $this->access['lists'];
		}

		if (!is_array($lists_to_remove)) {
			$lists_to_remove = array($lists_to_remove);
		}

		foreach ($this->access['lists'] as $p => $listid) {
			if (in_array($listid, $lists_to_remove)) {
				unset($this->access['lists'][$p]);
			}
		}
		return true;
	}

	/**
	* GrantTemplateAccess
	* Grants user access to specific templates passed in.
	*
	* @param Array $templates An array of templateid's to grant access to for this user.
	*
	* @see access
	* @see GetSession
	* @see Session::Remove
	*
	* @return True Always returns true.
	*/
	function GrantTemplateAccess($templates=array())
	{
		// reset the session so it can be set up again next time GetTemplates is called.
		$session = &GetSession();
		$session->Remove('UserTemplates');

		if (!is_array($templates)) {
			if (!in_array($templates, $this->access['templates'])) {
				array_push($this->access['templates'], $templates);
			}
			return true;
		}

		foreach ($templates as $templateid => $p) {
			if (!in_array($templateid, $this->access['templates'])) {
				array_push($this->access['templates'], $templateid);
			}
		}
		return true;
	}

	/**
	* RevokeTemplateAccess
	* Revokes user access to specific templates passed in. If no templateid's are passed in, all access is revoked.
	*
	* @param Array $templates_to_remove An array of templateid's to revoke access from for this user. If none are passed in, all access is revoked.
	*
	* @see access
	* @see GetSession
	* @see Session::Remove
	*
	* @return True Always returns true.
	*/
	function RevokeTemplateAccess($templates_to_remove=array())
	{
		// reset the session so it can be set up again next time GetTemplates is called.
		$session = &GetSession();
		$session->Remove('UserTemplates');

		if (!is_array($this->access['templates'])) {
			return true;
		}

		if (!$templates_to_remove) {
			$templates_to_remove = $this->access['templates'];
		}

		if (!is_array($templates_to_remove)) {
			$templates_to_remove = array($templates_to_remove);
		}

		foreach ($this->access['templates'] as $p => $templateid) {
			if (in_array($templateid, $templates_to_remove)) {
				unset($this->access['templates'][$p]);
			}
		}

		return true;
	}

	/**
	* SetSettings
	* Set the settings to those passed in.
	*
	* @param String $area Name of the area to set settings for.
	* @param Mixed $area_val The settings to set (this could be an integer, string or array).
	*
	* @see GetSession
	* @see Session::Get
	* @see Session::Set
	* @see GetSettings
	*
	* @return Array Returns the new settings per GetSettings
	*/
	function SetSettings($area='', $area_val='')
	{
		if (!$area) {
			return false;
		}

		$this->settings[$area] = $area_val;

		// now save it in the session too.
		$session = &GetSession();
		$sessionuser = $session->Get('UserDetails');
		if ($sessionuser->userid == $this->userid) {
			$session->Set('UserDetails', $this);
		}

		return $this->GetSettings($area);
	}

	/**
	* GetSettings
	* Return the sub-array of settings based on the name passed in.
	*
	* @param String $area Name of the area to return settings for.
	*
	* @return Array Returns the settings for the area specified. If it's not an set yet, an empty array is returned.
	*/
	function GetSettings($area='')
	{
		if (!$area) {
			return false;
		}

		if (!isset($this->settings[$area])) {
			$this->settings[$area] = array();
		}

		return $this->settings[$area];
	}


	/**
	* Admin
	* Whether the current user is an admin user or not.
	*
	* @see Admin
	* @see AdminType
	*
	* @return Boolean True if they are an admin, otherwise false.
	*/
	function Admin()
	{
		// already worked out? return it.
		if (!is_null($this->admin)) {
			return $this->admin;
		}

		$admin = false;
		if ($this->admintype == 'a') {
			$admin = true;
		}

		$this->admin = $admin;
		return $this->admin;
	}

	/**
	* AdminType
	* Return the type of administrator this user is.
	*
	* @see AdminTypes
	* @see admintype
	*
	* @return Char The type of administrator this user is.
	*/
	function AdminType()
	{
		return $this->admintype;
	}

	/**
	* GetAdminType
	* Return the type of administrator this user is. It can be anything in the AdminTypes list.
	* If it's a 'c'ustom type, only 'c' is returned.
	*
	* @param Char $admintype The admintype you want to fetch.
	*
	* @see AdminTypes
	*
	* @return Char|String If it's a 'c'ustom admin type, 'c' is returned. Else, it's transformed into the full word and returned.
	*/
	function GetAdminType($admintype='a', $return_name=0)
	{
		if (!in_array($admintype, array_keys($this->AdminTypes))) {
			return false;
		}

		if ($admintype == 'c' && $return_name == 0) {
			return $admintype;
		}

		return $this->AdminTypes[$admintype];
	}

	/**
	* ListAdmin
	* Whether the current user is a list admin or not.
	*
	* @see ListAdmin
	* @see ListAdminType
	*
	* @return Boolean True if they are a list admin, otherwise false.
	*/
	function ListAdmin()
	{
		// if we've already worked this out, return it.
		if (!is_null($this->listadmin)) {
			return $this->listadmin;
		}

		$listadmin = false;

		if ($this->Admin()) {
			$listadmin = true;
		} elseif ($this->admintype == 'l') {
			$listadmin = true;
		} else {
			$listadmin = $this->HasAccess('System', 'List');
		}

		$this->listadmin = $listadmin;
		return $this->listadmin;
	}

	/**
	* ListAdminType
	* Returns the list admin type. This should either be 'c' for custom or 'a' for access to all lists.
	*
	* @see ListAdmin
	* @see listadmintype
	*
	* @return Char returns the list admin type.
	*/
	function ListAdminType()
	{
		return $this->listadmintype;
	}

	/**
	 * SegmentAdminType
	 * Returns the segment admin type. This should either be 'c' for custom or 'a' for access to all segments.
	 *
	 * @uses User_API::SegmentAdmin()
	 *
	 * @return Char returns the segment admin type
	 */
	function SegmentAdminType()
	{
		return $this->segmentadmintype;
	}

	/**
	* TemplateAdmin
	* Whether the current user is a template admin or not.
	*
	* @see TemplateAdmin
	* @see TemplateAdminType
	*
	* @return Boolean True if they are a list admin, otherwise false.
	*/
	function TemplateAdmin()
	{
		// if we've already worked this out, return it.
		if (!is_null($this->templateadmin)) {
			return $this->templateadmin;
		}

		$templateadmin = false;
		if ($this->templateadmintype == 'a') {
			$templateadmin = true;
		} else {
			$templateadmin = $this->HasAccess('System', 'Template');
		}

		$this->templateadmin = $templateadmin;
		return $this->templateadmin;
	}

	/**
	* TemplateAdminType
	* Returns the template admin type. This should either be 'c' for custom or 'a' for access to all templates.
	*
	* @see TemplateAdmin
	* @see templateadmintype
	*
	* @return Char returns the template admin type.
	*/
	function TemplateAdminType()
	{
		return $this->templateadmintype;
	}

	/**
	* UserAdmin
	* Whether the current user is a user admin or not.
	*
	* @see UserAdmin
	* @see UserAdminType
	*
	* @return Boolean True if they are a user admin, otherwise false.
	*/
	function UserAdmin()
	{
		// if we've already worked this out, return it.
		if (!is_null($this->useradmin)) {
			return $this->useradmin;
		}

		$useradmin = false;
		if ($this->admintype == 'a' || $this->admintype == 'u') {
			$useradmin = true;
		} else {
			$useradmin = $this->HasAccess('System', 'User');
		}

		$this->useradmin = $useradmin;
		return $this->useradmin;
	}

	/**
	* LastUser
	* Returns boolean on whether this is the last user or not.
	*
	* @param Int $userid Userid to check. If none is supplied, it checks this users id.
	*
	* @return Boolean True if this user is the last one, false if there are others.
	*/
	function LastUser($userid=0)
	{
		$userid = (int)$userid;
		$this->GetDb();
		$query = "SELECT COUNT(userid) AS count FROM " . SENDSTUDIO_TABLEPREFIX . "users";
		if ($userid) {
			$query .= " WHERE userid NOT IN (" . $userid . ")";
		} else {
			if ($this->userid) {
				$query .= " WHERE userid NOT IN (" . $this->userid . ")";
			}
		}
		$result = $this->Db->Query($query);

		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		$row = $this->Db->Fetch($result);
		$count = $row['count'];
		if ($count > 0) {
			return false;
		}

		return true;
	}

	/**
	* LastActiveUser
	* Returns boolean on whether this is the last active user or not.
	*
	* @param Int $userid Userid to check. If none is supplied, it checks this users id.
	*
	* @return Boolean True if this user is the last one, false if there are others.
	*/
	function LastActiveUser($userid=0)
	{
		$userid = (int)$userid;
		$query = "SELECT COUNT(userid) AS count FROM " . SENDSTUDIO_TABLEPREFIX . "users WHERE status='1'";
		if ($userid) {
			$query .= " AND userid NOT IN (" . $userid . ")";
		} else {
			if ($this->userid) {
				$query .= " AND userid NOT IN (" . $this->userid . ")";
			}
		}
		$result = $this->Db->Query($query);

		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		$row = $this->Db->Fetch($result);
		$count = $row['count'];
		if ($count > 0) {
			return false;
		}

		return true;
	}

	/**
	* LastAdminUser
	* Returns boolean on whether this is the last admin user or not.
	*
	* @param Int $userid Userid to check. If none is supplied, it checks this users id.
	*
	* @return Boolean True if this user is the last one, false if there are others.
	*/
	function LastAdminUser($userid=0)
	{
		$userid = (int)$userid;
		$this->GetDb();
		$query = "SELECT COUNT(userid) AS count FROM " . SENDSTUDIO_TABLEPREFIX . "users WHERE admintype='a'";
		if ($userid) {
			$query .= " AND userid NOT IN (" . $userid . ")";
		} else {
			if ($this->userid) {
				$query .= " AND userid NOT IN (" . $this->userid . ")";
			}
		}
		$result = $this->Db->Query($query);

		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		$row = $this->Db->Fetch($result);
		$count = $row['count'];
		if ($count > 0) {
			return false;
		}

		return true;
	}

	/**
	* EditOwnSettings
	* Whether this user can edit their own settings or not.
	*
	* @see Admin
	* @see editownsettings
	*
	* @return Boolean Returns true if they are an admin or if they can edit their own settings, otherwise false.
	*/
	function EditOwnSettings()
	{
		if ($this->Admin()) {
			return true;
		}

		return $this->editownsettings;
	}

	/**
	* GetMaxLists
	* Returns the number of lists this user can create.
	* If they are an admin or listadmin, returns -1.
	*
	* @see Admin
	* @see ListAdmin
	*
	* @return Int Returns the number of lists this user is allowed to create.
	*/
	function GetMaxLists()
	{
		if (!$this->Admin() && !$this->ListAdmin()) {
			return $this->maxlists;
		}
		return -1;
	}

	/**
	* GetAdminTypes
	* Returns the admin types listed in AdminTypes
	*
	* @see AdminTypes
	*
	* @return Array Returns the admin types listed in AdminTypes
	*/
	function GetAdminTypes()
	{
		if($this->admintype != 'a')
		{
			$this->AdminTypes = array('b' => 'AgencyAdministrator', 'c' => 'RegularUser', 'd' => 'Custom', 'o' => 'ReportUser');
		}
		return $this->AdminTypes;
	}

	/**
	* GetListAdminTypes
	* Returns the listadmin types listed in ListAdminTypes
	*
	* @see ListAdminTypes
	*
	* @return Array Returns the listadmin types listed in ListAdminTypes
	*/
	function GetListAdminTypes()
	{
		return $this->ListAdminTypes;
	}

	/**
	 * GetSegmentAdminTypes
	 * Return the segmentadmin types listed in SegmentAdminTypes
	 *
	 * @see SegmentAdminTypes
	 *
	 * @return Array Returns the segmentadmin types listed in SegmentAdminTypes
	 */
	function GetSegmentAdminTypes()
	{
		return $this->SegmentAdminTypes;
	}

	/**
	* GetTemplateAdminTypes
	* Returns the templateadmin types listed in TemplateAdminTypes
	*
	* @see TemplateAdminTypes
	*
	* @return Array Returns the templateadmin types listed in TemplateAdminTypes
	*/
	function GetTemplateAdminTypes()
	{
		return $this->TemplateAdminTypes;
	}

	/**
	* GetLists
	* Gets a list of lists that this user owns / has access to.
	* If this user is an admin or list admin user, returns everything.
	*
	* The function will delegate it's database query to Lists API.
	* This is because we need to cache the lists result to reduce the number of redundant queries
	* that resulted by this function gets called multiple times within a request.
	*
	* @param Int $userid Userid to check lists for. If it's not supplied, it checks whether this user is an admin or list admin. If they aren't, only returns lists this user owns / has access to.
	* @param Boolean $getUnconfirmedCount Get unconfirmed count along with the query (OPTIONAL)
	*
	* @see ListAdmin
	* @uses Lists_API::GetListByUserID()
	*
	* @return Array Returns an array - list of listid's this user has created (or if the user is an admin/listadmin, returns everything).
	*/
	function GetLists($userid = 0, $getUnconfirmedCount = false)
	{
		if (!$userid && !$this->userid) {
			trigger_error('This user object is not loaded with any user.... You will need to supply the userid as a parameter.', E_USER_NOTICE);
			return false;
		}

		if (!$userid) {
			$userid = $this->userid;
		}

		// If user is a "System Admin" or a "List Admin", allow to access all lists
		if ($userid == $this->userid) {
			if ($this->ListAdmin() || $this->listadmintype == 'a') {
				$userid = 0;
			}
		}

		if (!class_exists('Lists_API')) {
			require(dirname(__FILE__) . '/lists.php');
		}

		$listapi = new Lists_API();
		return $listapi->GetListByUserID($userid, $getUnconfirmedCount);
	}

	/**
	 * GetTriggerEmailsList
	 * Get a list if triggeremails that this user owns/has access to.
	 * If this user is an admin, it will returns all trigger email records.
	 *
	 * This function will delegate it's database query to TriggerEmails API.
	 *
	 * @param Int $userid Usedid to check triggeremails for. If it is not supplied, it will get currently loaded user's id
	 * @return Mixed Returns an array of available trigger emails record if successul, FALSE if it encountered any errors.
	 *
	 * @uses TriggerEmails_API::GetRecordsByUserID()
	 */
	function GetTriggerEmailsList($userid = 0)
	{
		if (!$userid && !$this->userid) {
			trigger_error('This user object is not loaded with any user.... You will need to supply the userid as a parameter.', E_USER_NOTICE);
			return false;
		}

		if (!$userid) {
			$userid = $this->userid;
		}

		// If user is a "System Admin" or a "List Admin", allow to access all triggers
		if ($userid == $this->userid) {
			if ($this->ListAdmin() || $this->listadmintype == 'a') {
				$userid = 0;
			}
		}

		if (!class_exists('TriggerEmails_API')) {
			require_once(dirname(__FILE__) . '/triggeremails.php');
		}

		$triggerapi = new TriggerEmails_API();
		return $triggerapi->GetRecordsByUserID($userid, array(), false, 0, 'all');
	}

	/**
	* GetBannedLists
	* Gets the count per list of the number of bans on each mailing list.
	* If this user has access to the global list, then the global list is added.
	*
	* @param Array $listids An array of listid's to check ban counts for.
	*
	* @see HasAccess
	* @see Subscribers::ChooseList
	*
	* @return Array Returns an array - list of listid's that have bans. If some don't have any bans, then they aren't included in the array. That will need to be worked out separately.
	*/
	function GetBannedLists($listids=array())
	{
		$this->GetDb();

		$listids = $this->CheckIntVars($listids);

		if ($this->HasAccess('Lists', 'Global')) {
			$listids[] = 'g';
		}

		if (empty($listids)) {
			return array();
		}

		$query = "SELECT list, count(banid) AS bancount FROM ";
		$query .= SENDSTUDIO_TABLEPREFIX . "banned_emails b WHERE list IN ('" . implode('\',\'', $listids) . "')";

		$query .= " GROUP BY list";

		$lists = array();
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			$lists[$row['list']] = $row['bancount'];
		}

		return $lists;
	}

	/**
	* GetTemplates
	* Gets a list of templates that this user owns / has access to.
	* If this user is an admin or list admin user, returns everything.
	*
	* @param Int $userid Userid to check lists for. If it's not supplied, it checks whether this user is an admin or template admin. If they aren't, only returns lists this user owns / has access to.
	*
	* @see TemplateAdmin
	*
	* @return Array Returns an array - list of listid's this user has created (or if the user is an admin/listadmin, returns everything).
	*/
	function GetTemplates($userid=0)
	{
		$this->GetDb();

		$qry = "SELECT templateid, name, ownerid FROM " . SENDSTUDIO_TABLEPREFIX . "templates";
		if ($userid) {
			$qry .= " t, " . SENDSTUDIO_TABLEPREFIX . "user_access a WHERE a.id=t.templateid AND a.area='templates'";
			$qry .= " OR t.ownerid='" . $this->Db->Quote($userid) . "'";
		} else {
			if (!$this->TemplateAdmin()) {
				$qry .= " WHERE ownerid='" . $this->Db->Quote($this->userid) . "'";
				if (!empty($this->access['templates'])) {
					$qry .= " OR templateid IN (" . implode(',', $this->access['templates']) . ")";
				}
				$qry .= " OR isglobal='1'";
			}
		}
		$qry .= " ORDER BY LOWER(name) ASC";

		$templates = array();
		$result = $this->Db->Query($qry);
		while ($row = $this->Db->Fetch($result)) {
			$templates[$row['templateid']] = $row['name'];
		}

		return $templates;
	}

	/**
	* CanCreateList
	* Returns whether the current user can create a list or not. Checks against the maximum allowed.
	*
	* @see Admin
	* @see ListAdmin
	* @see GetMaxLists
	* @see GetLists
	*
	* @return Mixed Returns true if the user can create a new list, returns false if they can't. Returns -1 if they have reached their limit so we can display a different message.
	*/
	function CanCreateList()
	{
		/*if (!verify($this->userid)) {
			return -1;
		}*/

		if ($this->Admin()) {
			return true;
		}

		if ($this->ListAdmin()) {
			return true;
		}

		$maxlists = $this->GetMaxLists();

		// if there is no maximum set, double check they have permission to create a list.
		if ($maxlists == 0) {
			if ($this->HasAccess('Lists', 'Create')) {
				return true;
			}
			return false;
		}

		$mylists = count(array_keys($this->GetLists()));
		if ($mylists < $maxlists) {
			if ($this->HasAccess('Lists', 'Create')) {
				return true;
			}
		} else {
			return -1;
		}
		return false;
	}

	/**
	* GetUsers
	* Returns a list of users based on the criteria passed in.
	*
	* @param Int $userid Userid to get users for. This is used to restrict to the current user only if they are not an admin user.
	* @param Array $sortinfo An array of sorting information - what to sort by and what direction.
	* @param Boolean $countonly Whether to only get a count of users, rather than the information.
	* @param Int $start Where to start in the list. This is used in conjunction with perpage for paging.
	* @param Int|String $perpage How many results to return (max).
	*
	* @see ValidSorts
	* @see DefaultOrder
	* @see DefaultDirection
	*
	* @return Mixed Returns false if it couldn't retrieve user information. Otherwise returns the count (if specified), or a list of userid's.
	*/
	function GetUsers($userid=0, $sortinfo = array(), $countonly = false, $start=0, $perpage=10)
	{
		$userid = (int)$userid;
		$start = (int)$start;

		if ($countonly) {
			$query = "SELECT COUNT(userid) AS count FROM " . SENDSTUDIO_TABLEPREFIX . "users";
			if ($userid) {
				$query .= " WHERE userid='" . $userid . "'";
			}

			$result = $this->Db->Query($query);
			if (!$result) {
				return false;
			}

			return $this->Db->FetchOne($result, 'count');
		}

		$query = "SELECT * FROM " . SENDSTUDIO_TABLEPREFIX . "users";
		if ($userid) {
			$query .= " WHERE userid='" . $userid . "'";
		}

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy'])) ? strtolower($sortinfo['SortBy']) : $this->DefaultOrder;
		$order = (in_array($order, array_keys($this->ValidSorts))) ? $this->ValidSorts[$order] : $this->DefaultOrder;

		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction'])) ? $sortinfo['Direction'] : $this->DefaultDirection;

		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc') ? 'ASC' : 'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if ($perpage != 'all' && ($start || $perpage)) {
			$query .= $this->Db->AddLimit($start, $perpage);
		}

		$result = $this->Db->Query($query);
		if (!$result) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}
		$users = array();
		while ($row = $this->Db->Fetch($result)) {
			$users[] = $row;
		}
		return $users;
	}

	/**
	* GetAvailableLinks
	* This returns an array of links that the user can choose for filtering.
	* If a specific listid is passed in, we only get links for newsletters or autoresponders that have been sent to that specific list.
	* If we don't pass in a specific listid, then we get all links for all lists that the user has access to.
	* In both cases, we check which lists the user has access to and make sure they aren't trying to access anything outside of those lists.
	* If the user has not been loaded or if they try to access a listid outside of the ones they do have access to, this returns an empty array.
	*
	* @param Mixed $listid The list to check links for. If this is not passed in, we look at all lists the user has access to. (Integer or an array of Integer)
	*
	* @return Array Returns an array of linkid's and urls that have been sent to either the listid passed in (which the user must have access to) or any of the lists the user has access to - both from autoresponders and newsletters.
	*/
	function GetAvailableLinks($listid=false)
	{
		$this->GetDb();

		$links = array();

		if ($this->userid <= 0) {
			return $links;
		}

		$listids = array();

		$lists = $this->GetLists();

		$user_listids = array_keys($lists);

		if ($listid === false) {
			$listids = $user_listids;
		} else {
			if (!is_array($listid)) {
				$listid = array($listid);
			}

			$listids = array_intersect($listid, $user_listids);
		}

		if (empty($listids)) {
			return $links;
		}

		// getlists sets up the db object so we don't need to here.

		$statids = array();
		$query = "SELECT sa.statid FROM " . SENDSTUDIO_TABLEPREFIX . "stats_autoresponders sa, " . SENDSTUDIO_TABLEPREFIX . "autoresponders a WHERE sa.autoresponderid=a.autoresponderid AND a.listid IN (" . implode(',', $listids) . ")";
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			$statids[] = $row['statid'];
		}

		$query = "SELECT snl.statid FROM " . SENDSTUDIO_TABLEPREFIX . "stats_newsletter_lists snl, " . SENDSTUDIO_TABLEPREFIX . "stats_newsletters sn WHERE snl.statid=sn.statid AND snl.listid IN (" . implode(',', $listids) . ")";
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			$statids[] = $row['statid'];
		}

		if (empty($statids)) {
			return $links;
		}

		$query = "SELECT l.linkid AS linkid, url FROM " . SENDSTUDIO_TABLEPREFIX . "links l, " . SENDSTUDIO_TABLEPREFIX . "stats_links sl WHERE sl.linkid=l.linkid AND sl.statid IN (" . implode(',', $statids) . ") GROUP BY url, l.linkid ORDER BY url ASC";
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			$links[$row['linkid']] = $row['url'];
		}

		return $links;
	}

	/**
	* GetAvailableNewsletters
	* This returns an array of newsletters that the user can choose for filtering.
	* If a specific listid is passed in, we only get newsletters that have been sent to that specific list.
	* If we don't pass in a specific listid, then we get all newsletters for all lists that the user has access to.
	* In both cases, we check which lists the user has access to and make sure they aren't trying to access anything outside of those lists.
	* If the user has not been loaded or if they try to access a listid outside of the ones they do have access to, this returns an empty array.
	*
	* @param Int $listid The list to check newsletters for. If this is not passed in, we look at all lists the user has access to.
	*
	* @return Array Returns an array of newsletterid's and newsletter names that have been sent to either the listid passed in (which the user must have access to) or any of the lists the user has access to.
	*/
	function GetAvailableNewsletters($listid=false)
	{
		$this->GetDb();

		$news = array();

		if ($this->userid <= 0) {
			return $news;
		}

		$listids = array();

		$lists = $this->GetLists();

		$user_listids = array_keys($lists);

		if ($listid === false) {
			$listids = $user_listids;
		} else {
			if (!is_array($listid)) {
				$listid = array($listid);
			}

			$listids = array_intersect($listid, $user_listids);
		}

		if (empty($listids)) {
			return $news;
		}

		$query = "SELECT n.newsletterid AS newsid, n.name AS newslettername FROM " . SENDSTUDIO_TABLEPREFIX . "stats_newsletter_lists snl, " . SENDSTUDIO_TABLEPREFIX . "stats_newsletters sn, " . SENDSTUDIO_TABLEPREFIX . "newsletters n WHERE n.newsletterid=sn.newsletterid AND snl.statid=sn.statid AND snl.listid IN (" . implode(',', $listids) . ")";
		$query .= " AND sn.trackopens=1";

		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {
			$news[$row['newsid']] = $row['newslettername'];
		}
		return $news;
	}

	/**
	 * GetNewsletters
	 *
	 * Get all available newsletter for current user.
	 *
	 * NOTE: This is different from User_API::GetAvailableNewsletters().
	 * That function will only return an array of newsletter that can be used for filtering.
	 * while this function will return ALL newsletter that the current user have access to.
	 *
	 * @return Array Returns an array of newsletter records if successful, FALSE if it encountered any error
	 */
	function GetNewsletters()
	{
		$this->GetDb();
		$userid = intval($this->userid);

		$tableName = SENDSTUDIO_TABLEPREFIX . 'newsletters';
		$queryCondition = '';

		// Make sure that the object has been "loaded" with user
		if ($userid <= 0) {
			trigger_error('This function require you to "Load" the user details first.', E_USER_NOTICE);
			return false;
		}

		// Only restrict the query if this is a regular user
		if (!$this->Admin()) {
			$queryCondition = " WHERE ownerid = {$userid}";
		}

		$result = $this->Db->Query("SELECT * FROM {$tableName}{$queryCondition}");
		if ($result == false) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		$rows = array();
		while ($row = $this->Db->Fetch($result)) {
			$rows[$row['newsletterid']] = $row;
		}

		$this->Db->FreeResult($result);

		return $rows;
	}

	/**
	* ReduceEmails
	* Reduces the maximum amount of emails the current user can send.
	*
	* @param Int $reduce_emails_by The number of emails to reduce by.
	*
	* @return Boolean True if the reduction was completed successfully, otherwise false.
	*/
	function ReduceEmails($reduce_emails_by=0)
	{
		if ($this->userid <= 0) {
			return false;
		}

		if ($this->unlimitedmaxemails) {
			return true;
		}

		$this->GetDb();
		
		

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "users SET maxemails = maxemails - " . (int)$reduce_emails_by . " WHERE userid='" . $this->userid . "'";
		$result = $this->Db->Query($query);
		
		if($result)
		{
		require_once(dirname(__FILE__) . '/credits.php');
		$credit = new Credit_API();
		$credit->SpendCredits($reduce_emails_by, 'Credits spent sending newsletter',$this->userid);
		}
		
		return $result;
	}
	
	
	/**
	 * RefundEmails
	 * Refunds credits for an email campaign that was deleted
	 * 
	 * @param Int $refund_amount
	 * 
	 * @return Boolean True if the refund was completed sucessfully. otherwise false
	 */
	
	function RefundEmails($refund_amount, $userid=0)
	{
		if ($userid <= 0)
		{
			return false;
		}
		
		$this->GetDb();
		
		

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "users SET maxemails = maxemails + " . (int)$refund_amount . " WHERE userid='" . $userid . "'";
		$result = $this->Db->Query($query);
		
		if($result)
		{
			require_once(dirname(__FILE__) . '/credits.php');
			$credit = new Credit_API();
			$credit->RefundCredits($refund_amount, 'Credits refunded from deleted send',$userid);
		}
		
		return $result;
	}

	/**
	* GetAvailableEmailsThisMonth
	* Returns the number of emails you can send "this month" based on how many you have already sent.
	*
	* This is different to "permonth" because that number doesn't get adjusted as you send out (otherwise we'd need an extra db field to store the "original" info and the adjusted info).
	*
	* Returns -1 if the user hasn't been loaded, or if the per month limit is set to 0.
	*
	* @return Int Returns the number you can send left "this month" (and this month only).
	*/
	function GetAvailableEmailsThisMonth()
	{
		if ($this->userid <= 0) {
			return -1;
		}

		if ($this->permonth == 0) {
			return -1;
		}

		$this->GetDb();

		$thismonth = AdjustTime(array (0,0,1,date('m'),1,date('Y')), true, null, true);
		$nextmonth = AdjustTime(array (0,0,1,(date('m')+1),1,date('Y')), true, null, true);

		$query = "
			SELECT	SUM(queuesize) AS queuesize
			FROM	[|PREFIX|]stats_users
			WHERE	userid='{$this->userid}'
					AND queuetime >= '{$thismonth}'
					AND queuetime < '{$nextmonth}'
					AND statid<>0
		";

		$result = $this->Db->Query($query);

		$existing_queuesize = $this->Db->FetchOne($result, 'queuesize');

		return ($this->permonth - $existing_queuesize);
	}

	/**
	 * SegmentAdmin
	 * Whether the current user is a segment admin or not.
	 *
	 * @return Boolean True if they are a segment admin, otherwise false.
	 */
	function SegmentAdmin()
	{
		// if we've already worked this out, return it.
		if (!is_null($this->segmentadmin)) {
			return $this->segmentadmin;
		}

		$segmentadmin = false;

		if ($this->Admin()) {
			$segmentadmin = true;
		} else {
			$segmentadmin = $this->HasAccess('System', 'Segments');
		}

		$this->segmentadmin = $segmentadmin;
		return $this->segmentadmin;
	}

	/**
	 * GetSegmentList
	 * Gets a list of segments that this user owns / has access to.
	 * If this user is an admin or list admin user, returns everything.
	 *
	 * The returned array will contains associated array,
	 * whereby the array index is the segment id
	 *
	 * @param Int $userid Userid to check segments for. If it's not supplied, it checks whether this user is an admin or list admin. If they aren't, only returns segments this user owns / has access to.
	 *
	 * @uses Segment_API::GetSegmentByUserID()
	 *
	 * @return Array Returns an array - list of segments this user has created (or if the user is an admin/listadmin, returns everything).
	 */
	function GetSegmentList($userid=0)
	{
		if (!$userid) {
			$userid = $this->userid;
		}

		if (!class_exists('Segment_API')) {
			require(dirname(__FILE__) . '/segment.php');
		}

		if ($this->SegmentAdmin() || $this->SegmentAdminType() == 'a') {
			$userid = null;
		}

		$segment_api = new Segment_API();
		return $segment_api->GetSegmentByUserID($userid, array(), false, 0, 'all');
	}

	/**
	* CanCreateSegment
	* Returns whether the current user can create a segment or not.
	* @return Mixed Returns true if the user can create a new list, returns false if they can't. Returns -1 if they have reached their limit so we can display a different message.
	*/
	function CanCreateSegment()
	{
		if ($this->SegmentAdmin()) {
			return true;
		}

		if ($this->HasAccess('Segments', 'Create')) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * GrantSegmentAccess
	 * Grants user access to specific segments passed in.
	 *
	 * @param Array $segments An array of segmentid's to grant access to for this user.
	 *
	 * @see access
	 *
	 * @return True Always returns true.
	 */
	function GrantSegmentAccess($segments)
	{
		if (!is_array($segments)) {
			if (!in_array($lists, $this->access['segments'])) {
				array_push($this->access['segments'], $lists);
			}
			return true;
		}

		foreach ($segments as $segmentid => $p) {
			if (!in_array($segmentid, $this->access['segments'])) {
				array_push($this->access['segments'], $segmentid);
			}
		}
	}

	/**
	 * RevokeSegmentAccess
	 * Revokes user access to specific segments passed in. If no segmentid's are passed in, all access is revoked.
	 *
	 * @param Array $segments_to_remove An array of segmentid's to revoke access from for this user. If none are passed in, all access is revoked.
	 *
	 * @see access
	 *
	 * @return True Always returns true.
	 */
	function RevokeSegmentAccess($segments_to_remove = array())
	{
		if (!is_array($this->access['segments'])) {
			return true;
		}

		if (!$segments_to_remove) {
			$segments_to_remove = $this->access['segments'];
		}

		if (!is_array($segments_to_remove)) {
			$segments_to_remove = array($segments_to_remove);
		}

		foreach ($this->access['segments'] as $p => $segmentid) {
			if (in_array($segmentid, $segments_to_remove)) {
				unset($this->access['segments'][$p]);
			}
		}
		return true;
	}

	/**
	 * SetEventActivityType
	 * Set event activity type for current user
	 *
	 * @param Array $activity_types Event activity types to be saved to current user
	 * @return Boolean Returns TRUE if successful, FALSE otherwise
	 */
	function SetEventActivityType($activity_types)
	{
		if (empty($this->userid)) {
			return false;
		}

		if (!is_array($activity_types)) {
			return false;
		}

		$serialized = serialize($activity_types);
		if (!$serialized) {
			return false;
		}

		$serialized = $this->Db->Quote($serialized);
		$status = $this->Db->Query("UPDATE [|PREFIX|]users SET eventactivitytype = '{$serialized}' WHERE userid = {$this->userid}");
		if (!$status) {
			list($error, $level) = $this->Db->GetError();
			trigger_error($error, $level);
			return false;
		}

		$this->eventactivitytype = $activity_types;

		return true;
	}

	/**
	 * AddEventActivityType
	 * Add event activity type for current user.
	 * This will add a new activity type to the list when it's not a duplicate of any existing type.
	 *
	 * @param String $activity_types Event activity type to be added
	 * @return Boolean Returns TRUE if successful, FALSE otherwise
	 */
	function AddEventActivityType($activity_type)
	{
		if (empty($this->userid)) {
			return false;
		}

		$activity_type = trim($activity_type);
		if (empty($activity_type)) {
			return true;
		}

		$activity = $this->GetEventActivityType();
		if (!is_array($activity)) {
			return false;
		}

		if (array_search($activity_type, $activity)) {
			return true;
		}

		$activity[] = $activity_type;
		return $this->SetEventActivityType($activity);
	}

	/**
	 * GetEventActivityType
	 * Get event activity type for current user
	 *
	 * @return Array Returns a list of event activity type
	 */
	function GetEventActivityType()
	{
		if (empty($this->eventactivitytype)) {
			return array();
		}

		if (is_array($this->eventactivitytype)) {
			return $this->eventactivitytype;
		}

		return unserialize($this->eventactivitytype);
	}
	
	/**
	 * LitmusUserExists
	 * Check if a litmus row exists in the db
	 * 
	 * @return Boolean true or false if a user exists
	 */
	function LitmusUserExists()
	{
		$query = "SELECT COUNT(*) as count FROM " . SENDSTUDIO_TABLEPREFIX . "litmus WHERE userid='$this->userid'";
		$result = $this->Db->Query($query);
		$row = $this->Db->FetchOne($result, 'count');
		if($row > 0)
		{
			return true;
		} else {
			return false;
		}
	}
}
