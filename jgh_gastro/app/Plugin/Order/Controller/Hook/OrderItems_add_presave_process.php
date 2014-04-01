<?php 

			
	if($submitted_data_validates && $order_line_data['Order']['qc_gastro_central_bank_order']){
		$submitted_data_validates = false;
		
		// Order Item Data to save
		$new_order_item_data = array();
		$new_order_item_data['OrderItem'] = $this->request->data['OrderItem'];
		$new_order_item_data['OrderItem']['status'] = 'pending';
		$new_order_item_data['OrderItem']['order_line_id'] = $order_line_id;
		$new_order_item_data['OrderItem']['aliquot_master_id'] = $aliquot_data['AliquotMaster']['id'];
		
		$this->OrderItem->addWritableField(array('status', 'order_line_id', 'aliquot_master_id'));
			
		$this->OrderItem->id = null;
		if($this->OrderItem->save($new_order_item_data)) {
			// Update Order Line status
			$new_order_line_data = array();
			$new_order_line_data['OrderLine']['status'] = 'pending';
			
			$this->OrderLine->addWritableField(array('status'));
			
			$this->OrderLine->id = $order_line_data['OrderLine']['id'];
			if(!$this->OrderLine->save($new_order_line_data)) { 
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true ); 
			}
/*			
			// Update aliquot master status
			$new_aliquot_master_data = array();
			$new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
			$new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
			
			$this->AliquotMaster->addWritableField(array('in_stock', 'in_stock_detail'));
			
			$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$this->AliquotMaster->id = $aliquot_data['AliquotMaster']['id'];
			if(!$this->AliquotMaster->save($new_aliquot_master_data)) {
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true );
			}
*/			
			// Redirect
			$this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id.'/');
		}
	
	}

?>