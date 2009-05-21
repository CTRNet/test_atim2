<?php

class PathCollectionReview extends InventoryManagementAppModel
{
	var $name = 'PathCollectionReview';
	
	var $useTable = 'path_collection_reviews';
	
	var $belongsTo 
		= array('Collection' =>
			array('className'  => 'Collection',
				'conditions' => '',
				'order'      => '',
				'foreignKey' => 'collection_id'));
		
	var $validate = array();
	
}

?>
