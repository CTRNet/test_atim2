<?php

class UsersController extends AppController {

	var $helpers = array('Html', 'Form');
	var $uses = array('User', 'UserLoginAttempt');
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->autoRedirect = false;//because we need to save the login attempt
		$this->Auth->allowedActions = array('login', 'logout');
		
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'login') );
	}
	
	function login() {
		if($this->Auth->user()){
			if(!empty($this->data)){
				//successfulll login
				$login_data = array(
						"username" => $this->data['User']['username'],
						"ip_addr" => $_SERVER['REMOTE_ADDR'],
						"succeed" => true
				);
				$this->UserLoginAttempt->save($login_data);
			}						
			$this->redirect($this->Auth->redirect());
		}else if(!empty($this->data)){
			//failed login
			$login_data = array(
						"username" => $this->data['User']['username'],
						"ip_addr" => $_SERVER['REMOTE_ADDR'],
						"succeed" => false
			);
			$this->UserLoginAttempt->save($login_data);
		}
		
		//User got returned to the login page, tell him why
		if(isset($_SESSION) && isset($_SESSION['Message']) && isset($_SESSION['Message']['auth']['message'])){
			$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message'], true);
			unset($_SESSION['Message']['auth']);
		}else if(isset($_SESSION) && isset($_SESSION['Message']) && isset($_SESSION['Message']['flash']['message'])){
			$this->User->validationErrors[] = __($_SESSION['Message']['flash']['message'], true);
			unset($_SESSION['Message']['flash']);
		}
	}
	
	function logout() {
		$this->Acl->flushCache();
		$this->redirect($this->Auth->logout());
	}

}

?>