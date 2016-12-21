<?php
class ReportsControllerCustom extends ReportsController {
	
	function buildQbcfSummaryFromBlocks($parameters) {
		return $this->buildQbcfSummary($parameters, 'tma_block');
	}
	
	function buildQbcfSummaryFromAliquots($parameters) {
		return $this->buildQbcfSummary($parameters, 'aliquot');
	}

	function buildQbcfSummary($parameters, $display_option = '') {
		
		$conditions = array();
		$warnings = array();	
		$join_on_storage = 'LEFT JOIN';
		
		if(!isset($parameters['exact_search']) || $parameters['exact_search'] != 'no') {
			$warnings[] = __('only exact search is supported');
		}	
		
		// *********** Get Conditions from parameters *********** 
		
		$user_bank_id = ($_SESSION['Auth']['User']['group_id'] == '1')? 
			'all' :
			(empty($_SESSION['Auth']['User']['Group']['bank_id'])? '-1' : $_SESSION['Auth']['User']['Group']['bank_id']);
			
		$limit_to_bank = false;
		
		if(isset($parameters['Browser'])) {
			
			// 0-REPORT LAUNCHED FROM DATA BROWSER
				
			if(isset($parameters['ViewStorageMaster']['id'])) {
				$conditions[] = "StorageMaster.storage_control_id IN (SELECT id FROM storage_controls WHERE is_tma_block = '1' AND flag_active = '1')";
			 	$join_on_storage = 'INNER JOIN';
				if(($parameters['ViewStorageMaster']['id'] != 'all')) {
					$conditions[] = 'StorageMaster.id IN ('.implode(array_filter($parameters['ViewStorageMaster']['id']), ',').')' ;
				}				
			} else if(isset($parameters['Participant']['id'])) {
				if(($parameters['Participant']['id'] != 'all')) {
					$conditions[] = 'Participant.id IN ('.implode(array_filter($parameters['Participant']['id']), ',').')' ;
				}
			} else if(isset($parameters['ViewAliquot']['aliquot_master_id'])) {
				if(($parameters['ViewAliquot']['aliquot_master_id'] != 'all')) {
					$conditions[] = 'AliquotMaster.id IN ('.implode(array_filter($parameters['ViewAliquot']['aliquot_master_id']), ',').')' ;
				}
			} else {
				die('ERR 9900303');
			}
			
		} else {
			
			// 1-BANKS
			
			$bank_ids = array();
			if(isset($parameters['Participant']['qbcf_bank_id'])) $bank_ids = array_filter($parameters['Participant']['qbcf_bank_id']);
			if(isset($parameters['ViewAliquot']['qbcf_bank_id'])) $bank_ids = array_filter($parameters['ViewAliquot']['qbcf_bank_id']);
			if(!empty($bank_ids)) {
				$conditions[] = 'Participant.qbcf_bank_id IN ('."'".implode(str_replace("'", "''", $bank_ids), "','")."'".')';
				$limit_to_bank = true;
			}
			
			// 2-PARTICIPANT IDENTIFIERS
			
			if(isset($parameters['Participant']['participant_identifier_start'])) {
				if(strlen($parameters['Participant']['participant_identifier_start'])) {
					$conditions[] = 'Participant.participant_identifier >= '."'".str_replace("'", "''", $parameters['Participant']['participant_identifier_start'])."'";
				}
				if(strlen($parameters['Participant']['participant_identifier_end'])) {
					$conditions[] = 'Participant.participant_identifier <= '."'".str_replace("'", "''", $parameters['Participant']['participant_identifier_end'])."'";
				}
			} else if(isset($parameters['Participant']['participant_identifier'])) {
				$participant_identifiers = array_filter($parameters['Participant']['participant_identifier']);
				if($participant_identifiers) $conditions[] = 'Participant.participant_identifier IN ('."'".implode(str_replace("'", "''", $participant_identifiers), "','")."'".')';
			}
			
			if(isset($parameters['Participant']['qbcf_bank_participant_identifier'])) {
				$participant_identifiers = array_filter($parameters['Participant']['qbcf_bank_participant_identifier']);
				if($participant_identifiers) {
					$conditions[] = 'Participant.qbcf_bank_participant_identifier IN ('."'".implode(str_replace("'", "''", $participant_identifiers), "','")."'".')';
					$limit_to_bank = true;
				}
			}
			
			// 3- ALIQUOTS
			
			if(isset($parameters['ViewAliquot']['barcode_start'])) {
				if(strlen($parameters['ViewAliquot']['barcode_start'])) {
					$conditions[] = 'AliquotMaster.barcode >= '."'".str_replace("'", "''", $parameters['ViewAliquot']['barcode_start'])."'";
				}
				if(strlen($parameters['ViewAliquot']['barcode_end'])) {
					$conditions[] = 'AliquotMaster.barcode <= '."'".str_replace("'", "''", $parameters['ViewAliquot']['barcode_end'])."'";
				}
			} else if(isset($parameters['ViewAliquot']['barcode'])) {
				$barcodes = array_filter($parameters['ViewAliquot']['barcode']);
				if($barcodes) $conditions[] = 'AliquotMaster.barcode IN ('."'".implode(str_replace("'", "''", $barcodes), "','")."'".')';
			}
			
			if(isset($parameters['ViewAliquot']['qbcf_pathology_id'])) {
				$qbcf_pathology_ids = array_filter($parameters['ViewAliquot']['qbcf_pathology_id']);
				if($qbcf_pathology_ids) {
					$conditions[] = 'Collection.qbcf_pathology_id IN ('."'".implode(str_replace("'", "''", $qbcf_pathology_ids), "','")."'".')';
					$limit_to_bank = true;
				}
			}

			if(isset($parameters['ViewAliquot']['aliquot_label'])) {
				$aliquot_labels = array_filter($parameters['ViewAliquot']['aliquot_label']);
				if($aliquot_labels) {
					$conditions[] = 'AliquotMaster.aliquot_label IN ('."'".implode(str_replace("'", "''", $aliquot_labels), "','")."'".')';
					$limit_to_bank = true;
				}
			}
			
			if(isset($parameters['ViewAliquot']['selection_label'])) {
				$selection_labels = array_filter($parameters['ViewAliquot']['selection_label']);
				if($selection_labels) $conditions[] = 'StorageMaster.selection_label IN ('."'".implode(str_replace("'", "''", $selection_labels), "','")."'".')';
				$join_on_storage = 'INNER JOIN';
			}
			
			// 2-STORAGE
			
			if(isset($parameters['TmaBlock'])) {
				$conditions[] = "StorageMaster.storage_control_id IN (SELECT id FROM storage_controls WHERE is_tma_block = '1' AND flag_active = '1')";
				$join_on_storage = 'INNER JOIN';
				foreach($parameters['TmaBlock'] as $field => $new_field_criteria) {
					$tmp_criteria = array_filter($new_field_criteria);
					if($tmp_criteria) $conditions[] = 'StorageMaster.$field IN ('."'".implode(str_replace("'", "''", $tmp_criteria), "','")."'".')';
				}
			}
			
		}
	
		$conditions_str = empty($conditions)? 'TRUE' : implode($conditions, ' AND ');
		
		if($limit_to_bank && $user_bank_id != 'all') {
			$conditions[] = "Participant.qbcf_bank_id = '$user_bank_id'";
			$warnings[] = _('your search will be limited to your bank');
		}
		
		// *********** Get Control Data & all ***********
		
		$tx_controls = array();
		$query = "SELECT id, tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1";
		foreach($this->Report->tryCatchQuery($query) as $new_ctr) {
			$tx_controls[$new_ctr['treatment_controls']['tx_method']] = $new_ctr['treatment_controls'];
		}
		
		$this->StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true); 
		$other_dx_progression_sites = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('DX : Progressions Sites'));
		$other_dx_progression_sites = array_merge($other_dx_progression_sites['defined'], $other_dx_progression_sites['previously_defined']);
		
		$other_dx_treatments = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Tx : Other Cancer Treatment'));
		$other_dx_treatments = array_merge($other_dx_treatments['defined'], $other_dx_treatments['previously_defined']);
		
		$this->StructureValueDomain = new StructureValueDomain();
		$ctrnet_submission_disease_site = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'ctrnet_submission_disease_site'), 'recursive' => 2));
		$ctrnet_submission_disease_site_values = array();
		if($ctrnet_submission_disease_site) {
			foreach($ctrnet_submission_disease_site['StructurePermissibleValue'] as $new_value) {
				$ctrnet_submission_disease_site_values[$new_value['value']] = __($new_value['language_alias']);
			}
		}		
		
		$dx_controls = array();
		$query = "SELECT id, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1";
		foreach($this->Report->tryCatchQuery($query) as $new_dx) {
			$dx_controls[$new_dx['diagnosis_controls']['controls_type']] = $new_dx['diagnosis_controls'];
		}
		
		// *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********

		$sql =
			"SELECT DISTINCT
				Participant.id,
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
				Participant.qbcf_menopause,
				
				TreatmentMaster.id,
				TreatmentMaster.diagnosis_master_id,
				TreatmentMaster.start_date,
				TreatmentMaster.start_date_accuracy,
				TreatmentDetail.age_at_dx,
				TreatmentDetail.type_of_intervention,
				TreatmentDetail.laterality,
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
				TreatmentDetail.time_to_next_breast_dx_event_months				
				
				FROM participants AS Participant
				INNER JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = ".$tx_controls['breast diagnostic event']['id']." AND TreatmentMaster.deleted <> 1
				INNER JOIN ".$tx_controls['breast diagnostic event']['detail_tablename']." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				INNER JOIN collections AS Collection ON Collection.participant_id = Participant.id AND Collection.treatment_master_id = TreatmentMaster.id AND Collection.deleted <> 1
				INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
				$join_on_storage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
				
				WHERE Participant.deleted <> 1 AND ($conditions_str)
				ORDER BY Participant.qbcf_bank_id ASC, Participant.qbcf_bank_participant_identifier ASC, StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC;";
		
		$main_results = $this->Report->tryCatchQuery($sql);
		foreach($main_results as &$new_participant) {
			// ** 1 ** Set confidential data
			
			$confidential_record  = ($user_bank_id != 'all' && $new_participant['Participant']['qbcf_bank_id'] != $user_bank_id)? true : false;
			if($confidential_record) {
				$new_participant['Participant']['qbcf_bank_id'] = CONFIDENTIAL_MARKER;
				$new_participant['Participant']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
			}
			
			if($new_participant['TreatmentMaster']['start_date_accuracy'] != 'y') $new_participant['TreatmentMaster']['start_date_accuracy'] = 'm';
			
			// ** 2 ** Pre/Post Breast Diagnosis Event
			
			$new_participant['GeneratedQbcfPreBrDxEv'] = array(
				'event_to_collection_months' => '',
				'type_of_intervention' => '',
				'laterality' => '',
				'clinical_stage_summary' => '',
				'clinical_tstage' => '',
				'clinical_nstage' => '',
				'clinical_mstage' => '',
				'morphology' => '',
				'grade_notthingham_sbr_ee' => '',
				'er_overall' => '',
				'pr_overall' => '',
				'pr_percent' => '',
				'her2_ihc' => '',
				'her2_fish' => '',
				'her_2_status' => '',
				'tnbc' => '');
			$new_participant['GeneratedQbcfPostBrDxEv'] = array(			
				'collection_to_event_months' => '',
				'type_of_post_breast_dx_event' => '',
				'type_of_post_breast_dx_event_detail' => '',
				'type_of_intervention' => '',
				'laterality' => '',
				'morphology' => '',
				'er_overall' => '',
				'pr_overall' => '',
				'her_2_status' => '');
			if($new_participant['TreatmentMaster']['start_date']) {
				$sql =
					"SELECT DISTINCT
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
						INNER JOIN ".$tx_controls['breast diagnostic event']['detail_tablename']." AS GeneratedQbcfPreBrDxEv ON GeneratedQbcfPreBrDxEv.treatment_master_id = GeneratedQbcfPreBrDxEvMaster.id
						WHERE GeneratedQbcfPreBrDxEvMaster.id != ".$new_participant['TreatmentMaster']['id']."
						AND GeneratedQbcfPreBrDxEvMaster.participant_id = ".$new_participant['Participant']['id']."
						AND GeneratedQbcfPreBrDxEvMaster.treatment_control_id = ".$tx_controls['breast diagnostic event']['id']."
						AND GeneratedQbcfPreBrDxEvMaster.deleted <> 1
						AND GeneratedQbcfPreBrDxEvMaster.start_date <= '".$new_participant['TreatmentMaster']['start_date']."'
						AND GeneratedQbcfPreBrDxEvMaster.start_date IS NOT NULL
						ORDER BY GeneratedQbcfPreBrDxEvMaster.start_date DESC";
				$sub_results = $this->Report->tryCatchQuery($sql);
				if($sub_results) {
					$new_participant['GeneratedQbcfPreBrDxEv'] = array_merge($new_participant['GeneratedQbcfPreBrDxEv'], $sub_results[0]['GeneratedQbcfPreBrDxEv']);
					$new_participant['GeneratedQbcfPreBrDxEv']['event_to_collection_months'] = $this->getDateDiffInMonths($sub_results[0]['GeneratedQbcfPreBrDxEvMaster']['start_date'], $new_participant['TreatmentMaster']['start_date']);
				}
				$sql =
					"SELECT DISTINCT
						GeneratedQbcfPostBrDxEvMaster.start_date,
						GeneratedQbcfPostBrDxEvMaster.start_date_accuracy,
						GeneratedQbcfPostBrDxEv.type_of_intervention,
						GeneratedQbcfPostBrDxEv.laterality,
						GeneratedQbcfPostBrDxEv.morphology,
						GeneratedQbcfPostBrDxEv.er_overall,
						GeneratedQbcfPostBrDxEv.pr_overall,
						GeneratedQbcfPostBrDxEv.her_2_status
						FROM treatment_masters AS GeneratedQbcfPostBrDxEvMaster
						INNER JOIN ".$tx_controls['breast diagnostic event']['detail_tablename']." AS GeneratedQbcfPostBrDxEv ON GeneratedQbcfPostBrDxEv.treatment_master_id = GeneratedQbcfPostBrDxEvMaster.id
						WHERE GeneratedQbcfPostBrDxEvMaster.id != ".$new_participant['TreatmentMaster']['id']."
						AND GeneratedQbcfPostBrDxEvMaster.participant_id = ".$new_participant['Participant']['id']."
						AND GeneratedQbcfPostBrDxEvMaster.treatment_control_id = ".$tx_controls['breast diagnostic event']['id']."
						AND GeneratedQbcfPostBrDxEvMaster.deleted <> 1
						AND GeneratedQbcfPostBrDxEvMaster.start_date >= '".$new_participant['TreatmentMaster']['start_date']."'
						AND GeneratedQbcfPostBrDxEvMaster.start_date IS NOT NULL
						ORDER BY GeneratedQbcfPostBrDxEvMaster.start_date ASC";			
				$sub_results = $this->Report->tryCatchQuery($sql);
				if($sub_results) {
					$new_participant['GeneratedQbcfPostBrDxEv'] = array_merge($new_participant['GeneratedQbcfPostBrDxEv'], $sub_results[0]['GeneratedQbcfPostBrDxEv']);
					$new_participant['GeneratedQbcfPostBrDxEv']['collection_to_event_months'] = $this->getDateDiffInMonths($new_participant['TreatmentMaster']['start_date'], $sub_results[0]['GeneratedQbcfPostBrDxEvMaster']['start_date']);
					$type_of_post_breast_dx_event = __('new diagnosis');
					$type_of_post_breast_dx_event_detail = '';
					if($new_participant['GeneratedQbcfPostBrDxEv']['collection_to_event_months'] <= 60) {
						$diff_on = array();
						foreach(array('laterality' => 'laterality', 'morphology' => 'morphology', 'er_overall' => 'er overall  (from path report)', 'pr_overall' => 'pr overall (in path report)', 'her_2_status' => 'her 2 status') as $field => $language_id) {
							if($new_participant['GeneratedQbcfPreBrDxEv'][$field] != $new_participant['GeneratedQbcfPostBrDxEv'][$field]) {
								$diff_on[] = __($language_id).((!strlen($new_participant['GeneratedQbcfPreBrDxEv'][$field]) || !strlen($new_participant['GeneratedQbcfPostBrDxEv'][$field]))? ' ('.__('one empty value').')' : '');
							}
						}	
						if($diff_on) {
							$type_of_post_breast_dx_event = __('new diagnosis');
							$type_of_post_breast_dx_event_detail = __('differences on').' : '.implode(' + ', $diff_on);
						} else {
							$type_of_post_breast_dx_event = __('progression');
						}
					} else {
						$type_of_post_breast_dx_event_detail = _('> 5 years');
						$type_of_post_breast_dx_event = __('new diagnosis');
					}
					$new_participant['GeneratedQbcfPostBrDxEv']['type_of_post_breast_dx_event'] = $type_of_post_breast_dx_event;
					$new_participant['GeneratedQbcfPostBrDxEv']['type_of_post_breast_dx_event_detail'] = $type_of_post_breast_dx_event_detail;
				}
			} 
				
			// ** 3 ** Treatment
			
			$new_participant['GeneratedQbcfBxTx'] = array(
				'pre_collection_chemotherapy' => '',
				'pre_collection_hormonotherapy' => '',
				'pre_collection_immunotherapy' => '',
				'pre_collection_bone_specific_therapy' => '',
				'pre_collection_other_systemic_treatment' => '',
				'pre_collection_radiotherapy' => '',
				'adjuvant_chemotherapy' => '',
				'adjuvant_hormonotherapy' => '',
				'adjuvant_immunotherapy' => '',
				'adjuvant_bone_specific_therapy' => '',
				'adjuvant_other_systemic_treatment' => '',
				'adjuvant_radiotherapy' => '',
				'adjuvant_chemotherapy_detail' => '',
				'adjuvant_hormonotherapy_detail' => '',
				'adjuvant_immunotherapy_detail' => '',
				'adjuvant_bone_specific_therapy_detail' => '',
				'adjuvant_other_systemic_treatment_detail' => '',
				'adjuvant_radiotherapy_detail' => '',
				'post_collection_chemotherapy' => '',
				'post_collection_hormonotherapy' => '',
				'post_collection_immunotherapy' => '',
				'post_collection_bone_specific_therapy' => '',
				'post_collection_other_systemic_treatment' => '',
				'post_collection_radiotherapy' => '');
			if($new_participant['TreatmentMaster']['start_date']) {
				//Pre
				$control_ids = array(
					$tx_controls['chemotherapy']['id'],
					$tx_controls['hormonotherapy']['id'],
					$tx_controls['immunotherapy']['id'],
					$tx_controls['bone specific therapy']['id'],
					$tx_controls['radiotherapy']['id'],
					$tx_controls['other (breast cancer systemic treatment)']['id']
				);
				$control_ids = implode(',',$control_ids);
				$sql = 
					"SELECT DISTINCT treatment_control_id 
						FROM treatment_masters 
						WHERE deleted <> 1 
						AND participant_id = ".$new_participant['Participant']['id']." 
						AND treatment_control_id IN ($control_ids) 
						AND start_date IS NOT NULL
						AND start_date < '".$new_participant['TreatmentMaster']['start_date']."'";
				foreach($this->Report->tryCatchQuery($sql) as $new_tx) {
					switch($new_tx['treatment_masters']['treatment_control_id']) {
						case ($tx_controls['chemotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_chemotherapy'] = 'y';
							break;
						case ($tx_controls['hormonotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_hormonotherapy'] = 'y';
							break;
						case ($tx_controls['immunotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_immunotherapy'] = 'y';
							break;
						case ($tx_controls['bone specific therapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_bone_specific_therapy'] = 'y';
							break;
						case ($tx_controls['radiotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_radiotherapy'] = 'y';
							break;
						case ($tx_controls['other (breast cancer systemic treatment)']['id']):
							$new_participant['GeneratedQbcfBxTx']['pre_collection_other_systemic_treatment'] = 'y';
							break;
					}
				}
				//Adjuvant
				preg_match('/^([0-9]{4})(\-[0-9]{2}\-[0-9]{2})$/', $new_participant['TreatmentMaster']['start_date'], $matches);
				$end_date = (($matches[1])+1).$matches[2];
				$adjuvant_treatment = array();
				foreach(array('chemotherapy', 'hormonotherapy', 'immunotherapy', 'other (breast cancer systemic treatment)') as $tx_method) {
					$sql = 
						"SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.cycles_completed as completed, GROUP_CONCAT(DISTINCT Drug.generic_name ORDER BY Drug.generic_name DESC SEPARATOR ' + ') AS drug_names
							FROM treatment_masters TreatmentMaster
							INNER JOIN ".$tx_controls[$tx_method]['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
							LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
							LEFT JOIN drugs Drug ON Drug.id = TreatmentExtendMaster.drug_id
							WHERE TreatmentMaster.deleted <> 1
							AND TreatmentMaster.treatment_control_id = ".$tx_controls[$tx_method]['id']."
							AND TreatmentMaster.participant_id = ".$new_participant['Participant']['id']." 
							AND TreatmentMaster.start_date IS NOT NULL
							AND TreatmentMaster.start_date >= '".$new_participant['TreatmentMaster']['start_date']."'
							AND TreatmentMaster.start_date <= '$end_date'
							GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.cycles_completed";
					foreach($this->Report->tryCatchQuery($sql) as $new_tx) {
						$new_tx['tx_method'] = $tx_method;
						$adjuvant_treatment[] = $new_tx;
					}
				}
				$tx_method = 'bone specific therapy';
				$sql =
					"SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, '' AS completed, GROUP_CONCAT(DISTINCT Drug.generic_name ORDER BY Drug.generic_name DESC SEPARATOR ' + ') AS drug_names
						FROM treatment_masters TreatmentMaster
						INNER JOIN ".$tx_controls[$tx_method]['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
						LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
						LEFT JOIN drugs Drug ON Drug.id = TreatmentExtendMaster.drug_id
						WHERE TreatmentMaster.deleted <> 1
						AND TreatmentMaster.treatment_control_id = ".$tx_controls[$tx_method]['id']."
						AND TreatmentMaster.participant_id = ".$new_participant['Participant']['id']."
						AND TreatmentMaster.start_date IS NOT NULL
						AND TreatmentMaster.start_date >= '".$new_participant['TreatmentMaster']['start_date']."'
						AND TreatmentMaster.start_date <= '$end_date'
						GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number";
				foreach($this->Report->tryCatchQuery($sql) as $new_tx) {
					$new_tx['tx_method'] = $tx_method;
					$adjuvant_treatment[] = $new_tx;
				}
				$tx_method = 'radiotherapy';
				$sql =
					"SELECT TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, completed AS completed, '' AS drug_names
						FROM treatment_masters TreatmentMaster
						INNER JOIN ".$tx_controls[$tx_method]['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
						WHERE TreatmentMaster.deleted <> 1
						AND TreatmentMaster.treatment_control_id = ".$tx_controls[$tx_method]['id']."
						AND TreatmentMaster.participant_id = ".$new_participant['Participant']['id']."
						AND TreatmentMaster.start_date IS NOT NULL
						AND TreatmentMaster.start_date >= '".$new_participant['TreatmentMaster']['start_date']."'
						AND TreatmentMaster.start_date <= '$end_date'
						GROUP BY TreatmentMaster.id, TreatmentMaster.qbcf_clinical_trial_protocol_number, TreatmentDetail.completed";
				foreach($this->Report->tryCatchQuery($sql) as $new_tx) {
					$new_tx['tx_method'] = $tx_method;
					$adjuvant_treatment[] = $new_tx;
				}
				foreach($adjuvant_treatment as $new_tx) {
					$tx_merthod = $new_tx['tx_method'];
					$field_name = str_replace(array('chemotherapy', 'hormonotherapy', 'immunotherapy', 'bone specific therapy', 'radiotherapy', 'other (breast cancer systemic treatment)'),
						array('adjuvant_chemotherapy', 'adjuvant_hormonotherapy', 'adjuvant_immunotherapy', 'adjuvant_bone_specific_therapy', 'adjuvant_radiotherapy', 'adjuvant_other_systemic_treatment'),
						$tx_merthod);
					$new_participant['GeneratedQbcfBxTx'][$field_name] = 'y';
					$tx_detail = array(
						str_replace(array('yes', 'no', 'unknown'), array(__('completed'), __('not completed'), ''), $new_tx['TreatmentDetail']['completed']),
						$new_tx['TreatmentMaster']['qbcf_clinical_trial_protocol_number'],
						($new_tx['0']['drug_names']? '('.$new_tx['0']['drug_names'].')' : ''));
					if(!$tx_detail) $tx_detail = __('completion unknown');
					$tx_detail = array_filter($tx_detail);
					if($tx_detail) {
						$new_participant['GeneratedQbcfBxTx'][$field_name.'_detail'] .= __($tx_merthod).' ['.implode(' ', $tx_detail).'] ';
					}
					}
				// Post
				$sql =
					"SELECT DISTINCT treatment_control_id
						FROM treatment_masters
						WHERE deleted <> 1
						AND participant_id = ".$new_participant['Participant']['id']."
						AND treatment_control_id IN ($control_ids)
						AND start_date IS NOT NULL
						AND start_date >= '$end_date'";
				foreach($this->Report->tryCatchQuery($sql) as $new_tx) {
					switch($new_tx['treatment_masters']['treatment_control_id']) {
						case ($tx_controls['chemotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_chemotherapy'] = 'y';
							break;
						case ($tx_controls['hormonotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_hormonotherapy'] = 'y';
							break;
						case ($tx_controls['immunotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_immunotherapy'] = 'y';
							break;
						case ($tx_controls['bone specific therapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_bone_specific_therapy'] = 'y';
							break;
						case ($tx_controls['radiotherapy']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_radiotherapy'] = 'y';
							break;
						case ($tx_controls['other (breast cancer systemic treatment)']['id']):
							$new_participant['GeneratedQbcfBxTx']['post_collection_other_systemic_treatment'] = 'y';
							break;
					}
				}
			}		
				
			// ** 4 ** Breast Progression
			
			$new_participant['GeneratedQbcfBrDxProg'] = array(
				'first_progression' => '',
				'collection_to_first_progression_months' => '',
				'other_progressions' => array());
			if($new_participant['TreatmentMaster']['start_date']) {
				$sql =
					"SELECT DiagnosisMaster.dx_date, DiagnosisDetail.site
						FROM diagnosis_masters DiagnosisMaster
						INNER JOIN ".$dx_controls['breast progression']['detail_tablename']." DiagnosisDetail ON DiagnosisMaster.id = DiagnosisDetail.diagnosis_master_id
						WHERE DiagnosisMaster.deleted <> 1
						AND  DiagnosisMaster.diagnosis_control_id = ".$dx_controls['breast progression']['id']."
						AND DiagnosisMaster.parent_id = ".$new_participant['TreatmentMaster']['diagnosis_master_id']."
						AND DiagnosisMaster.dx_date IS NOT NULL
						AND DiagnosisMaster.dx_date > '".$new_participant['TreatmentMaster']['start_date']."' ORDER BY DiagnosisMaster.dx_date ASC";
				foreach($this->Report->tryCatchQuery($sql) as $new_prog) {
					if(empty($new_participant['GeneratedQbcfBrDxProg']['first_progression'])) {
						$new_participant['GeneratedQbcfBrDxProg']['first_progression'] = $new_prog['DiagnosisDetail']['site'];
						$new_participant['GeneratedQbcfBrDxProg']['collection_to_first_progression_months'] = $this->getDateDiffInMonths($new_participant['TreatmentMaster']['start_date'], $new_prog['DiagnosisMaster']['dx_date']);
					} else {
						$new_participant['GeneratedQbcfBrDxProg']['other_progressions'][$other_dx_progression_sites[$new_prog['DiagnosisDetail']['site']]] = $other_dx_progression_sites[$new_prog['DiagnosisDetail']['site']];
					}
				}
			}
			$new_participant['GeneratedQbcfBrDxProg']['other_progressions'] = implode(' & ', $new_participant['GeneratedQbcfBrDxProg']['other_progressions']);
			
			// ** 5 ** Other Tumors
			
			$sql =
				"SELECT DISTINCT DiagnosisDetail.disease_site
					FROM diagnosis_masters DiagnosisMaster
					INNER JOIN ".$dx_controls['other cancer']['detail_tablename']." AS DiagnosisDetail ON DiagnosisMaster.id = DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted <> 1
					AND  DiagnosisMaster.diagnosis_control_id = ".$dx_controls['other cancer']['id']."
					AND DiagnosisMaster.participant_id = ".$new_participant['Participant']['id'];
			$other_dx = array();
			foreach($this->Report->tryCatchQuery($sql) as $new_dx) $other_dx[] = $ctrnet_submission_disease_site_values[$new_dx['DiagnosisDetail']['disease_site']];
			$new_participant['GeneratedQbcfOtherTumor']['other_tumor_sites'] = implode (' & ', $other_dx);
			
			$tx_method = 'other cancer';
			$sql =
				"SELECT DISTINCT TreatmentDetail.type
					FROM treatment_masters TreatmentMaster
					INNER JOIN ".$tx_controls[$tx_method]['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
					WHERE TreatmentMaster.deleted <> 1
					AND TreatmentMaster.treatment_control_id = ".$tx_controls[$tx_method]['id']."
					AND TreatmentMaster.participant_id = ".$new_participant['Participant']['id'];
			$other_tx = array();
			foreach($this->Report->tryCatchQuery($sql) as $new_tx) $other_tx[] = $other_dx_treatments[$new_tx['TreatmentDetail']['type']];
			$new_participant['GeneratedQbcfOtherTumor']['other_tumor_treatments'] = implode (' & ', $other_tx);			
		}
		
		foreach($warnings as $new_warning) AppController::addWarningMsg($new_warning);
		
		$array_to_return = array(
			'header' => array(), 
			'data' => $main_results, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}	
	
	function getDateDiffInMonths($start_date, $end_date) {
		$months = '';
		if(!empty($start_date) && !empty($end_date)) {
			$start_date_ob = new DateTime($start_date);
			$end_date_ob = new DateTime($end_date);
			$interval = $start_date_ob->diff($end_date_ob);
			if($interval->invert) {
				$months = 'ERR';
			} else {
				$months = $interval->y*12 + $interval->m;
			}
		}
		return $months;
	}

}