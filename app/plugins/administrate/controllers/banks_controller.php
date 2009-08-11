<?php

class BanksController extends AdministrateAppController {
	
	var $uses = array('Bank');
	var $paginate = array('Bank'=>array('limit'=>10,'order'=>'Bank.name ASC')); 
	
	function index() {
		$this->data = $this->paginate($this->Bank);
	}
	
	function add(){
		$this->set( 'atim_menu', $this->Menus->get('/administrate/banks') );
		
		if ( !empty($this->data) ) {
			if ( $this->Bank->save($this->data) ) $this->flash( 'Your data has been updated.','/administrate/banks/detail/'.$this->Bank->id );
		}
		
	}
	
	function detail( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		$this->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
	}
	
	function edit( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		
		if ( !empty($this->data) ) {
			$this->Bank->id = $bank_id;
			if ( $this->Bank->save($this->data) ) $this->flash( 'Your data has been updated.','/administrate/banks/detail/'.$bank_id );
		} else {
			$this->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
		}
	}
	
	function delete( $bank_id ) {
		if ( $this->Bank->atim_delete($bank_id) ) {
			$this->flash( 'Your data has been deleted.', '/administrate/banks/index' );
		}
	}
	
	/*
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('banks') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$criteria = array();
		$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'banks', $this->Bank->findAll( $criteria, NULL, $order, $limit, $page ) );
		
		$this->set( 'banks', $this->Bank->find('all') );
	}
	
	function detail( $bank_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_74', $bank_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('banks') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		
		$this->Bank->id = $bank_id;
		$this->set( 'data', $this->Bank->read() );
	}
	
	function add() {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('banks') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('banks') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		if ( !empty($this->data) ) {
			
			if ( $this->Bank->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/banks/index/' );
			}
			
		}
		
	}
	
	function edit( $bank_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('banks') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_74', $bank_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('banks') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		
		if ( empty($this->data) ) {
			
			$this->Bank->id = $bank_id;
			$this->data = $this->Bank->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->User->save( $this->data['Bank'] ) ) {
				$this->flash( 'Your data has been updated.','/banks/detail/'.$bank_id );
			}
			
		}
	}
	*/

}

?>