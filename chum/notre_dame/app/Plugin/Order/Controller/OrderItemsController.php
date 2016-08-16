<?php

class OrderItemsController extends OrderAppController {

	var $components = array();
			
	var $uses = array(
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.ViewAliquot',	
			
		'StorageLayout.TmaSlide',
			
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem',
		
		'Order.Shipment');
		
	var $paginate = array(
		'OrderItem'=>array('order'=>'AliquotMaster.barcode'),
		'ViewAliquot' => array('order' => 'ViewAliquot.barcode DESC'), 
		'AliquotMaster' => array('order' => 'AliquotMaster.barcode DESC'), 
		'TmaSlide' => array('order' => 'TmaSlide.barcode DESC'));
			
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get('/Order/Orders/search'));
		$this->searchHandler($search_id, $this->OrderItem, 'orderitems', '/InventoryManagement/OrderItems/search');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}	
	
	function listall( $order_id, $status = 'all', $order_line_id = null, $shipment_id = null, $main_form_model = null) {
		// MANAGE DATA
		
		if($order_line_id && $shipment_id) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		
		if($order_line_id) {
			//List all items of an order line
			$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id), 'recursive' => '-1'));
			if(empty($order_line_data)) {
				$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
			}	
		} else if($shipment_id) {
			//List all items linked to a shipment
			$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id, 'Shipment.order_id'=>$order_id), 'recursive' => '-1'));
			if(empty($shipment_data)) {
				$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
			}	
		} else {
			//List all items of an order
			$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id), 'recursive' => '-1'));
			if(empty($order_data)) {
				$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}		
		
		// Set data
		$conditions = array('OrderItem.order_id'=>$order_id);
		if($order_line_id) {
			$conditions['OrderItem.order_line_id'] = $order_line_id;
		} else if($shipment_id) {
			$conditions['OrderItem.shipment_id'] = $shipment_id;
		}
		if(in_array($status, array('pending', 'shipped', 'shipped & returned'))) $conditions['OrderItem.status'] = $status;
		$this->request->data = $this->paginate($this->OrderItem, $conditions);
		
		foreach($this->request->data as &$new_item) {
			if($new_item['AliquotMaster']['id']) {
				$new_item['Generated']['item_detail_link'] = '/InventoryManagement/AliquotMasters/detail/'.$new_item['AliquotMaster']['collection_id'].'/'.$new_item['AliquotMaster']['sample_master_id'].'/'.$new_item['AliquotMaster']['id'];
			} else {
				$new_item['Generated']['item_detail_link'] = '/StorageLayout/TmaSlides/detail/'.$new_item['TmaSlide']['tma_block_storage_master_id'].'/'.$new_item['TmaSlide']['id'];
			}
		}
		
		$this->set('status', $status);
		$this->set('order_line_id', $order_line_id);
		$this->set('shipment_id', $shipment_id);
		$this->set('main_form_model', $main_form_model);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set('orderitems,orderitems_plus'.(($order_line_id || Configure::read('order_item_to_order_objetcs_link_setting') == 3)? '' : ',orderitems_and_lines'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		$this->set('atim_menu', $this->Menus->get('/Order/Orders/search'));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	/**
	 * Liste all order items linked to the same object (AliquotMaster or TmaSlide)
	 * 
	 * @param unknown $object_model_name Name of the model of the studied object (AliquotMaster, TmaSlide)
	 * @param unknown $object_id Id of the boject
	 */
	
	function listAllOrderItemsLinkedToOneObject($object_model_name, $object_id) {
		if(!in_array($object_model_name, array('AliquotMaster', 'TmaSlide'))) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$foreign_key_field = str_replace(array('AliquotMaster', 'TmaSlide'), array('aliquot_master_id', 'tma_slide_id'), $object_model_name);
		
		//MANAGE DATA
		
		$this->OrderItem->bindModel(
			array('belongsTo' => array(
				'Order'	=> array(
					'className'  	=> 'StorageLayout.Order',
					'foreignKey'	=> 'order_id'))));
		$this->request->data = $this->paginate($this->OrderItem, array("OrderItem.$foreign_key_field" => $object_id));
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
	
		$this->set('atim_menu', $this->Menus->get('/Order/Orders/search'));
		$this->set('atim_menu_variables', array());
	
		// Set structure
		$this->Structures->set('orders_short,orderitems'.(Configure::read('order_item_to_order_objetcs_link_setting') == 3? '' : ',orderitems_and_lines'));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
	
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}

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
			$barcodes_recorded = array();
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
					$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.barcode' => $data_unit['AliquotMaster']['barcode']), 'recursive' => '-1'));
					if(!$aliquot_data) {
						$errors_tracking['barcode']['barcode is required and should exist'][] = $row_counter;
					} else {
						$this->OrderItem->data['OrderItem']['aliquot_master_id'] = $aliquot_data['AliquotMaster']['id'];
						
					}
					// Check aliquot is not already assigned to an order with a 'pending' or 'shipped' status
					if($aliquot_data && !$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $aliquot_data['AliquotMaster']['id'])) {
						$errors_tracking['barcode']["an aliquot cannot be added twice to orders as long as this one has not been first returned"][] = $row_counter;
					}
					// Check aliquot has not be enterred twice
					if(in_array($data_unit['AliquotMaster']['barcode'], $barcodes_recorded)) $errors_tracking['barcode']['an aliquot can only be added once to an order'][] = $row_counter;
					$barcodes_recorded[] = $data_unit['AliquotMaster']['barcode'];
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
					if(in_array($data_unit['TmaSlide']['barcode'], $barcodes_recorded)) $errors_tracking['barcode']['a tma slide can only be added once to an order'][] = $row_counter;
					$barcodes_recorded[] = $data_unit['TmaSlide']['barcode'];
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
	
	/**
	 * @deprecated Replaced by addOrderItemsInBatch()
	 */
	function addAliquotsInBatch($aliquot_master_id = null) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	}
	
	function addOrderItemsInBatch($object_model_name, $object_id = null){
  		// MANAGE DATA
  		
  		if(!in_array($object_model_name, array('AliquotMaster', 'TmaSlide'))) {
  			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
  		}
  		if(Configure::read('order_item_type_config') == 2 && $object_model_name == 'TmaSlide') {
  			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
  		}
  		if(Configure::read('order_item_type_config') == 3 && $object_model_name == 'AliquotMaster') {
  			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
  		}
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
  		
		$object_ids_to_add = null;
		$initial_display = false;
		
		if(!empty($object_id)) {
			// Just clicked on 'add to order' button of the aliquot or tma slide form
			$object_ids_to_add[] = $object_id;
			$initial_display = true;
		} else if(isset($this->request->data[$object_model_name]) || isset($this->request->data['ViewAliquot'])) {
			// Just launched process from batchset
			if(isset($this->request->data[$object_model_name])) {
				$object_ids_to_add = $this->request->data[$object_model_name]['id'];
			} else {
				$object_ids_to_add = $this->request->data['ViewAliquot']['aliquot_master_id'];
			}
			if($object_ids_to_add == 'all' && isset($this->request->data['node'])) {
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$object_ids_to_add = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$object_ids_to_add = array_filter($object_ids_to_add);
			$initial_display = true;
		} else if (isset($this->request->data['object_ids_to_add'])) {
			// User just clicked on submit button
			$object_ids_to_add = explode(',',$this->request->data['object_ids_to_add']);
			unset($this->request->data['object_ids_to_add']);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		
		// Get Aliquot or TMA Slide data
		$new_items_data = $this->{$object_model_name}->find('all', array('conditions' => array("$object_model_name.id" => $object_ids_to_add)));
		$display_limit = Configure::read('AliquotInternalUseCreation_processed_items_limit');
		if(empty($new_items_data)){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		} else if(sizeof($new_items_data) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
			return;
		}
		if(sizeof($new_items_data) != sizeof($object_ids_to_add)) {
			//In case an order item has just been deleted by another user before we submitted updated data
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Check new item is not already assigned to an order with a 'pending' or 'shipped' status
		foreach($new_items_data as $new_item) {
			if($object_model_name == 'AliquotMaster') {
				if(!$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $new_item['AliquotMaster']['id'])) {
					$this->flash(__("an aliquot cannot be added twice to orders as long as this one has not been first returned"), $url_to_cancel, 5);
					return;
				}
			} else {
				if(!$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $new_item['TmaSlide']['id'])) {
					$this->flash(__("a tma slide cannot be added twice to orders as long as this one has not been first returned"), $url_to_cancel, 5);
					return;
				}
			}			
		}
		//Sort new items
		$this->{$object_model_name}->sortForDisplay($new_items_data, $object_ids_to_add);
		
		$this->set('new_items_data' , $new_items_data);	
		$this->set('object_model_name', $object_model_name);
		$this->set('object_ids_to_add', implode(',',$object_ids_to_add));
  		$this->set('url_to_cancel', $url_to_cancel);
		
		//warn unconsented aliquots
		if($object_model_name == 'AliquotMaster') {
			$unconsented_aliquots = $this->AliquotMaster->getUnconsentedAliquots(array('id' => $object_ids_to_add));
			if(!empty($unconsented_aliquots)){
				AppController::addWarningMsg(__('this list contains aliquot(s) without a proper consent')." (".count($unconsented_aliquots).")"); 
			}
		}
				
		// Build data for order and order line selection
		$order_and_order_line_data = array();
		$this->Order->unbindModel(array('hasMany' => array('OrderLine','Shipment')));
		$order_data_tmp = $this->Order->find('all', array('conditions' => array('NOT' => array('Order.processing_status' => array('completed'))), 'order' => 'Order.order_number ASC'));
  		if(!$order_data_tmp) {
			$this->flash(__('no order to complete is actually defined'), $url_to_cancel);
			return;
		}
		foreach($order_data_tmp as $new_order) {
			$order_id = $new_order['Order']['id'];
			$new_order['Generated']['order_and_order_line_ids'] =  "$order_id|";
			if(isset($this->request->data['FunctionManagement']['selected_order_and_order_line_ids']) && ($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'] == $new_order['Generated']['order_and_order_line_ids'])) {
				$new_order['FunctionManagement']['selected_order_and_order_line_ids'] = $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'];
			}
			$order_and_order_line_data[$order_id] = array('order' => array($new_order), 'lines' => array());
		}
		$this->OrderLine->unbindModel(array('belongsTo' => array('Order')));
		$order_line_data_tmp = $this->OrderLine->find('all', array('conditions' => array('OrderLine.order_id' => array_keys($order_and_order_line_data)), 'order' => 'OrderLine.date_required ASC'));
		if(!$order_line_data_tmp && (Configure::read('order_item_to_order_objetcs_link_setting') == 2)) {
			$this->flash(__('no order to complete is actually defined'), $url_to_cancel);
			return;
		}
		foreach($order_line_data_tmp as $new_line) {
			$new_line['Generated']['order_and_order_line_ids'] =  $new_line['OrderLine']['order_id'].'|'.$new_line['OrderLine']['id'];
			unset($new_line['OrderItem']);
			if(isset($this->request->data['FunctionManagement']['selected_order_and_order_line_ids']) && ($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'] == $new_line['Generated']['order_and_order_line_ids'])) {
				$new_line['FunctionManagement']['selected_order_and_order_line_ids'] = $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'];
			}
			$order_and_order_line_data[$new_line['OrderLine']['order_id']]['lines'][] = $new_line;
		}
		$this->set('order_and_order_line_data', $order_and_order_line_data);
		$this->set('item_to_order_direct_link_allowed', true);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Structures
		$this->Structures->set(($object_model_name == 'AliquotMaster'? 'view_aliquot_joined_to_sample_and_collection' : 'tma_blocks_for_slide_creation,tma_slides'), 'atim_structure_for_new_items_list');
		$this->Structures->set('orderitems_to_addAliquotsInBatch', 'atim_structure_orderitems_data');
		$this->Structures->set('orderlines', 'atim_structure_order_line');
		$this->Structures->set('orders', 'atim_structure_order');
		
		// Menu
		$this->set('atim_menu', $this->Menus->get("/Order/Orders/search/"));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
				
		// SAVE DATA

		if($initial_display) {
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			//SAVE
			
			// Launch validations
			$submitted_data_validates = true;		
			
			// Launch validation on order or order line selected data
			$order_id = null;
			$order_line_id = null;
			if(empty($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'])) {
				$submitted_data_validates = false;
				$this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
			} else if(preg_match('/^([0-9]+)\|([0-9]*)$/', $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'], $order_and_order_line_ids)) {
				$order_id = $order_and_order_line_ids[1];
				$order_line_id = $order_and_order_line_ids[2];
				if($order_line_id) {
					if(!$this->OrderLine->find('count', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderLine.id' => $order_line_id), 'recursive' => '-1'))) {
						$submitted_data_validates = false;
						$this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
					}
				} else {
					if(!$this->Order->find('count', array('conditions' => array('Order.id' => $order_id), 'recursive' => '-1'))) {
						$submitted_data_validates = false;
						$this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
					}					
				}
				$this->request->data['OrderItem']['order_id'] = $order_id;
				$this->request->data['OrderItem']['order_line_id'] = $order_line_id;
			} else {
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			// Launch validation on order item data
			$this->OrderItem->set($this->request->data);		
			$submitted_data_validates = ($this->OrderItem->validates()) ? $submitted_data_validates : false;			
			$this->request->data = $this->OrderItem->data;		
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}			
			
			if($submitted_data_validates){	
				
				AppModel::acquireBatchViewsUpdateLock();
				
				$this->OrderItem->addWritableField(array('order_id', 'order_line_id', 'status', 'aliquot_master_id', 'tma_slide_id'));
				foreach($object_ids_to_add as $added_id) {
					// Add order item
					$new_order_item_data = array();
					$new_order_item_data['OrderItem']['status'] = 'pending';
					$new_order_item_data['OrderItem'][($object_model_name == 'AliquotMaster')? 'aliquot_master_id': 'tma_slide_id'] = $added_id;
					$new_order_item_data['OrderItem'] = array_merge($new_order_item_data['OrderItem'], $this->request->data['OrderItem']);
					$this->OrderItem->data = null;
					$this->OrderItem->id = null;
					if(!$this->OrderItem->save($new_order_item_data, false)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
					
					if($object_model_name == 'AliquotMaster') {
						// Update aliquot master status
						$new_aliquot_master_data = array();
						$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
						$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
						$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
						$this->AliquotMaster->id = $added_id;
						if(!$this->AliquotMaster->save($new_aliquot_master_data)) { 
							$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
						}
					} else {
						// Update tma slide status
						$new_tma_slide_data = array();
						$new_tma_slide_data['TmaSlide']['in_stock'] = 'yes - not available';
						$new_tma_slide_data['TmaSlide']['in_stock_detail'] = 'reserved for order';
						$this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
						$this->TmaSlide->id = $added_id;
						if(!$this->TmaSlide->save($new_tma_slide_data)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
					}
				}
				
				// Update Order Line status
				if($order_line_id) {
					$new_order_line_data = array();
					$new_order_line_data['OrderLine']['status'] = 'pending';
					$this->OrderLine->addWritableField(array('status'));
					$this->OrderLine->id = $order_line_id;
					if(!$this->OrderLine->save($new_order_line_data)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				// Redirect
				$this->atimFlash(__('your data has been saved'), (!$order_line_id)? "/Order/Orders/detail/$order_id/" : "/Order/OrderLines/detail/$order_id/$order_line_id/");
			}
		}
	}
	
	function edit($order_id, $order_item_id, $main_form_model = null) {
		if (( !$order_id ) || ( !$order_item_id )) {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
				
		// MANAGE DATA
		
		$order_item_data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id, 'OrderItem.order_id'=>$order_id)));
		if(empty($order_item_data)) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		
		if($order_item_data['OrderItem']['status'] == 'shipped') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		switch($main_form_model) {
			case 'Order':
				$url_to_cancel = '/Order/Orders/detail/'.$order_item_data['OrderItem']['order_id'].'/';
				break;
			case 'OrderLine':
				$url_to_cancel = '/Order/OrderLines/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['order_line_id'].'/';
				break;
			case 'Shipment':
				$url_to_cancel = '/Order/Shipments/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['shipment_id'].'/';
				break;
		}		
		$this->set('url_to_cancel', $url_to_cancel);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/Orders/detail/%%Order.id%%/'));
		$this->set('atim_menu_variables', array('Order.id'=>$order_id, 'OrderItem.id'=>$order_item_id));
		
		$this->Structures->set(($order_item_data['OrderItem']['status'] == 'pending'? 'orderitems' : 'orderitems_returned'));
		
		// SAVE PROCESS
			
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( empty($this->request->data) ) {
			$this->request->data = $order_item_data;
		
		} else {
			$submitted_data_validates = true;
				
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if ($submitted_data_validates) {
				$this->OrderItem->id = $order_item_id;
				if($this->OrderItem->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'),$url_to_cancel);
				}
			}
		}
	}
	
	function editInBatch() {
		// MANAGE DATA
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
		
		$initial_display = false;
		$criteria = array('OrderItem.id' => '-1');
		$order_item_ids = array();
		$intial_order_items_data = array();
		if(isset($this->request->data['OrderItem']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['OrderItem']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$order_item_ids = array_filter($this->request->data['OrderItem']['id']);
			$criteria = array('OrderItem.id' => $order_item_ids);
			$initial_display = true;
		} else if(!empty($this->request->data)) {
			// User submit data of the OrderItem.editInBatch() form
			$order_item_ids = explode(',',$this->request->data['order_item_ids']);
			$criteria = array('OrderItem.id' => $order_item_ids);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		unset($this->request->data['order_item_ids']);
		
		if($initial_display) {
			$intial_order_items_data = $this->OrderItem->find('all', array('conditions' => $criteria, 'recursive' => '0'));
			if(empty($intial_order_items_data)) {
				$this->flash(__('no item to update'), $url_to_cancel);
				return;
			}
			if($order_item_ids) $this->OrderItem->sortForDisplay($intial_order_items_data, $order_item_ids);
			$display_limit = Configure::read('edit_processed_items_limit');
			if(sizeof($intial_order_items_data) > $display_limit) {
				$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
				return;
			}
		}

		$statuses = $this->OrderItem->find('all', array('conditions' => $criteria, 'fields' => array('DISTINCT OrderItem.status'), 'recursive' => '-1'));
		if(empty($statuses)) {
			//All order items have probably been deleted by another user before we submitted updated data
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if(sizeof($statuses) != 1) {
			$this->flash(__('items should have the same status to be updated in batch'), $url_to_cancel);
			return;
		} else if($statuses[0]['OrderItem']['status'] == 'shipped') {
			$this->flash(__('items should have a status different than shipped to be updated in batch'), $url_to_cancel);
			return;
		}
		$status = $statuses[0]['OrderItem']['status'];
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('order_item_ids', implode(',',$order_item_ids));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set(($status != 'pending')? 'orderitems_returned' : 'orderitems');
		
		$this->set('atim_menu', $this->Menus->get('/Order/Orders/search/'));
		$this->set('atim_menu_variables', array());
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// SAVE DATA
		
		if($initial_display) {
			$this->request->data = $intial_order_items_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
					
		} else {
			
			// Launch validation
			$submitted_data_validates = true;	
			
			$errors = array();	
			$record_counter = 0;
			$updated_item_ids = array();
			foreach($this->request->data as $key => &$new_studied_item){
				$record_counter++;
				//Get id
				if(!isset($new_studied_item['OrderItem']['id'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$updated_item_ids[] = $new_studied_item['OrderItem']['id'];
				// Launch Order Item validation
				$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
				$this->OrderItem->set($new_studied_item);
				$submitted_data_validates = ($this->OrderItem->validates()) ? $submitted_data_validates : false;
				foreach($this->OrderItem->validationErrors as $field => $msgs) {
					$msgs = is_array($msgs)? $msgs : array($msgs);
					foreach($msgs as $msg) $errors['OrderItem'][$field][$msg][]= $record_counter;
				}
				// Reset data
				$new_studied_item = $this->OrderItem->data;
			}
			
			if($this->OrderItem->find('count', array('conditions' => array('OrderItem.id'=> $updated_item_ids), 'recursive' => '-1')) != sizeof($updated_item_ids)) {
				//In case an order item has just been deleted by another user before we submitted updated data
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
		
			if ($submitted_data_validates) {
				
				// Launch save process
				AppModel::acquireBatchViewsUpdateLock();
				
				$this->OrderItem->writable_fields_mode = 'editgrid';
				
				foreach($this->request->data as $order_item){
					// Save data
					$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
					$this->OrderItem->id = $order_item['OrderItem']['id'];
					if(!$this->OrderItem->save($order_item['OrderItem'], false)) {
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
					}
				}

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				// Creat Batchset then redirect
				
				$batch_ids = $order_item_ids;
				$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
				$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
				$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('OrderItem'),
						'flag_tmp' => true
				));
				$batch_set_model->check_writable_fields = false;
				$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
				$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
					
			} else {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $lines_nbr) {
							$line_nbr_message = ($lines_nbr)? ' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s')) : '';
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field][] = $message.$line_nbr_message;
							} else {
								$this->{$model}->validationErrors[][] = $message.$line_nbr_message;
							}
						}
					}
				}
			}
		}
	}
	
	function delete($order_id, $order_item_id, $main_form_model = null) {
		
		// MANAGE DATA
		
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderItem.order_id' => $order_id)));
		if(empty($order_item_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}			
		
		//Build URL
		$redirect_url = 'javascript:history.go(-1)';
		switch($main_form_model) {
			case 'Order':
				$redirect_url = '/Order/Orders/detail/'.$order_item_data['OrderItem']['order_id'].'/';
				break;
			case 'OrderLine':
				$redirect_url = '/Order/OrderLines/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['order_line_id'].'/';
				break;
			case 'Shipment':
				$redirect_url = '/Order/Shipments/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['shipment_id'].'/';
				break;
		}	
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->OrderItem->allowDeletion($order_item_data);
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if($arr_allow_deletion['allow_deletion']) {
			// Launch deletion
			
			if($this->OrderItem->atimDelete($order_item_id)) {
				
				if($order_item_data['OrderItem']['aliquot_master_id']) {
					// Update AliquotMaster data
					$new_aliquot_master_data = array();
					$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - available';
					$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = '';
					
					$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
					$this->AliquotMaster->id = $order_item_data['OrderItem']['aliquot_master_id'];
					if(!$this->AliquotMaster->save($new_aliquot_master_data)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
				} else {
					// Update Tma Slide data
					$new_tma_slide_data = array();
					$new_tma_slide_data['TmaSlide']['in_stock'] = 'yes - available';
					$new_tma_slide_data['TmaSlide']['in_stock_detail'] = '';
					
					$this->TmaSlide->addWritableField(array('in_stock', 'in_stock_detail'));
					
					$this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
					$this->TmaSlide->id = $order_item_data['OrderItem']['tma_slide_id'];
					if(!$this->TmaSlide->save($new_tma_slide_data)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
				}
				
				$order_line_id = $order_item_data['OrderItem']['order_line_id'];
				if($order_line_id) {
					// Update order line status
					$new_status = 'pending';
					$order_item_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id), 'recursive' => '-1'));
					if($order_item_count != 0) {
						$order_item_not_shipped_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.status = "pending"', 'OrderItem.order_line_id' => $order_line_id, 'OrderItem.deleted != 1'), 'recursive' => '-1'));
						if($order_item_not_shipped_count == 0) { 
							$new_status = 'shipped'; 
						}
					}
					$order_line_data = array();
					$order_line_data['OrderLine']['status'] = $new_status;
					$this->OrderLine->addWritableField(array('status'));
					$this->OrderLine->id = $order_line_id;
					if(!$this->OrderLine->save($order_line_data)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				// Redirect
				$this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), $redirect_url);
			} else {
				$this->flash(__('error deleting data - contact administrator'), $redirect_url);
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), $redirect_url);
		}
	}
	
	function defineOrderItemsReturned($order_id = 0, $order_line_id = 0, $shipment_id = 0, $order_item_id = 0) {
		// MANAGE DATA
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
		
		$initial_display = false;
		
		$criteria = array('OrderItem.id' => '-1');
		$order_item_ids = array();
		$initial_order_items_data = array();
		if(isset($this->request->data['OrderItem']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['OrderItem']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$order_item_ids = array_filter($this->request->data['OrderItem']['id']);
			$criteria = array('OrderItem.id' => $order_item_ids);
			$initial_display = true;
		} else if(!empty($this->request->data)) {
			// User submit data of the OrderItem.defineOrderItemsReturned() form
			$order_item_ids = explode(',',$this->request->data['order_item_ids']);
			$criteria = array('OrderItem.id' => $order_item_ids);
		} else if($order_id){
			// User is working on an order
			$this->Order->getOrRedirect($order_id);
			$criteria = array('OrderItem.order_id' => $order_id);
			$criteria[] = array('OrderItem.status' => 'shipped');
			if($order_line_id) $criteria['OrderItem.order_line_id'] = $order_line_id;
			if($shipment_id) $criteria['OrderItem.shipment_id'] = $shipment_id;
			if($order_item_id) $criteria['OrderItem.id'] = $order_item_id;
			if(empty($this->request->data)) $initial_display = true;
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		unset($this->request->data['order_item_ids']);
		
		if($initial_display) {
			$initial_order_items_data = $this->OrderItem->find('all', array('conditions' => $criteria, 'order'=> array('AliquotMaster.barcode ASC', 'TmaSlide.barcode ASC')));
			if(empty($initial_order_items_data)) {
				$this->flash(__('no order items can be defined as returned'), $url_to_cancel);
				return;
			}
			$display_limit = Configure::read('defineOrderItemsReturned_processed_items_limit');
			if(sizeof($initial_order_items_data) > $display_limit) {
				$this->flash(__("batch init - number of submitted records too big")." (>$display_limit). ".__('use databrowser to submit a sub set of data'), $url_to_cancel, 5);
				return;
			}
			if($order_item_ids) {
				$this->OrderItem->sortForDisplay($initial_order_items_data, $order_item_ids);
			} else {
				foreach($initial_order_items_data as $new_order_item) $order_item_ids[] = $new_order_item['OrderItem']['id'];
			}
		}

		if($this->OrderItem->find('count', array('conditions' => array('OrderItem.id' => $order_item_ids, "OrderItem.status != 'shipped'")))) {
			$this->flash(__('only shipped items can be defined as returned'), $url_to_cancel);
			return;
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('order_id', $order_id);
		$this->set('order_line_id', $order_line_id);
		$this->set('shipment_id', $shipment_id);
		$this->set('order_item_ids', implode(',',$order_item_ids));
		
		// Set menu
		
		if($shipment_id) {
			// Get the current menu object
			$this->set('atim_menu', $this->Menus->get('/Order/Shipments/detail/%%Shipment.id%%/'));
			// Variables
			$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		} else if($order_line_id) {
			// Get the current menu object
			$this->set('atim_menu', $this->Menus->get('/Order/OrderLines/detail/%%OrderLine.id%%/'));
			// Variables
			$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );		
		} else if($order_id) {
			// Get the current menu object
			$this->set('atim_menu', $this->Menus->get('/Order/Orders/detail/%%Order.id%%/'));
			// Variables
			$this->set('atim_menu_variables', array('Order.id' => $order_id));
		} else {
			$this->set('atim_menu', $this->Menus->get('/Order/Orders/search/'));
			$this->set('atim_menu_variables', array());
		}
		
		// Set structure
		$this->Structures->set('orderitems_returned,orderitems_returned_flag');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// SAVE DATA
		
		if($initial_display) {
			
			$this->request->data = $initial_order_items_data;
				
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			// Launch validation
			$submitted_data_validates = true;	
			
			$errors = array();	
			$record_counter = 0;
			$at_least_one_item_defined_as_returned = false;
			foreach($this->request->data as &$new_studied_item){
				$record_counter++;
				$order_item_id = $new_studied_item['OrderItem']['id'];
				if(!isset($new_studied_item['OrderItem']['id'])) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				if(!isset($new_studied_item['OrderItem']['aliquot_master_id']) || !isset($new_studied_item['OrderItem']['tma_slide_id'])) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				if($new_studied_item['FunctionManagement']['defined_as_returned']) {
					// Launch Item validation
					$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
					$this->OrderItem->set($new_studied_item);
					$submitted_data_validates = ($this->OrderItem->validates()) ? $submitted_data_validates : false;
					foreach($this->OrderItem->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors['OrderItem'][$field][$msg][]= $record_counter;
					}
					// Reset data
					$new_studied_item = $this->OrderItem->data;
					//At least one item is defined as returned
					$at_least_one_item_defined_as_returned = true;
				}
			}						
			
			if(!$at_least_one_item_defined_as_returned) {
				$errors['OrderItem']['defined_as_returned']['at least one item should be defined as returned'] = array();
				$submitted_data_validates = false;
			}
			
			if($this->OrderItem->find('count', array('conditions' => array('OrderItem.id'=> $order_item_ids), 'recursive' => '-1')) != sizeof($order_item_ids)) {
				//In case an order item has just been deleted by another user before we submitted updated data
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}

			if ($submitted_data_validates) {
				
				// Launch save process
				
				AppModel::acquireBatchViewsUpdateLock();
				
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				$this->TmaSlide->addWritableField(array('in_stock', 'in_stock_detail'));
				
				$this->OrderItem->writable_fields_mode = 'editgrid';
				$this->OrderItem->addWritableField(array('status'));
				
				foreach($this->request->data as $new_studied_item_to_update){
					if($new_studied_item_to_update['FunctionManagement']['defined_as_returned']) {
						$order_item_id = $new_studied_item_to_update['OrderItem']['id'];
						
						// 1- Record Order Item Update
						$order_item_data = $new_studied_item_to_update;
						$order_item_data['OrderItem']['status'] = 'shipped & returned';
							
						$this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
						$this->OrderItem->id = $order_item_id;
						if(!$this->OrderItem->save($order_item_data, false)) {
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						}
						
						if($new_studied_item_to_update['OrderItem']['aliquot_master_id']) {
							// 2- Update Aliquot Master Data
							$aliquot_master = array();
							$aliquot_master['AliquotMaster']['in_stock'] = 'yes - available';
							$aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped & returned';
							$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
							$this->AliquotMaster->id = $new_studied_item_to_update['OrderItem']['aliquot_master_id'];
							if(!$this->AliquotMaster->save($aliquot_master, false)) {
								$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
							}
						} else {
							// 2- Update Tma Slide Data
							$tma_slide_master = array();
							$tma_slide_master['TmaSlide']['in_stock'] = 'yes - available';
							$tma_slide_master['TmaSlide']['in_stock_detail'] = 'shipped & returned';
							$this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
							$this->TmaSlide->id = $new_studied_item_to_update['OrderItem']['tma_slide_id'];
							if(!$this->TmaSlide->save($tma_slide_master, false)) {
								$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
							}
						}
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				// Redirect
				
				if($shipment_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id);
				} else if($order_line_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id);
				} else if($order_id){
					$this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/'.$order_id);
				}else{
					//batch
					$batch_ids = $order_item_ids;
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('OrderItem'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				}
				
			} else {	
				// Set error message			
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $lines_nbr) {
							$lines_nbr = $lines_nbr? ' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s')) : '';
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field][] = __($message).$lines_nbr;
							} else {
								$this->{$model}->validationErrors[][] =  __($message).$lines_nbr;
							}
						}
					}
				}
			}
		}
	}
	
	function removeFlagReturned($order_id, $order_item_id, $main_form_model = null) {
	
		// MANAGE DATA
	
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderItem.order_id' => $order_id)));
		if(empty($order_item_data) || $order_item_data['OrderItem']['status'] != 'shipped & returned') {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if(!isset($order_item_data['OrderItem']['aliquot_master_id']) && !isset($order_item_data['OrderItem']['tma_slide_id'])) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	
		// Check the status of the order item can be changed to shipped
		$error = null;
		if($order_item_data['OrderItem']['aliquot_master_id']) {
			if(!$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $order_item_data['OrderItem']['aliquot_master_id'], $order_item_data['OrderItem']['id'])) {
				$error = "the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses";
			}
		} else {
			if(!$this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $order_item_data['OrderItem']['tma_slide_id'], $order_item_data['OrderItem']['id'])) {
				$error = "the status of a tma slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses";
			}		
		}
		
		//Build URL
		$redirect_url = 'javascript:history.go(-1)';
		switch($main_form_model) {
			case 'Order':
				$redirect_url = '/Order/Orders/detail/'.$order_item_data['OrderItem']['order_id'].'/';
				break;
			case 'OrderLine':
				$redirect_url = '/Order/OrderLines/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['order_line_id'].'/';
				break;
			case 'Shipment':
				$redirect_url = '/Order/Shipments/detail/'.$order_item_data['OrderItem']['order_id'].'/'.$order_item_data['OrderItem']['shipment_id'].'/';
				break;
		}
		
		$hook_link = $this->hook();
		if( $hook_link ) {
			require($hook_link);
		}
		
		if(!$error) {
			// Launch status change
			$order_item = array();
			$order_item['OrderItem']['status'] = 'shipped';
			$order_item['OrderItem']['date_returned'] = null;
			$order_item['OrderItem']['date_returned_accuracy'] = null;
			$order_item['OrderItem']['reason_returned'] = null;
			$order_item['OrderItem']['reception_by'] = null;
			$this->OrderItem->addWritableField(array('status','date_returned','date_returned_accuracy','reason_returned', 'reception_by'));
			$this->OrderItem->id = $order_item_id;
			if(!$this->OrderItem->save($order_item)) {
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
			}
			if($order_item_data['OrderItem']['aliquot_master_id']) {
				//Update Aliquot Master Data
				$aliquot_master = array();
				$aliquot_master['AliquotMaster']['in_stock'] = 'no';
				$aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped';
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
				$this->AliquotMaster->id = $order_item_data['OrderItem']['aliquot_master_id'];
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				if(!$this->AliquotMaster->save($aliquot_master, false)) {
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			} else {
				//Update Tma Slide Data
				$tma_slide = array();
				$tma_slide['TmaSlide']['in_stock'] = 'no';
				$tma_slide['TmaSlide']['in_stock_detail'] = 'shipped';
				$this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
				$this->TmaSlide->id = $order_item_data['OrderItem']['tma_slide_id'];
				$this->TmaSlide->addWritableField(array('in_stock', 'in_stock_detail'));
				if(!$this->TmaSlide->save($tma_slide, false)) {
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
			}
			
			$hook_link = $this->hook('postsave_process');
			if( $hook_link ) {
				require($hook_link);
			}
	
			// Redirect
			$this->atimFlash(__('your data has been saved'), $redirect_url);
		} else {
			$this->flash(__($error), $redirect_url);
		}
	}
}
?>