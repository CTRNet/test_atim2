<?php

class OrderItemsControllerCustom extends OrderItemsController {

	function add( $order_id, $order_line_id = 0 , $object_model_name = 'AliquotMaster') {
		if (( !$order_id )) {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if(Configure::read('order_item_to_order_objetcs_link_setting') == 2 && !$order_line_id) {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if(!in_array($object_model_name, array('AliquotMaster', 'TmaSlide'))) $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		if(Configure::read('order_item_type_config') == 2 && $object_model_name == 'TmaSlide') {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if(Configure::read('order_item_type_config') == 3 && $object_model_name == 'AliquotMaster') {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	
		// MANAGE DATA
	
		$order_data = array();
		$order_line_data =  array();
		if(!$order_line_id) {
			$order_data = $this->Order->getOrRedirect($order_id);
		} else {
			$order_line_data = $this->OrderLine->getOrRedirect($order_line_id);
			$order_data = array('Order' => $order_line_data['Order']);
		}
	
		$this->set('object_model_name', $object_model_name);
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
	
		$this->set( 'atim_menu', $this->Menus->get($order_line_id? '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/' : '/Order/Orders/detail/%%Order.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
	
		$this->Structures->set('orderitems,'.(($object_model_name == 'AliquotMaster')? 'addaliquotorderitems': 'addtmaslideorderitems'));
	
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	
		if (empty($this->request->data) ) {
			$this->request->data = array(array());
	
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
		} else {
				
			$errors_tracking = array();
	
			// Validation
				
			$display_limit = Configure::read('AddToOrder_processed_items_limit');
			if(sizeof($this->request->data) > $display_limit) {
				$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", ($order_line_id? '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id.'/' : '/Order/Orders/detail/'.$order_id), 5);
				return;
			}
				
			$row_counter = 0;
			$items_recorded = array();
			foreach($this->request->data as &$data_unit){
				$row_counter++;
				$this->OrderItem->id = null;
				$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
				$this->OrderItem->set($data_unit);
				if(!$this->OrderItem->validates()){
					foreach($this->OrderItem->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors_tracking[$field][$msg][] = $row_counter;
					}
				}
				if($object_model_name == 'AliquotMaster') {
					// Check aliquot exists
					$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.aliquot_label' => $data_unit['AliquotMaster']['aliquot_label']), 'recursive' => '-1'));
					if(!$aliquot_data) {
						$errors_tracking['aliquot_label']['aliquot label is required and should exist'][] = $row_counter;
					} else {
						$this->OrderItem->data['OrderItem']['aliquot_master_id'] = $aliquot_data['AliquotMaster']['id'];
	
					}
					// Check aliquot is not already assigned to an order with a 'pending' or 'shipped' status
					if($aliquot_data && !$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $aliquot_data['AliquotMaster']['id'])) {
						$errors_tracking['aliquot_label']["an aliquot cannot be added twice to orders as long as this one has not been first returned"][] = $row_counter;
					}
					// Check aliquot has not be enterred twice
					if(in_array($data_unit['AliquotMaster']['aliquot_label'], $items_recorded)) $errors_tracking['aliquot_label']['an aliquot can only be added once to an order'][] = $row_counter;
					$items_recorded[] = $data_unit['AliquotMaster']['aliquot_label'];
				} else {
					// Check tma slide exists
					$slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.barcode' => $data_unit['TmaSlide']['barcode']), 'recursive' => '-1'));
					if(!$slide_data) {
						$errors_tracking['barcode']['a tma slide barcode is required and should exist'][] = $row_counter;
					} else {
						$this->OrderItem->data['OrderItem']['tma_slide_id'] = $slide_data['TmaSlide']['id'];
							
					}
					// Check tma slide is not already assigned to an order with a 'pending' or 'shipped' status
					if($slide_data && !$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $slide_data['TmaSlide']['id'])) {
						$errors_tracking['barcode']["a tma slide cannot be added twice to orders as long as this one has not been first returned"][] = $row_counter;
					}
					// Check tma slide has not be enterred twice
					if(in_array($data_unit['TmaSlide']['barcode'], $items_recorded)) $errors_tracking['barcode']['a tma slide can only be added once to an order'][] = $row_counter;
					$items_recorded[] = $data_unit['TmaSlide']['barcode'];
				}
				// Reset data
				$data_unit = $this->OrderItem->data;
			}
			unset($data_unit);
	
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
	
			// Launch Save Process
	
			if(empty($errors_tracking)){
				$this->OrderItem->addWritableField(array('status', 'order_id', 'order_line_id', 'aliquot_master_id', 'tma_slide_id'));
				if($object_model_name == 'AliquotMaster') {
					$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				} else {
					$this->TmaSlide->addWritableField(array('in_stock', 'in_stock_detail'));
				}
				AppModel::acquireBatchViewsUpdateLock();
				//save all
				foreach($this->request->data as $new_data_to_save) {
					// Order Item Data to save
					$new_data_to_save['OrderItem']['status'] = 'pending';
					$new_data_to_save['OrderItem']['order_id'] = $order_id;
					if($order_line_id) $new_data_to_save['OrderItem']['order_line_id'] = $order_line_id;
					//Save new recrod
					$this->OrderItem->id = null;
					$this->OrderItem->data = array();
					if(!$this->OrderItem->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
					if($object_model_name == 'AliquotMaster') {
						// Update aliquot master status
						$new_aliquot_master_data = array();
						$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
						$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
						$this->AliquotMaster->id = $new_data_to_save['OrderItem']['aliquot_master_id'];
						if(!$this->AliquotMaster->save($new_aliquot_master_data)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
					} else {
						// Update tma slide status
						$new_tma_slide_data = array();
						$new_tma_slide_data['TmaSlide']['in_stock'] = 'yes - not available';
						$new_tma_slide_data['TmaSlide']['in_stock_detail'] = 'reserved for order';
						$this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
						$this->TmaSlide->id = $new_data_to_save['OrderItem']['tma_slide_id'];
						if(!$this->TmaSlide->save($new_tma_slide_data)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
					}
				}
				if($order_line_id) {
					// Update Order Line status
					$new_order_line_data = array();
					$new_order_line_data['OrderLine']['status'] = 'pending';
					$this->OrderLine->addWritableField(array('status'));
					$this->OrderLine->id = $order_line_data['OrderLine']['id'];
					if(!$this->OrderLine->save($new_order_line_data)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
				}
	
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
	
				AppModel::releaseBatchViewsUpdateLock();
				$this->atimFlash(__('your data has been saved'), $order_line_id? '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id.'/' : '/Order/Orders/detail/'.$order_id);
			} else {
				$this->OrderItem->validationErrors = array();
				foreach($errors_tracking as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->OrderItem->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
					}
				}
			}
		}
	}
	
	
	


}
?>