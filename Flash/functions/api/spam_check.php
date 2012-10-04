<?php

/**
* Include the base API class if we haven't already.
*/
require_once(dirname(__FILE__) . '/api.php');

/**
* Class for checking the spam rating of an email campaign.
*/

class Spam_Check_API extends API {

	/**
	* ruletypes
	* These are the types of rules according t
	*/
	var $ruletypes = array();
	/**
	* TotalSpamRating
	* Accumulated Spam rating to determine result
	*
	* It stores the rating per rule type (eg spamassassin)
	*
	* @var Array
	*/
	var $TotalSpamRating = Array();

	/**
	* SpamFilterLimit
	* The maximum spam count you can accumulate before we flag the message as spam
	*
	* @var Int
	*/
	var $SpamFilterLimit = 5;

	/**
	* SpamFilterLimit
	* The maximum spam count you can accumulate before we flag the message as spam
	*
	* @var Int
	*/

	var $Spam_Rating = array(
		'notspam' => 3,
		'alert' => 4,
		'spam' => 5
	);


	/**
	* BrokenRules
	* This is a multi dimensional array that stores the rules that you have broken so that it can be displayed.
	*
	* @var Array
	*/
	var $BrokenRules = array();

	/**
	* Constructor
	*
	* @return Void
	*/
	function Spam_Check_API() {
		$spam_rule_files = list_files(SENDSTUDIO_RESOURCES_DIRECTORY . '/spam_rules');

		foreach ($spam_rule_files as $spam_rule) {
			$filename_parts = pathinfo($spam_rule);
			if (isset($filename_parts['extension']) && $filename_parts['extension'] == 'php') {
				require(SENDSTUDIO_RESOURCES_DIRECTORY . '/spam_rules/' . $spam_rule);
			}
		}

		$ruletypes = array_keys($GLOBALS['Spam_Rules']);

		$this->ruletypes = $ruletypes;
	}



	/**
	* Process
	* This will scan your emails content and use the reg expressions loaded to find and determine any rules that you have broken.
	* It keeps score so far and also remembers which rules you have broken so we can get a list of them
	*
	* @see TotalSpamRating
	* @see BrokenRules
	*
	* @return Void Doesn't return anything.
	*/
	function Process($emailText, $rule_category='', $ruleposition='body') {
		$arr = $GLOBALS['Spam_Rules'][$rule_category][$ruleposition];

		if (!isset($this->TotalSpamRating[$rule_category])) {
			$this->TotalSpamRating[$rule_category] = 0;
		}

		foreach ($arr as $rule){
			if (preg_match($rule[0], $emailText)) {
				$this->TotalSpamRating[$rule_category] += $rule[2];
				$this->BrokenRules[$rule_category][] = array($rule[1], $rule[2]);
			}
		}
	}

	/**
	* GetSpamRating
	* This will return the total points that you have accumulated according to a particular rule type.
	*
	* @return returns Int totalSpamRating.
	*/
	function GetSpamRating($ruletype){
		return $this->TotalSpamRating[$ruletype];
	}

	/**
	* GetBrokenRules
	* This will return an array of the broken rules
	*
	* @return returns Array BrokenRules.
	*/
	function GetBrokenRules(){
		return $this->BrokenRules;
	}

	/**
	* CheckSpamLimit
	* This returns the filter limit according to this api.
	* Everything is set to work off a scale of 1 to 5.
	*
	* @see Spam_Rating
	*
	* @return returns Int SpamFilterLimit.
	*/

	function CheckSpamLimit(){
		return $this->SpamFilterLimit;
	}

}

?>
