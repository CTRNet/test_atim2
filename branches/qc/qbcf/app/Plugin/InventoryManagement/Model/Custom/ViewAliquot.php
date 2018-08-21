<?php

class ViewAliquotCustom extends ViewAliquot
{

    var $name = 'ViewAliquot';

    public static $tableQuery = 'SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
--			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,
		
			Participant.participant_identifier, 
Participant.qbcf_bank_participant_identifier AS qbcf_bank_participant_identifier,
Participant.qbcf_bank_id AS bank_id, 
ParticipantBank.name AS participant_bank_name,
		
			Collection.acquisition_label,
            Collection.collection_protocol_id AS collection_protocol_id,
Collection.qbcf_pathology_id,
		
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,

SampleMaster.qbcf_is_tma_sample_control,
SampleMaster.qbcf_tma_sample_control_code,
SampleDetail.tissue_source,
        		
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
    
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
		
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
LEFT JOIN sd_spe_tissues AS SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN banks AS ParticipantBank ON ParticipantBank.id = Participant.qbcf_bank_id AND ParticipantBank.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
			WHERE AliquotMaster.deleted != 1 %%WHERE%%';

    public function beforeFind($queryData)
    {
        if (($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions'])) {
            if (AppModel::isFieldUsedAsCondition("ViewAliquot.qbcf_bank_participant_identifier", $queryData['conditions']) || AppModel::isFieldUsedAsCondition("ViewAliquot.aliquot_label", $queryData['conditions']) || AppModel::isFieldUsedAsCondition("ViewAliquot.qbcf_pathology_id", $queryData['conditions']) || AppModel::isFieldUsedAsCondition("ViewAliquot.bank_id", $queryData['conditions'])) {
                AppController::addWarningMsg(__('your search will be limited to your bank'));
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                $userBankId = $groupData['Group']['bank_id'];
                $queryData['conditions'][] = array(
                    "ViewAliquot.bank_id" => $userBankId
                );
            }
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        
        // Manage confidential information and build an aliquot information label gathering many data like bank, etc
        if (isset($results[0]['ViewAliquot'])) {
            // Get user and bank information
            $userBankId = '-1';
            if ($_SESSION['Auth']['User']['group_id'] == '1') {
                $userBankId = 'all';
            } else {
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                if ($groupData)
                    $userBankId = $groupData['Group']['bank_id'];
            }
            $BankModel = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $BankModel->getBankPermissibleValuesForControls();
            $StructurePermissibleValuesCustomModel = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $tissueSources = $StructurePermissibleValuesCustomModel->getCustomDropdown(array(
                'Tissue Sources'
            ));
            $tissueSources = array_merge($tissueSources['defined'], $tissueSources['previously_defined']);
            // Process data
            foreach ($results as &$result) {
                // Manage confidential information
                $setToConfidential = ($userBankId != 'all' && (! isset($result['ViewAliquot']['bank_id']) || $result['ViewAliquot']['bank_id'] != $userBankId)) ? true : false;
                if ($setToConfidential) {
                    if (isset($result['ViewAliquot']['bank_id']))
                        $result['ViewAliquot']['bank_id'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['qbcf_bank_participant_identifier']))
                        $result['ViewAliquot']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['participant_bank_name']))
                        $result['ViewAliquot']['participant_bank_name'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['qbcf_pathology_id']))
                        $result['ViewAliquot']['qbcf_pathology_id'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['aliquot_label']))
                        $result['ViewAliquot']['aliquot_label'] = CONFIDENTIAL_MARKER;
                }
                // Create the aliquot information label to display
                if (array_key_exists('aliquot_label', $result['ViewAliquot'])) {
                    if ($result['ViewAliquot']['qbcf_is_tma_sample_control'] == 'y') {
                        // Tissue Control
                        $result['ViewAliquot']['qbcf_generated_label_for_display'] = $result['ViewAliquot']['qbcf_tma_sample_control_code'] . " - QBCF# " . $result['ViewAliquot']['barcode'] . " (" . __('control') . ' - ' . $tissueSources[$result['ViewAliquot']['tissue_source']] . ')';
                    } else {
                        // Particiapnt Tissue
                        $aliquotParticipantIdAndBarcode = 'P#' . (empty($result['ViewAliquot']['participant_identifier']) ? '?' : $result['ViewAliquot']['participant_identifier']) . ' - QBCF# ' . $result['ViewAliquot']['barcode'];
                        if ($userBankId == 'all') {
                            $result['ViewAliquot']['qbcf_generated_label_for_display'] = (strlen($result['ViewAliquot']['participant_bank_name']) ? $result['ViewAliquot']['participant_bank_name'] : '?') . ' - ' . (strlen($result['ViewAliquot']['qbcf_bank_participant_identifier']) ? $result['ViewAliquot']['qbcf_bank_participant_identifier'] : '?') . ' - ' . (strlen($result['ViewAliquot']['aliquot_label']) ? $result['ViewAliquot']['aliquot_label'] : '?') . " ($aliquotParticipantIdAndBarcode)";
                        } elseif ($result['ViewAliquot']['bank_id'] == $userBankId) {
                            $result['ViewAliquot']['qbcf_generated_label_for_display'] = (strlen($result['ViewAliquot']['qbcf_bank_participant_identifier']) ? $result['ViewAliquot']['qbcf_bank_participant_identifier'] : '?') . ' - ' . (strlen($result['ViewAliquot']['aliquot_label']) ? $result['ViewAliquot']['aliquot_label'] : '?') . " ($aliquotParticipantIdAndBarcode)";
                        } else {
                            $result['ViewAliquot']['qbcf_generated_label_for_display'] = $aliquotParticipantIdAndBarcode;
                        }
                    }
                }
            }
        } elseif (isset($results['ViewAliquot'])) {
            pr('TODO #2 afterFind ViewAliquot');
            pr($results);
            exit();
        }
        
        return $results;
    }
}