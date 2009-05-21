<?php

class OrdersController extends OrderAppController {
	
	var $name = 'Orders';
	var $uses = array('Order', 'StudySummary', 'OrderLine', 'Shipment');

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
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$this->set( 'ctrapp_menu', array() );

    	$this->set( 'ctrapp_summary',  $this->Summaries->build() );
    		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orders') );
	
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$criteria = array();
		$criteria = array_filter($criteria);
	
		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orders', $this->Order->findAll( $criteria, NULL, $order, $limit, $page ) );
	}

	function add() {
		
 		// setup MODEL(s) validation array(s) for displayed FORM 
    	foreach ( $this->Forms->getValidateArray('orders') as $validate_model=>$validate_rules ) {
      		$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW
    	$this->set( 'ctrapp_menu', array() );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orders') );
    
    	$this->set( 'ctrapp_summary',  $this->Summaries->build() );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
		
		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );

		if ( !empty($this->data) ) {
	    	if ( $this->Order->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/orders/detail/'.$this->Order->getLastInsertId() );
      		} else {
				//print_r($this->params['data']);
     		}      
    	}  
 }
  
	function edit( $order_id=null ) {
  
 		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('orders') as $validate_model=>$validate_rules ) {
      	$this->{ $validate_model }->validate = $validate_rules;
    	}

		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_113', $order_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orders') );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    
		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );								 
								 					 
    	if ( empty($this->data) ) {
    		$this->Order->id = $order_id;
    		$this->data = $this->Order->read();
    		$this->set( 'data', $this->data );
    	} else {
    		$this->Order->id = $order_id;	  
    		if ( $this->Order->save( $this->data['Order'] ) ) {
				$this->flash( 'Your data has been updated.','/orders/detail/'.$order_id );
      		} else {
				//print_r($this->params['data']);
      		}      
    	}
	}
  
	function detail( $order_id=null ) {
  		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_113', $order_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orders') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'order_id', $order_id );
		
		$allow_deletion = FALSE;
		if($this->allowOrderDeletion($order_id)) {
    		$allow_deletion = TRUE;
    	}
 		$this->set( 'allow_deletion', $allow_deletion );   	
		
		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );
		
		$this->Order->id = $order_id;
		$this->set( 'data', $this->Order->read() );
	}
  
	function delete( $order_id=null ) {
    
    	if(!$this->allowOrderDeletion($order_id)) {
    		$this->redirect('/pages/err_order_system_error'); 
			exit;
    	}
    
    	$this->Order->del( $order_id );
   		$this->flash( 'Your data has been deleted.', '/orders/listall/' );
  }
 
	function index() {
		// clear SEARCH criteria, for pagination bug
		$_SESSION['ctrapp_core']['clinical_annotation']['search_criteria'] = NULL;

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orders') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );
	}
  
	function search( ) {
		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$ctrapp_form = $this->Forms->getFormArray('orders');
		$this->set( 'ctrapp_form', $ctrapp_form );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );		
		
		// if SEARCH form data, parse and create conditions
		if ( $this->data ) {
			$criteria = $this->Forms->getSearchConditions( $this->data, $ctrapp_form );
			$_SESSION['ctrapp_core']['order']['search_criteria'] = $criteria; // save CRITERIA to session for pagination
		} else {
			$criteria = $_SESSION['ctrapp_core']['order']['search_criteria']; // if no form data, use SESSION critera for PAGINATION bug
		}

		$no_pagination_order = '';
		$no_pagination_order = 'short_title ASC';

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orders', $this->Order->findAll( $criteria, NULL, $no_pagination_order, $limit, $page, 0, 2 ) );
	}
	
	function allowOrderDeletion($order_id){
		
		// Verify no order line is attached to the order	
		$criteria = 'OrderLine.order_id ="' .$order_id.'"';			 
		$order_line_nbr = $this->OrderLine->findCount($criteria);
		
		if($order_line_nbr > 0){
			return FALSE;
		}
		
		// Verify no order line is attached to the order	
		$criteria = 'Shipment.order_id ="' .$order_id.'"';			 
		$shipment_nbr = $this->Shipment->findCount($criteria);
		
		if($shipment_nbr > 0){
			return FALSE;
		}
		
				
		// Etc...
		
		return TRUE;
	}
	
	
	
  
	/*
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	*/
	
	function process_add_aliquots() {
		
		
		// set data for easier access
		$process_data = $_SESSION['ctrapp_core']['datamart']['process'];
		
		// kick out to DATAMART if no BATCH data
		if ( !isset($process_data['AliquotMaster']) || !is_array($process_data['AliquotMaster']) || !count($process_data['AliquotMaster']) ) {
			$this->redirect( '/datamart/batch_sets/index/' );
			exit;
		}
		
		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

    	$this->set( 'ctrapp_summary', array() );
    			
		// set FORM variable, for HELPER call on VIEW
		$ctrapp_form = $this->Forms->getFormArray('orders');
		$this->set( 'ctrapp_form', $ctrapp_form );
		
		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// Populate Study dropdown from study_summaries table
		$option_criteria = NULL;
		$fields = 'StudySummary.id, StudySummary.title';
		$order = 'StudySummary.title ASC';
		$study_summary_id_findall_result = $this->StudySummary->findAll( $option_criteria, $fields, $order );
		$study_summary_id_findall = array();
		foreach ( $study_summary_id_findall_result as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set( 'study_summary_id_findall', $study_summary_id_findall );		
		
		// get DATA for LISTALL form
		
		$criteria = 'Order.processing_status NOT IN ("completed") OR Order.processing_status IS NULL';
		$no_pagination_order = 'short_title ASC';
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orders', $this->Order->findAll( $criteria, NULL, $no_pagination_order, $limit, $page, 0, 2 ) );
		
	}
	
}
?>