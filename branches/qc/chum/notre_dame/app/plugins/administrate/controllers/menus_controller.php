<?php

class MenusController extends AdministrateAppController {
	
	var $uses = array('Menu');
	
	// temp beforefilter to allow permissions, ACL tables not updated yet
	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('index');
	}

	function index() {
		$this->hook();
		$this->data = $this->Menu->find('threaded', array('conditions'=>array('parent_id!="3" AND parent_id!="11" AND parent_id!="18" AND parent_id!="55" AND parent_id!="70"')));
	}
	
	function detail( $menu_id ) {
		$this->set( 'atim_menu_variables', array('Menu.id'=>$menu_id) );
		$this->hook();
		$this->data = $this->Menu->find('first',array('conditions'=>array('Menu.id'=>$menu_id)));
	}
	
	function edit( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Menu.id'=>$menu_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Menu->id = $bank_id;
			if ( $this->Menu->save($this->data) ) $this->flash( 'your data has been updated','/administrate/menus/detail/'.$menu_id );
		} else {
			$this->data = $this->Menu->find('first',array('conditions'=>array('Menu.id'=>$menu_id)));
		}
	}
	
	/*
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_71', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('menus') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
			// $criteria = array();
			// $criteria[] = 'id!="core_CAN_33"';
			// $criteria[] = '(parent="0" OR parent="core_CAN_33")';
			// $criteria = array_filter($criteria);
			
			// list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
			// $this->set( 'menus_data', $this->Menu->findAll( $criteria, NULL, $order, $limit, $page ) );
		
		$sort = 'parent_id ASC, display_order ASC';
		$this->set('data', $this->Menu->findAllThreaded(null, null, $sort));
		
	}
	
	function detail( $menu_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_71', '' );
		// $ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_74', $menu_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('menus') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'menu_id', $menu_id );
		
		$this->Menu->id = $menu_id;
		$this->set( 'data', $this->Menu->read() );
	}
	
	function add() {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('menus') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_71', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('menus') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		if ( !empty($this->data) ) {
			
			if ( $this->Menu->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/menus/index/' );
			}
			
		}
		
	}
	
	function edit( $menu_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('menus') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_71', '' );
		// $ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_74', $menu_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('menus') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'menu_id', $menu_id );
		
		if ( empty($this->data) ) {
			
			$this->Menu->id = $menu_id;
			$this->data = $this->Menu->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->Menu->save( $this->data['Menu'] ) ) {
				$this->flash( 'your data has been updated','/menus/detail/'.$menu_id );
			}
			
		}
	}
	*/
	
}

?>