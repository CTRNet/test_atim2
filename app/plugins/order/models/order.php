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
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Order']['short_title']),
					'title'			=>	array( NULL, $result['Order']['short_title']),
					
					'description'	=>	array(
						'order number'	=>	$result['Order']['order_number'],
						'date placed'		=>	$result['Order']['date_order_placed'],
						'processing status'   =>  $result['Order']['processing_status'],
						'description'      => $result['Order']['description']
					)
				)
			);
		}
		
		return $return;
	}
}

?>