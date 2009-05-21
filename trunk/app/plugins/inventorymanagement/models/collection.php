<?php

class Collection extends InventoryManagementAppModel
{
    var $name = 'Collection';
	var $useTable = 'collections';
	
	var $hasMany 
		= array('SampleMaster' =>
	         array('className'   => 'SampleMaster',
	               'conditions'  => '',
	               'order'       => '',
	               'limit'       => '',
	               'foreignKey'  => 'collection_id',
	               'dependent'   => true,
	               'exclusive'   => false,
	               'finderSql'   => ''));
								
	var $validate = array();
	
}

?>
