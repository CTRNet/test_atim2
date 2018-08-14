<?php

class ViewAliquotCustom extends ViewAliquot
{

    var $name = 'ViewAliquot';

    
    public static $tableQuery = 'SELECT 
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id, 
--		Collection.bank_id,
Participant.qc_tf_bank_participant_identifier AS qc_tf_bank_participant_identifier,
Participant.qc_tf_bank_id AS bank_id, 
ParticipantBank.name AS participant_bank_name,
Collection.qc_tf_collection_type AS qc_tf_collection_type, 
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id, 
			
			Participant.participant_identifier, 
			
			Collection.acquisition_label, 
            Collection.collection_protocol_id AS collection_protocol_id,
			
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
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
			WHERE AliquotMaster.deleted != 1 %%WHERE%%';
    
    public function beforeFind($queryData)
    {
        if (isset($_SESSION['Auth']) && ($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions'])) {
            if (AppModel::isFieldUsedAsCondition("ViewAliquot.qc_tf_bank_participant_identifier", $queryData['conditions'])) {
                AppController::addWarningMsg(__('your search will be limited to your bank'));
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                $userBankId = $groupData['Group']['bank_id'];
                $queryData['conditions'][] = array(
                    "ViewAliquot.bank_id" => $userBankId
                );
            } elseif (AppModel::isFieldUsedAsCondition("ViewAliquot.aliquot_label", $queryData['conditions'])) {
                // Don't allow search on tissue block of the other bank
                AppController::addWarningMsg(__('the list of tissue block will be limited to your bank blocks'));
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                $userBankId = $groupData['Group']['bank_id'];
                $AliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
                $tissueBlockControl = $AliquotControlModel->find('first', array(
                    'conditions' => array(
                        'AliquotControl.databrowser_label' => 'tissue|block'
                    )
                ));
                $tissueBlockControlId = $tissueBlockControl['AliquotControl']['id'];
                $queryData['conditions'][] = "((ViewAliquot.bank_id = $userBankId && ViewAliquot.aliquot_control_id = $tissueBlockControlId) || ViewAliquot.aliquot_control_id != $tissueBlockControlId)";
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
            if (isset($_SESSION['Auth']) && $_SESSION['Auth']['User']['group_id'] == '1') {
                $userBankId = 'all';
            } else {
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                if ($groupData)
                    $userBankId = $groupData['Group']['bank_id'];
            }
            $BankModel = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $BankModel->getBankPermissibleValuesForControls();
            // Process data
            foreach ($results as &$result) {
                // Manage confidential information
                $setToConfidential = ($userBankId != 'all' && (! isset($result['ViewAliquot']['bank_id']) || $result['ViewAliquot']['bank_id'] != $userBankId)) ? true : false;
                if ($setToConfidential) {
                    if (isset($result['ViewAliquot']['bank_id']))
                        $result['ViewAliquot']['bank_id'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['qc_tf_bank_participant_identifier']))
                        $result['ViewAliquot']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['participant_bank_name']))
                        $result['ViewAliquot']['participant_bank_name'] = CONFIDENTIAL_MARKER;
                    if (isset($result['ViewAliquot']['aliquot_label']) && $result['ViewAliquot']['sample_type'] . $result['ViewAliquot']['aliquot_type'] == 'tissueblock') {
                        $result['ViewAliquot']['aliquot_label'] = CONFIDENTIAL_MARKER; // Block Pathology Code
                    }
                }
                // Create the aliquot information label to display
                if (array_key_exists('aliquot_label', $result['ViewAliquot'])) {
                    if ($result['ViewAliquot']['qc_tf_is_tma_sample_control'] == 'y') {
                        // Tissue Control
                        $result['ViewAliquot']['qc_tf_generated_label_for_display'] = $result['ViewAliquot']['qc_tf_tma_sample_control_code'] . " " . $result['ViewAliquot']['aliquot_label'] . " (" . __('control') . (empty($result['ViewAliquot']['qc_tf_tma_sample_control_bank_id']) ? '' : ' - ' . $bankList[$result['ViewAliquot']['qc_tf_tma_sample_control_bank_id']]) . ')';
                    } else {
                        // Particiapnt Tissue
                        $result['ViewAliquot']['qc_tf_generated_label_for_display'] = $result['ViewAliquot']['aliquot_label'] . (empty($result['ViewAliquot']['participant_identifier']) ? '' : ' - P# ' . $result['ViewAliquot']['participant_identifier']);
                        if ($userBankId == 'all') {
                            $result['ViewAliquot']['qc_tf_generated_label_for_display'] .= " (" . $result['ViewAliquot']['qc_tf_bank_participant_identifier'] . ' [' . $result['ViewAliquot']['participant_bank_name'] . '])';
                        } elseif ($result['ViewAliquot']['bank_id'] == $userBankId) {
                            $result['ViewAliquot']['qc_tf_generated_label_for_display'] .= " (" . $result['ViewAliquot']['qc_tf_bank_participant_identifier'] . ')';
                        }
                    }
                }
                $result['ViewAliquot']['qc_tf_generated_selection_label_precision_for_display'] = (isset($result['StorageMaster']) && isset($result['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'])) ? $result['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'] : '';
            }
        } elseif (isset($results['ViewAliquot'])) {
            pr('TODO #2 afterFind ViewAliquot');
            pr($results);
            exit();
        }
        
        return $results;
    }
}