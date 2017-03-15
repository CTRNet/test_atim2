<?php

class DerivativeDetail extends InventoryManagementAppModel {
	var $primaryKey = 'sample_master_id';
	
	var $registered_view = array(
			'InventoryManagement.ViewSample' => array('SampleMaster.id', 'ParentSampleMaster.id'),
			'InventoryManagement.ViewAliquot' => array('AliquotMaster.sample_master_id'),
			'InventoryManagement.ViewAliquotUse' => array('SampleMaster.id')
	);
}
