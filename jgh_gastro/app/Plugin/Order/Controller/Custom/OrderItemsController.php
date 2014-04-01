<?php

class OrderItemsControllerCustom extends OrderItemsController {
	
	function delete( $order_id, $order_line_id, $order_item_id ) {
		if (( !$order_id ) || ( !$order_line_id ) || ( !$order_item_id )) {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	
		// MANAGE DATA
	
		// Get data
		$order_item_data = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.id' => $order_line_id)));
		if(empty($order_item_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	
		// Check deletion is allowed
		$arr_allow_deletion = $this->OrderItem->allowDeletion($order_item_data);
			
		if($arr_allow_deletion['allow_deletion']) {
			// Launch deletion
				
			if($this->OrderItem->atimDelete($order_item_id)) {
	
//JGH GASTRO				
				$tmp_order = $this->Order->find('first', array('conditions' => array('Order.id' => $order_item_data['OrderLine']['order_id']), 'recursive' => '-1'));				
				if(!$tmp_order['Order']['qc_gastro_central_bank_order']) {
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
				}
//END JGH GASTRO	

				// Update order line status
				$new_status = 'pending';
				$order_item_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id), 'recursive' => '-1'));
				if($order_item_count != 0) {
					$order_item_not_shipped_count = $this->OrderItem->find('count', array('conditions' => array('OrderItem.status != "shipped"', 'OrderItem.order_line_id' => $order_line_id, 'OrderItem.deleted != 1'), 'recursive' => '-1'));
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
	
				// Redirect
				$this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), '/Order/Orders/detail/'.$order_id);
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/Order/Orders/detail/'.$order_id);
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), 'javascript:history.go(-1)');
		}
	}
	
}
?>