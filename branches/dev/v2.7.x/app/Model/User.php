<?php
App::uses('AppModel', 'Model');

/**
 * Class User
 */
class User extends AppModel
{
   public $belongsTo = array('Group');

   public $actsAs = array('Acl' => array('requester'));

	const PASSWORD_MINIMAL_LENGTH = 8;

   public function parentNode() {
       if(isset($this->data['User']['group_id'])){
          return array('Group' => array('id' => $this->data['User']['group_id']));
       }
		 if(isset($this->data['User']['id'])){
		    $this->id = $this->data['User']['id'];
		 }

		 if (!$this->id) {
            throw new Exception('Insufficient data to determine parentNode');
       }

       $data = $this->find('first', array('conditions' => array('User.id' => $this->id, 'User.deleted' => array(0, 1))));
       return array('Group' => array('id' => $data['User']['group_id']));
	}

    public function summary( array $variables ) {
		$return = false;
		
		if ( isset($variables['User.id']) ) {
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


	public function getUsersList() {
		$all_users_data = $this->find('all', array('recursive' => '-1'));
		$result = array();
		foreach($all_users_data as $data) {
			$result[$data['User']['id']] = $data['User']['first_name'] . ' ' . $data['User']['last_name']; 
		}
		return $result;
	}

    public function savePassword(array $data, $error_flash_link, $success_flash_link, $modified_by_user = TRUE){
		assert($this->id);
		$this->validatePassword($data);
		
		if($this->validationErrors){
			AppController::getInstance()->flash(__($this->validationErrors['password'][0]), $error_flash_link);
		}else{
	
			$this->read();

			if ($modified_by_user) {
            $password_modified_time = now();
         } else {
            $password_modified_time = NULL;
         }
			
			//all good! save
			$data_to_save = array('User' => array(
				'group_id' => $this->data['User']['group_id'],
				'password' => Security::hash($data['User']['new_password'], null, true),
				'password_modified' => $password_modified_time
         ));
			
			$this->data = null;
			$this->check_writable_fields = false;
			if ( $this->save( $data_to_save ) ) {
				AppController::getInstance()->flash(__('your data has been updated'), $success_flash_link );
			}
		}
	}
	
	/**
	 * Will throw a flash message if the password is not valid
	 * @param array $data
    * @param string|null $created_user_name
    * @return boolean true if validation passes
	 */
    public function validatePassword(array $data, $created_user_name = null){
		if ( !isset($data['User']['new_password'], $data['User']['confirm_password']) ) {
			//do nothing
			$this->validationErrors['password'][] = 'Please make sure all fields are filled';
		} else if ($data['User']['new_password'] !== $data['User']['confirm_password']){
				$this->validationErrors['password'][] = 'passwords do not match'; 
		} else {
			if($created_user_name === $data['User']['new_password']) {
				$this->validationErrors['password'][] = 'password should be different than username';
			} else if($this->id) {
				if($this->find('count', array(
				   'conditions' =>array(
				      'User.id' => $this->id,
                  'User.username ' => $data['User']['new_password'])
            ))) {
               $this->validationErrors['password'][] = 'password should be different than username';
            }
				if($this->find('count', array(
				   'conditions' =>array(
				      'User.id' => $this->id,
                  'User.password ' => Security::hash($data['User']['new_password'], null, true)
               )))) {
               $this->validationErrors['password'][] = 'password should be different than the previous one';
            }
			} else {
				$this->validationErrors['password'][] = 'internal error';
			}

			$password_security_level = (int) Configure::read('password_security_level');
			if (!in_array($password_security_level, array(0,1,2,3,4), true)) {
            $password_security_level = 4;
         }

			$password_format_error = false;
			switch($password_security_level) {
				case 4:
					if(!preg_match('/\W+/', $data['User']['new_password'])) $password_format_error = true;
				case 3:
					if(!preg_match('/[A-Z]+/', $data['User']['new_password'])) $password_format_error = true;
				case 2:
					if(!preg_match('/[1-9]+/', $data['User']['new_password'])) $password_format_error = true;
				case 1:
					if( strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH) $password_format_error = true;
					if(!preg_match('/[a-z]+/', $data['User']['new_password'])) $password_format_error = true;
				case 0:
				default:
			}
			if($password_format_error) {
            $this->validationErrors['password'][] = 'password_format_error_msg_' . $password_security_level;
         }

         if (empty($this->validationErrors['password'])) {
            return TRUE;
         }
         return FALSE;
		}
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
         'UserLoginAttempt.succeed' => TRUE
      ), array('UserLoginAttempt.id DESC'));

      // Set default in case user has never logged in before
      if (!$last_successful_login_time) {
         $last_successful_login_time = date('Y-m-d H:i:s');
      }

      $failed_login_attempts_from_ip = $model_UserLoginAttempt->find('all', array(
         'conditions' => array(
            'UserLoginAttempt.ip_addr' => $_SERVER['REMOTE_ADDR'],
            'UserLoginAttempt.succeed' => FALSE,
            'UserLoginAttempt.attempt_time >' => $last_successful_login_time
         ),
         'fields' => 'UserLoginAttempt.attempt_time',
         'order' => array('UserLoginAttempt.id DESC'),
         'limit' => $max_login_attempts_from_IP
      ));

      if (count($failed_login_attempts_from_ip) >= $max_login_attempts_from_IP) {
         $last_attempt_time = $failed_login_attempts_from_ip[0]['UserLoginAttempt']['attempt_time'];
         $start_date = new DateTime($last_attempt_time);
         $end_date = new DateTime(now());
         $interval = $start_date->diff($end_date);

         if ($interval->y || $interval->m || $interval->d) {
            return FALSE;
         }

         if (($interval->h * 60 + $interval->i) < $time_in_minutes_before_ip_is_reactivated) {
            $this->validationErrors['login_temporarily_disabled'][] = 'Too many failed login attempts: Your connection has been disabled temporarily';
            return TRUE;
         }
      }

      return FALSE;
   }


   /**
    * @param $id
    */
   public function disableUser($id) {
      $this->check_writable_fields = FALSE;
      $this->id = $id;
      $this->saveField('flag_active', FALSE);
   }

   /**
    *
    */
   public function showErrorIfInternetExplorerIsBelowVersion8() {
      $matches = array();
      if (preg_match('/MSIE ([\d]+)/', $_SERVER['HTTP_USER_AGENT'], $matches)) {
         if ($matches[1] < 8) {
            $this->User->validationErrors[] = __('bad internet explorer version msg');
         }
      }
   }


   /**
    * @return bool
    */
   public function isPasswordResetRequired() {
      $last_time_password_was_modified = AuthComponent::user('password_modified');
      $password_validity_period_month = Configure::read('password_validity_period_month');

      if (!$last_time_password_was_modified && $password_validity_period_month) {
         return TRUE;
      } else {
         $start_date = new DateTime($last_time_password_was_modified);
         $end_date = new DateTime(now());
         $interval = $start_date->diff($end_date);
         if ($password_validity_period_month
            && (($interval->y * 12 + $interval->m) >= $password_validity_period_month)) {
            return TRUE;
         }
      }
      return FALSE;
   }
}
