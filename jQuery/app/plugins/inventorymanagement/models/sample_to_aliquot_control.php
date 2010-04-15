<?php

class SampleToAliquotControl extends InventoryManagementAppModel {
	
	var $belongsTo = array(
		'SampleControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			'foreignKey'  => 'sample_control_id'),
		'AliquotControl' => array(
			'className'   => 'Inventorymanagement.AliquotControl',
			'foreignKey'  => 'aliquot_control_id'));  	
		
}

?>
