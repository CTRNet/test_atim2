<?php

class AliquotInternalUse extends InventoryManagementAppModel {
	
	var $belongsTo = array(       
		'AliquotMaster' => array(           
			'className'    => 'InventoryManagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));
	
}

?>
