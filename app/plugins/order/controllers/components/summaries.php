<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $order_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		if ( $order_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('orders');
			
			// get order MODEL, and read RECORD 
			$this->Order_For_Summary =& new Order;
			$this->Order_For_Summary->id = $order_id;
			$text_data = $this->Order_For_Summary->read( 'Order.order_number' );
			$desc_data = $this->Order_For_Summary->read( 'Order.short_title' );
			
				$display_summary = array(
					'text'=>array(
						'id'=>$order_id,
						'form'=>$form,
						'data'=>array( $text_data )
					),
					'desc'=>array(
						'id'=>$order_id,
						'form'=>$form,
						'data'=>array( $desc_data )
					)
				);
			
		}
		
		// pass vars for CONTROLLERS 
		return $display_summary;
		
	}
	
}

?>