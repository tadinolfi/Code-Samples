<?php

error_reporting(6143);
ini_set("display_errors","1");

require_once(dirname(__FILE__) . '/api.php');

class Seedlist_API extends API
{
	var $seedlistid = 0;
	var $userid = 0;
	var $entrydate = '';
	
	var $emailaddress = '';
	
	function Seedlist_API($seedlistid=0)
	{
		$this->GetDb();
		return true;
	}
	
	function Load($creditid)
	{
		
	}
	
	function GetSeedList($global=false, $userid=0, $email_only=false)
	{
		$getSeedResult = array();
		
		if ($global == false && $userid != 0)
		{
			$getSeedEnabledQry = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."seedlist WHERE userid='$userid' ORDER BY dateadded DESC";
			$getSeedEnabledRes = $this->Db->Query($getSeedEnabledQry);
			
		} else {
			$getSeedEnabledQry = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."seedlist WHERE userid=0 ORDER BY dateadded DESC";
			$getSeedEnabledRes = $this->Db->Query($getSeedEnabledQry);
		}
		while ($getSeedEnabledRow = $this->Db->Fetch($getSeedEnabledRes))
		{
				
				if ($email_only)
				{
					$getSeedResult[] = $getSeedEnabledRow['email'];
				} else {
					$getSeedResult[] = $getSeedEnabledRow;
				}
		}
		
		return $getSeedResult;
	}
	
	function CreateSeed()
	{
		$seedQry = "INSERT INTO ".SENDSTUDIO_TABLEPREFIX."seedlist (email, dateadded, userid) VALUES ('".$this->Db->Quote($this->emailaddress)."', NOW(), '".$this->userid."')";
		return $this->Db->Query($seedQry);
	}
	
	function RemoveSeed($seedid = 0)
	{
		if ($seedid > 0)
		{
			$seedQry = "DELETE FROM ".SENDSTUDIO_TABLEPREFIX."seedlist WHERE seedlistid=$seedid";
			return $this->Db->Query($seedQry);
		}
		return false;
	}
	
	function GetSeed($seedid = 0)
	{
	if ($seedid > 0)
		{
			$seedQry = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."seedlist WHERE seedlistid=$seedid";
			$seedRes = $this->Db->Query($seedQry);
			return $this->Db->Fetch($seedRes);
		}
		return false;
	}
	
	function UpdateSeed($seedid = 0)
	{
		if ($seedid > 0)
		{
			$seedQry = "UPDATE ".SENDSTUDIO_TABLEPREFIX."seedlist SET email='".$this->emailaddress."' WHERE seedlistid=$seedid";
			return $this->Db->Query($seedQry);
		}
		return false;
	}
	
}

?>
