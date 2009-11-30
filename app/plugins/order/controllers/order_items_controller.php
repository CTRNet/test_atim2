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
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
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
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
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
				$submitted_data_validates = true;
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}

				$this->data['OrderItem']['status'] = 'pending';
				$this->data['OrderItem']['order_line_id'] = $order_line_id;
				$this->data['OrderItem']['aliquot_master_id'] = $aliquot_master['AliquotMaster']['id'];
				unset($this->data['AliquotMaster']);
				
				if($submitted_data_validates){
					$this->OrderItem->save($this->data);
					$aliquot_master['AliquotMaster']['status'] = 'reserved for order';
					$this->AliquotMaster->save($aliquot_master);
					$this->flash('Your data has been saved.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/');
				}
			}
		}
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));
		
		
	}
	
	function edit( $order_id, $order_line_id ) {
		//added by and added date (only editable fields)
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( !empty($this->data)) {
			$tmp_data = $this->OrderItem->find('all', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status' => 'pending')));
			$valid_barcodes = array();
			foreach($tmp_data as $val){
				$valid_barcodes[$val['AliquotMaster']['barcode']] = 1;
			}
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if($submitted_data_validates) {
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
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
			
		$this->data = $this->OrderItem->find('first',array('conditions'=>array('OrderItem.id'=>$order_item_id)));
	}
	
	
	function delete( $order_id, $order_line_id, $order_item_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_ord_no_line_id', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_item_id', null, true ); }
		
		$tmp = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.id' => $order_line_id, 'OrderLine.deleted' => '0')));
		if($tmp['Shipment']['id'] == ""){
			$aliquot_master['AliquotMaster'] = $tmp['AliquotMaster'];
			$aliquot_master['AliquotMaster']['status'] = 'available';

			$submitted_data_validates = true;
			$hook_link = $this->hook('delete');
			if($hook_link){
				require($hook_link);
			}
			
			if($submitted_data_validates) {
				$this->AliquotMaster->save($aliquot_master);
				$this->OrderItem->atim_delete( $order_item_id );
				$this->flash( 'Your data has been deleted.', '/order/order_items/listall/'.$order_id.'/'.$order_line_id );
			}
		}else{
			$this->flash( "This item cannot be deleted because it was already shipped.", '/order/order_items/listall/'.$order_id.'/'.$order_line_id );
		}
	}
	
	function manage_unshipped_items( $order_id, $order_line_id ){
		if( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', null, true ); }
		if( !$order_line_id ) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true ); }
		
		$this->set( 'atim_menu', $this->Menus->get('/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id));

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
}
?>