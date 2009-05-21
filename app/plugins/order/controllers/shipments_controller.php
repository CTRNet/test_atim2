<?php

class ShipmentsController extends OrderAppController {
	
	var $name = 'Shipments';
	var $uses = array('Shipment', 'OrderItem', 'AliquotUse');

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
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_116', $order_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
	
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('shipments') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
	
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
			
		$this->set( 'order_id', $order_id);
		
		$criteria = array();
		$criteria['order_id'] = $order_id;
		$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'shipments', $this->Shipment->findAll( $criteria, NULL, $order, $limit, $page ) );
	}

	function add( $order_id=null ) {
 		// setup MODEL(s) validation array(s) for displayed FORM 
    	foreach ( $this->Forms->getValidateArray('shipments') as $validate_model=>$validate_rules ) {
      	$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '');
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_116', $order_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
   		// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('shipments') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		$this->set( 'order_id', $order_id );
								 
		if ( !empty($this->data) ) {
	    	if ( $this->Shipment->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/shipments/detail/'.$order_id.'/'.$this->Shipment->getLastInsertId() );
      		} else {
				//print_r($this->params['data']);
     		}      
    	}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
	
 		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('shipments') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_116', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_116', 'ord_CAN_119', $order_id.'/'.$shipment_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('shipments') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		$this->set( 'order_id', $order_id);
		$this->set( 'shipment_id', $shipment_id);
		
		$this->Shipment->id = $shipment_id;
    	$shipment_data = $this->Shipment->read();;						 
								 
		if ( empty($this->data) ) {
    		$this->data = $shipment_data;
    		$this->set( 'data', $this->data );
    	} else {
    		$this->Order->id = $order_id;	  
    		if ( $this->Shipment->save( $this->data['Shipment'] ) ) {
    			
    			// update shipped aliquots use data
				$old_shipment_code = $shipment_data['Shipment']['shipment_code'];
				$new_shipment_code = $this->data['Shipment']['shipment_code'];
				$old_shipment_date = $shipment_data['Shipment']['datetime_shipped'];
				$new_shipment_date = $this->data['Shipment']['datetime_shipped'];
				if((strcmp($old_shipment_code,$new_shipment_code)!=0) ||
				(strcmp($old_shipment_date,$new_shipment_date)!=0)) {
					$this->updateShippedAliquotUses($shipment_id, $new_shipment_code, $new_shipment_date);
				}
    			
				$this->flash( 'Your data has been updated.','/shipments/detail/'.$order_id.'/'.$shipment_id );
      		} else {
				//print_r($this->params['data']);
      		}      
    	}  
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
  			
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_116', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_116', 'ord_CAN_119', $order_id.'/'.$shipment_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('shipments') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$allow_deletion = FALSE;
		if($this->allowShipmentDeletion($shipment_id)) {
			$allow_deletion = TRUE;			
		}
		$this->set( 'allow_deletion', $allow_deletion );
		
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'order_id', $order_id );
		
		$this->Shipment->id = $shipment_id;
		$this->set( 'data', $this->Shipment->read() );
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
  
  		if(!$this->allowShipmentDeletion($shipment_id)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;  			
  		}
  
    	$this->Shipment->del( $shipment_id );
    	$this->flash( 'Your data has been deleted.', '/shipments/listall/'.$order_id );
	}
	
	function allowShipmentDeletion($shipment_id){
		
		// Verify no order item is attached to the shipment	
		$criteria = 'OrderItem.shipment_id ="' .$shipment_id.'"';			 
		$order_item_nbr = $this->OrderItem->findCount($criteria);
		
		if($order_item_nbr > 0){
			return FALSE;
		}
				
		// Etc...
		
		return TRUE;
	}
	
	function updateShippedAliquotUses($shipment_id, $new_shipment_code, $new_shipment_date) {
		
		$this->OrderItem->bindModel(array('belongsTo' => 
			array('AliquotUse' => array(
					'className' => 'AliquotUse',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_use_id'))));
		
		$criteria = array();
		$criteria['OrderItem.shipment_id'] = $shipment_id;
		$criteria = array_filter($criteria);
		
		$aliquot_uses = $this->OrderItem->findAll($criteria, null, null, null, 1);
		
		if(!empty($aliquot_uses)) {
			foreach($aliquot_uses as $tmp => $shipped_aliquot_use_data) {
				$this->updateAliquotUseDetailAndDate($shipped_aliquot_use_data['AliquotUse']['id'], 
					$shipped_aliquot_use_data['AliquotUse']['aliquot_master_id'], 
					$new_shipment_code, 
					$new_shipment_date);
			}
		}	
	
	}
	
	function updateAliquotUseDetailAndDate($aliquot_use_id, $aliquot_master_id, $details, $date) {
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		$aliquot_use_data['AliquotUse']['use_details'] = $details;
		$aliquot_use_data['AliquotUse']['use_datetime'] = $date;
		
		if(!$this->AliquotUse->save($aliquot_use_data['AliquotUse'])){
			$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
			exit;
		}
		
	}
}

?>