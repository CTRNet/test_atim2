<?php
App::uses('AppModel', 'Model');

class UserLoginAttempt extends AppModel {

	public $checkWritableFields = false;

/**
 * Save successful Login
 *
 * @param string $username Username
 * @return mixed On success Model::$data if its not empty or true, false on failure
 */
	public function saveSuccessfulLogin($username) {
		$loginData = array(
			"username" => $username,
			"ip_addr" => $_SERVER['REMOTE_ADDR'],
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
	public function saveFailedLogin($username) {
		$loginData = array(
			"username" => $username,
			"ip_addr" => $_SERVER['REMOTE_ADDR'],
			"succeed" => false,
			"http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
			"attempt_time" => date("Y-m-d H:i:s")
		);
		return $this->save($loginData);
	}
}
