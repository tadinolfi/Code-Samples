<?php

error_reporting(6143);
ini_set("display_errors","1");

require_once(dirname(__FILE__) . '/api.php');

class Bounceadmin_API extends API
{
	var $userid = 0;
	var $entrydate = '';
	
	var $emailaddress = '';
	
	var $DefaultDirection = 'down';
	
	var $DefaultOrder = 'bouncetime';
	
	var $ValidSorts = array('username' => 'UserName', 'bouncetime' => 'BounceTime', 'emailaddress' => 'EmailAddress', 'bouncemessage' => 'BounceMessage');
	
	
	function Bounceadmin_API($seedlistid=0)
	{
		$this->GetDb();
		return true;
	}
	
	function Load()
	{
		
	}
	
	function GetSpamComplaints($global=false, $userid=0, $start=0, $perpage=10, $count=false)
	{
		$getSpamResult = array();
		
		if ($userid == false)
		{
			$userid = 0;
		}
		
		if ($count && $global)
		{
			$getSpamCount = "SELECT lsu.*, ls.emailaddress FROM ".SENDSTUDIO_TABLEPREFIX."list_subscribers_unsubscribe as lsu INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsu.subscriberid=ls.subscriberid WHERE lsu.complaint=1 ORDER BY bouncetime DESC";
			$getSpamRes = $this->Db->Query($getSpamCount);
			return $this->Db->CountResult($getSpamRes);
		} elseif($count && $global == false && $userid > 0) {
			$getSpamCount = "SELECT sl.listid, lsu.*, ls.emailaddress FROM ".SENDSTUDIO_TABLEPREFIX."lists as sl INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers_unsubscribe AS lsu ON sl.listid=lsu.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsu.subscriberid=ls.subscriberid WHERE sl.ownerid=$userid AND lsu.complaint=1 ORDER BY bouncetime DESC";
			$getSpamRes = $this->Db->Query($getSpamCount);
			return $this->Db->CountResult($getSpamRes);
		}
		
		if ($global == false && $userid != 0)
		{
			$getSpamQry = "SELECT sl.ownerid, sl.listid, lsu.*, ls.emailaddress, u.username FROM ".SENDSTUDIO_TABLEPREFIX."lists as sl INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscriber_unsubscribe AS lsu ON sl.listid=lsu.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsu.subscriberid=ls.subscriberid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."users as u ON sl.ownerid=u.userid WHERE sl.ownerid=$userid AND complaint=1 ORDER BY bouncetime DESC";
			
			if ($perpage != 'all' && ($start || $perpage)) {
				$getSpamQry .= $this->Db->AddLimit($start, $perpage);
			}
			$getSpamRes = $this->Db->Query($getSpamQry);
			
		} else {
			$getSpamQry = "SELECT lsu.*, ls.emailaddress, u.username FROM ".SENDSTUDIO_TABLEPREFIX."list_subscribers_unsubscribe as lsu INNER JOIN ".SENDSTUDIO_TABLEPREFIX."lists as sl ON sl.listid=lsu.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsu.subscriberid=ls.subscriberid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."users as u ON sl.ownerid=u.userid WHERE lsu.complaint=1 ORDER BY bouncetime DESC";
		
			if ($perpage != 'all' && ($start || $perpage)) {
				$getSpamQry .= $this->Db->AddLimit($start, $perpage);
			}
			$getSpamRes = $this->Db->Query($getSpamQry);
		}
		while ($getSpamRow = $this->Db->Fetch($getSpamRes))
		{
				
				$getSpamResult[] = $getSpamRow;
		}
		
		return $getSpamResult;
	}
	
	function GetBounces($global=false, $userid=0, $start=0, $perpage=10, $count=false)
	{
		$getBounceResult = array();
		
		if ($userid == false)
		{
			$userid = 0;
		}
		
		if ($count && $global)
		{
			$getBouncesCount = "SELECT lsb.*, ls.emailaddress FROM ".SENDSTUDIO_TABLEPREFIX."list_subscriber_bounces as lsb INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsb.subscriberid=ls.subscriberid ORDER BY bouncetime DESC";
			$getBouncesRes = $this->Db->Query($getBouncesCount);
			return $this->Db->CountResult($getBouncesRes);
		} elseif($count && $global == false && $userid > 0) {
			$getBouncesCount = "SELECT sl.listid, lsb.*, ls.emailaddress FROM ".SENDSTUDIO_TABLEPREFIX."lists as sl INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscriber_bounces AS lsb ON sl.listid=lsb.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsb.subscriberid=ls.subscriberid WHERE sl.ownerid=$userid ORDER BY bouncetime DESC";
			$getBouncesRes = $this->Db->Query($getBouncesCount);
			return $this->Db->CountResult($getBouncesRes);
		}
		
		if ($global == false && $userid != 0)
		{
			$getBouncesQry = "SELECT sl.ownerid, sl.listid, lsb.*, ls.emailaddress, u.username FROM ".SENDSTUDIO_TABLEPREFIX."lists as sl INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscriber_bounces AS lsb ON sl.listid=lsb.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsb.subscriberid=ls.subscriberid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."users as u ON sl.ownerid=u.userid WHERE sl.ownerid=$userid ORDER BY bouncetime DESC";
			
			if ($perpage != 'all' && ($start || $perpage)) {
				$getBouncesQry .= $this->Db->AddLimit($start, $perpage);
			}
			$getBouncesRes = $this->Db->Query($getBouncesQry);
			
		} else {
			$getBouncesQry = "SELECT lsb.*, ls.emailaddress, u.username FROM ".SENDSTUDIO_TABLEPREFIX."list_subscriber_bounces as lsb INNER JOIN ".SENDSTUDIO_TABLEPREFIX."lists as sl ON sl.listid=lsb.listid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."list_subscribers as ls ON lsb.subscriberid=ls.subscriberid INNER JOIN ".SENDSTUDIO_TABLEPREFIX."users as u ON sl.ownerid=u.userid ORDER BY bouncetime DESC";
		
			if ($perpage != 'all' && ($start || $perpage)) {
				$getBouncesQry .= $this->Db->AddLimit($start, $perpage);
			}
			$getBouncesRes = $this->Db->Query($getBouncesQry);
		}
		while ($getBounceRow = $this->Db->Fetch($getBouncesRes))
		{
				
				$getBounceResult[] = $getBounceRow;
		}
		
		return $getBounceResult;
	}
}

?>
