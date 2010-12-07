<?php

class QualityCtrlTestedAliquot extends InventoryManagementAppModel {
	
	var $belongsTo = array(        
		'QualityCtrl' => array(           
			'className'    => 'Inventorymanagement.QualityCtrl',            
			'foreignKey'    => 'quality_ctrl_id'),       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'), 
		'AliquotUse' => array(           
			'className'    => 'Inventorymanagement.AliquotUse',            
			'foreignKey'    => 'aliquot_use_id'));

}

?>
