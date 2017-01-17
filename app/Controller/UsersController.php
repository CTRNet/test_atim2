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
		
		$this->Auth->allow('login', 'logout');
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

//TODO: Added by Alex. Not sure required
if (AuthComponent::user()) {
//TODO: Added by Alex. Not sure required	$this->redirect(array('controller' => 'Menus', 'action' => 'index'));
}
		
//TODO: Added by Alex. Not sure required 	if ($this->request->is('post')) {

			$ip_temporarily_disabled = $this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts();
			
			if (!$ip_temporarily_disabled && $this->Auth->login() && (!isset($this->passedArgs['login']))) {

				$this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);
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
			} else {
				// Save failed login attempt
				if(isset($this->request->data['User']['username'])) $this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
				$username_just_disabled = isset($this->request->data['User']['username'])? $this->User->disableUserAfterTooManyFailedAttempts($this->request->data['User']['username']) : false;
				$flash_message = array();
				$flash_message[] = $ip_temporarily_disabled? __('too many failed login attempts - connection to atim disabled temporarily') : __('login failed - invalid username or password or disabled user');
				if($username_just_disabled) $flash_message[] = __('your username has been disabled - contact your administartor');
				$this->Auth->flash(implode(' ', $flash_message));
			}
//TODO: Added by Alex. Not sure required		}

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
}

?>