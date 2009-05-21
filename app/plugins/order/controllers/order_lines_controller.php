<?php

class OrderLinesController extends OrderAppController {
	
	var $name = 'OrderLines';
	var $uses = array('OrderLine', 'Order', 'OrderItem', 'SampleControl');

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
	
	function listall( $order_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
	
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderlines') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
	
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'order_id', $order_id );
		
		// Look for sample types
		$final_criteria = array();
		$final_criteria['status'] = 'active';
		$final_criteria = array_filter($final_criteria);
	
		$sample_types_list
			= $this->SampleControl->generateList(
				$final_criteria, 
				'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
				null, 
				'{n}.SampleControl.id', 
				'{n}.SampleControl.sample_type');
				
		$this->set( 'sample_types_list', $sample_types_list );

		$criteria = array();
		$criteria['order_id'] = $order_id;
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orderlines', $this->OrderLine->findAll( $criteria, NULL, $order, $limit, $page ) );
			
	}

 	function add( $order_id=null ) {
 		// setup MODEL(s) validation array(s) for displayed FORM 
    	foreach ( $this->Forms->getValidateArray('orderlines') as $validate_model=>$validate_rules ) {
      	$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
   		// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderlines') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		$this->set( 'order_id', $order_id );
		
		// Look for sample types
		$final_criteria = array();
		$final_criteria['status'] = 'active';
		$final_criteria = array_filter($final_criteria);
	
		$sample_types_list
			= $this->SampleControl->generateList(
				$final_criteria, 
				'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
				null, 
				'{n}.SampleControl.id', 
				'{n}.SampleControl.sample_type');
				
		$this->set( 'sample_types_list', $sample_types_list );
								 
		if ( !empty($this->data) ) {
	    	if ( $this->OrderLine->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/order_lines/detail/'.$order_id.'/'.$this->OrderLine->getLastInsertId() );
      		} else {
				//print_r($this->params['data']);
     		}      
    	}	
 	}
  
	function edit( $order_id=null, $orderline_id=null ) {
  
 		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('orderlines') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_115', $order_id.'/'.$orderline_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderlines') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		$this->set( 'order_id', $order_id);
		$this->set( 'orderline_id', $orderline_id);	
		
		// Look for sample types
		$final_criteria = array();
		$final_criteria['status'] = 'active';
		$final_criteria = array_filter($final_criteria);
	
		$sample_types_list
			= $this->SampleControl->generateList(
				$final_criteria, 
				'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
				null, 
				'{n}.SampleControl.id', 
				'{n}.SampleControl.sample_type');
				
		$this->set( 'sample_types_list', $sample_types_list );					 
								 
		if ( empty($this->data) ) {
    		$this->OrderLine->id = $orderline_id;
    		$this->data = $this->OrderLine->read();
    		$this->set( 'data', $this->data );
    	} else {
    		$this->Order->id = $order_id;	  
    		if ( $this->OrderLine->save( $this->data['OrderLine'] ) ) {
				$this->flash( 'Your data has been updated.','/order_lines/detail/'.$order_id.'/'.$orderline_id );
      		} else {
				//print_r($this->params['data']);
      		}      
    	}
	}
  
 	function detail( $order_id=null, $orderline_id=null ) {
  		
		// set MENU varible for echo on VIEW 
    	// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_115', $order_id.'/'.$orderline_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderlines') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

    	$allow_deletion = FALSE;		
		if($this->allowOrderLineDeletion($orderline_id)) {
    		$allow_deletion = TRUE;
    	}
		$this->set( 'allow_deletion', $allow_deletion );
    	
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'order_id', $order_id );
		$this->set( 'orderline_id', $orderline_id );
		
		// Look for sample types
		$final_criteria = array();
		$final_criteria['status'] = 'active';
		$final_criteria = array_filter($final_criteria);
	
		$sample_types_list
			= $this->SampleControl->generateList(
				$final_criteria, 
				'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
				null, 
				'{n}.SampleControl.id', 
				'{n}.SampleControl.sample_type');
				
		$this->set( 'sample_types_list', $sample_types_list );
		
		$this->OrderLine->id = $orderline_id;
		$this->set( 'data', $this->OrderLine->read() );
}
  
	function delete( $order_id=null, $orderline_id=null ) {
    
    	if(!$this->allowOrderLineDeletion($orderline_id)) {
    		$this->redirect('/pages/err_order_system_error'); 
			exit;
    	}
    		
    	$this->OrderLine->del( $orderline_id );
    	$this->flash( 'Your data has been deleted.', '/order_lines/listall/'.$order_id );
	}
	
	
	/*
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	*/
	
	function process_add_aliquots( $order_id=null ) {
		
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
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderlines') );
		
		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'order_id', $order_id );
		
		// Look for sample types
		$final_criteria = array();
		$final_criteria['status'] = 'active';
		$final_criteria = array_filter($final_criteria);
	
		$sample_types_list
			= $this->SampleControl->generateList(
				$final_criteria, 
				'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
				null, 
				'{n}.SampleControl.id', 
				'{n}.SampleControl.sample_type');
				
		$this->set( 'sample_types_list', $sample_types_list );

		$criteria = array();
		$criteria['order_id'] = $order_id;
		$criteria[] = 'OrderLine.status NOT IN ("shipped") OR OrderLine.status IS NULL';
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orderlines', $this->OrderLine->findAll( $criteria, NULL, $order, $limit, $page ) );
			
	}
	
	function allowOrderLineDeletion($orderline_id){
		
		// Verify no order item is attached to the line	
		$criteria = 'OrderItem.orderline_id ="' .$orderline_id.'"';			 
		$order_item_nbr = $this->OrderItem->findCount($criteria);
		
		if($order_item_nbr > 0){
			return FALSE;
		}
				
		// Etc...
		
		return TRUE;
	}
	
}

?>