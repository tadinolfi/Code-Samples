<?php
require_once(dirname(__FILE__) . '/smartmta_functions.php');

/* *
 * Permissions:
 *     read
 *     loadgraph
 *     loadcount
 * */

class Index extends SmartMTA_Functions
{
	function Process()
	{
		if(!isset($_GET['ajax']))
			$this->PrintHeader();
		$action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
		
		switch($action)
		{
			case 'loadgraph':
				$this->LoadGraph();
			break;
			default:
				$statsapi = $this->GetApi('Stats');
				$session = &GetSession();
				$user = &GetUser();
				
				$selected_sender = 0;
				
				if($session->Get('SenderID'))
					$selected_sender = (int)$session->Get('SenderID');

				$curr_month = date('n');
				if(isset($_POST['month']))
				{
					$this->tpl->Assign('SelectedDate', $_POST['month']);
					$dd_exp = explode('|',$_POST['month']);
					$selected_month = $dd_exp[0];
					$selected_year = $dd_exp[1];
					$thismonth = mktime(0, 0, 0, $selected_month, 1, $selected_year);
					$nextmonth = mktime(0, 0, 0, $selected_month + 1, 1, $selected_year);
					$calendar_restrictions = array('StartDate' => $thismonth, 'EndDate' => $nextmonth, 'SelectedMonth' => $selected_month);
					$session->Set('CalendarRestrictions', $calendar_restrictions);
					$this->tpl->Assign('CurrentMonth', $this->months[$selected_month]);
					$this->tpl->Assign('CurrentYear', $selected_year);
				}
				else
				{
					$selected_month = $curr_month;
					$selected_year = date('Y');
					$this->tpl->Assign('SelectedDate', $selected_month.'|'.$selected_year);
					$this->tpl->Assign('CurrentMonth', '<span class="loading-small">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>');
					$this->tpl->Assign('CurrentYear', '');
				}

				$senderid = $session->Get('SenderID');
				if(isset($_POST['senderid']) && $_POST['senderid'] != 0)
				{
					$this->tpl->Assign('SelectedSenderId', $_POST['senderid']);
					$senderid = (int)$_POST['senderid'];
				}
				else
					$this->tpl->Assign('SelectedSenderId', 0);

				$session->Set('SenderID',$senderid);

				$this->tpl->ParseTemplate('index');
				
			break;
		}
		
		if(!isset($_GET['ajax']))
			$this->PrintFooter();
	}
	
	protected function LoadGraph()
	{
		$statsapi = $this->GetApi('Stats');
		$session = &GetSession();
		$user = &GetUser();
		$senderlist = $user->GetApprovedSenders(true);

		$senderid = 0;
		if($_GET['senderid'] != 0)
			$senderid = $_GET['senderid'];
		else
			$senderid = $senderlist;
		
		$enddate = gmmktime(23, 59, 59, date('n'), date('j'), date('Y'));
		$startdate = gmmktime(0, 0, 0, date('n'), date('j')-2, date('Y'));
		$calendar_restrictions = array('StartDate' => $startdate, 'EndDate' => $enddate, 'SelectedMonth' => date('m'));
		
		$senderids_for_range = array();
		if(is_array($senderid)) {
			foreach($senderid as $sndr)
				$senderids_for_range[] = $sndr;
		} else
			$senderids_for_range[] = $senderid;
		
		$json = array();
		
		// Close the session so our uses can navigate away.
		// NO SESSION DATA CAN GET WRITTEN AFTER THIS POINT
		session_write_close();
		
		list($sent_email_by_day, $delivered_email_by_day, $bounce_by_day, $spam_by_day, $issue_by_day, $weekdays) = $statsapi->GetReportsGraphData($user->userid, $senderid, $calendar_restrictions);

		$json['ChartData'] = array();
		$json['ChartData']['categories'] = $weekdays;
		if(empty($senderid)){
			$json['ChartData']['title'] = array(
				'text' => 'Example Data',
				'verticalAlign' => 'middle',
				'style' => array(
					'fontSize' => '50px',
					'color' => '#AA4643'));
		}
		else
			$json['ChartData']['title']['text'] = '3 Day Summary';

		$json['ChartData']['numdays'] = sizeof($sent_email_by_day);

		$json['ChartData']['data'] = array(
			//sent
			array('name' => 'Emails Sent','data' => array_values($sent_email_by_day)),
			// delivered
			array('name' => 'Emails Delivered','data' => array_values($delivered_email_by_day)),
			//bounce
			array('name' => 'Bounces','data' => array_values($bounce_by_day)),
			//spam
			array('name' => 'Complaints','data' => array_values($spam_by_day)),
			// issue
			array('name' => 'Issues','data' => array_values($issue_by_day)));

		$json['Status'] = 'OK';
		$json['Message'] = '';

		echo json_encode($json);
	}	
}