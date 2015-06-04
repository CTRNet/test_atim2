<?php

class ViewAliquotCustom extends ViewAliquot {
	
	var $name = 'ViewAliquot';
	
	static $table_query =
		'SELECT
		AliquotMaster.id AS aliquot_master_id,
		AliquotMaster.sample_master_id AS sample_master_id,
		AliquotMaster.collection_id AS collection_id,
--		Collection.bank_id,
Participant.qc_tf_bank_participant_identifier AS qc_tf_bank_participant_identifier,
Participant.qc_tf_bank_id AS bank_id, 
Collection.qc_tf_collection_type AS qc_tf_collection_type, 
		AliquotMaster.storage_master_id AS storage_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
	
		Collection.acquisition_label,
	
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,

SampleMaster.qc_tf_is_tma_sample_control,
SampleMaster.qc_tf_tma_sample_control_code,
SampleMaster.qc_tf_tma_sample_control_bank_id,
				
		AliquotMaster.barcode,
		AliquotMaster.aliquot_label,
			
AliquotDetailCore.qc_tf_core_nature_site,
AliquotDetailCore.qc_tf_core_nature_revised,	
ParticipantBank.name AS participant_bank_name,
				
		AliquotControl.aliquot_type,
		AliquotMaster.aliquot_control_id,
		AliquotMaster.in_stock,
	
		StorageMaster.code,
		StorageMaster.selection_label,
		AliquotMaster.storage_coord_x,
		AliquotMaster.storage_coord_y,
	
		StorageMaster.temperature,
		StorageMaster.temp_unit,
	
		AliquotMaster.created,
	
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(SpecimenDetail.reception_datetime IS NULL, -1,
		 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(DerivativeDetail.creation_datetime IS NULL, -1,
		 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,

		IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
	
		FROM aliquot_masters AS AliquotMaster
		INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
LEFT JOIN ad_tissue_cores AS AliquotDetailCore ON AliquotDetailCore.aliquot_master_id = AliquotMaster.id	
		INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
		INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN banks AS ParticipantBank ON ParticipantBank.id = Participant.qc_tf_bank_id AND ParticipantBank.deleted != 1
		LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
		LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
		WHERE AliquotMaster.deleted != 1 %%WHERE%%';
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
				&& is_array($queryData['conditions'])
				&& AppModel::isFieldUsedAsCondition("ViewAliquot.qc_tf_bank_participant_identifier", $queryData['conditions'])) {
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("ViewAliquot.bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		//Manage confidential information and aliquot label
		if(isset($results[0]['ViewAliquot'])) {
			$user_bank_id = '-1';
			if($_SESSION['Auth']['User']['group_id'] == '1') {
				$user_bank_id = 'all';
			} else {
				$GroupModel = AppModel::getInstance("", "Group", true);
				$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
				if($group_data) $user_bank_id = $group_data['Group']['bank_id'];
			}
			$BankModel = AppModel::getInstance("Administrate", "Bank", true);
			$bank_list = $BankModel->getBankPermissibleValuesForControls();
			foreach($results as &$result){
				$aliquot_nature = substr(strtoupper(strlen($result['ViewAliquot']['qc_tf_core_nature_revised'])? $result['ViewAliquot']['qc_tf_core_nature_revised'] : (strlen($result['ViewAliquot']['qc_tf_core_nature_site'])? $result['ViewAliquot']['qc_tf_core_nature_site'] : 'U')), 0, 1);
				$result['ViewAliquot']['aliquot_label'] = $aliquot_nature;
				if($result['ViewAliquot']['qc_tf_is_tma_sample_control'] == 'n') {
					if($user_bank_id == 'all') {
						$result['ViewAliquot']['aliquot_label'] = $result['ViewAliquot']['qc_tf_bank_participant_identifier']." $aliquot_nature (".$result['ViewAliquot']['participant_bank_name'].')';
					} else if($result['ViewAliquot']['bank_id'] == $user_bank_id) {
						$result['ViewAliquot']['aliquot_label'] = $result['ViewAliquot']['qc_tf_bank_participant_identifier']." $aliquot_nature";
					} else {
						$result['ViewAliquot']['aliquot_label'] = $aliquot_nature;
						$result['ViewAliquot']['bank_id'] = CONFIDENTIAL_MARKER;
						$result['ViewAliquot']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
						$result['ViewAliquot']['participant_bank_name'] = CONFIDENTIAL_MARKER;
					}
				} else if($result['ViewAliquot']['qc_tf_is_tma_sample_control'] == 'y') {
					$core_provider_bank_name = '';
					if($result['ViewAliquot']['qc_tf_tma_sample_control_bank_id']) {
						$core_provider_bank_name = ' - '.$bank_list[$result['ViewAliquot']['qc_tf_tma_sample_control_bank_id']];
					}
					$result['ViewAliquot']['aliquot_label'] = $result['ViewAliquot']['qc_tf_tma_sample_control_code']." $aliquot_nature (".__('control').$core_provider_bank_name.')';
				}
			}
		} else if(isset($results['ViewAliquot'])){
			pr('TODO afterFind ViewAliquot');
			pr($results);
			exit;
		}
	
		return $results;
	}
	
}
