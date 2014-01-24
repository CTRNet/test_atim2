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
				$current_timestamp = $this->UserLoginAttempt->tryCatchQuery('SELECT CURRENT_TIMESTAMP');			
				$start_date = new DateTime($last_attempt_time);
				$end_date = new DateTime($current_timestamp[0][0]['CURRENT_TIMESTAMP']);
				$interval = $start_date->diff($end_date);			
				if(!$interval->invert) {		
					if($interval->y || $interval->m || $interval->d || (($interval->h*60 + $interval->i) >= $mn_IP_disabled)) $is_locked_IP = false;
				}
			}
		}	
		if($is_locked_IP) {
			$this->Auth->flash(__('your connection has been temporarily disabled'));
		} else if($this->Auth->login() && (!isset($this->passedArgs['login']) || !empty($this->request->data))){
			if(!empty($this->request->data)){
				//successfulll login
				$login_data = array(
						"username"			=> $this->request->data['User']['username'],
						"ip_addr"			=> $_SERVER['REMOTE_ADDR'],
						"succeed"			=> true,
						"http_user_agent"	=> $_SERVER['HTTP_USER_AGENT']
				);
				$this->UserLoginAttempt->save($login_data);
				$_SESSION['ctrapp_core']['warning_no_trace_msg'] = array();//init
				$_SESSION['ctrapp_core']['warning_trace_msg'] = array();//init
				$_SESSION['ctrapp_core']['info_msg'] = array();//init
			}
			if(!$this->Session->read('search_id')){
				$this->Session->write('search_id', 1);
				$_SESSION['ctrapp_core']['search'] = array();
			}
			$this->resetPermissions();
			if(isset($this->passedArgs['login'])){
				$this->render('ok');
			}else{
				$this->redirect('/Menus');
			}
		}else if(isset($this->request->data['User'])){
			//failed login
			$login_data = array(
						"username" => $this->request->data['User']['username'],
						"ip_addr" => $_SERVER['REMOTE_ADDR'],
						"succeed" => false
			);
			$this->UserLoginAttempt->save($login_data);
			$data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username'])));
			if(!empty($data) && !$data['User']['flag_active'] && $data['User']['username'] == $this->request->data['User']['username']){
				$this->Auth->flash(__("that username is disabled"));
			}else{
				$login_failed_message = 'Login failed. Invalid username or password.';
				if(!empty($data) && $data['User']['username'] == $this->request->data['User']['username']){
					$last_login_attempts_for_username = $this->UserLoginAttempt->find('all', array('conditions' => array('UserLoginAttempt.username' => $this->request->data['User']['username']), 'order' => array('UserLoginAttempt.id DESC'), 'limit' => Configure::read('max_user_login_attempts')));
					$disable_user = true;
					foreach($last_login_attempts_for_username as $login_attempt) if($login_attempt['UserLoginAttempt']['succeed']) $disable_user = false;
					if($disable_user) {
						$this->User->check_writable_fields = false;
						$this->User->id = $data['User']['id'];
						if(!$this->User->save(array('User' => array('id' => $data['User']['id'], 'flag_active' => 0)), false)) {
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						}
						$login_failed_message = 'login failed. that username has been disabled';
					}
				}				
				$this->Auth->flash(__($login_failed_message));
			}
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