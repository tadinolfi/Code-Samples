<?php
/**
* This file has the upgrade functionality in it.
*
* @version     $Id: upgrade.php,v 1.30 2008/03/04 04:31:33 hendri Exp $
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
* Class for the upgrade process. This will run through all the queries needed to upgrade sendstudio 2004 to sendstudio nx, and change the config file.
*
* @package SendStudio
* @subpackage SendStudio_Functions
*/
class UpgradeNX extends SendStudio_Functions
{

	/**
	* Constructor
	* Just loads the language file.
	*/
	function UpgradeNX()
	{
		$this->LoadLanguageFile();
	}

	/**
	* Process
	* Works out which step we are up to in the upgrade process and passes it off for the other methods to handle.
	*
	* @return Void Works out which step you are up to and that's it.
	*/
	function Process()
	{
		$user = &GetUser();
		if (!$user->Admin()) {
			header('Location: index.php');
			print '<a href="' . SENDSTUDIO_APPLICATION_URL . '">Click here to continue</a>';
			exit();
		}

		$this->DbPermissionCheck();
		$this->DbVersionCheck();

		$step = 0;
		if (isset($_GET['Step'])) {
			$step = (int)$_GET['Step'];
		}

		if ($step <= 0) {
			$step = 0;
		}

		$handle_step = 'ShowStep_' . $step;

		$this->$handle_step();
	}

	/**
	 * DbPermissionCheck
	 * Checks if the database user has sufficient privileges to upgrade and will not allow upgrades to continue if not.
	 *
	 * @see DbVersionCheck
	 *
	 * @return Void Does not return anything.
	 */
	function DbPermissionCheck()
	{
		$db = IEM::getDatabase();
		if (IEM_Installer::DbSufficientPrivileges($db)) {
			return;
		}
		$tpl = GetTemplateSystem();
		$tpl->Assign('title', 'This Upgrade Cannot Proceed');
		$tpl->Assign('msg', '<p>The database user does not have sufficient privileges to upgrade the database. Please ensure the database user has permission to CREATE, CREATE INDEX, INSERT, SELECT, UPDATE, DELETE, ALTER and DROP.</p>');
		$this->PrintHeader();
		$tpl->ParseTemplate('Upgrade_Body');
		$this->PrintFooter();
		exit();
	}

	/**
	 * DbVersionCheck
	 * Checks if the database version is sufficient to upgrade and will not allow upgrades to continue if not.
	 *
	 * @return Void Does not return anything.
	 */
	function DbVersionCheck()
	{
		$db = IEM::getDatabase();
		$version = $db->Version();
		list($error, $msg) = IEM_Installer::DbVersionCheck(SENDSTUDIO_DATABASE_TYPE, $version);
		if (!$error) {
			return;
		}
		// See also admin/index.php for a similar message
		$tpl = GetTemplateSystem();
		$tpl->Assign('title', 'This Upgrade Cannot Proceed');
		$tpl->Assign('msg', '<p>Interspire Email Marketer requires ' . $msg['product'] . ' <em>' . $msg['req_version'] . '</em> or above to work properly. Your server is running <em>' . $msg['version'] . '</em>. To complete the installation, your web host must upgrade ' . $msg['product'] . ' to this version. Please note that this is not a software problem and it is something only your web host can change.</p>');
		$this->PrintHeader();
		$tpl->ParseTemplate('Upgrade_Body');
		$this->PrintFooter();
		exit();
	}

	/**
	* PrintHeader
	* This is a modified print-header function which does not include menus etc we need to remove.
	* It is based on the popup header and stripped as bare as possible.
	*
	* @return Void Prints the header out, doesn't return it.
	*/
	function PrintHeader()
	{
		$this->ParseTemplate('Upgrade_Header');
	}

	/**
	* PrintFooter
	* This is a modified print-footer function.
	* It is based on the popup footer and stripped as bare as possible.
	*
	* @return Void Prints the footer out, doesn't return it.
	*/
	function PrintFooter()
	{
		$this->ParseTemplate('Upgrade_Footer');
	}

	/**
	* ShowStep_0
	* This works out which upgrades are going to need to run, sets session variables and sets up javascript functionality to process the actions.
	*
	* @return Void Prints the page out, doesn't return it.
	*/
	function ShowStep_0()
	{
		$this->PrintHeader();

		$api = $this->GetApi('Settings');
		$current_db_version = $api->GetDatabaseVersion();

		$session = &GetSession();

		require(SENDSTUDIO_API_DIRECTORY . '/upgrade.php');

		$upgrade_api = new Upgrade_API();

		$upgrades_to_run = $upgrade_api->GetUpgradesToRun($current_db_version, SENDSTUDIO_DATABASE_VERSION);

		$session->Set('UpgradesToRun', $upgrades_to_run['upgrades']);

		$upgrades_done = array();
		$session->Set('DatabaseUpgradesCompleted', $upgrades_done);
		$upgrades_failed = array();
		$session->Set('DatabaseUpgradesFailed', $upgrades_failed);
		$session->Set('TotalSteps', $upgrades_to_run['number_to_run']);
		$session->Set('StepNumber', 1);
		$session->Remove('SendServerDetails');

		$previous_version = 'NX1.0';
		if (isset($upgrade_api->versions[$current_db_version])) {
			$previous_version = $upgrade_api->versions[$current_db_version];
		}
		$session->Set('PreviousVersion', $previous_version);
		$session->Set('PreviousDBVersion', $current_db_version);

		?>
			<br /><br /><br /><br />
			<table style="margin:auto;"><tr><td style="border:solid 2px #DDD; padding:20px; background-color:#FFF; width:450px;">
			<table>
				<tr>

					<td class="Heading1">
						<img src="images/logo.jpg" />
					</td>
				</tr>
				<tr>
					<td style="padding:10px 0px 5px 0px">
						<div style="display: ">
							<strong><?php echo GetLang('Upgrade_Header'); ?></strong>

							<p><?php echo sprintf(GetLang('Upgrade_Introduction'), $previous_version, GetLang('SENDSTUDIO_VERSION')); ?></p>
							<p><?php echo GetLang('Upgrade_Introduction_Part2'); ?></p>
							<p>
								<label for="sendServerDetails"><input type="checkbox" name="sendServerDetails" id="sendServerDetails" value="1" checked="checked" style="vertical-align: middle;" /> <?php echo GetLang('Upgrade_SendAnonymous_Stats'); ?></label>

								<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="alert('<?php echo GetLang('Upgrade_SendAnonymous_Stats_Alert'); ?>');" style="color:gray"><?php echo GetLang('Upgrade_SendAnonymous_Stats_What'); ?></a>
							</p>

							<input type="button" value="<?php echo GetLang('Upgrade_Button_Start'); ?>" onclick="RunUpgrade()" class="FormButton_wide" />
						</div>
					</td>
				</tr>
			</table>
			</td></tr></table>
		<script>
			function RunUpgrade() {
				var urlAppend = '';
				if($('#sendServerDetails:checked').val()) {
					urlAppend = '&sendServerDetails=1';
				}
				x = 'index.php?Page=UpgradeNX'+urlAppend+'&Step=1&keepThis=true&TB_iframe=true&height=240&width=400&modal=true&random='+new Date().getTime();
				tb_show('', x, '');
			}
		</script>
		<?php

		$this->PrintFooter();
	}

	/**
	* ShowStep_1
	* This prints out the "progress report" thickbox window which tells us which upgrade we are up to and how far in the process we are.
	*
	* @return Void Prints the page out, doesn't return it.
	*/
	function ShowStep_1()
	{
		$session = &GetSession();

		if (isset($_GET['sendServerDetails'])) {
			$session->Set('SendServerDetails', 1);
		}

		$total_steps = $session->Get('TotalSteps');

		$previous_version = $session->Get('PreviousVersion');

		$variables['ProgressTitle'] = GetLang('UpgradePopup_ProgressTitle');
		$variables['ProgressMessage'] = sprintf(GetLang('UpgradePopup_ProgressMessage'), $previous_version, GetLang('SENDSTUDIO_VERSION'));
		$variables['ProgressReport'] = '';
		$variables['ProgressStatus'] = '&nbsp;';
		$variables['ProgressURLAction'] = 'index.php?Page=UpgradeNX&Step=2&random=' . uniqid('ss');
		$variables['ProcessFinishedURL'] = 'index.php?Page=UpgradeNX&Step=3';
		$variables['ProcessFailedURL'] = 'index.php?Page=UpgradeNX&Step=4';

		print 	'<html><head><link rel="stylesheet" href="includes/styles/stylesheet.css" type="text/css"></head>'.
				'<body class="popupBody"><div class="popupContainer">';

		$template = file_get_contents(SENDSTUDIO_TEMPLATE_DIRECTORY . '/upgrade_progressreport.tpl');
		foreach ($variables as $key=>$value) {
			$template = str_replace('%%GLOBAL_'.$key.'%%', $value, $template);
		}
		print $template;

		print	'</div></body></html>';
		return;
	}

	/**
	* ShowStep_2
	* This actually runs an upgrade step and updates the status report (from step1) using javascript.
	* If a process fails, then this step immediately takes you to step 4 which prints out the error reports.
	*
	* @return Void Prints the page out, doesn't return it.
	*/
	function ShowStep_2()
	{
		$session = &GetSession();

		$upgrades_failed = $session->Get('DatabaseUpgradesFailed');

		require(SENDSTUDIO_API_DIRECTORY . '/upgrade.php');

		$upgrade_api = new Upgrade_API();

		$running_upgrade = $upgrade_api->GetNextUpgrade();

		$total_steps = $session->Get('TotalSteps');
		$step_number = $session->Get('StepNumber');

		if (!is_null($running_upgrade)) {

			$msg = sprintf(GetLang('Upgrade_Running_StepXofY'), $this->FormatNumber($step_number), $this->FormatNumber($total_steps));

			$percent = ceil(($step_number / $total_steps) * 100);

			echo "<script>";
			echo "self.parent.UpdateStatus('".$msg."', '".$percent."');\n";
			echo "</script>";
			flush();

			$upgrade_result = $upgrade_api->RunUpgrade($running_upgrade);

			$upgrades_done[] = $running_upgrade;
			$session->Set('DatabaseUpgradesCompleted', $upgrades_done);

			if (!$upgrade_result) {
				$upgrades_failed[] = $upgrade_api->Get('error');
				$session->Set('DatabaseUpgradesFailed', $upgrades_failed);
				echo "<script>\n";
				echo "self.parent.ProcessFailed();";
				echo "</script>";
				exit;
			}

			$session->Set('StepNumber', ($step_number + 1));

			// Throw back to this same page to continue the upgrade process
			echo "<script>\n";
			echo "setTimeout(function() { window.location = 'index.php?Page=UpgradeNX&Step=2&random=" . uniqid('ss') . "'; }, 10);\n";
			echo "</script>";
			exit;
		}

		echo "<script>\n";
		echo "self.parent.ProcessFinished();";
		echo "</script>";
	}

	/**
	* ShowStep_3
	* This prints the "upgrade successful, all ok" message.
	* It also calls the server-stats file to notify us of the upgrade and the server info, if the user chose to send it to us.
	*
	* @return Void Prints the page out, doesn't return it.
	*/
	function ShowStep_3()
	{
		$this->PrintHeader();
		?>
		<br /><br /><br /><br />
		<table style="margin:auto;"><tr><td style="border:solid 2px #DDD; padding:20px; background-color:#FFF; width:450px">
		<table>
			<tr>
				<td class="Heading1">
					<img src="images/logo.jpg" />
				</td>
			</tr>
			<tr>
				<td style="padding:10px 0px 5px 0px">
					<strong><?php echo sprintf(GetLang('UpgradeFinished'), GetLang('SENDSTUDIO_VERSION')); ?></strong>
					<p><a href="index.php"><?php echo GetLang('UpgradeFinished_ClickToContinue'); ?></a></p>
				</td>
			</tr>
		</table>
		</td></tr></table>
		<?php
		$session = &GetSession();
		if ($session->Get('SendServerDetails')) {
			require(IEM_PATH . '/ext/server_stats/server_stats.php');
			$previous_version = $session->Get('PreviousVersion');
			$server_stats_info = serverStats_Send('upgrade', $previous_version, GetLang('SENDSTUDIO_VERSION'), 'SS');
			if ($server_stats_info['InfoSent'] === false) {
				echo $server_stats_info['InfoImage'];
			}
		}
		$this->PrintFooter();

		if (is_file(TEMP_DIRECTORY . '/.version')) {
			@unlink(TEMP_DIRECTORY . '/.version');
		}
	}


	/**
	* ShowStep_4
	* This prints the "upgrade failed" message to send to interspire if something went wrong.
	*
	* @return Void Prints the page out, doesn't return it.
	*/
	function ShowStep_4()
	{
		$session = &GetSession();
		$errors = $session->Get('DatabaseUpgradesFailed');

		$errorReport = "Interspire Email Marketer Upgrade Error Report\n";
		$errorReport .= "----------------------------------------------\n";
		$errorReport .= gmdate("r")."\n";
		$errorReport .= "\n";
		$errorReport .= "Application URL: ".SENDSTUDIO_APPLICATION_URL."\n";
		$errorReport .= "Contact Email: ".SENDSTUDIO_EMAIL_ADDRESS."\n";
		$errorReport .= "\n";

		$errorReport .= "Upgrade Details:\n";
		$errorReport .= "----------------\n";
		$errorReport .= "Upgrade From: ".$session->Get('PreviousVersion')." (".$session->Get('PreviousDBVersion').")\n";
		$errorReport .= "Upgrade To: ".GetLang('SENDSTUDIO_VERSION')." (".SENDSTUDIO_DATABASE_VERSION.")\n";
		$errorReport .= "\n";

		$errorReport .= "Upgrade Error:\n";
		$errorReport .= "----------------\n";
		$errorReport .= implode("\n", $errors);
		$errorReport .= "\n";
		$errorReport .= "\n";

		$errorReport .= "Server Information:\n";
		$errorReport .= "---------------------\n";
		$errorReport .= "PHP Version: ".phpversion()."\n";
		$errorReport .= "Database Type: ".SENDSTUDIO_DATABASE_TYPE."\n";
		$errorReport .= "Database Version: ".SENDSTUDIO_SYSTEM_DATABASE_VERSION."\n";

		$this->PrintHeader();
		?>
		<br /><br /><br /><br />
		<table style="margin:auto;"><tr><td style="border:solid 2px #DDD; padding:20px; background-color:#FFF; width:450px">
		<table>
			<tr>
				<td class="Heading1">
						<img src="images/logo.jpg" />
				</td>
			</tr>
			<tr>
				<td style="padding:10px 0px 5px 0px">
						<strong><?php echo GetLang('Upgrade_Errors_Heading'); ?></strong>
						<p><?php echo GetLang('Upgrade_Errors_Message'); ?></p>
						<textarea class="Field400" style="width: 100%" rows="10" cols="20" onfocus="this.select();"><?php echo $errorReport; ?></textarea>
				</td>
			</tr>
		</table>
		</td></tr></table>
		<?php
		$this->PrintFooter();
	}

}
?>
