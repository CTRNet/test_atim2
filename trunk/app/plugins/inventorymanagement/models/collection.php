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
		return array_filter($sample_master->find('list', array('fields' => array("SampleMaster.collection_id"), 'conditions' => array('SampleMaster.collection_id' => $collection_ids, 'SampleMaster.parent_id IS NULL'), 'group' => array('SampleMaster.collection_id'))));
	}

	/**
	 * Check if a collection can be deleted.
	 * 
	 * @param $collection_id Id of the studied collection.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($collection_id){
		// Check collection has no sample
		$sample_master_model = AppModel::atimNew("Inventorymanagement", "SampleMaster", true);
		$returned_nbr = $sample_master_model->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sample exists within the deleted collection'); 
		}
		
		// Check Collection has not been linked to a participant, consent or diagnosis
		$criteria = 'ClinicalCollectionLink.collection_id = "' . $collection_id . '" ';
		$criteria .= 'AND ClinicalCollectionLink.participant_id IS NOT NULL';
		$ccl_model = AppModel::atimNew("Clinicalcollection", "ClinicalCollectionLink", true);		
		$returned_nbr = $ccl_model->find('count', array('conditions' => array($criteria), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'the deleted collection is linked to participant'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}
	
}

?>
