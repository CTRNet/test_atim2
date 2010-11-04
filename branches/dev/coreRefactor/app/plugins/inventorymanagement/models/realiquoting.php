<?php

class Realiquoting extends InventoryManagementAppModel {

	var $belongsTo = array(
		'AliquotMaster' => array(
			'className' => 'Inventorymanagement.AliquotMaster',
			'foreignKey' => 'parent_aliquot_master_id'),
		'AliquotMasterChildren' => array(
			'className' => 'Inventorymanagement.AliquotMaster',
			'foreignKey' => 'child_aliquot_master_id'),
		'AliquotUse' => array(
			'className => Inventorymanagement.AliquotUse',
			'foreignKey' => 'aliquot_use_id'));
	
}

?>
