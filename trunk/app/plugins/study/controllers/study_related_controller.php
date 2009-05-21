<?php

class StudyRelatedController extends StudyAppController {
	
	var $name = 'StudyRelated';
	var $uses = array('StudyRelated');

	var $useDbConfig = 'default';

	var $components = array('Summaries');
	
	var $helpers = array('Summaries');
  
	function beforeFilter() {
    
    	// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
	    $this->othAuth->controller = &$this;
    	$this->othAuth->init();
    	$this->othAuth->check();

    	// CakePHP function to re-combine dat/time select fields 
    	$this->cleanUpFields();
  	}
	
	function listall( $study_summary_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_112', $study_summary_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_related') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'study_summary_id', $study_summary_id );
		$criteria = array();
		$criteria['study_summary_id'] = $study_summary_id;
		$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'study_related', $this->StudyRelated->findAll( $criteria, NULL, $order, $limit, $page ) );
	}

	function add( $study_summary_id=null, $study_related_id=null ) {
    
    		// setup MODEL(s) validation array(s) for displayed FORM 
    		foreach ( $this->Forms->getValidateArray('study_related') as $validate_model=>$validate_rules ) {
     	 		$this->{ $validate_model }->validate = $validate_rules;
    		}
    
    	// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
    	$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_112', $study_summary_id );
	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_related') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
   		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

	$this->set( 'study_summary_id', $study_summary_id );

    	if ( !empty($this->data) ) {
			if ( $this->StudyRelated->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/study_related/detail/'.$study_summary_id.'/'.$this->StudyRelated->getLastInsertId() );
      		} else {
				print_r($this->params['data']);
      		}      
    	}
  	}
  
	function edit( $study_summary_id=null, $study_related_id=null ) {
    	// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('study_related') as $validate_model=>$validate_rules ) {
    		$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_112', $study_summary_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_related') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    		$this->set( 'study_summary_id', $study_summary_id );
		$this->StudyRelated->id = $study_related_id;
		if ( empty($this->data) ) {
			$this->data = $this->StudyRelated->read();
      		$this->set( 'data', $this->data );
		} else {    
      		if ( $this->StudyRelated->save( $this->data['StudyRelated'] ) ) {
				$this->flash( 'Your data has been updated.','/study_related/detail/'.$study_summary_id.'/'.$study_related_id );
      		} else {
				print_r($this->params['data']);
      		}      
	    }
  	}
	
	function detail( $study_summary_id=null, $study_related_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_112', $study_summary_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_related') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'study_summary_id', $study_summary_id );
		
		$this->StudyRelated->id = $study_related_id;
		$this->set( 'data', $this->StudyRelated->read() );
	}
	
	function delete( $study_summary_id=null, $study_related_id=null ) {
    
    		$this->StudyRelated->del( $study_related_id );
    		$this->flash( 'Your data has been deleted.', '/study_related/listall/'.$study_summary_id.'/' );
  	}
}

?>
