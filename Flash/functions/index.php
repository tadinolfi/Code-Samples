<?php
/**
 * This file has the first welcome page functions, including quickstats.
 *
 * @version     $Id: index.php,v 1.28 2008/02/08 05:47:02 chris Exp $
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
 * Class for the welcome page. Includes quickstats and so on.
 *
 * @package SendStudio
 * @subpackage SendStudio_Functions
 */
class Index extends SendStudio_Functions
{
	/**
	 * Constructor
	 * Loads the language file and Getting Started steps
	 *
	 * @see LoadLanguageFile
	 *
	 * @return Void Doesn't return anything.
	 */
	function Index()
	{
		$user = &GetUser();
		$this->LoadLanguageFile();
		$this->LoadLanguageFile('stats');
	}

	/**
	 * Process
	 * Sets up the main page. Checks access levels and so on before printing out each option. Once the areas are set up, it simply calls the parent process function to do everything.
	 *
	 * @see GetSession
	 * @see GetUser
	 * @see User_API::HasAccess
	 * @see SendStudio_Functions::Process
	 *
	 * @return Void Prints out the main page, doesn't return anything.
	 */
	function Process()
	{
		$session = &GetSession();
		$user = &GetUser();

		$action = '';
		if (isset($_GET['Action'])) {
			$action = strtolower($_GET['Action']);
		}

		$print_header = true;

		/*
		 * If it's an ajax action, don't print the header.
		 * This also affects the footer at the bottom.
		 */
		$ajax_actions = array('switch', 'subscribergraph', 'cleanupexport');
		if (in_array($action, $ajax_actions)) {
			$print_header = false;
		}

		if ($print_header) {
			$this->PrintHeader();
		}

		switch ($action) {
			case 'switch':
				if (isset($_POST['To']) && strtolower($_POST['To']) == 'quicklinks') {
					$user->SetSettings('StartLinks', 'quicklinks');
					break;
				}
				$user->SetSettings('StartLinks', 'gettingstarted');
				break;

			case 'subscribergraph':
				$this->PrintGraph();
				break;

			case 'cleanupexport':
				$this->CleanupExportFile();
				break;

			default:
				$db = IEM::getDatabase();
				$GLOBALS['Message'] = GetFlashMessages();
				
				if ($user->HasAccess('Newsletters', 'Create')) {
					$GLOBALS['Newsletters_AddButton'] = $this->ParseTemplate('Newsletter_Create_Button', true, false);
				}

				if ($user->GetSettings('StartLinks') == 'quicklinks') {
					$GLOBALS['HomeGettingStartedDisplay'] = 'display:none;';
					$GLOBALS['StartTitle'] = GetLang('IWouldLikeTo');
					$GLOBALS['SwitchLink'] = GetLang('SwitchtoGettingStartedLinks');
				} else {
					$GLOBALS['HomeQuickLinksDisplay'] = 'display:none;';
					$GLOBALS['StartTitle'] = GetLang('GettingStarted_Header');
					$GLOBALS['SwitchLink'] = GetLang('SwitchtoQuickLinks');
				}
				
				$this->GetRecentStats();

				$GLOBALS['VersionCheckInfo'] = $this->_CheckVersion();

				$GLOBALS['PanelDesc'] = '&nbsp;&nbsp;&nbsp;' . GetLang('SubscriberActivity_Last7Days');
				$GLOBALS['Image'] = 'chart_bar.gif';
				
				$GLOBALS['SubPanel'] = $this->ParseTemplate('index_subscribergraph_panel',true);
				$GLOBALS['SubscriberGraph_Last7Days'] = $this->ParseTemplate('indexpanel', true);

				$GLOBALS['DisplayBox'] = GetDisplayInfo($this, false, null);
				
				$GLOBALS['LatestBlogEntry'] = $this->GetLatestBlogEntry();

				$this->PrintSystemMessage();
				$this->ParseTemplate('Index');
		}
		
		

		if ($print_header) {
			$this->PrintFooter();
		}
	}
	
	//Added to get the stats for the newsletter. Sets all the globals. 3/5/09 - John Norton
	function GetRecentStats()
	{
		$statsapi = $this->GetApi('Stats');
		$summary = $statsapi->GetNewsletterSummary($statsapi->GetMostRecent(), false, 100);
		$GLOBALS['THISID'] = $statsapi->GetMostRecent();

		$GLOBALS['NewsletterID'] = $summary['newsletterid'];

		$sent_when = $GLOBALS['StartSending'] = $this->PrintTime($summary['starttime'], true);

		if ($summary['finishtime'] > 0) {
			$GLOBALS['FinishSending'] = $this->PrintTime($summary['finishtime'], true);
			$GLOBALS['SendingTime'] = $this->TimeDifference($summary['finishtime'] - $summary['starttime']);
		} else {
			$GLOBALS['FinishSending'] = GetLang('NotFinishedSending');
			$GLOBALS['SendingTime'] = GetLang('NotFinishedSending');
		}

		$sent_to = $summary['htmlrecipients'] + $summary['textrecipients'] + $summary['multipartrecipients'];

		$sent_size = $summary['sendsize'];

		$GLOBALS['SentToDetails'] = sprintf(GetLang('NewsletterStatistics_Snapshot_SendSize'), $this->FormatNumber($sent_to), $this->FormatNumber($sent_size));

		$test_mode_info = '';
		if ($summary['sendtestmode'] == 1) {
			$test_mode_info = GetLang('NewsletterStatistics_Send_TestMode_Enabled');
		}

		$GLOBALS['SummaryIntro'] = sprintf(GetLang('NewsletterStatistics_Snapshot_Summary'), htmlspecialchars($summary['newslettername'], ENT_QUOTES, SENDSTUDIO_CHARSET), $sent_when, $test_mode_info);

		$GLOBALS['NewsletterName'] = htmlspecialchars($summary['newslettername'], ENT_QUOTES, SENDSTUDIO_CHARSET);
		$GLOBALS['NewsletterSubject'] = htmlspecialchars($summary['newslettersubject'], ENT_QUOTES, SENDSTUDIO_CHARSET);

		$GLOBALS['UserEmail'] = htmlspecialchars($summary['emailaddress'], ENT_QUOTES, SENDSTUDIO_CHARSET);
		$sent_by = $summary['username'];
		if ($summary['fullname']) {
			$sent_by = $summary['fullname'];
		}
		$GLOBALS['SentBy'] = htmlspecialchars($sent_by, ENT_QUOTES, SENDSTUDIO_CHARSET);

		if (sizeof($summary['lists']) > 1) {
			$GLOBALS['SentToLists'] = GetLang('SentToLists');
			$GLOBALS['MailingLists'] = '';
			$break_up = 4;
			$c = 1;
			foreach ($summary['lists'] as $listid => $listname) {
				if ($c % $break_up == 0) {
					$GLOBALS['MailingLists'] .= '<br/>';
					$c = 0;
				}
				$GLOBALS['MailingLists'] .= htmlspecialchars($listname, ENT_QUOTES, SENDSTUDIO_CHARSET) . ',';
				$c++;
			}
			if (($c - 1) % $break_up != 0) {
				$GLOBALS['MailingLists'] = substr($GLOBALS['MailingLists'], 0, -1);
			}
		} else {
			$GLOBALS['SentToLists'] = GetLang('SentToList');
			$listname = current($summary['lists']);
			$GLOBALS['MailingLists'] = htmlspecialchars($listname, ENT_QUOTES, SENDSTUDIO_CHARSET);
		}
	}

	/**
	 * PrintInterspireRSS
	 * Print the latest info from an rss feed.
	 * This also caches the feed for 24 hours so it's not going to constantly cause a remote hit
	 * and should also mean subsequent views are a little faster.
	 * If a url can't be fetched, the box on the front appears empty.
	 *
	 * @param String $rss_url The RSS URL to read in and process.
	 * @param Int $number_to_display The number of entries to display from the rss feed.
	 *
	 * @return Void Doesn't return anything, just prints the top 5 entries from the feed.
	 */
	function PrintRSS($rss_url=false, $number_to_display=5)
	{
		if (!$rss_url) {
			return;
		}

		// make sure number_to_display is >= 1.
		if ((int)$number_to_display < 1) {
			$number_to_display = 5;
		}

		$check_version = false;
		$cache_file = TEMP_DIRECTORY . '/' . str_replace(array('/', '\\', '.', ';', '"', "'"), '', base64_encode($rss_url)).'.xml';
		if (!is_file($cache_file)) {
			$check_version = true;
		}

		if (is_file($cache_file)) {
			$last_hit = filemtime($cache_file);
			if ($last_hit === false) {
				$check_version = true;
			}
			if ($last_hit < (time() - 86400)) {
				$check_version = true;
			}
			// if the file is empty..
			if (filesize($cache_file) == 0) {
				$check_version = true;
			}
		}

		if ($check_version) {
			list($content, $error) = $this->GetPageContents($rss_url);
			if ($content !== false) {
				if (is_writable(TEMP_DIRECTORY)) {
					$fp = fopen($cache_file, 'w');
					fputs($fp, $content);
					fclose($fp);
				}
			}
		} else {
			$content = file_get_contents($cache_file);
		}

		if ($content !== false) {
			$items = $this->FetchXMLNode('item',$content,true);
			$i = 0;
			foreach ($items as $item) {
				$url = $this->FetchXMLNode('link',$item);
				$title = $this->FetchXMLNode('title',$item);

				preg_match('%<\!\[cdata\[(.*?)\]\]>%is', $title, $matches);
				if (isset($matches[1])) {
					echo '<li><a href="' . $url . '" target="_blank" title="' . htmlspecialchars($matches[1], ENT_QUOTES, SENDSTUDIO_CHARSET) . '">' . $this->TruncateInMiddle($matches[1]) . '</a></li>';
				} else {
					preg_match('/http:\/\/www\.viewkb\.com\/questions\/(\d*)\//is', $url, $matches);
					if (count($matches) == 2) {
						echo '<li><a href="#" onClick="LaunchHelp(\'' . $matches[1] . '\');" title="' . htmlspecialchars($title, ENT_QUOTES, SENDSTUDIO_CHARSET) . '">' . $this->TruncateInMiddle($title) . '</a></li>';
					} else {
						echo '<li><a href="' . $url . '" target="_blank" title="' . htmlspecialchars($title, ENT_QUOTES, SENDSTUDIO_CHARSET) . '">' . $this->TruncateInMiddle($title) . '</a></li>';
					}
				}
				$i++;
				if ($i >= $number_to_display) {
					break;
				}
			}
		}
	}
	
	/**
	 * GetLatestBlogEntry
	 * Fetch the latest blog entry from the customer site.
	 * 
	 * @return String Returns the latest link for the blog
	 */
	
	function GetLatestBlogEntry()
	{
		$rss_url = "http://www.sendlabs.com/syndication.axd";
		$cache_file = TEMP_DIRECTORY . '/' . str_replace(array('/', '\\', '.', ';', '"', "'"), '', base64_encode($rss_url)).'.xml';
		$check_feed = false;
		
		if (!is_file($cache_file)) {
			$check_feed = true;
		}
		
		if (is_file($cache_file)) {
				$last_hit = filemtime($cache_file);
				if ($last_hit === false) {
					$check_feed = true;
				}
				if ($last_hit < (time() - 21600)) {
					$check_feed = true;
				}
				// if the file is empty..
				if (filesize($cache_file) == 0) {
					$check_feed = true;
				}
		}
		
		if ($check_feed) {
			list($content, $error) = $this->GetPageContents($rss_url);
			if ($content !== false) {
				if (is_writable(TEMP_DIRECTORY)) {
					$fp = fopen($cache_file, 'w');
					fputs($fp, $content);
					fclose($fp);
				}
			}
		} else {
			$content = file_get_contents($cache_file);
		}
		
		if ($content !== false) {
			$items = $this->FetchXMLNode('item',$content,true);
			$url = $this->FetchXMLNode('link',$items[0]);
			$title = $this->FetchXMLNode('title',$items[0]);
				if($url != '' && $title != '')
				{
					return '<a href="' . $url . '" target="_blank" title="' . htmlspecialchars($title, ENT_QUOTES, SENDSTUDIO_CHARSET) . '">' . $this->TruncateInMiddle($title) . '</a>';
				} 
				
		}
	}

	/**
	 * _CheckVersion
	 * Shows the "you are running the latest version" .. or not ..
	 * box on the front page.
	 *
	 * This allows an IEM user to see if there's an update (either bugfix or new feature version) available.
	 * A non-admin user does not see this box.
	 * Nor does it show up if the 'SENDSTUDIO_WHITE_LABEL' variable is set to true
	 *
	 * @see init.php
	 *
	 * @return String Returns either an empty string (for a non-admin user) or "you are (or are not) running the latest version" box.
	 */
	function _CheckVersion()
	{
		$user = &GetUser();
		if (!$user->Admin() || SENDSTUDIO_WHITE_LABEL) {
			return '';
		}
		$template = "<script>
						var latest_version = '';
						var feature_version = '';
						var latest_critical = 0;
						var feature_critical = 0;
					</script>";
		$template .= '<script src="http://www.version-check.net/version.js?p=9"></script>';
		$template .= '<script>
						$.ajax({
							type: "post",
							url: "remote.php",
							data: "what=save_version&latest=" + latest_version + "&feature=" + feature_version + "&latest_critical=" + latest_critical + "&feature_critical=" + feature_critical
						});
					</script>';
		return $template;
	}

	/**
	 * CleanupExportFile
	 * Removes the export file recorded in the user's session.
	 *
	 * @return Void Does not return anything. Sets Flash Messages.
	 */
	function CleanupExportFile()
	{
		$session = &GetSession();
		$exportinfo = $session->Get('ExportInfo');

		if (!empty($exportinfo)) {
			$api = $this->GetApi('Jobs');

			if (isset($exportinfo['ExportQueue'])) {
				$queueid = $exportinfo['ExportQueue'];
				if ($queueid && is_array($queueid)) {
					foreach ($queueid as $id) {
						$api->ClearQueue($id['queueid'], 'export');
					}
				}
			}

			$exportfile = $exportinfo['ExportFile'];

			if (is_file(TEMP_DIRECTORY . '/' . $exportfile)) {
				if (@unlink(TEMP_DIRECTORY . '/' . $exportfile)) {
					$session->Remove('ExportInfo');
					FlashMessage(GetLang('ExportFileDeleted'), SS_FLASH_MSG_SUCCESS, 'index.php');
					return;
				}
			}
		}
		FlashMessage(GetLang('ExportFileNotDeleted'), SS_FLASH_MSG_ERROR, 'index.php');
	}

	/**
	 * Prints out the System Message box above quick-stats.
	 *
	 * @return String Returns the panel to put in. This is only done if there is a system message to print out.
	 */
	function PrintSystemMessage()
	{
		if (SENDSTUDIO_SYSTEM_MESSAGE && trim(SENDSTUDIO_SYSTEM_MESSAGE) != '') {
			$GLOBALS['System_Message'] = SENDSTUDIO_SYSTEM_MESSAGE;
			$GLOBALS['SystemMessage'] = $this->ParseTemplate('Index_System_Message', true, false);
		} else {
			$GLOBALS['SystemMessage'] = '';
		}
	}


	/**
	 * Prints out the Email Credits box above the Version Check.
	 *
	 * @param String $user The user object
	 *
	 * @return String Returns the panel to put in. This is only done if there is a system message to print out.
	 */
	function PrintEmailsLeft($user)
	{
		$display = false;

		$unlimited_emails = $user->Get('unlimitedmaxemails');
		if (!$unlimited_emails) {
			$GLOBALS['TotalEmailCredits'] = sprintf(GetLang('User_Total_CreditsLeft'), $this->FormatNumber($user->Get('maxemails')));
			$GLOBALS['TotalEmailCredits'] .= '.<br/>';
			$display = true;
		}

		$monthly_credits = $user->Get('permonth');
		if ($monthly_credits > 0) {
			$this_month = date('n');
			$GLOBALS['MonthlyEmailCredits'] = sprintf(GetLang('User_Monthly_CreditsLeft'), $this->FormatNumber($user->GetAvailableEmailsThisMonth()), GetLang($this->Months[$this_month] . '_Long') . '.');
			if (!$unlimited_emails) {
				$GLOBALS['MonthlyEmailCredits'];
			}
			$display = true;
		}
		if ($display == true) {
			$GLOBALS['TotalEmailsLeft'] = $this->ParseTemplate('Index_Credits_Left', true, false);
		}
	}

	/**
	 * FetchXMLNode
	 * Get XML node from xml data
	 *
	 * @param String $node The node name
	 * @param String $xml The XML data
	 * @param Boolean $all True to grab all nodes, false to grab only the first
	 *
	 * @see GetContent
	 *
	 * @return Array Returns an array of nodes
	 */
	function FetchXmlNode($node='', $xml='', $all=false)
	{
		if ($node == '') {
			return false;
		}

		if ($all) {
			preg_match_all('%<(' . $node . '[^>]*)>(.*?)</' . $node . '>%is', $xml, $matches);
		} else {
			preg_match('%<(' . $node . '[^>]*)>(.*?)</' . $node . '>%is', $xml, $matches);
		}

		if (!isset($matches[2])) {
			return false;
		}

		return $matches[2];
	}

	/**
	 * PrintGraph
	 * Prints out the graph on the front page
	 * Which shows contact activity for the last 7 days including:
	 * - signups (confirmed/unconfirmed)
	 * - bounces
	 * - unsubscribes
	 * - forwards
	 *
	 * @return Void Doesn't return anything, this just prints out the contact activity graph.
	 */
	function PrintGraph()
	{
		$user = &GetUser();
		$lists = $user->GetLists();
		$listids = array_keys($lists);
		$stats_api = $this->GetApi('Stats');

		$session = &GetSession();
		$idx_calendar = array('DateType' => 'last7days');
		$session->Set('IndexCalendar', $idx_calendar);

		$rightnow = AdjustTime(0, true);

		$today = AdjustTime(array(0, 0, 0, date('m'), date('d'), date('Y')), true, null, true);

		$time = AdjustTime(array(0, 0, 0, date('m'), date('d') - 6, date('Y')), true, null, true);

		$query = ' AND (%%TABLE%% >= ' . $time . ')';

		$restrictions = array();
		$restrictions['subscribes'] = str_replace('%%TABLE%%', 'subscribedate', $query);
		$restrictions['unsubscribes'] = str_replace('%%TABLE%%', 'unsubscribetime', $query);
		$restrictions['bounces'] = str_replace('%%TABLE%%', 'bouncetime', $query);
		$restrictions['forwards'] = str_replace('%%TABLE%%', 'forwardtime', $query);

		$data = $stats_api->GetSubscriberGraphData('last7days', $restrictions, $listids);

		require(dirname(__FILE__) . '/amcharts/amcharts.php');

		$session->Set('IndexSubscriberGraphData', $data);

		$data_url = 'stats_chart.php?graph=' . urlencode(strtolower('subscribersummary')) . '&Area='.urlencode(strtolower('list')) . '&statid=0&i=1&' . session_name() . '=' . session_id();

		$chart = InsertChart('column', $data_url);
		echo $chart;
	}
}
