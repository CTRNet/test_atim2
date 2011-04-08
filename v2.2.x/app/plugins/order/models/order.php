<?php

class Order extends OrderAppModel {
	
	var $hasMany = array(
		'OrderLine' => array(
			'className'   => 'Order.OrderLine',
			 'foreignKey'  => 'order_id'),
		'Shipment' => array(
			'className'   => 'Order.Shipment',
			 'foreignKey'  => 'order_id')); 
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Order.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Order.id'=>$variables['Order.id'])));
			
			$return = array(
				'menu'			=>	array( 'order', ': ' . $result['Order']['order_number']),
				'title'			=>	array( null, __('order', true) . ': ' . $result['Order']['order_number']),
				'data'			=> $result,
				'structure alias'=>'orders'
			);
		}
		
		return $return;
	}
}

?>