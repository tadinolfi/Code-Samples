<?php
require_once(dirname(__FILE__) . '/job.php');

class Reputation_API extends Job_API
{
	public $blacklistShort = array('sbl-xbl.spamhaus.org','dnsbl.sorbs.net','bl.spamcop.net','dnsbl-1.uceprotect.net','dnsbl-2.uceprotect.net','dnsbl-3.uceprotect.net',
									'b.barracudacentral.org','zen.spamhaus.org');
	public $blacklistFull = array('asiaspam.spamblocked.com','b.barracudacentral.org','bl.deadbeef.com','bl.emailbasura.org','bl.spamcop.net','blackholes.five-ten-sg.com',
								'blacklist.woody.ch','bogons.cymru.com','cbl.abuseat.org','cdl.anti-spam.org.cn','combined.abuse.ch','combined.rbl.msrbl.net','db.wpbl.info',
								'dnsbl-1.uceprotect.net','dnsbl-2.uceprotect.net','dnsbl-3.uceprotect.net','dnsbl.abuse.ch','dnsbl.ahbl.org','dnsbl.cyberlogic.net',
								'dnsbl.inps.de','dnsbl.njabl.org','dnsbl.sorbs.net','drone.abuse.ch','duinv.aupads.org','dul.dnsbl.sorbs.net','dul.ru','dyna.spamrats.com',
								'dynip.rothen.com','eurospam.spamblocked.com','fl.chickenboner.biz','http.dnsbl.sorbs.net','images.rbl.msrbl.net','ips.backscatterer.org',
								'ix.dnsbl.manitu.net','korea.services.net','lacnic.spamblocked.com','misc.dnsbl.sorbs.net','noptr.spamrats.com','ohps.dnsbl.net.au',
								'omrs.dnsbl.net.au','orvedb.aupads.org','osps.dnsbl.net.au','osrs.dnsbl.net.au','owfs.dnsbl.net.au','owps.dnsbl.net.au','pbl.spamhaus.org',
								'phishing.rbl.msrbl.net','probes.dnsbl.net.au','proxy.bl.gweep.ca','proxy.block.transip.nl','psbl.surriel.com','rbl.interserver.net',
								'rdts.dnsbl.net.au','relays.bl.gweep.ca','relays.bl.kundenserver.de','relays.nether.net','residential.block.transip.nl','ricn.dnsbl.net.au',
								'rmst.dnsbl.net.au','sbl.spamhaus.org','short.rbl.jp','smtp.dnsbl.sorbs.net','socks.dnsbl.sorbs.net','spam.dnsbl.sorbs.net','spam.rbl.msrbl.net',
								'spam.spamrats.com','spamlist.or.kr','spamrbl.imp.ch','t3direct.dnsbl.net.au','tor.ahbl.org','tor.dnsbl.sectoor.de','torserver.tor.dnsbl.sectoor.de',
								'ubl.lashback.com','ubl.unsubscore.com','virbl.bit.nl','virus.rbl.jp','virus.rbl.msrbl.net','web.dnsbl.sorbs.net','wormrbl.imp.ch','xbl.spamhaus.org',
								'zen.spamhaus.org');
	public $Debug = false;
	
	public function __construct()
	{
		$this->GetDb();
	}
	
	public function Load()
	{
		
	}
	
	public function CheckSPFRecords($sendersids=array(),$userid=0)
	{
		if($userid > 0)
			$user = &GetUser($userid);
		else
			$user = &GetUser();
		$missing_spfs = array();

		$senderapi = $this->GetApi('Senders');
		if(empty($senderids))
			$approved_senders = $senderapi->GetApprovedSenders($user->userid);
		else
			$approved_senders = GetApprovedSendersByIds($sendersids);
		
		foreach($approved_senders as $approved_sender)
		{
			$domain = explode('@', $approved_sender['emailaddress']);
			if(isset($domain[1]))
			{
				$spf_records = dns_get_record($domain[1], DNS_TXT);
				if(empty($spf_records))
					$spf_records = array();
				$ok = false;
				if(!$spf_records)
					$missing_spfs[$approved_sender['senderid']] = 'all';
				foreach($spf_records as $spf_record)
				{
					if(!$ok)
					{
						if(isset($spf_record['txt']) && preg_match('/v=spf/', $spf_record['txt']))
						{
							if(isset($spf_record['txt']) && preg_match('/^"?v=spf"?$/', $spf_record['txt']))
								$missing_spfs[$approved_sender['senderid']] = 'all';
							else
							{
								if(!preg_match('/include:.*spf\.dynect\.net/', $spf_record['txt']))
								{
									$ip_pool = array();
									if($user->uniqueip) // has a unique ip(s) so check the spf against it.
										$ip_pool = $user->GetIPs(false, $user->userid);
									else // using the shared pool check for the pool instead
										$ip_pool = $user->GetIPs(true);

									foreach($ip_pool as $ip)
									{
										if(stripos($spf_record['txt'], $ip) === false)
										{
											if(!isset($missing_spfs[$approved_sender['senderid']]) || $missing_spfs[$approved_sender['senderid']] == 'all')
												$missing_spfs[$approved_sender['senderid']] = array($spf_record['txt']);
											$missing_spfs[$approved_sender['senderid']][] = $ip;
										}
									}
								}
								else
									$ok = true;
							}
						}
					}
				}
			}
		}
		
		return $missing_spfs;
	}
	
	public function CheckDomainKeys($sendersids=array(),$userid=0)
	{
		if($userid > 0)
			$user = &GetUser($userid);
		else
			$user = &GetUser();
		$private_key = '/k=rsa.?;.+t=y.?;.+p=MHwwDQYJKoZIhvcNAQEBBQADawAwaAJhAP3X49p188SrwGKsiPWU68lIzUJn8hsfEHLHuRU48aliKBuvg3wl3ADY75e3HLf9BJOo\+4DgRGhg2Egmxy4pevYyNT1t9LrgBWndSJbyWhwMo\+hBgiGKRUbMUhVpVyDlLQIDAQAB/m';
		$missing_dkims = array();
		$nomatch_dkims = array();
		
		$senderapi = $this->GetApi('Senders');
		if(empty($senderids))
			$approved_senders = $senderapi->GetApprovedSenders($user->userid);
		else
			$approved_senders = GetApprovedSendersByIds($sendersids);
		
		foreach($approved_senders as $approved_sender)
		{
			$domain = explode('@', $approved_sender['emailaddress']);
			if(isset($domain[1]))
			{
				$dkim_records = dns_get_record('_domainkey.' . $domain[1], DNS_TXT);
				if(empty($dkim_records))
					$dkim_records = array();
				$dkim_ok = false;
				foreach($dkim_records as $dkim_record)
				{
					if(isset($dkim_record['txt']))
					{
						if($this->Debug)
							echo "CHECKING _domainkey DKIM: " . $dkim_record;
	
						if(preg_match('/t=y.?;/',$dkim_record['txt']) != false && preg_match('/o=~.?;/',$dkim_record['txt']) != false)
						{
							if(!isset($approved_sender['dkim']) || $approved_sender['dkim'] == '')
								continue;
							else
								$dkim_id = $approved_sender['dkim'];
								
							$dkim_id_records = dns_get_record($dkim_id . '._domainkey.' . $domain[1], DNS_TXT);
							foreach($dkim_id_records as $dkim_id_record)
							{
								if(isset($dkim_id_record['txt']))
								{
									if($this->Debug)
										echo "CHECKING " . $dkim_id_record;
									
									if(preg_match($private_key,$dkim_id_record['txt']) != false)
									{
										$dkim_ok = true;
										break;
									}
								}
							}
						}
					}
					
				}
				if(!$dkim_ok)
					$missing_dkims[$approved_sender['senderid']] = $approved_sender['emailaddress'];
			}
		}
		return $missing_dkims;		
	}
	
	public function CheckVolume($senderids, $daterange, $statsapi=0)
	{
		if($statsapi === 0)
			$statsapi = $this->GetApi('Stats');
		return $statsapi->GetEmails($senderids,$daterange, true);
	}
	
	public function CheckPeakToAverage($senderids, $daterange, $statsapi=0)
	{
		if($statsapi === 0)
			$statsapi = $this->GetApi('Stats');
		$gotdays = $statsapi->GetEmailCountByDays($senderids,$daterange, true);
		$days = array();
		foreach($gotdays as $day)
			$days[] = $day['count'];
		$volume = array_sum($days);
		if($volume == 0)
			$volume = 1; //prevent divide by 0
		asort($days);
		return ($days[0]/($volume/30));
	}
	
	public function CheckBounceRate($volume, $senderids, $daterange, $statsapi=0)
	{
		if($statsapi === 0)
			$statsapi = $this->GetApi('Stats');
		$bounce = $statsapi->GetBounces($senderids,$daterange, true);
		if($volume == 0)
			$volume = 1;  //prevent divide by 0
		return $bounce/$volume*100;
	}
	
	public function CheckSpamRate($volume, $senderids, $daterange, $statsapi=0)
	{
		if($statsapi === 0)
			$statsapi = $this->GetApi('Stats');
		$spam = $statsapi->GetSpamComplaints($senderids,$daterange, true);
		if($volume == 0)
			$volume = 1;  //prevent divide by 0
		return $spam/$volume*100;
	}

	public function GetMastersBlacklists($masterid)
	{
		$query = $this->Db->Query("SELECT id FROM users where masterid=" . $masterid);
		$iplist = array();
		while($row = $this->Db->Fetch($query))
			   $iplist = array_merge($iplist, $this->GetUsersBlacklists($row['id']));
		return $iplist;
	}

	public function GetUsersBlacklists($userid)
	{
		$query = $this->Db->Query("SELECT i.ipid, i.ip FROM ip_pool i INNER JOIN ip_pool_user iu ON iu.ipid=i.ipid AND iu.userid=" . $userid);
		$iplist = array();
		while($row = $this->Db->Fetch($query))
				$iplist[] = $row;
		return $iplist;
	}
	
	
	public function CheckBlacklist($iplist=array(),$full=false,$verbose=false)
	{

		if(!is_array($iplist)) //we need an array!
			$iplist = array($iplist);

		if(empty($iplist)) //if we got an empty list we need to get them all from the database (probably a cron call).
		{
			$query = $this->Db->Query("SELECT ipid, ip FROM ip_pool");
			$iplist = array();
			while($row = $this->Db->Fetch($query))
				$iplist[] = $row;
		}

		//get the blacklist we need. one is huge and you better not scan it to often.
		$blacklists = $full ? $this->blacklistFull : $this->blacklistShort;

		$failed = array();
		$blacklisteddate = time();
		foreach ($iplist as $iprow)
		{
			$ip = 0;
			$id = 0;
			if(is_array($iprow))
			{
				$id = $iprow['ipid'];
				$ip = $iprow['ip'];
			}
			else
				$ip = $iprow;

			if($verbose) echo 'CHECKING IP: ' , $ip, "\r\n";

			$revip = implode('.',array_reverse(explode('.',$ip)));
			
			foreach($blacklists as $blacklist)
			{
				$lookup = $revip . '.' . $blacklist;
				if($lookup != gethostbyname($lookup))
				{
					if($verbose) echo 'FAILED BLACKLIST: ', $blacklist , "\r\n";

					if(isset($failed[$ip]))
						$failed[$ip][] = $blacklist;
					else
						$failed[$ip] = array($blacklist);
					
					if($id > 0)
						$query = $this->Db->Query("INSERT INTO ip_blacklisted (ipid, blacklisttime, blacklist,isfull) VALUES(".$id.",".$blacklisteddate.",'".$blacklist."',".($full ? 1 : 0).")");
				}
			}
		}
		return $failed;
	}
	
	public function GetSharedPoolAverages()
	{
		$interval = time() - 604800;
		$query = $this->Db->Query("SELECT AVG(inbox) as inbox, AVG(spam) as spam, AVG(missing) as missing FROM seedtotals WHERE shared=1 AND created > $interval");
		if(!$query)
			return false;
			
		$result = $this->Db->Fetch($query);
		return $result;
	}
	
	public function ActionJob($jobid, $jobtype)
	{
		if($jobtype == 'blacklist')
		{
			
		} else {
			$userapi = $this->GetApi('user');
			$users = $userapi->GetUsersLite();
			echo "GENERATING REPORT CARDS FOR " . count($users) . " USERS: ";
			$acualsent = 0;
			foreach($users as $user) 
			{
				if($this->GenerateReportCard($user['id']))
					$acualsent++;
			}
			echo "\r\nACTUAL SENT: " . $acualsent . "\r\n";
		}
		return true;
	}
	
	public function GenerateReportCard($userid)
	{
		$userapi = $this->GetApi('user');
		$userapi->Load($userid);
		if($userapi->isDemo())
			return false; //if they are a demo we dont need to send them one.
		$senderids = $userapi->GetAllApprovedSenders(true);
		$configapi = $this->GetApi('config');
		$configvars = $configapi->GetSectionConfigs('reputation');
		$daterange = array('StartDate' => (time() - 2592000) ,'EndDate' => time());
		$statsapi = $this->GetApi('Stats');
		
		//get template engine. yes i dont want to do this here but we need it.
		$tpl = GetTemplateSystem();
		
		$reps = array();
		
		//authentication
		$sendersids = $userapi->GetApprovedSenders(true);
		if(empty($sendersids))
			return false; //if they have no approved senders we dont need to send them one.
		$spf = $this->CheckSPFRecords($sendersids,$userapi->userid);
		$dkim = $this->CheckDomainKeys($sendersids,$userapi->userid);
		$authenticationScore = 1; // 1 = good 0 = bad
		if(count($spf) > 0 || count($dkim) > 0) {
			$authenticationScore = 0;
			$reps[] = array(
				'Title' => 'Authentication',
				'State' => 'Bad',
				'Description' => 'It appears that some of your approved senders are missing SPF and/or DKIM authentication.'
			);
		} else
			$reps[] = array(
				'Title' => 'Authentication',
				'State' => 'Good',
				'Description' => 'Your Approved Senders are set up properly.'
			);
		
		//volume
		$volume = $this->CheckVolume($senderids, $daterange, $statsapi);
		if($volume == 0)
			return false; //if they have not sent anything we dont need to send them one
		$volumeScore = 0;
		$volumeState = 'Bad';
		if($volume >= $configvars['SelfIPVolumeScoreA']) {
			$volumeScore = 1;
			$volumeState = 'Good';
		} elseif($volume >= $configvars['SelfIPVolumeScoreA-']) {
			$volumeScore = 0.80;
			$volumeState = 'Good';
		} elseif($volume >= $configvars['SelfIPVolumeScoreB']) {
			$volumeScore = 0.60;
			$volumeState = 'Good';
		} elseif($volume >= $configvars['SelfIPVolumeScoreB-']) {
			$volumeScore = 0.40;
			$volumeState = 'Good';
		} elseif($volume >= $configvars['SelfIPVolumeScoreC']) {
			$volumeScore = 0.20;
			$volumeState = 'Neutral';
		}
		
		//peak
		$peak = $this->CheckPeakToAverage($senderids, $daterange, $statsapi);
		$peakScore = 0;
		$peakState = 'Bad';
		if($peak <= $configvars['PeaktoAverageRatioScoreA']) {
			$peakScore = 1;
			$peakState = 'Good';
		} elseif($peak <= $configvars['PeaktoAverageRatioScoreA-']) {
			$peakScore = 0.80;
			$peakState = 'Good';
		} elseif($peak <= $configvars['PeaktoAverageRatioScoreB']) {
			$peakScore = 0.60;
			$peakState = 'Good';
		} elseif($peak <= $configvars['PeaktoAverageRatioScoreB-']) {
			$peakScore = 0.40;
			$peakState = 'Good';
		} elseif($peak <= $configvars['PeaktoAverageRatioScoreC']) {
			$peakScore = 0.20;
			$peakState = 'Neutral';
		}
		
		$volpeakState = 'Bad';
		if($volumeState == 'Good' && ($peakState == 'Good' || $peakState == 'Neutral'))
			$volpeakState == 'Good';
		elseif(($volumeState == 'Good' && $peakState == 'Bad') || $volumeState == 'Neutral')
			$volpeakState == 'Neutral';
		
		$reps[] = array(
			'Title' => 'Volume/Frequency',
			'State' => $volpeakState,
			'Description' => 'You have sent ' . number_format($volume) . ' emails.'
		);
		
		//inbox acceptance
		$inboxScore = 1; //TODO: <-this
		$reps[] = array(
			'Title' => 'Inbox Acceptance Rate',
			'State' => 'Good',
			'Description' => 'Your Inbox Acceptance Rate is GOOD. Keep up the great work!'
		);
		
		//bounce	
		$bounce = $this->CheckBounceRate($volume, $senderids, $daterange, $statsapi);
		$bounceScore = 0;
		$bounceState = 'Bad';
		if($bounce <= $configvars['BounceScoreA']) {
			$bounceScore = 1;
			$bounceState = 'Good';
		} elseif($bounce <= $configvars['BounceScoreA-']) {
			$bounceScore = 0.80;
			$bounceState = 'Good';
		} elseif($bounce <= $configvars['BounceScoreB']) {
			$bounceScore = 0.60;
			$bounceState = 'Good';
		} elseif($bounce <= $configvars['BounceScoreB-']) {
			$bounceScore = 0.40;
			$bounceState = 'Neutral';
		} elseif($bounce <= $configvars['BounceScoreC']) {
			$bounceScore = 0.20;
			$bounceState = 'Neutral';
		}
		$reps[] = array(
			'Title' => 'Bounce Rate',
			'State' => $bounceState,
			'Description' => 'Your bounce rate is ' . number_format($bounce, 2) . '%.'
		);
		
		//spam
		$spam = $this->CheckSpamRate($volume, $senderids, $daterange, $statsapi);
		$spamScore = 0;
		$spamState = 'Bad';
		if($spam <= $configvars['SpamScoreA']) {
			$spamScore = '1';
			$spamState = 'Good';
		} elseif($spam <= $configvars['SpamScoreA-']) {
			$spamScore = '0.80';
			$spamState = 'Good';
		} elseif($spam <= $configvars['SpamScoreB']) {
			$spamScore = '0.60';
			$spamState = 'Neutral';
		} elseif($spam <= $configvars['SpamScoreB-']) {
			$spamScore = '0.40';
			$spamState = 'Neutral';
		} elseif($spam <= $configvars['SpamScoreC'])
			$spamScore = '0.20';
		$reps[] = array(
			'Title' => 'Spam Complaint Rate',
			'State' => $spamState,
			'Description' => 'Your spam complaint rate is ' . number_format($spam, 2) . '%.'
		);
		
		//blacklist
		$blacklistsScore = 0; //TODO: <-this
		$reps[] = array(
			'Title' => 'Blacklists',
			'State' => 'Good',
			'Description' => 'You are currently not on any blacklists.'
		);
		/*$reps[] = array(
			'Title' => 'Blacklists',
			'State' => 'Bad',
			'Description' => 'We've found one or more of your IPs on X blacklists.'
		);*/
		
		//totals
		$total = 
			(($volumeScore * $configvars['SelfIPVolumeWeight']) +
			($peakScore * $configvars['PeaktoAverageRatioWeight']) +
			($bounceScore * $configvars['BounceWeight']) +
			($spamScore * $configvars['SpamWeight']) +
			($inboxScore * $configvars['InboxAcceptanceWeight']) +
			($authenticationScore * $configvars['AuthenticationWeight'])) -
			($blacklistsScore * 10);
		echo $userid,'(',$total,') ';
		//TODO: Figure out how to get a letter grade from this using the messed up letter system.
		
		//ips
		$ipapi = $this->GetApi('ipmanager');
		$ips = $ipapi->GetIPs($userapi->userid, array(), false, 0, 'all');
		$onlyips = array();
		foreach($ips as $ip)
			$onlyips[] = $ip['ip'];
		
		//TODO: Revise how this is being calculated. might not be prefect. 
		//      Will prob need revisions once implimented.
		$grade = '';
		$summary = '';
		if($total > 94) {
			$grade = 'A';
			$summary = 'Looks like everything\'s in place. Keep up the good work!';
		} elseif($total > 89 ) {
			$grade = 'A-';
			$summary = 'Not bad, Everything looks pretty good.';
		} elseif($total > 84) {
			$grade = 'B';
			$summary = 'A few things could use improvement. <a href="#">Help me fix it</a>.';
		} elseif($total > 74) {
			$grade = 'B-';
			$summary = 'A few things could use improvement. <a href="#">Help me fix it</a>.';
		} elseif($total > 64) {
			$grade = 'C';
			$summary = 'By fixing some of the issues below you could greatly improve how often your emails are recieved. <a href="#">Help me fix it</a>.';
		} else {
			$grade = 'F';
			$summary = 'Your account is in danger of being shut off. Please <a href="mailto:concierge@dyn.com">contact conseierge</a> so we can assist you.';
		} 
		
		$Email = array(
			//email parts
			'Subject' => 'RepCheck Email',
			'Date' => date('F, Y',mktime(0, 0, 0, date('n')-1, 1, date('Y'))),
			'Grade' => $grade,
			'Summary' => $summary,
			//user parts
			'Username' => $userapi->username,
			'Company' => $userapi->companyname,
			'Sent' => number_format($userapi->GetSent(0, mktime(0, 0, 0, date('n')-1, 1, date('Y')), mktime(0, 0, 0, date('n'), 1-1, date('Y')))),
			'IPs' => empty($onlyips) ? 'n/a' : implode(', ',$onlyips),
			'URL' => SMARTMTA_APPLICATION_URL,
			//reps
			'Reps' => $reps
		);
		
		$tpl->Assign('Email', $Email);
		$emailbody = $tpl->ParseTemplate('repcheck_email_html', true);
		$emailtextbody = $tpl->ParseTemplate('repcheck_email_text', true);
		
		$this->SendHTMLEmail(SMARTMTA_DELIVERABILITY_EMAIL, 'RepCheck by SmartMTA - Deliverability Report', $emailbody, $emailtextbody);
		
		return true;
	}
}