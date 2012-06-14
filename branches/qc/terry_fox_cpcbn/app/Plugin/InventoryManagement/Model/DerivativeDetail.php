<?php

class DerivativeDetail extends InventoryManagementAppModel {
	var $primaryKey = 'sample_master_id';
	
	var $registered_view = array(
			'InventoryManagement.ViewSample' => array('sample_master_id', 'parent_sample_id', 'initial_specimen_sample_id'),
			'InventoryManagement.ViewAliquot' => array('sample_master_id')
	);
}
