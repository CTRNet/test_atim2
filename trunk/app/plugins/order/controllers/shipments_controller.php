<?php

class ShipmentsController extends OrderAppController {
	
	var $uses = array('Order.Shipment', 'Order.Order', 'Order.OrderItem', 'Order.OrderLine', 'Inventorymanagement.AliquotMaster');
	var $paginate = array('Shipment'=>array('limit'=>10,'order'=>'Shipment.shipment_code'));
	
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', null, true ); }
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		$this->data = $this->paginate($this->Shipment, array('Shipment.order_id'=>$order_id));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( !empty($this->data) ) {
			$this->data['Shipment']['order_id'] = $order_id;
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			if ($submitted_data_validates && $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/shipments/detail/'.$order_id.'/'.$this->Shipment->id );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if ( !empty($this->data) ) {
			$this->Shipment->id = $shipment_id;
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			if ($submitted_data_validates && $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} else {
			$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$submitted_data_validates = true;
		$hook_link = $this->hook('delete');
		if($hook_link){
			require($hook_link);
		}
		
		
		if($submitted_data_validates &&  $this->Shipment->atim_delete( $shipment_id ) ) {
			$this->flash( 'your data has been deleted', '/order/shipments/listall/'.$order_id );
		} else {
			$this->flash( 'error deleting data - contact administrator', '/order/shipments/listall/'.$order_id );
		}
	}
	
	function deleteFromShipment($order_id, $order_item_id, $shipment_id){
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.order_id' => $order_id)));
		
		if(!empty($order_item)){
			$order_item['OrderItem']['shipment_id'] = null;
			$order_item['OrderItem']['status'] = 'pending';
			$order_item['AliquotMaster']['status'] = 'reserved for order';
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('delete');
			if($hook_link){
				require($hook_link);
			}

			if($submitted_data_validates){
				$this->AliquotMaster->save($order_item);
				
				$order_line['OrderLine']['id'] = $order_item['OrderItem']['order_line_id'];
				$order_line['OrderLine']['status'] = 'pending';
				$this->OrderLine->save($order_line);
				
				$this->OrderItem->save($order_item, false);//no validation because we just want to set the shipment_id to null and that is forbidden
				$this->flash('your data has been deleted', '/order/shipments/shipmentItems/'.$order_id.'/'.$shipment_id.'/');
			}
		}else{
			$this->flash('Invalid deleted.', '/order/shipments/shipmentItems/'.$order_id.'/'.$shipment_id.'/');
		}
	}
	
	function addToShipment($order_id, $shipment_id){
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
			
		if(!empty($this->data)){
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			if($submitted_data_validates){
				$order_line_to_update = array();
				foreach($this->data['order_item_id'] as $item_id){
					if($item_id != 0){
						//this item ships!
						$full_order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $item_id, 'OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL')));
						$order_item['OrderItem'] = $full_order_item['OrderItem'];
						$order_line_id = $full_order_item['OrderLine']['id'];
						$aliquot_master['AliquotMaster'] = $full_order_item['AliquotMaster'];
						$order_item['OrderItem']['shipment_id'] = $shipment_id;
						$aliquot_master['AliquotMaster']['status'] = "shipped";
						$order_item['OrderItem']['status'] = "shipped";
						$this->OrderItem->save($order_item);
						$this->AliquotMaster->save($aliquot_master);
						
						$order_line_to_update[$order_line_id] = "";
					}
				}
				foreach($order_line_to_update as $order_line_id => $foo){
					$items_counts = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id, 'OrderItem.status != "shipped"')));
					if($items_counts == 0){
						//update if everything is shipped
						$order_line['OrderLine']['id'] = $order_line_id;
						$order_line['OrderLine']['status'] = "shipped";
						$this->OrderLine->save($order_line);
					}
				}
				$this->flash('your data has been saved', '/order/shipments/shipmentItems/'.$order_id.'/'.$shipment_id.'/');
			}
		}else{
			$this->set('atim_menu_variables', array('Order.id' => $order_id, 'Shipment.id' => $shipment_id));
			$this->Structures->set('orderitems');
			$this->data = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL', 'OrderItem.deleted' => 0)));
		}		
	}
	
	function shipmentItems ( $order_id, $shipment_id ){
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		if ( !$shipment_id ) { $this->redirect( 'pages/err_order_funct_param_missing', null, true ); }
		
		$this->set('atim_menu', $this->Menus->get('/order/shipments/shipmentItems/%%Order.id%%/%%Shipment.id%%/'));
		
		$this->Structures->set('orderitems');
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id));
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.shipment_id'=>$shipment_id));
		
		$submitted_data_validates = true;
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
}

?>