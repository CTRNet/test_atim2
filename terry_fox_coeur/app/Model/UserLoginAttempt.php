<?php
class UserLoginAttempt extends AppModel {
	
	public $check_writable_fields = false;
	
	/**
	 * Save successful Login
	 *
	 * @param string $username Username
	 * @return mixed On success Model::$data if its not empty or true, false on failure
	 */
	function saveSuccessfulLogin($username) {	
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
	function saveFailedLogin($username) {
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