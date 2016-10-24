<?php
App::uses('AppModel', 'Model');

class UserLoginAttempt extends AppModel {

	public $checkWritableFields = false;

/**
 * Save successful Login
 *
 * @param $username
 */
	public function saveSuccessfulLogin($username) {
		$loginData = array(
			"username" => $username,
			"ip_addr" => $_SERVER['REMOTE_ADDR'],
			"succeed" => true,
			"http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
			"attempt_time" => date("Y-m-d H:i:s")
		);
		$this->save($loginData);
	}

/**
 * Save failed Login
 *
 * @param $username
 */
	public function saveFailedLogin($username) {
		$loginData = array(
			"username" => $username,
			"ip_addr" => $_SERVER['REMOTE_ADDR'],
			"succeed" => false,
			"http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
			"attempt_time" => date("Y-m-d H:i:s")
		);
		$this->save($loginData);
	}
}
