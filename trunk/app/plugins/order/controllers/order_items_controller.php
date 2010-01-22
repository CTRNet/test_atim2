<?php

class OrderItemsController extends OrderAppController {
	
	var $uses = array(
		'Inventorymanagement.AliquotMaster',	
	
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem');
		
	var $paginate = array(
		'OrderItem'=>array('limit'=>'10','order'=>'AliquotMaster.barcode'),
		'AliquotMaster' => array('limit' =>10 , 'order' => 'AliquotMaster.barcode DESC'));
	
	function listall( $order_id, $order_line_id ) {
  		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
	
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		

		// Set data
		$this->setDataForOrderItemsList($order_line_id);
		$this->data = array();
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
//TODO change line status...
//TODO verify an aliquot could be added to order just one time
//TODO add in batch $_SESSION['Order']['NewAliquotsForOrder']
	
//		my function (aliquot->addToOrder) must call this add
//		orderItemShipmentId

	
	function add( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
	
		// Check order line
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		// SAVE PROCESS
		
		if(!empty($this->data)){
						
			// Launch validations
			$submitted_data_validates = true;
			
			// Check aliquot exists
			$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.barcode' => $this->data['AliquotMaster']['barcode']), 'recursive' => '-1'));
			if(empty($aliquot_data)) {
				$this->AliquotMaster->validationErrors['barcode'] = 'barcode is required and should exist';
				$submitted_data_validates = false;
			}
			
			// Check aliquot has never been added to order
			if($submitted_data_validates) {
				$is_aliquot_into_order = $this->OrderItem->find('count', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_data['AliquotMaster']['id']), 'recursive' => '-1'));
				if($is_aliquot_into_order)	{
					$this->AliquotMaster->validationErrors['barcode'] = 'an aliquot could be added once into an order';
					$submitted_data_validates = false;					
				}	
			}
					
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}			
			
			if($submitted_data_validates){
				// Order Item Data to save
				$new_order_item_data = array();
				$new_order_item_data['OrderItem'] = $this->data['OrderItem'];
				$new_order_item_data['OrderItem']['status'] = 'pending';
				$new_order_item_data['OrderItem']['order_line_id'] = $order_line_id;
				$new_order_item_data['OrderItem']['aliquot_master_id'] = $aliquot_data['AliquotMaster']['id'];
				
				$this->OrderItem->id = null;
				if($this->OrderItem->save($new_order_item_data)) {
					// Update Order Line status
					$new_order_line_data = array();
					$new_order_line_data = $new_order_line_data['OrderLine']['status'] = 'pending';
					
					$this->OrderLine->id = $order_line_data['OrderLine']['id'];
					if(!$this->OrderLine->save($new_order_line_data)) { $this->redirect( '/pages/err_order_record_err', null, true ); }
					
					// Update aliquot master status
					$new_aliquot_master_data = array();
					$new_aliquot_master_data['AliquotMaster']['status_reason'] = 'reserved for order';
					
					$this->AliquotMaster->id = $aliquot_data['AliquotMaster']['id'];
					if(!$this->AliquotMaster->save($new_aliquot_master_data)) { $this->redirect( '/pages/err_order_record_err', null, true ); }
					
					// Redirect
					$this->flash('your data has been saved', '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/');
				}
			}
		}
	}
	
	function edit( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
	
		// Check order line
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id), 'recursive' => '-1'));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		
		
		// Set data
		$criteria = array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status' => 'pending');
		$items_data = $this->OrderItem->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));

		// Set array to get id from barcode
		$order_item_id_by_barcode = array();
		foreach($items_data as $tmp_data){
			$order_item_id_by_barcode[$tmp_data['AliquotMaster']['barcode']] = $tmp_data['OrderItem']['id']; 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// SAVE DATA
		
		if(empty($this->data)) {
			$this->data = $items_data;
					
		} else {
			// Launch validation
			$submitted_data_validates = true;	
			
			$errors = array();	
			foreach($this->data as $key => $new_studied_item){
				// Launch Order Item validation
				$this->OrderItem->set($new_studied_item);
				$submitted_data_validates = ($this->OrderItem->validates())? $submitted_data_validates: false;
				foreach($this->OrderItem->invalidFields() as $field => $error) { $errors['OrderItem'][$field][$error] = '-'; }
			
				// Get order item id
				if(!isset($order_item_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_order_system_error', null, true); }
				$new_studied_item['OrderItem']['id'] = $order_item_id_by_barcode[$new_studied_item['AliquotMaster']['barcode']];
			
				// Reset data
				$this->data[$key] = $new_studied_item;				
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
				// Launch save process
				foreach($this->data as $order_item){
					// Save data
					$this->OrderItem->id = $order_item['OrderItem']['id'];
					if(!$this->OrderItem->save($order_item['OrderItem'], false)) { $this->redirect('/pages/err_order_record_err', null, true); }
				}
				
				// Redirect
				$this->flash('your data has been saved', '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/');
			}
		}
	}
	
	function delete( $order_id, $order_line_id, $order_item_id ) {
		if (( !$order_id ) || ( !$order_line_id ) || ( !$order_item_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// MANAGE DATA
		
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.id' => $order_line_id)));
		if(empty($order_item_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }			
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderItemDeletion($order_item_data);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		$url = '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/';
		if($arr_allow_deletion['allow_deletion']) {
			// Launch deletion
			
			if($this->OrderItem->atim_delete($order_item_id)) {
				
				// Update AliquotMaster data
				$new_aliquot_master_data = array();
				$new_aliquot_master_data['AliquotMaster']['status_reason'] = '';
				$this->AliquotMaster->id = $order_item_data['OrderItem']['aliquot_master_id'];
				if(!$this->AliquotMaster->save($new_aliquot_master_data)) { $this->redirect( '/pages/err_order_record_err', null, true ); }				
				
				// Update order line status
				$new_status = 'pending';
				$order_item_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id), 'recursive' => '-1'));
				if($order_item_count != 0) {
					$order_item_not_shipped_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.status != "shipped"', 'OrderItem.order_line_id' => $order_line_id, 'OrderItem.deleted != 1'), 'recursive' => '-1'));
					if($order_item_not_shipped_count == 0) { $new_status = 'shipped'; }
				}
				$order_line_data = array();
				$order_line_data['OrderLine']['status'] = $new_status;
//TODO: test
				$this->OrderLine->id = $order_line_id;
				if(!$this->OrderLine->save($order_line_data)) { $this->redirect( '/pages/err_order_record_err', null, true ); }
				
				// Redirect
				$this->flash('your data has been deleted', $url);
			} else {
				$this->flash('error deleting data - contact administrator', $url);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], $url);
		}
	}
  	
  	
  	
  	function addAliquotsInBatch($aliquot_master_id = null, $order_id = null, $order_line_id = null){
			
		// MANAGE SET OF ALIQUOT IDS TO WORK ON
		$aliquot_ids_to_add = null;
		$url_to_redirect = null;
		$launch_save_process = false;
		
		if(is_null($order_id) && is_null($order_line_id)) {
			// A- User just launched the process: set ids in session
			
			// A.1- Get ids
			$studied_aliquot_master_ids = array();
					
			if(!empty($aliquot_master_id)) {
				// Add aliquot from inventorymanagement plugin
				$studied_aliquot_master_ids[] = $aliquot_master_id;
				
				// Get aliquot data
				$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $studied_aliquot_master_ids), 'recursive' => '-1'));
				if(empty($aliquot_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
				
				// Build redirect url
				$url_to_redirect = '/aliquot_masters/detail/' . $aliquot_data['AliquotMaster']['collection_id'] . '/' . $aliquot_data['AliquotMaster']['sample_master_id'] . '/' . $aliquot_data['AliquotMaster']['id'] . '/';				
				
					
			} else if(isset($_SESSION['ctrapp_core']['datamart']['process']['AliquotMaster']['id'])){
				// Add aliquots from batchset
				$batch_set_id = $_SESSION['ctrapp_core']['datamart']['process']['BatchSet']['id'];
				
				//TODO Add following lines to patch bug on the array of ids sent by the batchset process
				// $studied_aliquot_master_ids = $_SESSION['ctrapp_core']['datamart']['process']['AliquotMaster']['id'];
				$aliquot_master_ids = $_SESSION['ctrapp_core']['datamart']['process']['AliquotMaster']['id'];
				foreach($aliquot_master_ids as $new_id) { if(!empty($new_id)) { $studied_aliquot_master_ids[] = $new_id; } }
				$aliquot_master_ids = null;
				
				// Check all aliquots exist
				$aliquots_count = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.id' => $studied_aliquot_master_ids), 'recursive' => '-1'));
				if($aliquots_count != sizeof($studied_aliquot_master_ids)) { 
					$this->redirect('/pages/err_order_system_error', null, true); 
				}
				
				// Build redirect url
				$url_to_redirect = '/datamart/batch_sets/listall/all/' . $batch_set_id;
			
			} else {
				$this->redirect( '/pages/err_order_funct_param_missing', null, true );
			}
			
			//TODO unset($_SESSION['ctrapp_core']['datamart']['process']);
			
			// A.2- Validate submitted aliquot ids
			$submitted_aliquots_validates = true;
			$error_message = '';
			
			if(empty($studied_aliquot_master_ids)) {
				// No aliquot has been submitted
				$submitted_aliquots_validates = false;
				$error_message = 'no aliquot has been submitted';
			}
					
			if($submitted_aliquots_validates) {
				// Check aliquots have never been added to an order
				$existing_order_aliquots = $this->OrderItem->find('all', array('conditions' => array('OrderItem.aliquot_master_id' => $studied_aliquot_master_ids), 'recursive' => '0'));
				if(!empty($existing_order_aliquots)) {
					$aliquots_list_for_display = '';
					foreach($existing_order_aliquots as $new_record) { $aliquots_list_for_display .= '<br> - ' . $new_record['AliquotMaster']['barcode']; }
					$submitted_aliquots_validates = false;
					$error_message = __('an aliquot could be added once into an order', true) .  '<br>' . __('please check aliquots', true) . ' : ' . $aliquots_list_for_display;				
				}
			}
			
			if(!$submitted_aliquots_validates) {	
				// Error has been detected: Redirect
				$this->flash($error_message, $url_to_redirect);
				return;
				
			} else {
				// Set data to session
				$aliquot_ids_to_add = $studied_aliquot_master_ids;
				$_SESSION['Order']['AliquotIdsToAddToOrder'] = $studied_aliquot_master_ids;
			}	
					
		} else {
			// B- User should have selected an order line: get ids from session and launch save process
			
			if(!isset($_SESSION['Order']['AliquotIdsToAddToOrder'])) { $this->redirect('/pages/err_order_system_error', null, true); }
			$aliquot_ids_to_add = $_SESSION['Order']['AliquotIdsToAddToOrder'];
			$launch_save_process = true;
		}
		
		// MANAGE DATA
		
		// Get aliquot data
		$aliquots_data = $this->paginate($this->AliquotMaster, array('AliquotMaster.id'=>$aliquot_ids_to_add));
		$this->set('aliquots_data' , $aliquots_data);
		
		// Build data for order line selection
		$this->data = $this->Order->find('all', array('conditions' => array('NOT' => array('Order.processing_status' => array('completed')))));
		foreach($this->data as &$var){
			$var['children'] = $var['OrderLine'];
			unset($var['OrderLine']);
			foreach($var['children'] as $key => &$var2){
				$var['children'][$key] = array('OrderLine' => $var2);
			}
			unset($var['Shipment']);
		}	
		
		// Set url for cancel button
		$this->set('url_to_cancel', $url_to_redirect);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Structures
		$atim_structure = array();
		$atim_structure['Order'] = $this->Structures->get('form', 'orders');
		$atim_structure['OrderLine'] = $this->Structures->get('form', 'orderlines');
		$this->set('atim_structure', $atim_structure);
		
		$this->Structures->set('aliquotmasters_summary', 'atim_structure_for_aliquots_list');

		// Menu
		$this->set('atim_menu', $this->Menus->get("/order/orders/index/"));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
				
		// SAVE DATA

		if($launch_save_process) {
			pr('la');
			pr($order_id);
			pr($order_line_id);
			pr($aliquot_ids_to_add);
			exit;
			
			
			
			
			
			
			
		}
		

	}
  	
  	
  	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if an item can be deleted.
	 * 
	 * @param $order_line_data Data of the studied order item.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowOrderItemDeletion($order_line_data){
		// Check aliquot is not gel matrix used to create either core
		if(!empty($order_line_data['Shipment']['id'])) { return array('allow_deletion' => false, 'msg' => 'this item cannot be deleted because it was already shipped'); }	
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}
?>