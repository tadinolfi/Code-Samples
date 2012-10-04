<?php
 /**
 *  A class to handle sessions by using a mySQL database for session related data storage providing better
 *  security then the default session handler used by PHP.
 *
 *  To prevent session hijacking, don't forget to use the {@link regenerate_id} method whenever you do a
 *  privilege change in your application
 *
 *  <i>Before usage, make sure you use the session_data.sql file from the install_sql folder to set up the table
 *  used by the class</i>
 *
 *  After instantiating the class, use sessions as you would normally
 *
 *  This class is an adaptation of John Herren's code from the "Trick out your session handler" article
 *  ({@link http://devzone.zend.com/node/view/id/141}) and Chris Shiflett's code from Chapter 8, Shared Hosting - Pg 78-80,
 *  of his book - "Essential PHP Security" ({@link http://phpsecurity.org/code/ch08-2})
 *
 *  <i>Note that the class assumes that there is an active connection to a mySQL database and it does not attempt to create
 *  one. This is due to the fact that, usually, there is a config file that holds the database connection related
 *  information and another class, or function that handles database connection. If this is not how you do it, you can
 *  easily adapt the code by putting the database connection related code in the "open" method of the class.</i>
 *
 *  The code is approx 9Kb in size but still heavily documented so you can easily understand every aspect of it
 *
 *  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 2.5 License.
 *  To view a copy of this license, visit {@link http://creativecommons.org/licenses/by-nc-nd/2.5/} or send a letter to
 *  Creative Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105, USA.
 *
 *  For more resources visit {@link http://stefangabos.blogspot.com}
 *
 *  @author     Stefan Gabos <ix@nivelzero.ro>
 *  @version    1.0 (last revision: August 05, 2006)
 *  @copyright  (c) 2006 Stefan Gabos
 *  @package    dbSession
*/
 
error_reporting(E_ALL);
 
class dbSession
{
	
	var $Db = null;
	
	var $sessionLifetime = null;
	
	var $QueryLog = null;
 
    /**
     *  Constructor of class
     *
     *  @return void
     */
    function __construct()
    {
    	$this->GetDb(); 
        // get session lifetime
        $this->sessionLifetime = get_cfg_var("session.gc_maxlifetime");
        // register the new handler
        register_shutdown_function('session_write_close');
        
        //$this->QueryLog = TEMP_DIRECTORY . '/session_log.txt';
 
        // start the session
       
 
    }
 
    /**
     *  Regenerates the session id.
     *
     *  <b>Call this method whenever you do a privilege change!</b>
     *
     *  @return void
     */
    function regenerate_id()
    {
 
        // saves the old session's id
        $oldSessionID = session_id();
 
        // regenerates the id
        // this function will create a new session, with a new id and containing the data from the old session
        // but will not delete the old session
        session_regenerate_id();
 
        // because the session_regenerate_id() function does not delete the old session,
        // we have to delete it manually
        $this->destroy($oldSessionID);
 
    }
 
    /**
     *  Get the number of online users
     *
     *  This is not 100% accurate. It depends on how often the garbage collector is run
     *
     *  @return integer     approximate number of users curently online
     */
    function get_users_online()
    {
 
        // counts the rows from the database
        $result = $this->Db->Query("
            SELECT
                COUNT(session_id) as count
            FROM ss_sessions
        ");
 
        // return the number of found rows
        return $this->Db->FetchOne($result, "count");
 
    }
 
    /**
     *  Custom open() function
     *
     *  @access private
     */
    function open($save_path, $session_name)
    {
 
        return true;
 
    }
 
    /**
     *  Custom close() function
     *
     *  @access private
     */
    function close()
    {
        return true;
    }
 
    /**
     *  Custom read() function
     *
     *  @access private
     */
    function read($session_id)
    {
 
        // reads session data associated with the session id
        // but only if the HTTP_USER_AGENT is the same as the one who had previously written to this session
        // and if session has not expired
        $query = "SELECT session_data FROM ss_sessions WHERE
                session_id = '".$this->Db->Quote($session_id)."' AND
                session_expire > '".$this->Db->Quote(time())."'";
                
        $result = $this->Db->Query($query);
 
        // if anything was found
        if ($result) {
 
            // return found data
            // don't bother with the unserialization - PHP handles this automatically
           $row = $this->Db->FetchOne($result, "session_data");
           //$this->LogQuery("READ: " . $query . "\nRESULT:" . $row);
           
           return $row;
 
        }
 
        // if there was an error return an epmty string - this HAS to be an empty string
        return "";
 
    }
 
    /**
     *  Custom write() function
     *
     *  @access private
     */
    function write($session_id, $session_data)
    {
 
        // first checks if there is a session with this id
        $result = $this->Db->Query("
            SELECT
                *
            FROM
                ss_sessions
            WHERE
                session_id = '".$this->Db->Quote($session_id)."' FOR UPDATE
        ");
 
        // if there is
        if ($this->Db->CountResult($result) > 0) {
 
            // update the existing session's data
            // and set new expiry time
            $updatequery = "UPDATE
                    ss_sessions
                SET
                    session_data = '".$this->Db->Quote($session_data)."',
                    session_expire = '".$this->Db->Quote((time() + $this->sessionLifetime))."'
                WHERE
                    session_id = '".$this->Db->Quote($session_id)."'
            ";
            
            $result = $this->Db->Query($updatequery);
            
            //$this->LogQuery("Updated Session: " . $updatequery);
            
 
            // if anything happened
            if ($this->Db->NumAffected()) {
 
                // return true
                return true;
 
            }
 
        // if this session id is not in the database
        } else {
 
            // insert a new record
            $insertquery = "INSERT INTO
                    ss_sessions
                        (
                            session_id,
                            http_user_agent,
                            session_data,
                            session_expire
                        )
                    VALUES
                        (
                            '".$this->Db->Quote($session_id)."',
                            '".$this->Db->Quote($_SERVER["HTTP_USER_AGENT"])."',
                            '".$this->Db->Quote($session_data)."',
                            '".$this->Db->Quote((time() + $this->sessionLifetime))."'
                        )
            ";
            
            $result = $this->Db->Query($insertquery);
            
            //$this->LogQuery("Created New Session: " . $insertquery);
 
            // if anything happened
            if ($this->Db->NumAffected()) {
 
                // return an empty string
                return "";
 
            }
 
        }
 
        // if something went wrong, return false
        return false;
 
    }
 
    /**
     *  Custom destroy() function
     *
     *  @access private
     */
    function destroy($session_id)
    {
 
        // deletes the current session id from the database
        $result = $this->Db->Query("
            DELETE FROM
                ss_sessions
            WHERE
                session_id = '".$session_id."'
        ");
        
        //$this->LogQuery("DELETED Session");
 
        // if anything happened
        if ($this->Db->NumAffected()) {
 
            // return true
            return true;
 
        }
 
        // if something went wrong, return false
        return false;
 
    }
 
    /**
     *  Custom gc() function (garbage collector)
     *
     *  @access private
     */
    function gc($maxlifetime)
    {
 
        // it deletes expired sessions from database
        $result = $this->Db->Query("
            DELETE FROM
                ss_sessions
            WHERE
                session_expire < '".$this->Db->Quote((time() - $maxlifetime))."'
        ");
        
        //$this->LogQuery("GC");
 
    }
    
	function GetDb()
	{
		if (is_object($this->Db) && is_resource($this->Db->connection)) {
			return true;
		}

		if (is_null($this->Db) || !$this->Db->connection) {
			if(class_exists('IEM'))
			{
				$Db = IEM::getDatabase();
			} else {
			if (!defined('IEM_PATH')) {
				define('IEM_PATH', dirname(__FILE__) . '/../../../com');
			}
				require_once(dirname(__FILE__) . '/../../../includes/config.php');
				require_once(dirname(__FILE__) . '/../../../com/lib/IEM/DBFACTORY.class.php');
				require_once(dirname(__FILE__) . '/../../../com/lib/IEM.class.php');
				$Db = IEM::getDatabase();
			}
			$this->Db = &$Db;
		}

		if (!is_object($this->Db) || !is_resource($this->Db->connection)) {
			throw new Exception("Unable to connect to the database. Please make sure the database information specified in admin/includes/config.php are correct.");
		}
		return true;
	}
	
	/*function LogQuery($query='')
	{
		if (!$query) {
			return false;
		}

		if (!$this->QueryLog || $this->QueryLog === null) {
			return false;
		}

		if (!$fp = fopen($this->QueryLog, 'ab+')) {
			return false;
		}

		$backtrace = '';
		if (function_exists('debug_backtrace')) {
			$backtrace = debug_backtrace();
			$called_from = $backtrace[1];
			// if the called_from[file] entry is this particular file, we used FetchOne to do the query.
			// so we need to go back one more level.
			if ($called_from['file'] == __FILE__) {
				$called_from = $backtrace[2];
			}
			$backtrace = $called_from['file'] . ' (' . $called_from['line'] . ')';
		}
		$line = date('M d H:i:s') . "\t" . getmypid() . "\t" . $backtrace . "\t" . str_replace('`', '', preg_replace('%\s+%', ' ', $query)) . "\n";
		fputs($fp, $line, strlen($line));
		fclose($fp);
		return true;
	}*/
 
}
?>