<?php

class PasswordsController extends CustomizeAppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index() {
		$this->Structures->set('password');
			
		$this->User->id = $this->Session->read('Auth.User.id');
		
		$this->hook();
		
		if ( empty($this->request->data) ) {
			$this->set( 'data', $this->User->read() );
		}else {
			$flash_link = '/Customize/passwords/index';
			$this->User->savePassword($this->request->data, $flash_link, $flash_link);
		}
		
	}
}

?>