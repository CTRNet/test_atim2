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
			$this->warnUnconsentedAliquots($variables['Order.id']);
			
			$result = $this->find('first', array('conditions'=>array('Order.id'=>$variables['Order.id'])));
			
			$return = array(
				'menu'			=>	array( 'order', ': ' . $result['Order']['order_number']),
				'title'			=>	array( null, __('order') . ': ' . $result['Order']['order_number']),
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
		$order_ling_model = AppModel::getInstance("Order", "OrderLine", true);
		$returned_nbr = $order_ling_model->find('count', array('conditions' => array('OrderLine.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'order line exists for the deleted order'); 
		}
	
		// Check no order line exists
		$shipment_model = AppModel::getInstance("Order", "Shipment", true);
		$returned_nbr = $shipment_model->find('count', array('conditions' => array('Shipment.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'shipment exists for the deleted order'); 
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
  
	
	function warnUnconsentedAliquots($order_id){
		$order_line_model = AppModel::getInstance("Order", "OrderLine", true);
		$order_line_data = $order_line_model->find('all', array(
			'conditions' => array('OrderLine.order_id' => $order_id),
			'fields' => array('OrderLine.id'),
			'recursive' => -1
		));
		
		if(empty($order_line_data)){
			return;
		}
		
		$order_line_ids = array();
		foreach($order_line_data as $order_line_data_unit){
			$order_line_ids[] = $order_line_data_unit['OrderLine']['id'];
		}
		
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$order_item_data = $order_item_model->find('all', array(
			'conditions' => array('OrderItem.order_line_id' => $order_line_ids),
			'fields' => array('OrderItem.aliquot_master_id'),
			'recursive' => -1
		));
		
		if(empty($order_item_data)){
			return;
		}
		
		$aliquot_ids = array();
		foreach($order_item_data as $order_item_data_unit){
			$aliquot_ids[] = $order_item_data_unit['OrderItem']['aliquot_master_id'];
		}
		
		if(!empty($aliquot_ids)){
			$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			$unconsented_aliquots = $aliquot_master_model->getUnconsentedAliquots(array('id' => $aliquot_ids));
			if(!empty($unconsented_aliquots)){
				AppController::addWarningMsg(__('aliquot(s) without a proper consent').": ".count($unconsented_aliquots));
			}
		}
	}
}

?>