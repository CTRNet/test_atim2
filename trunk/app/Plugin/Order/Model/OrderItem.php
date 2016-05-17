<?php

class OrderItem extends OrderAppModel {
	
	var $belongsTo = array(       
		'OrderLine' => array(           
			'className'    => 'Order.OrderLine',            
			'foreignKey'    => 'order_line_id'),      
		'Shipment' => array(           
			'className'    => 'Order.Shipment',            
			'foreignKey'    => 'shipment_id'),       
		'AliquotMaster' => array(           
			'className'    => 'InventoryManagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id',
			'type'			=> 'INNER'),
		'ViewAliquot' => array(           
			'className'    => 'InventoryManagement.ViewAliquot',            
			'foreignKey'    => 'aliquot_master_id',
			'type'			=> 'INNER')
	);
	
	var $registered_view = array(
			'InventoryManagement.ViewAliquotUse' => array('OrderItem.id')
	);

	/**
	 * Check if an item can be deleted.
	 * 
	 * @param $order_line_data Data of the studied order item.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($order_line_data){
		// Check aliquot is not gel matrix used to create either core
		if(!empty($order_line_data['Shipment']['id'])) { 
			return array('allow_deletion' => false, 'msg' => 'this item cannot be deleted because it was already shipped'); 
		}	
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Check if the order item status can be set/changed to 'pending' or 'shipped': 
	 * An order item linked to an aliquot can have a status equal to 'pending' or 'shipped'
	 * when no other order item linked to the same aliquot has a status equal to 'pending' or 'shipped'
	 *
	 * @param $aliquot_master_id Id of the aliquot linked to the order item (that will be created or that will be updated)
	 * @param $order_item_id Id of the order item
	 *
	 * @return Return results as array:
	 * 	['allow_order_status'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 *
	 * @author N. Luc
	 * @since 2016-05-16
	 */
	function checkAliquotOrderItemStatusCanBeSetToPendingShipped($aliquot_master_id, $order_item_id = '-1'){
		$res = $this->find('count', array('conditions' => array("OrderItem.id != $order_item_id", 'OrderItem.aliquot_master_id' => $aliquot_master_id, 'OrderItem.status' => array('pending', 'shipped')), 'recursive' => '-1'));
		if($res) {
			return false;
		}
		return true;
	}
}

?>