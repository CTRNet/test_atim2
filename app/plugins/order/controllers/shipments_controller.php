<?php

class ShipmentsController extends OrderAppController {

	var $components = array();
		
	var $uses = array(
		'Order.Shipment', 
		'Order.Order', 
		'Order.OrderItem', 
		'Order.OrderLine', 
		
		'Inventorymanagement.AliquotMaster');
		
	var $paginate = array('Shipment'=>array('limit' => pagination_amount,'order'=>'Shipment.datetime_shipped DESC'));

	function index() {
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));
						
		$_SESSION['ctrapp_core']['search'][$search_id];
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search($search_id) {
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));

		$shipments_structure = $this->Structures->get('form', 'shipments');
		$this->set('atim_structure', $shipments_structure);
		if ($this->data) $_SESSION['ctrapp_core']['search'][$search_id]['criteria'] = $this->Structures->parseSearchConditions($shipments_structure);
		
		$this->data = $this->paginate($this->Shipment, $_SESSION['ctrapp_core']['search'][$search_id]['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search'][$search_id]['results'] = $this->params['paging']['Shipment']['count'];
		$_SESSION['ctrapp_core']['search'][$search_id]['url'] = '/inventorymanagement/shipments/search';
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}	
		
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		
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
		if ( !$order_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
	
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
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been saved','/order/shipments/listall/'.$order_id.'/' );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		
		// Get shipment data
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id, 'Shipment.order_id'=>$order_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }				

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
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated', '/order/shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		
		// Shipment data
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }				
		$this->data = $shipment_data;
		
		// Shipped items
		$shipped_items = $this->paginate($this->OrderItem, array('OrderItem.shipment_id'=>$shipment_id));
		$this->set('shipped_items', $shipped_items);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$this->Structures->set('shippeditems', 'atim_structure_for_shipped_items');	
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }				

		// Check deletion is allowed
		$arr_allow_deletion = $this->Shipment->allowDeletion($shipment_id);
			
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->Shipment->atim_delete( $shipment_id )) {
				$this->atimFlash('your data has been deleted', '/order/shipments/listall/'.$order_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/order/shipments/listall/'.$order_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/order/shipments/detail/'.$order_id.'/'.$shipment_id);
		}
	}
	
	/* ----------------------------- SHIPPED ITEMS ---------------------------- */
	
	function addToShipment($order_id, $shipment_id){
		if (( !$order_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		
		// Check shipment
		$shipment_data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		if(empty($shipment_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		// Get available order items
		$available_order_items = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL'), 'order' => 'OrderItem.date_added DESC, OrderLine.id'));
		if(empty($available_order_items)) { $this->flash('no new item could be actually added to the shipment', '/order/shipments/detail/'.$order_id.'/'.$shipment_id);  }

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
			
			foreach($this->data as $id => $new_studied_item) {
				// New studied item
				if($new_studied_item['FunctionManagement']['use']) {
					// Item has been defined as shipped
					$data_to_save[] = $new_studied_item;
				}
			}
			
			if(empty($data_to_save)) { 
				$this->OrderItem->validationErrors[] = 'no item has been defined as shipped';	
				$submitted_data_validates = false;			
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			if ($submitted_data_validates) {	
				// Launch Save Process
				$order_line_to_update = array();
				
				foreach($data_to_save as $key => $shipped_item){					
					// Get ids
					$order_item_id = $shipped_item['OrderItem']['id'];
					$order_line_id = $shipped_item['OrderLine']['id'];
					$aliquot_master_id = $shipped_item['AliquotMaster']['id'];
					
					// 1- Update Aliquot Master Data
					$aliquot_master = array();
					$aliquot_master['AliquotMaster']['in_stock'] = 'no';
					$aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped';
					$aliquot_master['AliquotMaster']['storage_master_id'] = null;
					$aliquot_master['AliquotMaster']['storage_coord_x'] = null;
					$aliquot_master['AliquotMaster']['storage_coord_y'] = null;	
		
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($aliquot_master, false)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// 2- Record Order Item Update
					$order_item_data = array();
					$order_item_data['OrderItem']['shipment_id'] = $shipment_data['Shipment']['id'];
					$order_item_data['OrderItem']['status'] = 'shipped';

					$this->OrderItem->id = $order_item_id;
					if(!$this->OrderItem->save($order_item_data, false)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
						
					// 3- Update Aliquot Use Counter					
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// 4- Set order line to update
					$order_line_to_update[$order_line_id] = $order_line_id;
				}
				
				$hook_link_line = $this->hook('postsave_process_line');
				foreach($order_line_to_update as $order_line_id){
					$items_counts = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status != "shipped"')));
					if($items_counts == 0){
						//update if everything is shipped
						$order_line = array();
						$order_line['OrderLine']['status'] = "shipped";
						$this->OrderLine->id = $order_line_id;
						if(!$this->OrderLine->save($order_line, false)) { 
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), 
					'/order/shipments/detail/'.$order_id.'/'.$shipment_id.'/');
			}		
		}	
	}
	
	function deleteFromShipment($order_id, $order_item_id, $shipment_id){
		if (( !$order_id ) || ( !$order_item_id ) || ( !$shipment_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE DATA
		
		// Check item
		$order_item_data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id, 'OrderItem.shipment_id'=>$shipment_id), 'recursive' => '-1'));
		if(empty($order_item_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	

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
		
		$url = '/order/shipments/detail/'.$order_id.'/'.$shipment_id;
		
		if($arr_allow_deletion['allow_deletion']) {
			$remove_done = true;

			// -> Remove order item from shipment	
			$order_item = array();
			$order_item['OrderItem']['shipment_id'] = null;
			$order_item['OrderItem']['aliquot_use_id'] = null;
			$order_item['OrderItem']['status'] = 'pending';
			$this->OrderItem->id = $order_item_id;
			if(!$this->OrderItem->save($order_item, false)) { 
				$remove_done = false; 
			}

			// -> Update aliquot master
			if($remove_done) {
				$new_aliquot_master_data = array();
				$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
				$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
				
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
}

?>