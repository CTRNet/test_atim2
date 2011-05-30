<?php
class QcGastroQcScore extends InventorymanagementAppModel{
	var $belongsTo = array(       
		'QualityCtrl' => array(           
			'className'    => 'Inventorymanagement.QualityCtrl',            
			'foreignKey'    => 'quality_ctrl_id')
	);
}