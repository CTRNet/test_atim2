<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
--		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
Participant.qbcf_bank_participant_identifier AS qbcf_bank_participant_identifier,
Participant.qbcf_bank_id AS bank_id,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
--		Collection.collection_datetime AS collection_datetime,
--		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
TreatmentMaster.start_date AS collection_datetime,			
TreatmentMaster.start_date_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Collection.qbcf_pathology_id
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));

			$title = '';
			if($collection_data['ViewCollection']['collection_property'] == 'independent collection') {
				$title = __('independent collection');
			} else if(empty($collection_data['ViewCollection']['participant_identifier'])) {
				$title = __('unlinked collection');
			} else if($collection_data['ViewCollection']['qbcf_bank_participant_identifier'] == CONFIDENTIAL_MARKER) {
				$title = __('participant identifier').' '.$collection_data['ViewCollection']['participant_identifier'];
			} else {
				$title = __('bank patient #').' '.$collection_data['ViewCollection']['qbcf_bank_participant_identifier'];
			}
			
			$return = array(
				'menu' => array(null, $title),
				'title' => array(null, __('collection') . ' : ' . $title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
		&& is_array($queryData['conditions'])) {
			if(AppModel::isFieldUsedAsCondition("ViewCollection.qbcf_bank_participant_identifier", $queryData['conditions'])
			|| AppModel::isFieldUsedAsCondition("ViewCollection.qbcf_pathology_id", $queryData['conditions'])
			|| AppModel::isFieldUsedAsCondition("ViewCollection.bank_id", $queryData['conditions'])) {
				AppController::addWarningMsg(__('your search will be limited to your bank'));
				$GroupModel = AppModel::getInstance("", "Group", true);
				$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
				$user_bank_id = $group_data['Group']['bank_id'];
				$queryData['conditions'][] = array("ViewCollection.bank_id" => $user_bank_id);
			}
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			if(isset($results[0]['ViewCollection']['bank_id']) 
			|| isset($results[0]['ViewCollection']['qbcf_bank_participant_identifier'])
			|| isset($results[0]['ViewCollection']['qbcf_pathology_id'])) {
				foreach($results as &$result){
					if((!isset($result['ViewCollection']['bank_id'])) || $result['ViewCollection']['bank_id'] != $user_bank_id) {
						if(isset($result['ViewCollection']['bank_id'])) $result['ViewCollection']['bank_id'] = CONFIDENTIAL_MARKER;
						if(isset($result['ViewCollection']['qbcf_bank_participant_identifier'])) $result['ViewCollection']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
						if(isset($result['ViewCollection']['qbcf_pathology_id'])) $result['ViewCollection']['qbcf_pathology_id'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['ViewCollection'])){
				pr('TODO afterFind ViewCollection');
				pr($results);
				exit;
			}
		}
		
		return $results;
	}	
		
}

