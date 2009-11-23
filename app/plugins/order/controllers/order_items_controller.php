<?php

class OrderItemsController extends OrderAppController {
	
	var $uses = array(
		'Inventorymanagement.AliquotMaster',	
	
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem');
		
	var $paginate = array('OrderItem'=>array('limit'=>'10','order'=>'AliquotMaster.barcode'));
	
	function listall( $order_id, $order_line_id ) {
		//todo: add delete button on each line
  		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		

		$this->data = $this->paginate($this->OrderItem, array('OrderItem.order_line_id'=>$order_line_id));			

		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		if($order_line_data['OrderLine']['status'] == 'pending' || $order_line_data['OrderLine']['status'] == ""){
			$this->set( 'status_pending', true);
		}
	}
	
	
	
	
	
	
	function add( $order_id, $order_line_id, $aliquot_master_id = null ) {
//		my function (aliquot->addToOrder) must call this add
//		orderItemShipmentId

		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }
		$tmp = $this->OrderLine->find('first', array('conditions' => array('OrderLine.id' => $order_line_id, 'Order.id' => $order_id, 'OrderLine.deleted' => '0')));
		if(empty($tmp)){
			$this->redirect( '/pages/err_order_no_data', null, true );
		}
		
		if(!empty($this->data) || $aliquot_master_id != null){
			if($aliquot_master_id == null){
				$aliquot_master = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.barcode' => $this->data['AliquotMaster']['barcode'], 'AliquotMaster.deleted' => '0', 'AliquotMaster.status' => 'available')));
			}else{
				$aliquot_master = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id)));
			}
			if(empty($aliquot_master)){
				$this->AliquotMaster->validationErrors["barcode"] = __("invalid barcode", true);
			}else{
				$this->data['OrderItem']['status'] = 'pending';
				$this->data['OrderItem']['order_line_id'] = $order_line_id;
				$this->data['OrderItem']['aliquot_master_id'] = $aliquot_master['AliquotMaster']['id'];
				unset($this->data['AliquotMaster']);
				
				$this->OrderItem->save($this->data);
				$aliquot_master['AliquotMaster']['status'] = 'reserved for order';
				$this->AliquotMaster->save($aliquot_master);
				$this->flash('Your data has been saved.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/');
			}
		}
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
	}
	
	function edit( $order_id, $order_line_id ) {
		//added by and added date (only editable fields)
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }
		//TODO: Validate not shipped already
		if ( !empty($this->data)) {
			$tmp_data = $this->OrderItem->find('all', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status' => 'pending')));
			$valid_barcodes = array();
			foreach($tmp_data as $val){
				$valid_barcodes[$val['AliquotMaster']['barcode']] = 1;
			}
			foreach($this->data as $order_item){
				if(isset($valid_barcodes[$order_item['AliquotMaster']['barcode']])){
					$aliquot_master = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.barcode' => $order_item['AliquotMaster']['barcode'], 'AliquotMaster.deleted' => '0')));
					if($aliquot_master['AliquotMaster']['id']){
						$curr_order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master['AliquotMaster']['id'])));
						unset($this->data['AliquotMaster']);
						unset($order_item['AliquotMaster']);
						unset($order_item['FunctionManangement']);
						$order_item['OrderItem']['id'] = $curr_order_item['OrderItem']['id'];
						$this->OrderItem->save($order_item);
					}
				}
			}
		}

		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
		
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status' => 'pending'));
	}
	
	function detail( $order_id, $order_line_id, $order_item_id ) {
		//TODO: will require structure override
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', null, true ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id, 'OrderItem.id'=>$order_item_id) );
		$this->data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id)));
	}
	
	
	function delete( $order_id, $order_line_id, $order_item_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', null, true ); }
		
		$tmp = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.id' => $order_line_id, 'OrderLine.deleted' => '0')));
		if ( $tmp['Shipment']['id'] == "") {
			$aliquot_master['AliquotMaster'] = $tmp['AliquotMaster'];
			$aliquot_master['AliquotMaster']['status'] = 'available';
			$this->AliquotMaster->save($aliquot_master);
			$this->OrderItem->atim_delete( $order_item_id );
			$this->flash( 'Your data has been deleted.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id );
		} else {
			$this->redirect( '/pages/err_order_no_data', null, true );
		}
	}
	
	function manage_unshipped_items( $order_id, $order_line_id ){
		if( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', null, true ); }
		if( !$order_line_id ) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		
	}
	
	function addInBatch( $order_id, $order_line_id ) {
		
		// set data for easier access
		$process_data = $_SESSION['ctrapp_core']['datamart']['process'];
		
		// kick out to DATAMART if no BATCH data
		$bool_all_aliquots_managed = true;
		
		if ( !isset($process_data['AliquotMaster']) || !is_array($process_data['AliquotMaster']) || !count($process_data['AliquotMaster']) ) {
			$bool_all_aliquots_managed = false;
		}
		
		if($bool_all_aliquots_managed) {
			
			// get Aliquots beeing already included to an order item
			$aliquot_criteria = 'OrderItem.aliquot_master_id IN ('.implode( ',', $process_data['AliquotMaster']['id'] ).')';
			$aliquot_already_included_into_order
				= $this->OrderItem->generateList(
						$aliquot_criteria, 
						null, 
						null, 
						'{n}.OrderItem.aliquot_master_id', 
						'{n}.OrderItem.aliquot_master_id');
			
			
			// get ALIQUOTS matching BATCH data (IDs)
			$aliquot_criteria = '';
			$aliquot_criteria = 'AliquotMaster.id IN ('.implode( ',', $process_data['AliquotMaster']['id'] ).')';
			$aliquot_result = $this->AliquotMaster->findAll( $aliquot_criteria );
		
			if ( is_array($aliquot_result) && count($aliquot_result) ) {
				
				// ADD each ALIQUOT to LINE's ITEMs
				foreach ($aliquot_result as $key=>$val) {
					
					if(isset($aliquot_already_included_into_order[$val['AliquotMaster']['id']])) {
						// This aliquot has already been attached to another order...
						$bool_all_aliquots_managed = false;
					
					} else {
					
						$add_aliquot_data = array();
						$add_aliquot_data['OrderItem'] = array();
						$add_aliquot_data['OrderItem']['id'] = null;
						$add_aliquot_data['OrderItem']['barcode'] = $val['AliquotMaster']['barcode'];
						$add_aliquot_data['OrderItem']['date_added'] = date('Y-m-d');
						$add_aliquot_data['OrderItem']['added_by'] = '';	//$this->othAuth->user('first_name').' '.$this->othAuth->user('last_name');
						$add_aliquot_data['OrderItem']['status'] = 'pending';
						$add_aliquot_data['OrderItem']['created'] = date('Y-m-d G:i');
						$add_aliquot_data['OrderItem']['created_by'] = $this->othAuth->user('id');
						$add_aliquot_data['OrderItem']['modified'] = date('Y-m-d G:i');
						$add_aliquot_data['OrderItem']['modified_by'] = $this->othAuth->user('id');
						$add_aliquot_data['OrderItem']['order_line_id'] = $order_line_id;
						$add_aliquot_data['OrderItem']['aliquot_master_id'] = $val['AliquotMaster']['id'];
						
						$add_aliquot_result = $this->OrderItem->save( $add_aliquot_data );
						
						// Update the status of the aliquot
						$aliq_mast_update = array(
							'id' => $val['AliquotMaster']['id'],
							'status' => 'not available',
							'status_reason' => 'reserved for order',
							'modified' => date('Y-m-d G:i'),
							'modified_by' => $this->othAuth->user('id'));
								
						$this->AliquotMaster->save($aliq_mast_update);	
					
					}
	
				}
				
			}
		}
				
		// empty PROCESS data, process complete
		unset($process_data);
		unset($_SESSION['ctrapp_core']['datamart']['process']);
		
		// REDIRECT to LINE's ITEMs
		if($bool_all_aliquots_managed) {
			$this->flash( 'your data has been updated', '/order_items/listall/'.$order_id.'/'.$order_line_id );
		} else {
			$this->flash( 'the process has been done but a part of the aliquots have not been ' .
					'included', '/order_items/listall/'.$order_id.'/'.$order_line_id );			
		}
		
	}
	
	
}
?>