<?php

class PasswordsAdminController extends AdministrateAppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index( $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->Structures->set('admin_user_password_for_change,password');
		
		$this->User->id = $user_id;
			
		if ( empty($this->request->data) ) {
			$this->set( 'data', $this->User->read() );
		} else {
			//Check administrator entered his password
			if($this->User->find('count', array('conditions' => array('User.id' => $this->Session->read('Auth.User.id'), 'User.password' => Security::hash($this->request->data['FunctionManagement']['admin_user_password_for_change'], null, true))))) {
				$flash_link = '/Administrate/PasswordsAdmin/index/'.$group_id.'/'.$user_id;
				$this->User->savePassword($this->request->data, $flash_link, $flash_link);
			} else {
				$this->User->validationErrors['admin_user_password_for_change'][] = __('your own password is invalid'); 
				$this->request->data = array();
			}
		}	
	}

}
