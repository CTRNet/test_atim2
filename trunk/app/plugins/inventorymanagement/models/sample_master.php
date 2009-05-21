<?php

class SampleMaster extends InventoryManagementAppModel
{
    var $name = 'SampleMaster';
    
	var $useTable = 'sample_masters';

	var $hasMany 
		= array('AliquotMaster' =>
			array('className'   => 'AliquotMaster',
			 	'conditions'  => '',
			 	'order'       => '',
			 	'limit'       => '',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent'   => true,
			 	'exclusive'   => false,
			 	'finderSql'   => ''));
	
	var $validate = array();

}

?>
