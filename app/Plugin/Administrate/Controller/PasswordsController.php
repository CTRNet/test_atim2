<?php

class PasswordsController extends AdministrateAppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index( $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->set( 'atim_structure', $this->Structures->get(NULL,'users') );
		
		$this->User->id = $user_id;
			
		if ( empty($this->request->data) ) {
			$this->set( 'data', $this->User->read() );
		} else {
			$flash_link = '/Administrate/passwords/index/'.$group_id.'/'.$user_id;
			$this->User->savePassword($this->request->data, $flash_link, $flash_link);
		}
		
	}

}

?>