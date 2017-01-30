<?php
class User extends AppModel {
	const PASSWORD_MINIMAL_LENGTH = 8;

	public $belongsTo = array('Group');

	public $actsAs = array('Acl' => array('requester'));

/**
 * Parent Node
 *
 * @return array
 * @throws Exception
 */
	function parentNode() {
		if (isset($this->data['User']['group_id'])) {
			return array('Group' => array('id' => $this->data['User']['group_id']));
		}
		if (isset($this->data['User']['id'])) {
			$this->id = $this->data['User']['id'];
		}
		
		if (!$this->id) {
			throw new Exception('Insufficient data to determine parentNode');
		}
		$data = $this->find('first', array('conditions' => array('User.id' => $this->id, 'User.deleted' => array(0, 1))));
		return array('Group' => array('id' => $data['User']['group_id']));
	}

/**
 * Summary
 *
 * @param array $variables Variables
 *
 * @return array|bool
 */
	function summary(array $variables) {
		$return = false;
		
		if (isset($variables['User.id'])) {
			$result = $this->find('first', array('conditions'=>array('User.id'=>$variables['User.id'])));
			
			$display_name = trim($result['User']['first_name'].' '.$result['User']['last_name']);
			$display_name = $display_name ? $display_name : $result['User']['username'];
			
			$return = array(
				'menu'			=>	array( NULL, $display_name ),
				'title'			=>	array( NULL, $display_name ),
				'data'			=> $result,
				'structure alias' => 'users'
			);
		}
		
		return $return;
	}

/**
 * Get a list of users
 *
 * @return array
 */
	function getUsersList() {
		$all_users_data = $this->find('all', array('recursive' => '-1'));
		$result = array();
		foreach ($all_users_data as $data) {
			$result[$data['User']['id']] = $data['User']['first_name'] . ' ' . $data['User']['last_name'];
		}
		return $result;
	}
	
/**
 * Save Password
 *
 * @param array $data Form Data
 * @param bool $modified_by_user
 *
 * @return True|False if save failed
 */
	function savePassword(array $data, $modified_by_user = true) {
		assert($this->id);
		if ($this->validatePassword($data)) {
			$this->read();
			$data_to_save = array(
				'User' => array(
					'group_id' => $this->data['User']['group_id'],
					'password' => Security::hash($data['User']['new_password'], null, true),
					'password_modified' => date("Y-m-d H:i:s")			
				)
			);
			if(array_key_exists('force_password_reset', $data['User'])) $data_to_save['User']['force_password_reset'] = $data['User']['force_password_reset'];
			if($modified_by_user) $data_to_save['User']['force_password_reset'] = '0';
			
			$this->data = null;
			$this->check_writable_fields = false;
			if ($this->save($data_to_save)) {
				return true;
			}
		}
		return false;
	}

/**
 * Will throw a flash message if the password is not valid
 *
 * @param array $data Form data
 * @param string|null $created_user_name user_name of a created user
 *
 * @return bool true if validation passes
 */
	function validatePassword(array $data, $created_user_name = null){
		$validation_errors = array();
		
		if (!isset($data['User']['new_password'], $data['User']['confirm_password']) || (!$this->id && !$created_user_name)) {
			//Missing fields
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$db_user_data = $this->id? $this->find('first', array('conditions' =>array('User.id' => $this->id))) : null;
		
		if ($data['User']['new_password'] !== $data['User']['confirm_password']) {
			$validation_errors['confirm_password'][] = 'passwords do not match'; 
		}
		
		if($created_user_name && $created_user_name === $data['User']['new_password']) {
			$validation_errors['password'][] = 'password should be different than username';
		}
		if($db_user_data) {
			if($db_user_data['User']['username'] === $data['User']['new_password']) {
				$validation_errors['password'][] = 'password should be different than username';
			}
			if($db_user_data['User']['password'] === Security::hash($data['User']['new_password'], null, true)) {
				$validation_errors['password'][] = 'password should be different than the previous one';
			} else {
			
				$different_passwords_number = (int)Configure::read('different_passwords_number_before_re_use');
				if (!preg_match('/^[0-5]$/', $different_passwords_number)) {
					$different_passwords_number =  5;
				}
				if($different_passwords_number) {
					$previous_passwords = $this->tryCatchQuery("SELECT password FROM users_revs WHERE id = ".$this->id." ORDER BY version_id DESC LIMIT 1, $different_passwords_number");	// Take last revs record equals current record in consideration
					foreach($previous_passwords as $previous_password){
						if($previous_password['users_revs']['password'] == Security::hash($data['User']['new_password'], null, true)) {
							$validation_errors['password'][] = __('password should be different than the %s previous one', ($different_passwords_number+1));
						}
					}
				}
			}
		}
		
		$password_security_level = (int)Configure::read('password_security_level');
		if (!preg_match('/^[0-4]$/', $password_security_level)) {
			$password_security_level =  4;
		}
		$password_format_error = false;
		switch($password_security_level) {
			case 4:
				if (!preg_match('/\W+/', $data['User']['new_password'])) $password_format_error = true;
			case 3:
				if (!preg_match('/[A-Z]+/', $data['User']['new_password'])) $password_format_error = true;
			case 2:
				if (!preg_match('/[1-9]+/', $data['User']['new_password'])) $password_format_error = true;
			case 1:
				if (strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH) $password_format_error = true;
				if (!preg_match('/[a-z]+/', $data['User']['new_password'])) $password_format_error = true;
			case 0:
			default:
		}
		if ($password_format_error) $validation_errors['password'][] = 'password_format_error_msg_'.$password_security_level;
		
		$this->validationErrors = array_merge($this->validationErrors, $validation_errors);
		return empty($validation_errors);
	}

/**
 * Checks if a user failed at login too often from the same IP adress (Takes only IP address into account).
 *
 * @return bool True if the IP adress is still defiend as disabled|False if not.
 * @throws CakeException when you try to construct an interface or abstract class.
 */
	function shouldLoginFromIpBeDisabledAfterFailedAttempts() {
		// Test last login results from IP address
		$max_login_attempts_from_IP = Configure::read('max_login_attempts_from_IP');
		if(!$max_login_attempts_from_IP) return false;
		$time_in_minutes_before_ip_is_reactivated = Configure::read('time_mn_IP_disabled');
	
		$model_UserLoginAttempt = ClassRegistry::init('UserLoginAttempt');
		$last_successful_login_time = $model_UserLoginAttempt->field('attempt_time', array(
			'UserLoginAttempt.ip_addr' => AppModel::getRemoteIPAddress(),
			'UserLoginAttempt.succeed' => true
		), array('UserLoginAttempt.id DESC'));
	
		// Set default in case user has never logged in before
		if (!$last_successful_login_time) {
			$last_successful_login_time = date('Y-m-d');	//Removed 'H:i:s' in case there is a server client time discrepency
		}
	
		$failed_login_attempts_from_ip = $model_UserLoginAttempt->find('all', array(
			'conditions' => array(
				'UserLoginAttempt.ip_addr' => AppModel::getRemoteIPAddress(),
				'UserLoginAttempt.succeed' => false,
				'UserLoginAttempt.attempt_time >' => $last_successful_login_time
			),
			'fields' => 'UserLoginAttempt.attempt_time',
			'order' => array('UserLoginAttempt.id DESC'),
			'limit' => $max_login_attempts_from_IP
		));
		
		if (count($failed_login_attempts_from_ip) >= $max_login_attempts_from_IP) {
			$last_attempt_time = $failed_login_attempts_from_ip[0]['UserLoginAttempt']['attempt_time'];
			$start_date = new DateTime($last_attempt_time);
			$end_date = new DateTime(date("Y-m-d H:i:s"));
			$interval = $start_date->diff($end_date);
			
			if ($interval->y || $interval->m || $interval->d) {
				return false;
			}
			
			if (($interval->h * 60 + $interval->i) < $time_in_minutes_before_ip_is_reactivated) {
				return true;
			}
		}
		
		return false;
	}
	
/**
 * Check if a user failed at login too often with the same user account and disable user account
 * if check succeed.
 *
 * @param string $user_name User account used by the user to login.
 *
 * @return bool True if function disabled user|False if not.
 * @throws CakeException when you try to construct an interface or abstract class.
 */
	function disableUserAfterTooManyFailedAttempts($user_name) {
		// Test last user login results
		$max_user_login_attempts = Configure::read('max_user_login_attempts');
		if(!$max_user_login_attempts) return false;
		
		$user_data = $this->find('first', array('conditions' =>array('User.username' => $user_name, 'User.flag_active' => '1'), 'recursive' => '-1'));
		if(!$user_data) return false;
	
		$model_UserLoginAttempt = ClassRegistry::init('UserLoginAttempt');
		$last_successful_login_time = $model_UserLoginAttempt->field('attempt_time', array(
			'UserLoginAttempt.username' => $user_name,
			'UserLoginAttempt.succeed' => true
		), array('UserLoginAttempt.id DESC'));
	
		// Set default in case user has never logged in before
		if (!$last_successful_login_time) {
			$last_successful_login_time = date('Y-m-d H:i:s');
		}
	
		$failed_user_login_attempts = $model_UserLoginAttempt->find('count', array(
			'conditions' => array(
				'UserLoginAttempt.username' => $user_name,
				'UserLoginAttempt.succeed' => false,
				'UserLoginAttempt.attempt_time >' => $last_successful_login_time
			),
			'order' => array('UserLoginAttempt.id DESC'),
			'limit' => $max_user_login_attempts
		));
	
		if ($failed_user_login_attempts && $failed_user_login_attempts >= $max_user_login_attempts) {
			$this->disableUser($user_data['User']['id']);
			return true;
		}
	
		return false;
	}
	
/**
 * Disable a User
 *
 * @param int $id UserId
 *
 * @return void
 */
	public function disableUser($id) {
		$this->check_writable_fields = false;
		$this->data = array();
		$this->id = $id;
		$this->save(array('User' => array('flag_active' => false)));
	}

/**
 * Error if IE below a version passed in args
 *
 * @param integer $version Version of internet explorer
 *
 * @return void
 */
	function showErrorIfInternetExplorerIsBelowVersion($version) {
		$matches = array();
		if (preg_match('/MSIE ([\d]+)/', $_SERVER['HTTP_USER_AGENT'], $matches)) {
			if ($matches[1] < $version) {
				$this->validationErrors[] = __('bad internet explorer version msg');
			}
		}
	}

/**
 * Checks if Password Reset is required
 *
 * @return bool
 */
	function isPasswordResetRequired() {
		//Check administartor forced user to reset the password
		
		if(AuthComponent::user('force_password_reset')) {
			return true;
		}
		
		//Check password validity
		
		$last_time_password_was_modified = AuthComponent::user('password_modified');
		$password_validity_period_month = Configure::read('password_validity_period_month');
		
		if($password_validity_period_month) {
			if (!$last_time_password_was_modified) {
				return true;
			} else {
				$start_date = new DateTime($last_time_password_was_modified);
				$end_date = new DateTime(date("Y-m-d H:i:s"));
				$interval = $start_date->diff($end_date);
				if (($interval->y * 12 + $interval->m) >= $password_validity_period_month) {
					return true;
				}
			}
		}
		
		return false;
	}
	
/**
 * Return the list of all fields of the 'users' database table used to record both personal questions and answers 
 * used by the 'Forgotten Password Rest' process.
 *
 * @return array Table fields (key=[question field]/value=[answer field]) 
 */
	function getForgottenPasswordResetFormFields() {
		$form_fields = array();
		for($question_id = 1; $question_id < 4; $question_id++) {
			$form_fields['forgotten_password_reset_question_'.$question_id] = 'forgotten_password_reset_answer_'.$question_id;
		}
		return $form_fields;
	}
	
/**
 * Return the encrypted answer to the questions used by the 'Forgotten Password Rest' process to be recorded into database.
 *
 * @return string encrypted answer
 */	
	function hashSecuritAsnwer($answer) {
		return Security::hash(strtolower(trim($answer)), null, true);
	}
}