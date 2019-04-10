<?php

class ReportsControllerCustom extends ReportsController
{

    public function buildCpcbnSummaryLevel3($parameters)
    {
        return $this->buildCpcbnSummary($parameters, true, true);
    }

    public function buildCpcbnSummaryLevel2($parameters)
    {
        return $this->buildCpcbnSummary($parameters, true);
    }

    public function buildCpcbnSummary($parameters, $displayCoresPositions = false, $displayCoresData = false)
    {
        $conditions = array();
        $warnings = array();
        $joinOnStorage = 'LEFT JOIN';
        
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
        
        if (isset($parameters['Browser'])) {
            
            // 0-REPORT LAUNCHED FROM DATA BROWSER
            
            if (isset($parameters['ViewStorageMaster']['id'])) {
                $joinOnStorage = 'INNER JOIN';
                $criteria = ($parameters['ViewStorageMaster']['id'] == 'all') ? array(
                    'StorageControl.is_tma_block = 1'
                ) : array(
                    'StorageMaster.id' => $parameters['ViewStorageMaster']['id']
                );
                $storageModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                $selectedStorages = $storageModel->find('all', array(
                    'conditions' => $criteria,
                    'recursive' => 0
                ));
                $tmaStorageMasterIds = array();
                foreach ($selectedStorages as $newStorage) {
                    if ($newStorage['StorageControl']['is_tma_block']) {
                        $tmaStorageMasterIds[] = $newStorage['StorageMaster']['id'];
                    } else {
                        $warnings[] = str_replace('%s', $newStorage['StorageMaster']['selection_label'], __('storage [%s] is not a tma block'));
                    }
                }
                if ($tmaStorageMasterIds) {
                    $conditions[] = 'AliquotMaster.storage_master_id IN (' . implode($tmaStorageMasterIds, ',') . ')';
                } else {
                    return array(
                        'header' => array(),
                        'data' => array(),
                        'columns_names' => null,
                        'error_msg' => 'no tma is selected'
                    );
                }
            } elseif (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode($parameters['Participant']['id'], ',') . ')';
                }
            } else {
                die('ERR 9900303');
            }
        } else {
            
            // 1-BANK
            $bankIds = array();
            foreach ($parameters['Participant']['qc_tf_bank_id'] as $newBankId)
                if (strlen($newBankId))
                    $bankIds[] = $newBankId;
            if (! empty($bankIds))
                $conditions[] = 'Participant.qc_tf_bank_id IN (' . implode($bankIds, ',') . ')';
                
                // 2-STORAGE
            $matchingStorageIssue = false;
            $recordedStorageSelectionLabels = array();
            foreach ($parameters['FunctionManagement']['recorded_storage_selection_label'] as $newLabel)
                if (strlen($newLabel))
                    $recordedStorageSelectionLabels[] = $newLabel;
            if (! empty($recordedStorageSelectionLabels)) {
                $joinOnStorage = 'INNER JOIN';
                $storageIds = array();
                $storageModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                foreach ($recordedStorageSelectionLabels as $newRecordedStorageSelectionLabel) {
                    $storageData = $storageModel->getStorageDataFromStorageLabelAndCode($newRecordedStorageSelectionLabel);
                    if (isset($storageData['StorageMaster'])) {
                        if ($storageData['StorageControl']['is_tma_block']) {
                            $storageIds[] = $storageData['StorageMaster']['id'];
                        } else {
                            $warnings[] = str_replace('%s', $newRecordedStorageSelectionLabel, __('storage [%s] is not a tma block'));
                        }
                    } elseif (isset($storageData['error'])) {
                        $warnings[] = __($storageData['error']);
                    }
                }
                if ($storageIds) {
                    $conditions[] = 'AliquotMaster.storage_master_id IN (' . implode($storageIds, ',') . ')';
                } else {
                    $matchingStorageIssue = true;
                }
            }
            
            // 3-PARTICIPANT IDENTIFIER
            $participantIdentifierCriteriaSet = false;
            if (isset($parameters['Participant']['qc_tf_bank_participant_identifier'])) {
                $participantIds = array();
                foreach ($parameters['Participant']['qc_tf_bank_participant_identifier'] as $newParticipantId)
                    if (strlen($newParticipantId))
                        $participantIds[] = $newParticipantId;
                if (! empty($participantIds)) {
                    $conditions[] = "Participant.qc_tf_bank_participant_identifier IN ('" . implode($participantIds, "','") . "')";
                    $participantIdentifierCriteriaSet = true;
                }
            } elseif (isset($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
                if (strlen($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
                    $participantIdentifierCriteriaSet = true;
                    $conditions[] = 'Participant.qc_tf_bank_participant_identifier >= ' . $parameters['Participant']['qc_tf_bank_participant_identifier_start'];
                }
                if (strlen($parameters['Participant']['qc_tf_bank_participant_identifier_end'])) {
                    $participantIdentifierCriteriaSet = true;
                    $conditions[] = 'Participant.qc_tf_bank_participant_identifier <= ' . $parameters['Participant']['qc_tf_bank_participant_identifier_end'];
                }
            }
            if (($_SESSION['Auth']['User']['group_id'] != '1') && $participantIdentifierCriteriaSet) {
                AppController::addWarningMsg(__('your search will be limited to your bank'));
                $conditions[] = "Participant.qc_tf_bank_id = '$userBankId'";
            }
            
            if (empty($conditions) && $matchingStorageIssue) {
                return array(
                    'header' => array(),
                    'data' => array(),
                    'columns_names' => null,
                    'error_msg' => 'no storage matches the selection labels'
                );
            }
        }
        
        $conditionsStr = empty($conditions) ? 'true' : implode($conditions, ' AND ');
        
        // *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********
        
        $joinToDisplayCoresData = $displayCoresData ? 'LEFT JOIN ad_tissue_cores AS AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
			LEFT JOIN aliquot_review_masters AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.aliquot_review_control_id = 2
			LEFT JOIN qc_tf_ar_tissue_cores AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id' : '';
        
        $sql = "SELECT DISTINCT
				Participant.id,
				Participant.qc_tf_bank_id,
				Participant.participant_identifier,
				Participant.qc_tf_bank_participant_identifier,
				Participant.qc_tf_study_exclusions,
				Participant.vital_status,
				Participant.qc_tf_ethnicity,
				Participant.date_of_death,
				Participant.date_of_death_accuracy,
				Participant.qc_tf_suspected_date_of_death,
				Participant.qc_tf_suspected_date_of_death_accuracy,
				
				Participant.qc_tf_last_contact,
				Participant.qc_tf_last_contact_accuracy,
				Participant.qc_tf_death_from_prostate_cancer,

				Participant.qc_tf_last_ct_ov_dept_visited,
				Participant.qc_tf_last_pc_rel_date,
				Participant.qc_tf_last_pc_rel_reason_for_visit,

				Participant.notes as participant_notes,
				
				DiagnosisMaster.id AS primary_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisDetail.tool,
				DiagnosisMaster.age_at_dx,
				DiagnosisDetail.active_surveillance,
				DiagnosisDetail.ptnm,
				DiagnosisDetail.ctnm,
				DiagnosisDetail.gleason_score_biopsy_turp,
				DiagnosisDetail.gleason_score_rp,

				DiagnosisMaster.notes as diagnosis_notes,
			
				TreatmentMaster.start_date ,
				TreatmentMaster.start_date_accuracy,
				TreatmentMaster.notes as treatment_notes,
				
				TreatmentDetail.qc_tf_lymph_node_invasion ,
				TreatmentDetail.qc_tf_capsular_penetration,
				TreatmentDetail.qc_tf_seminal_vesicle_invasion,
				TreatmentDetail.qc_tf_margin,
				TreatmentDetail.qc_tf_gleason_grade,
				
				DiagnosisDetail.hormonorefractory_status,
				DiagnosisDetail.survival_in_months,
				DiagnosisDetail.bcr_in_months" . 

        ($displayCoresPositions ? ', StorageMaster.selection_label, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, StorageMaster.short_label, StorageMaster.qc_tf_tma_name, StorageMaster.qc_tf_tma_label_site, StorageMaster.qc_tf_bank_id' : ' ') . 

        ($displayCoresData ? ',AliquotDetail.qc_tf_core_nature_site, AliquotDetail.qc_tf_core_nature_revised, AliquotReviewDetail.revised_nature, AliquotReviewDetail.grade ' : ' ') . 

        "FROM participants AS Participant 

			$joinOnStorage collections AS Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
			$joinOnStorage aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND aliquot_control_id = 33
			$joinOnStorage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
							
			LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_cpcbn AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			
			LEFT JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = 6 AND TreatmentMaster.deleted <> 1
			LEFT JOIN txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			
			$joinToDisplayCoresData
			
			WHERE Participant.deleted <> 1 AND ($conditionsStr)
			
			ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC " . ($displayCoresPositions ? ', StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC' : '') . ";";
        
        $mainResults = $this->Report->tryCatchQuery($sql);
        
        $primaryIds = array();
        $participantIds = array();
        $bankList = null;
        if ($displayCoresPositions) {
            $BankModel = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $BankModel->getBankPermissibleValuesForControls();
        }
        foreach ($mainResults as &$newParticipant) {
            $participantIds[] = $newParticipant['Participant']['id'];
            $newParticipant['Generated']['is_suspected_date_of_death'] = '';
            if (! empty($newParticipant['Participant']['date_of_death'])) {
                $newParticipant['Generated']['is_suspected_date_of_death'] = 'n';
            } elseif (! empty($newParticipant['Participant']['qc_tf_suspected_date_of_death'])) {
                $newParticipant['Participant']['date_of_death'] = $newParticipant['Participant']['qc_tf_suspected_date_of_death'];
                $newParticipant['Participant']['date_of_death_accuracy'] = $newParticipant['Participant']['qc_tf_suspected_date_of_death_accuracy'];
                $newParticipant['Generated']['is_suspected_date_of_death'] = 'y';
            }
            if (! empty($newParticipant['DiagnosisMaster']['primary_id']))
                $primaryIds[] = $newParticipant['DiagnosisMaster']['primary_id'];
            $newParticipant['Generated']['qc_tf_gleason_grade_rp'] = $newParticipant['TreatmentDetail']['qc_tf_gleason_grade'];
            $newParticipant['Generated']['qc_tf_all_participant_notes'] = array(
                strlen($newParticipant['Participant']['participant_notes']) ? 'Profile : ' . $newParticipant['Participant']['participant_notes'] : ''
            );
            $newParticipant['Generated']['qc_tf_all_participant_notes'][] = strlen($newParticipant['DiagnosisMaster']['diagnosis_notes']) ? 'Diagnosis : ' . $newParticipant['DiagnosisMaster']['diagnosis_notes'] : '';
            $newParticipant['Generated']['qc_tf_all_participant_notes'][] = strlen($newParticipant['TreatmentMaster']['treatment_notes']) ? 'Treatment : ' . $newParticipant['TreatmentMaster']['treatment_notes'] : '';
            if ($displayCoresPositions) {
                // Manage tma block confidential information
                $setToConfidential = ($_SESSION['Auth']['User']['group_id'] != '1' && (! isset($newParticipant['StorageMaster']['qc_tf_bank_id']) || $newParticipant['StorageMaster']['qc_tf_bank_id'] != $userBankId)) ? true : false;
                if ($setToConfidential) {
                    if (isset($newParticipant['StorageMaster']['qc_tf_bank_id']))
                        $newParticipant['StorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
                    if (isset($newParticipant['StorageMaster']['qc_tf_tma_label_site']))
                        $newParticipant['StorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
                    if (isset($newParticipant['StorageMaster']['qc_tf_tma_name']))
                        $newParticipant['StorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
                }
                // Create the storage information label to display$result['StorageMaster']['qc_tf_generated_label_for_display'] = $result['StorageMaster']['short_label'];
                $qcTfGeneratedLabelForDisplay = $newParticipant['StorageMaster']['short_label'];
                if (isset($newParticipant['StorageMaster']['qc_tf_tma_name'])) {
                    if ($_SESSION['Auth']['User']['group_id'] == '1') {
                        $qcTfGeneratedLabelForDisplay = $newParticipant['StorageMaster']['qc_tf_tma_name'] . (isset($newParticipant['StorageMaster']['qc_tf_bank_id']) ? ' (' . $bankList[$newParticipant['StorageMaster']['qc_tf_bank_id']] . ')' : '');
                    } elseif ($newParticipant['StorageMaster']['qc_tf_bank_id'] == $userBankId) {
                        $qcTfGeneratedLabelForDisplay = $newParticipant['StorageMaster']['qc_tf_tma_label_site'];
                    }
                }
                $newParticipant['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'] = ($qcTfGeneratedLabelForDisplay == $newParticipant['StorageMaster']['short_label']) ? '' : '|| ' . $qcTfGeneratedLabelForDisplay;
            }
        }
        $primaryIdsCondition = empty($primaryIds) ? '' : 'DiagnosisMaster.primary_id IN (' . implode($primaryIds, ',') . ')';
        $participantIds = empty($participantIds) ? array(
            '-1'
        ) : $participantIds;
        
        // *********** Get Bx DX, etc ********
        
        $bxDxGleasonGradesFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $TreatmentMasterModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
            $sql = "SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					TreatmentMaster.start_date,
					TreatmentMaster.start_date_accuracy,
					TreatmentDetail.type,
					TreatmentDetail.gleason_grade
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1
				INNER JOIN qc_tf_txd_biopsies_and_turps AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentDetail.type_specification = 'Dx'
				WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition
				ORDER BY DiagnosisMaster.primary_id ASC;";
            $gleasonGradesBxDx = $this->Report->tryCatchQuery($sql);
            $tmpNewPrimaryId = '';
            foreach ($gleasonGradesBxDx as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    $bxDxGleasonGradesFromPrimaryId[$studiedPrimaryId] = array(
                        'Generated' => array(
                            'qc_tf_date_biopsy_turp' => $this->formatReportDateForDisplay($newRes['TreatmentMaster']['start_date'], $newRes['TreatmentMaster']['start_date_accuracy']),
                            'qc_tf_date_biopsy_turp_accuracy' => $newRes['TreatmentMaster']['start_date_accuracy'],
                            'qc_tf_type_biopsy_turp' => $newRes['TreatmentDetail']['type'],
                            'qc_tf_gleason_grade_biopsy_turp' => $newRes['TreatmentDetail']['gleason_grade'],
                            'qc_tf_date_confirmation_biopsy_turp' => '',
                            'qc_tf_type_confirmation_biopsy_turp' => ''
                        )
                    );
                    if ($newRes['TreatmentMaster']['start_date']) {
                        // Get confirmation Biopsy
                        $sql = "SELECT DISTINCT
								TreatmentMaster.start_date,
								TreatmentMaster.start_date_accuracy,
								TreatmentDetail.type
							FROM diagnosis_masters AS DiagnosisMaster
							INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1
							INNER JOIN qc_tf_txd_biopsies_and_turps AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id AND (TreatmentDetail.type != 'Dx' OR TreatmentDetail.type IS NULL)
							WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.primary_id = $studiedPrimaryId
							AND TreatmentMaster.start_date IS NOT NULL
							AND TreatmentMaster.start_date > '" . $newRes['TreatmentMaster']['start_date'] . "'
							ORDER BY TreatmentMaster.start_date ASC
							LIMIT 0,1;";
                        $bxConfirmation = $this->Report->tryCatchQuery($sql);
                        if ($bxConfirmation) {
                            $bxDxGleasonGradesFromPrimaryId[$studiedPrimaryId]['Generated']['qc_tf_date_confirmation_biopsy_turp'] = $this->formatReportDateForDisplay($bxConfirmation[0]['TreatmentMaster']['start_date'], $bxConfirmation[0]['TreatmentMaster']['start_date_accuracy']);
                            $bxDxGleasonGradesFromPrimaryId[$studiedPrimaryId]['Generated']['qc_tf_date_confirmation_biopsy_turp_accuracy'] = $bxConfirmation[0]['TreatmentMaster']['start_date_accuracy'];
                            $bxDxGleasonGradesFromPrimaryId[$studiedPrimaryId]['Generated']['qc_tf_type_confirmation_biopsy_turp'] = $bxConfirmation[0]['TreatmentDetail']['type'];
                        }
                    }
                } else {
                    die('ERR 1993434343');
                }
            }
        }
        
        // *********** Get Fst Bcr ***********
        
        $fstBcrResultsFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					FstBcrDiagnosisMaster.dx_date AS first_bcr_date,
					FstBcrDiagnosisMaster.dx_date_accuracy AS first_bcr_date_accuracy,
					FstBcrDiagnosisDetail.type AS first_bcr_type
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN diagnosis_masters AS FstBcrDiagnosisMaster ON DiagnosisMaster.id = FstBcrDiagnosisMaster.primary_id AND FstBcrDiagnosisMaster.diagnosis_control_id = 22 AND FstBcrDiagnosisMaster.deleted <> 1
				INNER JOIN qc_tf_dxd_recurrence_bio AS FstBcrDiagnosisDetail ON FstBcrDiagnosisDetail.diagnosis_master_id = FstBcrDiagnosisMaster.id AND FstBcrDiagnosisDetail.first_biochemical_recurrence = 1
				WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition
				ORDER BY DiagnosisMaster.primary_id ASC;";
            
            $fstBcrResults = $this->Report->tryCatchQuery($sql);
            
            $tmpNewPrimaryId = '';
            foreach ($fstBcrResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    unset($newRes['DiagnosisMaster']);
                    $newRes['FstBcrDiagnosisMaster']['first_bcr_date'] = $this->formatReportDateForDisplay($newRes['FstBcrDiagnosisMaster']['first_bcr_date'], $newRes['FstBcrDiagnosisMaster']['first_bcr_date_accuracy']);
                    $fstBcrResultsFromPrimaryId[$studiedPrimaryId] = $newRes;
                } else {
                    die('ERR 19938939323');
                }
            }
        }
        
        // *********** Get DFS start & PSA PreDFS ***********
        
        $dfsStartResultsFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
				
					TreatmentMaster.start_date AS dfs_start_date,
					TreatmentMaster.start_date_accuracy AS dfs_start_date_accuracy,
					TreatmentControl.tx_method AS dfs_tx_method,
					TreatmentControl.disease_site AS dfs_disease_site,
				
					PsaEventMaster.event_date AS psa_event_date,
					PsaEventMaster.event_date_accuracy AS psa_event_date_accuracy,
					PsaEventDetail.psa_ng_per_ml
					
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.qc_tf_disease_free_survival_start_events = 1
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				LEFT JOIN event_masters AS PsaEventMaster ON PsaEventMaster.diagnosis_master_id = DiagnosisMaster.id AND PsaEventMaster.deleted <> 1 AND PsaEventMaster.event_control_id = 52 AND PsaEventMaster.event_date LIKE '%-%-%' AND PsaEventMaster.event_date <= TreatmentMaster.start_date
				LEFT JOIN qc_tf_ed_psa AS PsaEventDetail ON PsaEventDetail.event_master_id = PsaEventMaster.id
				WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition 
				ORDER BY DiagnosisMaster.primary_id ASC, PsaEventMaster.event_date DESC;";
            
            $dfsStartResults = $this->Report->tryCatchQuery($sql);
            
            $tmpNewPrimaryId = '';
            foreach ($dfsStartResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                
                $studiedData = array(
                    'DfsTreatmentMaster' => array(
                        'dfs_start_date' => $this->formatReportDateForDisplay($newRes['TreatmentMaster']['dfs_start_date'], $newRes['TreatmentMaster']['dfs_start_date_accuracy']),
                        'dfs_start_date_accuracy' => $newRes['TreatmentMaster']['dfs_start_date_accuracy']
                    ),
                    'DfsTreatmentControl' => array(
                        'dfs_tx_method' => $newRes['TreatmentControl']['dfs_tx_method'],
                        'dfs_disease_site' => $newRes['TreatmentControl']['dfs_disease_site']
                    ),
                    'PsaEventMaster' => array(
                        'psa_event_date' => $this->formatReportDateForDisplay($newRes['PsaEventMaster']['psa_event_date'], $newRes['PsaEventMaster']['psa_event_date_accuracy']),
                        'psa_event_date_accuracy' => $newRes['PsaEventMaster']['psa_event_date_accuracy']
                    ),
                    'PsaEventDetail' => array(
                        'psa_ng_per_ml' => $newRes['PsaEventDetail']['psa_ng_per_ml']
                    )
                );
                
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    $dfsStartResultsFromPrimaryId[$studiedPrimaryId] = $studiedData;
                } elseif (array_diff_assoc($dfsStartResultsFromPrimaryId[$studiedPrimaryId]['DfsTreatmentMaster'], $studiedData['DfsTreatmentMaster']) || array_diff_assoc($studiedData['DfsTreatmentMaster'], $dfsStartResultsFromPrimaryId[$studiedPrimaryId]['DfsTreatmentMaster']) || array_diff_assoc($dfsStartResultsFromPrimaryId[$studiedPrimaryId]['DfsTreatmentControl'], $studiedData['DfsTreatmentControl']) || array_diff_assoc($studiedData['DfsTreatmentControl'], $dfsStartResultsFromPrimaryId[$studiedPrimaryId]['DfsTreatmentControl'])) {
                    pr($studiedData);
                    pr($dfsStartResultsFromPrimaryId[$studiedPrimaryId]);
                    die('ERR 123');
                }
            }
        }
        
        // *********** Get Last PSA ***********
        
        $lastPsaFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
				
					PsaEventMaster.event_date AS psa_event_date,
					PsaEventMaster.event_date_accuracy AS psa_event_date_accuracy,
					PsaEventDetail.psa_ng_per_ml
					
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN event_masters AS PsaEventMaster ON PsaEventMaster.diagnosis_master_id = DiagnosisMaster.id AND PsaEventMaster.deleted <> 1 AND PsaEventMaster.event_control_id = 52 AND PsaEventMaster.event_date IS NOT NULL
				INNER JOIN qc_tf_ed_psa AS PsaEventDetail ON PsaEventDetail.event_master_id = PsaEventMaster.id
				WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition 
				ORDER BY DiagnosisMaster.primary_id ASC, PsaEventMaster.event_date DESC;";
            
            $lastPsaResults = $this->Report->tryCatchQuery($sql);
            
            $tmpNewPrimaryId = '';
            foreach ($lastPsaResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                
                $studiedData = array(
                    'PsaEventMaster' => array(
                        'qc_tf_last_psa_event_date' => $this->formatReportDateForDisplay($newRes['PsaEventMaster']['psa_event_date'], $newRes['PsaEventMaster']['psa_event_date_accuracy']),
                        'qc_tf_last_psa_event_date_accuracy' => $newRes['PsaEventMaster']['psa_event_date_accuracy']
                    ),
                    'PsaEventDetail' => array(
                        'qc_tf_last_psa_ng_per_ml' => $newRes['PsaEventDetail']['psa_ng_per_ml']
                    )
                );
                
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    $lastPsaFromPrimaryId[$studiedPrimaryId] = $studiedData;
                }
            }
        }
        // *********** Get Last BMI ***********
        
        $lastBmiFromParticipantId = array();
        if ($participantIds) {
            $sql = "SELECT DISTINCT
					BmiEventMaster.participant_id,
					BmiEventMaster.event_date AS bmi_event_date,
					BmiEventMaster.event_date_accuracy AS bmi_event_date_accuracy,
					BmiEventDetail.bmi
					
				FROM event_masters AS BmiEventMaster
				INNER JOIN qc_tf_ed_clinical_bmis AS BmiEventDetail ON BmiEventDetail.event_master_id = BmiEventMaster.id
				WHERE BmiEventMaster.deleted <> 1 AND BmiEventMaster.event_control_id = 56 AND  BmiEventMaster.participant_id IN (" . implode(',', $participantIds) . ")
				ORDER BY BmiEventMaster.event_date DESC;";

            $lastBmiResults = $this->Report->tryCatchQuery($sql);

            $tmpNewParticipantId = '';
            foreach ($lastBmiResults as $newRes) {
                $studiedParticipantId = $newRes['BmiEventMaster']['participant_id'];

                $studiedData = array(
                    'BmiEventMaster' => array(
                        'qc_tf_last_bmi_event_date' => $this->formatReportDateForDisplay($newRes['BmiEventMaster']['bmi_event_date'], $newRes['BmiEventMaster']['bmi_event_date_accuracy']),
                        'qc_tf_last_bmi_event_date_accuracy' => $newRes['BmiEventMaster']['bmi_event_date_accuracy']
                    ),
                    'BmiEventDetail' => array(
                        'bmi' => $newRes['BmiEventDetail']['bmi']
                    )
                );

                if ($tmpNewParticipantId != $studiedParticipantId) {
                    $tmpNewParticipantId = $studiedParticipantId;
                    $lastBmiFromParticipantId[$studiedParticipantId] = $studiedData;
                } else if (empty($lastBmiFromParticipantId[$studiedParticipantId]['BmiEventMaster']['qc_tf_last_bmi_event_date']) && ! empty($studiedData['BmiEventMaster']['qc_tf_last_bmi_event_date'])) {
                    $lastBmiFromParticipantId[$studiedParticipantId] = $studiedData;
                }
            }
        }
        
        // *********** Get Metastasis ***********
        
        $metastasisResultsFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
				DiagnosisMaster.primary_id,
				DiagnosisMaster.participant_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisDetail.site
				
			FROM diagnosis_masters AS DiagnosisMaster
			INNER JOIN qc_tf_dxd_metastasis AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id = 21 AND $primaryIdsCondition
			ORDER BY DiagnosisMaster.dx_date ASC;";
            
            $metastasisResults = $this->Report->tryCatchQuery($sql);
            
            $tmpNewPrimaryId = '';
            $isFirstOneSet = false;
            $tmpData = array();
            foreach ($metastasisResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId] = array(
                        'Metastasis' => array(
                            'first_metastasis_dx_date' => '',
                            'first_metastasis_dx_date_accuracy' => '',
                            'qc_tf_first_bone_metastasis_date' => '',
                            'qc_tf_first_bone_metastasis_date_accuracy' => '',
                            'first_metastasis_type' => '',
                            'other_types' => ''
                        )
                    );
                }
                if (empty($metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date']) && ! empty($newRes['DiagnosisMaster']['dx_date'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date'] = $this->formatReportDateForDisplay($newRes['DiagnosisMaster']['dx_date'], $newRes['DiagnosisMaster']['dx_date_accuracy']);
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date_accuracy'] = $newRes['DiagnosisMaster']['dx_date_accuracy'];
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_type'] = $newRes['DiagnosisDetail']['site'];
                } elseif (! empty($newRes['DiagnosisDetail']['site'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['other_types'][] = __($newRes['DiagnosisDetail']['site']);
                }
                if ($newRes['DiagnosisDetail']['site'] == 'bone' && empty($metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date']) && ! empty($newRes['DiagnosisMaster']['dx_date'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date'] = $this->formatReportDateForDisplay($newRes['DiagnosisMaster']['dx_date'], $newRes['DiagnosisMaster']['dx_date_accuracy']);
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date_accuracy'] = $newRes['DiagnosisMaster']['dx_date_accuracy'];
                }
            }
        }
        
        // *********** Get Trt ***********
        
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $tmp = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'radiotherapy types'
        ));
        $radiotherapyTypes = array_merge($tmp['defined'], $tmp['previously_defined']);
        
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $tmp = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'Hormonotherapy Types'
        ));
        $hormonotherapyTypes = array_merge($tmp['defined'], $tmp['previously_defined']);
        
        $treatmentsSummaryTemplate = array(
            'Generated' => array(
                'qc_tf_chemo_flag' => 'n',
                'qc_tf_chemo_first_date' => '',
                'qc_tf_radiation_flag' => 'n',
                'qc_tf_radiation_details' => '',
                'qc_tf_radiation_first_date' => '',
                'qc_tf_hormono_flag' => 'n',
                'qc_tf_hormono_details' => '',
                'qc_tf_hormono_first_date' => ''
            )
        );
        $sql = "SELECT distinct TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentMaster.participant_id, TreatmentControl.tx_method, RadiationDetails.qc_tf_type, HormonoDetails.type
			FROM treatment_masters TreatmentMaster 
			INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			LEFT JOIN txd_radiations RadiationDetails ON RadiationDetails.treatment_master_id =  TreatmentMaster.id
            LEFT JOIN qc_tf_txd_hormonotherapies HormonoDetails ON HormonoDetails.treatment_master_id =  TreatmentMaster.id
			WHERE TreatmentMaster.deleted <> 1
			AND TreatmentControl.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
			AND TreatmentMaster.participant_id IN (" . implode(',', $participantIds) . ")
			ORDER BY TreatmentMaster.start_date ASC";
        $treatmentResults = $this->Report->tryCatchQuery($sql);
        $treatmentsSummary = array();
        foreach ($treatmentResults as $newTrt) {
            $participantId = $newTrt['TreatmentMaster']['participant_id'];
            if (! isset($treatmentsSummary[$participantId]))
                $treatmentsSummary[$participantId] = $treatmentsSummaryTemplate;
            switch ($newTrt['TreatmentControl']['tx_method']) {
                case 'hormonotherapy':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_flag'] = 'y';
                    if ($newTrt['HormonoDetails']['type']) {
                        $hormonoType = isset($hormonotherapyTypes[$newTrt['HormonoDetails']['type']]) ? $hormonotherapyTypes[$newTrt['HormonoDetails']['type']] : $newTrt['HormonoDetails']['type'];
                        if (! preg_match("/$hormonoType/", $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details'])) {
                            $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details'] .= (empty($treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details']) ? '' : ', ') . $hormonoType;
                        }
                    }
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
                case 'radiation':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_flag'] = 'y';
                    if ($newTrt['RadiationDetails']['qc_tf_type']) {
                        $radiationType = isset($radiotherapyTypes[$newTrt['RadiationDetails']['qc_tf_type']]) ? $radiotherapyTypes[$newTrt['RadiationDetails']['qc_tf_type']] : $newTrt['RadiationDetails']['qc_tf_type'];
                        if (! preg_match("/$radiationType/", $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details'])) {
                            $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details'] .= (empty($treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details']) ? '' : ', ') . $radiationType;
                        }
                    }
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
                case 'chemotherapy':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_flag'] = 'y';
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
            }
        }
        
        // *********** Get Core Review ***********
        
        $participantIdsToRevisedGrades = null;
        if (! $displayCoresPositions) {
            $participantIdsToRevisedGrades = array();
            $sql = "
				SELECT Collection.participant_id, GROUP_CONCAT(AliquotReviewDetail.grade SEPARATOR '##') AS qc_tf_participant_reviewed_grades
				FROM collections Collection 
				INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
				INNER JOIN aliquot_review_masters AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.aliquot_review_control_id = 2
				INNER JOIN qc_tf_ar_tissue_cores AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id
				WHERE Collection.deleted <> 1 AND Collection.participant_id IN (" . implode(',', $participantIds) . ")
				GROUP BY Collection.participant_id";
            foreach ($this->Report->tryCatchQuery($sql) as $newPatientRevisedGrades) {
                $qcTfParticipantReviewedGrades = explode('##', $newPatientRevisedGrades['0']['qc_tf_participant_reviewed_grades']);
                asort($qcTfParticipantReviewedGrades);
                
                $participantIdsToRevisedGrades[$newPatientRevisedGrades['Collection']['participant_id']] = implode(' ', $qcTfParticipantReviewedGrades);
            }
        }
        
        // *********** Merge all data ***********
        
        $dfsPsaTemplate = array(
            'DfsTreatmentMaster' => array(
                'dfs_start_date' => '',
                'dfs_start_date_accuracy' => ''
            ),
            'DfsTreatmentControl' => array(
                'dfs_tx_method' => '',
                'dfs_disease_site' => ''
            ),
            'PsaEventMaster' => array(
                'psa_event_date' => '',
                'psa_event_date_accuracy' => ''
            ),
            'PsaEventDetail' => array(
                'psa_ng_per_ml' => ''
            )
        );
        
        $lastPsaTemplate = array(
            'PsaEventMaster' => array(
                'qc_tf_last_psa_event_date' => '',
                'qc_tf_last_psa_event_date_accuracy' => ''
            ),
            'PsaEventDetail' => array(
                'qc_tf_last_psa_ng_per_ml' => ''
            )
        );
        
        $metastasisTemplate = array(
            'Metastasis' => array(
                'first_metastasis_dx_date' => '',
                'first_metastasis_dx_date_accuracy' => '',
                'qc_tf_first_bone_metastasis_date' => '',
                'qc_tf_first_bone_metastasis_date_accuracy' => '',
                'first_metastasis_type' => '',
                'other_types' => ''
            )
        );
        $fstBcrTemplate = array(
            'FstBcrDiagnosisMaster' => array(
                'first_bcr_date' => '',
                'first_bcr_date_accuracy' => ''
            ),
            'FstBcrDiagnosisDetail' => array(
                'first_bcr_type' => ''
            )
        );
        $lastBmiTemplate = array(
            'BmiEventMaster' => array(
                'qc_tf_last_bmi_event_date' => '',
                'qc_tf_last_bmi_event_date_accuracy' => ''
            ),
            'BmiEventDetail' => array(
                'bmi' => ''
            )
        );
        foreach ($mainResults as &$newParticipant) {
            $newParticipant['Generated']['qc_tf_all_participant_notes'] = array_filter($newParticipant['Generated']['qc_tf_all_participant_notes']);
            $newParticipant['Generated']['qc_tf_all_participant_notes'] = implode(' & ', $newParticipant['Generated']['qc_tf_all_participant_notes']);
            if (isset($dfsStartResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $dfsStartResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $dfsPsaTemplate);
            }
            if (isset($lastPsaFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $lastPsaFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $lastPsaTemplate);
            }
            if (isset($metastasisResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']])) {
                $otherTypes = $metastasisResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'];
                $metastasisResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'] = (empty($otherTypes) || ! is_array($otherTypes)) ? '' : implode($otherTypes, ' | ');
                $newParticipant = array_merge_recursive($newParticipant, $metastasisResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $metastasisTemplate);
            }
            if (isset($fstBcrResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $fstBcrResultsFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $fstBcrTemplate);
            }
            if (isset($treatmentsSummary[$newParticipant['Participant']['id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $treatmentsSummary[$newParticipant['Participant']['id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $treatmentsSummaryTemplate);
            }
            if (isset($bxDxGleasonGradesFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $bxDxGleasonGradesFromPrimaryId[$newParticipant['DiagnosisMaster']['primary_id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, array(
                    'Generated' => array(
                        'qc_tf_date_biopsy_turp' => '',
                        'qc_tf_type_biopsy_turp' => '',
                        'qc_tf_gleason_grade_biopsy_turp' => '',
                        'qc_tf_date_confirmation_biopsy_turp' => '',
                        'qc_tf_type_confirmation_biopsy_turp' => ''
                    )
                ));
            }
            if (isset($lastBmiFromParticipantId[$newParticipant['Participant']['id']])) {
                $newParticipant = array_merge_recursive($newParticipant, $lastBmiFromParticipantId[$newParticipant['Participant']['id']]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $lastBmiTemplate);
            }
            $dateDiffDef = array(
                'Participant.qc_tf_last_contact' => 'Generated.qc_tf_rp_to_last_contact',
                'Metastasis.qc_tf_first_bone_metastasis_date' => 'Generated.qc_tf_rp_to_bone_met',
                'FstBcrDiagnosisMaster.first_bcr_date' => 'Generated.qc_tf_rp_to_bcr',
                'PsaEventMaster.qc_tf_last_psa_event_date' => 'Generated.qc_tf_rp_to_last_psa'
            );
            foreach ($dateDiffDef as $modelFieldData => $modelFieldCalculated) {
                list ($modelData, $fieldData) = explode('.', $modelFieldData);
                list ($modelCalculated, $fieldCalculated) = explode('.', $modelFieldCalculated);
                $newParticipant[$modelCalculated][$fieldCalculated] = $this->getDateDiffInMonths($newParticipant['TreatmentMaster']['start_date'], $newParticipant[$modelData][$fieldData]);
                if ($newParticipant[$modelData][$fieldData . '_accuracy'] . $newParticipant['TreatmentMaster']['start_date_accuracy'] != 'cc' && $newParticipant[$modelData][$fieldData] && $newParticipant['TreatmentMaster']['start_date'])
                    $warnings[] = __('intervals from rp have been calculated with at least one inaccuracy date');
            }
            list ($modelData, $fieldData) = explode('.', $modelFieldData);
            list ($modelCalculated, $fieldCalculated) = explode('.', $modelFieldCalculated);
            $newParticipant['Generated']['qc_tf_last_psa_to_last_contact_ov'] = $this->getDateDiffInMonths($newParticipant['PsaEventMaster']['qc_tf_last_psa_event_date'], $newParticipant['Participant']['qc_tf_last_contact']);
            if ($newParticipant['PsaEventMaster']['qc_tf_last_psa_event_date_accuracy'] . $newParticipant['Participant']['qc_tf_last_contact_accuracy'] != 'cc' && $newParticipant['PsaEventMaster']['qc_tf_last_psa_event_date'] && $newParticipant['Participant']['qc_tf_last_contact'])
                $warnings[] = __('intervals from last PSA to last contact have been calculated with at least one inaccuracy date');
            if (! is_null($participantIdsToRevisedGrades)) {
                if (array_key_exists($newParticipant['Participant']['id'], $participantIdsToRevisedGrades)) {
                    $newParticipant['Generated']['qc_tf_participant_reviewed_grades'] = $participantIdsToRevisedGrades[$newParticipant['Participant']['id']];
                } else {
                    $newParticipant['Generated']['qc_tf_participant_reviewed_grades'] = '';
                }
            }
            if (($_SESSION['Auth']['User']['group_id'] != '1') && ($newParticipant['Participant']['qc_tf_bank_id'] != $userBankId)) {
                $newParticipant['Participant']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                $newParticipant['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
            }
        }
        foreach ($warnings as $newWarning)
            AppController::addWarningMsg($newWarning);
        $arrayToReturn = array(
            'header' => array(),
            'data' => $mainResults,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }
    
    public function activeSurveillanceReport($parameters)
    {
        $conditions = array();
        $warnings = array();
        $joinOnStorage = false;
    
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
    
        if (isset($parameters['Browser'])) {
    
            // 0-REPORT LAUNCHED FROM DATA BROWSER
    
            if (isset($parameters['ViewStorageMaster']['id'])) {
                $joinOnStorage = true;
                $criteria = ($parameters['ViewStorageMaster']['id'] == 'all') ? array(
                    'StorageControl.is_tma_block = 1'
                ) : array(
                    'StorageMaster.id' => $parameters['ViewStorageMaster']['id']
                );
                $storageModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                $selectedStorages = $storageModel->find('all', array(
                    'conditions' => $criteria,
                    'recursive' => 0
                ));
                $tmaStorageMasterIds = array();
                foreach ($selectedStorages as $newStorage) {
                    if ($newStorage['StorageControl']['is_tma_block']) {
                        $tmaStorageMasterIds[] = $newStorage['StorageMaster']['id'];
                    } else {
                        $warnings[] = str_replace('%s', $newStorage['StorageMaster']['selection_label'], __('storage [%s] is not a tma block'));
                    }
                }
                if ($tmaStorageMasterIds) {
                    $conditions[] = 'AliquotMaster.storage_master_id IN (' . implode($tmaStorageMasterIds, ',') . ')';
                } else {
                    return array(
                        'header' => array(),
                        'data' => array(),
                        'columns_names' => null,
                        'error_msg' => 'no tma is selected'
                    );
                }
            } elseif (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode($parameters['Participant']['id'], ',') . ')';
                }
            } else {
                die('ERR 9900303');
            }
        } else {
    
            // 1-BANK
            $bankIds = array();
            foreach ($parameters['Participant']['qc_tf_bank_id'] as $newBankId)
                if (strlen($newBankId))
                    $bankIds[] = $newBankId;
                if (! empty($bankIds))
                    $conditions[] = 'Participant.qc_tf_bank_id IN (' . implode($bankIds, ',') . ')';
    
                // 2-STORAGE
                $matchingStorageIssue = false;
                $recordedStorageSelectionLabels = array();
                foreach ($parameters['FunctionManagement']['recorded_storage_selection_label'] as $newLabel)
                    if (strlen($newLabel))
                        $recordedStorageSelectionLabels[] = $newLabel;
                    if (! empty($recordedStorageSelectionLabels)) {
                        $joinOnStorage = true;
                        $storageIds = array();
                        $storageModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                        foreach ($recordedStorageSelectionLabels as $newRecordedStorageSelectionLabel) {
                            $storageData = $storageModel->getStorageDataFromStorageLabelAndCode($newRecordedStorageSelectionLabel);
                            if (isset($storageData['StorageMaster'])) {
                                if ($storageData['StorageControl']['is_tma_block']) {
                                    $storageIds[] = $storageData['StorageMaster']['id'];
                                } else {
                                    $warnings[] = str_replace('%s', $newRecordedStorageSelectionLabel, __('storage [%s] is not a tma block'));
                                }
                            } elseif (isset($storageData['error'])) {
                                $warnings[] = __($storageData['error']);
                            }
                        }
                        if ($storageIds) {
                            $conditions[] = 'AliquotMaster.storage_master_id IN (' . implode($storageIds, ',') . ')';
                        } else {
                            $matchingStorageIssue = true;
                        }
                    }
    
                    // 3-PARTICIPANT IDENTIFIER
                    $participantIdentifierCriteriaSet = false;
                    if (isset($parameters['Participant']['qc_tf_bank_participant_identifier'])) {
                        $participantIds = array();
                        foreach ($parameters['Participant']['qc_tf_bank_participant_identifier'] as $newParticipantId)
                            if (strlen($newParticipantId))
                                $participantIds[] = $newParticipantId;
                            if (! empty($participantIds)) {
                                $conditions[] = "Participant.qc_tf_bank_participant_identifier IN ('" . implode($participantIds, "','") . "')";
                                $participantIdentifierCriteriaSet = true;
                            }
                    } elseif (isset($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
                        if (strlen($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
                            $participantIdentifierCriteriaSet = true;
                            $conditions[] = 'Participant.qc_tf_bank_participant_identifier >= ' . $parameters['Participant']['qc_tf_bank_participant_identifier_start'];
                        }
                        if (strlen($parameters['Participant']['qc_tf_bank_participant_identifier_end'])) {
                            $participantIdentifierCriteriaSet = true;
                            $conditions[] = 'Participant.qc_tf_bank_participant_identifier <= ' . $parameters['Participant']['qc_tf_bank_participant_identifier_end'];
                        }
                    }
                    if (($_SESSION['Auth']['User']['group_id'] != '1') && $participantIdentifierCriteriaSet) {
                        AppController::addWarningMsg(__('your search will be limited to your bank'));
                        $conditions[] = "Participant.qc_tf_bank_id = '$userBankId'";
                    }
    
                    if (empty($conditions) && $matchingStorageIssue) {
                        return array(
                            'header' => array(),
                            'data' => array(),
                            'columns_names' => null,
                            'error_msg' => 'no storage matches the selection labels'
                        );
                    }
        }
    
        $conditionsStr = empty($conditions) ? 'true' : implode($conditions, ' AND ');
    
        // *********** Get Participant & Primary Prostate Diagnosis & RP ***********
    
        $sql = "SELECT DISTINCT
			Participant.id,
			Participant.qc_tf_bank_id,
			Participant.participant_identifier,
			Participant.qc_tf_bank_participant_identifier,
			Participant.qc_tf_study_exclusions,
			Participant.date_of_birth,
			Participant.date_of_birth_accuracy,
			Participant.vital_status,
            Participant.qc_tf_ethnicity,
			Participant.date_of_death,
			Participant.date_of_death_accuracy,
			Participant.qc_tf_suspected_date_of_death,
			Participant.qc_tf_suspected_date_of_death_accuracy,

			Participant.qc_tf_last_contact,
			Participant.qc_tf_last_contact_accuracy,
			Participant.qc_tf_death_from_prostate_cancer,

            DiagnosisMaster.id AS primary_id,
            DiagnosisMaster.dx_date,
            DiagnosisMaster.dx_date_accuracy,
            DiagnosisDetail.tool,
            DiagnosisMaster.age_at_dx,
            DiagnosisDetail.ptnm,
	
			TreatmentMaster.start_date ,
			TreatmentMaster.start_date_accuracy,
            TIMESTAMPDIFF(YEAR, Participant.date_of_birth, TreatmentMaster.start_date) AS qc_tf_age_at_rp,
			TreatmentDetail.qc_tf_lymph_node_invasion ,
			TreatmentDetail.qc_tf_capsular_penetration,
			TreatmentDetail.qc_tf_seminal_vesicle_invasion,
			TreatmentDetail.qc_tf_margin,
			TreatmentDetail.qc_tf_gleason_grade,
			TreatmentDetail.qc_tf_gleason_score
			
            FROM participants AS Participant" .
    
			($joinOnStorage? "
    			INNER JOIN collections AS Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
    			INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND aliquot_control_id = 33
    			INNER JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1 " : 
			    '') . "
    					
			LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_cpcbn AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
					
			LEFT JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = 6 AND TreatmentMaster.deleted <> 1
			LEFT JOIN txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				
			WHERE Participant.deleted <> 1 AND ($conditionsStr)
				
			ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC;";
    
        $mainResults = $this->Report->tryCatchQuery($sql);
        $primaryIds = array();
        $participantIds = array();
        foreach ($mainResults as &$newParticipant) {
            $participantIds[] = $newParticipant['Participant']['id'];
            $newParticipant['Generated']['is_suspected_date_of_death'] = '';
            if (! empty($newParticipant['Participant']['date_of_death'])) {
                $newParticipant['Generated']['is_suspected_date_of_death'] = 'n';
            } elseif (! empty($newParticipant['Participant']['qc_tf_suspected_date_of_death'])) {
                $newParticipant['Participant']['date_of_death'] = $newParticipant['Participant']['qc_tf_suspected_date_of_death'];
                $newParticipant['Participant']['date_of_death_accuracy'] = $newParticipant['Participant']['qc_tf_suspected_date_of_death_accuracy'];
                $newParticipant['Generated']['is_suspected_date_of_death'] = 'y';
            }
            if (! empty($newParticipant['DiagnosisMaster']['primary_id'])) {
                $primaryIds[] = $newParticipant['DiagnosisMaster']['primary_id'];
            }
        }
        $primaryIdsCondition = empty($primaryIds) ? '' : 'DiagnosisMaster.primary_id IN (' . implode($primaryIds, ',') . ')';
        $participantIds = empty($participantIds) ? array('-1') : $participantIds;
            
            // *********** Get Bx/TURP DX & Sent to CHUM & Last One ********
        $biopsyTurpFields = array(
            'type' => '',
            'type_specification' => '',
            'sent_to_chum' => '',
            'gleason_grade' => '',
            'gleason_score' => '',
            'total_positive' => '',
            'type' => '',
            'total_number_taken' => '',
            'greatest_percent_of_cancer' => '',
            'ctnm' => ''
        );
        $biopsyTurpFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
                DiagnosisMaster.primary_id,
                DiagnosisMaster.participant_id,
                TreatmentMaster.start_date,
                TreatmentMaster.start_date_accuracy,
                TreatmentDetail.type,
                TreatmentDetail.type_specification,
                TreatmentDetail.sent_to_chum,
                TreatmentDetail.gleason_grade,
                TreatmentDetail.gleason_score,
                TreatmentDetail.total_positive,
                TreatmentDetail.total_number_taken,
                TreatmentDetail.greatest_percent_of_cancer,
                TreatmentDetail.ctnm
                FROM diagnosis_masters AS DiagnosisMaster
                INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1
                INNER JOIN qc_tf_txd_biopsies_and_turps AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
                WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition
                ORDER BY DiagnosisMaster.participant_id ASC, DiagnosisMaster.primary_id ASC, TreatmentMaster.start_date DESC;";
            $bxTurpDx = $this->Report->tryCatchQuery($sql);
            $tmpNewPrimaryId = '';
            foreach ($bxTurpDx as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                if ($newRes['TreatmentMaster']['start_date']) {
                    if (! isset($biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_last_start_date'])) {
                        $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_last_start_date'] = $this->formatReportDateForDisplay($newRes['TreatmentMaster']['start_date'], $newRes['TreatmentMaster']['start_date_accuracy']);
                        $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_last_start_date_accuracy'] = $newRes['TreatmentMaster']['start_date_accuracy'];
                        foreach ($biopsyTurpFields as $biopsyTurpField => $tmp) {
                            $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_last_' . $biopsyTurpField] = $newRes['TreatmentDetail'][$biopsyTurpField];
                        }
                    }
                    if ($newRes['TreatmentDetail']['type_specification'] == 'Dx') {
                        if (! isset($biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_dx_start_date'])) {
                            $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_dx_start_date'] = $this->formatReportDateForDisplay($newRes['TreatmentMaster']['start_date'], $newRes['TreatmentMaster']['start_date_accuracy']);
                            $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_dx_start_date_accuracy'] = $newRes['TreatmentMaster']['start_date_accuracy'];
                            foreach ($biopsyTurpFields as $biopsyTurpField => $tmp) {
                                $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_dx_' . $biopsyTurpField] = $newRes['TreatmentDetail'][$biopsyTurpField];
                            }
                        } else {
                            die('ERR3878237');
                        }
                    }
                    if ($newRes['TreatmentDetail']['sent_to_chum']) {
                        if (! isset($biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_chum_start_date'])) {
                            $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_chum_start_date'] = $this->formatReportDateForDisplay($newRes['TreatmentMaster']['start_date'], $newRes['TreatmentMaster']['start_date_accuracy']);
                            $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_chum_start_date_accuracy'] = $newRes['TreatmentMaster']['start_date_accuracy'];
                            foreach ($biopsyTurpFields as $biopsyTurpField => $tmp) {
                                $biopsyTurpFromPrimaryId[$studiedPrimaryId]['qc_tf_bx_chum_' . $biopsyTurpField] = $newRes['TreatmentDetail'][$biopsyTurpField];
                            }
                        } else {
                            $warnings[] = __('at least one participant has 2 biopsies or turps defined as sent to chum');
                        }
                    }
                }
            }
        }
        
        // *********** Get Fst Bcr ***********
    
        $fstBcrResultsFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
                DiagnosisMaster.primary_id,
                DiagnosisMaster.participant_id,
                FstBcrDiagnosisMaster.dx_date AS first_bcr_date,
                FstBcrDiagnosisMaster.dx_date_accuracy AS first_bcr_date_accuracy,
                FstBcrDiagnosisDetail.type AS first_bcr_type
                FROM diagnosis_masters AS DiagnosisMaster
                INNER JOIN diagnosis_masters AS FstBcrDiagnosisMaster ON DiagnosisMaster.id = FstBcrDiagnosisMaster.primary_id AND FstBcrDiagnosisMaster.diagnosis_control_id = 22 AND FstBcrDiagnosisMaster.deleted <> 1
                INNER JOIN qc_tf_dxd_recurrence_bio AS FstBcrDiagnosisDetail ON FstBcrDiagnosisDetail.diagnosis_master_id = FstBcrDiagnosisMaster.id AND FstBcrDiagnosisDetail.first_biochemical_recurrence = 1
                WHERE DiagnosisMaster.deleted <> 1 AND $primaryIdsCondition
                ORDER BY DiagnosisMaster.primary_id ASC;";
            $fstBcrResults = $this->Report->tryCatchQuery($sql);
            $tmpNewPrimaryId = '';
            foreach ($fstBcrResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    unset($newRes['DiagnosisMaster']);
                    $newRes['FstBcrDiagnosisMaster']['first_bcr_date'] = $this->formatReportDateForDisplay($newRes['FstBcrDiagnosisMaster']['first_bcr_date'], $newRes['FstBcrDiagnosisMaster']['first_bcr_date_accuracy']);
                    $fstBcrResultsFromPrimaryId[$studiedPrimaryId] = $newRes;
                } else {
                    die('ERR 19938939323');
                }
            }
        }
        
        // *********** Get All PSA ***********
        
        $allPsaFromParticipantId = array();
        $sql = "SELECT DISTINCT
            PsaEventMaster.participant_id,
            PsaEventMaster.event_date AS psa_event_date,
            PsaEventMaster.event_date_accuracy AS psa_event_date_accuracy,
            PsaEventDetail.psa_ng_per_ml
            FROM event_masters AS PsaEventMaster
            INNER JOIN qc_tf_ed_psa AS PsaEventDetail ON PsaEventDetail.event_master_id = PsaEventMaster.id
            WHERE PsaEventMaster.deleted <> 1 AND PsaEventMaster.event_control_id = 52 AND PsaEventMaster.event_date IS NOT NULL
            AND PsaEventMaster.participant_id IN (" . implode(',', $participantIds) . ")
            ORDER BY PsaEventMaster.participant_id ASC, PsaEventMaster.event_date DESC;";
        $allPsaResults = $this->Report->tryCatchQuery($sql);
        foreach ($allPsaResults as $newRes) {
            $studiedParticipantId = $newRes['PsaEventMaster']['participant_id'];
            $allPsaFromParticipantId[$studiedParticipantId][] = array(
                'psa_event_date' => $this->formatReportDateForDisplay($newRes['PsaEventMaster']['psa_event_date'], $newRes['PsaEventMaster']['psa_event_date_accuracy']),
                'psa_event_date_accuracy' => $newRes['PsaEventMaster']['psa_event_date_accuracy'],
                'psa_ng_per_ml' => $newRes['PsaEventDetail']['psa_ng_per_ml']
            );
        }
        
        // *********** Get All Collection ***********
        
        $allCollectionsFromParticipantId = array();
        $sql = "SELECT DISTINCT
            Collection.participant_id,
            Collection.collection_datetime,
            Collection.collection_datetime_accuracy
            FROM collections AS Collection
            WHERE Collection.deleted <> 1
            AND Collection.participant_id IN (" . implode(',', $participantIds) . ");";
        $allCollections = $this->Report->tryCatchQuery($sql);
        foreach ($allCollections as $newRes) {
            $studiedParticipantId = $newRes['Collection']['participant_id'];
            if(isset($allCollectionsFromParticipantId[$studiedParticipantId])) {
                $warnings[] = __('at least one participant has 2 collections recorded into ATiM');
            } else {
                $allCollectionsFromParticipantId[$studiedParticipantId] = $newRes; 
            }
        }
        
        // *********** Get Metastasis ***********
    
        $metastasisResultsFromPrimaryId = array();
        if ($primaryIdsCondition) {
            $sql = "SELECT DISTINCT
                DiagnosisMaster.primary_id,
                DiagnosisMaster.participant_id,
                DiagnosisMaster.dx_date,
                DiagnosisMaster.dx_date_accuracy,
                DiagnosisDetail.site
                FROM diagnosis_masters AS DiagnosisMaster
                INNER JOIN qc_tf_dxd_metastasis AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
                WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id = 21 AND $primaryIdsCondition
                ORDER BY DiagnosisMaster.dx_date ASC;";
            $metastasisResults = $this->Report->tryCatchQuery($sql);
            $tmpNewPrimaryId = '';
            $isFirstOneSet = false;
            $tmpData = array();
            foreach ($metastasisResults as $newRes) {
                $studiedPrimaryId = $newRes['DiagnosisMaster']['primary_id'];
                if ($tmpNewPrimaryId != $studiedPrimaryId) {
                    $tmpNewPrimaryId = $studiedPrimaryId;
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId] = array(
                        'Metastasis' => array(
                            'first_metastasis_dx_date' => '',
                            'first_metastasis_dx_date_accuracy' => '',
                            'qc_tf_first_bone_metastasis_date' => '',
                            'qc_tf_first_bone_metastasis_date_accuracy' => '',
                            'first_metastasis_type' => '',
                            'other_types' => ''
                        )
                    );
                }
                if (empty($metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date']) && ! empty($newRes['DiagnosisMaster']['dx_date'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date'] = $this->formatReportDateForDisplay($newRes['DiagnosisMaster']['dx_date'], $newRes['DiagnosisMaster']['dx_date_accuracy']);
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_dx_date_accuracy'] = $newRes['DiagnosisMaster']['dx_date_accuracy'];
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['first_metastasis_type'] = $newRes['DiagnosisDetail']['site'];
                } elseif (! empty($newRes['DiagnosisDetail']['site'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['other_types'][] = __($newRes['DiagnosisDetail']['site']);
                }
                if ($newRes['DiagnosisDetail']['site'] == 'bone' && empty($metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date']) && ! empty($newRes['DiagnosisMaster']['dx_date'])) {
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date'] = $this->formatReportDateForDisplay($newRes['DiagnosisMaster']['dx_date'], $newRes['DiagnosisMaster']['dx_date_accuracy']);
                    $metastasisResultsFromPrimaryId[$studiedPrimaryId]['Metastasis']['qc_tf_first_bone_metastasis_date_accuracy'] = $newRes['DiagnosisMaster']['dx_date_accuracy'];
                }
            }
        }
    
        // *********** Get Trt ***********
    
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $tmp = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'radiotherapy types'
        ));
        $radiotherapyTypes = array_merge($tmp['defined'], $tmp['previously_defined']);
        
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $tmp = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'Hormonotherapy Types'
        ));
        $hormonotherapyTypes = array_merge($tmp['defined'], $tmp['previously_defined']);
        
        $treatmentsSummaryTemplate = array(
            'Generated' => array(
                'qc_tf_chemo_flag' => 'n',
                'qc_tf_chemo_first_date' => '',
                'qc_tf_radiation_flag' => 'n',
                'qc_tf_radiation_details' => '',
                'qc_tf_radiation_first_date' => '',
                'qc_tf_hormono_flag' => 'n',
                'qc_tf_hormono_details' => '',
                'qc_tf_hormono_first_date' => ''
            )
        );
        $sql = "SELECT distinct TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentMaster.participant_id, TreatmentControl.tx_method, RadiationDetails.qc_tf_type, HormonoDetails.type
			FROM treatment_masters TreatmentMaster
			INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			LEFT JOIN txd_radiations RadiationDetails ON RadiationDetails.treatment_master_id =  TreatmentMaster.id
            LEFT JOIN qc_tf_txd_hormonotherapies HormonoDetails ON HormonoDetails.treatment_master_id =  TreatmentMaster.id
			WHERE TreatmentMaster.deleted <> 1
			AND TreatmentControl.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
			AND TreatmentMaster.participant_id IN (" . implode(',', $participantIds) . ")
			ORDER BY TreatmentMaster.start_date ASC";
        $treatmentResults = $this->Report->tryCatchQuery($sql);
        $treatmentsSummary = array();
        foreach ($treatmentResults as $newTrt) {
            $participantId = $newTrt['TreatmentMaster']['participant_id'];
            if (! isset($treatmentsSummary[$participantId]))
                $treatmentsSummary[$participantId] = $treatmentsSummaryTemplate;
            switch ($newTrt['TreatmentControl']['tx_method']) {
                case 'hormonotherapy':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_flag'] = 'y';
                    if ($newTrt['HormonoDetails']['type']) {
                        $hormonoType = isset($hormonotherapyTypes[$newTrt['HormonoDetails']['type']]) ? $hormonotherapyTypes[$newTrt['HormonoDetails']['type']] : $newTrt['HormonoDetails']['type'];
                        if (! preg_match("/$hormonoType/", $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details'])) {
                            $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details'] .= (empty($treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_details']) ? '' : ', ') . $hormonoType;
                        }
                    }
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_hormono_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
                case 'radiation':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_flag'] = 'y';
                    if ($newTrt['RadiationDetails']['qc_tf_type']) {
                        $radiationType = isset($radiotherapyTypes[$newTrt['RadiationDetails']['qc_tf_type']]) ? $radiotherapyTypes[$newTrt['RadiationDetails']['qc_tf_type']] : $newTrt['RadiationDetails']['qc_tf_type'];
                        if (! preg_match("/$radiationType/", $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details'])) {
                            $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details'] .= (empty($treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_details']) ? '' : ', ') . $radiationType;
                        }
                    }
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_radiation_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
                case 'chemotherapy':
                    $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_flag'] = 'y';
                    if (strlen($newTrt['TreatmentMaster']['start_date']) && ! $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date']) {
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date'] = $this->formatReportDateForDisplay($newTrt['TreatmentMaster']['start_date'], $newTrt['TreatmentMaster']['start_date_accuracy']);
                        $treatmentsSummary[$participantId]['Generated']['qc_tf_chemo_first_date_accuracy'] = $newTrt['TreatmentMaster']['start_date_accuracy'];
                    }
                    break;
            }
        }
    
        // *********** Merge all data ***********
        
        $metastasisTemplate = array(
            'Metastasis' => array(
                'first_metastasis_dx_date' => '',
                'first_metastasis_dx_date_accuracy' => '',
                'qc_tf_first_bone_metastasis_date' => '',
                'qc_tf_first_bone_metastasis_date_accuracy' => '',
                'first_metastasis_type' => '',
                'other_types' => ''
            )
        );
        $fstBcrTemplate = array(
            'FstBcrDiagnosisMaster' => array(
                'first_bcr_date' => '',
                'first_bcr_date_accuracy' => ''
            ),
            'FstBcrDiagnosisDetail' => array(
                'first_bcr_type' => ''
            )
        );
        $biopsyTurpTemplate = array(
            'Generated' => array_merge(array(
                'start_date' => '',
                'start_date_accuracy' => ''
            ), $biopsyTurpFields)
        );
        foreach ($mainResults as &$newParticipant) {
            $newParticipantId = $newParticipant['Participant']['id'];
            $newPrimaryId = $newParticipant['DiagnosisMaster']['primary_id'];
            // ---- Anonymize data ----
            if (($_SESSION['Auth']['User']['group_id'] != '1') && ($newParticipant['Participant']['qc_tf_bank_id'] != $userBankId)) {
                $newParticipant['Participant']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                $newParticipant['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
            }
            // ---- Collection -----
            if (isset($allCollectionsFromParticipantId[$newParticipantId])) {
                $newParticipant = array_merge_recursive($newParticipant, $allCollectionsFromParticipantId[$newParticipantId]);
            } else {
                $newParticipant['Collection']['collection_datetime'] = '';
            }
            // ---- Get Metastasis ----
            if (isset($metastasisResultsFromPrimaryId[$newPrimaryId])) {
                $otherTypes = $metastasisResultsFromPrimaryId[$newPrimaryId]['Metastasis']['other_types'];
                $metastasisResultsFromPrimaryId[$newPrimaryId]['Metastasis']['other_types'] = (empty($otherTypes) || ! is_array($otherTypes)) ? '' : implode($otherTypes, ' | ');
                $newParticipant = array_merge_recursive($newParticipant, $metastasisResultsFromPrimaryId[$newPrimaryId]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $metastasisTemplate);
            }
            // ---- Get Fst Bcr ----
            if (isset($fstBcrResultsFromPrimaryId[$newPrimaryId])) {
                $newParticipant = array_merge_recursive($newParticipant, $fstBcrResultsFromPrimaryId[$newPrimaryId]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $fstBcrTemplate);
            }
            // ---- Get Trt ----
            if (isset($treatmentsSummary[$newParticipantId])) {
                $newParticipant = array_merge_recursive($newParticipant, $treatmentsSummary[$newParticipantId]);
            } else {
                $newParticipant = array_merge_recursive($newParticipant, $treatmentsSummaryTemplate);
            }
            // ---- Get Bx/TURP DX & Sent to CHUM & Last One ----
            foreach (array('qc_tf_bx_last_', 'qc_tf_bx_dx_', 'qc_tf_bx_chum_') as $key_prefix) {
                $bxTurpRecorded = (isset($biopsyTurpFromPrimaryId[$newPrimaryId][$key_prefix . 'start_date']) && $biopsyTurpFromPrimaryId[$newPrimaryId][$key_prefix . 'start_date']) ? true : false;
                foreach ($biopsyTurpTemplate['Generated'] as $fieldWithNoPrefix => $tmp) {
                    $newParticipant['Generated'][$key_prefix . $fieldWithNoPrefix] = $bxTurpRecorded ? $biopsyTurpFromPrimaryId[$newPrimaryId][$key_prefix . $fieldWithNoPrefix] : '';
                }
            }
            // ---- time calculation ----
            $dateDiffDef = array(
                'Participant.qc_tf_last_contact' => 'Generated.qc_tf_rp_to_last_contact',
                'Metastasis.qc_tf_first_bone_metastasis_date' => 'Generated.qc_tf_rp_to_bone_met',
                'FstBcrDiagnosisMaster.first_bcr_date' => 'Generated.qc_tf_rp_to_bcr'
            );
            foreach ($dateDiffDef as $modelFieldData => $modelFieldCalculated) {
                list ($modelData, $fieldData) = explode('.', $modelFieldData);
                list ($modelCalculated, $fieldCalculated) = explode('.', $modelFieldCalculated);
                $newParticipant[$modelCalculated][$fieldCalculated] = $this->getDateDiffInMonths($newParticipant['TreatmentMaster']['start_date'], $newParticipant[$modelData][$fieldData]);
                if ($newParticipant[$modelData][$fieldData . '_accuracy'] . $newParticipant['TreatmentMaster']['start_date_accuracy'] != 'cc' && $newParticipant[$modelData][$fieldData] && $newParticipant['TreatmentMaster']['start_date'])
                    $warnings[] = __('intervals from rp have been calculated with at least one inaccuracy date');
            }
            // ---- PSA completion ----
            $tmpPsa = array(
                'qc_tf_last_psa_ng_per_ml' => '',
                'qc_tf_last_psa' => '',
                'qc_tf_prior_rp_psa_ng_per_ml' => '',
                'qc_tf_prior_rp_psa' => '',
                'qc_tf_after_rp_psa_ng_per_ml' => '',
                'qc_tf_after_rp_psa' => '',
                'qc_tf_prior_bx_dx_psa_ng_per_ml' => '',
                'qc_tf_prior_bx_dx_psa' => '',
                'qc_tf_after_bx_dx_psa_ng_per_ml' => '',
                'qc_tf_after_bx_dx_psa' => '',
                'qc_tf_prior_bx_chum_psa_ng_per_ml' => '',
                'qc_tf_prior_bx_chum_psa' => '',
                'qc_tf_after_bx_chum_psa_ng_per_ml' => '',
                'qc_tf_after_bx_chum_psa' => '',
                'qc_tf_prior_bx_last_psa_ng_per_ml' => '',
                'qc_tf_prior_bx_last_psa' => '',
                'qc_tf_after_bx_last_psa_ng_per_ml' => '',
                'qc_tf_after_bx_last_psa' => '',
                'qc_tf_prior_chemo_psa_ng_per_ml' => '',
                'qc_tf_prior_chemo_psa' => '',
                'qc_tf_prior_radiation_psa_ng_per_ml' => '',
                'qc_tf_prior_radiation_psa' => '',
                'qc_tf_prior_hormono_psa_ng_per_ml' => '',
                'qc_tf_prior_hormono_psa' => '');
            $psaAndEventProperties = array(
                array(
                    array('TreatmentMaster','start_date'),
                    'rp',
                    array('prior', 'after')),
                array(
                    array('Generated','qc_tf_bx_dx_start_date'),
                    'bx_dx',
                    array('prior', 'after')),
                array(
                    array('Generated','qc_tf_bx_chum_start_date'),
                    'bx_chum',
                    array('prior', 'after')),
                array(
                    array('Generated','qc_tf_bx_last_start_date'),
                    'bx_last',
                    array('prior', 'after')),
                array(
                    array('Generated','qc_tf_chemo_first_date'),
                    'chemo',
                    array('prior', null)),
                array(
                    array('Generated','qc_tf_radiation_first_date'),
                    'radiation',
                    array('prior', null)),
                array(
                    array('Generated','qc_tf_hormono_first_date'),
                    'hormono',
                    array('prior', null)));
            $newParticipant['Generated'] = array_merge($newParticipant['Generated'], $tmpPsa);
            if (isset($allPsaFromParticipantId[$newParticipantId])) {
                foreach ($allPsaFromParticipantId[$newParticipantId] as $newPsa) {
                    // Note: PSA dates DESC
                    $psaEventDate = $newPsa['psa_event_date'];
                    $psaEventDateAccuracy = $newPsa['psa_event_date_accuracy'];
                    $psaNgPerMl = $newPsa['psa_ng_per_ml'];
                    if ($psaEventDate) {
                        // Last PSA
                        if (empty($newParticipant['Generated']['qc_tf_last_psa'])) {
                            $newParticipant['Generated']['qc_tf_last_psa_ng_per_ml'] = $psaNgPerMl;
                            $newParticipant['Generated']['qc_tf_last_psa'] = $psaEventDate;
                        }
                        // other data
                        foreach ($psaAndEventProperties as $newPsaAndEventProperty) {
                            list ($eventModelField, $psaKey, $afterPriorFlag) = $newPsaAndEventProperty;
                            $studiedDate = $newParticipant[$eventModelField[0]][$eventModelField[1]];
                            if ($studiedDate) {
                                if($afterPriorFlag[0]) {
                                    // Prior
                                    if (empty($newParticipant['Generated']['qc_tf_prior_' . $psaKey . '_psa']) && $studiedDate >= $psaEventDate) {
                                        $newParticipant['Generated']['qc_tf_prior_' . $psaKey . '_psa_ng_per_ml'] = $psaNgPerMl;
                                        $newParticipant['Generated']['qc_tf_prior_' . $psaKey . '_psa'] = $psaEventDate;
                                    }
                                }
                                if($afterPriorFlag[1]) {
                                    // After
                                    if ($studiedDate <= $psaEventDate) {
                                        $newParticipant['Generated']['qc_tf_after_' . $psaKey . '_psa_ng_per_ml'] = $psaNgPerMl;
                                        $newParticipant['Generated']['qc_tf_after_' . $psaKey . '_psa'] = $psaEventDate;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        foreach ($warnings as $newWarning) {
            AppController::addWarningMsg($newWarning);
        }
        
        $arrayToReturn = array(
            'header' => array(),
            'data' => $mainResults,
            'columns_names' => null,
            'error_msg' => null
        );
    
        return $arrayToReturn;
    }
    
    public function getDateDiffInMonths($startDate, $endDate)
    {
        $months = '';
        if (! empty($startDate) && ! empty($endDate)) {
            $startDateOb = new DateTime($startDate);
            $endDateOb = new DateTime($endDate);
            $interval = $startDateOb->diff($endDateOb);
            if ($interval->invert) {
                $months = 'ERR';
            } else {
                $months = $interval->y * 12 + $interval->m;
            }
        }
        return $months;
    }

    public function formatReportDateForDisplay($date, $accuracy)
    {
        if (preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}(\ [0-9]{2}:[0-9]{2}){0,1}/', $date)) {
            if ($accuracy != 'c') {
                if ($accuracy == 'd') {
                    $date = substr($date, 0, 7);
                } elseif ($accuracy == 'm') {
                    $date = substr($date, 0, 4);
                } elseif ($accuracy == 'y') {
                    $date = '±' . substr($date, 0, 4);
                } elseif ($accuracy == 'h') {
                    $date = substr($date, 0, 10);
                } elseif ($accuracy == 'i') {
                    $date = substr($date, 0, 13);
                }
            }
        }
        return $date;
    }
}