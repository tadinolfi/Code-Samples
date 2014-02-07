<?php

require_once(dirname(__FILE__) . '/api.php');

class Stats_API extends API
{

	public function __construct()
	{
		$this->GetDb();
	}

	public function GetEmails($senderids, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM email WHERE senderid IN (" . $senderids . ")";
		else
			$query = "SELECT * FROM email WHERE senderid IN (" . $senderids . ")";


		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND senttime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND senttime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		if($emailFilter != '')
			$query .= " AND emailaddress LIKE '%" . $this->Db->Quote($emailFilter) . "%'";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');


		$validsorts = array('email' => 'emailaddress', 'date' => 'senttime');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'senttime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$this->GetDb();
		$result = $this->Db->Query($query);

		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetEmailCountByDays($userid, $calendar_restrictions = array())
	{
		$days = 0;
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

		$today = array('month' => date('n', $calendar_restrictions['StartDate']), 'day' => date('j', $calendar_restrictions['StartDate']), 'year' => date('Y', $calendar_restrictions['StartDate']));
		
		$weekdays = array();
		$earr = array_fill(0, $days, 0);
		
		for($i = 0; $i < $days; $i++)
		{
			$today = $calendar_restrictions['StartDate'] + ($i * 86400);
			$today = gmmktime(0, 0, 0, date('m', $today), date('d', $today), date('Y', $today));
			
			// Sent & Delivered
			if($aggdata) { //count using agg tables for the agg'd data
				$query = $this->Db->Query("SELECT SUM(sentcount) as sentcount FROM `email_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if($result && !empty($result['sentcount'])) {
					$earr[$i] = (int) $result['sentcount'];
				}
			} else { //this exists for the old months not aggregated. we still have to rock the old method. it's ok though this will be gone soon.
				$result = $this->Db->FetchOne("SELECT COUNT(senttime) as c FROM `email` WHERE senttime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND senttime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$earr[$i] = (int) $result;

			}
		}
		return $earr;
	}

	public function GetOpens($userid, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(empty($userid))
			return false;

		$user = &GetUser($userid);

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM " . DATABASE_GROUP_OPENS_NAME . $user->groupnum . ".useropens_" . $userid . " ";
		else
			$query = "SELECT * FROM " . DATABASE_GROUP_OPENS_NAME . $user->groupnum . ".useropens_" . $userid . " ";

		$query .= 'WHERE 1=1';

		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND opentime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND opentime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		$filterValue = $this->Db->Quote($emailFilter);
		if($emailFilter != '')
			$query .= " AND agent LIKE '%" . $filterValue . "%'"
					. " OR status LIKE '%" . $filterValue . "%')";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');

		$validsorts = array('date' => 'opentime', 'stage' => 'stage', 'useragent' => 'agent', 'ip' => 'ip');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'opentime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$result = $this->Db->Query($query);

		$this->GetDb();

		if(!$result)
			return false;

		$return = array();
		$emailids = array();
		while($row = $this->Db->Fetch($result))
		{
			array_push($return, $row);
			$emailids[] = $row['emailid'];
		}
		if(!empty($emailids)) { //if we have opens get the email addresses that match them
			$query = 'SELECT emailaddress, emailid FROM email WHERE emailid IN(' . implode(',', $emailids) . ')';
			$result = $this->Db->Query($query);
			while($row = $this->Db->Fetch($result))
			{
				$c = sizeof($return);
				for($i = 0; $i < $c; $i++)
				{
					if($return[$i]['emailid'] == $row['emailid'])
						$return[$i]['emailaddress'] = $row['emailaddress'];
				}
			}
		}
		return $return;
	}

	public function GetClicks($userid, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(empty($userid))
			return false;

		$user = &GetUser($userid);

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM " . DATABASE_GROUP_CLICKS_NAME . $user->groupnum . ".userclicks_" . $userid . " ";
		else
			$query = "SELECT uc.*, pl.url oldurl FROM " . DATABASE_GROUP_CLICKS_NAME . $user->groupnum . ".userclicks_" . $userid . " uc LEFT OUTER JOIN postfix.links pl ON pl.linkid=uc.linkid ";

		$query .= 'WHERE 1=1';

		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND clicktime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND clicktime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		$filterValue = $this->Db->Quote($emailFilter);
		if($emailFilter != '')
			$query .= " AND ip LIKE '%" . $filterValue . "%'"
					. " OR url LIKE '%" . $filterValue . "%')";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');

		$validsorts = array('time' => 'clicktime', 'ip' => 'ip', 'url' => 'url');
		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'clicktime';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'clicktime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'ASC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';

		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);
		$result = $this->Db->Query($query);

		$this->GetDb();

		if(!$result)
			return false;

		$return = array();
		$emailids = array();
		while($row = $this->Db->Fetch($result))
		{
			//handle the old version of the url stored in links
			if(isset($row['oldurl']) && $row['oldurl'] != '')
				$row['url'] = $row['oldurl'];
			$return[] = $row;
			$emailids[] = $row['emailid'];
		}
		if(!empty($emailids)) { //if we have opens get the email addresses that match them
			$query = 'SELECT emailaddress, emailid FROM email WHERE emailid IN(' . implode(',', $emailids) . ')';
			$result = $this->Db->Query($query);
			while($row = $this->Db->Fetch($result))
			{
				$c = sizeof($return);
				for($i = 0; $i < $c; $i++)
				{
					if($return[$i]['emailid'] == $row['emailid'])
						$return[$i]['emailaddress'] = $row['emailaddress'];
				}
			}
		}
		return $return;
	}

	public function GetOpensGraphData($userid, $calendar_restrictions = array(), $overriderandom = false)
	{
		if(empty($userid))
			return false;

		$user = &GetUser($userid);

		$days = 0;
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

		$today = array('month' => date('n', $calendar_restrictions['StartDate']), 'day' => date('j', $calendar_restrictions['StartDate']), 'year' => date('Y', $calendar_restrictions['StartDate']));

		$weekdays = array();
		if($days >= 28) {
			$open_arr = array_fill(0, $days, 0);
			$skimmed_arr = array_fill(0, $days, 0);
			$read_arr = array_fill(0, $days, 0);
			$total_arr = array_fill(0, $days, 0);
		} else {
			$constructarray = array();
			for($i = 0; $i < $days; $i++)
			{
				$constructarray[] = 0;
				$weekdays[] = date('l <\b\r/>n/j', gmmktime(0, 0, 0, $today['month'], $today['day'] + $i, $today['year']));
			}
			$open_arr = $skimmed_arr = $read_arr = $total_arr = $constructarray;
		}

		$overriderandom = false;
		for($i = 0; $i < $days; $i++)
		{
			$result = $this->Db->Query("SELECT stage, COUNT(opentime) as c FROM " . DATABASE_GROUP_OPENS_NAME . $user->groupnum . ".useropens_" . $userid . " WHERE opentime BETWEEN " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400) -1 ) . " GROUP BY stage");
			while($opens = $this->Db->Fetch($result))
			{
				if($opens) {
					$overriderandom = true;
					if($opens['stage'] == 'seen') {
						$open_arr[$i] = (int) $opens['c'];
						$total_arr[$i] += (int) $opens['c'];
					} elseif($opens['stage'] == 'skimmed') {
						$skimmed_arr[$i] = (int) $opens['c'];
						$total_arr[$i] += (int) $opens['c'];
					} elseif($opens['stage'] == 'read') {
						$read_arr[$i] = (int) $opens['c'];
						$total_arr[$i] += (int) $opens['c'];
					}
				}
			}
		}

		//if we have no data make some up!
		if ( !$overriderandom) {
			if(array_sum($open_arr) == 0) {
				foreach($open_arr as $key => $val)
				{
					$open_arr[$key] = rand(0, 2000);
					$skimmed_arr[$key] = rand(0, 3000);
					$read_arr[$key] = rand(1000, 5000);
					$total_arr[$key] = $open_arr[$key] + $skimmed_arr[$key] + $read_arr[$key];
				}
			}
		}

		$this->GetDb();

		$return = array($open_arr, $skimmed_arr, $read_arr, $total_arr, $weekdays);
		return $return;
	}

	public function GetClicksGraphData($userid, $calendar_restrictions = array(), $overriderandom = false)
	{
		if(empty($userid))
			return false;

		$user = &GetUser($userid);

		$days = 0;
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

		$today = array('month' => date('n', $calendar_restrictions['StartDate']), 'day' => date('j', $calendar_restrictions['StartDate']), 'year' => date('Y', $calendar_restrictions['StartDate']));

		$weekdays = array();
		if($days >= 28) {
			$clicks_arr = array_fill(0, $days, 0);
		} else {
			$constructarray = array();
			for($i = 0; $i < $days; $i++)
			{
				$constructarray[] = 0;
				$weekdays[] = date('l <\b\r/>n/j', gmmktime(0, 0, 0, $today['month'], $today['day'] + $i, $today['year']));
			}
			$clicks_arr = $constructarray;
		}

		//print_r($days);
		for($i = 0; $i < $days; $i++)
		{
			//echo "SELECT COUNT(clicktime) as c FROM " . DATABASE_GROUP_CLICKS_NAME . $user->groupnum . ".userclicks_" . $userid . " WHERE clicktime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND clicktime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400));
			$query = $this->Db->Query("SELECT COUNT(clicktime) as c FROM " . DATABASE_GROUP_CLICKS_NAME . $user->groupnum . ".userclicks_" . $userid . " WHERE clicktime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND clicktime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)));
			$result = $this->Db->FetchOne($query, 'c');
			if($result) {
				$clicks_arr[$i] = (int) $result;
			} else {
			}
		}

		//if we have no data make some up!
		if (!$overriderandom) {
			if(array_sum($clicks_arr) == 0) {
				foreach($clicks_arr as $key => $val)
					$clicks_arr[$key] = rand(0, 2000);
			}
		}

		$this->GetDb();

		$return = array($clicks_arr, $weekdays);
		return $return;
	}

	public function GetSpamComplaints($senderids, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;
		if($count_only)
			$query = "SELECT COUNT(*) as count FROM complaint c INNER JOIN email e ON c.recipientid=e.emailid  WHERE c.senderid IN (" . $senderids . ") ";
		else
			$query = "SELECT * FROM complaint c INNER JOIN email e ON c.recipientid=e.emailid WHERE c.senderid IN (" . $senderids . ")";

		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND spamtime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND spamtime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		if($emailFilter != '')
			$query .= " AND emailaddress LIKE '%" . $this->Db->Quote($emailFilter) . "%'";

		if($count_only) {
			$result_array = array();
			$result_array['complaints'] =  $this->Db->FetchOne($query, 'count');
			$result_array['prevcomplaints'] =  0; //$this->Db->FetchOne($query . " STUFF TO MAKE IT UNIQUE FROM OTHER COMPLAINTS!", 'count');
			return $result_array;
		}

		$validsorts = array('email' => 'emailaddress', 'date' => 'spamtime');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'spamtime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$result = $this->Db->Query($query);

		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetBounces($senderids, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM bounce b INNER JOIN email e ON e.emailid=b.recipientid AND b.senderid IN (" . $senderids . ") ";
		else
			$query = "SELECT e.emailaddress, b.* FROM bounce b INNER JOIN email e ON e.emailid=b.recipientid AND b.senderid IN (" . $senderids . ") ";
		/* b.bounceid, b.recipientid, b.bouncetype, b.bouncerule, b.bouncecode, b.bouncetime, b.senderid, b.notifiedtime */

		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND b.bouncetime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND b.bouncetime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		$filterValue = $this->Db->Quote($emailFilter);
		if($emailFilter != '')
			$query .= " AND (e.emailaddress LIKE '%" . $filterValue . "%'"
					. " OR b.bouncetype LIKE '%" . $filterValue . "%'"
					. " OR b.bouncerule LIKE '%" . $filterValue . "%')";
			

		if($count_only) {
			$result_array = array();
			//SELECT bouncetype, bouncerule, COUNT(bouncetype) FROM `bounce` WHERE bouncetime >= '1313971200' AND bouncetime < '1314144000' AND senderid IN (1923) AND bouncetype = 'hard' AND (bouncecode = '' OR bouncecode IS NULL) GROUP BY bouncetype, bouncerule
			//SELECT bouncetype, bouncerule, COUNT(bouncetype) FROM `bounce` WHERE bouncetime >= '1313971200' AND bouncetime < '1314144000' AND senderid IN (1923) AND bouncetype = 'hard' AND (bouncecode != '' AND bouncecode IS NOT NULL) GROUP BY bouncetype, bouncerule
			$temp = $query. " AND b.bouncetype = 'hard' AND (b.bouncecode != '' AND b.bouncecode IS NOT NULL) "; //<-THIS NEEDS DOME WORK!
			//echo $temp,"\n";
			$result_array['hardbounces'] = $this->Db->FetchOne($temp, 'count');
			$temp = $query . " AND b.bouncetype = 'hard' AND (b.bouncecode = '' OR b.bouncecode IS NULL) ";
			//echo $temp,"\n";
			$result_array['prevhardbounces'] = $this->Db->FetchOne($temp, 'count');
			$temp = $query . " AND b.bouncetype = 'soft'";
			//echo $temp,"\n";
			$result_array['softbounces'] = $this->Db->FetchOne($temp, 'count');
			return $result_array;	
		}
		
		$validsorts = array('email' => 'e.emailaddress', 'date' => 'b.bouncetime', 'type' => 'b.bouncetype', 'rule' => 'b.bouncerule', 'code' => 'b.bouncecode');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'date';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'b.bouncetime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = strtolower($direction) == 'asc'?'asc':'desc';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);
		$result = $this->Db->Query($query);
		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetUsersByHighestBounces($count=10, $days=7)
	{
		$offset = time() - (86400 * $days);
		$query = 'SELECT u.id, u.username, COUNT( b.bounceid ) c ' .
				'FROM users u ' .
				'INNER JOIN sender s ON u.id = s.userid ' .
				'INNER JOIN bounce b ON s.senderid = b.senderid WHERE b.bouncetime > ' . $offset . ' ' .
				'GROUP BY u.id ' .
				'ORDER BY COUNT(b.bounceid) DESC ' .
				'LIMIT ' . $count;

		$result = $this->Db->Query($query);
		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetUsersByHighestSpams($count=10, $days=7)
	{
		$offset = time() - (86400 * $days);
		$query = 'SELECT u.id, u.username, COUNT( c.complaintid ) c ' .
				'FROM users u ' .
				'INNER JOIN sender s ON u.id = s.userid ' .
				'INNER JOIN complaint c ON s.senderid = c.senderid WHERE c.spamtime > ' . $offset . ' ' .
				'GROUP BY u.id ' .
				'ORDER BY COUNT(c.complaintid) DESC ' .
				'LIMIT ' . $count;

		$result = $this->Db->Query($query);
		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetSendIssueMessage($sendissueid=0)
	{
		$query = 'SELECT message FROM sendissue WHERE sendissueid=' . $sendissueid;
		$result = $this->Db->Query($query);

		if(!$result)
			return '';
		return $this->Db->FetchOne($result, 'message');
	}

	public function GetBounceHeader($bounceid=0)
	{
		$query = 'SELECT bounceheader FROM bounce WHERE bounceid=' . $bounceid;
		$result = $this->Db->Query($query);

		if(!$result)
			return '';
		return $this->Db->FetchOne($result, 'bounceheader');
	}

	public function GetReportsGraphData($userid, $senderids, $calendar_restrictions = array())
	{
		if(empty($senderids))
			$senderids = '0';
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		
		$now = gmmktime( 0, 0, 0, date('m'), date('d')-2, date('Y'));

		$days = 0;
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

		$today = array('month' => date('n', $calendar_restrictions['StartDate']), 'day' => date('j', $calendar_restrictions['StartDate']), 'year' => date('Y', $calendar_restrictions['StartDate']));
		
		$weekdays = array();
		if($days >= 28) {
			$earr = array_fill(0, $days, 0);
			$darr = array_fill(0, $days, 0);
			$barr = array_fill(0, $days, 0);
			$sarr = array_fill(0, $days, 0);
			$iarr = array_fill(0, $days, 0);
		} else {
			$constructarray = array();
			for($i = 0; $i < $days; $i++)
			{
				$constructarray[] = 0;
				$weekdays[] = date('l <\b\r/>n/j', gmmktime(0, 0, 0, $today['month'], $today['day'] + $i, $today['year']));
			}
			$earr = $darr = $barr = $sarr = $iarr = $constructarray;
		}
		
		// =========== Temp Code!!! ===========
		//handle the month we aggregated
		$aggdata = false;
		$selectedmonth = date('m', $calendar_restrictions['StartDate']);
		if($selectedmonth >= 8)
			$aggdata = true;
		// =========== Temp Code!!! ===========

		for($i = 0; $i < $days; $i++)
		{
			$today = $calendar_restrictions['StartDate'] + ($i * 86400);
			$today = gmmktime(0, 0, 0, date('m', $today), date('d', $today), date('Y', $today));
			
			// Sent & Delivered
			if($aggdata) { //count using agg tables for the agg'd data
				$query = $this->Db->Query("SELECT SUM(sentcount) as sentcount, SUM(undeliveredcount) as undeliveredcount FROM `email_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if($result && !empty($result['sentcount'])) {
					$earr[$i] = (int) $result['sentcount'];
					$darr[$i] = (int) ($result['sentcount'] - $result['undeliveredcount']);
				}
				
				$query = $this->Db->Query("SELECT SUM(hardbouncecount) as hardbouncecount, SUM(softbouncecount) as softbouncecount, SUM(prevbouncecount) as prevbouncecount FROM `bounce_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if ($result && !empty($result['hardbouncecount'])) {
					$barr[$i] = (int) $result['hardbouncecount'];
					$barr[$i] += (int) $result['softbouncecount'];
					$barr[$i] += (int) $result['prevbouncecount'];
				}
			} else { //this exists for the old months not aggregated. we still have to rock the old method. it's ok though this will be gone soon.
				$result = $this->Db->FetchOne("SELECT COUNT(senttime) as c FROM `email` WHERE senttime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND senttime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$earr[$i] = (int) $result;

				$result = $this->Db->FetchOne("SELECT COUNT(senttime) as c FROM `email` WHERE senttime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND senttime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ") AND delivered=1", 'c');
				if($result)
					$darr[$i] = (int) $result;
				
				$result = $this->Db->FetchOne("SELECT COUNT(bouncetime) as c FROM `bounce` WHERE bouncetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND bouncetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$barr[$i] = (int) $result;
			}
				

			//check for agrigated data first
			//check for agrigated data first
			/*if(USE_ARCHITECTURE == Architecture::OnlyDark)
			{
				$query = $this->Db->Query("SELECT SUM(hardbouncecount) as hardbouncecount, SUM(softbouncecount) as softbouncecount, SUM(prevbouncecount) as prevbouncecount FROM `bounce_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if ($result && !empty($result['hardbouncecount'])) {
					$barr[$i] = (int) $result['hardbouncecount'];
					$barr[$i] += (int) $result['softbouncecount'];
					$barr[$i] += (int) $result['prevbouncecount'];
				}
			} elseif(USE_ARCHITECTURE == Architecture::OnlyLight) {
				$result = $this->Db->FetchOne("SELECT COUNT(bouncetime) as c FROM `bounce` WHERE bouncetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND bouncetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$barr[$i] = (int) $result;
			} else {
				$query = $this->Db->Query("SELECT SUM(hardbouncecount) as hardbouncecount, SUM(softbouncecount) as softbouncecount, SUM(prevbouncecount) as prevbouncecount FROM `bounce_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);

				$newdatabounce = (int) $result['hardbouncecount'];
				$newdatabounce += (int) $result['softbouncecount'];
				$newdatabounce += (int) $result['prevbouncecount'];

				
				$result = $this->Db->FetchOne("SELECT COUNT(bouncetime) as c FROM `bounce` WHERE bouncetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND bouncetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$barr[$i] = (int) $result;
				
				if(( $now <= ($calendar_restrictions['StartDate'] + ($i * 86400)) ) && $newdatabounce != $barr[$i] )
				{
					$log = new SystemLog();
					$log->LogSystemDebug('php', 'Dark Architecture Data Inconsistency (bounce)', '</br> User: ' . $userid . '</br> Sender: ' . $senderids . '</br> StartTime: ' . ($calendar_restrictions['StartDate'] + ($i * 86400)) . '<br/>Bounce:<br/>- Dark: ' . $newdatabounce . '</br>- Light: ' . $barr[$i]);
				}
			}*/
			
			//check for agrigated data first
			if(USE_ARCHITECTURE == Architecture::OnlyDark)
			{
				$query = $this->Db->Query("SELECT SUM(complaintcount) as complaintcount, SUM(prevcomplaintcount) as prevcomplaintcount FROM `complaint_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if ($result && !empty($result['complaintcount'])) {
					$sarr[$i] = (int) $result['complaintcount'];
					$sarr[$i] += (int) $result['prevcomplaintcount'];
				}
			} elseif(USE_ARCHITECTURE == Architecture::OnlyLight) {
				$result = $this->Db->FetchOne("SELECT COUNT(spamtime) as c FROM complaint WHERE spamtime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND spamtime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$sarr[$i] = (int) $result;
			} else {
				$query = $this->Db->Query("SELECT SUM(complaintcount) as complaintcount, SUM(prevcomplaintcount) as prevcomplaintcount FROM `complaint_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				
				$newdatacomplaint = (int) $result['complaintcount'];
				$newdatacomplaint += (int) $result['prevcomplaintcount'];
				
				$result = $this->Db->FetchOne("SELECT COUNT(spamtime) as c FROM complaint WHERE spamtime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND spamtime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$sarr[$i] = (int) $result;
				
				if(( $now <= ($calendar_restrictions['StartDate'] + ($i * 86400)) ) && $newdatacomplaint != $sarr[$i] )
				{
					$log = new SystemLog();
					$log->LogSystemDebug('php', 'Dark Architecture Data Inconsistency (complaint)', '</br> User: ' . $userid . '</br> Sender: ' . $senderids . '</br> StartTime: ' . ($calendar_restrictions['StartDate'] + ($i * 86400)) . '<br/>Complaint:<br/>- Dark: ' . $newdatacomplaint . '</br>- Light: ' . $sarr[$i] );
				}
			}
			 
			
			//check for agrigated data first
			if(USE_ARCHITECTURE == Architecture::OnlyDark)
			{
				$result = $this->Db->FetchOne("SELECT SUM(sendissuecount) as sendissuecount FROM `sendissue_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid), 'sendissuecount');
				if ($result && !empty($result))
					$iarr[$i] = (int) $result;
			} elseif(USE_ARCHITECTURE == Architecture::OnlyLight) {
				$result = $this->Db->FetchOne("SELECT COUNT(issuetime) as c FROM `sendissue` WHERE userid=" . $this->Db->Quote($userid) . " AND issuetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND issuetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)), 'c');
				if($result)
					$iarr[$i] = (int) $result;
			} else {
				$result = $this->Db->FetchOne("SELECT SUM(sendissuecount) as sendissuecount FROM `sendissue_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid), 'sendissuecount');
				$newdataissue  = (int) $result;
				
				$result = $this->Db->FetchOne("SELECT COUNT(issuetime) as c FROM `sendissue` WHERE userid=" . $this->Db->Quote($userid) . " AND issuetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND issuetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)), 'c');
				$iarr[$i] = (int) $result;
				
				if(( $now <= ($calendar_restrictions['StartDate'] + ($i * 86400)) ) && $newdataissue != $iarr[$i] )
				{
					$log = new SystemLog();
					$log->LogSystemDebug('php', 'Dark Architecture Data Inconsistency (issue)', '</br> User: ' . $userid . '</br> StartTime: ' . ($calendar_restrictions['StartDate'] + ($i * 86400)) . '<br/>Issue:<br/>- Dark: ' .$newdataissue . '</br>- Light: ' . $iarr[$i]);
				}
			}
			
		}

		$email_sent_by_day = $earr;

		$email_delivered_by_day = $darr;

		$bounce_by_day = $barr;

		$spam_by_day = $sarr;

		$issue_by_day = $iarr;

		if($senderids == '0') {
			$emailslen = count($email_sent_by_day);
			for($i = 0; $i < $emailslen - 1; $i++)
			{
				$emailsc = rand(1, 5) > 2?rand(10000, 50000):0;
				$email_sent_by_day[$i] = $emailsc;
				$email_delivered_by_day[$i] = $emailsc;
				$bounce_by_day[$i] = $emailsc > 0?rand(0, $emailsc / 10):0;
				$spam_by_day[$i] = $emailsc > 0?(rand(1, 5) > 3?rand(1, 10):0):0;
				$issue_by_day[$i] = $emailsc > 0?(rand(1, 5) > 3?rand(1, 10):0):0;
			}
		}

		$return = array($email_sent_by_day, $email_delivered_by_day, $bounce_by_day, $spam_by_day, $issue_by_day, $weekdays);
		return $return;
	}

	public function GetActiveMonths($senderids)
	{
		if(empty($senderids))
			return array();
		if(is_array($senderids))
			$senderids = implode(',', $senderids);

		$query_emails = $this->Db->Query("SELECT DISTINCT FROM_UNIXTIME(senttime, '%Y|%c') AS daterange FROM email WHERE senderid IN (" . $senderids . ")");

		$retVal = array();

		while($result = $this->Db->Fetch($query_emails))
		{
			$res = $result['daterange'];
			$retVal[$res] = $res;
		}

		$retVal = array_keys($retVal);
		arsort($retVal);

		return $retVal;
	}

	public function GetCustomHeader($header, $body)
	{
		if(!$body)
			return false;

		$bounce_header = '';
		if(preg_match('%' . $header . ' (.*)%i', $body, $match))
			$bounce_header = trim($match[1]);

		unset($body);
		return $bounce_header;
	}

	public function ExportEmailsToFile($senderids, $calendar_restrictions = array(), $sortinfo=array(), $searchFilter='', $delivered_only=false)
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		$query = '';

		// Apply date range if specified
		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND senttime >= " . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0')
					. " AND senttime < " . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399');

		// Only export delivered if specified
		if($delivered_only)
			$query .= " AND delivered=1";

		// Apply text filter if specified
		$filterValue = $this->Db->Quote($searchFilter);
		if($searchFilter != '')
			$query .= " AND (emailaddress LIKE '%" . $filterValue . "%')";

		// Apply sort
		$validsorts = array('email' => 'emailaddress', 'date' => 'senttime');
		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'senttime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		$queryCount = "SELECT COUNT(*) c FROM email WHERE senderid IN (" . $senderids . ") " . $query;
		$query = "SELECT emailaddress, FROM_UNIXTIME(senttime) senttime FROM email WHERE senderid IN (" . $senderids . ") " . $query;

		// Retrieve results and export to file
		$result = $this->Db->Query($queryCount);
		if(!$result)
			return false;
		$size = $this->Db->FetchOne($result, 'c');

		$user = &GetUser();

		$filename = $this->_Export('emails', $query, $size, $user->userid);

		if($filename === true) //they had to multithread the result
			return true;
		return $filename;
	}

	public function ExportBouncesToFile($senderids, $calendar_restrictions = array(), $sortinfo=array(), $searchFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		$query = '';

		// Apply date range if specified
		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND b.bouncetime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0')
					. "' AND b.bouncetime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		// Apply text filter if specified
		$filterValue = $this->Db->Quote($searchFilter);
		if($searchFilter != '')
			$query .= " AND (e.emailaddress LIKE '%" . $filterValue . "%'"
					. " OR b.bouncetype LIKE '%" . $filterValue . "%'"
					. " OR b.bouncerule LIKE '%" . $filterValue . "%')";

		// Apply sort
		$validsorts = array('email' => 'e.emailaddress', 'date' => 'b.bouncetime', 'type' => 'b.bouncetype', 'rule' => 'b.bouncerule');
		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'date';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'b.bouncetime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'desc';
		$direction = strtolower($direction) == 'asc'?'asc':'desc';
		$query .= " ORDER BY " . $order . " " . $direction;

		$queryCount = "SELECT COUNT(*) c FROM bounce b INNER JOIN email e ON e.emailid=b.recipientid WHERE b.senderid IN (" . $senderids . ") " . $query;
		$query = "SELECT e.emailaddress, b.bouncetype, b.bouncerule, FROM_UNIXTIME(b.bouncetime) bouncedatetime FROM bounce b INNER JOIN email e ON e.emailid=b.recipientid WHERE b.senderid IN (" . $senderids . ") " . $query;

		// Retrieve results and export to file
		$result = $this->Db->Query($queryCount);
		if(!$result)
			return false;
		$size = $this->Db->FetchOne($result, 'c');

		$user = &GetUser();

		$filename = $this->_Export('bounces', $query, $size, $user->userid);

		if($filename === true) //they had to multithread the result
			return true;
		return $filename;
	}

	public function ExportComplaintsToFile($senderids, $calendar_restrictions = array(), $sortinfo=array(), $searchFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		$query = '';

		// Apply date range if specified
		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND spamtime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0')
					. "' AND spamtime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		// Apply text filter if specified
		$filterValue = $this->Db->Quote($searchFilter);
		if($searchFilter != '')
			$query .= " AND (emailaddress LIKE '%" . $filterValue . "%')";

		// Apply sort
		$validsorts = array('email' => 'emailadress', 'date' => 'spamtime');
		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'spamtime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		$queryCount = "SELECT COUNT(*) c FROM complaint x INNER JOIN email e ON x.recipientid=e.emailid WHERE x.senderid IN (" . $senderids . ") " . $query;
		$query = "SELECT emailaddress, FROM_UNIXTIME(spamtime) complaintdatetime FROM complaint c INNER JOIN email e ON c.recipientid=e.emailid  WHERE c.senderid IN (" . $senderids . ") " . $query;

		// Retrieve results and export to file
		$result = $this->Db->Query($queryCount);
		if(!$result)
			return false;
		$size = $this->Db->FetchOne($result, 'c');

		$user = &GetUser();

		$filename = $this->_Export('complaints', $query, $size, $user->userid);

		if($filename === true) //they had to multithread the result
			return true;
		return $filename;
	}

	public function ExportIssuesToFile($userid, $calendar_restrictions = array(), $sortinfo=array(), $searchFilter='')
	{
		$query = '';

		// Apply date range if specified
		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND issuetime >= " . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0')
					. " AND issuetime < " . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399');

		// Apply text filter if specified
		$filterValue = $this->Db->Quote($searchFilter);
		if($searchFilter != '')
			$query .= " AND (emailaddress LIKE '%" . $filterValue . "%')";

		// Apply sort
		$validsorts = array('email' => 'emailaddress', 'date' => 'issuetime');
		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'date';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'issuetime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		$queryCount = "SELECT COUNT(*) c FROM sendissue WHERE userid = " . $userid . $query;
		$query = "SELECT userid, errormessage, emailaddress, issuetime FROM sendissue INNER JOIN senderrorcode ON senderrorcodeid=errorcode WHERE userid = " . $userid . $query;

		// Retrieve results and export to file
		$result = $this->Db->Query($queryCount);
		if(!$result)
			return false;
		$size = $this->Db->FetchOne($result, 'c');

		$user = &GetUser();

		$filename = $this->_Export('issues', $query, $size, $user->userid);

		if($filename === true) //they had to multithread the result
			return true;
		return $filename;
	}

	public function RecordClick($clickdetails=array())
	{
		if(!isset($clickdetails['userid'])) {
			return false; // if there's no subscriber id, it's probably an invalid array passed in.
		}

		$user = &GetUser($clickdetails['userid']);

		$record_click = true;

		/**
		 * this is the number of seconds to record link clicks as 'opens'.
		 * that is - if you click a link and tries to record a click,
		 * if it's in the last $number_of_seconds of the last clicked recorded for that subscriber
		 * it is not logged as a separate open.
		 */
		$number_of_seconds = 5;

		/**
		 * check how many times this subscriber has 'opened' the newsletter.
		 * if this returns anything, they have either displayed the open image	
		 * or clicked a link in the past.
		 */
		$query = "SELECT clicktime FROM `usergroup_clicks_" . $user->groupnum . "`.`userclicks_" . $user->userid . "` WHERE emailid='" . (int) $clickdetails['emailid'] . "' ORDER BY clicktime DESC LIMIT 1";
		$result = $this->Db->Query($query);
		$row_count = $this->Db->CountResult($result);

		if($row_count) {
			$now = $this->GetServerTime();
			$last_click_row = $this->Db->Fetch($result);
			$last_click = $last_click_row['clicktime'];
			if($last_click && (($now - $last_click) < $number_of_seconds)) {
				$record_click = false;
			}
		}

		$this->Db->FreeResult($result);

		if(!$record_click) {
			return;
		}

		$this->Db->Query("INSERT INTO `usergroup_clicks_" . $user->groupnum . "`.`userclicks_" . $user->userid . "` (linkid, emailid, ip, clicktime ) VALUES ('" . $clickdetails['linkid'] . "', '" . $clickdetails['emailid'] . "', '" . $clickdetails['clickip'] . "', '" . $this->GetServerTime() . "')");
	}

	public function RecordOpen($opendetails=array())
	{
		if(!isset($opendetails['userid'])) {
			return false; // if there's no subscriber id, it's probably an invalid array passed in.
		}

		$user = &GetUser($opendetails['userid']);

		$record_open = true;

		/**
		 * this is the number of minutes to record link clicks as 'opens'.
		 * that is - if you click a link and tries to record an open,
		 * if it's in the last $number_of_mins of the last open recorded for that subscriber
		 * it is not logged as a separate open.
		 */
		$number_of_mins = 2;

		/**
		 * check how many times this subscriber has 'opened' the newsletter.
		 * if this returns anything, they have either displayed the open image
		 * or clicked a link in the past.
		 */
		$query = "SELECT opentime FROM `usergroup_opens_" . $user->groupnum . "`.`useropens_" . $user->userid . "` WHERE emailid='" . (int) $opendetails['emailid'] . "' ORDER BY opentime DESC LIMIT 1";
		$result = $this->Db->Query($query);
		$last_open_row = $this->Db->Fetch($result);
		$row_count = $this->Db->CountResult($result);
		$this->Db->FreeResult($result);

		if(!empty($last_open_row)) {
			$cutoff = $this->GetServerTime() - ($number_of_mins * 60);
			$last_opened = $last_open_row['opentime'];

			// Anything recorded AFTER cutoff timestamp will not be recorded
			if($last_opened > $cutoff) {
				$record_open = false;
			}
		}

		if(!$record_open) {
			return true;
		}

		$this->Db->Query("INSERT INTO `usergroup_opens_" . $user->groupnum . "`.`useropens_" . $user->userid . "` (emailid, ip, agent, stage, opentime) VALUES ('" . (int) $opendetails['emailid'] . "', '" . $opendetails['openip'] . "', '" . $opendetails['useragent'] . "', 'seen', '" . $this->GetServerTime() . "')");
	}

	public function FetchLink($linkid)
	{
		$query = $this->Db->Query("SELECT url FROM links WHERE linkid='" . $this->Db->Quote($linkid) . "'");
		$url = $this->Db->FetchOne($query, 'url');
		$url = str_replace(array('"', "'"), '', $url);
		return $url;
	}

	public function GetSentEmails($senderids, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM email WHERE senderid IN (" . $senderids . ")";
		else
			$query = "SELECT * FROM email WHERE senderid IN (" . $senderids . ")";


		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND senttime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND senttime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		if($emailFilter != '')
			$query .= " AND emailaddress LIKE '%" . $this->Db->Quote($emailFilter) . "%'";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');


		$validsorts = array('email' => 'emailaddress', 'date' => 'senttime');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'senttime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$this->GetDb();
		$result = $this->Db->Query($query);

		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetDeliveredEmails($senderids, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($senderids))
			$senderids = implode(',', $senderids);
		if(empty($senderids))
			$senderids = 0;

		if($count_only) {
			$query = "SELECT COUNT(*) as count FROM email WHERE senderid IN (" . $senderids . ") AND delivered=1";
		} else {
			$query = "SELECT * FROM email e WHERE senderid IN (" . $senderids . ") AND delivered=1";
		}

		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND senttime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND senttime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		if($emailFilter != '')
			$query .= " AND emailaddress LIKE '%" . $this->Db->Quote($emailFilter) . "%'";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');


		$validsorts = array('email' => 'emailaddress', 'date' => 'senttime');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'time';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'senttime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$this->GetDb();
		$result = $this->Db->Query($query);

		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	public function GetSendIssues($userid, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='500', $sortinfo=array(), $emailFilter='')
	{
		if(is_array($userid))
			$userid = implode(',', $userid);
		if(empty($userid))
			$userid = 0;

		if($count_only)
			$query = "SELECT COUNT(*) as count FROM sendissue WHERE userid=" . $userid;
		else
			$query = "SELECT * FROM sendissue INNER JOIN senderrorcode ON senderrorcodeid=errorcode WHERE userid=" . $userid;


		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND issuetime >= '" . ($calendar_restrictions['StartDate'] != ''?$this->Db->Quote($calendar_restrictions['StartDate']):'0') . "' AND issuetime < '" . ($calendar_restrictions['EndDate'] != ''?$this->Db->Quote($calendar_restrictions['EndDate']):'253402304399') . "'";

		if($emailFilter != '')
			$query .= " AND emailaddress LIKE '%" . $this->Db->Quote($emailFilter) . "%'";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');


		$validsorts = array('email' => 'emailaddress', 'error' => 'errorcode', 'date' => 'issuetime');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy']))?strtolower($sortinfo['SortBy']):'date';
		$order = (in_array($order, array_keys($validsorts)))?$validsorts[$order]:'issuetime';
		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction']))?$sortinfo['Direction']:'DESC';
		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc')?'ASC':'DESC';
		$query .= " ORDER BY " . $order . " " . $direction;

		if($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);

		$this->GetDb();
		$result = $this->Db->Query($query);

		if(!$result)
			return false;

		$return = array();
		while($row = $this->Db->Fetch($result))
			array_push($return, $row);

		return $return;
	}

	/*
	 * Takes a UNIX_TIMESTAMP() and deletes all opens partitions older than the given timestamp
	 */

	function PurgeAllOpens($timestamp)
	{

		//echo $timestamp;  // Some Debugging
		//echo "\n";        // Some Debugging
		// Converts Given timestamp into format: YYYYMM
		$yearmonth = date("Ym", $timestamp);
		//echo $yearmonth ; // Some Debugging
		//echo "\n";        // Some Debugging

		/*
		 * Concats the query that searches the Partitions table in information schema
		 * partitions are named after the YYYYMM format. The query searches for all partitions
		 * older than the given timestamp of all usergroup_opens database
		 */
		//echo $yearmonth ;
		//echo "\n";
		$query = "SELECT CONCAT( TABLE_SCHEMA, '.', TABLE_NAME ) AS dbase , PARTITION_NAME FROM ";
		$query .="information_schema.PARTITIONS WHERE TABLE_SCHEMA LIKE 'usergroup_opens%' AND PARTITION_NAME < 'p";
		$query .= $yearmonth;
		$query .= "'";
		//echo $query ;
		//echo "\n";
		$results = $this->Db->Query($query);

		/*
		 * Takes the results from above and iterates through the rows and drop the found partitions
		 */
		while($row = $this->Db->Fetch($results))
		{
			$query = 'ALTER TABLE ' . $row["dbase"] . ' DROP PARTITION ' . $row["PARTITION_NAME"];
			$results2 = $this->Db->Query($query);
		}

		$results = $this->Db->Query("SELECT COUNT(*) FROM information_schema.PARTITIONS WHERE TABLE_SCHEMA LIKE 'usergroup_opens%' AND PARTITION_NAME < 'p" . $yearmonth . "'");
		if($results > 0)
			return false;
		return true;
	}

	/*
	 * Takes a UNIX_TIMESTAMP() and deletes all clicks partitions older than the given timestamp
	 */

	function PurgeAllClicks($timestamp)
	{

		//echo $timestamp;  // Some Debugging
		//echo "\n";        // Some Debugging
		// Converts Given timestamp into format: YYYYMM
		$yearmonth = date("Ym", $timestamp);
		//echo $yearmonth ; // Some Debugging
		//echo "\n";        // Some Debugging

		/*
		 * Concats the query that searches the Partitions table in information schema
		 * partitions are named after the YYYYMM format. The query searches for all partitions
		 * older than the given timestamp of all usergroup_clicks database
		 */
		$query = "SELECT CONCAT( TABLE_SCHEMA, '.', TABLE_NAME ) AS dbase , PARTITION_NAME FROM ";
		$query .="information_schema.PARTITIONS WHERE TABLE_SCHEMA LIKE 'usergroup_clicks%' AND PARTITION_NAME < 'p";
		$query .= $yearmonth;
		$query .= "'";
		//echo $query ;
		//echo "\n";
		$results = $this->Db->Query($query);

		/*
		 * Takes the results from above and iterates through the rows and drop the found partitions
		 */
		while($row = $this->Db->Fetch($results))
		{
			$query = 'ALTER TABLE ' . $row["dbase"] . ' DROP PARTITION ' . $row["PARTITION_NAME"];
			$results2 = $this->Db->Query($query);
		}

		$results = $this->Db->Query("SELECT COUNT(*) FROM information_schema.PARTITIONS WHERE TABLE_SCHEMA LIKE 'usergroup_clicks%' AND PARTITION_NAME < 'p" . $yearmonth . "'");
		if($results > 0)
			return false;
		return true;
	}

	/*
	 * AggregateDataForUser takes in a user object, and an array of calender restrictions
	 * if the the variable of getalldata is set to TRUE a master user will data for master
	 * and all sub user accounts. This fumction return an array contains all of the aggreagated
	 * data with in the time constraints.
	 * 
	 * returns an array with keys of sends, delivered, bounces, complaints, issues, clicks, read, skimmed, seen
	 */

	function AggregateDataForUser($userid, $calender_restrictions, $getalldata=false)
	{

		$totalarr = array();
		$temp = array();

		echo $userid;

		// get total emails
		$totalarr['sends'] = $this->GetCountOfSends($userid, $calender_restrictions);

		// get total delieverd emails
		$totalarr['delivered'] = $this->GetCountOfDelivered($userid, $calender_restrictions, $getalldata);

		// get total bounces
		$totalarr['bounces'] = $this->GetCountOfBounces($userid, $calender_restrictions, $getalldata);

		// get total complaints
		$totalarr['complaints'] = $this->GetCountOfComplaints($userid, $calender_restrictions, $getalldata);

		// get total issues
		$totalarr['issues'] = $this->GetCountOfIssues($userid, $calender_restrictions, $getalldata);

		// get total clicks
		$totalarr['clicks'] = $this->GetCountOfClicks($userid, $calender_restrictions, $getalldata);

		// get total opens
		$temp = $this->GetCountOfOpens($userid, $calender_restrictions, $getalldata);

		$totalarr['read'] = $temp['read'];
		$totalarr['skimmed'] = $temp['skimmed'];
		$totalarr['seen'] = $temp['seen'];

		return $totalarr;
	}

	/*
	 * Takes userid
	 * 
	 * This function will total all of the clicks of a user with in the given time restricions
	 * If the  the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */

	function GetCountOfClicks($userid, $calender_restrictions, $getalldata)
	{
		$user = new User_API();
		$groupnum = $user->GetGroupnumByUserId($userid);
		$query = "SELECT";
		if($user->IsMasterByUserId($userid) && $getalldata == true) {
			// since we want all of the data for master and subusers we need to union a few tables in different databases
			$count = 1;
			$subusers = $user->GetArrayOfUserIdsbyMasterId($userid, 1);
			$arraysize = count($subusers);
			foreach($subusers as &$id)
			{
				if($count != 1 && $count < $arraysize)
					$query.=" UNION ALL ";
				$query .= "( SELECT COUNT(clickid) as count FROM usergroup_clicks_" . $groupnum . ".userclicks_" . $id . " WHERE clicktime >=" . $calender_restrictions['StartDate'] . " AND clicktime <" . $calender_restrictions['EndDate'];
				$count++;
			}
		} else {
			$query.=" COUNT(clickid) as count FROM usergroup_clicks_" . $groupnum . ".userclicks_" . $userid . " WHERE clicktime >=" . $calender_restrictions['StartDate'] . " AND clicktime <" . $calender_restrictions['EndDate'];
		}
		$result = $this->Db->query($query);
		$result = $this->Db->Fetch($result);
		return $result['count'];
	}

	/*
	 * Takes userid
	 * 
	 * This function will total all of the opens of a user with in the given time restrictions
	 * If the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well.
	 * 
	 * This function returns an array with the keys of read, seen, and skimmed in that order
	 * If the stage names change this function needs to change!
	 */

	function GetCountOfOpens($userid, $calender_restrictions, $getalldata)
	{
		$user = new User_API();
		$arr = array();
		$temp = array();
		$groupnum = $user->GetGroupnumByUserId($userid);

		$query = "SELECT";
		if($user->IsMasterByUserId($userid) && $getalldata == true) {
			// since we want all of the data for master and subusers we need to union a few tables in different databases
			$count = 1;
			$subusers = $user->GetArrayOfUserIdsbyMasterId($userid, 1);
			$arraysize = count($subusers);
			foreach($subusers as &$id)
			{
				if($count != 1 && $count < $arraysize)
					$query.=" UNION ALL ";
				$query .= "( SELECT COUNT(openid) as count FROM usergroup_opens_" . $groupnum . ".useropens_" . $id . " WHERE opentime >=" . $calender_restrictions['StartDate'] . " AND opentime <" . $calender_restrictions['EndDate'] . " GROUP BY stage)";
				$count++;
			}
		} else {
			$query.=" COUNT(openid) as count FROM usergroup_opens_" . $groupnum . ".useropens_" . $userid . " WHERE opentime >=" . $calender_restrictions['StartDate'] . " AND opentime <" . $calender_restrictions['EndDate'] . " GROUP BY stage";
		}
		$result = $this->Db->Query($query);

		//format returned data for the array
		$temp = $this->Db->Fetch($result);
		$arr['read'] = $temp['count'];
		$temp = $this->Db->Fetch($result);
		$arr['seen'] = $temp['count'];
		$temp = $this->Db->Fetch($result);
		$arr['skimmed'] = $temp['count'];

		return $arr;
	}

	/*
	 * Takes userid
	 * 
	 * This function will total all of the issues of a user with in the given time restricions
	 * If the  the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */

	function GetCountOfIssues($userid, $calender_restrictions, $getalldata)
	{
		$user = new User_API();
		$query = "SELECT COUNT(sendissueid) as count FROM postfix.sendissue WHERE issuetime >=" . $calender_restrictions['StartDate'] . " AND issuetime <" . $calender_restrictions['EndDate'] . " AND userid ";
		if($user->IsMasterByUserId($userid) && $getalldata == true) {
			$subusers = $user->GetArrayOfUserIdsByMasterId($userid, 1);
			$subusers = implode(",", $subusers);
			$query .= " IN (" . $subusers . ")";
		} else {
			$query .= "=" . $userid;
		}
		$result = $this->Db->Query($query);
		$result = $this->Db->Fetch($result);

		return $result['count'];
	}

	/*
	 * Takes userid
	 *
	 * This function will total all of the issues of a user with in the given time restricions
	 * If the  the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */
	function GetCountOfBounces($userid, $calendar_restrictions)
	{
		$days = 0;
		$hardbounces = 0;
		$softbounces = 0;
		$prevhardbounce = 0;
		
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

		
		// =========== Temp Code!!! ===========
		//handle the month we aggregated
		$aggdata = false;
		$selectedmonth = date('n', $calendar_restrictions['StartDate']);
		if($selectedmonth >= 8)
			$aggdata = true;
		
		$userapi = $this->GetApi('user');
		$userapi->Load($userid);
		$senders_arr = array();
		$senders_arr = $userapi->GetApprovedSenders(true);
		$senderids = implode(',',$senders_arr);
		// =========== Temp Code!!! ===========

		for($i = 0; $i < $days; $i++)
		{
			
			$today = $calendar_restrictions['StartDate'] + ($i * 86400);
			$today = gmmktime(0, 0, 0, date('m', $today), date('d', $today), date('Y', $today));
			
			// Bounces
			if($aggdata) { //count using agg tables for the agg'd data
				$query = $this->Db->Query("SELECT SUM(hardbouncecount) as hardbouncecount, SUM(softbouncecount) as softbouncecount, SUM(prevbouncecount) as prevbouncecount FROM `bounce_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if ($result && !empty($result['hardbouncecount'])) {
					$hardbounces += (int) $result['hardbouncecount'];
					$softbounces += (int) $result['softbouncecount'];
					$prevhardbounce += (int) $result['prevbouncecount'];
				}
			} else { //this exists for the old months not aggregated. we still have to rock the old method. it's ok though this will be gone soon.
				$result = $this->Db->FetchOne("SELECT COUNT(bouncetime) as c FROM `bounce` WHERE bouncetime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND bouncetime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$hardbounces += (int) $result;

			}
		}
		return array( 'hardbounces' => $hardbounces, 'softbounces' => $softbounces, 'prevhardbounces' => $prevhardbounce);
		
	}

	/*
	 * Takes userid
	 *
	 * This function will total all of the complaints of a user with in the given time restricions
	 * If the  the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */

	function GetCountOfComplaints($userid, $calender_restrictions, $getalldata)
	{
		$user = new User_API();
		$query = "SELECT COUNT(c.complaintid) as count FROM postfix.complaint c INNER JOIN postfix.sender s ON s.senderid=c.senderid WHERE c.spamtime >=" . $calender_restrictions['StartDate'] . " AND c.spamtime <" . $calender_restrictions['EndDate']
				. " AND s.userid ";
		if($user->IsMasterByUserId($userid) && $getalldata == true) {
			$subusers = $user->GetArrayOfUserIdsByMasterId($userid, 1);
			$subusers = implode(",", $subusers);
			$query .= " IN (" . $subusers . ")";
		} else {
			$query .= "=" . $userid;
		}
		$result = $this->Db->Query($query);
		$result = $this->Db->Fetch($result);

		return $result['count'];
	}

	/*
	 * Takes userid
	 *
	 * This function will total all of the delivered of a user with in the given time restricions
	 * If the  the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */

	function GetCountOfDelivered($userid, $calendar_restrictions)
	{
		$days = 0;
		$total = 0;
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);
		
		// =========== Temp Code!!! ===========
		//handle the month we aggregated
		$aggdata = false;
		$selectedmonth = date('m', $calendar_restrictions['StartDate']);
		if($selectedmonth >= 8)
			$aggdata = true;
		
		$userapi = $this->GetApi('user');
		$userapi->Load($userid);
		$senders_arr = array();
		$senders_arr = $userapi->GetApprovedSenders(true);
		$senderids = implode(',',$senders_arr);
		// =========== Temp Code!!! ===========

		for($i = 0; $i < $days; $i++)
		{
			
			$today = $calendar_restrictions['StartDate'] + ($i * 86400);
			$today = gmmktime(0, 0, 0, date('m', $today), date('d', $today), date('Y', $today));
			
			// Delivered
			if($aggdata) { //count using agg tables for the agg'd data
				$query = $this->Db->Query("SELECT SUM(sentcount) as sentcount, SUM(undeliveredcount) as undeliveredcount FROM `email_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if($result && !empty($result['sentcount'])) {
					$total += (int) ($result['sentcount'] - $result['undeliveredcount']);
				}
			} else { //this exists for the old months not aggregated. we still have to rock the old method. it's ok though this will be gone soon.
				$result = $this->Db->FetchOne("SELECT COUNT(senttime) as c FROM `email` WHERE senttime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND senttime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ") AND delivered=1", 'c');
				if($result)
					$total += (int) $result;

			}
		}
		return $total;
		
		/*$user = new User_API();
		$query = "SELECT COUNT(e.emailid) as count FROM postfix.email e INNER JOIN postfix.sender s ON s.senderid=e.senderid WHERE e.delivered=1 and e.senttime >=" . $calender_restrictions['StartDate']
				. " AND e.senttime <" . $calender_restrictions['EndDate'] . " AND s.userid";
		if($user->IsMasterByUserId($userid) && $getalldata == true) {
			$subusers = $user->GetArrayOfUserIdsByMasterId($userid, 1);
			$subusers = implode(",", $subusers);
			$query .= " IN (" . $subusers . ")";
		} else {
			$query .= "=" . $userid;
		}
		$result = $this->Db->Query($query);
		$result = $this->Db->Fetch($result);

		return $result['count'];*/
	}

	/*
	 * Takes userid
	 *
	 * This function will total all of the email of a user with in the given time restricions
	 * If the variable of getalldata is set to true then all of the subusers
	 * data will be returned as well
	 */

	function GetCountOfSends($userid, $calendar_restrictions)
	{
		$days = 0;
		$total = 0;
		
		if(!isset($calendar_restrictions['StartDate']) || $calendar_restrictions['StartDate'] == '')
			$calendar_restrictions['StartDate'] = 0;
		if(!isset($calendar_restrictions['EndDate']) || $calendar_restrictions['EndDate'] == '')
			$calendar_restrictions['EndDate'] = time();
		$days = $this->dateDiff($calendar_restrictions['StartDate'], $calendar_restrictions['EndDate']);

				
		// =========== Temp Code!!! ===========
		//handle the month we aggregated
		$aggdata = false;
		$selectedmonth = date('m', $calendar_restrictions['StartDate']);
		if($selectedmonth >= 8)
			$aggdata = true;
		
		$userapi = $this->GetApi('user');
		$userapi->Load($userid);
		$senders_arr = array();
		$senders_arr = $userapi->GetApprovedSenders(true);
		$senderids = implode(',',$senders_arr);
		// =========== Temp Code!!! ===========

		for($i = 0; $i < $days; $i++)
		{
			
			$today = $calendar_restrictions['StartDate'] + ($i * 86400);
			$today = gmmktime(0, 0, 0, date('m', $today), date('d', $today), date('Y', $today));

			
			// Sent
			if($aggdata) { //count using agg tables for the agg'd data
				$query = $this->Db->Query("SELECT SUM(sentcount) as sentcount FROM `email_by_day` WHERE daytime = " . $this->Db->Quote($today) . " AND userid=" . $this->Db->Quote($userid));
				$result = $this->Db->Fetch($query);
				if($result && !empty($result['sentcount'])) {
					$total += (int) $result['sentcount'];
				}
			} else { //this exists for the old months not aggregated. we still have to rock the old method. it's ok though this will be gone soon.
				$result = $this->Db->FetchOne("SELECT COUNT(senttime) as c FROM `email` WHERE senttime >= " . $this->Db->Quote($calendar_restrictions['StartDate'] + ($i * 86400)) . " AND senttime < " . $this->Db->Quote($calendar_restrictions['StartDate'] + (($i + 1) * 86400)) . " AND senderid IN (" . $senderids . ")", 'c');
				if($result)
					$total += (int) $result;

			}
		}
		return $total;
	}

	/*
	 * This function will aggregate data for all subusers and insert colected data into the database.
	 */

	function AggregateMonthlyDataForAllUsers($month, $year)
	{

		$users = array();
		$info = array();

		if($month < 1 && $year < 1) {
			$month = $month % 12;
			$month = date("m") + $month;
			$year = date("Y") + $year;
		} else if($month >= 1 && $month < 13 && $year < 1) {
			$year = date("Y") + $year;
		}

		$calender_restrictions['StartDate'] = gmmktime(0, 0, 0, $month, 1, $year);
		$calender_restrictions['EndDate'] = gmmktime(0, 0, 0, $month + 1, 1, $year);

		$query = " Select id FROM postfix.users AS u INNER JOIN postfix.master AS m ON u.masterid=m.masterid  WHERE m.isdemo=0 AND u.admintype IN ('b','c') ";
		$result = $this->Db->Query($query);
		while($row = $this->Db->Fetch($result))
		{
			$info = $this->AggregateDataForUser($row['id'], $calender_restrictions);
			$query = " INSERT INTO postfix.usagehistory ( userid, year, month, sendcount, bouncecount, complaintcount, seencount, readcount, skimmedcount, clickcount, deliveredcount, issuecount ) VALUES ('";
			$query .= $row['id'] . "','" . $year . "','" . $month . "','" . $info['sends'] . "','" . $info['bounces'] . "','" . $info['complaints'] . "','" . $info['seen'] . "','" . $info['read'] . "','" . $info['skimmed'] . "','" . $info['clicks'] . "','" . $info['delivered'] . "','" . $info['issues'] . "')";
			$this->Db->Query($query);
		}

		return true;
	}

	function dateDiff($start, $end)
	{
		return round(($end - $start) / 86400);
	}

}