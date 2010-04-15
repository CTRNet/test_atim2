<?php

class AliquotUse extends InventoryManagementAppModel {
	
	var $belongsTo = array(       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));
			
}

?>
