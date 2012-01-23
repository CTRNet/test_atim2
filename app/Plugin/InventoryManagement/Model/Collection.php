<?php

class Collection extends InventoryManagementAppModel {

	var $hasMany = array(
		'SampleMaster' => array(
			'className'   => 'InventoryManagement.SampleMaster',
			 'foreignKey'  => 'collection_id')); 
			 
	var $belongsTo = array(
		'Participant' => array(
			'className' => 'ClinicalAnnotation.Participant',
			'foreignKey' => 'participant_id'
		), 'DiagnosisMaster' => array(
			'className' => 'ClinicalAnnotation.DiagnosisMaster',
			'foreignKey' => 'diagnosis_master_id'
		), 'ConsentMaster' => array(
			'className' => 'ClinicalAnnotation.ConsentMaster',
			'foreignKey' => 'consent_master_id'
		)
	);
	
	function summary($variables=array()) {
		$return = false;
		
		return $return;
	}
	
	/**
	 * @param array $collection_ids The collection ids whom child existence will be verified
	 * @return array The collection ids having a child
	 */
	function hasChild(array $collection_ids){
		$sample_master = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
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
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		$returned_nbr = $sample_master_model->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sample exists within the deleted collection'); 
		}
		
		// Check Collection has not been linked to a participant, consent or diagnosis
		$criteria = 'ClinicalCollectionLink.collection_id = "' . $collection_id . '" ';
		$criteria .= 'AND ClinicalCollectionLink.participant_id IS NOT NULL';
		$ccl_model = AppModel::getInstance("Clinicalcollection", "ClinicalCollectionLink", true);		
		$returned_nbr = $ccl_model->find('count', array('conditions' => array($criteria), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'the deleted collection is linked to participant'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Checks if a collection link (to a participant) can be deleted.
	 * @param int $collection_id
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 */
	function allowLinkDeletion($collection_id) {
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}

?>
