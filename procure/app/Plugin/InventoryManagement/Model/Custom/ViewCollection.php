<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
Collection.procure_visit AS procure_visit,
Collection.procure_collected_by_bank AS procure_collected_by_bank,
		Participant.participant_identifier AS participant_identifier,
Participant.procure_participant_attribution_number,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';	
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			$title = empty($collection_data['ViewCollection']['participant_identifier'])? '?' : $collection_data['ViewCollection']['participant_identifier'];
			$date = empty($collection_data['ViewCollection']['collection_datetime'])? '' : ' '.substr($collection_data['ViewCollection']['collection_datetime'],0,strpos($collection_data['ViewCollection']['collection_datetime'], ' '));
			$return = array(
				'menu' => array(null, $title . $date),
				'title' => array(null, __('collection') . ' : ' . $title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
			
			if(Configure::read('procure_atim_version') != 'PROCESSING') {
				//Check Consent
				$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
				if(!empty($consent_status)){
					if(!$collection_data['ViewCollection']['participant_id']){
						AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
					}else if($consent_status[$variables['Collection.id']] == null){
						AppController::addWarningMsg(__('no consent is linked to the current participant collection'));
					}
				}
				//Check Aliquot Barcode
				$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
				$aliquot_count = $aliquot_master_model->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_data['ViewCollection']['collection_id'], "AliquotMaster.barcode NOT LIKE '% ".$collection_data['ViewCollection']['procure_visit']." -%'"), 'recursive' => '-1'));
				if($aliquot_count) {
					AppController::addWarningMsg(__('at least one aliquot procure identification does not match the collection visit'));
				}
			}
			//Check Aliquot Barcode
			$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			$aliquot_count = $aliquot_master_model->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_data['ViewCollection']['collection_id'], "AliquotMaster.barcode NOT LIKE '% ".$collection_data['ViewCollection']['procure_visit']." -%'"), 'recursive' => '-1'));
			if($aliquot_count) {
				AppController::addWarningMsg(__('at least one aliquot procure identification does not match the collection visit'));
			}
		}
		
		return $return;
	}
	
	function getUnconsentedParticipantCollections(array $collection){
		$data = null;
		if(array_key_exists('id', $collection)){
			$data = $this->find('all', array('conditions' => array('ViewCollection.collection_id' => $collection['id']), 'recursive' => '-1'));
		}else{
			$data = array_key_exists('ViewCollection', $collection['data']) ? array($collection['data']) : $collection['data'];
		}
	
		$results = array();
		$participants_to_fetch = array();
		foreach($data as $index => &$data_unit){
			if(empty($data_unit['ViewCollection']['participant_id'])){
				//removing missing consents (participant)
				$results[$data_unit['ViewCollection']['collection_id']] = null;
			}else{
				$participants_to_fetch[$data_unit['ViewCollection']['participant_id']] = $data_unit['ViewCollection']['collection_id'];
			}
		}
		if(!empty($participants_to_fetch)){
			//find all collections participants unlinked to a consent
			$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
			$consent_data = $consent_model->find('all', array(
					'fields' => array('ConsentMaster.id', 'ConsentMaster.id, ConsentMaster.participant_id'),
					'conditions' => array('ConsentMaster.participant_id' => array_keys($participants_to_fetch)),
					'recursive' => -1)
			);		
			foreach($consent_data as $consent_data_unit) unset($participants_to_fetch[$consent_data_unit['ConsentMaster']['participant_id']]);
			foreach($participants_to_fetch as $participant_id => $collection_id) $results[$collection_id] = null;
		}
		return $results;
	}
}

