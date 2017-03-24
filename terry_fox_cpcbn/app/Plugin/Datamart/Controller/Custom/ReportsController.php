<?php
class ReportsControllerCustom extends ReportsController {
	
	function buildCpcbnSummaryLevel3($parameters) {
		return $this->buildCpcbnSummary($parameters, true, true);
	}
	
	function buildCpcbnSummaryLevel2($parameters) {
		return $this->buildCpcbnSummary($parameters, true);
	}
	
	function buildCpcbnSummary($parameters, $display_cores_positions = false, $display_cores_data = false) {
		
		$conditions = array();
		$warnings = array();	
		$join_on_storage = 'LEFT JOIN';
		
		$user_bank_id = null;
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = (empty($group_data)? '' : $group_data['Group']['bank_id']);
		}
		
		if(!isset($parameters['exact_search']) || $parameters['exact_search'] != 'on') {
			$warnings[] = __('only exact search is supported');
		}	
		
		// *********** Get Conditions from parameters *********** 
		
		if(isset($parameters['Browser'])) {
			
			// 0-REPORT LAUNCHED FROM DATA BROWSER
				
			if(isset($parameters['ViewStorageMaster']['id'])) {
				$join_on_storage = 'INNER JOIN';
				$criteria = ($parameters['ViewStorageMaster']['id'] == 'all')? array('StorageControl.is_tma_block = 1') :  array('StorageMaster.id'=>$parameters['ViewStorageMaster']['id']);
				$storage_model = AppModel::getInstance("StorageLayout", "StorageMaster", true);
				$selected_storages = $storage_model->find('all', array('conditions' => $criteria, 'recursive' => 0));		
				$tma_storage_master_ids = array();
				foreach($selected_storages as $new_storage) {
					if($new_storage['StorageControl']['is_tma_block']) {
						$tma_storage_master_ids[] = $new_storage['StorageMaster']['id'];
					} else {
						$warnings[] = str_replace('%s', $new_storage['StorageMaster']['selection_label'], __('storage [%s] is not a tma block'));
					}
				}
				if($tma_storage_master_ids) {
					$conditions[] = 'AliquotMaster.storage_master_id IN ('.implode($tma_storage_master_ids, ',').')' ;
				} else {
					return array(
						'header' => array(),
						'data' => array(),
						'columns_names' => null,
						'error_msg' => 'no tma is selected');
				}
			} else if(isset($parameters['Participant']['id'])) {
				if(($parameters['Participant']['id'] != 'all')) {
					$conditions[] = 'Participant.id IN ('.implode($parameters['Participant']['id'], ',').')' ;
				}
			} else {
				die('ERR 9900303');
			}
			
		} else {
			
			// 1-BANK
			$bank_ids = array();
			foreach($parameters['Participant']['qc_tf_bank_id'] as $new_bank_id) if(strlen($new_bank_id)) $bank_ids[] = $new_bank_id;
			if(!empty($bank_ids)) $conditions[] = 'Participant.qc_tf_bank_id IN ('.implode($bank_ids, ',').')' ;
	
			
			// 2-STORAGE
			$matching_storage_issue = false;
			$recorded_storage_selection_labels = array();
			foreach($parameters['FunctionManagement']['recorded_storage_selection_label'] as $new_label) if(strlen($new_label)) $recorded_storage_selection_labels[] = $new_label;
			if(!empty($recorded_storage_selection_labels)) {
				$join_on_storage = 'INNER JOIN';
				$storage_ids = array();
				$storage_model = AppModel::getInstance("StorageLayout", "StorageMaster", true);
				foreach($recorded_storage_selection_labels as $new_recorded_storage_selection_label) {
					$storage_data = $storage_model->getStorageDataFromStorageLabelAndCode($new_recorded_storage_selection_label);
					if(isset($storage_data['StorageMaster'])) {
						if($storage_data['StorageControl']['is_tma_block']) {
							$storage_ids[] = $storage_data['StorageMaster']['id'];
						} else {
							$warnings[] = str_replace('%s', $new_recorded_storage_selection_label, __('storage [%s] is not a tma block'));
						}
					} else if(isset($storage_data['error'])) {
						$warnings[] = __($storage_data['error']);
					}
				}
				if($storage_ids) {
					$conditions[] = 'AliquotMaster.storage_master_id IN ('.implode($storage_ids, ',').')' ;
				} else {
					$matching_storage_issue = true;
				}
			}
			
			// 3-PARTICIPANT IDENTIFIER
			$participant_identifier_criteria_set = false;
			if(isset($parameters['Participant']['qc_tf_bank_participant_identifier'])) {
				$participant_ids = array();
				foreach($parameters['Participant']['qc_tf_bank_participant_identifier']as $new_participant_id) if(strlen($new_participant_id)) $participant_ids[] = $new_participant_id;
				if(!empty($participant_ids)) {
					$conditions[] = "Participant.qc_tf_bank_participant_identifier IN ('".implode($participant_ids, "','")."')" ;
					$participant_identifier_criteria_set = true;
				}
				
			} else if(isset($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
				if(strlen($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
					$participant_identifier_criteria_set = true;
					$conditions[] = 'Participant.qc_tf_bank_participant_identifier >= '.$parameters['Participant']['qc_tf_bank_participant_identifier_start'];
				}
				if(strlen($parameters['Participant']['qc_tf_bank_participant_identifier_end'])) {
					$participant_identifier_criteria_set = true;
					$conditions[] = 'Participant.qc_tf_bank_participant_identifier <= '.$parameters['Participant']['qc_tf_bank_participant_identifier_end'];
				}
			}
			if(($_SESSION['Auth']['User']['group_id'] != '1') && $participant_identifier_criteria_set) {
				AppController::addWarningMsg(__('your search will be limited to your bank'));
				$conditions[] = "Participant.qc_tf_bank_id = '$user_bank_id'";
			}
			
			if(empty($conditions) && $matching_storage_issue) {
				return array(
					'header' => array(),
					'data' => array(),
					'columns_names' => null,
					'error_msg' => 'no storage matches the selection labels');
			}
		}
		
		$conditions_str = empty($conditions)? 'TRUE' : implode($conditions, ' AND ');
		
		// *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********
		
		$join_to_display_cores_data = $display_cores_data? 
			'LEFT JOIN ad_tissue_cores AS AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
			LEFT JOIN aliquot_review_masters AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.aliquot_review_control_id = 2
			LEFT JOIN qc_tf_ar_tissue_cores AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id' :
			'';

		$sql = 
			"SELECT DISTINCT
				Participant.id,
				Participant.qc_tf_bank_id,
				Participant.participant_identifier,
				Participant.qc_tf_bank_participant_identifier,
				Participant.qc_tf_study_exclusions,
				Participant.vital_status,
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
				DiagnosisDetail.active_surveillance,
				DiagnosisDetail.ptnm,
				DiagnosisDetail.ctnm,
				DiagnosisDetail.gleason_score_biopsy_turp,
				DiagnosisDetail.gleason_score_rp,
			
				TreatmentMaster.start_date ,
				TreatmentMaster.start_date_accuracy,
				
				TreatmentDetail.qc_tf_lymph_node_invasion ,
				TreatmentDetail.qc_tf_capsular_penetration,
				TreatmentDetail.qc_tf_seminal_vesicle_invasion,
				TreatmentDetail.qc_tf_margin,
				TreatmentDetail.qc_tf_gleason_grade,
				
				DiagnosisDetail.hormonorefractory_status,
				DiagnosisDetail.survival_in_months,
				DiagnosisDetail.bcr_in_months".
				
				($display_cores_positions?  ', StorageMaster.selection_label, AliquotMaster.storage_coord_x, AliquotMaster.storage_coord_y, StorageMaster.short_label, StorageMaster.qc_tf_tma_name, StorageMaster.qc_tf_tma_label_site, StorageMaster.qc_tf_bank_id' : ' ').
				
				($display_cores_data? ',AliquotDetail.qc_tf_core_nature_site, AliquotDetail.qc_tf_core_nature_revised, AliquotReviewDetail.revised_nature, AliquotReviewDetail.grade ' : ' ')
				
			."FROM participants AS Participant 

			$join_on_storage collections AS Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
			$join_on_storage aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND aliquot_control_id = 33
			$join_on_storage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
							
			LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_cpcbn AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			
			LEFT JOIN treatment_masters AS TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.treatment_control_id = 6 AND TreatmentMaster.deleted <> 1
			LEFT JOIN txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			
			$join_to_display_cores_data
			
			WHERE Participant.deleted <> 1 AND ($conditions_str)
			
			ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC, StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC;";
		
		$main_results = $this->Report->tryCatchQuery($sql);
		
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
					TreatmentMaster.start_date,
					TreatmentMaster.start_date_accuracy,
					TreatmentDetail.type,
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
					$bx_dx_gleason_grades_from_primary_id[$studied_primary_id] = array(
						'Generated'=>array(
							'qc_tf_date_biopsy_turp' => $this->formatReportDateForDisplay($new_res['TreatmentMaster']['start_date'], $new_res['TreatmentMaster']['start_date_accuracy']),
							'qc_tf_date_biopsy_turp_accuracy' => $new_res['TreatmentMaster']['start_date_accuracy'],							
							'qc_tf_type_biopsy_turp' => $new_res['TreatmentDetail']['type'],								
							'qc_tf_gleason_grade_biopsy_turp' => $new_res['TreatmentDetail']['gleason_grade'],
							'qc_tf_date_confirmation_biopsy_turp' => '',
							'qc_tf_type_confirmation_biopsy_turp' => ''	
						));
					if($new_res['TreatmentMaster']['start_date']) {
						//Get confirmation Biopsy
						$sql =
							"SELECT DISTINCT
								TreatmentMaster.start_date,
								TreatmentMaster.start_date_accuracy,
								TreatmentDetail.type
							FROM diagnosis_masters AS DiagnosisMaster
							INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1
							INNER JOIN qc_tf_txd_biopsies_and_turps AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentDetail.type NOT IN ('".implode("','", $TreatmentMasterModel->dx_biopsy_and_turp_types)."')
							WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.primary_id = $studied_primary_id
							AND TreatmentMaster.start_date IS NOT NULL
							AND TreatmentMaster.start_date > '".$new_res['TreatmentMaster']['start_date']."'
							ORDER BY TreatmentMaster.start_date ASC
							LIMIT 0,1;";
						$bx_confirmation = $this->Report->tryCatchQuery($sql);
						if($bx_confirmation) {
							$bx_dx_gleason_grades_from_primary_id[$studied_primary_id]['Generated']['qc_tf_date_confirmation_biopsy_turp'] = $this->formatReportDateForDisplay($bx_confirmation[0]['TreatmentMaster']['start_date'], $bx_confirmation[0]['TreatmentMaster']['start_date_accuracy']);
							$bx_dx_gleason_grades_from_primary_id[$studied_primary_id]['Generated']['qc_tf_date_confirmation_biopsy_turp_accuracy'] = $bx_confirmation[0]['TreatmentMaster']['start_date_accuracy'];
							$bx_dx_gleason_grades_from_primary_id[$studied_primary_id]['Generated']['qc_tf_type_confirmation_biopsy_turp'] = $bx_confirmation[0]['TreatmentDetail']['type'];
						}
					}
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
					$new_res['FstBcrDiagnosisMaster']['first_bcr_date'] = $this->formatReportDateForDisplay($new_res['FstBcrDiagnosisMaster']['first_bcr_date'], $new_res['FstBcrDiagnosisMaster']['first_bcr_date_accuracy'] );
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
						'dfs_start_date' => $this->formatReportDateForDisplay($new_res['TreatmentMaster']['dfs_start_date'], $new_res['TreatmentMaster']['dfs_start_date_accuracy']),
						'dfs_start_date_accuracy' => $new_res['TreatmentMaster']['dfs_start_date_accuracy']),
					'DfsTreatmentControl' => array(
						'dfs_tx_method' => $new_res['TreatmentControl']['dfs_tx_method'],
						'dfs_disease_site' =>  $new_res['TreatmentControl']['dfs_disease_site']),
					'PsaEventMaster' => array(
						'psa_event_date' => $this->formatReportDateForDisplay($new_res['PsaEventMaster']['psa_event_date'], $new_res['PsaEventMaster']['psa_event_date_accuracy']),
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
		
		// *********** Get Last PSA ***********
		
		$last_psa_from_primary_id = array();
		if($primary_ids_condition) {
			$sql = 
				"SELECT DISTINCT
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
				
					PsaEventMaster.event_date AS psa_event_date,
					PsaEventMaster.event_date_accuracy AS psa_event_date_accuracy,
					PsaEventDetail.psa_ng_per_ml
					
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN event_masters AS PsaEventMaster ON PsaEventMaster.diagnosis_master_id = DiagnosisMaster.id AND PsaEventMaster.deleted <> 1 AND PsaEventMaster.event_control_id = 52 AND PsaEventMaster.event_date IS NOT NULL
				INNER JOIN qc_tf_ed_psa AS PsaEventDetail ON PsaEventDetail.event_master_id = PsaEventMaster.id
				WHERE DiagnosisMaster.deleted <> 1 AND $primary_ids_condition 
				ORDER BY DiagnosisMaster.primary_id ASC, PsaEventMaster.event_date DESC;";
				
			$last_psa_results = $this->Report->tryCatchQuery($sql);
				
			$tmp_new_primary_id = '';
			foreach($last_psa_results as $new_res) {
				$studied_primary_id = $new_res['DiagnosisMaster']['primary_id'];
		
				$studied_data = array(
					'PsaEventMaster' => array(
						'qc_tf_last_psa_event_date' => $this->formatReportDateForDisplay($new_res['PsaEventMaster']['psa_event_date'], $new_res['PsaEventMaster']['psa_event_date_accuracy']),
						'qc_tf_last_psa_event_date_accuracy' => $new_res['PsaEventMaster']['psa_event_date_accuracy']),
					'PsaEventDetail' => array(
						'qc_tf_last_psa_ng_per_ml' => $new_res['PsaEventDetail']['psa_ng_per_ml']
					)
				);
				
				if($tmp_new_primary_id != $studied_primary_id) {
					$tmp_new_primary_id = $studied_primary_id;
					$last_psa_from_primary_id[$studied_primary_id] = $studied_data;
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
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date'] = $this->formatReportDateForDisplay($new_res['DiagnosisMaster']['dx_date'], $new_res['DiagnosisMaster']['dx_date_accuracy']);
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date_accuracy'] = $new_res['DiagnosisMaster']['dx_date_accuracy'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_type'] = $new_res['DiagnosisDetail']['site'];			
				} else if(!empty($new_res['DiagnosisDetail']['site'])) {				
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['other_types'][] = __($new_res['DiagnosisDetail']['site']);
				}
				if($new_res['DiagnosisDetail']['site'] == 'bone' && empty($metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['qc_tf_first_bone_metastasis_date']) && !empty($new_res['DiagnosisMaster']['dx_date'])) {
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['qc_tf_first_bone_metastasis_date'] = $this->formatReportDateForDisplay($new_res['DiagnosisMaster']['dx_date'], $new_res['DiagnosisMaster']['dx_date_accuracy']);
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
				'qc_tf_chemo_first_date' => '',
				'qc_tf_radiation_flag' => 'n',
				'qc_tf_radiation_details' => '',
				'qc_tf_radiation_first_date' => '',
				'qc_tf_hormono_flag' => 'n',
				'qc_tf_hormono_first_date' => ''));
		$sql = "SELECT distinct TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentMaster.participant_id, TreatmentControl.tx_method, RadiationDetails.qc_tf_type
			FROM treatment_masters TreatmentMaster 
			INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			LEFT JOIN txd_radiations RadiationDetails ON RadiationDetails.treatment_master_id =  TreatmentMaster.id
			WHERE TreatmentMaster.deleted <> 1
			AND TreatmentControl.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
			AND TreatmentMaster.participant_id IN (".implode(',',$participant_ids).")
			ORDER BY TreatmentMaster.start_date ASC";
		$treatment_results = $this->Report->tryCatchQuery($sql);
		$treatments_summary = array();
		foreach($treatment_results as $new_trt) {
			$participant_id = $new_trt['TreatmentMaster']['participant_id'];
			if(!isset($treatments_summary[$participant_id])) $treatments_summary[$participant_id] = $treatments_summary_template;
			switch($new_trt['TreatmentControl']['tx_method']) {
				case 'hormonotherapy':
					$treatments_summary[$participant_id]['Generated']['qc_tf_hormono_flag'] = 'y';
					if(strlen($new_trt['TreatmentMaster']['start_date']) && !$treatments_summary[$participant_id]['Generated']['qc_tf_hormono_first_date']) {
						$treatments_summary[$participant_id]['Generated']['qc_tf_hormono_first_date'] = $this->formatReportDateForDisplay($new_trt['TreatmentMaster']['start_date'], $new_trt['TreatmentMaster']['start_date_accuracy']);
						$treatments_summary[$participant_id]['Generated']['qc_tf_hormono_first_date_accuracy'] = $new_trt['TreatmentMaster']['start_date_accuracy'];		
					}
					break;
				case 'radiation':
					$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_flag'] = 'y';
					if($new_trt['RadiationDetails']['qc_tf_type']) {
						$radiation_type = isset($radiotherapy_types[$new_trt['RadiationDetails']['qc_tf_type']])? $radiotherapy_types[$new_trt['RadiationDetails']['qc_tf_type']] : $new_trt['RadiationDetails']['qc_tf_type'];
						if(!preg_match('/$radiation_type/', $treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'])) {
							$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'] .= (empty($treatments_summary[$participant_id]['Generated']['qc_tf_radiation_details'])? '' : ', '). $radiation_type;
						}
					}
					if(strlen($new_trt['TreatmentMaster']['start_date']) && !$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_first_date']) {
						$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_first_date'] = $this->formatReportDateForDisplay($new_trt['TreatmentMaster']['start_date'], $new_trt['TreatmentMaster']['start_date_accuracy']);
						$treatments_summary[$participant_id]['Generated']['qc_tf_radiation_first_date_accuracy'] = $new_trt['TreatmentMaster']['start_date_accuracy'];	
					}
					break;
				case 'chemotherapy':
					$treatments_summary[$participant_id]['Generated']['qc_tf_chemo_flag'] = 'y';
					if(strlen($new_trt['TreatmentMaster']['start_date']) && !$treatments_summary[$participant_id]['Generated']['qc_tf_chemo_first_date']) {
						$treatments_summary[$participant_id]['Generated']['qc_tf_chemo_first_date'] = $this->formatReportDateForDisplay($new_trt['TreatmentMaster']['start_date'], $new_trt['TreatmentMaster']['start_date_accuracy']);
						$treatments_summary[$participant_id]['Generated']['qc_tf_chemo_first_date_accuracy'] = $new_trt['TreatmentMaster']['start_date_accuracy'];
					}
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
		
		$last_psa_template = array(
			'PsaEventMaster' => array(
				'qc_tf_last_psa_event_date' =>  '',
				'qc_tf_last_psa_event_date_accuracy' => ''),
			'PsaEventDetail' => array(
				'qc_tf_last_psa_ng_per_ml' => ''
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
			if(isset($last_psa_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge_recursive($new_participant, $last_psa_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge_recursive($new_participant, $last_psa_template);
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
				$new_participant = array_merge_recursive($new_participant, array(
					'Generated'=>array(
						'qc_tf_date_biopsy_turp' => '',
						'qc_tf_type_biopsy_turp' => '',
						'qc_tf_gleason_grade_biopsy_turp' => '',
						'qc_tf_date_confirmation_biopsy_turp' => '',
						'qc_tf_type_confirmation_biopsy_turp' => ''	
					)));
			}
			$date_diff_def = array('Participant.qc_tf_last_contact' => 'Generated.qc_tf_rp_to_last_contact',
				'Metastasis.qc_tf_first_bone_metastasis_date' => 'Generated.qc_tf_rp_to_bone_met',
				'FstBcrDiagnosisMaster.first_bcr_date' => 'Generated.qc_tf_rp_to_bcr',
				'PsaEventMaster.qc_tf_last_psa_event_date' => 'Generated.qc_tf_rp_to_last_psa');
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
pr($main_results);		
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
	
	function formatReportDateForDisplay($date, $accuracy) {
		if(preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}(\ [0-9]{2}:[0-9]{2}){0,1}/', $date)) {
			if($accuracy != 'c'){
				if($accuracy == 'd'){
					$date = substr($date, 0, 7);
				}else if($accuracy == 'm'){
					$date = substr($date, 0, 4);
				}else if($accuracy == 'y'){
					$date = '±'.substr($date, 0, 4);
				}else if($accuracy == 'h'){
					$date = substr($date, 0, 10);
				}else if($accuracy == 'i'){
					$date = substr($date, 0, 13);
				}
			}
		}
		return $date;
	}
}