<?php

class Realiquoting extends InventoryManagementAppModel {

	var $belongsTo = array(
		'AliquotMaster' => array(
			'className' => 'Inventorymanagement.AliquotMaster',
			'foreignKey' => 'parent_aliquot_master_id'),
		'AliquotMasterChildren' => array(
			'className' => 'Inventorymanagement.AliquotMaster',
			'foreignKey' => 'child_aliquot_master_id'));
	
}

?>
