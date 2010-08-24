<?php

class UsersController extends AppController {

	var $helpers = array('Html', 'Form');
	var $uses = array('User');
	
	function beforeFilter() {
		parent::beforeFilter();
		
		$this->Auth->allowedActions = array('login', 'logout');
		
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'login') );
	}
	
	function login() {
		if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
			$data = $this->User->find('first', array('conditions' => array('User.id' => $_SESSION['Auth']['User']['id'])));
			$_SESSION['Auth']['Group'] = $data['Group'];
			$this->redirect($this->Auth->loginRedirect);
		}else if(!empty($this->data)){
			$tmp = $this->User->find('first', array('conditions' => array('User.username' => $this->data['User']['username'])));
			if(!empty($tmp) && !$tmp['User']['flag_active']){
				$this->User->validationErrors[] = "that user is disabled";
			}else{
				$this->User->validationErrors[] = "Login failed. Invalid username or password.";
			}
		}
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