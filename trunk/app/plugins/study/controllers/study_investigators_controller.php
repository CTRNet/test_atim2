<?php

class StudyInvestigatorsController extends StudyAppController {
	
	var $name = 'StudyInvestigators';
	var $uses = array('StudyInvestigator');

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
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_106', $study_summary_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_investigators') );
		
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
		$this->set( 'study_investigators', $this->StudyInvestigator->findAll( $criteria, NULL, $order, $limit, $page ) );
	}

	function add( $study_summary_id=null, $study_investigator_id=null ) {
    
    		// setup MODEL(s) validation array(s) for displayed FORM 
    		foreach ( $this->Forms->getValidateArray('study_investigators') as $validate_model=>$validate_rules ) {
     	 		$this->{ $validate_model }->validate = $validate_rules;
    		}
    
    	// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
    	$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_106', $study_summary_id );
	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_investigators') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
   
    	// set SIDEBAR variable, for HELPER call on VIEW 
   		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

	$this->set( 'study_summary_id', $study_summary_id );

    	if ( !empty($this->data) ) {
			if ( $this->StudyInvestigator->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/study_investigators/detail/'.$study_summary_id.'/'.$this->StudyInvestigator->getLastInsertId() );
      		} else {
				print_r($this->params['data']);
      		}      
    	}
  	}
  	
	function edit( $study_summary_id=null, $study_investigator_id=null ) {
    	// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('study_investigators') as $validate_model=>$validate_rules ) {
    		$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_106', $study_summary_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_investigators') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    		$this->set( 'study_summary_id', $study_summary_id );
		$this->StudyInvestigator->id = $study_investigator_id;
		if ( empty($this->data) ) {
			$this->data = $this->StudyInvestigator->read();
      		$this->set( 'data', $this->data );
		} else {    
      		if ( $this->StudyInvestigator->save( $this->data['StudyInvestigator'] ) ) {
				$this->flash( 'Your data has been updated.','/study_investigators/detail/'.$study_summary_id.'/'.$study_investigator_id );
      		} else {
				print_r($this->params['data']);
      		}      
	    }
  	}
	
	function detail( $study_summary_id=null, $study_investigator_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_106', $study_summary_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_investigators') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'study_summary_id', $study_summary_id );
		
		$this->StudyInvestigator->id = $study_investigator_id;
		$this->set( 'data', $this->StudyInvestigator->read() );
	}
  
	function delete( $study_summary_id=null, $study_investigator_id=null ) {
    
    		$this->StudyInvestigator->del( $study_investigator_id );
    		$this->flash( 'Your data has been deleted.', '/study_investigators/listall/'.$study_summary_id.'/' );
  	}
}

?>
