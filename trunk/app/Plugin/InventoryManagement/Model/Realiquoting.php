<?php

class Realiquoting extends InventoryManagementAppModel {

	var $belongsTo = array(
		'AliquotMaster' => array(
			'className' => 'InventoryManagement.AliquotMaster',
			'foreignKey' => 'parent_aliquot_master_id'),
		'AliquotMasterChildren' => array(
			'className' => 'InventoryManagement.AliquotMaster',
			'foreignKey' => 'child_aliquot_master_id'));
	var $registered_view = array(
			'InventoryManagement.ViewAliquotUse' => array('Realiquoting.id')
	);
}

?>
