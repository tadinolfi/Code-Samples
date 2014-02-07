<?php

require_once(dirname(__FILE__) . '/smartmta_functions.php');

/* *
 * Permissions:
 *     UnKnown
 *     
 * */

class Ipauthentication extends SmartMTA_Functions {

    private $SearchFilter = '';
    private $DisplayPage = 1;

    public function Process() {
        $user = &GetUser();
        $session = &GetSession();
        $action = isset($_GET['Action']) ? strtolower($_GET['Action']) : '';
        $this->SearchFilter = isset($_GET['SearchFilter']) ? strtolower($_GET['SearchFilter']) : '';

        //check for ajax
        if (!(isset($_GET['ajax']) && $_GET['ajax'] == '1'))
            $this->PrintHeader();

        switch ($action) {
            case 'add':
                if (isset($_POST['ipaddress'])) {
                    $this->Add();
                } else {
                    $this->Message('error', 'Missing Ip');
                }
                break;
            case 'delete':
                if (isset($_GET['id'])) {
                    $this->Delete();
                } else {
                    $this->Message('error', 'Missing id');
                }
                break;
            case 'activate':
                if (isset($_GET['id'])) {
                    $this->Activate();
                } else {
                    $this->Message('error', 'Missing id');
                }
                break;
            case 'deactivate':
                if (isset($_GET['id'])) {
                    $this->Deactivate();
                } else {
                    $this->Message('error', 'Missing id');
                }
                break;
            default:
                //TODO: check if they didnt create a support ticket
                $this->Manage();
                break;
        }
        //check for ajax
        if (!(isset($_GET['ajax']) && $_GET['ajax'] == '1'))
            $this->PrintFooter();
    }

    public function Add() {
        $user = &GetUser();
        $ip = $this->GetApi('ipauthentication');

        if (isset($_POST['ipaddress'])) {
            $ipaddress = $_POST['ipaddress'];
            if ($ip->ValidateIp($ipaddress) == true) {
                $exists = $ip->CheckIfIpExists($user->userid, $ipaddress);
                if ($exists == false) {
                    if ($ip->AddAuthenticatedIpToUser($user->userid, $ipaddress) == true) {
                        $this->Message('success', 'IP address successfully added. Please allow 10 minutes for changes to take effect.');
                    } else {
                        $this->Message('error', 'IP address was not added. Please try again, or contact support for further assistance.');
                    }
                } elseif ($exists == 'conflict_inside') {
                    $this->Message('error', 'IP address already exist for this company');
                } elseif ($exists == 'conflict_outside') {
                    $this->Message('error', 'IP address already exists within system. Please contact support.');
                }
            } else {
                $this->Message('error', 'IP address is invalid');
            }
        } else {
            $this->Message('error', 'No IP address entered');
        }
        $this->Redirect();
    }

    public function Delete() {
        $user = &GetUser();
        $ip = $this->GetApi('ipauthentication');

        if (isset($_GET['id'])) {
            $id = $_GET['id'];
            if ($ip->CheckIfIpExistsForUserById($user->userid, $id) == true) {
                if ($ip->RemoveIpFromUserbyId($user->userid, $id) == true) {
                    $this->Message('success', 'IP address successfully removed. Please allow 10 minutes for changes to take effect.');
                } else {
                    $this->Message('error', 'IP address was not removed. Please try again.');
                }
            } else {
                $this->Message('error', 'Do Not Try To Spoof Our URLs');
            }
        } else {
            $this->Message('error', 'IP address not entered');
        }
        $this->Redirect();
    }

    public function Manage() {
        $user = &GetUser();
        $ip = $this->GetApi('ipauthentication');

        $iparray = array();
        $sortinfo = $this->GetSortDetails();
        
        $this->DisplayPage = $this->GetCurrentPage();
        $perpage = $this->GetPerPage();
        $start = 0;
        if ($perpage != 'all') {
            $perpage = 25;
            $start = ($this->DisplayPage - 1) * $perpage;
        }

        $ip_count = $ip->GetArrayOfIpsForUser($user->userid, array(), true, $start, 'all', array(), $this->SearchFilter);
        $this->SetupPaging($ip_count, $this->DisplayPage, $perpage, '&SearchFilter=' . $this->SearchFilter);
        $sortinfo = $this->GetSortDetails();
        $iparray = $ip->GetArrayOfIpsForUser($user->userid, array(), false, $start, $perpage, $sortinfo, $this->SearchFilter);

        if (in_array('false', $iparray)) {
            $this->Message('error', 'An error has occurred. Please reload the page, or contact Support for further assistance.');
        } else {
            $this->tpl->Assign('Ips', $iparray);
        }
        $this->tpl->ParseTemplate('ipauthentication_manage');
    }

    public function Activate() {
        $user = &GetUser();
        $ip = $this->GetApi('ipauthentication');
        $id = $_GET['id'];

        if ($ip->CheckIfIpExistsForUserById($user->userid, $id) == true) {
            if ($ip->ActivateIpForUserById($user->userid, $id) == true) {
                $this->Message('success', 'IP address successfully activated');
            } else {
                $this->Message('error', 'IP address was not deactivated. Please try again, or contact support for further assistance.');
            }
        } else {
            $this->Message('error', 'Do Not Try To Spoof Our URLs');
        }

        $this->Redirect();
    }

    public function Deactivate() {
        $user = &GetUser();
        $ip = $this->GetApi('ipauthentication');
        $id = $_GET['id'];

        if ($ip->CheckIfIpExistsForUserById($user->userid, $id) == true) {
            if ($ip->DeactivateIpForUserById($user->userid, $id) == true) {
                $this->Message('success', 'IP address successfully deactivated');
            } else {
                $this->Message('error', 'IP address was not activated. Please try again, or contact support for further assistance.');
            }
        } else {
            $this->Message('error', 'Do Not Try To Spoof Our URLs');
        }

        $this->Redirect();
    }

}