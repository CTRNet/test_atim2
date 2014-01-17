<?php

class OrderItem extends OrderAppModel {
	
	var $belongsTo = array(       
		'OrderLine' => array(           
			'className'    => 'Order.OrderLine',            
			'foreignKey'    => 'order_line_id',
			'type'			=> 'INNER'),      
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
}

?>