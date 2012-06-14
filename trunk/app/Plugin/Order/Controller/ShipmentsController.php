<?php

class ShipmentsController extends OrderAppController {

	var $components = array();
		
	var $uses = array(
		'Order.Shipment', 
		'Order.Order', 
		'Order.OrderItem', 
		'Order.OrderLine',
		
		'InventoryManagement.AliquotMaster');
		
	var $paginate = array('Shipment'=>array('limit' => pagination_amount,'order'=>'Shipment.datetime_shipped DESC'));

	function search($search_id = 0){
		$this->set('atim_menu', $this->Menus->get('/Order/orders/search'));
		$this->searchHandler($search_id, $this->Shipment, 'shipments', '/InventoryManagement/Shipments/search');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}	
		
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->getOrRedirect($order_id);
		
		// Get shipments
		$shipments_data = $this->paginate($this->Shipment, array('Shipment.order_id'=>$order_id));
		$this->request->data = $shipments_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id ) {

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->getOrRedirect($order_id);
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( !empty($this->request->data) ) {
			// Set order id
			$this->request->data['Shipment']['order_id'] = $order_id;
			
			// Launch validation
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			$this->Shipment->addWritableField('order_id');
			if ($submitted_data_validates && $this->Shipment->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been saved','/Order/Orders/detail/'.$order_id.'/' );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		
		// Get shipment data
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id, 'Shipment.order_id'=>$order_id)));
		if(empty($shipment_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}				

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( empty($this->request->data) ) {
			$this->request->data = $shipment_data;	
					
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			$this->Shipment->id = $shipment_id;
			if ($submitted_data_validates && $this->Shipment->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated', '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		
		// MANAGE DATA
		
		// Shipment data
		$shipment_data = $this->Shipment->getOrRedirect($shipment_id);
		$this->request->data = $shipment_data;
		
		// Shipped items
		$conditions = array('OrderItem.shipment_id' => $shipment_id);
		$shipped_items = $this->paginate($this->OrderItem, $conditions);
		$aliquots_for_batchset = $this->OrderItem->find('all', array('fields' => array('AliquotMaster.id'), 'conditions' => $conditions));
		$this->set('shipped_items', $shipped_items);
		$this->set('aliquots_for_batchset', $aliquots_for_batchset);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$this->Structures->set('shippeditems', 'atim_structure_for_shipped_items');	
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		$shipment_data = $this->Shipment->getOrRedirect($shipment_id);

		// Check deletion is allowed
		$arr_allow_deletion = $this->Shipment->allowDeletion($shipment_id);
			
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->Shipment->atimDelete( $shipment_id )) {
				$this->atimFlash('your data has been deleted', 'javascript:history.go(-1)');
			} else {
				$this->flash('error deleting data - contact administrator', 'javascript:history.go(-1)');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], 'javascript:history.go(-1)');
		}
	}
	
	/* ----------------------------- SHIPPED ITEMS ---------------------------- */
	
	function addToShipment($order_id, $shipment_id){
		
		// MANAGE DATA
		
		// Check shipment
		$shipment_data = $this->Shipment->getOrRedirect($shipment_id);
		
		// Get available order items
		$available_order_items = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL'), 'order' => 'OrderItem.date_added DESC, OrderLine.id'));
		if(empty($available_order_items)) { 
			$this->flash('no new item could be actually added to the shipment', '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id);  
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Order.id' => $order_id, 'Shipment.id' => $shipment_id));
		
		$this->Structures->set('shippeditems');		
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(empty($this->request->data)){
			$this->request->data = $this->formatDataForShippedItemsSelection($available_order_items);
		
		} else {	
				
			// Launch validation
			$submitted_data_validates = true;
			$data_to_save = array_filter($this->request->data['OrderItem']['id']);
			
			if(empty($data_to_save)) { 
				$this->OrderItem->validationErrors[] = 'no item has been defined as shipped';	
				$submitted_data_validates = false;	
				$this->request->data = $this->formatDataForShippedItemsSelection($available_order_items);
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
					
			if ($submitted_data_validates) {	
				// Launch Save Process
				$order_line_to_update = array();
				
				$available_order_items = AppController::defineArrayKey($available_order_items, 'OrderItem', 'id', true);
				
				foreach($data_to_save as $order_item_id){
					$order_item = isset($available_order_items[$order_item_id]) ? $available_order_items[$order_item_id] : null;
					if($order_item == null){
						//hack attempt
						continue;
					}
					
					// Get id
					$aliquot_master_id = $order_item['AliquotMaster']['id'];
					
					// 1- Update Aliquot Master Data
					$aliquot_master = array();
					$aliquot_master['AliquotMaster']['in_stock'] = 'no';
					$aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped';
					$aliquot_master['AliquotMaster']['storage_master_id'] = null;
					$aliquot_master['AliquotMaster']['storage_coord_x'] = '';
					$aliquot_master['AliquotMaster']['storage_coord_y'] = '';
		
					$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail', 'storage_master_id','storage_coord_x','storage_coord_y'));
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($aliquot_master, false)) {
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// 2- Record Order Item Update
					$order_item_data = array();
					$order_item_data['OrderItem']['shipment_id'] = $shipment_data['Shipment']['id'];
					$order_item_data['OrderItem']['status'] = 'shipped';

					$this->OrderItem->addWritableField(array('shipment_id', 'status'));
					
					$this->OrderItem->id = $order_item_id;
					if(!$this->OrderItem->save($order_item_data, false)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
						
					// 3- Update Aliquot Use Counter					
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// 4- Set order line to update
					$order_line_id = $order_item['OrderLine']['id'];
					$order_line_to_update[$order_line_id] = $order_line_id;
				}
				
				$hook_link_line = $this->hook('postsave_process_line');
				foreach($order_line_to_update as $order_line_id){
					$items_counts = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status != "shipped"')));
					if($items_counts == 0){
						//update if everything is shipped
						$order_line = array();
						$order_line['OrderLine']['status'] = "shipped";
						$this->OrderLine->addWritableField(array('status'));
						$this->OrderLine->id = $order_line_id;
						if(!$this->OrderLine->save($order_line, false)) { 
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), 
					'/Order/Shipments/detail/'.$order_id.'/'.$shipment_id.'/');
			}		
		}	
	}
	
	function formatDataForShippedItemsSelection($order_items) {
		$sample_control_model = AppModel::getInstance('InventoryManagement', 'SampleControl');
		$aliquot_control_model = AppModel::getInstance('InventoryManagement', 'AliquotControl');
		foreach($order_items as $order_item){
			if(!isset($data[$order_item['OrderLine']['id']])){
				$sample_ctrl = $sample_control_model->findById($order_item['OrderLine']['sample_control_id']);
				$name = __($sample_ctrl['SampleControl']['sample_type']);
				if($order_item['OrderLine']['aliquot_control_id']){
					$aliquot_ctrl = $aliquot_control_model->findById($order_item['OrderLine']['aliquot_control_id']);
					$name .= ' - '.$aliquot_ctrl['AliquotControl']['aliquot_type'];
				}
				if($order_item['OrderLine']['sample_aliquot_precision']){
					$name .= ' - '.$order_item['OrderLine']['sample_aliquot_precision'];
				}
				$data[$order_item['OrderLine']['id']] = array('name' => $name, 'data' => array());
			}
			$data[$order_item['OrderLine']['id']]['data'][] = $order_item;
		}
		
		return $data;
	}
	
	function deleteFromShipment($order_id, $order_item_id, $shipment_id){
		// MANAGE DATA
		
		// Check item
		$order_item_data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id, 'OrderItem.shipment_id'=>$shipment_id), 'recursive' => '-1'));
		if(empty($order_item_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	

		// Set ids
		$order_line_id = $order_item_data['OrderItem']['order_line_id'];
		$aliquot_master_id = $order_item_data['OrderItem']['aliquot_master_id'];
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->Shipment->allowItemRemoveFromShipment($order_item_id, $shipment_id);
			
		$hook_link = $this->hook('delete_from_shipment');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		// LAUNCH DELETION
		
		$url = '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id;
		
		if($arr_allow_deletion['allow_deletion']) {
			$remove_done = true;

			// -> Remove order item from shipment	
			$order_item = array();
			$order_item['OrderItem']['shipment_id'] = null;
			$order_item['OrderItem']['aliquot_use_id'] = null;
			$order_item['OrderItem']['status'] = 'pending';
			$this->OrderItem->addWritableField(array('shipment_id', 'status','aliquot_use_id'));
			$this->OrderItem->id = $order_item_id;
			if(!$this->OrderItem->save($order_item, false)) { 
				$remove_done = false; 
			}

			// -> Update aliquot master
			if($remove_done) {
				$new_aliquot_master_data = array();
				$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
				$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
				$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->AliquotMaster->id = $aliquot_master_id;
				if(!$this->AliquotMaster->save($new_aliquot_master_data, false)) { 
					$remove_done = false; 
				}
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) { 
					$remove_done = false; 
				}
			}
			
			// -> Update order line
			if($remove_done) {			
				$order_line = array();
				$order_line['OrderLine']['status'] = "pending";
				$this->OrderLine->addWritableField(array('status'));
				$this->OrderLine->id = $order_line_id;
				if(!$this->OrderLine->save($order_line, false)) { 
					$remove_done = false; 
				}	
			}

			// Redirect
			if($remove_done) {
				$this->atimFlash('your data has been removed - update the aliquot in stock data', $url);
			} else {
				$this->flash('error deleting data - contact administrator', $url);
			}
		
		} else {
			$this->flash($arr_allow_deletion['msg'], $url);
		}
	}
	
	function manageContact(){
		$this->Structures->set('shipment_recipients');
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		$contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
		$this->request->data = $contacts_model->find('all');
	}
	
	function saveContact(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		if(!empty($this->request->data) && isset($this->request->data['Shipment'])){
			$contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
			$shipment_contact_keys = array_fill_keys(array("recipient", "facility", "delivery_street_address", "delivery_city", "delivery_province", "delivery_postal_code", "delivery_country"), null);
			$shipment_data = array_intersect_key($this->request->data['Shipment'], $shipment_contact_keys);
			
			$contacts_model->save($shipment_data);
			
			echo __('your data has been saved');
			exit;
		} 
	}
	
	function deleteContact($contact_id){
		$contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
		$contacts_model->atimDelete($contact_id);
		exit;
	}
}

?>