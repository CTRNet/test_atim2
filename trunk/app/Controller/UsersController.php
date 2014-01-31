<?php

class UsersController extends AppController {

	var $uses = array('User', 'UserLoginAttempt', 'Version');
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->allow('login', 'logout');
		$this->Auth->authenticate = array('Form' => array('userModel' => 'User', 'scope' => array('User.flag_active')));
		
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'login') );
	}
	
	function login(){
		if($this->request->is('ajax') && !isset($this->passedArgs['login'])){
			echo json_encode(array("logged_in" => isset($_SESSION['Auth']['User']), "server_time" => time()));
			exit;
		}

		$version_data = $this->Version->find('first', array('fields' => array('MAX(id) AS id')));
		$this->Version->id = $version_data[0]['id'];
		$this->Version->read();
		
		if($this->Version->data['Version']['permissions_regenerated'] == 0){
			$this->newVersionSetup();
		}
		
		$this->set('skip_expiration_cookie', true);
		
		// Test last login results from IP adress
		$is_locked_IP = true;
		$max_login_attempts_from_IP = Configure::read('max_login_attempts_from_IP');
		$mn_IP_disabled = Configure::read('time_mn_IP_disabled');	
		$last_login_attempts_from_ip = $this->UserLoginAttempt->find('all', array('conditions' => array('UserLoginAttempt.ip_addr' => $_SERVER['REMOTE_ADDR']), 'order' => array('UserLoginAttempt.id DESC'), 'limit' => $max_login_attempts_from_IP));	
		if(sizeof($last_login_attempts_from_ip) < $max_login_attempts_from_IP) {
			$is_locked_IP = false;
		} else {
			foreach($last_login_attempts_from_ip as $login_attempt) if($login_attempt['UserLoginAttempt']['succeed']) $is_locked_IP = false;
			if($is_locked_IP) {
				$last_attempt_time = $last_login_attempts_from_ip[($max_login_attempts_from_IP-1)]['UserLoginAttempt']['attempt_time'];			
				$start_date = new DateTime($last_attempt_time);
				$end_date = new DateTime(now());
				$interval = $start_date->diff($end_date);			
				if($interval->y || $interval->m || $interval->d || (($interval->h*60 + $interval->i) >= $mn_IP_disabled)) $is_locked_IP = false;
			}
		}	
		if($is_locked_IP) {
			$this->Auth->flash(__('your connection has been temporarily disabled'));
		} else if($this->Auth->login() && (!isset($this->passedArgs['login']) || !empty($this->request->data))){
			$reset_pwd = false;
			if(!empty($this->request->data)){
				//successfulll login
				$login_data = array(
						"username"			=> $this->request->data['User']['username'],
						"ip_addr"			=> $_SERVER['REMOTE_ADDR'],
						"succeed"			=> true,
						"http_user_agent"	=> $_SERVER['HTTP_USER_AGENT'],
						"attempt_time"		=> now()
				);
				$this->UserLoginAttempt->save($login_data);
				$_SESSION['ctrapp_core']['warning_no_trace_msg'] = array();//init
				$_SESSION['ctrapp_core']['warning_trace_msg'] = array();//init
				$_SESSION['ctrapp_core']['info_msg'] = array();//init
				//Authentication credentials expiration 
				$user_data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username'])));
				if(!$user_data['User']['password_modified'] && Configure::read('password_validity_period_month')) {
					$reset_pwd = true;
				} else {
					$last_password_modified = $user_data['User']['password_modified'];
					$start_date = new DateTime($last_password_modified);
					$end_date = new DateTime(now());
					$interval = $start_date->diff($end_date);
					if(Configure::read('password_validity_period_month') && (($interval->y*12 + $interval->m) >= Configure::read('password_validity_period_month'))) {
						$reset_pwd = true;
					}
				}
			}
			if(!$this->Session->read('search_id')){
				$this->Session->write('search_id', 1);
				$_SESSION['ctrapp_core']['search'] = array();
			}
			$this->resetPermissions();
			if(isset($this->passedArgs['login'])){
				$this->render('ok');
			}else if($reset_pwd) {
				AppController::addWarningMsg(__('your password has expired. please change your password for security reason.'));
				$this->redirect('/Customize/Passwords/index/');
			} else {
				$this->redirect('/Menus');
			}
		}else if(isset($this->request->data['User'])){
			//failed login
			$user_data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username'])));
			$login_failed_message = 'Login failed. Invalid username or password or disabled user.';
			if(!empty($user_data) && !$user_data['User']['flag_active'] && $user_data['User']['username'] == $this->request->data['User']['username']){
				//$login_failed_message = "that username is disabled";
			}else{
				if(!empty($user_data) && $user_data['User']['username'] == $this->request->data['User']['username']){
					$last_login_attempts_for_username = $this->UserLoginAttempt->find('all', array('conditions' => array('UserLoginAttempt.username' => $this->request->data['User']['username']), 'order' => array('UserLoginAttempt.id DESC'), 'limit' => Configure::read('max_user_login_attempts')));			
					$disable_user = (empty($last_login_attempts_for_username) || ($last_login_attempts_for_username[0]['UserLoginAttempt']['attempt_time'] < $user_data['User']['modified']))? false : true;
					if($disable_user) foreach($last_login_attempts_for_username as $login_attempt) if($login_attempt['UserLoginAttempt']['succeed']) $disable_user = false;
					if($disable_user) {
						$this->User->check_writable_fields = false;
						$this->User->id = $user_data['User']['id'];
						if(!$this->User->save(array('User' => array('id' => $user_data['User']['id'], 'flag_active' => 0)), false)) {
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						}
						//$login_failed_message = 'login failed. that username has been disabled';
					}
				}
			}
			//UserLoginAttempt->save() should be after user->save() for test "$last_login_attempts_for_username[0]['UserLoginAttempt']['attempt_time']. ' < ' . $user_data['User']['modified']" above
			$login_data = array(
					"username" => $this->request->data['User']['username'],
					"ip_addr" => $_SERVER['REMOTE_ADDR'],
					"succeed" => false,
					"http_user_agent"	=> $_SERVER['HTTP_USER_AGENT'],
					"attempt_time"		=> now()
			);
			$this->UserLoginAttempt->save($login_data);
			$this->Auth->flash(__($login_failed_message));
		}
		
		
		//User got returned to the login page, tell him why
		if(isset($_SESSION) && isset($_SESSION['Message']) && isset($_SESSION['Message']['auth']['message'])){
			if($_SESSION['Message']['auth']['message'] == "You are not authorized to access that location."){
				$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message'])." ".__("if you were logged id, your session expired.");
			}else{
				$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message']);
			}
			unset($_SESSION['Message']['auth']);
		}
		
		if(isset($this->passedArgs['login'])){
			AppController::addInfoMsg(__('your session has expired'));
		}
		
		$matches = array();
		if(preg_match('/MSIE ([\d]+)/', $_SERVER['HTTP_USER_AGENT'], $matches)){
			if($matches[1] < 8){
				$this->User->validationErrors[] = __('bad internet explorer version msg');
			}
		}
	}
	
	function logout() {
		$this->Acl->flushCache();
		$this->redirect($this->Auth->logout());
	}
}

?>