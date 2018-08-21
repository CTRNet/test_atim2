<?php

class ReportsControllerCustom extends ReportsController
{

    public function buildQbcfSummary($parameters)
    {
        $conditions = array();
        $participantConditionsOnly = array();
        $includeTmaCore = false;
        $warnings = array();
        
        if (! isset($parameters['exact_search']) || $parameters['exact_search'] != 'no') {
            $warnings[] = __('only exact search is supported');
        }
        
        // *********** Get Conditions from parameters ***********
        
        $userBankId = ($_SESSION['Auth']['User']['group_id'] == '1') ? 'all' : (empty($_SESSION['Auth']['User']['Group']['bank_id']) ? '-1' : $_SESSION['Auth']['User']['Group']['bank_id']);
        $limitToBank = false;
        
        if (isset($parameters['Browser'])) {
            
            // 0-REPORT LAUNCHED FROM DATA BROWSER
            
            if (isset($parameters['ViewStorageMaster']['id'])) {
                $includeTmaCore = true;
                if (($parameters['ViewStorageMaster']['id'] != 'all')) {
                    $conditions[] = 'StorageMaster.id IN (' . implode(array_filter($parameters['ViewStorageMaster']['id']), ',') . ')';
                }
            } elseif (isset($parameters['TmaBlock']['id'])) {
                $includeTmaCore = true;
                if (($parameters['TmaBlock']['id'] != 'all')) {
                    $conditions[] = 'StorageMaster.id IN (' . implode(array_filter($parameters['TmaBlock']['id']), ',') . ')';
                }
            } elseif (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                    $participantConditionsOnly[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                }
            } elseif (isset($parameters['ViewAliquot']['aliquot_master_id'])) {
                $includeTmaCore = true;
                if (($parameters['ViewAliquot']['aliquot_master_id'] != 'all')) {
                    $conditions[] = 'ViewAliquot.aliquot_master_id IN (' . implode(array_filter($parameters['ViewAliquot']['aliquot_master_id']), ',') . ')';
                }
            } else {
                pr($parameters);
                die('ERR 9900303');
            }
        } else {
            
            // 1-BANKS
            
            $bankIds = array();
            if (isset($parameters['Participant']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['Participant']['qbcf_bank_id']);
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            } elseif (isset($parameters['ViewAliquot']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['ViewAliquot']['qbcf_bank_id']);
                $includeTmaCore = true;
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            // 2-PARTICIPANT IDENTIFIERS
            
            if (isset($parameters['Participant']['participant_identifier_start'])) {
                if (strlen($parameters['Participant']['participant_identifier_start'])) {
                    $conditions[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                }
                if (strlen($parameters['Participant']['participant_identifier_end'])) {
                    $conditions[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                }
            } elseif (isset($parameters['Participant']['participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                }
            }
            
            if (isset($parameters['Participant']['qbcf_bank_participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['qbcf_bank_participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            // 3- ALIQUOTS
            
            if (isset($parameters['ViewAliquot']))
                $includeTmaCore = true;
            
            if (isset($parameters['ViewAliquot']['barcode_start'])) {
                if (strlen($parameters['ViewAliquot']['barcode_start'])) {
                    $conditions[] = 'ViewAliquot.barcode >= ' . "'" . str_replace("'", "''", $parameters['ViewAliquot']['barcode_start']) . "'";
                }
                if (strlen($parameters['ViewAliquot']['barcode_end'])) {
                    $conditions[] = 'ViewAliquot.barcode <= ' . "'" . str_replace("'", "''", $parameters['ViewAliquot']['barcode_end']) . "'";
                }
            } elseif (isset($parameters['ViewAliquot']['barcode'])) {
                $barcodes = array_filter($parameters['ViewAliquot']['barcode']);
                if ($barcodes)
                    $conditions[] = 'ViewAliquot.barcode IN (' . "'" . implode(str_replace("'", "''", $barcodes), "','") . "'" . ')';
            }
            
            if (isset($parameters['ViewAliquot']['qbcf_pathology_id'])) {
                $qbcfPathologyIds = array_filter($parameters['ViewAliquot']['qbcf_pathology_id']);
                if ($qbcfPathologyIds) {
                    $conditions[] = 'Collection.qbcf_pathology_id IN (' . "'" . implode(str_replace("'", "''", $qbcfPathologyIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            if (isset($parameters['ViewAliquot']['aliquot_label'])) {
                $aliquotLabels = array_filter($parameters['ViewAliquot']['aliquot_label']);
                if ($aliquotLabels) {
                    $conditions[] = 'ViewAliquot.aliquot_label IN (' . "'" . implode(str_replace("'", "''", $aliquotLabels), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            if (isset($parameters['ViewAliquot']['selection_label'])) {
                $selectionLabels = array_filter($parameters['ViewAliquot']['selection_label']);
                if ($selectionLabels)
                    $conditions[] = 'StorageMaster.selection_label IN (' . "'" . implode(str_replace("'", "''", $selectionLabels), "','") . "'" . ')';
            }
            
            // 2-STORAGE
            
            if (isset($parameters['TmaBlock'])) {
                $includeTmaCore = true;
                foreach ($parameters['TmaBlock'] as $field => $newFieldCriteria) {
                    $tmpCriteria = array_filter($newFieldCriteria);
                    if ($tmpCriteria)
                        $conditions[] = "StorageMaster.$field IN (" . "'" . implode(str_replace("'", "''", $tmpCriteria), "','") . "'" . ')';
                }
            }
        }
        
        if ($limitToBank && $userBankId != 'all') {
            $conditions[] = "Participant.qbcf_bank_id = $userBankId";
            if ($participantConditionsOnly)
                $participantConditionsOnly[] = "Participant.qbcf_bank_id = $userBankId";
            $warnings[] = __('your search will be limited to your bank');
        }
        
        $conditionsStr = empty($conditions) ? 'TRUE' : implode($conditions, ' AND ');
        
        // *********** Get Control Data & all ***********
        
        $txControls = array();
        $query = "SELECT id, tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1";
        foreach ($this->Report->tryCatchQuery($query) as $newCtr) {
            $txControls[$newCtr['treatment_controls']['tx_method']] = $newCtr['treatment_controls'];
        }
        
        $this->StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $otherDxProgressionSites = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
            'DX : Progressions Sites'
        ));
        $otherDxProgressionSites = array_merge($otherDxProgressionSites['defined'], $otherDxProgressionSites['previously_defined']);
        
        $otherDxTreatments = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
            'Tx : Other Cancer Treatment'
        ));
        $otherDxTreatments = array_merge($otherDxTreatments['defined'], $otherDxTreatments['previously_defined']);
        
        App::uses('StructureValueDomain', 'Model');
        $this->StructureValueDomain = new StructureValueDomain();
        $ctrnetSubmissionDiseaseSite = $this->StructureValueDomain->find('first', array(
            'conditions' => array(
                'StructureValueDomain.domain_name' => 'ctrnet_submission_disease_site'
            ),
            'recursive' => 2
        ));
        $ctrnetSubmissionDiseaseSiteValues = array();
        if ($ctrnetSubmissionDiseaseSite) {
            foreach ($ctrnetSubmissionDiseaseSite['StructurePermissibleValue'] as $newValue) {
                $ctrnetSubmissionDiseaseSiteValues[$newValue['value']] = __($newValue['language_alias']);
            }
        }
        
        $dxControls = array();
        $query = "SELECT id, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1";
        foreach ($this->Report->tryCatchQuery($query) as $newDx) {
            $dxControls[$newDx['diagnosis_controls']['controls_type']] = $newDx['diagnosis_controls'];
        }
        
        $tmaControlIds = array();
        $query = "SELECT id FROM storage_controls WHERE is_tma_block = '1' AND flag_active = '1'";
        foreach ($this->Report->tryCatchQuery($query) as $newTmaCtrl) {
            $tmaControlIds[] = $newTmaCtrl['storage_controls']['id'];
        }
        
        $tissueBlockAliquotControlId = '';
        $query = "SELECT aliquot_controls.id FROM sample_controls INNER JOIN aliquot_controls ON sample_controls.id = sample_control_id WHERE sample_type = 'tissue' AND aliquot_type = 'block' AND aliquot_controls.flag_active = '1'";
        $tissueBlockAliquotControlId = $this->Report->tryCatchQuery($query);
        $tissueBlockAliquotControlId = $tissueBlockAliquotControlId ? $tissueBlockAliquotControlId[0]['aliquot_controls']['id'] : '-1';
        
        // *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********
        
        $sqlParticipantFields = "Participant.id,
			Participant.participant_identifier,
			Participant.qbcf_bank_id,
			Participant.vital_status,
			Participant.qbcf_bank_participant_identifier,
			Participant.qbcf_study_exclusion,
			Participant.qbcf_breast_cancer_fam_hist,
			Participant.qbcf_ovarian_cancer_fam_hist,
			Participant.qbcf_other_cancer_fam_hist,
			Participant.qbcf_breast_cancer_previous_hist,
			Participant.qbcf_gravida,
			Participant.qbcf_gravidaplus_integer_unknown,
			Participant.qbcf_para,
			Participant.qbcf_paraplus_integer_unknown,
			Participant.qbcf_aborta,
			Participant.qbcf_abortaplus_integer_unknown,
			Participant.qbcf_menopause";
        $sqlTreatmentFields = "TreatmentMaster.id,
			TreatmentMaster.diagnosis_master_id,
			TreatmentMaster.start_date,
			TreatmentMaster.start_date_accuracy,
			TreatmentDetail.age_at_dx,
			TreatmentDetail.type_of_intervention,
			TreatmentDetail.laterality,
			TreatmentDetail.clinical_stage_summary,
			TreatmentDetail.clinical_tstage,
			TreatmentDetail.clinical_nstage,
			TreatmentDetail.clinical_mstage,
			TreatmentDetail.path_stage_summary,
			TreatmentDetail.path_tstage,
			TreatmentDetail.path_nstage,
			TreatmentDetail.path_mstage,
			TreatmentDetail.morphology,
			TreatmentDetail.grade_notthingham_sbr_ee,
			TreatmentDetail.tumor_size,
			TreatmentDetail.margin_status,
			TreatmentDetail.number_of_positive_regional_ln,
			TreatmentDetail.number_of_positive_regional_ln_integer_unknown,
			TreatmentDetail.total_number_of_regional_ln_analysed,
			TreatmentDetail.total_number_of_regional_ln_analysed_integer_unknown,
			TreatmentDetail.number_of_positive_regional_ln_category,
			TreatmentDetail.number_of_positive_sentinel_ln,
			TreatmentDetail.number_of_positive_sentinel_ln_integer_unknown,
			TreatmentDetail.total_number_of_sentinel_ln_analysed,
			TreatmentDetail.total_number_of_sentinel_ln_analysed_integer_unknown,
			TreatmentDetail.er_overall,
			TreatmentDetail.pr_overall,
			TreatmentDetail.her2_ihc,
			TreatmentDetail.her2_fish,
			TreatmentDetail.her_2_status,
			TreatmentDetail.tnbc,
			TreatmentDetail.time_to_last_contact_months,
			TreatmentDetail.time_to_first_progression_months,
			TreatmentDetail.time_to_next_breast_dx_event_months";
        $sqlCoreFields = "ViewAliquot.aliquot_master_id,
			ViewAliquot.sample_master_id,
			ViewAliquot.collection_id,
			ViewAliquot.qbcf_pathology_id,
			ViewAliquot.aliquot_type,
			ViewAliquot.barcode,
			ViewAliquot.aliquot_label,
			ViewAliquot.selection_label,
			ViewAliquot.storage_coord_x,
			ViewAliquot.storage_coord_y";
        
        $innerJoinOnStorage = "INNER JOIN storage_masters AS StorageMaster ON ViewAliquot.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1 AND StorageMaster.storage_control_id IN (" . implode(',', ($tmaControlIds ? $tmaControlIds : array(
            '-1'
        ))) . ")";
        
        $sql = "SELECT DISTINCT
				$sqlParticipantFields,
				$sqlTreatmentFields
				" . ($includeTmaCore ? ",$sqlCoreFields" : "") . "
				FROM participants AS Participant
				INNER JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = " . $txControls['breast diagnostic event']['id'] . " AND TreatmentMaster.deleted <> 1
				INNER JOIN " . $txControls['breast diagnostic event']['detail_tablename'] . " AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				INNER JOIN collections AS Collection ON Collection.participant_id = Participant.id AND Collection.treatment_master_id = TreatmentMaster.id AND Collection.deleted <> 1
				" . ($includeTmaCore ? "INNER JOIN view_aliquots AS ViewAliquot ON ViewAliquot.collection_id = Collection.id AND ViewAliquot.aliquot_type = 'core' $innerJoinOnStorage" : "") . " WHERE Participant.deleted <> 1 
				AND ($conditionsStr)
				ORDER BY " . ($includeTmaCore ? "StorageMaster.selection_label ASC, ViewAliquot.storage_coord_x ASC, ViewAliquot.storage_coord_y ASC" : "Participant.qbcf_bank_id ASC, Participant.qbcf_bank_participant_identifier ASC");
        $mainResults = $this->Report->tryCatchQuery($sql);
        
        if ($participantConditionsOnly) {
            // Look for participants matching the participant criteria but not linked to a breast diagnosis event and/or an aliquot
            $mainResultParticipantIds = '-1';
            if ($mainResults) {
                $participantIdQuery = "SELECT DISTINCT Participant.id " . substr($sql, strpos($sql, 'FROM participants AS Participant'), (strpos($sql, 'ORDER BY') - strpos($sql, 'FROM participants AS Participant')));
                $mainResultParticipantIds = $mainResultParticipantIds = array();
                foreach ($this->Report->tryCatchQuery($participantIdQuery) as $tmpRes) {
                    $mainResultParticipantIds[] = $tmpRes['Participant']['id'];
                }
                $mainResultParticipantIds = implode(',', $mainResultParticipantIds);
            }
            $sqlForUnlinked = "SELECT DISTINCT
					$sqlParticipantFields
					FROM participants AS Participant
					WHERE Participant.deleted <> 1 
					AND (" . implode($participantConditionsOnly, ' AND ') . ")
					AND Participant.id NOT IN ($mainResultParticipantIds)
					ORDER BY Participant.qbcf_bank_id ASC, Participant.qbcf_bank_participant_identifier ASC;";
            $resultForUnlinked = $this->Report->tryCatchQuery($sqlForUnlinked);
            if ($resultForUnlinked) {
                $txEmptyArray = array();
                foreach (explode(',', preg_replace("/[\n\r\s\s+]/", "", $sqlTreatmentFields)) as $newField) {
                    list ($model, $field) = explode('.', $newField);
                    $txEmptyArray[$model][$field] = '';
                }
                foreach ($resultForUnlinked as $newParticipant) {
                    $mainResults[] = $newParticipant + $txEmptyArray;
                }
            }
        }
        
        if (sizeof($mainResults) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => __('the report contains too many results - please redefine search criteria') . " [> " . sizeof($mainResults) . " " . __('lines') . ']'
            );
        }
        foreach ($mainResults as &$newParticipant) {
            
            // if($newParticipant['TreatmentMaster']['start_date_accuracy'] != 'y') $newParticipant['TreatmentMaster']['start_date_accuracy'] = 'm';
            $emptyValue = '';
            
            // ** 1 ** Set confidential data
            
            $confidentialRecord = ($userBankId != 'all' && $newParticipant['Participant']['qbcf_bank_id'] != $userBankId) ? true : false;
            if ($confidentialRecord) {
                $newParticipant['Participant']['qbcf_bank_id'] = CONFIDENTIAL_MARKER;
                $newParticipant['Participant']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                if (isset($newParticipant['ViewAliquot'])) {
                    $newParticipant['ViewAliquot']['qbcf_pathology_id'] = CONFIDENTIAL_MARKER;
                    $newParticipant['ViewAliquot']['aliquot_label'] = CONFIDENTIAL_MARKER;
                }
            }
            
            // ** 2 ** Pre/Post Breast Diagnosis Event
            
            $newParticipant['GeneratedQbcfPreBrDxEv'] = array(
                'event_to_collection_months' => $emptyValue,
                'type_of_intervention' => $emptyValue,
                'laterality' => $emptyValue,
                'clinical_stage_summary' => $emptyValue,
                'clinical_tstage' => $emptyValue,
                'clinical_nstage' => $emptyValue,
                'clinical_mstage' => $emptyValue,
                'morphology' => $emptyValue,
                'grade_notthingham_sbr_ee' => $emptyValue,
                'er_overall' => $emptyValue,
                'pr_overall' => $emptyValue,
                'pr_percent' => $emptyValue,
                'her2_ihc' => $emptyValue,
                'her2_fish' => $emptyValue,
                'her_2_status' => $emptyValue,
                'tnbc' => $emptyValue
            );
            $newParticipant['GeneratedQbcfPostBrDxEv'] = array(
                'collection_to_event_months' => $emptyValue,
                'type_of_post_breast_dx_event' => $emptyValue,
                'type_of_post_breast_dx_event_detail' => $emptyValue,
                'type_of_intervention' => $emptyValue,
                'laterality' => $emptyValue,
                'morphology' => $emptyValue,
                'er_overall' => $emptyValue,
                'pr_overall' => $emptyValue,
                'her_2_status' => $emptyValue
            );
            if ($newParticipant['TreatmentMaster']['id'] != 'n/a' && $newParticipant['TreatmentMaster']['start_date']) {
                $sql = "SELECT DISTINCT
						GeneratedQbcfPreBrDxEvMaster.start_date,
						GeneratedQbcfPreBrDxEvMaster.start_date_accuracy,
						GeneratedQbcfPreBrDxEv.type_of_intervention,
						GeneratedQbcfPreBrDxEv.laterality,
						GeneratedQbcfPreBrDxEv.clinical_stage_summary,
						GeneratedQbcfPreBrDxEv.clinical_tstage,
						GeneratedQbcfPreBrDxEv.clinical_nstage,
						GeneratedQbcfPreBrDxEv.clinical_mstage,
						GeneratedQbcfPreBrDxEv.morphology,
						GeneratedQbcfPreBrDxEv.grade_notthingham_sbr_ee,
						GeneratedQbcfPreBrDxEv.er_overall,
						GeneratedQbcfPreBrDxEv.pr_overall,
						GeneratedQbcfPreBrDxEv.pr_percent,
						GeneratedQbcfPreBrDxEv.her2_ihc,
						GeneratedQbcfPreBrDxEv.her2_fish,
						GeneratedQbcfPreBrDxEv.her_2_status,
						GeneratedQbcfPreBrDxEv.tnbc
						FROM treatment_masters AS GeneratedQbcfPreBrDxEvMaster
						INNER JOIN " . $txControls['breast diagnostic event']['detail_tablename'] . " AS GeneratedQbcfPreBrDxEv ON GeneratedQbcfPreBrDxEv.treatment_master_id = GeneratedQbcfPreBrDxEvMaster.id
						WHERE GeneratedQbcfPreBrDxEvMaster.id != " . $newParticipant['TreatmentMaster']['id'] . "
						AND GeneratedQbcfPreBrDxEvMaster.participant_id = " . $newParticipant['Participant']['id'] . "
						AND GeneratedQbcfPreBrDxEvMaster.treatment_control_id = " . $txControls['breast diagnostic event']['id'] . "
						AND GeneratedQbcfPreBrDxEvMaster.deleted <> 1
						AND GeneratedQbcfPreBrDxEvMaster.start_date < '" . $newParticipant['TreatmentMaster']['start_date'] . "'
						AND GeneratedQbcfPreBrDxEvMaster.start_date IS NOT NULL
						AND (GeneratedQbcfPreBrDxEv.type_of_intervention LIKE 'fine needle aspiration%' OR GeneratedQbcfPreBrDxEv.type_of_intervention LIKE 'biopsy%')		
						ORDER BY GeneratedQbcfPreBrDxEvMaster.start_date DESC";
                $subResults = $this->Report->tryCatchQuery($sql);
                if ($subResults) {
                    $newParticipant['GeneratedQbcfPreBrDxEv'] = array_merge($newParticipant['GeneratedQbcfPreBrDxEv'], $subResults[0]['GeneratedQbcfPreBrDxEv']);
                    $newParticipant['GeneratedQbcfPreBrDxEv']['event_to_collection_months'] = $this->getDateDiffInMonths($subResults[0]['GeneratedQbcfPreBrDxEvMaster']['start_date'], $newParticipant['TreatmentMaster']['start_date']);
                }
                $sql = "SELECT DISTINCT
						GeneratedQbcfPostBrDxEvMaster.start_date,
						GeneratedQbcfPostBrDxEvMaster.start_date_accuracy,
						GeneratedQbcfPostBrDxEv.type_of_intervention,
						GeneratedQbcfPostBrDxEv.laterality,
						GeneratedQbcfPostBrDxEv.morphology,
						GeneratedQbcfPostBrDxEv.er_overall,
						GeneratedQbcfPostBrDxEv.pr_overall,
						GeneratedQbcfPostBrDxEv.her_2_status
						FROM treatment_masters AS GeneratedQbcfPostBrDxEvMaster
						INNER JOIN " . $txControls['breast diagnostic event']['detail_tablename'] . " AS GeneratedQbcfPostBrDxEv ON GeneratedQbcfPostBrDxEv.treatment_master_id = GeneratedQbcfPostBrDxEvMaster.id
						WHERE GeneratedQbcfPostBrDxEvMaster.id != " . $newParticipant['TreatmentMaster']['id'] . "
						AND GeneratedQbcfPostBrDxEvMaster.participant_id = " . $newParticipant['Participant']['id'] . "
						AND GeneratedQbcfPostBrDxEvMaster.treatment_control_id = " . $txControls['breast diagnostic event']['id'] . "
						AND GeneratedQbcfPostBrDxEvMaster.deleted <> 1
						AND GeneratedQbcfPostBrDxEvMaster.start_date > '" . $newParticipant['TreatmentMaster']['start_date'] . "'
						AND GeneratedQbcfPostBrDxEvMaster.start_date IS NOT NULL
						ORDER BY GeneratedQbcfPostBrDxEvMaster.start_date ASC";
                $subResults = $this->Report->tryCatchQuery($sql);
                if ($subResults) {
                    $newParticipant['GeneratedQbcfPostBrDxEv'] = array_merge($newParticipant['GeneratedQbcfPostBrDxEv'], $subResults[0]['GeneratedQbcfPostBrDxEv']);
                    $newParticipant['GeneratedQbcfPostBrDxEv']['collection_to_event_months'] = $this->getDateDiffInMonths($newParticipant['TreatmentMaster']['start_date'], $subResults[0]['GeneratedQbcfPostBrDxEvMaster']['start_date']);
                    $typeOfPostBreastDxEvent = __('new diagnosis');
                    $typeOfPostBreastDxEventDetail = '';
                    if ($newParticipant['GeneratedQbcfPostBrDxEv']['collection_to_event_months'] <= 60) {
                        $diffOn = array();
                        foreach (array(
                            'laterality' => 'laterality',
                            'morphology' => 'morphology',
                            'er_overall' => 'er overall  (from path report)',
                            'pr_overall' => 'pr overall (in path report)',
                            'her_2_status' => 'her 2 status'
                        ) as $field => $languageId) {
                            if ($newParticipant['GeneratedQbcfPreBrDxEv'][$field] != $newParticipant['GeneratedQbcfPostBrDxEv'][$field]) {
                                $diffOn[] = __($languageId) . ((! strlen($newParticipant['GeneratedQbcfPreBrDxEv'][$field]) || ! strlen($newParticipant['GeneratedQbcfPostBrDxEv'][$field])) ? ' (' . __('one empty value') . ')' : '');
                            }
                        }
                        if ($diffOn) {
                            $typeOfPostBreastDxEvent = __('new diagnosis');
                            $typeOfPostBreastDxEventDetail = __('differences on') . ' : ' . implode(' + ', $diffOn);
                        } else {
                            $typeOfPostBreastDxEvent = __('progression');
                        }
                    } else {
                        $typeOfPostBreastDxEventDetail = __('> 5 years');
                        $typeOfPostBreastDxEvent = __('new diagnosis');
                    }
                    $newParticipant['GeneratedQbcfPostBrDxEv']['type_of_post_breast_dx_event'] = $typeOfPostBreastDxEvent;
                    $newParticipant['GeneratedQbcfPostBrDxEv']['type_of_post_breast_dx_event_detail'] = $typeOfPostBreastDxEventDetail;
                }
            }
            
            // ** 3 ** Treatment
            
            $newParticipant['GeneratedQbcfBxTx'] = array(
                'pre_collection_chemotherapy' => $emptyValue,
                'pre_collection_hormonotherapy' => $emptyValue,
                'pre_collection_immunotherapy' => $emptyValue,
                'pre_collection_bone_specific_therapy' => $emptyValue,
                'pre_collection_other_systemic_treatment' => $emptyValue,
                'pre_collection_radiotherapy' => $emptyValue,
                'adjuvant_chemotherapy' => $emptyValue,
                'adjuvant_hormonotherapy' => $emptyValue,
                'adjuvant_immunotherapy' => $emptyValue,
                'adjuvant_bone_specific_therapy' => $emptyValue,
                'adjuvant_other_systemic_treatment' => $emptyValue,
                'adjuvant_radiotherapy' => $emptyValue,
                'adjuvant_chemotherapy_detail' => $emptyValue,
                'adjuvant_hormonotherapy_detail' => $emptyValue,
                'adjuvant_immunotherapy_detail' => $emptyValue,
                'adjuvant_bone_specific_therapy_detail' => $emptyValue,
                'adjuvant_other_systemic_treatment_detail' => $emptyValue,
                'adjuvant_radiotherapy_detail' => $emptyValue,
                'post_collection_chemotherapy' => $emptyValue,
                'post_collection_hormonotherapy' => $emptyValue,
                'post_collection_immunotherapy' => $emptyValue,
                'post_collection_bone_specific_therapy' => $emptyValue,
                'post_collection_other_systemic_treatment' => $emptyValue,
                'post_collection_radiotherapy' => $emptyValue
            );
            if ($newParticipant['TreatmentMaster']['id'] != 'n/a' && $newParticipant['TreatmentMaster']['start_date']) {
                // Pre
                $controlIds = array(
                    $txControls['chemotherapy']['id'],
                    $txControls['hormonotherapy']['id'],
                    $txControls['immunotherapy']['id'],
                    $txControls['bone specific therapy']['id'],
                    $txControls['radiotherapy']['id'],
                    $txControls['other (breast cancer systemic treatment)']['id']
                );
                $controlIds = implode(',', $controlIds);
                $sql = "SELECT DISTINCT treatment_control_id 
						FROM treatment_masters 
						WHERE deleted <> 1 
						AND participant_id = " . $newParticipant['Participant']['id'] . " 
						AND treatment_control_id IN ($controlIds) 
						AND start_date IS NOT NULL
						AND start_date < '" . $newParticipant['TreatmentMaster']['start_date'] . "'";
                foreach ($this->Report->tryCatchQuery($sql) as $newTx) {
                    switch ($newTx['treatment_masters']['treatment_control_id']) {
                        case ($txControls['chemotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_chemotherapy'] = 'y';
                            break;
                        case ($txControls['hormonotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_hormonotherapy'] = 'y';
                            break;
                        case ($txControls['immunotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_immunotherapy'] = 'y';
                            break;
                        case ($txControls['bone specific therapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_bone_specific_therapy'] = 'y';
                            break;
                        case ($txControls['radiotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_radiotherapy'] = 'y';
                            break;
                        case ($txControls['other (breast cancer systemic treatment)']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['pre_collection_other_systemic_treatment'] = 'y';
                            break;
                    }
                }
                // Adjuvant
                preg_match('/^([0-9]{4})(\-[0-9]{2}\-[0-9]{2})$/', $newParticipant['TreatmentMaster']['start_date'], $matches);
                $endDate = (($matches[1]) + 1) . $matches[2];
                $adjuvantTreatment = array();
                foreach (array(
                    'chemotherapy',
                    'hormonotherapy',
                    'immunotherapy',
                    'other (breast cancer systemic treatment)'
                ) as $txMethod) {
                    $sql = "SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.cycles_completed as completed, GROUP_CONCAT(DISTINCT Drug.generic_name ORDER BY Drug.generic_name DESC SEPARATOR ' + ') AS drug_names
							FROM treatment_masters TreatmentMaster
							INNER JOIN " . $txControls[$txMethod]['detail_tablename'] . " TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
							LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
							LEFT JOIN drugs Drug ON Drug.id = TreatmentExtendMaster.drug_id
							WHERE TreatmentMaster.deleted <> 1
							AND TreatmentMaster.treatment_control_id = " . $txControls[$txMethod]['id'] . "
							AND TreatmentMaster.participant_id = " . $newParticipant['Participant']['id'] . " 
							AND TreatmentMaster.start_date IS NOT NULL
							AND TreatmentMaster.start_date >= '" . $newParticipant['TreatmentMaster']['start_date'] . "'
							AND TreatmentMaster.start_date <= '$endDate'
							GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.cycles_completed";
                    foreach ($this->Report->tryCatchQuery($sql) as $newTx) {
                        $newTx['tx_method'] = $txMethod;
                        $adjuvantTreatment[] = $newTx;
                    }
                }
                $txMethod = 'bone specific therapy';
                $sql = "SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, '' AS completed, GROUP_CONCAT(DISTINCT Drug.generic_name ORDER BY Drug.generic_name DESC SEPARATOR ' + ') AS drug_names
						FROM treatment_masters TreatmentMaster
						INNER JOIN " . $txControls[$txMethod]['detail_tablename'] . " TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
						LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
						LEFT JOIN drugs Drug ON Drug.id = TreatmentExtendMaster.drug_id
						WHERE TreatmentMaster.deleted <> 1
						AND TreatmentMaster.treatment_control_id = " . $txControls[$txMethod]['id'] . "
						AND TreatmentMaster.participant_id = " . $newParticipant['Participant']['id'] . "
						AND TreatmentMaster.start_date IS NOT NULL
						AND TreatmentMaster.start_date >= '" . $newParticipant['TreatmentMaster']['start_date'] . "'
						AND TreatmentMaster.start_date <= '$endDate'
						GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number";
                foreach ($this->Report->tryCatchQuery($sql) as $newTx) {
                    $newTx['tx_method'] = $txMethod;
                    $newTx['TreatmentDetail']['completed'] = $newTx['0']['completed'];
                    $adjuvantTreatment[] = $newTx;
                }
                $txMethod = 'radiotherapy';
                $sql = "SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, completed AS completed, '' AS drug_names
						FROM treatment_masters TreatmentMaster
						INNER JOIN " . $txControls[$txMethod]['detail_tablename'] . " TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
						WHERE TreatmentMaster.deleted <> 1
						AND TreatmentMaster.treatment_control_id = " . $txControls[$txMethod]['id'] . "
						AND TreatmentMaster.participant_id = " . $newParticipant['Participant']['id'] . "
						AND TreatmentMaster.start_date IS NOT NULL
						AND TreatmentMaster.start_date >= '" . $newParticipant['TreatmentMaster']['start_date'] . "'
						AND TreatmentMaster.start_date <= '$endDate'
						GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.completed";
                foreach ($this->Report->tryCatchQuery($sql) as $newTx) {
                    $newTx['tx_method'] = $txMethod;
                    $adjuvantTreatment[] = $newTx;
                }
                foreach ($adjuvantTreatment as $newTx) {
                    $txMerthod = $newTx['tx_method'];
                    $fieldName = str_replace(array(
                        'chemotherapy',
                        'hormonotherapy',
                        'immunotherapy',
                        'bone specific therapy',
                        'radiotherapy',
                        'other (breast cancer systemic treatment)'
                    ), array(
                        'adjuvant_chemotherapy',
                        'adjuvant_hormonotherapy',
                        'adjuvant_immunotherapy',
                        'adjuvant_bone_specific_therapy',
                        'adjuvant_radiotherapy',
                        'adjuvant_other_systemic_treatment'
                    ), $txMerthod);
                    $newParticipant['GeneratedQbcfBxTx'][$fieldName] = 'y';
                    $txDetail = array(
                        str_replace(array(
                            'unknown',
                            'yes',
                            'no'
                        ), array(
                            '',
                            __('completed'),
                            __('not completed')
                        ), $newTx['TreatmentDetail']['completed']),
                        $newTx['TreatmentMaster']['qbcf_clinical_trial_protocol_number'],
                        ($newTx['0']['drug_names'] ? '(' . $newTx['0']['drug_names'] . ')' : '')
                    );
                    if (! $txDetail)
                        $txDetail = __('completion unknown');
                    $txDetail = array_filter($txDetail);
                    if ($txDetail) {
                        $newParticipant['GeneratedQbcfBxTx'][$fieldName . '_detail'] .= __($txMerthod) . ' [' . implode(' ', $txDetail) . '] ';
                    }
                }
                // Post
                $sql = "SELECT DISTINCT treatment_control_id
						FROM treatment_masters
						WHERE deleted <> 1
						AND participant_id = " . $newParticipant['Participant']['id'] . "
						AND treatment_control_id IN ($controlIds)
						AND start_date IS NOT NULL
						AND start_date >= '$endDate'";
                foreach ($this->Report->tryCatchQuery($sql) as $newTx) {
                    switch ($newTx['treatment_masters']['treatment_control_id']) {
                        case ($txControls['chemotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_chemotherapy'] = 'y';
                            break;
                        case ($txControls['hormonotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_hormonotherapy'] = 'y';
                            break;
                        case ($txControls['immunotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_immunotherapy'] = 'y';
                            break;
                        case ($txControls['bone specific therapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_bone_specific_therapy'] = 'y';
                            break;
                        case ($txControls['radiotherapy']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_radiotherapy'] = 'y';
                            break;
                        case ($txControls['other (breast cancer systemic treatment)']['id']):
                            $newParticipant['GeneratedQbcfBxTx']['post_collection_other_systemic_treatment'] = 'y';
                            break;
                    }
                }
            }
            
            // ** 4 ** Breast Progression
            
            $newParticipant['GeneratedQbcfBrDxProg'] = array(
                'first_progression' => $emptyValue,
                'collection_to_first_progression_months' => $emptyValue,
                'other_progressions' => array(
                    $emptyValue
                )
            );
            if ($newParticipant['TreatmentMaster']['id'] != 'n/a' && $newParticipant['TreatmentMaster']['start_date']) {
                $sql = "SELECT DiagnosisMaster.dx_date, DiagnosisDetail.site
						FROM diagnosis_masters DiagnosisMaster
						INNER JOIN " . $dxControls['breast progression']['detail_tablename'] . " DiagnosisDetail ON DiagnosisMaster.id = DiagnosisDetail.diagnosis_master_id
						WHERE DiagnosisMaster.deleted <> 1
						AND  DiagnosisMaster.diagnosis_control_id = " . $dxControls['breast progression']['id'] . "
						AND DiagnosisMaster.parent_id = " . $newParticipant['TreatmentMaster']['diagnosis_master_id'] . "
						AND DiagnosisMaster.dx_date IS NOT NULL
						AND DiagnosisMaster.dx_date > '" . $newParticipant['TreatmentMaster']['start_date'] . "' ORDER BY DiagnosisMaster.dx_date ASC";
                foreach ($this->Report->tryCatchQuery($sql) as $newProg) {
                    if (empty($newParticipant['GeneratedQbcfBrDxProg']['first_progression'])) {
                        $newParticipant['GeneratedQbcfBrDxProg']['first_progression'] = $newProg['DiagnosisDetail']['site'];
                        $newParticipant['GeneratedQbcfBrDxProg']['collection_to_first_progression_months'] = $this->getDateDiffInMonths($newParticipant['TreatmentMaster']['start_date'], $newProg['DiagnosisMaster']['dx_date']);
                    } else {
                        $newParticipant['GeneratedQbcfBrDxProg']['other_progressions'][$otherDxProgressionSites[$newProg['DiagnosisDetail']['site']]] = $otherDxProgressionSites[$newProg['DiagnosisDetail']['site']];
                    }
                }
            }
            $newParticipant['GeneratedQbcfBrDxProg']['other_progressions'] = implode(' & ', $newParticipant['GeneratedQbcfBrDxProg']['other_progressions']);
            
            // ** 5 ** Other Tumors
            
            $sql = "SELECT DISTINCT DiagnosisDetail.disease_site
					FROM diagnosis_masters DiagnosisMaster
					INNER JOIN " . $dxControls['other cancer']['detail_tablename'] . " AS DiagnosisDetail ON DiagnosisMaster.id = DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted <> 1
					AND  DiagnosisMaster.diagnosis_control_id = " . $dxControls['other cancer']['id'] . "
					AND DiagnosisMaster.participant_id = " . $newParticipant['Participant']['id'];
            $otherDx = array();
            foreach ($this->Report->tryCatchQuery($sql) as $newDx)
                $otherDx[] = $ctrnetSubmissionDiseaseSiteValues[$newDx['DiagnosisDetail']['disease_site']];
            $newParticipant['GeneratedQbcfOtherTumor']['other_tumor_sites'] = implode(' & ', $otherDx);
            
            $txMethod = 'other cancer';
            $sql = "SELECT DISTINCT TreatmentDetail.type
					FROM treatment_masters TreatmentMaster
					INNER JOIN " . $txControls[$txMethod]['detail_tablename'] . " TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
					WHERE TreatmentMaster.deleted <> 1
					AND TreatmentMaster.treatment_control_id = " . $txControls[$txMethod]['id'] . "
					AND TreatmentMaster.participant_id = " . $newParticipant['Participant']['id'];
            $otherTx = array();
            foreach ($this->Report->tryCatchQuery($sql) as $newTx)
                $otherTx[] = $otherDxTreatments[$newTx['TreatmentDetail']['type']];
            $newParticipant['GeneratedQbcfOtherTumor']['other_tumor_treatments'] = implode(' & ', $otherTx);
            
            // ** 6 ** Check if participant blocks are available
            
            $sql = "SELECT count(*) AS nbr_of_blocks
				FROM collections Collection
				INNER JOIN aliquot_masters AS TissueBlockAliquotMaster ON TissueBlockAliquotMaster.collection_id = Collection.id 
				WHERE Collection.participant_id = " . $newParticipant['Participant']['id'] . "
				AND Collection.treatment_master_id = " . ($newParticipant['TreatmentMaster']['id'] ? $newParticipant['TreatmentMaster']['id'] : '-1') . "
				AND TissueBlockAliquotMaster.deleted <> 1 
				AND TissueBlockAliquotMaster.aliquot_control_id = '$tissueBlockAliquotControlId' 
				AND TissueBlockAliquotMaster.in_stock IN ('yes - available', 'yes - not available');";
            $resCount = $this->Report->tryCatchQuery($sql);
            $newParticipant['GeneratedQbcfBrDxEv']['block_available'] = $resCount[0][0]['nbr_of_blocks'] ? 'y' : 'n';
            
            // ** 7 ** Add Core fields plus values equal to n/a when cores are not part of the display
            
            if (! array_key_exists('ViewAliquot', $newParticipant)) {
                $newParticipant['ViewAliquot'] = array(
                    'selection_label' => 'n/a',
                    'storage_coord_x' => 'n/a',
                    'storage_coord_y' => 'n/a'
                );
            }
            
            // ** 8 ** No Biopsy - Replace cTNM by data of Dx Tx
            
            if (! strlen($newParticipant['GeneratedQbcfPreBrDxEv']['type_of_intervention'] . $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_stage_summary'] . $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_tstage'] . $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_nstage'] . $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_mstage'])) {
                $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_stage_summary'] = $newParticipant['TreatmentDetail']['clinical_stage_summary'];
                $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_tstage'] = $newParticipant['TreatmentDetail']['clinical_tstage'];
                $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_nstage'] = $newParticipant['TreatmentDetail']['clinical_nstage'];
                $newParticipant['GeneratedQbcfPreBrDxEv']['clinical_mstage'] = $newParticipant['TreatmentDetail']['clinical_mstage'];
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

    public function buildQbcfCostRecoverySummary($parameters)
    {
        $conditions = array();
        $participantConditionsOnly = array();
        $includeTmaCore = false;
        $warnings = array();
        
        if (! isset($parameters['exact_search']) || $parameters['exact_search'] != 'no') {
            $warnings[] = __('only exact search is supported');
        }
        
        // *********** Get Conditions from parameters ***********
        
        $userBankId = ($_SESSION['Auth']['User']['group_id'] == '1') ? 'all' : (empty($_SESSION['Auth']['User']['Group']['bank_id']) ? '-1' : $_SESSION['Auth']['User']['Group']['bank_id']);
        $limitToBank = false;
        
        if (isset($parameters['Browser'])) {
            
            // 0-REPORT LAUNCHED FROM DATA BROWSER
            
            if (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                    $participantConditionsOnly[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                }
            } else {
                pr($parameters);
                die('ERR 9900303');
            }
        } else {
            
            // 1-BANKS
            
            $bankIds = array();
            if (isset($parameters['Participant']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['Participant']['qbcf_bank_id']);
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            } elseif (isset($parameters['ViewAliquot']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['ViewAliquot']['qbcf_bank_id']);
                $includeTmaCore = true;
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            // 2-PARTICIPANT IDENTIFIERS
            
            if (isset($parameters['Participant']['participant_identifier_start'])) {
                if (strlen($parameters['Participant']['participant_identifier_start'])) {
                    $conditions[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                }
                if (strlen($parameters['Participant']['participant_identifier_end'])) {
                    $conditions[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                }
            } elseif (isset($parameters['Participant']['participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                }
            }
            
            if (isset($parameters['Participant']['qbcf_bank_participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['qbcf_bank_participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
        }
        
        if ($limitToBank && $userBankId != 'all') {
            $conditions[] = "Participant.qbcf_bank_id = $userBankId";
            if ($participantConditionsOnly)
                $participantConditionsOnly[] = "Participant.qbcf_bank_id = $userBankId";
            $warnings[] = __('your search will be limited to your bank');
        }
        
        $conditionsStr = empty($conditions) ? 'TRUE' : implode($conditions, ' AND ');
        
        // *********** Get Control Data & all ***********
        
        $txControls = array();
        $query = "SELECT id, tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1";
        foreach ($this->Report->tryCatchQuery($query) as $newCtr) {
            $txControls[$newCtr['treatment_controls']['tx_method']] = $newCtr['treatment_controls'];
        }
        
        $tissueAliquotControlIds = array();
        $query = "SELECT AliquotControl.id, aliquot_type, AliquotControl.sample_control_id
    	    FROM sample_controls SampleControl INNER JOIN aliquot_controls AliquotControl ON AliquotControl.sample_control_id = SampleControl.id
    	    WHERE AliquotControl.flag_active = 1
    	    AND SampleControl.sample_type = 'tissue'
	        AND AliquotControl.aliquot_type IN ('block', 'slide');";
        foreach ($this->Report->tryCatchQuery($query) as $newCtr) {
            $tissueAliquotControlIds[$newCtr['AliquotControl']['aliquot_type']] = $newCtr['AliquotControl']['id'];
        }
        
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $aliquotReviewWarnings = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'Tissue Review Warnings'
        ));
        $aliquotReviewWarnings = array_merge($aliquotReviewWarnings['defined'], $aliquotReviewWarnings['previously_defined']);
        
        // *********** Get Participants Count Matching Criteria ***********
        
        $sql = "SELECT COUNT(*) AS Nbr_of_participants
            FROM participants AS Participant
            WHERE Participant.deleted <> 1
			AND ($conditionsStr)";
        $nbrOfParticipantsMatchingCriteria = $this->Report->tryCatchQuery($sql);
        $nbrOfParticipantsMatchingCriteria = $nbrOfParticipantsMatchingCriteria[0][0]['Nbr_of_participants'];
        
        // *********** Get Participant Blocks ***********
        
        $blocksDetails = array();
        $participantsBlocksCounter = array();
        $samplesBlocksSlidesReviewsCounter = array();
        $sql = "SELECT DISTINCT
        	    Participant.id,
    			Participant.participant_identifier,
    			Participant.qbcf_bank_id,
    			Participant.vital_status,
    			Participant.qbcf_bank_participant_identifier,
    			Participant.qbcf_study_exclusion,
    	        Participant.qbcf_study_exclusion_reason,
    			IF(IFNULL(TreatmentMaster.id, '') = '', 'n', 'y') AS breast_diagnosis_found,
                AliquotMaster.collection_id,
                AliquotMaster.sample_master_id,
    			AliquotMaster.id,
    			AliquotMaster.barcode,
    			AliquotMaster.aliquot_label,
    			AliquotMaster.in_stock,
    	        AliquotDetail.qbcf_block_selected,
    			AliquotInternalUse.type as aliquot_event
    			FROM participants Participant
    			INNER JOIN collections Collection 
    	           ON Participant.id = Collection.participant_id 
    	           AND Collection.deleted <> 1
    			INNER JOIN aliquot_masters AliquotMaster 
    	           ON Collection.id = AliquotMaster.collection_id 
    	           AND AliquotMaster.deleted <> 1 
    	           AND AliquotMaster.aliquot_control_id = " . $tissueAliquotControlIds['block'] . "
    			INNER JOIN ad_blocks AliquotDetail 
    	           ON AliquotMaster.id = AliquotDetail.aliquot_master_id
    			LEFT JOIN aliquot_internal_uses AliquotInternalUse 
	               ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id 
	               AND AliquotInternalUse.deleted <> 1 
	               AND AliquotInternalUse.type IN ('cost recovery paid', 'returned to bank')
    			LEFT JOIN treatment_masters AS TreatmentMaster 
	               ON Participant.id = TreatmentMaster.participant_id 
	               AND TreatmentMaster.treatment_control_id = " . $txControls['breast diagnostic event']['id'] . " 
	               AND TreatmentMaster.deleted <> 1			
    			WHERE Participant.deleted <> 1
    		    AND ($conditionsStr)";
        foreach ($this->Report->tryCatchQuery($sql) as $newResult) {
            $participantId = $newResult['Participant']['id'];
            $sampleMasterId = $newResult['AliquotMaster']['sample_master_id'];
            $aliquotMasterId = $newResult['AliquotMaster']['id'];
            if (! isset($blocksDetails[$aliquotMasterId])) {
                // Recrod New Block Data
                $blocksDetails[$aliquotMasterId] = array(
                    'Participant' => $newResult['Participant'],
                    'AliquotMaster' => $newResult['AliquotMaster'],
                    'AliquotDetail' => $newResult['AliquotDetail'],
                    'ViewAliquot' => array(
                        'collection_id' => $newResult['AliquotMaster']['collection_id'],
                        'sample_master_id' => $sampleMasterId,
                        'aliquot_master_id' => $aliquotMasterId
                    ),
                    '0' => array(
                        'qbcf_generated_paid_block' => 'n',
                        'qbcf_generated_returned_block' => 'n',
                        
                        'qbcf_generated_breast_diagnosis_found' => $newResult['0']['breast_diagnosis_found'],
                        'qbcf_generated_patient_blocks_number' => '',
                        'qbcf_generated_patient_paid_blocks_number' => '',
                        'qbcf_generated_patient_returned_blocks_number' => '',
                        
                        'qbcf_generated_sample_blocks_number' => '',
                        'qbcf_generated_sample_slide_number' => '',
                        'qbcf_generated_sample_path_reviews_number' => '',
                        'qbcf_generated_sample_path_reviews_warnings_number' => '',
                        'bcf_generated_sample_path_reviews_warnings' => ''
                    )
                );
            }
            // Counter and flag management
            if (! isset($participantsBlocksCounter[$participantId])) {
                $participantsBlocksCounter[$participantId] = array(
                    'qbcf_generated_patient_blocks_number' => array(),
                    'qbcf_generated_patient_paid_blocks_number' => array(),
                    'qbcf_generated_patient_returned_blocks_number' => array()
                );
            }
            $participantsBlocksCounter[$participantId]['qbcf_generated_patient_blocks_number'][$aliquotMasterId] = $aliquotMasterId;
            if (! isset($samplesBlocksSlidesReviewsCounter[$sampleMasterId])) {
                $samplesBlocksSlidesReviewsCounter[$sampleMasterId] = array(
                    'qbcf_generated_sample_blocks_number' => array(),
                    'qbcf_generated_sample_slide_number' => array(),
                    'qbcf_generated_sample_path_reviews_number' => array(),
                    'qbcf_generated_sample_path_reviews_warnings_number' => array(),
                    'bcf_generated_sample_path_reviews_warnings' => array()
                );
            }
            $samplesBlocksSlidesReviewsCounter[$sampleMasterId]['qbcf_generated_sample_blocks_number'][$aliquotMasterId] = $aliquotMasterId;
            if ($newResult['AliquotInternalUse']['aliquot_event'] == 'cost recovery paid') {
                $blocksDetails[$aliquotMasterId]['0']['qbcf_generated_paid_block'] = 'y';
                $participantsBlocksCounter[$participantId]['qbcf_generated_patient_paid_blocks_number'][$aliquotMasterId] = $aliquotMasterId;
            }
            if ($newResult['AliquotInternalUse']['aliquot_event'] == 'returned to bank') {
                $blocksDetails[$aliquotMasterId]['0']['qbcf_generated_returned_block'] = 'y';
                $participantsBlocksCounter[$participantId]['qbcf_generated_patient_returned_blocks_number'][$aliquotMasterId] = $aliquotMasterId;
            }
        }
        // Slide Review
        $sql = "SELECT DISTINCT
                Collection.participant_id,
                AliquotMaster.id,
                AliquotMaster.sample_master_id,
    	        AliquotReviewMaster.id AS aliquot_review_master_id,
    			AliquotReviewDetail.qbcf_warnings
    			FROM aliquot_masters AliquotMaster
    			INNER JOIN collections Collection 
    	           ON Collection.id = AliquotMaster.collection_id 
    	           AND Collection.deleted <> 1
    			LEFT JOIN aliquot_review_masters AliquotReviewMaster 
                    ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id 
                    AND AliquotReviewMaster.deleted <> 1
    			LEFT JOIN qbcf_ar_tissue_blocks AliquotReviewDetail 
                    ON AliquotReviewMaster.id = AliquotReviewDetail.aliquot_review_master_id
    			WHERE AliquotMaster.deleted <> 1 
                AND AliquotMaster.sample_master_id IN (" . implode(',', array_keys(empty($samplesBlocksSlidesReviewsCounter) ? array(
            '-1' => ''
        ) : $samplesBlocksSlidesReviewsCounter)) . ")
                AND AliquotMaster.aliquot_control_id = " . $tissueAliquotControlIds['slide'];
        foreach ($this->Report->tryCatchQuery($sql) as $newResult) {
            $participantId = $newResult['Collection']['participant_id'];
            $sampleMasterId = $newResult['AliquotMaster']['sample_master_id'];
            $aliquotMasterId = $newResult['AliquotMaster']['id'];
            $samplesBlocksSlidesReviewsCounter[$sampleMasterId]['qbcf_generated_sample_slide_number'][$aliquotMasterId] = $aliquotMasterId;
            if ($newResult['AliquotReviewMaster']['aliquot_review_master_id']) {
                $aliquotReviewMasterId = $newResult['AliquotReviewMaster']['aliquot_review_master_id'];
                $samplesBlocksSlidesReviewsCounter[$sampleMasterId]['qbcf_generated_sample_path_reviews_number'][$aliquotReviewMasterId] = $aliquotReviewMasterId;
            }
            if (strlen($newResult['AliquotReviewDetail']['qbcf_warnings'])) {
                $aliquotReviewMasterId = $newResult['AliquotReviewMaster']['aliquot_review_master_id'];
                $qbcfWarnings = $newResult['AliquotReviewDetail']['qbcf_warnings'];
                $samplesBlocksSlidesReviewsCounter[$sampleMasterId]['qbcf_generated_sample_path_reviews_warnings_number'][$aliquotReviewMasterId] = $aliquotReviewMasterId;
                $samplesBlocksSlidesReviewsCounter[$sampleMasterId]['bcf_generated_sample_path_reviews_warnings'][$qbcfWarnings] = isset($aliquotReviewWarnings[$qbcfWarnings]) ? $aliquotReviewWarnings[$qbcfWarnings] : $qbcfWarnings;
                ;
            }
        }
        // Merge Information
        foreach ($blocksDetails as $aliquotMasterId => &$blockData) {
            $participantId = $blockData['Participant']['id'];
            $sampleMasterId = $blockData['AliquotMaster']['sample_master_id'];
            $aliquotMasterId = $blockData['AliquotMaster']['id'];
            foreach ($blockData[0] as $blockDataField => &$blockDataFieldValue) {
                if (array_key_exists($blockDataField, $participantsBlocksCounter[$participantId])) {
                    $blockDataFieldValue = sizeof($participantsBlocksCounter[$participantId][$blockDataField]);
                }
                if (array_key_exists($blockDataField, $samplesBlocksSlidesReviewsCounter[$sampleMasterId])) {
                    $blockDataFieldValue = ($blockDataField == 'bcf_generated_sample_path_reviews_warnings') ? implode(' & ', $samplesBlocksSlidesReviewsCounter[$sampleMasterId][$blockDataField]) : sizeof($samplesBlocksSlidesReviewsCounter[$sampleMasterId][$blockDataField]);
                }
            }
            $confidentialRecord = ($userBankId != 'all' && $blockData['Participant']['qbcf_bank_id'] != $userBankId) ? true : false;
            if ($confidentialRecord) {
                $blockData['Participant']['qbcf_bank_id'] = CONFIDENTIAL_MARKER;
                $blockData['Participant']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
            }
        }
        
        foreach ($warnings as $newWarning)
            AppController::addWarningMsg($newWarning);
        
        $arrayToReturn = array(
            'header' => array(),
            'data' => $blocksDetails,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function buildQbcfBlocksSelectionSummary($parameters)
    {
        $conditions = array();
        $participantConditionsOnly = array();
        $includeTmaCore = false;
        $warnings = array();
        
        if (! isset($parameters['exact_search']) || $parameters['exact_search'] != 'no') {
            $warnings[] = __('only exact search is supported');
        }
        
        // *********** Get Conditions from parameters ***********
        
        $userBankId = ($_SESSION['Auth']['User']['group_id'] == '1') ? 'all' : (empty($_SESSION['Auth']['User']['Group']['bank_id']) ? '-1' : $_SESSION['Auth']['User']['Group']['bank_id']);
        $limitToBank = false;
        
        if (isset($parameters['Browser'])) {
            
            // 0-REPORT LAUNCHED FROM DATA BROWSER
            
            if (isset($parameters['Participant']['id'])) {
                if (($parameters['Participant']['id'] != 'all')) {
                    $conditions[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                    $participantConditionsOnly[] = 'Participant.id IN (' . implode(array_filter($parameters['Participant']['id']), ',') . ')';
                }
            } else {
                pr($parameters);
                die('ERR 9900303');
            }
        } else {
            
            // 1-BANKS
            
            $bankIds = array();
            if (isset($parameters['Participant']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['Participant']['qbcf_bank_id']);
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            } elseif (isset($parameters['ViewAliquot']['qbcf_bank_id'])) {
                $bankIds = array_filter($parameters['ViewAliquot']['qbcf_bank_id']);
                $includeTmaCore = true;
                if ($bankIds) {
                    $conditions[] = 'Participant.qbcf_bank_id IN (' . "'" . implode(str_replace("'", "''", $bankIds), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
            
            // 2-PARTICIPANT IDENTIFIERS
            
            if (isset($parameters['Participant']['participant_identifier_start'])) {
                if (strlen($parameters['Participant']['participant_identifier_start'])) {
                    $conditions[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier >= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_start']) . "'";
                }
                if (strlen($parameters['Participant']['participant_identifier_end'])) {
                    $conditions[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                    $participantConditionsOnly[] = 'Participant.participant_identifier <= ' . "'" . str_replace("'", "''", $parameters['Participant']['participant_identifier_end']) . "'";
                }
            } elseif (isset($parameters['Participant']['participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                }
            }
            
            if (isset($parameters['Participant']['qbcf_bank_participant_identifier'])) {
                $participantIdentifiers = array_filter($parameters['Participant']['qbcf_bank_participant_identifier']);
                if ($participantIdentifiers) {
                    $conditions[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $participantConditionsOnly[] = 'Participant.qbcf_bank_participant_identifier IN (' . "'" . implode(str_replace("'", "''", $participantIdentifiers), "','") . "'" . ')';
                    $limitToBank = true;
                }
            }
        }
        
        if ($limitToBank && $userBankId != 'all') {
            $conditions[] = "Participant.qbcf_bank_id = $userBankId";
            if ($participantConditionsOnly)
                $participantConditionsOnly[] = "Participant.qbcf_bank_id = $userBankId";
            $warnings[] = __('your search will be limited to your bank');
        }
        
        $conditionsStr = empty($conditions) ? 'TRUE' : implode($conditions, ' AND ');
        
        // *********** Get Control Data & all ***********
        
        $txControls = array();
        $query = "SELECT id, tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1";
        foreach ($this->Report->tryCatchQuery($query) as $newCtr) {
            $txControls[$newCtr['treatment_controls']['tx_method']] = $newCtr['treatment_controls'];
        }
        
        $tissueAliquotControlIds = array();
        $query = "SELECT AliquotControl.id, aliquot_type, AliquotControl.sample_control_id
    	    FROM sample_controls SampleControl INNER JOIN aliquot_controls AliquotControl ON AliquotControl.sample_control_id = SampleControl.id
    	    WHERE AliquotControl.flag_active = 1
    	    AND SampleControl.sample_type = 'tissue'
	        AND AliquotControl.aliquot_type IN ('block', 'slide');";
        foreach ($this->Report->tryCatchQuery($query) as $newCtr) {
            $tissueAliquotControlIds[$newCtr['AliquotControl']['aliquot_type']] = $newCtr['AliquotControl']['id'];
        }
        
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $aliquotReviewWarnings = $StructurePermissibleValuesCustom->getCustomDropdown(array(
            'Tissue Review Warnings'
        ));
        $aliquotReviewWarnings = array_merge($aliquotReviewWarnings['defined'], $aliquotReviewWarnings['previously_defined']);
        
        // *********** Get Participants Count Matching Criteria ***********
        
        $sql = "SELECT COUNT(*) AS Nbr_of_participants
	    FROM participants AS Participant
	    WHERE Participant.deleted <> 1
	    AND ($conditionsStr)";
        $nbrOfParticipantsMatchingCriteria = $this->Report->tryCatchQuery($sql);
        $nbrOfParticipantsMatchingCriteria = $nbrOfParticipantsMatchingCriteria[0][0]['Nbr_of_participants'];
        
        // *********** Get Participant Blocks ***********
        
        $blocksDetails = array();
        $participantsBlocksCounter = array();
        $samplesBlocksSlidesReviewsCounter = array();
        $sql = "SELECT DISTINCT
                Participant.id,
                Participant.participant_identifier,
                Participant.qbcf_bank_id,
                Participant.vital_status,
                Participant.qbcf_bank_participant_identifier,
                Participant.qbcf_study_exclusion,
                Participant.qbcf_study_exclusion_reason,
                IF(IFNULL(TreatmentMaster.id, '') = '', 'n', 'y') AS breast_diagnosis_found,
                BlockAliquotMaster.collection_id,
                BlockAliquotMaster.sample_master_id,
                BlockAliquotMaster.id,
                BlockAliquotMaster.barcode,
                BlockAliquotMaster.aliquot_label,
                BlockAliquotMaster.in_stock,
                AliquotDetail.qbcf_block_selected,
                SlideAliquotMaster.barcode,
                SlideAliquotMaster.aliquot_label,
                AliquotReviewDetail.*
                FROM participants Participant
                INNER JOIN collections Collection
                    ON Participant.id = Collection.participant_id
                    AND Collection.deleted <> 1
                INNER JOIN aliquot_masters BlockAliquotMaster
                    ON Collection.id = BlockAliquotMaster.collection_id
                    AND BlockAliquotMaster.deleted <> 1
                    AND BlockAliquotMaster.aliquot_control_id = " . $tissueAliquotControlIds['block'] . "
                INNER JOIN ad_blocks AliquotDetail
                    ON BlockAliquotMaster.id = AliquotDetail.aliquot_master_id
                LEFT JOIN realiquotings Realiquoting
                    ON Realiquoting.parent_aliquot_master_id = BlockAliquotMaster.id
                    AND Realiquoting.deleted <> 1
                LEFT JOIN aliquot_masters SlideAliquotMaster
                    ON Realiquoting.child_aliquot_master_id = SlideAliquotMaster.id
                    AND SlideAliquotMaster.deleted <> 1
                    AND SlideAliquotMaster.aliquot_control_id = " . $tissueAliquotControlIds['slide'] . "
                LEFT JOIN aliquot_review_masters AliquotReviewMaster
                    ON SlideAliquotMaster.id = AliquotReviewMaster.aliquot_master_id
                    AND AliquotReviewMaster.deleted <> 1
                LEFT JOIN qbcf_ar_tissue_blocks AliquotReviewDetail
                    ON AliquotReviewMaster.id = AliquotReviewDetail.aliquot_review_master_id
                LEFT JOIN treatment_masters AS TreatmentMaster
                    ON Participant.id = TreatmentMaster.participant_id
                    AND TreatmentMaster.treatment_control_id = " . $txControls['breast diagnostic event']['id'] . "
                    AND TreatmentMaster.deleted <> 1
                WHERE Participant.deleted <> 1
                AND ($conditionsStr)";
        $blockAliquotMasterIds = array(
            '0'
        );
        foreach ($this->Report->tryCatchQuery($sql) as $newResult) {
            $participantId = $newResult['Participant']['id'];
            $sampleMasterId = $newResult['BlockAliquotMaster']['sample_master_id'];
            $aliquotMasterId = $newResult['BlockAliquotMaster']['id'];
            $blocksDetails[] = array(
                'Participant' => $newResult['Participant'],
                'AliquotMaster' => $newResult['BlockAliquotMaster'],
                'AliquotDetail' => $newResult['AliquotDetail'],
                'AliquotReviewDetail' => $newResult['AliquotReviewDetail'],
                'ViewAliquot' => array(
                    'collection_id' => $newResult['BlockAliquotMaster']['collection_id'],
                    'sample_master_id' => $sampleMasterId,
                    'aliquot_master_id' => $aliquotMasterId
                ),
                '0' => array(
                    'qbcf_generated_paid_block' => 'n',
                    'qbcf_generated_returned_block' => 'n',
                    'slide_barcode' => $newResult['SlideAliquotMaster']['barcode'],
                    'slide_aliquot_label' => $newResult['SlideAliquotMaster']['aliquot_label'],
                    'qbcf_generated_breast_diagnosis_found' => $newResult['0']['breast_diagnosis_found']
                )
            );
            $blockAliquotMasterIds[] = $aliquotMasterId;
        }
        
        $sql = "SELECT DISTINCT AliquotInternalUse.type, AliquotInternalUse.aliquot_master_id
	       FROM aliquot_internal_uses AliquotInternalUse
	       WHERE AliquotInternalUse.aliquot_master_id IN (" . implode(',', $blockAliquotMasterIds) . ")
	       AND AliquotInternalUse.deleted <> 1
	       AND AliquotInternalUse.type IN ('cost recovery paid', 'returned to bank')";
        $resInteranlUse = array(
            'cost recovery paid' => array(),
            'returned to bank' => array()
        );
        foreach ($this->Report->tryCatchQuery($sql) as $newResult2) {
            $resInteranlUse[$newResult2['AliquotInternalUse']['type']][$newResult2['AliquotInternalUse']['aliquot_master_id']] = $newResult2['AliquotInternalUse']['aliquot_master_id'];
        }
        
        // Merge Information
        foreach ($blocksDetails as &$blockData) {
            $participantId = $blockData['Participant']['id'];
            $sampleMasterId = $blockData['AliquotMaster']['sample_master_id'];
            $aliquotMasterId = $blockData['AliquotMaster']['id'];
            if (in_array($aliquotMasterId, $resInteranlUse['returned to bank'])) {
                $blockData['0']['qbcf_generated_returned_block'] = 'y';
            }
            if (in_array($aliquotMasterId, $resInteranlUse['cost recovery paid'])) {
                $blockData['0']['qbcf_generated_paid_block'] = 'y';
            }
            $confidentialRecord = ($userBankId != 'all' && $newBlock['Participant']['qbcf_bank_id'] != $userBankId) ? true : false;
            if ($confidentialRecord) {
                $blockData['Participant']['qbcf_bank_id'] = CONFIDENTIAL_MARKER;
                $blockData['Participant']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
            }
        }
        
        foreach ($warnings as $newWarning)
            AppController::addWarningMsg($newWarning);
        
        $arrayToReturn = array(
            'header' => array(),
            'data' => $blocksDetails,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }
}