<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class UserLoginAttempt
 */
class UserLoginAttempt extends AppModel
{

    public $checkWritableFields = false;

    /**
     * Save successful Login
     *
     * @param string $username Username
     * @return mixed On success Model::$data if its not empty or true, false on failure
     */
    public function saveSuccessfulLogin($username)
    {
        $loginData = array(
            "username" => $username,
            "ip_addr" => AppModel::getRemoteIPAddress(),
            "succeed" => true,
            "http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
            "attempt_time" => date("Y-m-d H:i:s")
        );
        return $this->save($loginData);
    }

    /**
     * Save failed Login
     *
     * @param string $username Username
     * @return mixed On success Model::$data if its not empty or true, false on failure
     */
    public function saveFailedLogin($username)
    {
        $loginData = array(
            "username" => $username,
            "ip_addr" => AppModel::getRemoteIPAddress(),
            "succeed" => false,
            "http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
            "attempt_time" => date("Y-m-d H:i:s")
        );
        return $this->save($loginData);
    }
}