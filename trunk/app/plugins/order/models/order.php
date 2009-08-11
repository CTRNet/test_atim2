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
				'Summary'	 => array(
					'menu'			=>	array( NULL, __($result['Order']['short_title'], TRUE)),
					'title'			=>	array( NULL, __($result['Order']['short_title'], TRUE)),
					
					'description'	=>	array(
						__('order number', TRUE)		=>	__($result['Order']['order_number'], TRUE),
						__('date placed', TRUE)			=>	__($result['Order']['date_order_placed'], TRUE),
						__('processing status', TRUE)	=>  __($result['Order']['processing_status'], TRUE),
						__('description', TRUE)	    	=>  __($result['Order']['description'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>