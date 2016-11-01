<?php
App::uses('AppModel', 'Model');

/**
 * Class User
 */
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
	public function parentNode() {
		if (isset($this->data['User']['group_id'])) {
			return array('Group' => array('id' => $this->data['User']['group_id']));
		}
		if (isset($this->data['User']['id'])) {
			$this->id = $this->data['User']['id'];
		}

		if (!$this->id) {
			throw new Exception('Insufficient data to determine parentNode');
		}

		$data = $this->find('first',
			array('conditions' => array('User.id' => $this->id, 'User.deleted' => array(0, 1))));
		return array('Group' => array('id' => $data['User']['group_id']));
	}

/**
 * Summary
 *
 * @param array $variables Variables
 *
 * @return array|bool
 */
	public function summary(array $variables) {
		$return = false;

		if (isset($variables['User.id'])) {
			$result = $this->find('first', array('conditions' => array('User.id' => $variables['User.id'])));

			$displayName = trim($result['User']['first_name'] . ' ' . $result['User']['last_name']);
			$displayName = $displayName ? $displayName : $result['User']['username'];

			$return = array(
				'menu' => array(null, $displayName),
				'title' => array(null, $displayName),
				'data' => $result,
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
	public function getUsersList() {
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
 * @param $error_flash_link
 * @param $success_flash_link
 * @param bool $modified_by_user
 *
 * @return void
 */
	public function savePassword(array $data, $error_flash_link, $success_flash_link, $modified_by_user = true) {
		assert($this->id);
		$this->validatePassword($data);

		if ($this->validationErrors) {
			AppController::getInstance()->flash(__($this->validationErrors['password'][0]), $error_flash_link);
		} else {
			$this->read();

			if ($modified_by_user) {
				$password_modified_time = date("Y-m-d H:i:s");
			} else {
				$password_modified_time = null;
			}

			//all good! save
			$data_to_save = array(
				'User' => array(
					'group_id' => $this->data['User']['group_id'],
					'password' => Security::hash($data['User']['new_password'], null, true),
					'password_modified' => $password_modified_time
				)
			);

			$this->data = null;
			$this->checkWritableFields = false;
			if ($this->save($data_to_save)) {
				AppController::getInstance()->atimFlash(__('your data has been updated'), $success_flash_link);
			}
		}
	}

/**
 * Will throw a flash message if the password is not valid
 *
 * @param array $data Form data
 * @param string|null $createdUserName username
 *
 * @return bool true if validation passes
 */
	public function validatePassword(array $data, $createdUserName = null) {
		if (!isset($data['User']['new_password'], $data['User']['confirm_password'])) {
			$this->validationErrors['password'][] = 'Please make sure all fields are filled';
			return false;
		}

		if ($data['User']['new_password'] !== $data['User']['confirm_password']) {
			$this->validationErrors['password'][] = 'passwords do not match';
			return false;
		}

		if ($createdUserName === $data['User']['new_password']) {
			$this->validationErrors['password'][] = 'password should be different than username';
		}

		if ($this->find('count', array(
			'conditions' => array(
				'User.id' => $this->id,
				'User.username' => $data['User']['new_password']
			)
		))
		) {
			$this->validationErrors['password'][] = 'password should be different than username';
		}

		if ($this->find('count', array(
			'conditions' => array(
				'User.id' => $this->id,
				'User.password' => Security::hash($data['User']['new_password'], null, true)
			)
		))
		) {
			$this->validationErrors['password'][] = 'password should be different than the previous one';
		}

		$passwordSecurityLevel = (int)Configure::read('password_security_level');
		if (!in_array($passwordSecurityLevel, array(0, 1, 2, 3, 4), true)) {
			$passwordSecurityLevel = 4;
		}

		$passwordFormatError = false;
		switch ($passwordSecurityLevel) {
			case 4:
				if (!preg_match('/\W+/', $data['User']['new_password'])) {
					$passwordFormatError = true;
				}
			case 3:
				if (!preg_match('/[A-Z]+/', $data['User']['new_password'])) {
					$passwordFormatError = true;
				}
			case 2:
				if (!preg_match('/[1-9]+/', $data['User']['new_password'])) {
					$passwordFormatError = true;
				}
			case 1:
				if (strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH) {
					$passwordFormatError = true;
				}
				if (!preg_match('/[a-z]+/', $data['User']['new_password'])) {
					$passwordFormatError = true;
				}
			case 0:
			default:
		}
		if ($passwordFormatError) {
			$this->validationErrors['password'][] = 'password_format_error_msg_' . $passwordSecurityLevel;
		}

		if (empty($this->validationErrors['password'])) {
			return true;
		}
		return false;
	}

/**
 * Checks if a user failed at login too often. Takes users IP address into account
 *
 * @return bool
 * @throws CakeException when you try to construct an interface or abstract class.
 */
	public function shouldLoginFromIpBeDisabledAfterFailedAttempts() {
		// Test last login results from IP address
		$max_login_attempts_from_IP = Configure::read('max_login_attempts_from_IP');
		$time_in_minutes_before_ip_is_reactivated = Configure::read('time_mn_IP_disabled');

		$model_UserLoginAttempt = ClassRegistry::init('UserLoginAttempt');
		$last_successful_login_time = $model_UserLoginAttempt->field('attempt_time', array(
			'UserLoginAttempt.ip_addr' => $_SERVER['REMOTE_ADDR'],
			'UserLoginAttempt.succeed' => true
		), array('UserLoginAttempt.id DESC'));

		// Set default in case user has never logged in before
		if (!$last_successful_login_time) {
			$last_successful_login_time = date('Y-m-d H:i:s');
		}

		$failed_login_attempts_from_ip = $model_UserLoginAttempt->find('all', array(
			'conditions' => array(
				'UserLoginAttempt.ip_addr' => $_SERVER['REMOTE_ADDR'],
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
				$this->validationErrors['login_temporarily_disabled'][] = 'Too many failed login attempts: Your connection has been disabled temporarily';
				return true;
			}
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
		$this->checkWritableFields = false;
		$this->id = $id;
		$this->saveField('flag_active', false);
	}

/**
 * Error if IE below version 8
 *
 * @return void
 */
	public function showErrorIfInternetExplorerIsBelowVersion8() {
		$matches = array();
		if (preg_match('/MSIE ([\d]+)/', $_SERVER['HTTP_USER_AGENT'], $matches)) {
			if ($matches[1] < 8) {
				$this->validationErrors[] = __('bad internet explorer version msg');
			}
		}
	}

/**
 * Checks if Password Reset is required
 *
 * @return bool
 */
	public function isPasswordResetRequired() {
		$last_time_password_was_modified = AuthComponent::user('password_modified');
		$password_validity_period_month = Configure::read('password_validity_period_month');

		if (!$last_time_password_was_modified && $password_validity_period_month) {
			return true;
		} else {
			$start_date = new DateTime($last_time_password_was_modified);
			$end_date = new DateTime(date("Y-m-d H:i:s"));
			$interval = $start_date->diff($end_date);
			if ($password_validity_period_month && (($interval->y * 12 + $interval->m) >= $password_validity_period_month)) {
				return true;
			}
		}
		return false;
	}
}
