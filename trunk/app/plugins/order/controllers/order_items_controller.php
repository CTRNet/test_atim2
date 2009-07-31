<?php

class OrderItemsController extends OrderAppController {
	
	var $uses = array('Order.OrderItem', 'Order.Order', 'Order.OrderLine');
	var $paginate = array('OrderItem'=>array('limit'=>'10','order'=>'OrderItem.barcode'));
	
	function listall( $order_id=null, $order_line_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', NULL, TRUE ); }

		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.orderline_id'=>$order_line_id));
			
	}

	function add( $order_id=null, $order_line_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		if ( !empty($this->data) ) {
			$this->data['OrderItem']['orderline_id'] = $order_line_id;
			if ( $this->OrderItem->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/order_items/detail/'.$order_id.'/'.$order_line_id.'/'.$this->OrderItem->id );
			}
		}
	}
	
	function edit( $order_id=null, $order_line_id=null, $order_item_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', NULL, TRUE ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id, 'OrderItem.id'=>$order_item_id) );
		
		if ( !empty($this->data) ) {
			$this->OrderItem->id = $order_item_id;
			if ( $this->OrderItem->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/order_items/detail/'.$order_id.'/'.$order_line_id.'/'.$order_item_id );
			}
		} else {
			$this->data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id)));
		}
	}
	
	function detail( $order_id=null, $order_line_id=null, $order_item_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', NULL, TRUE ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id, 'OrderItem.id'=>$order_item_id) );
		$this->data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id)));
	}
	
	function shipment_items ( $order_id=null, $shipment_id=null ){
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$shipment_id ) { $this->redirect( 'pages/err_ord_no_ship_id', NULL, TRUE ); }
		
		$this->set('atim_menu', $this->Menus->get('/order/order_items/shipment_items/%%Order.id%%/%%Shipment.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id));
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.shipment_id'=>$shipment_id));
	}
	
	function delete( $order_id=null, $order_line_id=null, $order_item_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', NULL, TRUE ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', NULL, TRUE ); }
		
		if( $this->OrderItem->del( $order_item_id ) ) {
			$this->flash( 'Your data has been deleted.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id );
		}
	}
	
	function deleteFromShipment( $order_id=null,$order_item_id=null ){
		if( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if( !$order_item_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->data = $this->OrderItem->find('first', array('conditions'=>array('OrderItem.id'=>$order_item_id)));
		
		$shipment_id = $this->data['OrderItem']['shipment_id'];
		$this->data['OrderItem']['shipment_id'] = NULL;
		
		//Turned off validations because its not working
		if($this->OrderItem->save($this->data, false)){
			$this->flash( 'Your order item was removed from shipment.', '/order/order_items/shipment_items/'.$order_id.'/'.$shipment_id.'/' );
		}else{
			$this->flash( 'Your order item was not removed from shipment.', '/order/order_items/shipment_items/'.$order_id.'/'.$shipment_id.'/' );
		}
	}
	
	function manage_shipments( $order_id=null, $order_line_id=null ){
		if( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if( !$order_line_id ) { $this->redirect('/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.orderline_id'=>$order_line_id));
	}
	
	function manage_unshipped_items( $order_id=null, $order_line_id=null ){
		if( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if( !$order_line_id ) { $this->redirect('/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		
	}
/*	
	function obsolete_datagrid( $order_id=null, $orderline_id=null ) {
		
		//TODO
		
	}
	
	function manageUnshippedItems( $order_id=null, $orderline_id=null ) {
		
		// set MENU varible for echo on VIEW
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_117', $order_id.'/'.$orderline_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderitems') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'order_id', $order_id ); 
		$this->set( 'orderline_id', $orderline_id );
		
		$criteria = array();
		$criteria['orderline_id'] = $orderline_id;
		$criteria[] = "status NOT IN ('shipped')";
		$criteria = array_filter($criteria);
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$item_list = $this->OrderItem->findAll($criteria, NULL, $order);
		$this->set( 'data',  $item_list);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// if DATA submitted...
		if ( !empty($this->data) ) {
				
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE each row separately, setting the FLAG to FALSE if ANY row has a problem
			foreach ( $this->data as $key=>$val ) {
				if ( !$this->OrderItem->validates( $val ) ) {
					$submitted_data_validates = false;
				}
			}
			
			// if ALL the rows VALIDATE, then save each row separately, otherwise display errors
			if ( $submitted_data_validates ) {
				
				// save each ROW
				foreach ( $this->data as $key=>$val ) {
					$this->OrderItem->save( $val );
				}
				
				$this->flash( 'Your data has been saved.', '/order_items/listall/'.$order_id.'/'.$orderline_id.'/' );
				exit;
			
			} else {
				
				// extra ERROR message, which FORMS HELPER will translate normally
				// $this->OrderItem->validationErrors[] = 'untranslated custom error message here';
				
			}
			
		}
		
	}
	
	function manageShipments( $order_id=null, $orderline_id=null ) {
		
		// set MENU varible for echo on VIEW
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_117', $order_id.'/'.$orderline_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('manage_shipments') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'order_id', $order_id ); 
		$this->set( 'orderline_id', $orderline_id );
		
		$criteria = array();
		$criteria['orderline_id'] = $orderline_id;
		$criteria[] = "status NOT IN ('shipped')";
		$criteria = array_filter($criteria);
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$item_list = $this->OrderItem->findAll($criteria, NULL, $order);
		$this->set( 'data',  $item_list);
		
		// Populate Shipment dropdown from shipments table
		$option_criteria = 'Shipment.order_id="'.$order_id.'"';
		$fields = NULL;
		$order = 'Shipment.shipment_code ASC';
		$shipment_id_findall_result = $this->Shipment->findAll( $option_criteria, $fields, $order );
		$shipment_id_findall = array();
		$shipments_details = array();
		foreach ( $shipment_id_findall_result as $record ) {

			$shipment_id_findall[ $record['Shipment']['id'] ] = $record['Shipment']['shipment_code'].
				( $record['Shipment']['delivery_street_address'] ? ', '.$record['Shipment']['delivery_street_address'] : '' ).
				( $record['Shipment']['delivery_city'] ? ', '.$record['Shipment']['delivery_city'] : '' ).
				( $record['Shipment']['delivery_province'] ? ', '.$record['Shipment']['delivery_province'] : '' ).
				( $record['Shipment']['delivery_country'] ? ', '.$record['Shipment']['delivery_country'] : '' );

			$shipments_details[ $record['Shipment']['id'] ] = array(
				'shipment_code' => $record['Shipment']['shipment_code'],
				'datetime_shipped' => $record['Shipment']['datetime_shipped']);
			
		}
		
		$this->set( 'shipment_id_findall', $shipment_id_findall );
		
		if(empty($shipment_id_findall)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;		
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// if DATA submitted...
		if ( !empty($this->data) ) {
									
			$items_to_update = array();
			$submitted_data_validates = true;
			foreach($this->data as $key => $new_studied_item) {
				
				if(strcmp($new_studied_item['FunctionManagement']['generated_field_ship'], 'yes') == 0) {
					// Item defined as shipped
					
					// Track shipped item data
					$new_studied_item['OrderItem']['status'] = 'shipped';
					
					// VALIDATE each row separately, setting the FLAG to FALSE if ANY row has a problem
					if ( !$this->OrderItem->validates( $new_studied_item['OrderItem'] ) ) {
						$submitted_data_validates = false;
					}
					
					// Create use record
					// VALIDATE each row separately, setting the FLAG to FALSE if ANY row has a problem
//					if ( !$this->AliquotUse->validates( $new_studied_item['AliquotUse'] ) ) {
//						$submitted_data_validates = false;
//					}
					
					$items_to_update[] = array('OrderItem' => $new_studied_item['OrderItem']);
					
				}
				
				
			}
			
			if(empty($items_to_update)) {
				$this->flash( 'No data to update.', '/order_items/listall/'.$order_id.'/'.$orderline_id.'/' );
				exit;
			}
			
			// if ALL the rows VALIDATE, then save each row separately, otherwise display errors
			if ( $submitted_data_validates ) {
				
				// save each ROW
				$save_validates = true;
				foreach ($items_to_update as $key=>$val ) {
									
					// Get main information
					$aliquot_master_id = $val['OrderItem']['aliquot_master_id'];
					$shipment_data = $shipments_details[$val['OrderItem']['shipment_id']];
					
					// 1- Update the status of the aliquot
					
					// Check aliquot data
					$aliquot_criteria = '';
					$aliquot_criteria = "AliquotMaster.id = '$aliquot_master_id'";
					$aliquot_result = $this->AliquotMaster->findAll( $aliquot_criteria );
					
					if(empty($aliquot_result)) {
						// The aliquot id does not exists
						$this->redirect('/pages/err_order_system_error'); 
						exit;
					} else if(sizeof($aliquot_result) > 1) {
						$this->redirect('/pages/err_order_system_error'); 
						exit;
					}
					
					// Upadet aliquot data
					$shipped_aliquot = $aliquot_result[0]['AliquotMaster'];
					$shipped_aliquot['status'] = 'not available';
					$shipped_aliquot['status_reason'] = 'shipped';
					$shipped_aliquot['storage_master_id'] = NULL;
					$shipped_aliquot['storage_coord_x'] = NULL;
					$shipped_aliquot['storage_coord_y'] = NULL;
					
					if(!$this->AliquotMaster->save($shipped_aliquot)) {
						$save_validates = false;
						break;
					}
					
					// 2- Record use
					
					$aliquot_use_data = array();
					$aliquot_use_data['id'] = NULL;
					$aliquot_use_data['aliquot_master_id'] = $aliquot_master_id;
					
					$aliquot_use_data['use_definition'] = 'aliquot shipment';
					$aliquot_use_data['use_details'] = $shipment_data['shipment_code'];
					$aliquot_use_data['use_recorded_into_table'] = 'order_items';	
					$aliquot_use_data['use_datetime'] = $shipment_data['datetime_shipped'];
					
					if(! $this->AliquotUse->save( $aliquot_use_data )) {
						$save_validates = false;
						break;
					}
					
					$aliquot_use_id = $this->AliquotUse->getLastInsertId();		
					
					// 3- Record Order Item Update
					$val['OrderItem']['aliquot_use_id'] = $aliquot_use_id;
					
					if(! $this->OrderItem->save( $val )) {
						$save_validates = false;
						break;
					}
					
							
									
				}
				
				if($save_validates) {
					$this->flash( 'Your data has been saved.', '/order_items/listall/'.$order_id.'/'.$orderline_id.'/' );
					exit;	
				} else {
					$this->redirect('/pages/err_order_system_error'); 
					exit;					
				}
			
			}
			
		}
		
	}
	
	function add( $order_id=null, $orderline_id=null ) {
		
 		// set MENU varible for echo on VIEW
    	// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_117', $order_id.'/'.$orderline_id );
    	$this->set( 'ctrapp_menu', $ctrapp_menu );
    
   		// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderitems') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
								 
		$this->set( 'order_id', $order_id ); 
		$this->set( 'orderline_id', $orderline_id );
		
//		// Populate Shipment dropdown from shipments table
//		$option_criteria = 'Shipment.order_id="'.$order_id.'"';
//		$fields = NULL;
//		$order = 'Shipment.shipment_code ASC';
//		$shipment_id_findall_result = $this->Shipment->findAll( $option_criteria, $fields, $order );
//		$shipment_id_findall = array();
//		foreach ( $shipment_id_findall_result as $record ) {
//			$shipment_id_findall[ $record['Shipment']['id'] ] = $record['Shipment']['shipment_code'];
//		}
//		$this->set( 'shipment_id_findall', $shipment_id_findall );
						 
		if ( !empty($this->data) ) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
	    	foreach ( $this->Forms->getValidateArray('orderitems') as $validate_model=>$validate_rules ) {
	      		$this->{ $validate_model }->validate = $validate_rules;
	    	}
    
    		// Search aliquot master id
			$aliquot_master_id = NULL;
			if(isset($this->data['OrderItem']['barcode']) 
			&& (!empty($this->data['OrderItem']['barcode']))) {
				$aliq_barcode = $this->data['OrderItem']['barcode'];
				
				$aliquot_criteria = '';
				$aliquot_criteria = "AliquotMaster.barcode = '$aliq_barcode'";
				$aliquot_result = $this->AliquotMaster->findAll( $aliquot_criteria );
				
				if(empty($aliquot_result)) {
					// The aliquot barocde does not exists
					$this->data['OrderItem']['barcode'] = '';
				} else {
					if(sizeof($aliquot_result) > 1) {
						$this->data['OrderItem']['barcode'] = ''; 
						$this->OrderItem->validationErrors[] 
							= "at least 2 aliquots have this defined barcode";
					} else {
						// Set the aliquot master id
						$aliquot_master_id = $aliquot_result[0]['AliquotMaster']['id'];
						$this->data['OrderItem']['aliquot_master_id'] = $aliquot_master_id;
					}
				}
				
			}
			
			// Set status of the order
			$this->data['OrderItem']['status'] = 'pending';
			
			$submitted_data_validates = TRUE;
			
			// Validates Fields
			if(!$this->OrderItem->validates($this->data['OrderItem'])){
				$submitted_data_validates = FALSE;
			}
			
			// Verify aliquot has not already been defined as an order item
			if($submitted_data_validates) {
				$criteria = 'OrderItem.aliquot_master_id ="' .$aliquot_master_id.'"';			 
				$aliquot_order_nbr = $this->OrderItem->findCount($criteria);	
				if($aliquot_order_nbr > 0) {
					$submitted_data_validates = FALSE;
					$this->OrderItem->validationErrors[] = "the aliquot has already been included into an order item";	
				}
			}
			
			if($submitted_data_validates) {
		    	if ( $this->OrderItem->save( $this->data ) ) {
		    		
		    		// update the status of the aliquot
		    		if(is_null($aliquot_master_id)) {
						$this->redirect('/pages/err_order_system_error'); 
						exit;
		    		}
		    		
		    		$aliq_mast_update = array(
						'id' => $aliquot_master_id,
						'status' => 'not available',
						'status_reason' => 'reserved for order',
						'modified' => date('Y-m-d G:i'),
						'modified_by' => $this->othAuth->user('id'));
							
					if($this->AliquotMaster->save($aliq_mast_update)) {
						$this->flash( 'Your data has been saved.',
							'/order_items/detail/'.$order_id.'/'.$orderline_id.'/'.$this->OrderItem->getLastInsertId() );					
					} else {
						$this->redirect('/pages/err_order_system_error'); 
						exit;
					}	    		
	
	      		}
			}
      		     
    	}		
 	}
  
	function edit( $order_id=null, $orderline_id=null, $orderitem_id=null ) {
	
 		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('orderitems') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
    	}
    
    	// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_117', $order_id.'/'.$orderline_id );
//    	$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_117', 'ord_CAN_118', $order_id.'/'.$orderline_id.'/'.$orderitem_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
    
    	// set FORM variable, for HELPER call on VIEW 
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderitems') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
    
    	// set SIDEBAR variable, for HELPER call on VIEW 
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		$this->set( 'order_id', $order_id);
		$this->set( 'orderline_id', $orderline_id);

		// Populate Shipment dropdown from shipments table
//		$option_criteria = 'Shipment.order_id="'.$order_id.'"';
//		$fields = NULL;
//		$order = 'Shipment.shipment_code ASC';
//		$shipment_id_findall_result = $this->Shipment->findAll( $option_criteria, $fields, $order );
//		$shipment_id_findall = array();
//		foreach ( $shipment_id_findall_result as $record ) {
//			$shipment_id_findall[ $record['Shipment']['id'] ] = $record['Shipment']['shipment_code'];
//		}
//		$this->set( 'shipment_id_findall', $shipment_id_findall );
								 
		$this->OrderItem->id = $orderitem_id;
		$item_data = $this->OrderItem->read();		
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
		
		if ( empty($this->data) ) {
    		$this->data = $item_data;
    		$this->set( 'data', $this->data );
    	} else {
    		$this->OrderLine->id = $orderline_id;	  
    		if ( $this->OrderItem->save( $this->data['OrderItem'] ) ) {
				$this->flash( 'Your data has been updated.','/order_items/detail/'.$order_id.'/'.$orderline_id.'/'.$orderitem_id );
      		} else {
				//print_r($this->params['data']);
      		}      
    	} 
	}
  
 	function detail( $order_id=null, $orderline_id=null, $orderitem_id=null ) {
 		// set MENU varible for echo on VIEW 
    	// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_114', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_114', 'ord_CAN_117', $order_id.'/'.$orderline_id );
//		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_117', 'ord_CAN_118', $order_id.'/'.$orderline_id.'/'.$orderitem_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderitems') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'order_id', $order_id );
		$this->set( 'orderline_id', $orderline_id );
		
		$allow_deletion = FALSE;
		if($this->allowOrderItemDeletion($orderitem_id)) {
			$allow_deletion = TRUE; 			
  		}
		$this->set( 'allow_deletion', $allow_deletion );
				
		// Populate Shipment dropdown from shipments table
		$option_criteria = 'Shipment.order_id="'.$order_id.'"';
		$fields = NULL;
		$order = 'Shipment.shipment_code ASC';
		$shipment_id_findall_result = $this->Shipment->findAll( $option_criteria, $fields, $order );
		$shipment_id_findall = array();
		foreach ( $shipment_id_findall_result as $record ) {
			$shipment_id_findall[ $record['Shipment']['id'] ] = $record['Shipment']['shipment_code'];
		}
		$this->set( 'shipment_id_findall', $shipment_id_findall );
		
		$this->OrderItem->id = $orderitem_id;
		$this->set( 'data', $this->OrderItem->read() ); 
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
	}
  
	function delete( $order_id=null, $orderline_id=null, $orderitem_id=null ) {
		
		if(!$this->allowOrderItemDeletion($orderitem_id)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;  			
  		}
  		
  		$criteria = 'OrderItem.id ="' .$orderitem_id.'"';		 
		$order_item = $this->OrderItem->find($criteria);
  		
 		// ** Update aliquot status **
		$bool_delete_aliquot_from_line = TRUE;
	
		// Update the status of the aliquot
		$aliq_mast_update = array(
			'id' => $order_item['OrderItem']['aliquot_master_id'],
			'status' => 'available',
			'status_reason' => '',
			'modified' => date('Y-m-d G:i'),
			'modified_by' => $this->othAuth->user('id'));
			
		if(!$this->AliquotMaster->save($aliq_mast_update)){
			$bool_delete_aliquot_from_line = FALSE;		
		}
		
		if($bool_delete_aliquot_from_line && ($this->OrderItem->del( $orderitem_id ))){
	    	$this->flash( 'Your data has been deleted.', '/order_items/listall/'.$order_id.'/'.$orderline_id.'/' );
		} else {
			$this->redirect('/pages/err_order_system_error'); 
			exit;  					
		}	 		
  		  		
	}
	
	function shipment_items( $order_id=null, $shipment_id=null ) {
		
		// set MENU varible for echo on VIEW 
		// $ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_102', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_101', 'ord_CAN_116', $order_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'ord_CAN_116', 'ord_CAN_120', $order_id.'/'.$shipment_id.'/' );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
	
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('orderitems') );
		
		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $order_id ) );
	
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
			
		$this->set( 'order_id', $order_id);
		
		$criteria = array();
		$criteria['shipment_id'] = $shipment_id;
		$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'orderitems', $this->OrderItem->findAll( $criteria, NULL, $order, $limit, $page ) );
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
			
	}
	
	
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	
	
	function process_add_aliquots( $order_id=null, $orderline_id=null ) {
		
		// set data for easier access
		$process_data = $_SESSION['ctrapp_core']['datamart']['process'];
		
		// kick out to DATAMART if no BATCH data
		$bool_all_aliquots_managed = TRUE;
		
		if ( !isset($process_data['AliquotMaster']) || !is_array($process_data['AliquotMaster']) || !count($process_data['AliquotMaster']) ) {
			$bool_all_aliquots_managed = FALSE;
		}
		
		if($bool_all_aliquots_managed) {
			
			// get Aliquots beeing already included to an order item
			$aliquot_criteria = 'OrderItem.aliquot_master_id IN ('.implode( ',', $process_data['AliquotMaster']['id'] ).')';
			$aliquot_already_included_into_order
				= $this->OrderItem->generateList(
						$aliquot_criteria, 
						null, 
						null, 
						'{n}.OrderItem.aliquot_master_id', 
						'{n}.OrderItem.aliquot_master_id');
			
//			// find EXISTING aliquots in LINE
//			$existing_items_criteria = '';
//			$existing_items_criteria = 'OrderItem.orderline_id="'.$orderline_id.'"';
//			$existing_items_result = $this->OrderItem->findAll( $existing_items_criteria );
//			
//			// remove IDs from BATCH data if already in LINE
//			foreach ($existing_items_result as $key=>$val) {
//				if ($val['OrderItem']['aliquot_master_id']) {
//					if ( in_array($val['OrderItem']['aliquot_master_id'],$process_data['AliquotMaster']['id']) ) {
//						unset($process_data['AliquotMaster']['id'][ array_search($val['OrderItem']['aliquot_master_id'], $process_data['AliquotMaster']['id']) ]);
//					}
//				}
//			}
			
			// get ALIQUOTS matching BATCH data (IDs)
			$aliquot_criteria = '';
			$aliquot_criteria = 'AliquotMaster.id IN ('.implode( ',', $process_data['AliquotMaster']['id'] ).')';
			$aliquot_result = $this->AliquotMaster->findAll( $aliquot_criteria );
		
			if ( is_array($aliquot_result) && count($aliquot_result) ) {
				
				// ADD each ALIQUOT to LINE's ITEMs
				foreach ($aliquot_result as $key=>$val) {
					
					if(isset($aliquot_already_included_into_order[$val['AliquotMaster']['id']])) {
						// This aliquot has already been attached to another order...
						$bool_all_aliquots_managed = FALSE;
					
					} else {
					
						$add_aliquot_data = array();
						$add_aliquot_data['OrderItem'] = array();
						$add_aliquot_data['OrderItem']['id'] = NULL;
						$add_aliquot_data['OrderItem']['barcode'] = $val['AliquotMaster']['barcode'];
						$add_aliquot_data['OrderItem']['date_added'] = date('Y-m-d');
						$add_aliquot_data['OrderItem']['added_by'] = '';	//$this->othAuth->user('first_name').' '.$this->othAuth->user('last_name');
						$add_aliquot_data['OrderItem']['status'] = 'pending';
						$add_aliquot_data['OrderItem']['created'] = date('Y-m-d G:i');
						$add_aliquot_data['OrderItem']['created_by'] = $this->othAuth->user('id');
						$add_aliquot_data['OrderItem']['modified'] = date('Y-m-d G:i');
						$add_aliquot_data['OrderItem']['modified_by'] = $this->othAuth->user('id');
						$add_aliquot_data['OrderItem']['orderline_id'] = $orderline_id;
						$add_aliquot_data['OrderItem']['aliquot_master_id'] = $val['AliquotMaster']['id'];
						
						$add_aliquot_result = $this->OrderItem->save( $add_aliquot_data );
						
						// Update the status of the aliquot
						$aliq_mast_update = array(
							'id' => $val['AliquotMaster']['id'],
							'status' => 'not available',
							'status_reason' => 'reserved for order',
							'modified' => date('Y-m-d G:i'),
							'modified_by' => $this->othAuth->user('id'));
								
						$this->AliquotMaster->save($aliq_mast_update);	
					
					}
	
				}
				
			}
		}
				
		// empty PROCESS data, process complete
		unset($process_data);
		unset($_SESSION['ctrapp_core']['datamart']['process']);
		
		// REDIRECT to LINE's ITEMs
		if($bool_all_aliquots_managed) {
			$this->flash( 'Your data has been updated.', '/order_items/listall/'.$order_id.'/'.$orderline_id );
		} else {
			$this->flash( 'the process has been done but a part of the aliquots have not been ' .
					'included', '/order_items/listall/'.$order_id.'/'.$orderline_id );			
		}
		
	}
	
	function deleteFromShipment($order_id=null, $orderitem_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($order_id) || empty($orderitem_id)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;
		}
		
		// * Verify the existing of the order item **
		$criteria = array();		
		$criteria['OrderItem.id'] = $orderitem_id;
		
		$oder_item_data = $this->OrderItem->find($criteria, null, null, 0);		

		if(empty($oder_item_data)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;
		}
				
		$criteria = array();		
		$criteria['OrderLine.id'] = $oder_item_data['OrderItem']['orderline_id'];
		$criteria['OrderLine.order_id'] = $order_id;
		
		$oder_line_data = $this->OrderLine->find($criteria, null, null, 0);					
		
		if(empty($oder_line_data)) {
			$this->redirect('/pages/err_order_system_error'); 
			exit;
		}
		
		// * Check in AliquotUse **
		$aliquot_use_id = $oder_item_data['OrderItem']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $oder_item_data['OrderItem']['aliquot_master_id'];
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_order_system_error'); 
			exit;		
		}	
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Use Record **
		$bool_delete_aliquot_from_shipment = TRUE;
	
		if(!$this->AliquotUse->del($aliquot_use_id)){
			$bool_delete_aliquot_from_shipment = FALSE;		
		}
		
		// Update the status of the aliquot
		$aliq_mast_update = array(
			'id' => $oder_item_data['OrderItem']['aliquot_master_id'],
			'status' => 'not available',
			'status_reason' => 'reserved for order',
			'modified' => date('Y-m-d G:i'),
			'modified_by' => $this->othAuth->user('id'));
			
		if(!$this->AliquotMaster->save($aliq_mast_update)){
			$bool_delete_aliquot_from_shipment = FALSE;		
		}			
		
		// Update order	
		$orer_item_update = array();
		$orer_item_update['id'] = $orderitem_id;
		$orer_item_update['status'] = 'pending';
		$orer_item_update['shipment_id'] = NULL;
		$orer_item_update['aliquot_use_id'] = NULL;
		$orer_item_update['modified'] = date('Y-m-d G:i');
		$orer_item_update['modified_by'] = $this->othAuth->user('id');
		
		if(!$this->OrderItem->save($orer_item_update)){
			$bool_delete_aliquot_from_shipment = FALSE;		
		}
		
		if(!$bool_delete_aliquot_from_shipment){
			$this->redirect('/pages/err_order_system_error'); 
			exit;
		}
		
		$this->flash( 'Your data has been updated.', '/order_items/listall/'.$order_id.'/'.$oder_item_data['OrderItem']['orderline_id'] );
		
	}
	
	function allowOrderItemDeletion($orderitem_id){
		
		// Verify order item is not attached to the shipment	
		$criteria = 'OrderItem.id ="' .$orderitem_id.'"';		 
		$order_item = $this->OrderItem->find($criteria);
		
		if((strcmp($order_item['OrderItem']['status'], "shipped") == 0)
		|| (!empty($order_item['OrderItem']['shipment_id']))) {
			return FALSE;
		}
				
		// Etc...
		
		return TRUE;
	}
*/	
}
?>