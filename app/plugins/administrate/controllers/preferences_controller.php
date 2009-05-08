<?php

class PreferencesController extends AppController {
	
	var $uses = array('User');
	
	function index( $bank_id, $group_id, $user_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'user_preferences') );
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
	}
	
	function edit( $bank_id, $group_id, $user_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'user_preferences') );
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->User->save($this->data) ) $this->flash( 'Your data has been updated.','/administrate/preferences/index/'.$bank_id.'/'.$group_id.'/'.$user_id );
		} else {
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		}
	}

	
	/*
	var $name = 'Preferences';
	var $uses = array('User');
	
	var $components = array('Summaries');
	var $helpers = array('Summaries');
	
	function index( $bank_id, $group_id, $user_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_92', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('user_preferences') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		
		$this->User->id = $user_id;
		$this->set( 'data', $this->User->read() );
	}
	
	function edit( $bank_id, $group_id, $user_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_92', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('user_preferences') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		
		if ( empty($this->data) ) {
			
			$this->User->id = $user_id;
			$this->data = $this->User->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->User->save( $this->data['User'] ) ) {
				$this->flash( 'Your data has been updated.','/preferences/index/'.$bank_id.'/'.$group_id.'/'.$user_id );
			}
			
		}
	}
	*/

}

?>