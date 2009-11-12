<?php

class UsersController extends AppController {

	var $helpers = array('Html', 'Form');
	
	function beforeFilter() {
		parent::beforeFilter();
		
		$this->Auth->allowedActions = array('login', 'logout');
		
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'login') );
	}
	
	function login() {
		if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
			// $this->redirect($this->Auth->loginRedirect);
		}
	}
	
	function logout() {
		$this->Session->setFlash('Good-Bye');
		$this->redirect($this->Auth->logout());
	}

}

?>