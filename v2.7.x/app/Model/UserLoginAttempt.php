<?php
App::uses('AppModel', 'Model');

class UserLoginAttempt extends AppModel {
	public $check_writable_fields = false;

	public function saveSuccessfulLogin($username) {
      $login_data = array(
         "username" => $username,
         "ip_addr" => $_SERVER['REMOTE_ADDR'],
         "succeed" => TRUE,
         "http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
         "attempt_time" => now()
      );
      $this->save($login_data);
   }

	public function saveFailedLogin($username) {
      $login_data = array(
         "username" => $username,
         "ip_addr" => $_SERVER['REMOTE_ADDR'],
         "succeed" => FALSE,
         "http_user_agent" => $_SERVER['HTTP_USER_AGENT'],
         "attempt_time" => now()
      );
      $this->save($login_data);
   }
}
