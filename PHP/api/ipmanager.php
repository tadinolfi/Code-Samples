<?php
require_once(dirname(__FILE__) . '/api.php');

class Ipmanager_API extends API
{
	public $id;
	public $userids;
	public $ip;
	public $vmta;
	public $shared;
	public $notes;
	public $mta;

	function __construct()
	{
		$this->GetDb();
	}

	public function Create()
	{
		$this->GetDb();
		$this->Db->StartTransaction();
		$query = "INSERT INTO ip_pool (ip, vmta, shared, created, notes, mta) VALUES('" . $this->Db->Quote($this->ip) . "', '" . $this->Db->Quote($this->vmta) . "', " . ($this->shared ? 1 : 0) . ", UNIX_TIMESTAMP(), '" . $this->Db->Quote($this->notes) . "', '" . $this->Db->Quote($this->mta) . "')";
		$result = $this->Db->Query($query);

		if(!$result) {
			$this->Db->RollbackTransaction();
			return false;
		}
		
		$ipid = $this->Db->LastId();

		if($this->userids)
		{
			//now link the IPs to actual accounts
			$query = "INSERT INTO ip_pool_user (ipid, userid) VALUES";
			foreach($this->userids as $userid)
				$query .= "(".$ipid.",".$userid."),";
			$query = rtrim($query, ',');

			$result = $this->Db->Query($query);

			if(!$result) {
				$this->Db->RollbackTransaction();
				return false;
			}
		}
		if(!$this->Db->CommitTransaction())
		{
			$this->Db->RollbackTransaction();
			return false;
		}
		return true;
	}

	public function Update()
	{
		$this->Db->StartTransaction();
		//first lets handle the updates
		$query = "UPDATE ip_pool SET".($this->ip != '' ? " ip=".$this->Db->Quote($this->ip)."," : "")." vmta='" . $this->Db->Quote($this->vmta) . "', shared='" . ($this->shared ? 1 : 0) . "', notes='" . $this->Db->Quote($this->notes) . "', mta='" . $this->Db->Quote($this->mta) . "' WHERE ipid=" . $this->Db->Quote($this->id);
		$result = $this->Db->Query($query);

		if(!$result) {
			$this->Db->RollbackTransaction();
			return false;
		}
		
		// get modified users if any
		if(!$this->userids)
			$this->userids = array();

		$users = $this->GetIPsAccounts($this->id, true);
		if(!is_array($this->userids))
			$this->userids = array($this->userids);
		$remusers = array_diff($users, $this->userids);
		$newusers = array_diff($this->userids, $users);
		//remove removed users
		if(count($remusers) > 0)
		{
			$query = 'DELETE FROM ip_pool_user WHERE userid IN(';
			foreach($remusers as $remuser)
				$query .= $this->Db->Quote($remuser) . ',';
			$query = rtrim($query, ',') . ')';

			$result = $this->Db->Query($query);

			if(!$result) {
				$this->Db->RollbackTransaction();
				return false;
			}
		}
		//add new users
		if(count($newusers) > 0)
		{
			$query = 'INSERT INTO ip_pool_user (ipid,userid) VALUES';
			foreach($newusers as $newuser)
				$query .= '(' . $this->Db->Quote($this->id) . ', ' . $newuser . '),';
			$query = rtrim($query, ',');

			$result = $this->Db->Query($query);

			if(!$result) {
				$this->Db->RollbackTransaction();
				return false;
			}
		}


		if(!$this->Db->CommitTransaction())
		{
			$this->Db->RollbackTransaction();
			return false;
		}
		
		return true;
	}
	
	public function AddUserToVMTAName($userid, $vmta)
	{
		$query = 'INSERT INTO ip_pool_user (ipid,userid) VALUES(' . $this->Db->Quote($vmta) . ', ' . $userid . ')';

		$result = $this->Db->Query($query);

		if(!$result) {
			$this->Db->RollbackTransaction();
			return false;
		}
	}
	
	public function GetIPsByVMTA($id)
	{
		$query = "SELECT i.ipid, i.ip FROM ip_pool i WHERE vmta=(SELECT p.vmta FROM ip_pool p WHERE ipid=".$this->Db->Quote($id)." LIMIT 1)";
		$result = $this->Db->Query($query);
		if(!$result)
			return array();
		$ips = array();
		while($row = $this->Db->Fetch($result))
			array_push($ips, $row);
		return $ips;
	}
	
	public function GetIPsByVMTAName($name)
	{
		$query = "SELECT i.ipid FROM ip_pool i WHERE vmta='".$this->Db->Quote($name)."' LIMIT 1";
		$result = $this->Db->Query($query);
		if(!$result)
			return false;
		return $this->Db->FetchOne($result, 'ipid');
	}

	public function Exists($ip)
	{
		//TODO: Finish this function
		return false;
	}

	public function Delete($id)
	{
		$this->Db->StartTransaction();
		$query = "DELETE FROM ip_pool_user WHERE ipid=".$id;
		$result = $this->Db->Query($query);
		if(!$result) {
			$this->Db->RollbackTransaction();
			return false;
		}
		$query = "DELETE FROM ip_pool WHERE ipid=".$id;
		$result = $this->Db->Query($query);
		if(!$result) {
			$this->Db->RollbackTransaction();
			return false;
		}
		if(!$this->Db->CommitTransaction())
		{
			$this->Db->RollbackTransaction();
			return false;
		}
		return true;
	}

	public function GetIPs($userid, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='100', $sortinfo=array(), $searchFilter='')
	{
		$user = &GetUser($userid);
		
		$this->GetDb();
		$query = " FROM ip_pool i";

		if($count_only)
			$query = "SELECT COUNT( DISTINCT i.ipid ) count" . $query;
		else
			$query = "SELECT DISTINCT i.ipid, i.ip, i.vmta, i.shared, i.notes, i.created, i.mta" . $query;

		//logic for what IPs to show
		if(!$user->hasRole('ManageMTA')) //if they are not steve, or a steve equivalent then only show them theirs
		{
			if(!$user->hasRole('Master')) //if they are not master show them only their ips
				$query .= " INNER JOIN ip_pool_user iu ON i.ipid=iu.ipid AND iu.userid=".$userid." AND i.shared=0";
			else //else they are a master so show them all their emails
				$query .= " INNER JOIN ip_pool_user iu ON i.ipid=iu.ipid INNER JOIN users u ON iu.userid=u.id AND u.masterid=".$user->masterid." WHERE i.shared=0";			
		} else
			$query .= " WHERE 1=1";


		if(is_array($calendar_restrictions) && !empty($calendar_restrictions))
			$query .= " AND i.created >= '" . ($calendar_restrictions['StartDate'] != '' ? $this->Db->Quote($calendar_restrictions['StartDate']) : '0') . "' AND i.created < '" . ($calendar_restrictions['EndDate'] != '' ? $this->Db->Quote($calendar_restrictions['EndDate']) : '253402304399') . "'";

		$filterValue = $this->Db->Quote($searchFilter);
		if($searchFilter != '')
			$query .= " AND (i.ip LIKE '%" . $filterValue . "%' OR i.vmta LIKE '%" . $filterValue . "%')";

		if($count_only)
			return $this->Db->FetchOne($query, 'count');

		$validsorts = array('ip' => 'i.ip', 'date' => 'i.created', 'vmta' => 'i.vmta', 'notes' => 'i.notes', 'date' => 'i.created');

		$order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy'])) ? strtolower($sortinfo['SortBy']) : 'date';

		$order = (in_array($order, array_keys($validsorts))) ? $validsorts[$order] : 'i.created';

		$direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction'])) ? $sortinfo['Direction'] : 'ASC';

		$direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc') ? 'ASC' : 'DESC';

		$query .= " ORDER BY " . $order . " " . $direction;

		if ($perpage != 'all' && ($start || $perpage))
			$query .= $this->Db->AddLimit($start, $perpage);
		
		$result = $this->Db->Query($query);

		$ips = array();
		while($row = $this->Db->Fetch($result))
			array_push($ips, $row);

		return $ips;
	}

	/**
	 * Get all UserIDs associated by an IP by an IP's ID.
	 * 
	 * @param int $ipid
	 * @param bool $idsOnly
	 * @param bool $user
	 * @return array 
	 */
	public function GetIPsAccounts($ipid, $idsOnly=false, $user=false)
	{
		$query = "SELECT u.id, u.username, u.companyname FROM users u INNER JOIN ip_pool_user iu ON iu.userid=u.id AND iu.ipid=".$ipid;
		if($user && !$user->hasRole('ManageMTA'))
			$query .= " AND masterid=" . $user->masterid;
		$result = $this->Db->Query($query);
		if($result)
		{
			$users = array();
			while($row = $this->Db->Fetch($result)) {
				if($idsOnly)
					array_push($users, $row['id']);
				else
					array_push($users, $row);
			}
			return $users;
		}
		return false;
	}

	/**
	 * Get a VMTA's name and mta associated to a user by userid 
	 * 
	 * @param int $userid The id of the user to select with.
	 * @return string the name of the vmta. if no vmta is found then "GoodVMTAs" is passed.
	 */
	public function GetVMTAByUserID($userid)
	{
		$query = "SELECT i.vmta, i.mta FROM ip_pool i INNER JOIN ip_pool_user iu ON iu.ipid=i.ipid AND iu.userid=".$userid." LIMIT 1";
		$result = $this->Db->Query($query);
		if($this->Db->CountResult($result) > 0)
		{
			$row = $this->Db->Fetch($result);
			return !empty($row) ? $row : array('vmta' => 'GoodVMTAs', 'mta' => 1);
		}
		return array('vmta' => 'GoodVMTAs', 'mta' => 1);
	}
}