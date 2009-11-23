<?php

class ShipmentsController extends OrderAppController {
	
	var $uses = array('Order.Shipment', 'Order.Order', 'Order.OrderItem', 'Inventorymanagement.AliquotMaster');
	var $paginate = array('Shipment'=>array('limit'=>10,'order'=>'Shipment.shipment_code'));
	
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', null, true ); }
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		$this->hook();
		$this->data = $this->paginate($this->Shipment, array('Shipment.order_id'=>$order_id));
	}

	function add( $order_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['Shipment']['order_id'] = $order_id;
			if ( $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/shipments/detail/'.$order_id.'/'.$this->Shipment->id );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', null, true ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Shipment->id = $shipment_id;
			if ( $this->Shipment->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} else {
			$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', null, true ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		$this->hook();
		$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', null, true ); }
		
		$this->hook();
		
		if( $this->Shipment->atim_delete( $shipment_id ) ) {
			$this->flash( 'Your data has been deleted.', '/order/shipments/listall/'.$order_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/order/shipments/listall/'.$order_id );
		}
	}
	
	function deleteFromShipment($order_id, $order_item_id, $shipment_id){
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$order_item_id ) { $this->redirect( '/pages/err_ord_no_order_item_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', null, true ); }
		
		
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $order_item_id, 'OrderLine.order_id' => $order_id)));
		if(!empty($order_item)){
			$order_item['OrderItem']['shipment_id'] = null;
			$order_item['AliquotMaster']['status'] = 'pending';
			$this->AliquotMaster->save($order_item);
			
			$this->OrderItem->save($order_item, false);//no validation because we just want to set the shipment_id to null and that is forbidden
			$this->flash('Your data has been deleted.', '/order/shipments/shipment_items/'.$order_id.'/'.$shipment_id.'/');
		}else{
			$this->flash('Invalid deleted.', '/order/shipments/shipment_items/'.$order_id.'/'.$shipment_id.'/');
		}
	}
	
	function addToShipment($order_id, $shipment_id){
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_shipment_id', null, true ); }
		
		if(!empty($this->data)){
			foreach($this->data['foo'] as $item_id){
				if($item_id != 0){
					//this item ships!
					$full_order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.id' => $item_id, 'OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL')));
					$order_item['OrderItem'] = $full_order_item['OrderItem'];
					$aliquot_master['AliquotMaster'] = $full_order_item['AliquotMaster'];
					$order_item['OrderItem']['shipment_id'] = $shipment_id;
					$aliquot_master['AliquotMaster']['status'] = "shipped";
					$this->OrderItem->save($order_item);
					$this->AliquotMaster->save($aliquot_master);
				}
			}
			$this->flash('Your data has been saved.', '/order/shipments/shipment_items/'.$order_id.'/'.$shipment_id.'/');
		}else{
			$this->set('atim_menu_variables', array('Order.id' => $order_id, 'Shipment.id' => $shipment_id));
			$this->set('atim_structure', $this->Structures->get('form', 'orderitems'));
			$this->data = $this->OrderItem->find('all', array('conditions' => array('OrderLine.order_id' => $order_id, 'OrderItem.shipment_id IS NULL')));
		}		
	}
	
	function shipmentItems ( $order_id, $shipment_id ){
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', null, true ); }
		if ( !$shipment_id ) { $this->redirect( 'pages/err_ord_no_ship_id', null, true ); }
		
		$this->set('atim_menu', $this->Menus->get('/order/shipments/shipment_items/%%Order.id%%/%%Shipment.id%%/'));
		
		$this->set('atim_structure', $this->Structures->get('form', 'orderitems'));
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id));
		$this->data = $this->paginate($this->OrderItem, array('OrderItem.shipment_id'=>$shipment_id));
	}
	
}

?>