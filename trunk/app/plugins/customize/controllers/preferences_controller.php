<?php

class PreferencesController extends CustomizeAppController {
	
	var $name = 'Preferences';
	var $uses = array('User', 'Config');
	
	function index() {
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'preferences' ) );
		
		// get USER data
		
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			
		// get CONFIG data
		
			$config_results	= false;
		
			// get CONFIG for logged in user
			if ( $_SESSION['Auth']['User']['id'] ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$_SESSION['Auth']['User']['id'].'"'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $_SESSION['Auth']['User']['group_id'] && (!count($config_results) || !$config_results) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$_SESSION['Auth']['User']['group_id'].'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( !count($config_results) || !$config_results ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
			
			$this->data['Config'] = $config_results['Config'];
	}
	
	function edit() {
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'preferences' ) );
		
		$config_id = NULL;
		
		// get CONFIG data
			
			$config_results	= false;
			
			// get CONFIG for logged in user
			if ( $_SESSION['Auth']['User']['id'] ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$_SESSION['Auth']['User']['id'].'"'));
				$config_id = $config_results['Config']['id']; // set ID for saves (add or edit)
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $_SESSION['Auth']['User']['group_id'] && !count($config_results) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$_SESSION['Auth']['User']['group_id'].'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( !count($config_results) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
		
		if ( !empty($this->data) ) {
		
			$this->User->id = $_SESSION['Auth']['User']['id'];
			
			$this->Config->id = $config_id;
			$this->data['Config']['bank_id'] = 0;
			$this->data['Config']['group_id'] = 0;
			$this->data['Config']['user_id'] = $_SESSION['Auth']['User']['id'];
			
			if ( $this->User->validates($this->data) && $this->Config->validates($this->data) ) {
				$this->User->save($this->data);
				$this->Config->save($this->data);
				
				$this->flash( 'Your data has been updated.','/customize/preferences/index' );
			}
			
		} else {
			
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			$this->data['Config'] = $config_results['Config'];
				
		}
	}
	
	/*
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_42', 'core_CAN_85', '' );
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
		$this->set( 'data', $this->User->read() );
	}
	
	function edit() {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_42', 'core_CAN_84', '' );
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
		
		if ( empty($this->data) ) {
			
			$this->User->id = $this->othAuth->user('id');
			$this->data = $this->User->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->User->save( $this->data['User'] ) ) {
				$this->flash( 'Your data has been updated.','/preferences/index/' );
			}
			
		}
	}
	*/

}

?>