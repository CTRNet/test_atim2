<?php

class UsersController extends AppController {

	public $uses = array('User', 'UserLoginAttempt', 'Version');

/**
 * Before Filter Callback
 *
 * @return void
 */
	function beforeFilter() {
		parent::beforeFilter();
		
		if(Configure::read('reset_forgotten_password_feature')) {
			$this->Auth->allow('login', 'logout', 'resetForgottenPassword');
		} else {
			$this->Auth->allow('login', 'logout');
		}
		$this->Auth->authenticate = array(
			'Form' => array(
				'userModel' => 'User',
				'scope' => array('User.flag_active')
			)
		);
		
		$this->set('atim_structure', $this->Structures->get('form', 'login'));
	}
	
/**
 * Login Method
 *
 * @return \Cake\Network\Response|null
 */
	function login() {
		if ($this->request->is('ajax') && !isset($this->passedArgs['login'])) {
			echo json_encode(array('logged_in' => isset($_SESSION['Auth']['User']), 'server_time' => time()));
			exit;
		}
		
		// Load version data and check if initialization is required
		$versionData = $this->Version->find('first', array('fields' => array('MAX(id) AS id')));
		$this->Version->id = $versionData[0]['id'];
		$this->Version->read();
		if ($this->Version->data['Version']['permissions_regenerated'] == 0) {
			$this->newVersionSetup();
		}
			
		$this->set('skip_expiration_cookie', true);
		
		if($this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts()) {
			// Too many login attempts - froze atim for couple of minutes
			$this->request->data = array();
			$this->Auth->flash(__('too many failed login attempts - connection to atim disabled temporarily'));

		} else if ($this->Auth->login() && (!isset($this->passedArgs['login']))) {
			// Log in user
			if($this->request->data['User']['username']) $this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);
			$this->_initializeNotificationSessionVariables();
			
			$this->_setSessionSearchId();
			$this->resetPermissions();
			
			//Authentication credentials expiration
			if ($this->User->isPasswordResetRequired()) {
				$this->Session->write('Auth.User.force_password_reset', '1');
				return $this->redirect('/Customize/Passwords/index');
			}
			
			if (isset($this->passedArgs['login'])) {
				return $this->render('ok');
			} else {
				return $this->redirect('/Menus');
			}
			
		} else if(isset($this->request->data['User']['username'])) {
				// Save failed login attempt
				$this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
				if($this->User->disableUserAfterTooManyFailedAttempts($this->request->data['User']['username'])) {
					AppController::addWarningMsg(__('your username has been disabled - contact your administartor'));
				}
				$this->request->data = array();
				$this->Auth->flash(__('login failed - invalid username or password or disabled user'));
		}

		//User got returned to the login page, tell him why
		if (isset($_SESSION['Message']['auth']['message'])) {
			$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message']).($_SESSION['Message']['auth']['message'] == "You are not authorized to access that location."? __("if you were logged id, your session expired.") : '');
			unset($_SESSION['Message']['auth']);
		}
		
		if (isset($this->passedArgs['login'])) {
			AppController::addInfoMsg(__('your session has expired'));
		}
		
		$this->User->showErrorIfInternetExplorerIsBelowVersion(8);
	}

/**
 * Set Session Search Id
 *
 * @return void
 */
	function _setSessionSearchId() {
		if (!$this->Session->read('search_id')) {
			$this->Session->write('search_id', 1);
			$this->Session->write('ctrapp_core.search', array());
		}
	}

/**
 * Logs a user out
 *
 * @return void
 */
	function logout() {
		$this->Acl->flushCache();
		$this->redirect($this->Auth->logout());
	}

/**
 * initializeNotificationSessionVariables
 *
 * @return void
 */
	function _initializeNotificationSessionVariables() {
		// Init Session variables
		$this->Session->write('ctrapp_core.warning_no_trace_msg', array());
		$this->Session->write('ctrapp_core.warning_trace_msg', array());
		$this->Session->write('ctrapp_core.info_msg', array());
	}
	
/**
 * Reset a forgotten password of a user based on personnal questions.
 *
 * @return \Cake\Network\Response|null
 */
	function resetForgottenPassword() {
		if(!Configure::read('reset_forgotten_password_feature')) {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if($this->Session->read('Auth.User.id')) {
			$this->redirect('/');
		}

		$ip_temporarily_disabled = $this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts();
		
		if(empty($this->request->data) || $ip_temporarily_disabled) {
			
			// 1- Initial access to the function: 
			// Display of the form to set the username.
			
			$this->Structures->set('username');
			if($ip_temporarily_disabled) $this->User->validationErrors[][] = __('too many failed login attempts - connection to atim disabled temporarily');
			
			$this->set('reset_forgotten_password_step', '1');
		
		} else {
			
			// Check username exists in the database and is not disabled
			
			if(!isset($this->request->data['User']['username'])) {
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$reset_form_fields = $this->User->getForgottenPasswordResetFormFields();
			$reset_form_question_fields = array_keys($reset_form_fields);
			
			$db_user_data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username'], 'User.flag_active' => '1')));
			if(!$db_user_data) {
				
				// 2- User name does not exist in the database or is disabled
				// Display or re-display the form to set the username
				
				$this->User->validationErrors['username'][] = __('invalid username or disabled user');
				$this->Structures->set('username');
				$this->set('reset_forgotten_password_step', '1');
				$this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
				$this->request->data = array();
				
			} else if(!array_key_exists(array_shift($reset_form_question_fields), $this->request->data['User'])) {
				
				// 3- User name does exist in the database
				// Display the form to set the username confidential questions
				
				$this->Structures->set('forgotten_password_reset'.((Configure::read('reset_forgotten_password_feature') != '1')? ',other_user_login_to_forgotten_password_reset': ''));
				$this->set('reset_forgotten_password_step', '2');
				$this->request->data = array('User' => array('username' => $this->request->data['User']['username']));
				foreach($reset_form_fields as $question_field_name => $answer_field_name) {
					$this->request->data['User'][$question_field_name] = $db_user_data['User'][$question_field_name];
				}
				
			} else {
					
				// 4- User name does exist in the database and answers have been completed by the user
				// Check the answers set by the user to reset the password
			
				$this->Structures->set('forgotten_password_reset'.((Configure::read('reset_forgotten_password_feature') != '1')? ',other_user_login_to_forgotten_password_reset': ''));
				$this->set('reset_forgotten_password_step', '2');
				
				$submitted_data_validates = true;				
				
				// Validate user questions answers
				
				foreach($reset_form_fields as $question_field_name => $answer_field_name) {
					// Check db/form questions matche
					if($db_user_data['User'][$question_field_name] != $this->request->data['User'][$question_field_name]) {
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					// Check answers
					if(!strlen($db_user_data['User'][$answer_field_name])) {
						//No answer in db. Validation can not be done
						$this->User->validationErrors['username']['#1'] = __('at least one error exists in the questions you answered - password can not be reset');
						$submitted_data_validates = false;					
					}
					if($db_user_data['User'][$answer_field_name]  !== $this->User->hashSecuritAsnwer($this->request->data['User'][$answer_field_name])) {
						$this->User->validationErrors['username']['#1'] = __('at least one error exists in the questions you answered - password can not be reset');
						$submitted_data_validates = false;
					}
				}
				
				// Validate other user login

				if(Configure::read('reset_forgotten_password_feature') != '1') {
					if(!isset($this->request->data['0']['other_user_check_username'])) {
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					$conditions = array(
						'User.username' => $this->request->data['0']['other_user_check_username'],
						'User.flag_active' => '1',
						'User.password' => Security::hash($this->request->data['0']['other_user_check_password'], null, true)
					);
					if (!$this->User->find('count', array('conditions' => $conditions))) {
						$this->User->validationErrors['other_user_check_username'][] = __('other user control').' : '.__('invalid username or disabled user');
						$submitted_data_validates = false;
					}
				}
				
				if($submitted_data_validates) {
					// Save new password
					$this->User->id = $db_user_data['User']['id'];
					$suer_data_to_save = array(
						'User' => array(
							'id' => $db_user_data['User']['id'],
							'group_id' => $db_user_data['User']['group_id'],
							'new_password' => $this->request->data['User']['new_password'],
							'confirm_password' => $this->request->data['User']['confirm_password']
						)
					);
					if($this->User->savePassword($suer_data_to_save, true)) {
						$this->atimFlash(__('your data has been updated'), '/' );
					}
				} else {
					// Save failed login attempt
					$this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
					if($this->User->disableUserAfterTooManyFailedAttempts($this->request->data['User']['username'])) {
						AppController::addWarningMsg(__('your username has been disabled - contact your administartor'));
					}
				}
				
				// Flush login information
				$this->request->data['0']['other_user_check_username'] = '';
				$this->request->data['0']['other_user_check_password'] = '';
				$this->request->data['User']['new_password'] = '';
				$this->request->data['User']['confirm_password'] = '';
			}
		}
	}
}

?>