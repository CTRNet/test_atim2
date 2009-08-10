<?php

class Order extends OrderAppModel
{
	var $name = 'Order';
	var $useTable = 'orders';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Order.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Order.id'=>$variables['Order.id'])));
			
			$return = array(
				__('Summary', TRUE) => array(
					__('menu',TRUE)			=>	array( NULL, __($result['Order']['short_title'], TRUE)),
					__('title', TRUE)		=>	array( NULL, __($result['Order']['short_title'], TRUE)),
					
					__('description', TRUE)	=>	array(
						__('order number', TRUE)		=>	__($result['Order']['order_number'], TRUE),
						__('date placed', TRUE)			=>	__($result['Order']['date_order_placed'], TRUE),
						__('processing status', TRUE)	=>  __($result['Order']['processing_status'], TRUE),
						__('description', TRUE)	    	=> __($result['Order']['description'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>