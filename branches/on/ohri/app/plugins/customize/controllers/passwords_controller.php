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
		} 
		
		else {
		
			foreach ( $this->Structures->get('rules', 'users') as $model=>$rules ) $this->{ $model }->validate = $rules;
			
			if ( isset($this->data['User']['new_password']) && isset($this->data['User']['confirm_password']) ) {
				if ( $this->data['User']['new_password'] && $this->data['User']['confirm_password'] ) {
					if ( $this->data['User']['new_password']==$this->data['User']['confirm_password'] ) {
						$this->data['User']['password'] = Security::hash($this->data['User']['new_password'], null, true);
						
						unset($this->data['User']['new_password']);
						unset($this->data['User']['confirm_password']);
						
						if ( $this->User->save( $this->data ) ) {
							$this->atimFlash( 'your data has been updated','/customize/passwords/index' );
						}
						
					} else {
						$this->flash( 'Sorry, new password was not entered correctly.','/customize/passwords/index' );
					}
					
				} else {
					$this->flash( 'Sorry, new password was not entered correctly.','/customize/passwords/index' );
				}
				
			}
			
			
		}
		
	}
}

?>