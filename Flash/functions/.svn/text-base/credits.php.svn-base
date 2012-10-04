<?php

error_reporting(6143);
ini_set("display_errors","1");

require(dirname(__FILE__) . '/sendstudio_functions.php');

class Credits extends SendStudio_Functions
{
	var $PopupWindows = array();
	var $SuppressHeaderFooter = array();
	var $_DefaultDirection = 'up';
	
	function Credits()
	{
		$this->LoadLanguageFile();
	}
	
	function Process()
	{
		$action = (isset($_GET['Action'])) ? strtolower(urldecode($_GET['Action'])) : null;
		$subaction = (isset($_GET['Subaction'])) ? strtolower(urldecode($_GET['Subaction'])) : null;
		$session = &GetSession();
		$user = &GetUser();
		
		if ($action == 'processpaging') {
			$perpage = (int)$_GET['PerPageDisplay'];
			$display_settings = array('NumberToShow' => $perpage);
			$user->SetSettings('DisplaySettings', $display_settings);
			$action = '';
		}
		/*if ($_SERVER['HTTPS'] != "on" && $action == 'purchase') { 
			$url = "https://". $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI']; 
			header("Location: $url"); 
		}*/
		
		if ($action != 'purchasereceipt')
		{
		$this->PrintHeader();
		}
		switch($action)
		{
			case 'purchase':
				require_once 'api/credits.php';
				$creditapi = new Credit_API();
				switch($subaction)
				{	
					
						
					case 'step2':
						
						$thisyear = date('Y');
						$yearoptions = '';
						for($i = 0; $i< 6; $i++)
						{
							$year = $thisyear + $i;
							$yearoptions .= "<option value=\"$year\">$year</option>";
						}
						$GLOBALS['YearList'] = $yearoptions;
						$statesUser = new User_API();
						$GLOBALS['StateList'] = $statesUser->GetStatesList();
						$template = $this->ParseTemplate("Credit_Form_Step2", true, false);
						
						if(isset($_POST['credits']) && $_POST['credits'] != '')
						{
							$package = $creditapi->GetPackage($_POST['credits']);
							$creditStart = substr($package['creditamount'],0,strlen($package['creditamount'])-3);
							$creditEnd = substr($package['creditamount'],strlen($package['creditamount'])-3);
							$GLOBALS['CreditsFormatted'] = $creditStart.','.$creditEnd;
							$GLOBALS['Credits'] = $package['creditamount'];
							$GLOBALS['Price'] = $package['price'];
							$GLOBALS['PackageType'] = 'Credits';
							$creditpackagelist = $this->ParseTemplate('Credit_Package_Itemized', true, false); 
						}
						
						
						
						if(isset($_POST['renders']) && $_POST['renders'] != '')
						{
							$package = $creditapi->GetPackage($_POST['renders'], 'render');
							$GLOBALS['CreditsFormatted'] = $package['creditamount'];
							$GLOBALS['Credits'] = $package['creditamount'];
							$GLOBALS['Price'] = $package['price'];
							$GLOBALS['PackageType'] = 'Renders';
							$renderpackagelist = $this->ParseTemplate('Credit_Package_Itemized', true, false);
						}
												
						
						$template = str_replace("%%TPL_CreditsChosen%%", $creditpackagelist, $template);
						$template = str_replace("%%TPL_RenderCreditsChosen%%", $renderpackagelist, $template);
						echo $template;
					break;
					
					default:
						
						$packages = $creditapi->GetPackages('credits');
						$creditpackagelist = '';
						$GLOBALS['PackageType'] = 'credits';
						$creditct = 0;
						foreach($packages as $package)
						{
							$GLOBALS['PackageId'] = $package['creditpackageid'];
							$creditStart = substr($package['creditamount'],0,strlen($package['creditamount'])-3);
							$creditEnd = substr($package['creditamount'],strlen($package['creditamount'])-3);
							$GLOBALS['CreditAmount'] = $creditStart.','.$creditEnd;
							$GLOBALS['Price'] = $package['price'];
							$GLOBALS['PackageName'] = $package['packagename'];
							$creditpackagelist .= $this->ParseTemplate("Credit_Package_Row",true,false);
							$creditct++;
						}
						
						$template = $this->ParseTemplate("Credit_Form_Step1",true,false);
						$template = str_replace('%%TPL_CreditsPackage_Row%%',$creditpackagelist,$template);
						
						$packages = $creditapi->GetPackages('render');
						$renderpackagelist = '';
						$GLOBALS['PackageType'] = 'renders';
						$renderct = 0;
						foreach($packages as $package)
						{
							$GLOBALS['PackageId'] = $package['creditpackageid'];
							$GLOBALS['CreditAmount'] = $package['creditamount'];
							$GLOBALS['Price'] = $package['price'];
							$GLOBALS['PackageName'] = $package['packagename'];
							$renderpackagelist .= $this->ParseTemplate("Credit_Package_Row",true,false);
							$renderct++;
						}
						
						if($creditct > $renderct)
						{
							while($creditct >= $renderct)
							{
								
								$renderpackagelist .= $this->ParseTemplate("Empty_Credit_Package_Row", true, false);
								$renderct++;
							}
						} elseif($renderct > $creditct) {
							
							while($renderct >= $creditct)
							{
								$creditpackagelist .= $$this->ParseTemplate("Empty_Credit_Package_Row", true, false);
								$creditct++;
							}
						}
						
						$template = str_replace('%%TPL_RenderPackage_Row%%',$renderpackagelist,$template);
						echo $template;
					break;
				}
			break;
			
			case 'processpayment':
				
				require_once 'api/credits.php';
				$creditapi = new Credit_API();
				$user = &GetUser(); 
				$purchaseResult = $creditapi->PurchaseCredits(
												$_POST['fname'], 
												$_POST['lname'], 
												$_POST['address'], 
												$_POST['city'],
												$_POST['state'], 
												$_POST['zip'], 
												$_POST['ccnum'], 
												$_POST['cnv'], 
												$_POST['expmonth'] . $_POST['expyear'], 
												$_POST['price'],
												$_POST['credits'], 
												$user->userid,
												$_POST['cctype']
											);

				switch($purchaseResult[0])
				{
					case 1:
						//approved
						$user = &GetUser(); 
						$user = &GetUser($user->userid); 
						$new_user = new User_API($user->userid);
						$purchasedetail = array('Firstname' => $_POST['fname'], 'Lastname' => $_POST['lname'], 'Credits' => $_POST['credits'], 'Price' => $_POST['price'], 'Address' => $_POST['address'], 'City' => $_POST['city'], 'State' => $_POST['state'], 'Zip' => $_POST['zip'], 'cctype' => $_POST['cctype']);
						$session = &GetSession();
						$session->Set('UserDetails', $new_user);
						$session->Set('PurchaseDetails', $purchasedetail);
						$GLOBALS['InvoiceHref'] = "index.php?Page=Credits&Action=PurchaseReceipt";
						$this->ParseTemplate("Credit_Thankyou");
					break;
						
					case 2:
						//declined

						$GLOBALS['ShowMessage'];
						$GLOBALS['Message'] = 'The purchase has been declined by our payment system.';
						$this->ParseTemplate("Credit_Declined");
					break;

					case 3:
						//error

						$GLOBALS['ShowMessage'];
						$GLOBALS['Message'] = $purchaseResult[1];
						$this->ParseTemplate("Credit_Declined");					
					break;
				}
			
			break;
			
			case 'purchasereceipt':
				$user = &GetUser();
				$session = &GetSession();
				$purchase_detail = $session->Get('PurchaseDetails');
				$GLOBALS['Firstname'] = $purchase_detail['Firstname'];
				$GLOBALS['Lastname'] = $purchase_detail['Lastname'];
				$GLOBALS['Address'] = $purchase_detail['Address'];
				$GLOBALS['City'] = $purchase_detail['City'];
				$GLOBALS['State'] = $purchase_detail['State'];
				$GLOBALS['Zip'] = $purchase_detail['Zip'];
				$GLOBALS['Companyname'] = $user->companyname;
				$GLOBALS['Price'] = $purchase_detail['Price'];
				$GLOBALS['Credits'] = $purchase_detail['Credits'];
				$GLOBALS['InvoiceDate'] = date('M d, Y');
				$GLOBALS['CardType'] = $purchase_detail['cctype'];			
				echo $this->ParseTemplate("Credit_Receipt");
				exit();
			break;
			
			default:
				$this->DisplayHistory();			
			break;
		}
		$this->PrintFooter();
	}
	
	function DisplayHistory()
	{
		$perpage = $this->GetPerPage();

		$DisplayPage = $this->GetCurrentPage();
		$start = ($DisplayPage - 1) * $perpage;
		$this->SetupPaging($NumberOfLists, $DisplayPage, $perpage);
		$GLOBALS['FormAction'] = 'Action=ProcessPaging';
		$paging = $this->ParseTemplate('Paging', true, false);

		$sortinfo = $this->GetSortDetails();
		$user = &GetUser();	
		
		$userid = isset($_REQUEST['userid']) ? $_REQUEST['userid'] : 0;
		if($user->admintype != 'a' && $user->admintype != 'b')
		{
			$userid = $user->userid;
			$GLOBALS['ShowUserSelector'] = 'none';
		}
		require_once 'api/credits.php';
		$creditapi = new Credit_API();
		$creditHistory = $creditapi->GetCreditHistory($userid);
		
		$historyuser = new User_API($userid);
		
		$userList = $historyuser->GetClientList($userid);
		$userOptions = '<option value="0">All Users</option>' . $userList;
		/*foreach($userList as $option)
		{
			if($option['admintype'] != 'a' && $option['admintype'] != 'b' )
			{
				$selected = $userid == $option['userid'] ? ' selected ':'';
				$userOptions .= '<option value="'.$option['userid'].'" '.$selected.'>'.$option['companyname'].'('.$option['fullname'].')</option>';
			}
		}*/
		$GLOBALS['UserList'] = $userOptions;
		
		if($userid > 0){
			$GLOBALS['UserAccount'] = $historyuser->companyname.'('.$historyuser->fullname.')';
		}else{
			$GLOBALS['UserAccount'] = 'All Users';
		}
		
		if ($user->Get('permonth') > 0)
		{
			$GLOBALS['ShowCreditPurchaseTab'] = 'none';
		}
		
		$template = $this->ParseTemplate("Credit_List",true,false);
		$rowdetails = '';
		
		foreach($creditHistory as $creditRow)
		{
			$GLOBALS['CompanyName'] = $creditRow['companyname'];
			$GLOBALS['UserName'] = $creditRow['fullname'];
			$GLOBALS['CreditChange'] = ((substr($creditRow['creditamount'],0,1) != '-') ? '+' : '') . $creditRow['creditamount'];
			$GLOBALS['CreditTotal'] = $creditRow['current_total'];
			$GLOBALS['Date'] = date('m/d/Y g:i a', strtotime($creditRow['entrydate']));
			$GLOBALS['Notes'] = $creditRow['note'];
			
			$rowdetails .= $this->ParseTemplate("Credit_List_Row",true,false);
		}
		
		$template = str_replace('%%TPL_Credit_Row%%', $rowdetails, $template);
		$template = str_replace('%%TPL_Paging%%', $paging, $template);
		$template = str_replace('%%TPL_Paging_Bottom%%', $GLOBALS['PagingBottom'], $template);
		
		echo $template;
	}
	
}

?>
