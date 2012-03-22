<?php

class ViewAliquot extends InventoryManagementAppModel {
	var $primaryKey = 'aliquot_master_id';
	var $base_model = "AliquotMaster";
	var $base_plugin = 'InventoryManagement';
	
	var $belongsTo = array(
		'AliquotControl' => array(
			'className'    => 'InventoryManagement.AliquotControl',
			'foreignKey'    => 'aliquot_control_id',
			'type'			=> 'INNER'),
		'Collection' => array(
			'className'    => 'InventoryManagement.Collection',
			'foreignKey'    => 'collection_id',
			'type'			=> 'INNER'),
		'SampleMaster' => array(
			'className'    => 'InventoryManagement.SampleMaster',
			'foreignKey'    => 'sample_master_id',
			'type'			=> 'INNER'),
		'StorageMaster' => array(
			'className'    => 'StorageLayout.StorageMaster',
			'foreignKey'    => 'storage_master_id'));
}
