<?php

class OrderItemsController extends OrderAppController {

	var $components = array();
			
	var $uses = array(
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.ViewAliquot',	
			
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem',
		
		'Order.Shipment');
		
	var $paginate = array(
		'OrderItem'=>array('order'=>'AliquotMaster.barcode'),
		'ViewAliquot' => array('order' => 'ViewAliquot.barcode DESC'), 
		'AliquotMaster' => array('order' => 'AliquotMaster.barcode DESC'));

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
	
	function listall( $order_id, $status = '', $order_line_id = null, $shipment_id = null) {
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
		
		$this->set('status', $status);
		$this->set('order_line_id', $order_line_id);
		$this->set('shipment_id', $shipment_id);
		
		$aliquots_for_batchset = $this->OrderItem->find('all', array('fields' => array('AliquotMaster.id'), 'conditions' => $conditions));
		$this->set('aliquots_for_batchset', $aliquots_for_batchset);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set('orderitems,orderitems_plus'.(($order_line_id || Configure::read('order_item_to_order_objetcs_link_setting') == 3)? '' : ',orderitems_and_lines'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}

	function add( $order_id, $order_line_id = null ) {
		if (( !$order_id )) { 
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		if(Configure::read('order_item_to_order_objetcs_link_setting') == 2 && !$order_line_id) {
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
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get($order_line_id? '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/' : '/Order/Orders/detail/%%Order.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
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
			
			$display_limit = Configure::read('AddAliquotToOrder_processed_items_limit');
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
				// Check aliquot exists
				$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.barcode' => $data_unit['AliquotMaster']['barcode']), 'recursive' => '-1'));
				if(!$aliquot_data) {
					$errors_tracking['barcode']['barcode is required and should exist'][] = $row_counter;
				} else {
					$this->OrderItem->data['OrderItem']['aliquot_master_id'] = $aliquot_data['AliquotMaster']['id'];
					
				}
				// Check aliquot is not already assigned to an order with a 'pending' or 'shipped' status
				if($aliquot_data && !$this->OrderItem->checkAliquotOrderItemStatusCanBeSetToPendingShipped($aliquot_data['AliquotMaster']['id'])) {
					$errors_tracking['barcode']["an aliquot cannot be added twice to orders as long as this one has not been first returned"][] = $row_counter;
				}
				// Check aliquot has not be enterred twice
				if(in_array($data_unit['AliquotMaster']['barcode'], $barcodes_recorded)) $errors_tracking['barcode']['an aliquot can only be added once to an order'][] = $row_counter;
				$barcodes_recorded[] = $data_unit['AliquotMaster']['barcode'];

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
				$this->OrderItem->addWritableField(array('status', 'order_id', 'order_line_id', 'aliquot_master_id'));
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				AppModel::acquireBatchViewsUpdateLock();
				//save all
				foreach($this->request->data as $new_data_to_save) {
					// Order Item Data to save
					$new_data_to_save['OrderItem']['status'] = 'pending';
					$new_data_to_save['OrderItem']['order_id'] = $order_id;
					$new_data_to_save['OrderItem']['order_line_id'] = $order_line_id;
					//Save new recrod
					$this->OrderItem->id = null;
					$this->OrderItem->data = array();
					if(!$this->OrderItem->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
					// Update aliquot master status
					$new_aliquot_master_data = array();
					$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
					$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $new_data_to_save['OrderItem']['aliquot_master_id'];
					if(!$this->AliquotMaster->save($new_aliquot_master_data)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );	
					// Update Aliquot Use Counter
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($new_data_to_save['OrderItem']['aliquot_master_id'], false, true)) {
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
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
  	
  	function addAliquotsInBatch($aliquot_master_id = null){
  		
  		// MANAGE SET OF ALIQUOT IDS TO WORK ON
		$aliquot_ids_to_add = null;
		$url_to_redirect = 'javascript:history.go(-1)';
		$launch_save_process = false;
		
			
		if(isset($this->request->data['0']['aliquot_ids_to_add'])){
		// A - User just clicked on submit button
			$aliquot_ids_to_add = explode(',',$this->request->data['0']['aliquot_ids_to_add']);
			$this->setUrlToCancel();
			$url_to_redirect = $this->request->data['url_to_cancel'];
			$launch_save_process = true;

		}else{
			// A- User just launched the process: set ids in session
			
			// A.1- Get ids
			$studied_aliquot_master_ids = array();
					
			if(!empty($aliquot_master_id)) {
				// Add aliquot from InventoryManagement plugin
				$studied_aliquot_master_ids[] = $aliquot_master_id;
				
				// Get aliquot data
				$aliquot_data = $this->AliquotMaster->getOrRedirect($studied_aliquot_master_ids);
				
				// Build redirect url
				$url_to_redirect = '/InventoryManagement/AliquotMasters/detail/' . $aliquot_data['AliquotMaster']['collection_id'] . '/' . $aliquot_data['AliquotMaster']['sample_master_id'] . '/' . $aliquot_data['AliquotMaster']['id'] . '/';				
				
					
			} else {
				// Add aliquots from batchset
				
				// Build redirect url
				$this->setUrlToCancel();
				$url_to_redirect = $this->request->data['url_to_cancel'];

				$studied_aliquot_master_ids = array();
				if(isset($this->request->data['AliquotMaster'])) {
					$studied_aliquot_master_ids = $this->request->data['AliquotMaster']['id'];
				} else if(isset($this->request->data['ViewAliquot'])) {
					$studied_aliquot_master_ids = $this->request->data['ViewAliquot']['aliquot_master_id'];
				} else {
					$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_redirect, 5);
					return;
				}
				if($studied_aliquot_master_ids == 'all' && isset($this->request->data['node'])) {
					$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
					$studied_aliquot_master_ids = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				if(!is_array($studied_aliquot_master_ids) && strpos($studied_aliquot_master_ids, ',')){
					//User launched action from databrowser but the number of items was bigger than databrowser_and_report_results_display_limit
					$this->flash(__("batch init - number of submitted records too big"), "javascript:history.back();", 5);
					return;
				}
				$studied_aliquot_master_ids = array_filter($studied_aliquot_master_ids);
				$this->request->data = null;
				
				//Check all aliquots have been defined once
				if(sizeof(array_flip($studied_aliquot_master_ids)) != sizeof($studied_aliquot_master_ids)) {
					$this->flash(__('an aliquot can only be added once to an order'), $url_to_redirect);
					return;
				}

				// Check all aliquots exist
				$aliquots_count = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.id' => $studied_aliquot_master_ids), 'recursive' => '-1'));
				if($aliquots_count != sizeof($studied_aliquot_master_ids)) { 
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$display_limit = Configure::read('AddAliquotToOrder_processed_items_limit');
				if($aliquots_count > $display_limit) {
					$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_redirect, 5);
					return;
				}				
			}
			
			// A.2- Validate submitted aliquot ids
			$submitted_aliquots_validates = true;
			$error_message = '';
			
			if(empty($studied_aliquot_master_ids)) {
				// No aliquot has been submitted
				$submitted_aliquots_validates = false;
				$error_message = 'no aliquot has been submitted';
			}
					
			if($submitted_aliquots_validates) {
				// Check aliquot is not already assigned to an order with a 'pending' or 'shipped' status
				$aliquot_master_ids_to_check = array();
				foreach($studied_aliquot_master_ids as $new_aliquot_master_id) {
					if(!$this->OrderItem->checkAliquotOrderItemStatusCanBeSetToPendingShipped($new_aliquot_master_id)) $aliquot_master_ids_to_check[] = $new_aliquot_master_id;
				}
				if($aliquot_master_ids_to_check) {
					$aliquots_list_for_display = '';
					foreach($this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $aliquot_master_ids_to_check), 'recursive' => '-1')) as $new_aliquot_to_check) { 
						$aliquots_list_for_display .= '<br> - ' . $new_aliquot_to_check['AliquotMaster']['barcode']; 
					}
					$submitted_aliquots_validates = false;
					$error_message = __("an aliquot cannot be added twice to orders as long as this one has not been first returned") .  '<br>' . __('please check aliquots') . ' : ' . $aliquots_list_for_display;		
				}
			}
			
			if(!$submitted_aliquots_validates) {	
				// Error has been detected: Redirect
				$this->flash(__($error_message), $url_to_redirect);
				return;
				
			} else {
				// Set data to session
				$aliquot_ids_to_add = $studied_aliquot_master_ids;
			}	
					
		}
		
		// MANAGE DATA
		
		$this->set('aliquot_ids_to_add', implode(',',$aliquot_ids_to_add));
		
		// Get data of aliquots to add
		$aliquots_data = $this->ViewAliquot->find('all', array('conditions' => array('ViewAliquot.aliquot_master_id'=>$aliquot_ids_to_add)));
		$this->set('aliquots_data' , $aliquots_data);	
		
		//warn unconsented aliquots
		$unconsented_aliquots = $this->AliquotMaster->getUnconsentedAliquots(array('id' => $aliquot_ids_to_add));
		if(!empty($unconsented_aliquots)){
			AppController::addWarningMsg(__('this list contains aliquot(s) without a proper consent')." (".count($unconsented_aliquots).")"); 
		}
				
		// Build data for order and order line selection
		$order_and_order_line_data = array();
		$this->Order->unbindModel(array('hasMany' => array('OrderLine','Shipment')));
		$order_data_tmp = $this->Order->find('all', array('conditions' => array('NOT' => array('Order.processing_status' => array('completed'))), 'order' => 'Order.order_number ASC'));
  		if(!$order_data_tmp) {
			$this->flash(__('no order to complete is actually defined'), $url_to_redirect);
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
			$this->flash(__('no order to complete is actually defined'), $url_to_redirect);
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
		
		// Set url for cancel button
		$this->set('url_to_cancel', $url_to_redirect);
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Structures
		$this->Structures->set('view_aliquot_joined_to_sample_and_collection', 'atim_structure_for_aliquots_list');
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

		if($launch_save_process) {
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
				$this->OrderItem->addWritableField(array('order_id', 'order_line_id', 'status', 'aliquot_master_id'));
				foreach($aliquot_ids_to_add as $added_aliquot_master_id) {
					// Add order item
					$new_order_item_data = array();
					$new_order_item_data['OrderItem']['status'] = 'pending';
					$new_order_item_data['OrderItem']['aliquot_master_id'] = $added_aliquot_master_id;
					$new_order_item_data['OrderItem'] = array_merge($new_order_item_data['OrderItem'], $this->request->data['OrderItem']);
					$this->OrderItem->addWritableField(array('status', 'aliquot_master_id'));
					$this->OrderItem->data = null;
					$this->OrderItem->id = null;
					if(!$this->OrderItem->save($new_order_item_data, false)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
					
					// Update aliquot master status
					$new_aliquot_master_data = array();
					$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
					$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
					$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $added_aliquot_master_id;
					if(!$this->AliquotMaster->save($new_aliquot_master_data)) { 
						$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
					}
					
					// Update Aliquot Use Counter
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($added_aliquot_master_id, false, true)) {
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
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
	
	function edit($is_items_returned, $order_id = 0, $order_line_id = 0, $shipment_id = 0) {
		$initial_display = false;
		
		$url_to_cancel = 'javascript:history.go(-1)';
		if(isset($this->request->data['url_to_cancel'])) {
			$url_to_cancel = $this->request->data['url_to_cancel'];
			if(preg_match('/^javascript:history.go\((-?[0-9]*)\)$/', $url_to_cancel, $matches)){
				$back = empty($matches[1]) ? -1 : $matches[1] - 1;
				$url_to_cancel = 'javascript:history.go('.$back.')';
			}
		}
		unset($this->request->data['url_to_cancel']);
		
		$criteria = array('OrderItem.id' => '-1');
		$order_item_ids_for_sorting = array();
		if($order_id || $order_line_id || $shipment_id){
			// User is workning on an order
			if($order_line_id && $shipment_id) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
			if($order_line_id) {
				$order_line_data = $this->OrderLine->getOrRedirect($order_line_id);
			} else if($shipment_id) {
				$order_line_data = $this->Shipment->getOrRedirect($shipment_id);
			}
			$this->Order->getOrRedirect($order_id);
			$criteria = array('OrderItem.order_id' => $order_id);
			if($order_line_id) $criteria['OrderItem.order_line_id'] = $order_line_id;
			if($shipment_id) $criteria['OrderItem.shipment_id'] = $shipment_id;
			if(empty($this->request->data)) $initial_display = true;
		} else if(isset($this->request->data['OrderItem']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['OrderItem']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$order_item_ids_for_sorting = array_filter($this->request->data['OrderItem']['id']);
			$criteria = array('OrderItem.id' => $order_item_ids_for_sorting);
			$initial_display = true;
		} else if(!empty($this->request->data)) {
			// User submit data of the OrderItem.edit() form
			$order_item_ids_for_sorting = explode(',',$this->request->data['order_item_ids_for_sorting']);
			$criteria = array('OrderItem.id' => $order_item_ids_for_sorting);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		unset($this->request->data['order_item_ids_for_sorting']);
		
		// Get data
		$criteria['OrderItem.status'] = ($is_items_returned? 'shipped & returned' : 'pending');
		$items_data = $this->OrderItem->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));
		
		if(empty($items_data)) {
			$this->flash(__($is_items_returned? 'no returned item exists' : 'no unshipped item exists'), $url_to_cancel);
		}
		
		$display_limit = Configure::read('edit_processed_items_limit');
		if(sizeof($items_data) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit). ".__('use databrowser to submit a sub set of data'), $url_to_cancel, 5);
		}
		
		$order_items_data_from_id = array();
		foreach($items_data as $new_order_item_data)
			$order_items_data_from_id[$new_order_item_data['OrderItem']['id']] = $new_order_item_data;
		
		foreach($order_item_ids_for_sorting as $key_value => $tested_id) if(!array_key_exists($tested_id, $order_items_data_from_id)) unset($order_item_ids_for_sorting[$key_value]);
		if($order_item_ids_for_sorting && $items_data) $this->OrderItem->sortForDisplay($items_data, $order_item_ids_for_sorting);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('is_items_returned', $is_items_returned);
		$this->set('order_id', $order_id);
		$this->set('order_line_id', $order_line_id);
		$this->set('shipment_id', $shipment_id);
		$this->set('order_item_ids_for_sorting', implode(',',$order_item_ids_for_sorting));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set($is_items_returned? 'orderitems_returned' : 'orderitems');
		
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
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// SAVE DATA
		
		if($initial_display) {
			$this->request->data = $items_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
					
		} else {
			
			// Launch validation
			$submitted_data_validates = true;	
			
			$errors = array();	
			$record_counter = 0;
			$ids_to_save = array();
			foreach($this->request->data as $key => $new_studied_item){
				$record_counter++;
				$order_item_id = $new_studied_item['OrderItem']['id'];
				if(!isset($order_items_data_from_id[$order_item_id])) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				// Launch Order Item validation
				$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
				$this->OrderItem->set($new_studied_item);
				$submitted_data_validates = ($this->OrderItem->validates()) ? $submitted_data_validates : false;
				$new_studied_item = $this->OrderItem->data;
				foreach($this->OrderItem->validationErrors as $field => $msgs) {
					$msgs = is_array($msgs)? $msgs : array($msgs);
					foreach($msgs as $msg) $errors['OrderItem'][$field][$msg][]= $record_counter;
				}
				// Reset data
				$this->request->data[$key] = $new_studied_item;	
				// Check data should be saved
				$diff = array_diff($new_studied_item['OrderItem'], $order_items_data_from_id[$order_item_id]['OrderItem']);
				if($diff) $ids_to_save[] = $order_item_id;	
			}		
			if(!$ids_to_save) {
				$submitted_data_validates = false;
				$errors['OrderItem']['id']['at least one data should be updated'] = array();
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
		
			if ($submitted_data_validates) {
				
				AppModel::acquireBatchViewsUpdateLock();
				
				if($is_items_returned) $this->OrderItem->writable_fields_mode = 'editgrid';
				
				// Launch save process
				foreach($this->request->data as $order_item){
					$order_item_id = $order_item['OrderItem']['id'];
					if(in_array($order_item_id, $ids_to_save)) {
						// Save data
						$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
						$this->OrderItem->id = $order_item['OrderItem']['id'];
						if(!$this->OrderItem->save($order_item['OrderItem'], false)) {
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						}
					}
				}

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				if($shipment_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id);
				} else if($order_line_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id);
				} else if($order_id){
					$this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/'.$order_id);
				}else{
					//batch
					$batch_ids = $order_item_ids_for_sorting;
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
	
	function delete($order_id, $order_item_id) {
		
		// MANAGE DATA
		
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderItem.order_id' => $order_id)));
		if(empty($order_item_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
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
				
				// Update AliquotMaster data
				$new_aliquot_master_data = array();
				$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - available';
				$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = '';
				
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->AliquotMaster->id = $order_item_data['OrderItem']['aliquot_master_id'];
				if(!$this->AliquotMaster->save($new_aliquot_master_data)) { 
					$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
				}
				
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($order_item_data['OrderItem']['aliquot_master_id'], false, true)) {
					$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
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
				$this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), 'javascript:history.go(-1)');
			} else {
				$this->flash(__('error deleting data - contact administrator'), 'javascript:history.go(-1)');
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), 'javascript:history.go(-1)');
		}
	}
	
	function defineOrderItemsReturned($order_id = 0, $order_line_id = 0, $shipment_id = 0) {
		$initial_display = false;
		
		$url_to_cancel = 'javascript:history.go(-1)';
		if(isset($this->request->data['url_to_cancel'])) {
			$url_to_cancel = $this->request->data['url_to_cancel'];
			if(preg_match('/^javascript:history.go\((-?[0-9]*)\)$/', $url_to_cancel, $matches)){
				$back = empty($matches[1]) ? -1 : $matches[1] - 1;
				$url_to_cancel = 'javascript:history.go('.$back.')';
			}
		}
		unset($this->request->data['url_to_cancel']);
		
		// MANAGE DATA
		
		$criteria = array('OrderItem.id' => '-1');
		$order_item_ids_for_sorting = array();
		if($order_id){
			// User is workning on an order
			$this->Order->getOrRedirect($order_id);
			$criteria = array('OrderItem.order_id' => $order_id);
			if($order_line_id) $criteria['OrderItem.order_line_id'] = $order_line_id;
			if($shipment_id) $criteria['OrderItem.shipment_id'] = $shipment_id;
			if(empty($this->request->data)) $initial_display = true;
		} else if(isset($this->request->data['OrderItem']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['OrderItem']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$order_item_ids_for_sorting = array_filter($this->request->data['OrderItem']['id']);
			$criteria = array('OrderItem.id' => $order_item_ids_for_sorting);
			$initial_display = true;
		} else if(!empty($this->request->data)) {
			// User submit data of the OrderItem.defineOrderItemsReturned() form
			$order_item_ids_for_sorting = explode(',',$this->request->data['order_item_ids_for_sorting']);
			$criteria = array('OrderItem.id' => $order_item_ids_for_sorting);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		unset($this->request->data['order_item_ids_for_sorting']);
		
		$criteria[] = array('OrderItem.status' => 'shipped');
		$order_items_data = $this->OrderItem->find('all', array('conditions' => $criteria, 'order'=>'AliquotMaster.barcode'));
		if(empty($order_items_data)) {
			$this->flash(__('no order items can be defined as returned'), $url_to_cancel);
		}
		
		$display_limit = Configure::read('defineOrderItemsReturned_processed_items_limit');
		if(sizeof($order_items_data) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit). ".__('use databrowser to submit a sub set of data'), $url_to_cancel, 5);
		}
		
		$order_items_data_from_id = array();
		foreach($order_items_data as $new_order_item_data)
			$order_items_data_from_id[$new_order_item_data['OrderItem']['id']] = $new_order_item_data;
	
		foreach($order_item_ids_for_sorting as $key_value => $tested_id) if(!array_key_exists($tested_id, $order_items_data_from_id)) unset($order_item_ids_for_sorting[$key_value]);
		if($order_item_ids_for_sorting && $order_items_data) $this->OrderItem->sortForDisplay($order_items_data, $order_item_ids_for_sorting);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('order_id', $order_id);
		$this->set('order_line_id', $order_line_id);
		$this->set('shipment_id', $shipment_id);
		$this->set('order_item_ids_for_sorting', implode(',',$order_item_ids_for_sorting));
		
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
			
			$this->request->data = $order_items_data;
				
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
			foreach($this->request->data as $key => $new_studied_item){
				$record_counter++;
				$order_item_id = $new_studied_item['OrderItem']['id'];
				if(!isset($order_items_data_from_id[$order_item_id])) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				if($new_studied_item['FunctionManagement']['defined_as_returned']) {
					// Launch Item validation
					$this->OrderItem->data = array();	// *** To guaranty no merge will be done with previous data ***
					$this->OrderItem->set($new_studied_item);
					$submitted_data_validates = ($this->OrderItem->validates()) ? $submitted_data_validates : false;
					$new_studied_item = $this->OrderItem->data;
					foreach($this->OrderItem->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors['OrderItem'][$field][$msg][]= $record_counter;
					}
					// Reset data
					$this->request->data[$key] = $new_studied_item;		
					//Check item is flagged as shipped
					if($order_items_data_from_id[$order_item_id]['OrderItem']['status'] != 'shipped') $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
					//At least one item is defined as returned
					$at_least_one_item_defined_as_returned = true;
				}
			}						
			
			if(!$at_least_one_item_defined_as_returned) {
				$errors['OrderItem']['defined_as_returned']['at least one item should be defined as returned'] = array();
				$submitted_data_validates = false;
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}

			if ($submitted_data_validates) {
				
				AppModel::acquireBatchViewsUpdateLock();
				
				// Launch save process
				
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				
				$this->OrderItem->writable_fields_mode = 'editgrid';
				$this->OrderItem->addWritableField(array('status'));
				
				foreach($this->request->data as $new_studied_item){
					if($new_studied_item['FunctionManagement']['defined_as_returned']) {
						// Get ids
						
						$order_item_id = $new_studied_item['OrderItem']['id'];
						$aliquot_master_id = $order_items_data_from_id[$order_item_id]['OrderItem']['aliquot_master_id'];
							
						// 1- Update Aliquot Master Data
						$aliquot_master = array();
						$aliquot_master['AliquotMaster']['in_stock'] = 'yes - available';
						$aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped & returned';
							
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						$this->AliquotMaster->id = $aliquot_master_id;
						if(!$this->AliquotMaster->save($aliquot_master, false)) {
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						}
							
						// 2- Record Order Item Update
						$order_item_data = $new_studied_item;
						$order_item_data['OrderItem']['status'] = 'shipped & returned';
							
						$this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						$this->OrderItem->id = $order_item_id;
						if(!$this->OrderItem->save($order_item_data, false)) {
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						}
					
						// 3- Update Aliquot Use Counter
						if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) {
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						}
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				// Redirect
				
				AppModel::releaseBatchViewsUpdateLock();
				
				if($shipment_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id);
				} else if($order_line_id) {
					$this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id);
				} else if($order_id){
					$this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/'.$order_id);
				}else{
					//batch
					$batch_ids = $order_item_ids_for_sorting;
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
	
	function removeFlagReturned($order_id, $order_item_id) {
	
		// MANAGE DATA
	
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderItem.order_id' => $order_id)));
		if(empty($order_item_data) || $order_item_data['OrderItem']['status'] != 'shipped & returned') {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	
		// Check the status of the order item can be changed to shipped
		$error = null;
		if(!$this->OrderItem->checkAliquotOrderItemStatusCanBeSetToPendingShipped($order_item_data['OrderItem']['aliquot_master_id'], $order_item_data['OrderItem']['id'])) {
			$error = "the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses";
		}
		
		$hook_link = $this->hook();
		if( $hook_link ) {
			require($hook_link);
		}
	
		if(!$error) {
			$aliquot_master_id = $order_item_data['OrderItem']['aliquot_master_id'];
			
			// Launch status change
			$order_item_data = array();
			$order_item_data['OrderItem']['status'] = 'shipped';
			$order_item_data['OrderItem']['date_returned'] = null;
			$order_item_data['OrderItem']['date_returned_accuracy'] = null;
			$order_item_data['OrderItem']['reason_returned'] = null;
			$order_item_data['OrderItem']['reception_by'] = null;
			$this->OrderItem->addWritableField(array('status','date_returned','date_returned_accuracy','reason_returned', 'reception_by'));
			$this->OrderItem->id = $order_item_id;
			if(!$this->OrderItem->save($order_item_data)) {
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
			}
			
			// Update Aliquot Use Counter
			if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) {
				$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			}
	
			$hook_link = $this->hook('postsave_process');
			if( $hook_link ) {
				require($hook_link);
			}
	
			// Redirect
			$this->atimFlash(__('your data has been saved'), 'javascript:history.go(-1)');
		} else {
			$this->flash(__($error), 'javascript:history.go(-1)');
		}
	}
}
?>