<?php

class StructuresController extends AdministrateAppController {
	
	var $uses = array('Structure');
	var $paginate = array('Structure'=>array('limit'=>10,'order'=>'Structure.alias ASC')); 
	
	function index() {
		$this->data = $this->paginate($this->Structure);
	}
	
	function detail( $structure_id ) {
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id) );
		
		$this->data = $this->Structure->find('first',array('conditions'=>array('Structure.id'=>$structure_id)));
	}
	
	function edit( $structure_id ) {
		$this->set( 'atim_menu_variables', array('v.id'=>$structure_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->Structure->save($this->data) ) $this->flash( 'Your data has been updated.','/administrate/structures/detail/'.$structure_id );
		} else {
			$this->data = $this->Structure->find('first',array('conditions'=>array('Structure.id'=>$structure_id)));
		}
	}
	
	/*
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('forms') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
			$criteria = array();
			$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'forms_data', $this->Form->findAll( $criteria, NULL, $order, $limit, $page ) );
		
	}
	
	function detail( $form_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_75', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('forms') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		
		$this->Form->id = $form_id;
		$this->set( 'data', $this->Form->read() );
	}
	
	function add() {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('forms') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('forms') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		if ( !empty($this->data) ) {
			
			if ( $this->Form->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/forms/index/' );
			}
			
		}
		
	}
	
	function edit( $form_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('forms') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_75', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('forms') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		
		if ( empty($this->data) ) {
			
			$this->Form->id = $form_id;
			$this->data = $this->Form->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->Form->save( $this->data['Form'] ) ) {
				$this->flash( 'Your data has been updated.','/forms/detail/'.$form_id );
			}
			
		}
	}
	*/

}

?>