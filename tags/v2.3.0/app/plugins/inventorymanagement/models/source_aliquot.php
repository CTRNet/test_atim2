<?php

class SourceAliquot extends InventoryManagementAppModel {

	var $belongsTo = array(        
		'SampleMaster' => array(           
			'className'    => 'Inventorymanagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id'),       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));
			
}

?>
