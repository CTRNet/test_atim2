<?php

class AliquotUse extends InventoryManagementAppModel {
	
		var $useTable = false;
		
	var $belongsTo = array(       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));

	public static $mValidate = null;
	
}

?>
