<?php

class DerivativeDetail extends InventoryManagementAppModel {
	var $primaryKey = 'sample_master_id';
	
	var $registered_view = array(
			'InventoryManagement.ViewSample' => array('SampleMaster.id', 'SampleMaster.parent_id', 'SampleMaster.initial_specimen_sample_id'),
			'InventoryManagement.ViewAliquot' => array('AliquotMaster.sample_master_id'),
			'InventoryManagement.ViewAliquotUse' => array('SampleMaster.id')
	);
}
