<?php 

	$tmp_order = $this->Order->find('first', array('conditions' => array('Order.id' => $selected_order_line_data['OrderLine']['order_id']), 'recursive' => '-1'));
	if($submitted_data_validates && $tmp_order['Order']['qc_gastro_central_bank_order']){
		$submitted_data_validates = false;
		AppModel::acquireBatchViewsUpdateLock();
		$this->OrderItem->addWritableField(array('order_line_id', 'status', 'aliquot_master_id'));
		foreach($aliquot_ids_to_add as $added_aliquot_master_id) {
			// Add order item
			$new_order_item_data = array();
			$new_order_item_data['OrderItem']['status'] = 'pending';
			$new_order_item_data['OrderItem']['aliquot_master_id'] = $added_aliquot_master_id;
			$new_order_item_data['OrderItem'] = array_merge($new_order_item_data['OrderItem'], $this->request->data['OrderItem']);
			$this->OrderItem->addWritableField(array('status', 'aliquot_master_id'));
			$this->OrderItem->id = null;
			if(!$this->OrderItem->save($new_order_item_data, false)) { 
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
			}
/*			
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
*/			
		}
		
		// Update Order Line status
		$new_order_line_data = array();
		$new_order_line_data['OrderLine']['status'] = 'pending';
		$this->OrderLine->addWritableField(array('status'));
		$this->OrderLine->id = $this->request->data['OrderItem']['order_line_id'];
		if(!$this->OrderLine->save($new_order_line_data)) { 
			$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		AppModel::releaseBatchViewsUpdateLock();
		
		// Redirect
		$this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/'.$order_id.'/'.$this->request->data['OrderItem']['order_line_id'].'/');
	}

?>