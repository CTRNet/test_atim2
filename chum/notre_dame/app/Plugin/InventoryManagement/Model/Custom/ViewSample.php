<?php
class ViewSampleCustom extends ViewSample{
	var $name = 'ViewSample';
	
	static $table_query = '
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_sample_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
		
		Collection.bank_id, 
		Collection.sop_master_id, 
		Collection.participant_id, 
		
		Participant.participant_identifier, 
		
		Collection.acquisition_label, 
		
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
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg,
		 
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
		
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
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE SampleMaster.deleted != 1 %%WHERE%%';
	
	function find($type = 'first', $query = array()) {
		if($type == 'all' && isset($query['conditions'])) {
			$identifier_values = array();
			foreach($query['conditions'] as $key => $new_condition) {
				if($key === 'ViewSample.identifier_value') {
					$identifier_values = $new_condition;
					break;
				} else if(is_string($new_condition)) {
					if(preg_match_all('/ViewSample\.identifier_value LIKE \'%([0-9]+)%\'/', $new_condition, $matches)) {
						$identifier_values = $matches[1];
						break;
					}
				}
			}
			if(!empty($identifier_values)) {
				$misc_identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
				$result = $misc_identifier_model->find('all', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => 6, 'MiscIdentifier.identifier_value' => $identifier_values), 'fields' => 'MiscIdentifier.identifier_value'));
				if($result){
					$all_values = array();
					foreach($result as $new_res) $all_values[] = $new_res['MiscIdentifier']['identifier_value'];
					AppController::addWarningMsg(__('no labos [%s] matche old bank numbers', implode(', ', $all_values)));
				}
			}
		}
		return parent::find($type, $query);
	}
}

