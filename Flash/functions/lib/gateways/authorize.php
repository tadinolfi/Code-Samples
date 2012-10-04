
<?php

error_reporting(6143);
ini_set("display_errors","1");

class Payment_Gateway
{
	function MakePurchase($fname, $lname, $address, $city, $state, $zip, $cardnumber, $cvn, $exprdate, $price)
	{
		$DEBUGGING					= 1;				# Display additional information to track down problems
		$TESTING					= 1;				# Set the testing flag so that transactions are not live
		$ERROR_RETRIES				= 2;				# Number of transactions to post if soft errors occur
		
		$auth_net_login_id			= SENDSTUDIO_GATEWAY_ID;
		$auth_net_tran_key			= SENDSTUDIO_GATEWAY_KEY;

		$auth_net_url			= "https://secure.authorize.net/gateway/transact.dll";
		
		$authnet_values				= array
		(
			"x_login"				=> $auth_net_login_id,
			"x_version"				=> "3.1",
			"x_delim_char"			=> "|",
			"x_delim_data"			=> "TRUE",
			"x_url"					=> "FALSE",
			"x_type"				=> "AUTH_CAPTURE",
			"x_method"				=> "CC",
			"x_tran_key"			=> $auth_net_tran_key,
			"x_test_request"		=> "true",
			"x_relay_response"		=> "FALSE",
			"x_card_num"			=> $cardnumber,
			"x_exp_date"			=> $exprdate,
			"x_description"			=> "SendLabs Email Credits",
			"x_amount"				=> $price,
			"x_first_name"			=> $fname,
			"x_last_name"			=> $lname,
			"x_address"				=> $address,
			"x_city"				=> $city,
			"x_state"				=> $state,
			"x_zip"					=> $zip
		);
		
		$fields = "";
		foreach( $authnet_values as $key => $value ) $fields .= "$key=" . urlencode( $value ) . "&";	
		$ch = curl_init($auth_net_url) or dir("CURL INIT FALIED"); 
		curl_setopt($ch, CURLOPT_HEADER, 0); // set to 0 to eliminate header info from response
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); // Returns response data instead of TRUE(1)
		curl_setopt($ch, CURLOPT_POSTFIELDS, rtrim( $fields, "& " )); // use HTTP POST to send form data
		### curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE); // uncomment this line if you get no gateway response. ###
		$resp = curl_exec($ch) or die("EXEC FAILED"); //execute post and get results
		curl_close ($ch);

		$responseArgs = explode('|',$resp);

		$response = array($responseArgs[0],$responseArgs[3]);

		return $response;
	}
}

?>
