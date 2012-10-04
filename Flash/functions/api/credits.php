<?php

error_reporting(6143);
ini_set("display_errors","1");

require_once(dirname(__FILE__) . '/api.php');

class Credit_API extends API
{
	var $creditehistoryid = 0;
	var $userid = 0;
	var $entrydate = '';
	var $creditamount = 0;
	var $note = '';
	var $gateway = null;
	var $current_total = 0;
	var $type = 'credits';
	
	function Credit_API($creditid=0)
	{
		$this->GetDb();
		if ($creditid > 0) {
			return $this->Load($creditid);
		}
		return true;
	}
	
	function Load($creditid)
	{
		if($creditid <= 0)
			return false;
			
		$loadCreditQry = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX." WHERE credithistoryid = $creditid";
		$loadCreditRes = $this->Db->Query($loadCreditQry);
		if(!$loadCreditRes)
			return false;
			
		$loadCreditRow = $this->Db->Fetch($loadCreditRes);
		if(!$loadCreditRow)
			return false;
		
		$this->credithistory = $loadCreditRow['credithistoryid'];
		$this->userid = $loadCreditRow['userid'];
		$this->entrydate = $loadCreditRow['entrydate'];
		$this->creditamount = $loadCreditRow['creditamount'];
		$this->note = $loadCreditRow['note'];
		
		return true;
	}
	
	function Create()
	{
		$createCreditQry =	'INSERT INTO ' . SENDSTUDIO_TABLEPREFIX . 'credit_history (userid, entrydate, creditamount, note, current_total, type) 
							VALUES (' . $this->userid . ', NOW(),' . $this->creditamount . ', \'' . $this->Db->Quote($this->note) . '\',' . (int)$this->current_total . ', \'' . $this->Db->Quote($this->type) . '\')';
		
		$createCreditResult = $this->Db->Query($createCreditQry);
		if($createCreditResult)
		{
			$this->credithistoryid  = $this->Db->LastId(SENDSTUDIO_TABLEPREFIX . 'credit_history');
			return $this->credithistoryid;
		}
		return false;
	}
		
	function GetCreditHistory($userid = 0)
	{
		$getCreditsQry = 'SELECT credithistoryid, entrydate, creditamount, note, companyname, fullname, current_total FROM '.SENDSTUDIO_TABLEPREFIX.'credit_history h INNER JOIN '.SENDSTUDIO_TABLEPREFIX.'users u ON h.userid = u.userid ';
		if($userid > 0)
			$getCreditsQry .= " WHERE h.userid = $userid";
		
		$getCreditsQry .= " ORDER BY entrydate DESC";
		
		$getCreditsRes = $this->Db->Query($getCreditsQry);
		$retCredits = array();
		while($getCreditsRow = $this->Db->Fetch($getCreditsRes))
		{
			array_push($retCredits,$getCreditsRow);
		}
		return $retCredits;
	}
	
	function PurchaseCredits($firstname, $lastname, $address, $city, $state, $zip, $cardnumber, $cvn, $exprdate, $price, $credits, $userid, $cctype)
	{	
		require(SENDSTUDIO_LIB_DIRECTORY . '/gateways/' . SENDSTUDIO_PAYMENT_GATEWAY . '.php');
		
		$this->gateway = new Payment_Gateway();
		$paymentResult = $this->gateway->MakePurchase($firstname, $lastname, $address, $city, $state, $zip, $cardnumber, $cvn, $exprdate, $price);
		if($paymentResult[0] == 1)
		{
			$this->userid = $userid;
			$this->creditamount = $credits;
			$this->note = 'Purchased credits';
			
			$updateUserSql = "UPDATE ".SENDSTUDIO_TABLEPREFIX."users SET maxemails = maxemails + $credits WHERE userid = $userid";
			$this->Db->Query($updateUserSql);
			
			$this->current_total = $this->GetTotalCredits();
			$this->Create();
			
			// We need the email for this user so we can send them an invoice
			$user = new User_API($this->userid);
			$this->SendInvoice($firstname, $lastname, $address, $city, $state, $zip, $price, $credits, $user->emailaddress, $cctype);
		}
		return $paymentResult;
	}
	
	function SpendCredits($creditsspent, $note, $userid, $type='credits')
	{
		$this->userid = $userid;
		$this->creditamount = -1 * $creditsspent;
		$this->note = $note;
		$this->type = $type;
		$this->current_total = $this->GetTotalCredits($userid, $type);
		
		
		$this->Create();
	}
	
	function RefundCredits($credits, $note, $userid)
	{
		$this->userid = $userid;
		$this->creditamount = $credits;
		$this->note = $note;
		$this->current_total = $this->GetTotalCredits();
		
		$this->Create();
	}
	
	function GetPackages($type='credits')
	{
		switch($type)
		{
			case 'credits':
				$packageQuery = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."credit_packages WHERE type='credits' ORDER BY creditamount ASC";
			break;
			case 'render':
				$packageQuery = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."credit_packages WHERE type='render' ORDER BY creditamount ASC";
			break;	
		}
		
			$packageRes = $this->Db->Query($packageQuery);
			$retArray = array();
			while($packageRow = $this->Db->Fetch($packageRes))
			{
				array_push($retArray,$packageRow);
			}
		return $retArray;
				
	}
	
	function GetPackage($packageid, $type='credits')
	{
		$packageQuery = "SELECT * FROM ".SENDSTUDIO_TABLEPREFIX."credit_packages WHERE type='$type' AND creditpackageid = $packageid";
		$packageRes = $this->Db->Query($packageQuery);
		$packageRow = $this->Db->Fetch($packageRes);
		return $packageRow;
	}
	
	function SendInvoice($firstname, $lastname, $address, $city, $state, $zip, $price, $credits, $email, $cctype)
	{
		$invoice = "We have recieved your request to add $credits more credits. If you have any questions feel free to contact us at 1-800-722-7194\n\n";
		$invoice .= "Thanks for your purchase! Your payment details are as follows:\n\n";
		$invoice .= "---------------- Sendlabs Credit Purchase -------------------------\n\n";
		$invoice .= "First: $firstname\nLast: $lastname\nAddress: $address\nCity: $city\nState: $state\nZip: $zip\n\n\n";
		$invoice .= "Cardtype: $cctype \nCredits: $credits\nAmount: $price\n\n\n";
		$invoice .= "------------------------------------------------------------------\n\n";
		
		
		mail($email, "Sendlabs Purchase Confirmation", $invoice, "From:support@sendlabs.com\r\nBcc:creditsales@sendlabs.com");
	}
	
	function GetTotalCredits($userid=0, $type='credits')
	{
		if($userid == 0)
		{
			$userid = $this->userid;
		}
		if($type == 'credits')
		{
			$query = "SELECT maxemails FROM " . SENDSTUDIO_TABLEPREFIX . "users WHERE userid='" . $userid . "'";
			$result = $this->Db->Query($query);
			return $this->Db->FetchOne($result, "maxemails");
		} else {
			$query = "SELECT litmuspoints FROM " . SENDSTUDIO_TABLEPREFIX . "litmus WHERE userid='" . $userid . "'";
			$result = $this->Db->Query($query);
			return $this->Db->FetchOne($result, "litmuspoints");
		}
		
	}
}

?>
