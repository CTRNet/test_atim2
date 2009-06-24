<?php

class OrderLinesController extends OrderAppController {
	
	//var $name = 'OrderLines';
	
	var $uses = array('Order.OrderLine', 'Order.Order');
	var $paginate = array('OrderLine'=>array('limit'=>'10','order'=>'OrderLine.date_required'));
	
	function listall( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		$this->data = $this->paginate($this->OrderLine, array('OrderLine.order_id'=>$order_id));
		
	}

 	function add( $order_id=null ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		if ( !empty($this->data) ) {
			$this->data['OrderLine']['order_id'] = $order_id;
			if ( $this->OrderLine->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/order_lines/detail/'.$order_id.'/'.$this->OrderLine->id );
			}
		}	
 	}
  
	function edit( $order_id=null, $order_line_id=null ) {
  
 		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
		
		if ( !empty($this->data) ) {
			$this->OrderLine->id = $order_line_id;
			if ( $this->OrderLine->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/order_lines/detail/'.$order_id.'/'.$order_line_id );
			}
		} else {
			$this->data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id)));
		}
	}
  
 	function detail( $order_id=null, $order_line_id=null ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
		$this->data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id)));
	}
  
	function delete( $order_id=null, $order_line_id=null ) {
    	if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$order_line_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->OrderLine->del( $order_line_id ) ) {
			$this->flash( 'Your data has been deleted.', '/order/order_lines/listall/'.$order_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/order/order_lines/listall/'.$order_id );
		}
	}
	
	
}

?>