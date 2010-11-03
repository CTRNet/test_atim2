<?php

class Collection extends InventorymanagementAppModel {

	var $hasMany = array(
		'SampleMaster' => array(
			'className'   => 'Inventorymanagement.SampleMaster',
			 'foreignKey'  => 'collection_id')); 
			 
	var $hasOne = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'collection_id',
			'dependent' => true));
	
	function summary($variables=array()) {
		$return = false;
		
		return $return;
	}
	
}

?>
