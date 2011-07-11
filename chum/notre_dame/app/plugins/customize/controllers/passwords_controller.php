<?php

class PasswordsController extends CustomizeAppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index() {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'users') );
			
		$this->User->id = $_SESSION['Auth']['User']['id'];
		
		$this->hook();
		
		if ( empty($this->data) ) {
			$this->set( 'data', $this->User->read() );
		}else {
			$flash_link = '/customize/passwords/index';
			$this->User->savePassword($this->data, $flash_link, $flash_link);
		}
		
	}
}

?>