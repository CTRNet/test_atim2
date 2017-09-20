<?php

class ReportsControllerCustom extends ReportsController
{

    public function buildCoeurSummary($parameters)
    {
        $conditions = array();
        $warnings = array();
        
        $userBankId = null;
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = (empty($groupData) ? '' : $groupData['Group']['bank_id']);
        }
        
        if (! isset($parameters['exact_search']) || $parameters['exact_search'] != 'on') {
            $warnings[] = __('only exact search is supported');
        }
        
        // *********** Get Conditions from parameters ***********
        
        $csvOrderForDisplay = array();
        $searchOnPathoNumber = false;
        
        if (isset($parameters['Browser'])) {
            
            // 0-REPORT LAUNCHED FROM DATA BROWSER
            
            if (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode(',', $parameters['Participant']['id']) . ')';
                }
            } else {
                die('ERR 9900303');
            }
        } else {
            if (isset($parameters['Participant'])) {
                
                // 1-BANK
                $bankIds = array_filter($parameters['Participant']['qc_tf_bank_id']);
                if (! empty($bankIds))
                    $conditions[] = 'Participant.qc_tf_bank_id IN (' . implode(',', $bankIds) . ')';
                    
                    // 2-PARTICIPANT IDENTIFIER
                if (isset($parameters['Participant']['participant_identifier'])) {
                    $participantIds = array_filter($parameters['Participant']['participant_identifier']);
                    if (! empty($participantIds)) {
                        $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIds) . "')";
                        $csvOrderForDisplay[] = array(
                            'field' => 'Participant.participant_identifier',
                            'order' => $parameters['Participant']['participant_identifier']
                        );
                    }
                } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
                    if (strlen($parameters['Participant']['participant_identifier_start'])) {
                        $conditions[] = 'Participant.participant_identifier >= ' . $parameters['Participant']['participant_identifier_start'];
                    }
                    if (strlen($parameters['Participant']['participant_identifier_end'])) {
                        $conditions[] = 'Participant.participant_identifier <= ' . $parameters['Participant']['participant_identifier_end'];
                    }
                }
                
                // 3-PARTICIPANT BANK IDENTIFIER
                
                if (isset($parameters['Participant']['qc_tf_bank_identifier'])) {
                    $participantIds = array_filter($parameters['Participant']['qc_tf_bank_identifier']);
                    if (! empty($participantIds)) {
                        $conditions[] = "Participant.qc_tf_bank_identifier IN ('" . implode("','", $participantIds) . "')";
                        if ($_SESSION['Auth']['User']['group_id'] != '1') {
                            AppController::addWarningMsg(__('your search will be limited to your bank'));
                            $conditions[] = "Participant.qc_tf_bank_id = '$userBankId'";
                        }
                        $csvOrderForDisplay[] = array(
                            'field' => 'Participant.qc_tf_bank_identifier',
                            'order' => $parameters['Participant']['qc_tf_bank_identifier']
                        );
                    }
                }
            } else 
                if (isset($parameters['AliquotDetail'])) {
                    
                    // 4-PATHOLOGY NUMBER
                    if (isset($parameters['AliquotDetail']['patho_dpt_block_code'])) {
                        $pathoDptBlockCodes = array_filter($parameters['AliquotDetail']['patho_dpt_block_code']);
                        if (! empty($pathoDptBlockCodes)) {
                            $conditions[] = "AliquotDetail.patho_dpt_block_code IN ('" . implode("','", $pathoDptBlockCodes) . "')";
                            if ($_SESSION['Auth']['User']['group_id'] != '1') {
                                AppController::addWarningMsg(__('your search will be limited to your bank'));
                                $conditions[] = "Participant.qc_tf_bank_id = '$userBankId'";
                            }
                            $csvOrderForDisplay[] = array(
                                'field' => 'AliquotDetail.patho_dpt_block_code',
                                'order' => $parameters['AliquotDetail']['patho_dpt_block_code']
                            );
                        }
                    }
                    $searchOnPathoNumber = true;
                }
            
            // 5-CHECK ORDER OF THE RESULT TO CONTROL
            
            if (isset($parameters['FunctionManagement']['qc_tf_keep_csv_file_order']) && $parameters['FunctionManagement']['qc_tf_keep_csv_file_order'][0]) {
                switch (sizeof($csvOrderForDisplay)) {
                    case '0':
                        $csvOrderForDisplay = null;
                        AppController::addWarningMsg(__('the csv order cannot be preserved with these search criteria'));
                        break;
                    case '1':
                        $csvOrderForDisplay = $csvOrderForDisplay[0];
                        break;
                    case '2':
                        $csvOrderForDisplay = null;
                        AppController::addWarningMsg(__('system is not able to to preserve the order when both participant identifiers and bank identifiers are used for research'));
                        break;
                    default:
                        $csvOrderForDisplay = null;
                }
            } else {
                $csvOrderForDisplay = null;
            }
        }
        if (empty($conditions)) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'please complete at least one search criteria'
            );
        }
        $conditionsStr = implode(' AND ', $conditions);
        
        // *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********
        
        $sql = "SELECT DISTINCT " . ($searchOnPathoNumber ? 'AliquotDetail.patho_dpt_block_code,' : '') . "Participant.id AS participant_id,
				Participant.qc_tf_bank_id,
				Participant.participant_identifier,
				Participant.qc_tf_bank_identifier,
				Participant.vital_status,
				Participant.qc_tf_brca_status,
				Participant.qc_tf_post_chemo,
				Participant.qc_tf_family_history,
				Participant.notes,
				DiagnosisMaster.id AS primary_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisMaster.age_at_dx,
				DiagnosisMaster.tumour_grade,
				DiagnosisDetail.figo,
				DiagnosisDetail.residual_disease,
				DiagnosisDetail.survival_from_ovarectomy_in_months,
				DiagnosisDetail.progression_time_in_months,
				DiagnosisDetail.follow_up_from_ovarectomy_in_months,
				DiagnosisDetail.ca125_progression_time_in_months,
				DiagnosisDetail.progression_status,
				DiagnosisDetail.histopathology,
				DiagnosisDetail.reviewed_histopathology
			FROM participants AS Participant " . ($searchOnPathoNumber ? 'INNER JOIN collections Collection ON Collection.participant_id = Participant.id INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id ' : '') . "LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_eocs AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			WHERE Participant.deleted <> 1 AND ($conditionsStr)
			ORDER BY Participant.participant_identifier ASC;";
        $mainResults = $this->Report->tryCatchQuery($sql);
        
        $eocPrimaryIds = array();
        $participantIds = array();
        foreach ($mainResults as $newParticipant) {
            $participantIds[] = $newParticipant['Participant']['participant_id'];
            if (! empty($newParticipant['DiagnosisMaster']['primary_id']))
                $eocPrimaryIds[] = $newParticipant['DiagnosisMaster']['primary_id'];
        }
        
        // *********** Get first EOC ***********
        
        $firstEocChemosFromParticipantId = array();
        if ($eocPrimaryIds) {
            $sql = "SELECT 
					TreatmentMaster.id,
					TreatmentMaster.start_date AS start_date,
					TreatmentMaster.start_date_accuracy AS start_date_accuracy,
					TreatmentMaster.finish_date AS finish_date,
					TreatmentMaster.finish_date_accuracy AS finish_date_accuracy,
					TreatmentMaster.participant_id,
					Drug.generic_name
				FROM treatment_masters AS TreatmentMaster
				LEFT JOIN txe_chemos AS TreatmentExtend ON TreatmentExtend.treatment_master_id = TreatmentMaster.id
				LEFT JOIN drugs AS Drug ON Drug.id = TreatmentExtend.drug_id
				WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.diagnosis_master_id IN (" . implode(',', $eocPrimaryIds) . ") AND TreatmentMaster.treatment_control_id = 14
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.finish_date ASC, TreatmentMaster.id ASC;";
            $eocChemoResults = $this->Report->tryCatchQuery($sql);
            foreach ($eocChemoResults as $newRes) {
                $studiedParticipantId = $newRes['TreatmentMaster']['participant_id'];
                if (! isset($firstEocChemosFromParticipantId[$studiedParticipantId])) {
                    $firstEocChemosFromParticipantId[$studiedParticipantId] = $newRes;
                    $firstEocChemosFromParticipantId[$studiedParticipantId]['0']['qc_tf_coeur_chemo_drugs'] = isset($newRes['Drug']['generic_name']) ? array(
                        $newRes['Drug']['generic_name']
                    ) : array();
                } else 
                    if ($firstEocChemosFromParticipantId[$studiedParticipantId]['TreatmentMaster']['id'] == $newRes['TreatmentMaster']['id']) {
                        if (isset($newRes['Drug']['generic_name']))
                            $firstEocChemosFromParticipantId[$studiedParticipantId]['0']['qc_tf_coeur_chemo_drugs'][] = $newRes['Drug']['generic_name'];
                    }
            }
        }
        
        // *********** Get first Progression ***********
        
        $firstProgressionFromParticipantId = array();
        if ($eocPrimaryIds) {
            $sql = "SELECT DISTINCT
					DiagnosisMaster.id,
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					DiagnosisMaster.dx_date,
					DiagnosisMaster.dx_date_accuracy
				FROM diagnosis_masters AS DiagnosisMaster
				WHERE DiagnosisMaster.diagnosis_control_id = 16 AND DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.primary_id <> 1 AND DiagnosisMaster.primary_id IN (" . implode(',', $eocPrimaryIds) . ")
				ORDER BY DiagnosisMaster.primary_id ASC, DiagnosisMaster.dx_date ASC";
            $eocProgressionResults = $this->Report->tryCatchQuery($sql);
            foreach ($eocProgressionResults as $newRes) {
                $studiedParticipantId = $newRes['DiagnosisMaster']['participant_id'];
                if (! isset($firstProgressionFromParticipantId[$studiedParticipantId])) {
                    $firstProgressionFromParticipantId[$studiedParticipantId] = $newRes;
                }
            }
        }
        
        // *********** Get other DX ***********
        
        $otherDxFromParticipantId = array();
        if ($participantIds) {
            $sql = "SELECT DISTINCT
					DiagnosisMaster.participant_id,
					DiagnosisMaster.dx_date,
					DiagnosisMaster.dx_date_accuracy,
					DiagnosisMaster.qc_tf_tumor_site
				FROM diagnosis_masters AS DiagnosisMaster
				WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id = 15 AND DiagnosisMaster.participant_id IN (" . implode(',', $participantIds) . ")
				ORDER BY DiagnosisMaster.participant_id, DiagnosisMaster.dx_date ASC;";
            $otherDxResults = $this->Report->tryCatchQuery($sql);
            foreach ($otherDxResults as $newRes) {
                $studiedParticipantId = $newRes['DiagnosisMaster']['participant_id'];
                if (! isset($otherDxFromParticipantId[$studiedParticipantId]))
                    $otherDxFromParticipantId[$studiedParticipantId] = array();
                if (sizeof($otherDxFromParticipantId[$studiedParticipantId]) < 4) {
                    $otherDxFromParticipantId[$studiedParticipantId][] = $newRes;
                }
            }
        }
        
        // *********** Merge all data ***********
        
        $progressionWarnings = array();
        foreach ($mainResults as &$newParticipant) {
            $studiedParticipantId = $newParticipant['Participant']['participant_id'];
            $newParticipant['0'] = array(
                'qc_tf_coeur_end_of_first_chemo' => '',
                'qc_tf_coeur_end_of_first_chemo_accuracy' => '',
                'qc_tf_coeur_chemo_drugs' => '',
                'qc_tf_coeur_first_progression_date' => '',
                'qc_tf_coeur_first_first_chemo_to_first_progression_months' => '',
                'qc_tf_coeur_other_dx_tumor_site_1' => '',
                'qc_tf_coeur_other_dx_tumor_date_1' => '',
                'qc_tf_coeur_other_dx_tumor_site_2' => '',
                'qc_tf_coeur_other_dx_tumor_date_2' => '',
                'qc_tf_coeur_other_dx_tumor_site_3' => '',
                'qc_tf_coeur_other_dx_tumor_date_3' => ''
            );
            if (isset($firstEocChemosFromParticipantId[$studiedParticipantId])) {
                $newParticipant['0']['qc_tf_coeur_end_of_first_chemo'] = $this->tmpFormatdate($firstEocChemosFromParticipantId[$studiedParticipantId]['TreatmentMaster']['finish_date'], $firstEocChemosFromParticipantId[$studiedParticipantId]['TreatmentMaster']['finish_date_accuracy']);
                $newParticipant['0']['qc_tf_coeur_end_of_first_chemo_accuracy'] = $firstEocChemosFromParticipantId[$studiedParticipantId]['TreatmentMaster']['finish_date_accuracy'];
                $newParticipant['0']['qc_tf_coeur_chemo_drugs'] = implode(', ', array_filter($firstEocChemosFromParticipantId[$studiedParticipantId]['0']['qc_tf_coeur_chemo_drugs']));
            }
            if (isset($firstProgressionFromParticipantId[$studiedParticipantId])) {
                $newParticipant['0']['qc_tf_coeur_first_progression_date'] = $this->tmpFormatdate($firstProgressionFromParticipantId[$studiedParticipantId]['DiagnosisMaster']['dx_date'], $firstProgressionFromParticipantId[$studiedParticipantId]['DiagnosisMaster']['dx_date_accuracy']);
                if (! empty($newParticipant['0']['qc_tf_coeur_end_of_first_chemo']) && ! empty($firstProgressionFromParticipantId[$studiedParticipantId]['DiagnosisMaster']['dx_date'])) {
                    if (in_array($newParticipant['0']['qc_tf_coeur_end_of_first_chemo_accuracy'] . $firstProgressionFromParticipantId[$studiedParticipantId]['DiagnosisMaster']['dx_date_accuracy'], array(
                        'cc'/*, 'cd', 'dc'*/))) {
                        $firstChemoDate = new DateTime($newParticipant['0']['qc_tf_coeur_end_of_first_chemo']);
                        $firstProgressionDate = new DateTime($firstProgressionFromParticipantId[$studiedParticipantId]['DiagnosisMaster']['dx_date']);
                        $interval = $firstChemoDate->diff($firstProgressionDate);
                        if ($interval->invert) {
                            $progressionWarnings['unable to calculate first chemo to first progression because dates are not chronological'][] = $newParticipant['Participant']['participant_identifier'];
                        } else {
                            $newParticipant['0']['qc_tf_coeur_first_first_chemo_to_first_progression_months'] = $interval->y * 12 + $interval->m;
                        }
                    } else {
                        $progressionWarnings['unable to calculate first chemo to first progression with at least one unaccuracy date'][] = $newParticipant['Participant']['participant_identifier'];
                    }
                }
            }
            if (isset($otherDxFromParticipantId[$studiedParticipantId])) {
                $id = 0;
                foreach ($otherDxFromParticipantId[$studiedParticipantId] as $newOtherDx) {
                    $id ++;
                    $newParticipant['0']['qc_tf_coeur_other_dx_tumor_site_' . $id] = $newOtherDx['DiagnosisMaster']['qc_tf_tumor_site'];
                    $newParticipant['0']['qc_tf_coeur_other_dx_tumor_date_' . $id] = $this->tmpFormatdate($newOtherDx['DiagnosisMaster']['dx_date'], $newOtherDx['DiagnosisMaster']['dx_date_accuracy']);
                }
            }
            if (($_SESSION['Auth']['User']['group_id'] != '1') && ($newParticipant['Participant']['qc_tf_bank_id'] != $userBankId)) {
                $newParticipant['Participant']['qc_tf_bank_identifier'] = CONFIDENTIAL_MARKER;
                $newParticipant['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
                if ($searchOnPathoNumber)
                    $newParticipant['AliquotDetail']['patho_dpt_block_code'] = CONFIDENTIAL_MARKER;
            }
        }
        
        foreach ($progressionWarnings as $msg => $patientIds)
            $warnings[] = __($msg) . ' - See TFRI# : ' . implode(', ', $patientIds);
        foreach ($warnings as $newWarning)
            AppController::addWarningMsg($newWarning);
        
        if ($csvOrderForDisplay) {
            list ($modelForOrder, $fieldForOrder) = explode('.', $csvOrderForDisplay['field']);
            $mainResultsSortedPerKey = array();
            $emptyResult = array();
            foreach ($mainResults as $newResult) {
                $csvKey = $newResult[$modelForOrder][$fieldForOrder];
                $mainResultsSortedPerKey[$csvKey][] = $newResult;
                $emptyResult = $newResult;
            }
            foreach ($emptyResult as &$modelResult)
                foreach ($modelResult as &$result)
                    $result = '';
            $emptyResult['Participant']['participant_id'] = '-1';
            $mainResults = array();
            $valuesAssignedToManyPatients = array();
            foreach ($csvOrderForDisplay['order'] as $nextKey) {
                if (array_key_exists($nextKey, $mainResultsSortedPerKey)) {
                    if (sizeof($mainResultsSortedPerKey[$nextKey]) > 1)
                        $valuesAssignedToManyPatients[$nextKey] = $nextKey;
                    foreach ($mainResultsSortedPerKey[$nextKey] as $newResult)
                        $mainResults[] = $newResult;
                } else {
                    $mainResults[] = $emptyResult;
                }
            }
            if ($valuesAssignedToManyPatients)
                AppController::addWarningMsg(__('following values are assigned to many patients') . ' : ' . implode(', ', $valuesAssignedToManyPatients));
        }
        
        $arrayToReturn = array(
            'header' => array(),
            'data' => $mainResults,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function tmpFormatdate($value, $accuracy)
    {
        if ($value && $accuracy) {
            switch ($accuracy) {
                case 'i':
                    $value = substr($value, 0, 13);
                    break;
                case 'h':
                    $value = substr($value, 0, 10);
                    break;
                case 'd':
                    $value = substr($value, 0, 7);
                    break;
                case 'm':
                    $value = substr($value, 0, 4);
                    break;
                case 'y':
                    $value = '±' . substr($value, 0, 4);
                    break;
                default:
                    break;
            }
        }
        return $value;
    }
}