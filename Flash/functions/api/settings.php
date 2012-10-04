<?php
/**
* The Settings API.
*
* @version     $Id: settings.php,v 1.47 2008/03/05 04:38:45 chris Exp $
* @author Chris <chris@interspire.com>
*
* @package API
* @subpackage Settings_API
*/


/**
* Include the base API class if we haven't already.
*/
require_once(dirname(__FILE__) . '/api.php');

/**
* This will load settings, set them and save them all for you.
*
* @package API
* @subpackage Settings_API
*/
class Settings_API extends API
{

	/**
	* A list of the current settings. This is used by load and save to store things temporarily.
	*
	* @see Areas
	* @see Load
	* @see Save
	*
	* @var Array
	*/
	var $Settings = array();

	/**
	* Used to store the location of the settings file temporarily.
	*
	* @see Settings_API
	*
	* @var String
	*/
	var $ConfigFile = false;

	/**
	* A list of areas that we hold settings for. This is used by 'save' in conjunction with Settings to see what will get saved.
	*
	* @see Save
	*
	* @var Array
	*/
	var $Areas = array (
		'config' => array (
			'DATABASE_TYPE',
			'DATABASE_USER',
			'DATABASE_PASS',
			'DATABASE_HOST',
			'DATABASE_NAME',
			'TABLEPREFIX',
			'LICENSEKEY',
			'APPLICATION_URL',
		),

		'SMTP_SERVER',
		'SMTP_USERNAME',
		'SMTP_PASSWORD',
		'SMTP_PORT',

		'BOUNCE_ADDRESS',
		'BOUNCE_SERVER',
		'BOUNCE_USERNAME',
		'BOUNCE_PASSWORD',
		'BOUNCE_IMAP',
		'BOUNCE_EXTRASETTINGS',
		'BOUNCE_AGREEDELETE',
		'BOUNCE_AGREEDELETEALL',

		'HTMLFOOTER',
		'TEXTFOOTER',

		'FORCE_UNSUBLINK',
		'MAXHOURLYRATE',
		'MAXOVERSIZE',
		'CRON_ENABLED',
		'DEFAULTCHARSET',
		'EMAIL_ADDRESS',
		'IPTRACKING',
		'MAX_IMAGEWIDTH',
		'MAX_IMAGEHEIGHT',

		'ALLOW_EMBEDIMAGES',
		'DEFAULT_EMBEDIMAGES',

		'ALLOW_ATTACHMENTS',
		'ATTACHMENT_SIZE',

		'CRON_SEND',
		'CRON_AUTORESPONDER',
		'CRON_BOUNCE',
		'CRON_TRIGGEREMAILS_S',
		'CRON_TRIGGEREMAILS_P',

		'EMAILSIZE_WARNING',
		'EMAILSIZE_MAXIMUM',

		'SYSTEM_MESSAGE',
		'SYSTEM_DATABASE_VERSION',
		'SEND_TEST_MODE',
		'RESEND_MAXIMUM',

		'SHOW_SMTPCOM_OPTION',

		'SECURITY_WRONG_LOGIN_WAIT',
		'SECURITY_WRONG_LOGIN_THRESHOLD_COUNT',
		'SECURITY_WRONG_LOGIN_THRESHOLD_DURATION',
		'SECURITY_BAN_DURATION'
	);

	/**
	* send_options
	* The options for how often scheduled sending can run. This is used by the settings page to work out which options to show.
	*
	* @var Array
	*/
	var $send_options = array(
		'0'		=> 'disabled',
		'1'		=> '1_minute',
		'2'		=> '2_minutes',
		'5'		=> '5_minutes',
		'10'	=> '10_minutes',
		'15'	=> '15_minutes',
		'20'	=> '20_minutes',
		'30'	=> '30_minutes',
	);

	/**
	* autoresponder_options
	* The options for how often autoresponders can run. This is used by the settings page to work out which options to show.
	*
	* @var Array
	*/
	var $autoresponder_options = array(
		'0'		=> 'disabled',
		'1'		=> '1_minute',
		'2'		=> '2_minutes',
		'5'		=> '5_minutes',
		'10'	=> '10_minutes',
		'15'	=> '15_minutes',
		'20'	=> '20_minutes',
		'30'	=> '30_minutes',
		'60'	=> '1_hour',
		'120'	=> '2_hours',
		'720'	=> '12_hours',
		'1440'	=> '1_day'
	);

	/**
	* bounce_options
	* The options for how often bounce processing can run. This is used by the settings page to work out which options to show.
	*
	* @var Array
	*/
	var $bounce_options = array(
		'0'			=> 'disabled',
		'60'		=> '1_hour',
		'120'		=> '2_hours',
		'240'		=> '4_hours',
		'360'		=> '6_hours',
		'720'		=> '12_hours',
		'1440'		=> '1_day',
	);

	/**
	 * triggeremails_s_options
	 * The options for how often triggeremails send process can run. This is used by the settings page to work out which options to show.
	 *
	 * @var Array
	 */
	var $triggeremails_s_options = array(
		'0'		=> 'disabled',
		'1'		=> '1_minute',
		'2'		=> '2_minutes',
		'5'		=> '5_minutes',
		'10'	=> '10_minutes',
		'15'	=> '15_minutes',
		'20'	=> '20_minutes',
		'30'	=> '30_minutes',
	);

	/**
	 * triggeremails_p_options
	 * The options for how often triggeremails send process can run. This is used by the settings page to work out which options to show.
	 *
	 * @var Array
	 */
	var $triggeremails_p_options = array(
		'0'		=> 'disabled',
		'1440'	=> '1_day'
	);

	/**
	* If cron is enabled, this setting is checked to make sure it's working ok. This allows the settings page to show a warning about it being set up properly or not.
	*
	* @see Load
	*
	* @var Boolean
	*/
	var $cronok = false;

	/**
	* The first time cron runs it will store information in cronrun1.
	*
	* @see Load
	*
	* @var Boolean
	*/
	var $cronrun1 = 0;

	/**
	* The second time cron runs it will store information in cronrun2.
	*
	* @see Load
	*
	* @var Boolean
	*/
	var $cronrun2 = 0;

	/**
	* The database version number.
	*
	* @see Load
	*/
	var $database_version = -1;

	/**
	* Job schedule & when jobs were last run.
	*
	* @see CheckCron
	*/
	var $Schedule = array (
		'autoresponder' => array (
			'lastrun' => -1,
		),
		'bounce' => array (
			'lastrun' => -1,
		),
		'send' => array (
			'lastrun' => -1,
		),
		'triggeremails_s' => array (
			'lastrun' => -1
		),
		'triggeremails_p' => array (
			'lastrun' => -1
		)
	);

	/**
	* Constructor
	*
	* Sets the path to the config file. Loads up the database so it can check whether cron is set up properly or not.
	*
	* @param Boolean $load_settings Whether to load up the settings or not. Defaults to loading the settings.
	*
	* @see GetDb
	*
	* @return Void Doesn't return anything, just sets up the variables.
	*/
	function Settings_API($load_settings=true)
	{
		$this->ConfigFile = SENDSTUDIO_INCLUDES_DIRECTORY . '/config.php';

		if ($load_settings) {
			$db = $this->GetDb();
			$this->LoadSettings();
		}
	}

	/**
	* Load
	* Loads up the settings from the config file.
	*
	* @see CheckCron
	* @see Areas
	*
	* @return Boolean Will return false if the config file isn't present, otherwise it set the class vars and return true.
	*/
	function Load()
	{
		if (!$fp = fopen($this->ConfigFile, 'r')) {
			return false;
		}
		$contents = fread($fp, filesize($this->ConfigFile));
		fclose($fp);

		$this->LoadSettings();

		return true;
	}

	/**
	* LoadSettings
	* Loads up the settings from the database and defines all the variables that it needs to.
	* Also loads up cron to make sure that's working ok.
	*
	* It also has a hook into the settings for any addons to load their own global options.
	* <b>Example</b>
	* Split test sending has a settings event so it can have a cron job run.
	*
	* @return Void Doesn't return anything.
	*
	* @uses EventData_IEM_SETTINGSAPI_LOADSETTINGS
	*/
	function LoadSettings()
	{
		/**
		 * Trigger event
		 */
			$tempEventData = new EventData_IEM_SETTINGSAPI_LOADSETTINGS();
			$tempEventData->data = $this;
			$tempEventData->trigger();

			unset($tempEventData);
		/**
		 * -----
		 */

		$query = "SELECT * FROM " . SENDSTUDIO_TABLEPREFIX . "config_settings";
		$result = $this->Db->Query($query);

		$areas = $this->Areas;
		unset($areas['config']);

		while ($row = $this->Db->Fetch($result)) {
			$area = $row['area'];
			// eh? How did a config setting get in the db without it being in the settings api??
			if (!in_array($area, $areas)) {
				continue;
			}

			// this is for the 'upgrade' process - which moves them from the config file to being in the database.
			if (!defined('SENDSTUDIO_' . $area)) {
				define('SENDSTUDIO_' . $area, $row['areavalue']);
			}
			$k = array_search($area, $areas);
			unset($areas[$k]);
		}

		// ----- Default settings
			// Number of seconds to sleep when login failed
			if (!defined('SENDSTUDIO_SECURITY_WRONG_LOGIN_WAIT')) {
				define('SENDSTUDIO_SECURITY_WRONG_LOGIN_WAIT', 5);
			}

			// Number of attempts threshold
			if (!defined('SENDSTUDIO_SECURITY_WRONG_LOGIN_THRESHOLD_COUNT')) {
				define('SENDSTUDIO_SECURITY_WRONG_LOGIN_THRESHOLD_COUNT', 5);
			}

			// Number of seconds that wrong login threshold is checking for
			// (ie. 5 failed log in attempts in 300 seconds)
			if (!defined('SENDSTUDIO_SECURITY_WRONG_LOGIN_THRESHOLD_DURATION')) {
				define('SENDSTUDIO_SECURITY_WRONG_LOGIN_THRESHOLD_DURATION', 300);
			}

			// Ban duration
			if (!defined('SENDSTUDIO_SECURITY_BAN_DURATION')) {
				define('SENDSTUDIO_SECURITY_BAN_DURATION', 300);
			}
		// -----

		/**
		 * Addons might define their own things.
		 * To make everything work we need to go through the left over $areas items to define them.
		 * If we don't do this, then we'd get errors when we try to view the settings page
		 * as the option/variable would not be defined yet.
		 *
		 * Set them to null by default.
		 */
		foreach ($areas as $area) {
			$name = 'SENDSTUDIO_' . $area;
			if (!defined($name)) {
				define($name, null);
			}
		}

		$this->CheckCron();
	}

	/**
	* CheckCron
	* Checks whether cron has run ok and updated the settings in the database.
	* It goes through the current schedule items to set the applicable options.
	* Addons can modify the Schedule array to include their own things if they need to.
	*
	* @see cronok
	* @see Schedule
	* @see LoadSettings
	*
	* @return Boolean Returns true if the database has been updated, otherwise false.
	*/
	function CheckCron()
	{
		$cronok = false;
		$query = "SELECT * FROM " . SENDSTUDIO_TABLEPREFIX . "settings";
		$result = $this->Db->Query($query);
		$row = $this->Db->Fetch($result);
		if ($row['cronok'] == 1) {
			$cronok = true;
		}

		$this->cronok = $cronok;
		$this->cronrun1 = (int)$row['cronrun1'];
		$this->cronrun2 = (int)$row['cronrun2'];

		if (isset($row['database_version'])) {
			$this->database_version = $row['database_version'];
		} else {
			$query = "ALTER TABLE " . SENDSTUDIO_TABLEPREFIX . "settings ADD COLUMN database_version INT";
			$result = $this->Db->Query($query);
			if ($result) {
				$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "settings SET database_version='0'";
				$result = $this->Db->Query($query);
			}
		}

		$query = "SELECT * FROM " . SENDSTUDIO_TABLEPREFIX . "settings_cron_schedule";
		$result = $this->Db->Query($query);
		while ($row = $this->Db->Fetch($result)) {

			/**
			 * check if the item is in the schedule array.
			 * If it's not, then it may be an addon has defined a cron schedule but not cleaned itself up when it has been uninstalled/disabled.
			 */
			$schedule_name = $row['jobtype'];
			if (!isset($this->Schedule[$schedule_name])) {
				continue;
			}
			$this->Schedule[$schedule_name] = array('lastrun' => $row['lastrun']);
		}

		return $cronok;
	}

	/**
	 * Check whether or not cron is still running
	 *
	 * This function will check whether or not cron is still running.
	 * It does that by comparing the last known time cron has successfully run
	 * against current time...
	 *
	 * @param Int $leeway Leeway interval where cron can be skipped
	 *
	 * @return Boolean Returns TRUE if cron has been triggered as expected, FALSE otherwise
	 */
	function CheckCronStillRunning($leeway=3)
	{
		if (!$this->CheckCron()) {
			return true;
		}

		$expectedIntervalPool = array(SENDSTUDIO_CRON_SEND, SENDSTUDIO_CRON_AUTORESPONDER, SENDSTUDIO_CRON_BOUNCE, SENDSTUDIO_CRON_TRIGGEREMAILS_S, SENDSTUDIO_CRON_TRIGGEREMAILS_P);
		$expectedInterval = -1;
		$actualInterval = floor(($this->GetServerTime() - $this->cronrun2) / 60);

		foreach ($expectedIntervalPool as $item) {
			$item = intval($item);
			if ($item == 0) {
				continue;
			}

			if ($expectedInterval == -1 || $expectedInterval > $item) {
				$expectedInterval = $item;
			}
		}

		return ($actualInterval < ($expectedInterval * $leeway));
	}

	/**
	* SetRunTime
	* Sets the runtime for a particular type of job.
	* It updates the 'lastrun' variable for that particular type.
	*
	* @param String $jobtype The type of job to set the lastrun time for.
	*
	* @return Void Doesn't return anything.
	*/
	function SetRunTime($jobtype='send')
	{
		$allowed_jobtypes = array_keys($this->Schedule);

		if (!in_array($jobtype, $allowed_jobtypes)) {
			return false;
		}

		$jobtime = $this->GetServerTime();
		$jobtype = $this->Db->Quote($jobtype);

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "settings_cron_schedule SET lastrun={$jobtime} WHERE jobtype='{$jobtype}'";
		$result = $this->Db->Query($query);

		if (!$result) {
			trigger_error('Cannot set CRON schedule', E_USER_NOTICE);
			return;
		}

		$number_affected = $this->Db->NumAffected($result);
		if ($number_affected == 0) {
			$query = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "settings_cron_schedule (lastrun, jobtype) VALUES ({$jobtime}, '{$jobtype}')";
			$result = $this->Db->Query($query);
		}
	}

	/**
	* CronEnabled
	* Checks whether cron has been enabled or not.
	*
	* @param Boolean $autoresponder_check Whether this is checking autoresponders.
	*
	* @see cronok
	*
	* @return Boolean Returns true if cron is enabled, otherwise false.
	*/
	function CronEnabled($autoresponder_check=false)
	{
		/**
		 * If cron isn't enabled at all, return straight away.
		 */
		if (!SENDSTUDIO_CRON_ENABLED) {
			return false;
		}

		/**
		 * If we're just checking autoresponders, then check that particular variable.
		 */
		if ($autoresponder_check) {
			if (SENDSTUDIO_CRON_AUTORESPONDER > 0) {
				return true;
			}
			return false;
		}

		/**
		 * If we're not just checking autoresponders, return true
		 * as we're just checking whether cron is working or not.
		 */
		return true;
	}

	/**
	* DisableCron
	* This turns cron off on the settings table, clears out the last run times and also clears out settings for the cron schedule items.
	*
	* @see cronok
	*
	* @return Boolean Returns whether cron was disabled or not. It should only return false if the database somehow goes missing in the middle of the process.
	*/
	function DisableCron()
	{
		$this->cronok = false;

		$this->Db->StartTransaction();

		$query = "UPDATE " . SENDSTUDIO_TABLEPREFIX . "settings SET cronok='0', cronrun1=0, cronrun2=0";
		$res = $this->Db->Query($query);
		if (!$res) {
			$this->Db->RollbackTransaction();
			return false;
		}

		$query = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "settings_cron_schedule";
		$this->Db->Query($query);
		foreach (array_keys($this->Schedule) as $jobtype) {
			$query = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "settings_cron_schedule(jobtype, lastrun) VALUES ('" . $this->Db->Quote($jobtype) . "', 0)";
			$res = $this->Db->Query($query);
			if (!$res) {
				$this->Db->RollbackTransaction();
				return false;
			}
		}

		$this->Db->CommitTransaction();

		return true;
	}

	/**
	* Save
	* This function saves the current class vars to the settings file.
	* It checks to make sure the file is writable, then places the appropriate values in there and saves it. It uses a temporary name then copies that over the top of the old one, then removes the temporary file.
	*
	* @return Boolean Returns true if it worked, false if it fails.
	*/
	function Save()
	{
		if (!is_writable($this->ConfigFile)) {
			return false;
		}

		$tmpfname = tempnam(TEMP_DIRECTORY, 'SS_');
		if (!$handle = fopen($tmpfname, 'w')) {
			return false;
		}

		$copy = true;
		if (is_file(TEMP_DIRECTORY . '/config.prev.php')) {
			if (!@unlink(TEMP_DIRECTORY . '/config.prev.php')) {
				$copy = false;
			}
		}

		if ($copy) {
			@copy($this->ConfigFile, TEMP_DIRECTORY . '/config.prev.php');
		}

		// the old config backups were in the includes folder so try to clean them up as part of this process.
		$config_prev = SENDSTUDIO_INCLUDES_DIRECTORY . '/config.prev.php';
		if (is_file($config_prev)) {
			@unlink($config_prev);
		}

		$contents = '';
		$contents .= '<?' . 'php' . "\n\n";

		gmt($this);

		$areas = $this->Areas;
		foreach ($areas['config'] as $area) {
			$string = 'define(\'SENDSTUDIO_' . $area . '\', \'' . addslashes($this->Settings[$area]) . '\');' . "\n";
			$contents .= $string;
		}

		$contents .= 'define(\'SENDSTUDIO_IS_SETUP\', 1);' . "\n";

		$contents .= "\n" . '?>' . "\n";

		fputs($handle, $contents, strlen($contents));
		fclose($handle);
		chmod($tmpfname, 0644);

		if (!copy($tmpfname, $this->ConfigFile)) {
			return false;
		}
		unlink($tmpfname);

		$copy = true;
		if (is_file(TEMP_DIRECTORY . '/config.bkp.php')) {
			if (!@unlink(TEMP_DIRECTORY . '/config.bkp.php')) {
				$copy = false;
			}
		}

		if ($copy) {
			@copy($this->ConfigFile, TEMP_DIRECTORY . '/config.bkp.php');
		}

		// the old config backups were in the includes folder so try to clean them up as part of this process.
		$config_bkp = SENDSTUDIO_INCLUDES_DIRECTORY . '/config.bkp.php';
		if (is_file($config_bkp)) {
			@unlink($config_bkp);
		}

		unset($areas['config']);

		$query = "DELETE FROM " . SENDSTUDIO_TABLEPREFIX . "config_settings";
		$result = $this->Db->Query($query);
		foreach ($areas as $area) {
			$value = isset($this->Settings[$area]) ? $this->Settings[$area] : '';
			if ($area == 'SYSTEM_DATABASE_VERSION') {
				$value = $this->Db->FetchOne("SELECT version() AS version");
			}
			if (is_bool($value)) {
				$value = (int)$value;
			}
			$query = "INSERT INTO " . SENDSTUDIO_TABLEPREFIX . "config_settings(area, areavalue) VALUES ('" . $this->Db->Quote($area) . "', '" . $this->Db->Quote($value) . "')";
			$result = $this->Db->Query($query);
		}

		return true;
	}

	/**
	* GetDatabaseVersion
	* Gets the database version from the settings if needed.
	*
	* @return Int Returns the database version (from the config/settings table if needed).
	*/
	function GetDatabaseVersion()
	{
		if ($this->database_version == -1) {
			$this->CheckCron();
		}
		return $this->database_version;
	}

	/**
	* NeedDatabaseUpgrade
	* This checks whether a database upgrade is needed.
	*
	* It compares the database version from the config/settings to the SENDSTUDIO_DATABASE_VERSION
	* If a database upgrade is needed, then it returns true.
	* If they are the same number, then it returns false.
	*
	* @return Boolean Returns true if an upgrade is needed otherwise false.
	*/
	function NeedDatabaseUpgrade()
	{
		if ($this->database_version == -1) {
			$this->CheckCron();
		}

		if ($this->database_version < SENDSTUDIO_DATABASE_VERSION) {
			return true;
		}

		return false;
	}

	/**
	* GDEnabled
	* Function to detect if the GD extension for PHP is enabled.
	*
	* @return Boolean Returns true if GD is enabled, false if it's not
	*/
	function GDEnabled()
	{
		if (function_exists('imagecreate') && (function_exists('imagegif') || function_exists('imagepng') || function_exists('imagejpeg'))) {
			return true;
		}
		return false;
	}
}

?>
