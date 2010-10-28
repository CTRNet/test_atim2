<?php

class PasswordsController extends AdministrateAppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index( $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->set( 'atim_structure', $this->Structures->get(NULL,'users') );
		
		$this->User->id = $user_id;
			
		if ( empty($this->data) ) {
			$this->set( 'data', $this->User->read() );
		} 
		
		else {
			
			foreach ( $this->Structures->get('rules', 'users') as $model=>$rules ){
				$this->{ $model }->validate = $rules;
			}
			
			if ( isset($this->data['User']['new_password']) && isset($this->data['User']['confirm_password']) ) {
				if ( $this->data['User']['new_password'] && $this->data['User']['confirm_password'] ) {
					if ( $this->data['User']['new_password']==$this->data['User']['confirm_password'] ) {
						$this->data['User']['password'] = Security::hash($this->data['User']['new_password'], null, true);
						
						unset($this->data['User']['new_password']);
						unset($this->data['User']['confirm_password']);
						$this->data['User']['group_id'] = $group_id;
						if ( $this->User->save( $this->data ) ) {
							
							$this->atimFlash( 'your data has been updated','/administrate/passwords/index/'.$group_id.'/'.$user_id );
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