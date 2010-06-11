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
							$this->flash( 'your data has been updated','/customize/passwords/index' );
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
	
	/*
	var $name = 'Passwords';
	var $uses = array('User');
	
	var $components = array('Summaries');
	var $helpers = array('Summaries');
	
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_42', 'core_CAN_93', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('user_preferences');
		unset( $ctrapp_form['FormField'][0] ); // manually adjust form, remove elements USER should not have access to...
		$this->set( 'ctrapp_form', $ctrapp_form );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$this->User->id = $this->othAuth->user('id');
			
		if ( empty($this->data) ) {
			
			$this->set( 'data', $this->User->read() );
			
		} else {
		
			// pr($this->data);
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			if ( isset($this->data['User']['new_password']) && isset($this->data['User']['confirm_password']) ) {
				if ( $this->data['User']['new_password'] && $this->data['User']['confirm_password'] ) {
					if ( $this->data['User']['new_password']==$this->data['User']['confirm_password'] ) {
						$this->data['User']['passwd'] = $this->data['User']['new_password'];
						unset($this->data['User']['new_password']);
						unset($this->data['User']['confirm_password']);
					}
				}
			}
			
			// pr($this->data);
			// exit();
			
			if ( $this->User->save( $this->data ) ) {
				$this->flash( 'your data has been updated','/passwords/index/' );
				exit();
			}
			
		}
		
	}
	*/

}

?>