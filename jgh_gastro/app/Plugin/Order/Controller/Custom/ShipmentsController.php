<?php

class ShipmentsControllerCustom extends ShipmentsController {
	
	/* ----------------------------- SHIPPED ITEMS ---------------------------- */
	
	function addToShipment($order_id, $shipment_id){
		
		// MANAGE DATA
		
		// Check shipment
		$shipment_data = $this->Shipment->getOrRedirect($shipment_id);
		
		// Get available order items
		$available_order_items = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL'), 'order' => 'OrderItem.date_added DESC, OrderLine.id'));
		if(empty($available_order_items)) { 
			$this->flash(__('no new item could be actually added to the shipment'), '/Order/Shipments/detail/'.$order_id.'/'.$shipment_id);  
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Order.id' => $order_id, 'Shipment.id' => $shipment_id));
		
		$this->Structures->set('shippeditems');		
		
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
			
			if ($submitted_data_validates) {

				AppModel::acquireBatchViewsUpdateLock();
				
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
//JGH GASTRO					
					if(!$shipment_data['Shipment']['qc_gastro_central_bank_order'])	{
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
					}
//End JGH GASTRO					
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
				
				AppModel::releaseBatchViewsUpdateLock();
//JGH GASTRO				
				$this->atimFlash(__('your data has been saved').((!$shipment_data['Shipment']['qc_gastro_central_bank_order'])? '<br>'.__('aliquot storage data were deleted (if required)') : ''), 
					'/Order/Shipments/detail/'.$order_id.'/'.$shipment_id.'/');
//END JGH GASTRO				
			}		
		}	
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
//JGH GASTRO
				$tmp_shipment = $this->Shipment->find('first', array('conditions' => array('Shipment.id' => $order_item_data['OrderItem']['shipment_id']), 'recursive' => '-1'));
				if(!$tmp_shipment['Shipment']['qc_gastro_central_bank_order']) {
					$new_aliquot_master_data = array();
					$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
					$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
					$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($new_aliquot_master_data, false)) { 
						$remove_done = false; 
					}
				}
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, false, true)) { 
					$remove_done = false; 
				}
			}
//END JGH GASTRO			
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
				$this->atimFlash(__('your data has been removed - update the aliquot in stock data'), $url);
			} else {
				$this->flash(__('error deleting data - contact administrator'), $url);
			}
		
		} else {
			$this->flash(__($arr_allow_deletion['msg']), $url);
		}
	}
}

?>