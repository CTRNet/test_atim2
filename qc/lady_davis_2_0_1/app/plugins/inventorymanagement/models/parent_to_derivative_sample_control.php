<?php

class ParentToDerivativeSampleControl extends InventoryManagementAppModel {
	
	var $belongsTo = array(
		'ParentSampleControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			 'foreignKey'  => 'parent_sample_control_id'),
		'DerivativeControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			 'foreignKey'  => 'derivative_sample_control_id'));  	
	
}

?>
