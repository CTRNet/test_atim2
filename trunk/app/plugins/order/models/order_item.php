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
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'),       
		'AliquotUse' => array(           
			'className'    => 'Inventorymanagement.AliquotUse',            
			'foreignKey'    => 'aliquot_use_id'));
	
}

?>