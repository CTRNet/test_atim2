<?php

class SpecimenDetail extends InventoryManagementAppModel {
	var $primaryKey = 'sample_master_id';

	var $registered_view = array(
		'InventoryManagement.ViewSample' => array('SampleMaster.id', 'ParentSampleMaster.id', 'SpecimenSampleMaster.id'),
		'InventoryManagement.ViewAliquot' => array('AliquotMaster.sample_master_id')
	);
}
