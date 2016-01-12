<?php

class OrderCustom extends Order {
	var $useTable = 'orders';
	var $name = 'Order';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Order.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Order.id'=>$variables['Order.id'])));
			
			$return = array(
				'menu'			=>	array( __('order'), ': ' . $result['Order']['order_number']),
				'title'			=>	array( null, __('order') . ': ' . $result['Order']['order_number']),
				'data'			=> $result,
				'structure alias'=>'orders'
			);
		}
		
		return $return;
	}
}

?>