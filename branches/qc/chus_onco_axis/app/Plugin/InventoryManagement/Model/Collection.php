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
		), 'TreatmentMaster' => array(
			'className'	=> 'ClinicalAnnotation.TreatmentMaster',
			'foreignKey'	=> 'treatment_master_id'
		), 'EventMaster'	=> array(
			'className'	=> 'ClinicalAnnotation.EventMaster',
			'foreignKey'	=> 'event_master_id'
		)
	);
	
	var $browsing_search_dropdown_info = array(
		'browsing_filter'	=> array(
			1	=> array('lang' => 'keep entries with the most recent date per participant', 'group by' => 'participant_id', 'field' => 'collection_datetime', 'attribute' => 'MAX'),
			2	=> array('lang' => 'keep entries with the oldest date per participant', 'group by' => 'participant_id', 'field' => 'collection_datetime', 'attribute' => 'MIN')
		), 'collection_datetime' => array(
			1	=> array('model' => 'TreatmentMaster', 'field' => 'start_date', 'relation' => '>='),		
			2	=> array('model' => 'TreatmentMaster', 'field' => 'start_date', 'relation' => '<='),		
			3	=> array('model' => 'TreatmentMaster', 'field' => 'finish_date', 'relation' => '>='),		
			4	=> array('model' => 'TreatmentMaster', 'field' => 'finish_date', 'relation' => '<='),		
			5	=> array('model' => 'EventMaster', 'field' => 'event_date', 'relation' => '>='),		
			6	=> array('model' => 'EventMaster', 'field' => 'event_date', 'relation' => '<=')		
		)
	);
	
	var $registered_view = array(
		'InventoryManagement.ViewCollection' => array('Collection.id'),
		'InventoryManagement.ViewSample' => array('Collection.id'),
		'InventoryManagement.ViewAliquot' => array('Collection.id')
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
		$coll_data = $this->getOrRedirect($collection_id);
		if($coll_data['Collection']['participant_id']){ 
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
	
	function validates($options = array()) {
		//make sure all linked model are owned by the right participant
		$tmp_data = $this->data;
		$prev_data = null;
		if($this->id){
			$prev_data = $this->read();
			$this->data = $tmp_data;
		}
		foreach(array('ConsentMaster' => 'consent_master_id', 'DiagnosisMaster' => 'diagnosis_master_id', 'TreatmentMaster' => 'treatment_master_id', 'EventMaster' => 'event_master_id') as $model_name => $model_key){
			if(isset($this->data['Collection'][$model_key]) && $this->data['Collection'][$model_key] && (!isset($prev_data['Collection'][$model_key]) || $prev_data['Collection'][$model_key] != $this->data['Collection'][$model_key])){
				//defined and changed, check participant
				$model = AppModel::getInstance('ClinicalAnnotation', $model_name, true);
				$model_data = $model->getOrRedirect($this->data['Collection'][$model_key]);
				if(empty($model_data) || $model_data[$model_name]['participant_id'] != $this->data['Collection']['participant_id']){
					$this->validationErrors[][] = 'ERROR: data owned by another partcipant for model ['.$model_name.']';
				}
			}
		}
		
		return parent::validates($options);
	}
	
}

?>
