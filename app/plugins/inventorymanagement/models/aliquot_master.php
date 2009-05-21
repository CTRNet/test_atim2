<?php

class AliquotMaster extends InventoryManagementAppModel
{
    var $name = 'AliquotMaster';
    
	var $useTable = 'aliquot_masters';

	var $belongsTo 
		= array('StorageMaster' =>
			array('className'  => 'StorageMaster',
                 'conditions' => '',
                 'order'      => '',
                 'foreignKey' => 'storage_master_id'));
                                 
	var $hasMany 
		= array('AliquotUse' =>
			array('className'   => 'AliquotUse',
			 	'conditions'  => '',
			 	'order'       => '',
			 	'limit'       => '',
			 	'foreignKey'  => 'aliquot_master_id',
			 	'dependent'   => true,
			 	'exclusive'   => false,
			 	'finderSql'   => ''));
		
	var $validate = array();

}

?>
