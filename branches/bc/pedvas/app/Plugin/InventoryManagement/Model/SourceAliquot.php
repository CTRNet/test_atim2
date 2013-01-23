<?php

class SourceAliquot extends InventoryManagementAppModel {

	var $belongsTo = array(        
		'SampleMaster' => array(           
			'className'    => 'InventoryManagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id'),       
		'AliquotMaster' => array(           
			'className'    => 'InventoryManagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));
			
}

?>
