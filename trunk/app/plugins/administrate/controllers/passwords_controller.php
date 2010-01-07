<?php

class PasswordsController extends AppController {
	
	var $name = 'Passwords';
	var $uses = array('User');
	
	function index( $bank_id, $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->set( 'atim_structure', $this->Structures->get(NULL,'users') );
			
		/*
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_94', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		*/
		
		/*
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('user_preferences');
		unset( $ctrapp_form['FormField'][0] ); // manually adjust form, remove elements USER should not have access to...
		$this->set( 'ctrapp_form', $ctrapp_form );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		*/
		
		$this->User->id = $user_id;
			
		if ( empty($this->data) ) {
			$this->set( 'data', $this->User->read() );
		} 
		
		else {
		
			foreach ( $this->Structures->get('rules', 'users') as $model=>$rules ) $this->{ $model }->validate = $rules;
			
			/*
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			*/
			
			if ( isset($this->data['User']['new_password']) && isset($this->data['User']['confirm_password']) ) {
				if ( $this->data['User']['new_password'] && $this->data['User']['confirm_password'] ) {
					if ( $this->data['User']['new_password']==$this->data['User']['confirm_password'] ) {
						$this->data['User']['password'] = Security::hash($this->data['User']['new_password'], null, true);
						
						unset($this->data['User']['new_password']);
						unset($this->data['User']['confirm_password']);
						
						if ( $this->User->save( $this->data ) ) {
							$this->flash( 'Your data has been updated.','/administrate/passwords/index/'.$bank_id.'/'.$group_id.'/'.$user_id );
						}
					}
				}
			}
			
			$this->flash( 'Sorry, new password was not entered correctly.','/customize/passwords/index' );
		}
		
	}

}

?>