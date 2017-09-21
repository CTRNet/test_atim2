<?php

class ViewAliquotCustom extends ViewAliquot
{

    var $name = 'ViewAliquot';

    static $table_query = 'SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
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
		
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotMaster.in_stock_detail,
			StudySummary.title AS study_summary_title,
			StudySummary.id AS study_summary_id,
		
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
	
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes,
		
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
		
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
			WHERE AliquotMaster.deleted != 1 %%WHERE%%';

    public function find($type = 'first', $query = array())
    {
        if ($type == 'all' && isset($query['conditions'])) {
            $identifier_values = array();
            $query_conditions = is_array($query['conditions']) ? $query['conditions'] : array(
                $query['conditions']
            );
            foreach ($query_conditions as $key => $new_condition) {
                if ($key === 'ViewAliquot.identifier_value') {
                    $identifier_values = $new_condition;
                    break;
                } elseif (is_string($new_condition)) {
                    if (preg_match_all('/ViewAliquot\.identifier_value LIKE \'%([0-9]+)%\'/', $new_condition, $matches)) {
                        $identifier_values = $matches[1];
                        break;
                    }
                }
            }
            if (! empty($identifier_values)) {
                $misc_identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
                $result = $misc_identifier_model->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.misc_identifier_control_id' => 6,
                        'MiscIdentifier.identifier_value' => $identifier_values
                    ),
                    'fields' => 'MiscIdentifier.identifier_value'
                ));
                if ($result) {
                    $all_values = array();
                    foreach ($result as $new_res)
                        $all_values[] = $new_res['MiscIdentifier']['identifier_value'];
                    AppController::addWarningMsg(__('no labos [%s] matche old bank numbers', implode(', ', $all_values)));
                }
            }
        }
        if (isset($query['conditions']) && empty($query['fields'])) {
            $gt_key = array_key_exists('ViewAliquot.identifier_value >=', $query['conditions']);
            $lt_key = array_key_exists('ViewAliquot.identifier_value <=', $query['conditions']);
            if ($gt_key || $lt_key) {
                $inf_value = $gt_key ? str_replace(',', '.', $query['conditions']['ViewAliquot.identifier_value >=']) : '';
                $sup_value = $lt_key ? str_replace(',', '.', $query['conditions']['ViewAliquot.identifier_value <=']) : '';
                if (strlen($inf_value . $sup_value) && (is_numeric($inf_value) || ! strlen($inf_value)) && (is_numeric($sup_value) || ! strlen($sup_value))) {
                    // Return just numeric
                    $query['conditions']['ViewAliquot.identifier_value REGEXP'] = "^[0-9]+([\,\.][0-9]+){0,1}$";
                    // Define range
                    if ($gt_key) {
                        $query['conditions']["(REPLACE(ViewAliquot.identifier_value, ',','.') * 1) >="] = $inf_value;
                        unset($query['conditions']['ViewAliquot.identifier_value >=']);
                    }
                    if ($lt_key) {
                        $query['conditions']["(REPLACE(ViewAliquot.identifier_value, ',','.') * 1) <="] = $sup_value;
                        unset($query['conditions']['ViewAliquot.identifier_value <=']);
                    }
                    // Manage Order
                    if (! isset($query['order'])) {
                        // supperfluou?s
                        $query['order']['ViewAliquot.identifier_value'] = 'ASC';
                    }
                }
            }
        }
        if (isset($query['order']) && is_array($query['order']) && array_key_exists('ViewAliquot.identifier_value', $query['order'])) {
            $order_by = $query['order']['ViewAliquot.identifier_value'];
            $query['order']["IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '0', '1') $order_by, ViewAliquot.identifier_value*IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '1', '') $order_by, ViewAliquot.identifier_value $order_by"] = '';
            unset($query['order']['ViewAliquot.identifier_value']);
        }
        return parent::find($type, $query);
    }
}