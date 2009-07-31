<?php

class ShipmentsController extends OrderAppController {
	
	var $uses = array('Order.Shipment', 'Order.Order');
	var $paginate = array('Shipment'=>array('limit'=>10,'order'=>'Shipment.shipment_code'));
	
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
	
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		
		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		$this->data = $this->paginate($this->Shipment, array('Shipment.order_id'=>$order_id));
	}

	function add( $order_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
	
		$this->set('atim_menu', $this->Menus->get('/order/shipments/listall'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		if ( !empty($this->data) ) {
			$this->data['Shipment']['order_id'] = $order_id;
			if ( $this->Shipment->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/shipments/detail/'.$order_id.'/'.$this->Shipment->id );
			}
		}	
	}
  
	function edit( $order_id=null, $shipment_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		
		if ( !empty($this->data) ) {
			$this->Shipment->id = $shipment_id;
			if ( $this->Shipment->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/shipments/detail/'.$order_id.'/'.$shipment_id );
			}
		} else {
			$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
		} 
	}
  
	function detail( $order_id=null, $shipment_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'Shipment.id'=>$shipment_id) );
		$this->data = $this->Shipment->find('first',array('conditions'=>array('Shipment.id'=>$shipment_id)));
	}
  
	function delete( $order_id=null, $shipment_id=null ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_ord_no_order_id', NULL, TRUE ); }
		if ( !$shipment_id ) { $this->redirect( '/pages/err_ord_no_ship_id', NULL, TRUE ); }
		
		if( $this->Shipment->del( $shipment_id ) ) {
			$this->flash( 'Your data has been deleted.', '/order/shipments/listall/'.$order_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/order/shipments/listall/'.$order_id );
		}
	}
}

?>