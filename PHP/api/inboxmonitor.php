<?php
require_once(dirname(__FILE__) . '/job.php');
require_once(dirname(__FILE__) . '/user.php');

class InboxMonitor_API extends Job_API
{
	var $Debug = false;
	/**
	* Where to save debug messages.
	*
	* @see Debug
	* @see Bounce_API
	*/
	var $LogFile = null;
	
	/**
	* bounceuser The bounce username to log in with.
	*
	* @see Login
	*
	* @var String
	*/
	var $user = null;

	/**
	* bouncepassword The bounce password to log in with.
	*
	* @see Login
	*
	* @var String
	*/
	var $password = null;

	/**
	* bounceserver The server name to log in to.
	*
	* @see Login
	*
	* @var String
	*/
	var $server = null;

	/**
	* imapaccount Whether we are trying to log in to an imap account or a regular pop3 account.
	*
	* @see Login
	*
	* @var Boolean
	*/
	var $imapaccount = true;

	/**
	* extramailsettings Any extra email account settings we may need to use to log in.
	* For example '/notls' or '/nossl'
	*
	* @see Login
	*
	* @var String
	*/
	var $extramailsettings = null;

	/**
	* connection Temporarily store the connection to the email account here for easy use.
	*
	* @see Login
	* @see Logout
	* @see Delete
	* @see GetEmailCount
	* @see GetHeader
	* @see GetMessage
	*
	* @var Resource
	*/
	var $connection = null;
	
		/**
	 * Regex cache for matching subject rules
	 *
	 * This variable is used by self::ProcessEmail when matching subject to the subject rule.
	 * Processed regex string will be stored here for further use by the function.
	 *
	 * Initial value for this variable should be set to NULL.
	 *
	 * @var string|null
	 * @see self::ProcessEmail()
	 */
	var $_subjectRegex = null;

	/**
	 * The number of bytes to scan in an email to locate the delivery message.
	 * Increasing this too much will considerably slow bounce processing.
	 *
	 * @see ParseBody
	 *
	 * @var Int
	 */
	var $_peek = 10240;
	
	var $ErrorMessage = null;
	
	var $inbox_folder = null;
	
	var $spam_folder = null;
	
	public $vmta_list = array();
	
	public function __construct()
	{
		$this->GetDb();
		$this->LogFile = SMARTMTA_TEMP_DIRECTORY . '/inboxmonitor.debug.log';
	}
	
	
	public function Load($id)
	{
		$query = $this->Db->Query("SELECT * FROM seedlist WHERE id=" . $this->Db->Quote($id));
		$row = $this->Db->Fetch($query);
		if(!$row)
			return false;
		$this->server = $row['host'];
		$this->user = $row['username'];
		$this->password = $row['password'];
		$this->imapaccount = $row['imap'];
		$this->extramailsettings = '/ssl/novalidate-cert';
		return true;
	}
	
	public function Login($folder=null)
	{
		if (is_null($this->user) || is_null($this->password) || is_null($this->server)) {
			return false;
		}

		if ($this->imapaccount) {
			if (strpos($this->server, ':') === false) {
				$connection = '{' . $this->server . ':143';
			} else {
				$connection = '{' . $this->server;
			}
		} else {
			if (strpos($this->server, ':') === false) {
				$connection = '{' . $this->server . ':110/pop3';
			} else {
				$connection = '{' . $this->server . '/pop3';
			}
		}

		if ($this->extramailsettings != '') {
			$connection .= $this->extramailsettings;
		}
		
		if(!is_null($folder))
		{
			$connection .= '}' . $folder;
		} else {
			$connection .= '}INBOX';
		}

		//echo "USING CONN: " . $connection . "\n";
		

		$password = $this->password;
		
		if ($this->Debug) {
			error_log('Line ' . __LINE__ . '; connection string: ' . $connection ."\n", 3, $this->LogFile);
			error_log('Line ' . __LINE__ . '; user: ' . $this->user ."\n", 3, $this->LogFile);
			error_log('Line ' . __LINE__ . '; password: ' . $password ."\n", 3, $this->LogFile);
		}

		$inbox = @imap_open($connection, $this->user, $password);
		

		if ($this->Debug) {
			error_log('Line ' . __LINE__ . '; inbox: ' . $inbox ."\n", 3, $this->LogFile);
		}

		if (!$inbox) {
			$errormsg = imap_last_error();

			$errors = imap_errors();
			
			if (is_array($errors) && !empty($errors)) {
				$errormsg = array_shift($errors);
			} else {
				$alerts = imap_alerts();
				if (is_array($alerts) && !empty($alerts)) {
					$errormsg = array_shift($alerts);
				}
			}

			$this->ErrorMessage = $errormsg;

			if ($this->Debug) {
				error_log('Line ' . __LINE__ . '; imap_errors: ' . print_r(imap_errors(), true) ."\n", 3, $this->LogFile);
				error_log('Line ' . __LINE__ . '; imap_alerts: ' . print_r(imap_alerts(), true) ."\n", 3, $this->LogFile);
			}
			imap_alerts();
			return false;
		}
		imap_errors();
		imap_alerts();

		$this->connection = $inbox;
		return true;
	}
	
	/**
	* GetEmailCount
	* Gets the number of emails in the account based on the current connection.
	*
	* @see connection
	*
	* @return Mixed Returns false if the connection has not been established, otherwise gets the number of emails and returns that.
	*/
	function GetEmailCount()
	{
		if (is_null($this->connection)) {
			return false;
		}

		$display_errors = @ini_get('display_errors');
		@ini_set('display_errors', false);

		$count = imap_num_msg($this->connection);
		@ini_set('display_errors', $display_errors);
		return $count;
	}

	/**
	* Logout
	* Logs out of the established connection and optionally deletes messages that have been marked for deletion. Also resets the class connection variable.
	*
	* @param Boolean $delete_messages Whether to delete messages that have been marked for deletion or not.
	*
	* @see connection
	* @see Delete
	*
	* @return Boolean Returns false if the connection has not been established previously, otherwise returns true.
	*/
	function Logout($delete_messages=false)
	{
		if (is_null($this->connection)) {
			return false;
		}

		if ($delete_messages) {
			// delete any emails marked for deletion.
			$this->ExpungeEmail();
		}

		imap_close($this->connection);
		$this->connection = null;

		imap_errors();
		imap_alerts();

		return true;
	}

	/**
	* DeleteEmail
	* Marks a message for deletion when logging out of the account.
	*
	* @param Int $messageid The message to delete when logging out.
	*
	* @see connection
	* @see Logout
	*
	* @return Boolean Returns false if there is an invalid message number passed in or if there is no previous connection. Otherwise marks the message for deletion and returns true.
	*/
	function DeleteEmail($messageid=0)
	{
		$messageid = (int)$messageid;
		if ($messageid <= 0) {
			return false;
		}

		if (is_null($this->connection)) {
			return false;
		}

		imap_delete($this->connection, $messageid);
		return true;
	}
	
	/**
	* MoveEmail
	* Marks a message for movement to another folder when logging out of the account.
	*
	* @param Int $messageid The message to delete when logging out.
	* @param String $folder The name of the folder to move the email to.
	*
	* @see connection
	* @see Logout
	*
	* @return Boolean Returns false if there is an invalid message number passed in or if there is no previous connection. Otherwise marks the message for moving and returns true.
	*/
	function MoveEmail($messageid, $folder='Work')
	{
		$messageid = (int)$messageid;
		if ($messageid <= 0)
			return false;

		if (is_null($this->connection))
			return false;
		echo "\nMoving ".$messageid.' to '.$folder."\n";
		if(imap_mail_move($this->connection, $messageid, 'INBOX.'.$folder))
			return true;
		return false;
	}

	/**
	* ExpungeEmail
	* Delete all emails marked for deletion.
	*
	* @return Void Does not return anything.
	*/
	function ExpungeEmail()
	{
		imap_expunge($this->connection);
	}

	/**
	* GetHeader
	* Gets the email header(s) for a particular message.
	*
	* @param Int $messageid The message to get the header(s) for.
	*
	* @return Mixed Returns false if the messageid is invalid or if there is no established connection, otherwise returns an object of the headers (per imap_header)
	*/
	function GetHeader($messageid=0)
	{
		$messageid = (int)$messageid;
		if ($messageid <= 0) {
			return false;
		}

		if (is_null($this->connection)) {
			return false;
		}

		$header = imap_fetchheader($this->connection, $messageid);
		
		if($header && $header != '')
		{
			return $header;
		}
		return false;
	}
	
	/**
	* GetMessage
	* Returns the message body based on the messageid passed in.
	*
	* @param Int $messageid The message number to get the email body for.
	*
	* @return Mixed Returns false if an invalid message number is passed in or there is an invalid connection. Otherwise returns the whole message body.
	*/
	function GetMessage($messageid=0)
	{
		$messageid = (int)$messageid;
		if ($messageid <= 0) {
			return false;
		}

		if (is_null($this->connection)) {
			return false;
		}

		return imap_body($this->connection, $messageid);
	}
	
	/**
	 * Get message subject
	 * @param Object $header Header object
	 * @return String|False Returns email subject if successful, FALSE otherwise
	 */
	function GetSubject($header=false)
	{
		if (!is_object($header)) {
			return false;
		}

		if (!isset($header->subject)) {
			return false;
		}

		return strtolower($header->subject);
	}
	
	function GetCustomHeader($header, $body)
	{
		if (!$body) {
			return false;
		}

		//$body = preg_replace('%\s+%', ' ', $body);
		$bounce_header = '';
			if (preg_match('%' . $header . '(.*)%i', $body, $match)) {
				if ($this->Debug) {
					error_log('Line ' . __LINE__ . '; Found a oid match '.print_r($match, true)."\n", 3, $this->LogFile);
				}
				$bounce_header = trim($match[1]);
			}
		
		unset($body);

		return $bounce_header;
	}
	
	
	public function ProcessEmail($emailid)
	{
		$userapi = $this->GetApi('User');
		
		$header = $this->GetHeader($emailid);
		
		if(!$header)
		{
			return false;
		}
				
		$body = $this->GetMessage($emailid);
		
		/**
		 * Base 64 encoding is used by Microsoft Exchange, so decode them first
		 */
			if (preg_match('/\r?\n(.*?)\r?\nContent-Type\:\s*text\/plain.*?Content-Transfer-Encoding\:\sbase64\r?\n\r?\n(.*?)\1/is', substr($body, 0, $this->_peek), $matches)) {
				$body = str_replace($matches[2], base64_decode(str_replace(array("\n", "\r"), '', $matches[2])), $body);
			}
		/**
		 * -----
		 */
		
		if(!$body)
		{
			//echo "MISSING BODY";
			return false;
		}

		$vmta_header = $this->GetCustomHeader('X-SeedMTA:', $header);
		
		if(!$vmta_header || $vmta_header == '')
		{
			//echo "MISSING VMTA HEADER";
			return false;
		}
			
			
		$seed_id = $this->GetCustomHeader('X-SeedID:', $header);
		
		if(!$seed_id || $seed_id == '')
		{
			//echo "MISSING SEED HEADER";
			return false;
		}
		
		$uniq_id = $this->GetCustomHeader('X-Uniq:', $header);
		
		if(!$uniq_id || $uniq_id == '')
		{
			echo "WRONG UNIQ ID";
			return false;
		}
			
		$result = array('seedid' => $seed_id, 'vmta' => $vmta_header, 'uniqid' => $uniq_id);
		
		return $result;
	}
	
	public function GetInboxMonitorSeedlist($onlyactive=true)
	{
		$query = $this->Db->Query("SELECT * FROM seedlist" . ($onlyactive ? " WHERE active=1" : "") . " ORDER BY address ASC");
		$seedlist = array();
		while($row = $this->Db->Fetch($query))
		{
			array_push($seedlist, $row);
		}
		return $seedlist;
	}
	
	public function CreateInbox($address,$username,$password,$host,$imap=1,$active=1)
	{
		$query = $this->Db->Query("INSERT INTO seedlist (address, username, password, host, imap, active) VALUES('" . $this->Db->Quote($address) . "', '" . $this->Db->Quote($username) . "', '" . $this->Db->Quote($password) . "', '" . $this->Db->Quote($host) . "', '" . $this->Db->Quote($imap) . "', '" . $this->Db->Quote($active) . "')");
		if($query)
			return true;
		return false;
	}
	
	public function DeleteInbox($id)
	{
		$query = $this->Db->Query("DELETE FROM seedlist WHERE id=" . $id);
		if($query)
			return true;
		return false;
	}
	
	/**
	 * Activate or deactivate an inbox.
	 * @param int $id The inbox ID
	 * @param int $active 1 To activate an inbox. 0 to deactivate. 
	 */
	public function UpdateInboxStatus($id, $active=1)
	{
		$query = $this->Db->Query("UPDATE seedlist SET active=" . $active . " WHERE id=" . $id);
		if($query)
			return true;
		return false;
	}
	
	public function GetIMAPFolderStructure($seedid)
	{
		if(is_null($this->connection))
			return false;
			
		$mailboxes = imap_list($this->connection, '{' . $this->server . '}', "*");
		print_r($mailboxes);
		$folders = array();
		foreach($mailboxes as $mailbox) 
		{
			if(preg_match('%.*inbox.*%i', $mailbox))
			{
				$folders['inbox'] = str_replace('{' . $this->server . '}', '', $mailbox);
			}
			if(preg_match('%.*spam.*%i', $mailbox) || preg_match('%.*bulk.*%i', $mailbox))
			{
				$folders['spam'] = str_replace('{' . $this->server . '}', '', $mailbox);
			}
		}
		return $folders;
	}
	
	public function LoadVMTAList()
	{
		$query = $this->Db->Query("SELECT * FROM ip_pool i INNER JOIN ip_pool_user u GROUP BY i.ip ORDER BY vmta ASC");
		if(!$query)
			return false;
			
		$results = array();
		$cutoff = time() - 7200;
		while($row = $this->Db->Fetch($query))
		{
			if((int)$row['shared'] == 0)
			{
				$user = GetUser($row['userid']);
				$freq_query = $this->Db->Query("SELECT COUNT(*) as count FROM email WHERE senderid IN (" . implode(',', empty($user->approved_senders) ? array(0) : array_keys($user->approved_senders)) . ") AND senttime > " . $cutoff);
				$result = $this->Db->FetchOne($freq_query, 'count');
				if($result <= 0)
					continue;
			}
			array_push($results, $row['vmta']);
		}
		$this->vmta_list = $results;
		return true;
	}
	
	public function GetVMTA($vmta)
	{
		$query = $this->Db->Query("SELECT * FROM ip_pool WHERE vmta='" . $vmta . "'");
		if(!$query)
			return false;
			
		$result = $this->Db->Fetch($query);
		return $result;
	}
	
	public function SaveTotals($totals=array())
	{
		$this->GetDb();
		// reset the totals first
				
		foreach($totals as $vmta => $total)
		{
			$inbox_percent = 0;
			$spam_percent = 0;
			$missing_percent = 0;
			
			if(isset($total['inbox']['inbox']) && $total['inbox']['inbox'])
				$inbox_percent = $this->CalculatePercentage($total['inbox']['inbox'], $totals['seedtotal']);
			if(isset($total['spam']['spam']) && $total['spam']['spam'] > 0)
				$spam_percent = $this->CalculatePercentage($total['spam']['spam'], $totals['seedtotal']);
			if(isset($total['missing']) && $total['missing'] > 0)
				$missing_percent = $this->CalculatePercentage($total['missing'], $totals['seedtotal']);

			$vmtadata = $this->GetVMTA($vmta);
			
			if(stripos($vmta, 'vmta') !== false && $inbox_percent > 0)
			{
				$query = $this->Db->Query("INSERT INTO seedtotals (ip, vmta, shared, inbox, spam, missing, created) VALUES ('" . $vmtadata['ip'] . "', '" . $vmta . "', '" . $vmtadata['shared'] . "','" . $inbox_percent . "', '" . $spam_percent . "', '" . $missing_percent . "', UNIX_TIMESTAMP())");
			}
		}
	}
	
	public function CalculatePercentage($num_amount, $num_total)
	{
		$count1 = $num_amount / $num_total;
		$count2 = $count1 * 100;
		$percent = number_format($count2, 2);
		return $percent;
	}
	
	public function GetSeedMessages($limit=0)
	{
		$query = "SELECT * FROM seedemails ORDER BY RAND() ";
		if($limit > 0)
		{
			$query .= "LIMIT $limit";	
		}
		$result = $this->Db->Query($query);
		
		$results = array();
		while($row = $this->Db->Fetch($result))
		{
			array_push($results, $row);
		}
		return $results;
	}
	
	public function Setup()
	{
		if (is_null($this->connection))
			return false;
		$folder1 = @imap_createmailbox($this->connection, imap_utf7_encode('{' . $this->server . '}INBOX.Work'));
		$folder2 = @imap_createmailbox($this->connection, imap_utf7_encode('{' . $this->server . '}INBOX.Personal'));
		return $folder1 && $folder2;
	}
}