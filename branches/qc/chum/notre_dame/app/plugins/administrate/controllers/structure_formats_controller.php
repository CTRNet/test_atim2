<?php

class StructureFormatsController extends AdministrateAppController {
	
	var $uses = array('StructureFormat');
	var $paginate = array('StructureFormat'=>array('limit' => pagination_amount,'order'=>'StructureFormat.id ASC')); 
	
	function listall( $structure_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->StructureFormat, array('StructureFormat.structure_id'=>$structure_id));
	}
	
	function detail( $structure_id, $structure_format_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id, 'StructureFormat.id'=>$structure_format_id) );
		
		$this->hook();
		
		$this->data = $this->StructureFormat->find('first',array('conditions'=>array('StructureFormat.id'=>$structure_format_id)));
	}
	
	function edit( $structure_id, $structure_format_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id, 'StructureFormat.id'=>$structure_format_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			if ( $this->StructureFormat->save($this->data) ) $this->flash( 'your data has been updated','/administrate/structure_formats/detail/'.$structure_id.'/'.$structure_format_id );
		} else {
			$this->data = $this->StructureFormat->find('first',array('conditions'=>array('StructureFormat.id'=>$structure_format_id)));
		}
	}
	
	/*
	var $name = 'FormFormats';
	var $uses = array('Form', 'FormFormat', 'FormField');
	
	var $components = array('Summaries');
	var $helpers = array('Summaries');
	
	function listall( $form_id=0 ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_76', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('fields') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		
			// restrict BATCHes criteria to GROUPs
			// $restrict_criteria = array();
			// $restrict_result = $this->FormField->query('SELECT field_id FROM forms_form_fields WHERE form_id="'.$form_id.'"');
			// foreach ( $restrict_result as $key=>$val ) {
			// 	$restrict_criteria[] = '"'.$val['forms_form_fields']['field_id'].'"';
			// }
			
			// $criteria = array();
			// $criteria[] = 'FormField.id IN ('.implode(',',$restrict_criteria).')';
			
		vlist( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		// $this->set( 'fields_data', $this->FormField->findAll( $criteria, NULL, $order, $limit, $page ) );
		
			$criteria = array();
			$criteria[] = 'FormFormat.form_id="'.$form_id.'"';
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'fields_data', $this->FormFormat->findAll( $criteria, NULL, $order, $limit, $page ) );
		
	}
	
	function detail( $form_id=0, $format_id=0 ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_76', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('fields') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		$this->set( 'field_id', $format_id );
		
		$this->FormFormat->id = $format_id;
		$this->set( 'data', $this->FormFormat->read() );
	}
	
	function add( $form_id=0 ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('fields') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_76', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('fields') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		
		if ( !empty($this->data) ) {
			
			if ( $this->FormField->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/form_formats/index/'.$form_id );
			}
			
		}
		
	}
	
	function edit( $form_id=0, $format_id=0 ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('fields') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_72', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_72', 'core_CAN_76', $form_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('fields') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'form_id', $form_id );
		$this->set( 'format_id', $format_id );
		
		if ( empty($this->data) ) {
			
			$this->FormFormat->id = $format_id;
			$this->data = $this->FormFormat->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->FormFormat->save($this->data['FormFormat']) && $this->FormField->save($this->data['FormField']) ) {
				$this->flash( 'your data has been updated','/form_formats/detail/'.$form_id.'/'.$format_id );
			}
			
		}
	}
	*/

}

?>