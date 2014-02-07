<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

class Reputation extends SmartMTA_Functions
{
	public function Process()
	{
		if(!isset($_GET['ajax']))
			$this->PrintHeader();
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		
		if ($action == 'processpaging') {
			$thispage = $this->SetPerPage($_GET['PerPageDisplay']);
			$action = '';
		}
		
		switch($action)
		{
			case 'authentication':
				$repapi = $this->GetApi();
				$senders_spf = $repapi->CheckSPFRecords();
				$senders_dkim = $repapi->CheckDomainKeys();
				$json = new stdClass();
				$json->Status = 'OK';
				if(count($senders_spf) > 0 || count($senders_dkim) > 0)
				{
					$json->Rating = 'BAD';
					$json->Summary = 'It appears that some of your approved senders are missing SPF and/or DKIM authentication.';
					$json->Details = $this->tpl->ParseTemplate('reputation_authentication',true);
				} else {
					$json->Rating = 'GOOD';
					$json->Summary = 'Your Approved Senders are set up properly.';
					$json->Details = '';
				}
				echo json_encode($json);
				break;
			case 'volume/frequency':
				$user = &GetUser();
				$statsapi = $this->GetApi('Stats');
				$daterange = array('StartDate' => (time() - 2592000) ,'EndDate' => time());
				//$senderids = $user->GetAllApprovedSenders(true);
				$configapi = $this->GetApi('config');
				
				//Volume: last 30 days
				// >= B- = good
				// >= C  = neutral
				// <  C  = bad
				$scoreVGood = $configapi->GetConfigField('SelfIPVolumeScoreB-','reputation');
				$scoreVNeutral = $configapi->GetConfigField('SelfIPVolumeScoreC','reputation');

				//Peak To Average: last 30 days
				// <= B- = good
				// <= C = neutral
				// <  C = Bad
				$scorePGood = $configapi->GetConfigField('PeaktoAverageRatioScoreB-','reputation');
				$scorePNeutral = $configapi->GetConfigField('PeaktoAverageRatioScoreC','reputation');
								
				$gotdays = $statsapi->GetEmailCountByDays($user->userid,$daterange, true);
				$days = array();
				foreach($gotdays as $day)
					$days[] = $day['count'];
				$volume = array_sum($days);
				asort($days);
				// Handle cases where they have no volume (isset and volume==0)
				$peaktoaverage = ( (isset($days[0]) ? $days[0] : 0) / ( ($volume == 0 ? 1 : $volume) / 30) );
				
				$volscore = -1;
				if($volume >= $scoreVGood)
					$volscore = 1;
				elseif($volume >= $scoreVNeutral)
					$volscore = 0;
				
				$peakscore = -1;
				if($peaktoaverage <= $scorePGood)
					$peakscore = 1;
				elseif($peaktoaverage <= $scorePNeutral)
					$peakscore = 0;
				
				$json = new stdClass();
				$json->Status = 'OK';
				$json->Summary = 'You have sent '.number_format($volume).' emails.';
				if($volscore == 1 && $peakscore >= 0) //good
					$json->Rating = 'GOOD';
				elseif(($volume <= 1000 ) && ($user->createdate > strtotime('-3 months'))) //neutral
					$json->Rating = 'NEUTRAL';
				else //bad
					$json->Rating = 'BAD';
				$json->Details = $this->tpl->ParseTemplate('reputation_volumefrequency',true);
				echo json_encode($json);
				break;
			case 'bouncerate':
				// last 30 days
				// bounce/sent*100
				// <= B = good
				// <= C = neutral
				// >  C = bad
				$user = &GetUser();
				$statsapi = $this->GetApi('Stats');
				$daterange = array('StartDate' => (time() - 2592000) ,'EndDate' => time());
				$senderids = $user->GetAllApprovedSenders(true);
				$bounce_array = array();
				$bounce_array = $statsapi->GetBounces($senderids,$daterange, true);
				$bounce = $bounce_array['hardbounces'] + $bounce_array['softbounces'];
				$sent = $statsapi->GetEmails($senderids,$daterange, true);
				if($sent == 0)
					$sent = 1;  //prevent divide by 0
				$configapi = $this->GetApi('config');
				$scoreBGood = $configapi->GetConfigField('BounceScoreB','reputation');
				$scoreBNeutral = $configapi->GetConfigField('BounceScoreC','reputation');
				$bouncerate = $bounce/$sent*100;
				$json = new stdClass();
				$json->Status = 'OK';
				$json->Details = $this->tpl->ParseTemplate('reputation_bounce',true);
				$json->Summary = 'Your bounce rate is '.number_format($bouncerate,2).'%.';
				if($bouncerate <= $scoreBGood)
					$json->Rating = 'GOOD';
				elseif($bouncerate <= $scoreBNeutral)
					$json->Rating = 'NEUTRAL';
				else
					$json->Rating = 'BAD';
				echo json_encode($json);
				break;
			case 'spamcomplaintrate':
				// last 30 days
				// spam/sent*100
				// <= A- = good
				// <= B- = neutral
				// >  B- = bad
				$user = &GetUser();
				$statsapi = $this->GetApi('Stats');
				$daterange = array('StartDate' => (time() - 2592000) ,'EndDate' => time());
				$senderids = $user->GetAllApprovedSenders(true);
				$spam = array_sum($statsapi->GetSpamComplaints($senderids,$daterange, true));
				$sent = $statsapi->GetEmails($senderids,$daterange, true);
				if($sent == 0)
					$sent = 1;  //prevent divide by 0
				$configapi = $this->GetApi('config');
				$scoreVGood = $configapi->GetConfigField('SpamScoreA-','reputation');
				$scoreVNeutral = $configapi->GetConfigField('SpamScoreB-','reputation');
				$spamrate = $spam/$sent*100;
				$json = new stdClass();
				$json->Status = 'OK';
				$json->Details = $this->tpl->ParseTemplate('reputation_spam',true);
				$json->Summary = 'Your spam complaint rate is '.number_format($spamrate,2).'%.';
				if($spamrate <= $scoreVGood)
					$json->Rating = 'GOOD';
				elseif($spamrate <= $scoreVNeutral)
					$json->Rating = 'NEUTRAL';
				else
					$json->Rating = 'BAD';
				echo json_encode($json);
				break;
			case 'blacklists': //ajax call
				$user = &GetUser();
				$api = $this->GetApi();
				$iplist = $api->GetMastersBlacklists($user->masterid);
				if(empty($iplist))
				{
					$json = new stdClass();
					$json->Status = 'OK';
					$json->Rating = 'GOOD';
					$json->Summary = 'You are currently not on any blacklists.';
					$json->Details = 'Some times even good senders get blacklisted. While we strive to keep your IPs off of blacklists, occationaly the content of an email or ' .
							 'sending to a specific email address can land you on a blacklist. Most of these lists are 24 hour blocks and you will auto removed at the ' .
							 'end but there are some that require action to remove yourself from. If you do find yourself on one of these dont panic and remember, we\'re here to help.';;
					echo json_encode($json);
				}
				else
					echo $this->IsBlacklisted($iplist,false);
				break;
			case 'checkblacklist':
				if(isset($_POST['ip']))
					$this->IsBlacklists($_POST['ip']);
				break;
			case 'checkauthentication':
				$this->CheckAuthentication();
			break;
			case 'inboxacceptancerate':
				$this->CheckInboxAcceptance();
			break;
			case 'edit':
				if(isset($_POST['TotalWeight']))
				{ //if they submitted the page let's save the values
					$configapi = $this->GetApi('config');
					$failed = false;
					foreach($_POST as $key=>$value)
					{
						if($key != 'TotalWeight')
						{
							if(!$configapi->UpdateByName($key, $value, 'reputation'))
							{
								$failed = true;
								$this->Message('error', 'The field ' . $key . ' could not be updated as it does not exist.');
							}
						}
					}
					if(!$failed)
						$this->Message('success', 'The reputation config fields have been updated.');
				}
				$this->Edit();
			break;
			default:
				$this->ManageReputation();
		}

		if(!isset($_GET['ajax']))
			$this->PrintFooter();
	}
	
	public function ManageReputation()
	{
		
		$this->tpl->ParseTemplate('reputation');
	}
	
	public function Edit()
	{
		$configapi = $this->GetApi('config');
		$fields = $configapi->GetConfigs('reputation');
		$formfields = array();
		foreach($fields as $field)
			$formfields[$field['name']] = $field['value'];
		$this->tpl->Assign('form', $formfields);
		$this->tpl->ParseTemplate('reputation_form');
	}
	
	public function CheckAuthentication()
	{
		$api = $this->GetApi();
		$spf_check = $api->CheckSPFRecords();
		$results = array();
		if(!empty($spf_check))
		{
			$results['spf'] = $spf_check;
		}
		$dkim_check = $api->CheckDomainKeys();
		if(!empty($dkim_check))
		{
			$results['dkim'] = $dkim_check;
		}
		echo json_encode($results);
	}

	public function IsBlacklisted($iplist,$full=true)
	{

		$api = $this->GetApi();
		$failed = $api->CheckBlacklist($iplist,$full);
		$json = new stdClass();
		if(count($failed) > 0)
		{
			$json->Rating = 'Bad';
			$json->Summary = 'One or more of your IP\'s was found on at least one blacklist.';
			$rows = array();
			foreach($failed as $ip => $blacklists)
			{
				$rows[] = array(
					'blacklistip' => $ip,
					'blacklistedby' => implode(', ',$blacklists)
				);
			}
			$this->tpl->Assign('Blacklists', $rows);
			$json->Details = $this->tpl->ParseTemplate('reputation_blacklist',true);
		}
		else {
			$json->Rating = 'GOOD';
			$json->Summary = 'You are currently not on any blacklists.';
			$json->Details = 'Some times even good senders get blacklisted. While we strive to keep your IPs off of blacklists, occationaly the content of an email or ' .
							 'sending to a specific email address can land you on a blacklist. Most of these lists are 24 hour blocks and you will auto removed at the ' .
							 'end but there are some that require action to remove yourself from. If you do find yourself on one of these dont panic and remember, we\'re here to help.';
		}
		$json->Status = 'OK';
		$json->Message = '';

		return json_encode($json);
	}
	
	public function CheckInboxAcceptance()
	{
		$user = &GetUser();
		if($user->uniqueip !== false)
		{
			$ip_pool = $user->GetIPs(true, $user->userid, false);
		} else {
			$ip_pool = $user->GetIPs(false, 0, false);
		}
			
		$group_status = 'Good';
		$summary = '';
		$details = '<table cellspacing="0" cellpadding="0" border="0" width="650"><tr><th>IP Address</th><th>Inbox</th><th>Bulk</th><th>Missing</th><th>Status</th></tr>';
		
		if($user->uniqueip !== false)
		{
			foreach($ip_pool as $ip_row)
			{
				if(($ip_row['inbox'] < 80 || $ip_row['spam'] > 10) || $ip_row['missing'] > 3)
				{
					$summary = 'Your Inbox Acceptance Rate is POOR.';
					$group_status = 'Bad';
					$curr_status = '<span style="color:red;font-weight:bold">POOR</span>';
				} elseif($ip_row['inbox'] < 90 || $ip_row['spam'] > 5) {
					$summary = 'Your Inbox Acceptance Rate is NEUTRAL.';
					$group_status = 'Good';
					$curr_status = '<span style="color:gray;font-weight:bold">NEUTRAL</span>';
				} else {
					$summary = 'Your Inbox Acceptance Rate is GOOD. Keep up the great work!';
					$group_status = 'Good';
					$curr_status = '<span style="color:green;font-weight:bold">GOOD</span>';
				}
				
				$this->tpl->Assign('inboxacc',array(
					'ip' => $ip_row['ip'],
					'inboxrate' => round($ip_row['inbox']),
					'spamrate' => round($ip_row['spam']),
					'missingrate' => round($ip_row['missing']),
					'status' => $curr_status));
				$details .= $this->tpl->ParseTemplate('inbox_acceptance_row', true, false);
			}
		} else {
			$api = $this->GetApi();
			if(isset($_GET['real']) && strtolower($_GET['real']) == 'yes')
			{
				$avgs = $api->GetSharedPoolAverages();			
			} else {
				$avgs = array('inbox' => 97, 'spam' => 3, 'missing' => 0);
			}
			
			if(($avgs['inbox'] < 80 || $avgs['spam'] > 10) || $avgs['missing'] > 3)
			{
				$group_status = 'Bad';
				$summary = 'Your Inbox Acceptance Rate is POOR.';
				$curr_status = '<span style="color:red;font-weight:bold">POOR</span>';
			} elseif($avgs['inbox'] < 90 || $avgs['spam'] > 5) {
				$group_status = 'Good';
				$summary = 'Your Inbox Acceptance Rate is NEUTRAL.';
				$curr_status = '<span style="color:gray;font-weight:bold">NEUTRAL</span>';
			} else {
				$summary = 'Your Inbox Acceptance Rate is GOOD. Keep up the great work!';
				$group_status = 'Good';
				$curr_status = '<span style="color:green;font-weight:bold">GOOD</span>';
			}
			$this->tpl->Assign('inboxacc',array(
				'ip' => 'Shared',
				'inboxrate' => round($avgs['inbox']),
				'spamrate' => round($avgs['spam']),
				'missingrate' => round($avgs['missing']),
				'status' => $curr_status));
			$details .= $this->tpl->ParseTemplate('inbox_acceptance_row', true, false);
		}
		$details .= '</table>';
		
		$result = array('Status' => 'OK', 'Message' => '', 'Rating' => $group_status, 'Summary' => $summary, 'Details' => $details);
		echo json_encode($result);
	}
}