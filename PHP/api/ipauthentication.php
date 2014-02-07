<?php

require_once(dirname(__FILE__) . '/api.php');

/**
 * Ip Authentication Data Access Class
 * 
 * This class creates and returns Ip Authenticaiton data.
 * 
 * @package DataAccessLayer
 */
class IpAuthentication_API extends API {

    public function __construct() {
        $this->GetDb();
    }

    /**
     * Add Ip Address to User if the Ip Address
     * 
     * @param int $userid The ID of the user to add authenticated ip address to.
     * @param string $ipaddress
     * 
     * @return bool If true the Ip was added.
     */
    public function AddAuthenticatedIpToUser($userid, $ipaddress) {
        $this->GetDb();
        $query = "INSERT INTO ".DATABASE_NAME.".ip_authentication ( userid, ipaddress, active ) VALUES ('";
        $query .= $this->Db->Quote($userid) . "','" . $this->Db->Quote($ipaddress) . "', 1 )";
        $result = $this->Db->Query($query);

        if ($result)
            return true;
        return false;
    }

    /**
     * Check For existing Ip Address of user so we dont duplicate, function used for adding
     * 
     * @param int $userid The ID of the user to check against 
     * @param string $ipaddress Ip of Ip to check
     * 
     * @return string, 'conflict_inside' if the problem within a company or 'conflict_outside' if the problem is between companys. 
     */
    public function CheckIfIpExists($userid, $ipaddress) {
        $this->GetDb();
        $query = "SELECT userid FROM ".DATABASE_NAME.".ip_authentication WHERE ipaddress='" . $this->Db->Quote($ipaddress) . "'";
        $result = $this->Db->Query($query);
        if (!$result) {
            return false;
        } 
        
        if ( $this->Db->NumAffected($result) < 1 ) {
            return false;
        }
        
        $result = $this->Db->Fetch($result);
        $userapi = $this->GetApi('user');
        $masteratt = $userapi->GetMasterIdByUserId($userid);
        $masterown = $userapi->GetMasterIdByUserId($result['userid']);
        
        if ($masteratt == $masterown) {
            return 'conflict_inside';
        }
        $this->EmailIpError($userid, $result['userid'], $ipaddress);
        return 'conflict_outside';
    }

    /**
     * Remove an ip from a user.
     * 
     * @param int $userid The ID of the user to remove the Ip from.
     * @param string $id
     * 
     * @return bool If true the ip was removed.
     */
    public function RemoveIpFromUserById($userid, $id) {
        $this->GetDb();
        $query = "DELETE FROM ".DATABASE_NAME.".ip_authentication WHERE userid=" . $this->Db->Quote($userid) . " AND id='" . $this->Db->Quote($id) . "'";
        $result = $this->Db->Query($query);

        if (!$result)
            return false;
        return true;
    }

    /**
     * Remove a role from a user.
     * 
     * @param int $userid The ID of the user to remove the role from.
     * 
     * @return array of all ip address for User or false if query fails.
     */
    public function GetArrayOfIpsForUser($userid, $calendar_restrictions = array(), $count_only=false, $start=0, $perpage='25', $sortinfo=array(), $searchFilter='') {
        $this->GetDb();
        $ips = array();

        if($count_only)
			$query = "SELECT COUNT(*) count";
		else
			$query = "SELECT *";
        
        $query .= " FROM ".DATABASE_NAME.".ip_authentication WHERE userid=" . $this->Db->Quote($userid);

        $filterValue = $this->Db->Quote($searchFilter);
        if ($searchFilter != '')
            $query .= " AND ipaddress LIKE '%" . $filterValue . "%'";

        $validsorts = array('ip' => 'ipaddress');
        $order = (isset($sortinfo['SortBy']) && !is_null($sortinfo['SortBy'])) ? strtolower($sortinfo['SortBy']) : 'ipaddress';
        $order = (in_array($order, array_keys($validsorts))) ? $validsorts[$order] : 'ipaddress';
        $direction = (isset($sortinfo['Direction']) && !is_null($sortinfo['Direction'])) ? $sortinfo['Direction'] : 'ASC';
        $direction = (strtolower($direction) == 'up' || strtolower($direction) == 'asc') ? 'ASC' : 'DESC';
        $query .= " ORDER BY " . $order . " " . $direction;

        if ($perpage != 'all' && ($start || $perpage))
            $query .= $this->Db->AddLimit($start, $perpage);
        
        $result = $this->Db->Query($query);

        if (!$result) {
            $ips[] = 'false';
        } else {
            if ($count_only) {
                $row = $this->Db->Fetch($result);
                return $row['count'];
            } else {
                while ($row = $this->Db->Fetch($result))
                array_push($ips, $row);
            }
        }
        
        return $ips;
    }

    /**
     * Get all the roles a user has.
     * 
     * @param int $userid The ID of the user to remove the role from.
     * @param int $roleid The ID of the role to remove.
     * 
     * @return bool|array If fales the call failed. Otherwise it returns arrays of data rows.
     */
    public function ValidateIp($ipaddress) {
        if ($ipaddress == '127.0.0.1')
            return false;
        if (!filter_var($ipaddress, FILTER_VALIDATE_IP, FILTER_FLAG_NO_RES_RANGE))
                return false;
        if (!filter_var($ipaddress, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE))
                return false;
        return true;
    }

    /**
     * Check For existing Ip Address of user so we dont duplicate, Function is used in functions involving action on existing data.
     * 
     * @param int $userid The ID of the user to check against 
     * @param string $id
     * 
     * @return bool If true Ip exists.
     */
    public function CheckIfIpExistsForUserById($userid, $id) {
        $this->GetDb();
        $query = "SELECT (id) FROM ".DATABASE_NAME.".ip_authentication WHERE userid=" . $this->Db->Quote($userid) . " AND id='" . $this->Db->Quote($id) . "'";
        $result = $this->Db->Query($query);

        if (!$result) {
            return false;
        }
        if ( $this->Db->NumAffected($result) < 1 ) {
            return false;
        }
        return true;
    }

    /**
     * Deactivate existing Ip Address of user
     * 
     * @param int $userid The ID of the user to check against 
     * @param string $id
     * 
     * @return bool If true Ip exists.
     */
    public function DeactivateIpForUserById($userid, $id) {
        $this->GetDb();
        $query = "UPDATE ".DATABASE_NAME.".ip_authentication SET active=0 WHERE id= " . $this->Db->Quote($id) . " AND userid=" . $this->Db->Quote($userid);
        $result = $this->Db->Query($query);

        if (!$result)
            return false;
        return true;
    }

    /**
     * Activate existing Ip Address of user
     * 
     * @param int $userid The ID of the user to check against 
     * @param string $id
     * 
     * @return bool If true Ip exists.
     */
    public function ActivateIpForUserById($userid, $id) {
        $this->GetDb();
        $query = "UPDATE ".DATABASE_NAME.".ip_authentication SET active=1 WHERE id= " . $this->Db->Quote($id) . " AND userid=" . $this->Db->Quote($userid);
        $result = $this->Db->Query($query);

        if (!$result)
            return false;
        return true;
    }

    /**
     * Activate existing Ip Address of user
     * 
     * @param int $userid The ID of the user to check against 
     * @param string $id
     * 
     * @return bool If true Ip exists.
     */
    public function EmailIpError($useratt, $userown, $ipaddress) {
        $userapi = $this->GetApi('user');
        $masteratt = $userapi->GetMasterIdByUserId($useratt);
        $masterown = $userapi->GetMasterIdByUserId($userown);
        $usermastown = $userapi->GetMasterUserId($masterown);
        $usermastatt = $userapi->GetMasterUserId($masteratt);
        $userapi->Load($usermastatt);
        $body = "A user under the master account: " . $userapi->companyname . "(" . $userapi->username . ") attempted to add the ip address: " . $ipaddress;
        $userapi->Load($usermastown);
        $body .= " on DynECT Email Delivery. This ip address is currently in is use by master account: " . $userapi->companyname . "(" . $userapi->username . ")";
        $userapi->Load($usermastatt);
        $body .= "\n\n" . $userapi->companyname . "'s info\n---------------------------------\n";
        $userapi->Load($useratt);
        $body.= $userapi->companyname . "\n" . $userapi->username . "\n" . $userapi->phone;
        $userapi->Load($usermastown);
        $body .= "\n\n" . $userapi->companyname . "'s info\n---------------------------------\n";
        $userapi->Load($userown);
        $body.= $userapi->companyname . "\n" . $userapi->username . "\n" . $userapi->phone;

        $configapi = $this->GetApi('config');
        $to = $configapi->GetConfigField('ConciergeEmail', $section = 'ipauthentication');

        $this->SendEmail($to, 'Ip Authentication Conflict On DynECT Email Delivery', $body);

        return;
    }

    /**
     * Return Username of given ip
     * 
     * @param string $ip
     * 
     * @return username|bool. return false is it does not exist.
     */
    public function GetUsernameByIp($ipaddress) {
        $this->GetDb();
        $query = " SELECT u.username as user FROM ".DATABASE_NAME.".ip_authentication ip INNER JOIN ".DATABASE_NAME.".users u ON ip.userid=u.id WHERE ip.ipaddress='" . $this->Db->Quote($ipaddress) . "'";
        $result = $this->Db->Query($query);
        if (!$result)
            return false;
        if ( $this->Db->NumAffected($result) < 1 ) {
            return false;
        }
        $result = $this->Db->Fetch($result);
        return $result['user'];
    }

    /**
     * Return id of given ip
     * 
     * @param string $userid
     * @param string $ipaddress
     * 
     * @return id|bool. return false is it does not exist.
     */
    public function GetIdOfIpByUserId($userid, $ipaddress) {

        if ($this->CheckIfIpExists($userid, $ipaddress) == false)
            return false;
        $this->GetDb();
        $query = "SELECT id from ".DATABASE_NAME.".ip_authentication WHERE ipaddress='" . $this->Db->Quote($ipaddress);
        $query .= "' and userid=" . $this->Db->Quote($userid);
        $result = $this->Db->Query($query);
        $result = $this->Db->Fetch($result);
        return $result['id'];
    }

}