<?php

class RealiquotingControl extends InventorymanagementAppModel {

	var $belongsTo = array(
		'ParentSampleToAliquotControl' => array(
			'className'   => 'Inventorymanagement.SampleToAliquotControl',
			'foreignKey'  => 'parent_sample_to_aliquot_control_id'),
		'ChildSampleToAliquotControl' => array(
			'className'   => 'Inventorymanagement.SampleToAliquotControl',
			'foreignKey'  => 'child_sample_to_aliquot_control_id'));  
			
}

?>