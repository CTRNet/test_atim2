<?php

class ShipmentsController extends OrderAppController {
	
	var $uses = array(
		'Order.Shipment', 
		'Order.Order', 
		'Order.OrderItem', 
		'Order.OrderLine', 
		
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.AliquotControl',
		'Inventorymanagement.AliquotUse');
		
	var $paginate = array('Shipment'=>array('limit'=>10,'order'=>'Shipment.datetime_shipped DESC'));

	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		
		
		// Get shipments
		$shipments_data = $this->paginate($this->Shipment, array('Shipment.order_id'=>$order_id));
		$this->data = $shipments_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( !empty($this->data) ) {
			// Set order id
			$this->data['Shipment']['order_id'] = $order_id;
			
			// Launch validation
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if ($submitted_data_validates && $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been saved','/order/shipments/listall/'.$order_id.'/' );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id, 'Shipment.order_id'=>$order_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }				
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( empty($this->data) ) {
			$this->data = $shipment_data;	
					
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			$this->Shipment->id = $shipment_id;
			if ($submitted_data_validates && $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been updated', '/order/shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
		
		// Shipment data
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }				
		$this->data = $shipment_data;
		
		// Shipped items
		$shipped_items = $this->paginate($this->OrderItem, array('OrderItem.shipment_id'=>$shipment_id));
		$this->set('shipped_items', $shipped_items);

		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$this->Structures->set('shippeditems', 'atim_structure_for_shipped_items');	
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }				

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowShipmentDeletion($shipment_id);
			
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->Shipment->atim_delete( $shipment_id )) {
				$this->flash('your data has been deleted', '/order/shipments/listall/'.$order_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/order/shipments/listall/'.$order_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/order/shipments/detail/'.$order_id.'/'.$shipment_id);
		}
	}
	
	/* ----------------------------- SHIPPED ITEMS ---------------------------- */
	
	function addToShipment($order_id, $shipment_id){
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
		
		// Check shipment
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }	
		
		// Get available order items
		$available_order_items = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL'), 'order' => 'OrderItem.date_added DESC, OrderLine.id'));
		if(empty($available_order_items)) { $this->flash('no new item could be actualy added to the shipment', '/order/shipments/detail/'.$order_id.'/'.$shipment_id);  }

		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);
		
		// Set array to get ids from barcode
		$item_id_by_barcode = array();
		$order_line_id_by_barcode = array();
		$aliquot_id_by_barcode = array();
		foreach($available_order_items as $item_data){
			$item_id_by_barcode[$item_data['AliquotMaster']['barcode']] = $item_data['OrderItem']['id']; 
			$order_line_id_by_barcode[$item_data['AliquotMaster']['barcode']] = $item_data['OrderLine']['id']; 
			$aliquot_id_by_barcode[$item_data['AliquotMaster']['barcode']] = $item_data['AliquotMaster']['id']; 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Order.id' => $order_id, 'Shipment.id' => $shipment_id));
		
		$this->Structures->set('shippeditems');		
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(empty($this->data)){		
			$this->data = $available_order_items;
			
		} else {	
			// Launch validation
			$submitted_data_validates = true;
			
			$data_to_save = array();
			$errors = array();
			foreach($this->data as $id => $new_studied_item) {
				// New studied item

				if($new_studied_item['FunctionManagement']['use']) {
					// Item has been defined as shipped
					
					// Launch validation on fields (if required)
					
//					$this->{model}->set($new_studied_item);
//					$submitted_data_validates = ($this->{model}->validates())? $submitted_data_validates: false;			
//					foreach($this->{model}->invalidFields() as $field => $error) { $errors[{model}][$field][$error] = '-'; }
					
					// Get OrderItem id
					if(!isset($item_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_order_system_error', null, true); }
					$new_studied_item['OrderItem']['id'] = $item_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']];

					// Get OrderLine id
					if(!isset($order_line_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_order_system_error', null, true); }
					$new_studied_item['OrderLine']['id'] = $order_line_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']];
						
					// Get AliquotMaster id
					if(!isset($aliquot_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_order_system_error', null, true); }
					$new_studied_item['AliquotMaster']['id'] = $aliquot_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']];
					
					// Define data as 'to save'
					$data_to_save[] = $new_studied_item;
				}
				
				// Reset data
				$this->data[$id] = $new_studied_item;
			}
			
			if(empty($data_to_save)) { 
				$this->OrderItem->validationErrors[] = 'no item has been defined as shipped';	
				$submitted_data_validates = false;			
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			if (!$submitted_data_validates) {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $tmp) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field] = $message;
							} else {
								$this->{$model}->validationErrors[] = $message;
							}
						}
					}
				}
			} else {	
				// Launch Save Process
				$order_line_to_update = array();
				
				foreach($data_to_save as $key => $shipped_item){					
					// Get ids
					$order_item_id = $shipped_item['OrderItem']['id'];
					$order_line_id = $shipped_item['OrderLine']['id'];
					$aliquot_master_id = $shipped_item['AliquotMaster']['id'];
					
					// 1- Update Aliquot Master Data
					$aliquot_master = array();
					$aliquot_master['AliquotMaster']['status'] = 'not available';
					$aliquot_master['AliquotMaster']['status_reason'] = 'shipped';
					$aliquot_master['AliquotMaster']['storage_master_id'] = null;
					$aliquot_master['AliquotMaster']['storage_coord_x'] = null;
					$aliquot_master['AliquotMaster']['storage_coord_y'] = null;	
					
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($aliquot_master, false)) { $this->redirect('/pages/err_order_record_err', null, true); }										
					
					// 2- Create new aliquot use
					$aliquot_use_data = array();
					$aliquot_use_data['AliquotUse']['id'] = null;
					$aliquot_use_data['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;
					$aliquot_use_data['AliquotUse']['use_definition'] = 'aliquot shipment';
					$aliquot_use_data['AliquotUse']['use_code'] = $shipment_data['Shipment']['shipment_code'];
					$aliquot_use_data['AliquotUse']['use_details'] = '';
					$aliquot_use_data['AliquotUse']['use_recorded_into_table'] = 'order_items';	
					$aliquot_use_data['AliquotUse']['use_datetime'] = $shipment_data['Shipment']['datetime_shipped'];
					$aliquot_use_data['AliquotUse']['used_by'] = $shipment_data['Shipment']['shipped_by'];
					$aliquot_use_data['AliquotUse']['study_summary_id'] = '';
										
					if(! $this->AliquotUse->save( $aliquot_use_data )) { $this->redirect('/pages/err_order_record_err', null, true); }
					
					// 3- Record Order Item Update
					$order_item_data = array();
					$order_item_data['OrderItem']['shipment_id'] = $shipment_data['Shipment']['id'];
					$order_item_data['OrderItem']['aliquot_use_id'] = $this->AliquotUse->getLastInsertId();
					$order_item_data['OrderItem']['status'] = 'shipped';

					$this->OrderItem->id = $order_item_id;
					if(!$this->OrderItem->save($order_item_data, false)) { $this->redirect('/pages/err_order_record_err', null, true); }		
					
					// Set order line to update
					$order_line_to_update[$order_line_id] = $order_line_id;
				}
				
				foreach($order_line_to_update as $order_line_id){
					$items_counts = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status != "shipped"')));
					if($items_counts == 0){
						//update if everything is shipped
						$order_line = array();
						$order_line['OrderLine']['status'] = "shipped";
						$this->OrderLine->id = $order_line_id;
						$this->OrderLine->save($order_line);
					}
				}
				
				$this->flash('your data has been saved', '/order/shipments/detail/'.$order_id.'/'.$shipment_id.'/');
			}		
		}	
	}	
	
	
	
	function updateShippedAliquotUses($shipment_id, $new_shipment_code, $new_shipment_date) {
		//TODO
	}	
	
	function deleteFromShipment($order_id, $order_item_id, $shipment_id){
		$this->flash('underdeveleopment', '/order/shipments/detail/'.$order_id.'/'.$shipment_id.'/');
		//TODO review
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.order_id' => $order_id)));
		
		if(!empty($order_item)){
			$order_item['OrderItem']['shipment_id'] = null;
			$order_item['OrderItem']['status'] = 'pending';
			$order_item['AliquotMaster']['status'] = 'reserved for order';
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('delete');
			if($hook_link){
				require($hook_link);
			}

			if($submitted_data_validates){
				$this->AliquotMaster->save($order_item);
				
				$order_line['OrderLine']['id'] = $order_item['OrderItem']['order_line_id'];
				$order_line['OrderLine']['status'] = 'pending';
				$this->OrderLine->save($order_line);
				
				$this->OrderItem->save($order_item, false);//no validation because we just want to set the shipment_id to null and that is forbidden
				$this->flash('your data has been deleted', '/order/shipments/shipmentItems/'.$order_id.'/'.$shipment_id.'/');
			}
		}else{
			$this->flash('Invalid deleted.', '/order/shipments/shipmentItems/'.$order_id.'/'.$shipment_id.'/');
		}
	}
  	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a shipment can be deleted.
	 * 
	 * @param $shipment_id Id of the studied shipment.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowShipmentDeletion($shipment_id){
		// Check no item is linked to this shipment
		$returned_nbr = $this->OrderItem->find('count', array('conditions' => array('OrderItem.shipment_id' => $shipment_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'order item exists for the deleted shipment'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}

?>