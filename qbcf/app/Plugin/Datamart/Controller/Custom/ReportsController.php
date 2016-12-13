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
				$conditions[] = 'Participant.qc_tf_bank_id IN ('."'".implode(str_replace("'", "''", $bank_ids), "','")."'".')';
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
		
		if($limit_to_bank && $_SESSION['Auth']['User']['group_id'] != '1') {
			$user_bank_id = (empty($_SESSION['Auth']['User']['Group']['bank_id'])? '-1' : $_SESSION['Auth']['User']['Group']['bank_id']);
			$conditions[] = "Participant.qc_tf_bank_id = '$user_bank_id'";
			$warnings[] = _('your search will be limited to your bank');
		}
		
pr($parameters);
pr($conditions);
pr($warnings);
		
		// *********** Get Control Data ***********
		
		$tx_controls = array();
		$query = "SELECT id, tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1";
		foreach($this->Report->tryCatchQuery($query) as $new_ctr) {
			$tx_controls[$new_ctr['treatment_controls']['tx_method']] = $new_ctr['treatment_controls'];
		}
		
		pr($new_ctr);
		
	

		exit;
		
		// *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********

		$sql =
		"SELECT DISTINCT
				Participant.id AS participant_id,
				Participant.*
				
				TreatmentMaster.*,
				TreatmentDetail.*
				
				FROM participants AS Participant
				INNER JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = ".$tx_controls['breast diagnostic event']['id']." AND TreatmentMaster.deleted <> 1
				INNER JOIN ".$tx_controls['breast diagnostic event']['detail_tablename']." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				INNER JOIN collections AS Collection ON Collection.participant_id = Participant.id AND Collection.treatment_master_id = TreatmentMaster.id AND Collection.deleted <> 1
				INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
				$join_on_storage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
				
				WHERE Participant.deleted <> 1 AND ($conditions_str)
				ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC, StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC;";
		
		
		/*
		$sql = 
			"SELECT DISTINCT
				Participant.id AS participant_id,
				Participant.*
							
				TreatmentMaster.*,
				TreatmentDetail.*
				
				DiagnosisDetail.hormonorefractory_status,
				DiagnosisDetail.survival_in_months,
				DiagnosisDetail.bcr_in_months".
				
				($display_cores_positions?  ', StorageMaster.selection_label, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, StorageMaster.short_label, StorageMaster.qc_tf_tma_name, StorageMaster.qc_tf_tma_label_site, StorageMaster.qc_tf_bank_id' : ' ').
				
				($display_cores_data? ',AliquotDetail.qc_tf_core_nature_site, AliquotDetail.qc_tf_core_nature_revised, AliquotReviewDetail.revised_nature, AliquotReviewDetail.grade ' : ' ')
				
			."FROM participants AS Participant 

			INNER JOIN collections AS Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
			INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND aliquot_control_id = 33
			$join_on_storage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
							
			LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_cpcbn AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			
			LEFT JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = 6 AND TreatmentMaster.deleted <> 1
			LEFT JOIN txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			
			$join_to_display_cores_data
			
			WHERE Participant.deleted <> 1 AND ($conditions_str)
			
			ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC, StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC;";
		*/
		$main_results = $this->Report->tryCatchQuery($sql);
	
		
		
		/*
		
		
		$primary_ids = array();
		$participant_ids = array();
		$bank_list = null;
		if($display_cores_positions) {
			$BankModel = AppModel::getInstance("Administrate", "Bank", true);
			$bank_list = $BankModel->getBankPermissibleValuesForControls();
		}
		foreach($main_results as &$new_participant) {
			$participant_ids[] = $new_participant['Participant']['id'];
			$new_participant['Generated']['is_suspected_date_of_death'] = '';
			if(!empty($new_participant['Participant']['date_of_death'])) {
				$new_participant['Generated']['is_suspected_date_of_death'] = 'n';
			} else if(!empty($new_participant['Participant']['qc_tf_suspected_date_of_death'])) {
				$new_participant['Participant']['date_of_death'] = $new_participant['Participant']['qc_tf_suspected_date_of_death'];
				$new_participant['Participant']['date_of_death_accuracy'] = $new_participant['Participant']['qc_tf_suspected_date_of_death_accuracy'];
				$new_participant['Generated']['is_suspected_date_of_death'] = 'y';
			}
			if(!empty($new_participant['DiagnosisMaster']['primary_id'])) $primary_ids[] = $new_participant['DiagnosisMaster']['primary_id'];
			$new_participant['Generated']['qc_tf_gleason_grade_rp'] = $new_participant['TreatmentDetail']['qc_tf_gleason_grade'];
			if($display_cores_positions) {
				//Manage tma block confidential information
				$set_to_confidential = ($_SESSION['Auth']['User']['group_id'] != '1' && (!isset($new_participant['StorageMaster']['qc_tf_bank_id']) || $new_participant['StorageMaster']['qc_tf_bank_id'] != $user_bank_id))? true : false;
				if($set_to_confidential) {
					if(isset($new_participant['StorageMaster']['qc_tf_bank_id'])) $new_participant['StorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
					if(isset($new_participant['StorageMaster']['qc_tf_tma_label_site'])) $new_participant['StorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
					if(isset($new_participant['StorageMaster']['qc_tf_tma_name'])) $new_participant['StorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
				}
				//Create the storage information label to display$result['StorageMaster']['qc_tf_generated_label_for_display'] = $result['StorageMaster']['short_label'];
				$qc_tf_generated_label_for_display = $new_participant['StorageMaster']['short_label'];
				if(isset($new_participant['StorageMaster']['qc_tf_tma_name'])) {
					if($_SESSION['Auth']['User']['group_id'] == '1') {
						$qc_tf_generated_label_for_display = $new_participant['StorageMaster']['qc_tf_tma_name'].(isset($new_participant['StorageMaster']['qc_tf_bank_id'])? ' ('.$bank_list[$new_participant['StorageMaster']['qc_tf_bank_id']].')' : '');
					} else if($new_participant['StorageMaster']['qc_tf_bank_id'] == $user_bank_id) {
						$qc_tf_generated_label_for_display = $new_participant['StorageMaster']['qc_tf_tma_label_site'];
					}
				}
				$new_participant['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'] = ($qc_tf_generated_label_for_display == $new_participant['StorageMaster']['short_label'])? '' : '|| '.$qc_tf_generated_label_for_display;	
			}
		}
		$primary_ids_condition = empty($primary_ids)? '' : 'DiagnosisMaster.primary_id IN ('.implode($primary_ids, ',').')';
		$participant_ids = empty($participant_ids)? array('-1') : $participant_ids;

		
		// *********** Get Bx DX, etc ********
		
		$bx_dx_gleason_grades_from_primary_id = array();
		if($primary_ids_condition) {
			$TreatmentMasterModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
			$sql =
				"SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					TreatmentDetail.gleason_grade
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1
				INNER JOIN qc_tf_txd_biopsies_and_turps AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentDetail.type IN ('".implode("','", $TreatmentMasterModel->dx_biopsy_and_turp_types)."')
				WHERE DiagnosisMaster.deleted <> 1 AND $primary_ids_condition
				ORDER BY DiagnosisMaster.primary_id ASC;";
			$gleason_grades_bx_dx = $this->Report->tryCatchQuery($sql);
			$tmp_new_primary_id = '';
			foreach($gleason_grades_bx_dx as $new_res) {
				$studied_primary_id = $new_res['DiagnosisMaster']['primary_id'];
				if($tmp_new_primary_id != $studied_primary_id) {
					$tmp_new_primary_id = $studied_primary_id;
					$bx_dx_gleason_grades_from_primary_id[$studied_primary_id] = array('Generated'=>array('qc_tf_gleason_grade_biopsy_turp' => $new_res['TreatmentDetail']['gleason_grade']));
				} else {
					die('ERR 1993434343');
				}
			}
		}
		
		// *********** Get Fst Bcr ***********		
		
		$fst_bcr_results_from_primary_id = array();
		if($primary_ids_condition) {
			$sql =
				"SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					FstBcrDiagnosisMaster.dx_date AS first_bcr_date,
					FstBcrDiagnosisMaster.dx_date_accuracy AS first_bcr_date_accuracy,
					FstBcrDiagnosisDetail.type AS first_bcr_type
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN diagnosis_masters AS FstBcrDiagnosisMaster ON DiagnosisMaster.id = FstBcrDiagnosisMaster.primary_id AND FstBcrDiagnosisMaster.diagnosis_control_id = 22 AND FstBcrDiagnosisMaster.deleted <> 1
				INNER JOIN qc_tf_dxd_recurrence_bio AS FstBcrDiagnosisDetail ON FstBcrDiagnosisDetail.diagnosis_master_id = FstBcrDiagnosisMaster.id AND FstBcrDiagnosisDetail.first_biochemical_recurrence = 1
				WHERE DiagnosisMaster.deleted <> 1 AND $primary_ids_condition
				ORDER BY DiagnosisMaster.primary_id ASC;";
				
			$fst_bcr_results = $this->Report->tryCatchQuery($sql);
					
			$tmp_new_primary_id = '';
			foreach($fst_bcr_results as $new_res) {
				$studied_primary_id = $new_res['DiagnosisMaster']['primary_id'];
				if($tmp_new_primary_id != $studied_primary_id) {
					$tmp_new_primary_id = $studied_primary_id;
					unset($new_res['DiagnosisMaster']);
					$fst_bcr_results_from_primary_id[$studied_primary_id] = $new_res;
				} else {
					die('ERR 19938939323');
				}
			}
		}
		
		// *********** Get DFS start & PSA PreDFS ***********
		
		$dfs_start_results_from_primary_id = array();
		if($primary_ids_condition) {
			$sql = 
				"SELECT DISTINCT
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
				WHERE DiagnosisMaster.deleted <> 1 AND $primary_ids_condition 
				ORDER BY DiagnosisMaster.primary_id ASC, PsaEventMaster.event_date DESC;";
			
			$dfs_start_results = $this->Report->tryCatchQuery($sql);
			
			$tmp_new_primary_id = '';
			foreach($dfs_start_results as $new_res) {
				$studied_primary_id = $new_res['DiagnosisMaster']['primary_id'];
				
				$studied_data = array(
					'DfsTreatmentMaster' => array(
						'dfs_start_date' => $new_res['TreatmentMaster']['dfs_start_date'],
						'dfs_start_date_accuracy' => $new_res['TreatmentMaster']['dfs_start_date_accuracy']),
					'DfsTreatmentControl' => array(
						'dfs_tx_method' => $new_res['TreatmentControl']['dfs_tx_method'],
						'dfs_disease_site' =>  $new_res['TreatmentControl']['dfs_disease_site']),
					'PsaEventMaster' => array(
						'psa_event_date' => $new_res['PsaEventMaster']['psa_event_date'],
						'psa_event_date_accuracy' => $new_res['PsaEventMaster']['psa_event_date_accuracy']),
					'PsaEventDetail' => array(
						'psa_ng_per_ml' => $new_res['PsaEventDetail']['psa_ng_per_ml']
					)
				);
				
				if($tmp_new_primary_id != $studied_primary_id) {
					$tmp_new_primary_id = $studied_primary_id;
					$dfs_start_results_from_primary_id[$studied_primary_id] = $studied_data;
				} else if( array_diff_assoc($dfs_start_results_from_primary_id[$studied_primary_id]['DfsTreatmentMaster'], $studied_data['DfsTreatmentMaster']) || array_diff_assoc($studied_data['DfsTreatmentMaster'], $dfs_start_results_from_primary_id[$studied_primary_id]['DfsTreatmentMaster']) || array_diff_assoc($dfs_start_results_from_primary_id[$studied_primary_id]['DfsTreatmentControl'], $studied_data['DfsTreatmentControl']) || array_diff_assoc($studied_data['DfsTreatmentControl'], $dfs_start_results_from_primary_id[$studied_primary_id]['DfsTreatmentControl'])) {
					pr($studied_data);
					pr($dfs_start_results_from_primary_id[$studied_primary_id]);
					die('ERR 123');
				}
			}
		}
		
		// *********** Get Metastasis ***********
		
		$metastasis_results_from_primary_id = array();
		if($primary_ids_condition) {
			$sql =
			"SELECT DISTINCT
				DiagnosisMaster.primary_id,
				DiagnosisMaster.participant_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisDetail.site
				
			FROM diagnosis_masters AS DiagnosisMaster
			INNER JOIN qc_tf_dxd_metastasis AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id = 21 AND $primary_ids_condition
			ORDER BY DiagnosisMaster.dx_date ASC;";
				
			$metastasis_results = $this->Report->tryCatchQuery($sql);
	
			$tmp_new_primary_id = '';
			$is_first_one_set = false;
			$tmp_data = array();
			foreach($metastasis_results as $new_res) {
				$studied_primary_id = $new_res['DiagnosisMaster']['primary_id'];
				
				if($tmp_new_primary_id != $studied_primary_id) {
					$tmp_new_primary_id = $studied_primary_id;
					$metastasis_results_from_primary_id[$studied_primary_id] = array(
						'Metastasis' => array(
							'first_metastasis_dx_date' => '',
							'first_metastasis_dx_date_accuracy' => '', 
							'qc_tf_first_bone_metastasis_date' => '',
							'qc_tf_first_bone_metastasis_date_accuracy' => '',
							'first_metastasis_type' => '', 
							'other_types' => ''
						)
					) ;
				}
				if(empty($metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date']) && !empty($new_res['DiagnosisMaster']['dx_date'])) {
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date'] = $new_res['DiagnosisMaster']['dx_date'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date_accuracy'] = $new_res['DiagnosisMaster']['dx_date_accuracy'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_type'] = $new_res['DiagnosisDetail']['site'];			
				} else if(!empty($new_res['DiagnosisDetail']['site'])) {				
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['other_types'][] = __($new_res['DiagnosisDetail']['site']);
				}
				if($new_res['DiagnosisDetail']['site'] == 'bone' && empty($metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['qc_tf_first_bone_metastasis_date']) && !empty($new_res['DiagnosisMaster']['dx_date'])) {
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['qc_tf_first_bone_metastasis_date'] = $new_res['DiagnosisMaster']['dx_date'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['qc_tf_first_bone_metastasis_date_accuracy'] = $new_res['DiagnosisMaster']['dx_date_accuracy'];
				}
			}
		}
		
		// *********** Get Trt ***********
		
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$tmp = $StructurePermissibleValuesCustom->getCustomDropdown(array('radiotherapy types'));
		$radiotherapy_types = array_merge($tmp['defined'], $tmp['previously_defined']);

		$treatments_summary_template = array(
			'Generated' => array(
				'qc_tf_chemo_flag' => 'n',
				'qc_tf_radiation_flag' => 'n',
				'qc_tf_radiation_details' => '',
				'qc_tf_hormono_flag' => 'n'));
		$sql = "SELECT distinct TreatmentMaster.participant_id, TreatmentControl.tx_method, RadiationDetails.qc_tf_type
			FROM treatment_masters TreatmentMaster 
			INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			LEFT JOIN txd_radiations RadiationDetails ON RadiationDetails.treatment_master_id =  TreatmentMaster.id
			WHERE TreatmentMaster.deleted <> 1
			AND TreatmentControl.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
			AND TreatmentMaster.participant_id IN (".implode(',',$participant_ids).")";
		$treatment_results = $this->Report->tryCatchQuery($sql);
		$treatments_summary = array();
		foreach($treatment_results as $new_trt) {
			$participant_id = $new_trt['TreatmentMaster']['participant_id'];
			if(!isset($treatments_summary[$participant_id])) $treatments_summary[$participant_id] = $treatments_summary_template;
			switch($new_trt['TreatmentControl']['tx_method']) {
				case 'hormonotherapy':
					$treatments_summary[$participant_id]['Generated']['qc_tf_hormono_flag'] = 'y';
					break;
				case 'radiation':
					$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_flag'] = 'y';
					if($new_trt['RadiationDetails']['qc_tf_type']) {
						$radiation_type = isset($radiotherapy_types[$new_trt['RadiationDetails']['qc_tf_type']])? $radiotherapy_types[$new_trt['RadiationDetails']['qc_tf_type']] : $new_trt['RadiationDetails']['qc_tf_type'];
						if(!preg_match('/$radiation_type/', $treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'])) {
							$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'] .= (empty($treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'])? '' : ', '). $radiation_type;
						}
					}
					break;
				case 'chemotherapy':
					$treatments_summary[$participant_id]['Generated']['qc_tf_chemo_flag'] = 'y';
					break;
			}
		}
		
		// *********** Get Core Review ***********
		
		$participant_ids_to_revised_grades = null;
		if(!$display_cores_positions) {
			$participant_ids_to_revised_grades = array();
			$sql = "
				SELECT Collection.participant_id, GROUP_CONCAT(AliquotReviewDetail.grade SEPARATOR '##') AS qc_tf_participant_reviewed_grades
				FROM collections Collection 
				INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
				INNER JOIN aliquot_review_masters AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.aliquot_review_control_id = 2
				INNER JOIN qc_tf_ar_tissue_cores AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id
				WHERE Collection.deleted <> 1 AND Collection.participant_id IN (".implode(',',$participant_ids).")
				GROUP BY Collection.participant_id";
			foreach($this->Report->tryCatchQuery($sql) as $new_patient_revised_grades) {
				$qc_tf_participant_reviewed_grades = explode('##',$new_patient_revised_grades['0']['qc_tf_participant_reviewed_grades']);
				asort($qc_tf_participant_reviewed_grades);
				
				$participant_ids_to_revised_grades[$new_patient_revised_grades['Collection']['participant_id']] = implode(' ', $qc_tf_participant_reviewed_grades);
			}
		}
		
		// *********** Merge all data ***********
		
		$dfs_psa_template = array(
			'DfsTreatmentMaster' => array(
				'dfs_start_date' => '',
				'dfs_start_date_accuracy' => ''),
			'DfsTreatmentControl' => array(
				'dfs_tx_method' => '',
				'dfs_disease_site' => ''),
			'PsaEventMaster' => array(
				'psa_event_date' => '',
				'psa_event_date_accuracy' => ''),
			'PsaEventDetail' => array(
				'psa_ng_per_ml' => ''
			)
		);		
		$metastasis_template = array(
			'Metastasis' => array(
				'first_metastasis_dx_date' => '',
				'first_metastasis_dx_date_accuracy' => '',
				'qc_tf_first_bone_metastasis_date' => '',
				'qc_tf_first_bone_metastasis_date_accuracy' => '',
				'first_metastasis_type' => '',
				'other_types' => ''
			)
		);
		$fst_bcr_template = array(
			'FstBcrDiagnosisMaster' => array(
				'first_bcr_date' => '',
				'first_bcr_date_accuracy' => ''),
			'FstBcrDiagnosisDetail' => array(
					'first_bcr_type' => ''
			)
		);
		foreach($main_results as &$new_participant) {
			if(isset($dfs_start_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge_recursive($new_participant, $dfs_start_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, $dfs_psa_template);
			}
			if(isset($metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$other_types = $metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'];			
				$metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'] = (empty($other_types) || !is_array($other_types))? '' : implode($other_types, ' | ');
				$new_participant = array_merge_recursive($new_participant, $metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, $metastasis_template);
			}
			if(isset($fst_bcr_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge_recursive($new_participant, $fst_bcr_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, $fst_bcr_template);
			}
			if(isset($treatments_summary[$new_participant['Participant']['id']])) {
				$new_participant = array_merge_recursive($new_participant, $treatments_summary[$new_participant['Participant']['id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, $treatments_summary_template);
			}
			if(isset($bx_dx_gleason_grades_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge_recursive($new_participant, $bx_dx_gleason_grades_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, array('Generated'=>array('qc_tf_gleason_grade_biopsy_turp' => '')));
			}
			$date_diff_def = array('Participant.qc_tf_last_contact' => 'Generated.qc_tf_rp_to_last_contact',
				'Metastasis.qc_tf_first_bone_metastasis_date' => 'Generated.qc_tf_rp_to_bone_met',
				'FstBcrDiagnosisMaster.first_bcr_date' => 'Generated.qc_tf_rp_to_bcr');
			foreach($date_diff_def as $model_field_data => $model_field_calculated) {
				list($model_data,$field_data) = explode('.', $model_field_data);
				list($model_calculated,$field_calculated) = explode('.', $model_field_calculated);
				$new_participant[$model_calculated][$field_calculated] = $this->getDateDiffInMonths($new_participant['TreatmentMaster']['start_date'], $new_participant[$model_data][$field_data]);	
				if($new_participant[$model_data][$field_data.'_accuracy'].$new_participant['TreatmentMaster']['start_date_accuracy'] != 'cc' && $new_participant[$model_data][$field_data] && $new_participant['TreatmentMaster']['start_date'] ) $warnings[] = __('intervals from rp have been calculated with at least one inaccuracy date');
			}
			if(!is_null($participant_ids_to_revised_grades)) {
				if(array_key_exists($new_participant['Participant']['id'], $participant_ids_to_revised_grades)) {
					$new_participant['Generated']['qc_tf_participant_reviewed_grades'] = $participant_ids_to_revised_grades[$new_participant['Participant']['id']];
				} else {
					$new_participant['Generated']['qc_tf_participant_reviewed_grades'] = '';
				}
			}
			if(($_SESSION['Auth']['User']['group_id'] != '1') && ($new_participant['Participant']['qc_tf_bank_id'] != $user_bank_id)) {
				$new_participant['Participant']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
				$new_participant['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
			}
		}
		
		foreach($warnings as $new_warning) AppController::addWarningMsg($new_warning);
		$array_to_return = array(
			'header' => array(), 
			'data' => $main_results, 
			'columns_names' => null,
			'error_msg' => null);
*/		
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