<?php

class ViewSampleCustom extends ViewSample {
	
	var $name = 'ViewSample';
	
	static $table_query = '
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_sample_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
		
--		Collection.bank_id, 
Participant.qc_tf_bank_participant_identifier AS qc_tf_bank_participant_identifier,
Participant.qc_tf_bank_id AS bank_id, 
		Collection.sop_master_id, 
		Collection.participant_id, 
		
		Participant.participant_identifier, 
		
		Collection.acquisition_label, 
Collection.qc_tf_collection_type AS qc_tf_collection_type, 
		
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
		
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		 
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg 
		
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
		WHERE SampleMaster.deleted != 1 %%WHERE%%';
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
				&& is_array($queryData['conditions'])
				&& AppModel::isFieldUsedAsCondition("ViewSample.qc_tf_bank_participant_identifier", $queryData['conditions'])) {
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("ViewSample.bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			if(isset($results[0]['ViewSample']['bank_id']) || isset($results[0]['ViewSample']['qc_tf_bank_participant_identifier'])) {
				foreach($results as &$result){
					if((!isset($result['ViewSample']['bank_id'])) || $result['ViewSample']['bank_id'] != $user_bank_id) {		
						$result['ViewSample']['bank_id'] = CONFIDENTIAL_MARKER;
						$result['ViewSample']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['ViewSample'])){
				pr('TODO afterFind ViewSample');
				pr($results);
				exit;
			}
		}
	
		return $results;
	}
}
