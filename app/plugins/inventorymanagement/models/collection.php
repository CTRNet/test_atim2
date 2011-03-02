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
	
	/**
	 * @param array $collection_ids The collection ids whom child existence will be verified
	 * @return array The collection ids having a child
	 */
	function hasChild(array $collection_ids){
		$sample_master = AppModel::atimNew("inventorymanagement", "SampleMaster", true);
		return $sample_master->find('list', array('fields' => array("SampleMaster.collection_id"), 'conditions' => array('SampleMaster.collection_id' => $collection_ids, 'SampleMaster.parent_id IS NULL'), 'group' => array('SampleMaster.collection_id')));
	}
	
}

?>
