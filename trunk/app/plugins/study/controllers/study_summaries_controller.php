<?php

class StudySummariesController extends StudyAppController {
	
	var $name = 'StudySummaries';
	var $uses = array('StudySummary',
		'StudyContact', 'StudyEthicsBoard', 'StudyFunding', 'StudyInvestigator', 'StudyRelated', 'StudyResult', 'StudyReview',
		'AliquotMaster', 'Order', 'AliquotUse');

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
	
	function listall( ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$this->set( 'ctrapp_menu', array() );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_summaries') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', array() );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		
		$criteria = array();
		$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'study_summaries', $this->StudySummary->findAll( $criteria, NULL, $order, $limit, $page ) );
		
	}

	function add() {
    
    	// setup MODEL(s) validation array(s) for displayed FORM 
    	foreach ( $this->Forms->getValidateArray('study_summaries') as $validate_model=>$validate_rules ) {
      		$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
    	$this->set( 'ctrapp_menu', array() );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_summaries') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', array() );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
   		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

    	if ( !empty($this->data) ) {
			if ( $this->StudySummary->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/study_summaries/detail/'.$this->StudySummary->getLastInsertId() );
      		} else {
				print_r($this->params['data']);
      		}      
    	}
  	}
  
	function edit( $study_summary_id=null ) {
    	// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('study_summaries') as $validate_model=>$validate_rules ) {
    		$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_104', $study_summary_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_summaries') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    	
		$this->StudySummary->id = $study_summary_id;
		if ( empty($this->data) ) {
			$this->data = $this->StudySummary->read();
      		$this->set( 'data', $this->data );
		} else {    
      		if ( $this->StudySummary->save( $this->data['StudySummary'] ) ) {
				$this->flash( 'Your data has been updated.','/study_summaries/detail/'.$study_summary_id );
      		} else {
				print_r($this->params['data']);
      		}      
	    }
  	}
	
	function detail( $study_summary_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_100', 'tool_CAN_103', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_103', 'tool_CAN_104', $study_summary_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('study_summaries') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($study_summary_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'study_summary_id', $study_summary_id );
		
		$this->StudySummary->id = $study_summary_id;
		$this->set( 'data', $this->StudySummary->read() );
	}
  
	function delete( $study_summary_id=null ) {
    
    	if(!$this->allowStudyDeletion($study_summary_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/study_summaries/detail/'.$study_summary_id );
			exit;
		}
	
		$this->StudySummary->del( $study_summary_id );
    	$this->flash( 'Your data has been deleted.', '/study_summaries/listall/' );
  	}
  	
  	function allowStudyDeletion($study_summary_id) {

		// Check additional study tabs
		$criteria = 'StudyContact.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyContact->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'StudyEthicsBoard.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyEthicsBoard->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'StudyFunding.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyFunding->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'StudyInvestigator.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyInvestigator->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'StudyRelated.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyRelated->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'StudyResult.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyResult->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}	
		
		$criteria = 'StudyReview.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->StudyReview->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Aliquot Matser
		$criteria = 'AliquotMaster.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->AliquotMaster->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Order
		$criteria = 'Order.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->Order->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Order
		$criteria = 'AliquotUse.study_summary_id ="' .$study_summary_id.'"';			 
		$record_nbr = $this->AliquotUse->findCount($criteria);	
		if($record_nbr > 0){
			return FALSE;
		}
				
		// Etc
		
		return TRUE;
	}
}

?>
