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
	
	/**
	 * Check if an order can be deleted.
	 * 
	 * @param $order_id Id of the studied order.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($order_id){
		// Check no order line exists
		$order_ling_model = AppModel::atimNew("Order", "OrderLine", true);
		$returned_nbr = $order_ling_model->find('count', array('conditions' => array('OrderLine.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'order line exists for the deleted order'); 
		}
	
		// Check no order line exists
		$shipment_model = AppModel::atimNew("Order", "Shipment", true);
		$returned_nbr = $shipment_model->find('count', array('conditions' => array('Shipment.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'shipment exists for the deleted order'); 
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
  
}

?>