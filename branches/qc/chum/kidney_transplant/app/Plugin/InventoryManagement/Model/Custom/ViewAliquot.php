<?php

class ViewAliquotCustom extends ViewAliquot
{

    var $name = 'ViewAliquot';

    // TODO: Kidney transplant customisation
    // Added Collection.chum_kidney_transp_collection_time to view.
    static $tableQuery = 'SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,
		
			Participant.participant_identifier,
		
CONCAT(IFNULL(MiscIdentifier.identifier_value, "?"), " ", Collection.chum_kidney_transp_collection_part_type, " ", Collection.chum_kidney_transp_collection_time) acquisition_label,
		
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
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label,
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time
        
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
        if (isset($query['conditions'])) {
            $identifierValues = array();
            $queryConditions = is_array($query['conditions']) ? $query['conditions'] : array(
                $query['conditions']
            );
            foreach ($queryConditions as $key => $newCondition) {
                if ($key === 'ViewAliquot.identifier_value') {
                    $identifierValues = $newCondition;
                    break;
                } elseif (is_string($newCondition)) {
                    if (preg_match_all('/ViewAliquot\.identifier_value LIKE \'%([0-9]+)%\'/', $newCondition, $matches)) {
                        $identifierValues = $matches[1];
                        break;
                    }
                }
            }
            if (! empty($identifierValues)) {
                $miscIdentifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
                $result = $miscIdentifierModel->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.misc_identifier_control_id' => array(6,18,19),
                        'MiscIdentifier.identifier_value' => $identifierValues
                    ),
                    'fields' => 'MiscIdentifier.identifier_value'
                ));
                if ($result) {
                    $allValues = array();
                    foreach ($result as $newRes)
                        $allValues[] = $newRes['MiscIdentifier']['identifier_value'];
                    AppController::addWarningMsg(__('no labos [%s] matche old bank numbers', implode(', ', $allValues)));
                }
            }
            $gtKey = array_key_exists('ViewAliquot.identifier_value >=', $query['conditions']);
            $ltKey = array_key_exists('ViewAliquot.identifier_value <=', $query['conditions']);
            if ($gtKey || $ltKey) {
                $infValue = $gtKey ? str_replace(',', '.', $query['conditions']['ViewAliquot.identifier_value >=']) : '';
                $supValue = $ltKey ? str_replace(',', '.', $query['conditions']['ViewAliquot.identifier_value <=']) : '';
                if (strlen($infValue . $supValue) && (is_numeric($infValue) || ! strlen($infValue)) && (is_numeric($supValue) || ! strlen($supValue))) {
                    // Return just numeric
                    $query['conditions']['ViewAliquot.identifier_value REGEXP'] = "^[0-9]+([\,\.][0-9]+){0,1}$";
                    // Define range
                    if ($gtKey) {
                        $query['conditions']["(REPLACE(ViewAliquot.identifier_value, ',','.') * 1) >="] = $infValue;
                        unset($query['conditions']['ViewAliquot.identifier_value >=']);
                    }
                    if ($ltKey) {
                        $query['conditions']["(REPLACE(ViewAliquot.identifier_value, ',','.') * 1) <="] = $supValue;
                        unset($query['conditions']['ViewAliquot.identifier_value <=']);
                    }
                    // Manage Order
                    if (! isset($query['order'])) {
                        // supperfluou?s
                        $query['order'][] = "(REPLACE(ViewAliquot.identifier_value, ',','.') * 1)";
                    } elseif (is_array($query['order']) && isset($query['order']['ViewAliquot.identifier_value'])) {
                        $query['order']["(REPLACE(ViewAliquot.identifier_value, ',','.') * 1)"] = $query['order']['ViewAliquot.identifier_value'];
                        unset($query['order']['ViewAliquot.identifier_value']);
                    } elseif (is_string($query['order']) && preg_match('/^ViewAliquot.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                        $orderBy = $matches[1];
                        $query['order'] = "IF(concat('', REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '0', '1') $orderBy, ViewAliquot.identifier_value*IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '1', '') $orderBy, ViewAliquot.identifier_value $orderBy";
                    }
                }
            }
        }
        
        if (isset($query['order'])) {
            if (is_array($query['order']) && isset($query['order']['ViewAliquot.identifier_value']) && sizeof($query['order']) == 1) {
                // Display first numerical values then alphanumerical values
                $orderBy = $query['order']['ViewAliquot.identifier_value'];
                $query['order'][] = "IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '0', '1') $orderBy, ViewAliquot.identifier_value*IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '1', '') $orderBy, ViewAliquot.identifier_value $orderBy";
                unset($query['order']['ViewAliquot.identifier_value']);
            } elseif (is_string($query['order']) && preg_match('/^ViewAliquot.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                $orderBy = $matches[1];
                $query['order'] = "IF(concat('', REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '0', '1') $orderBy, ViewAliquot.identifier_value*IF(concat('',REPLACE(ViewAliquot.identifier_value, ',', '.') * 1) = REPLACE(ViewAliquot.identifier_value, ',', '.'), '1', '') $orderBy, ViewAliquot.identifier_value $orderBy";
            }
        }
        return parent::find($type, $query);
    }
}