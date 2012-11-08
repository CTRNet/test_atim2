<?php
class ReportsControllerCustom extends ReportsController {
//	var $name = 'ReportsController';

	function buildCpcbnSummary($parameters) {
		
		$conditions = array();
		$warnings = array();	
		$join_on_storage = 'LEFT JOIN';
		
		if(!isset($parameters['exact_search']) || $parameters['exact_search'] != 'on') {
			$warnings[] = __('only exact search is supported');
		}	
		
		// *********** Get Conditions from parameters *********** 
		

		if(isset($parameters['Browser'])) {
			
			// 0-REPORT LAUNCHED FROM DATA BROWSER
				
			if(isset($parameters['StorageMaster']['id'])) {
				$join_on_storage = 'INNER JOIN';
				$criteria = ($parameters['StorageMaster']['id'] == 'all')? array('StorageControl.is_tma_block = 1') :  array('StorageMaster.id'=>$parameters['StorageMaster']['id']);
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
			if(isset($parameters['Participant']['qc_tf_bank_participant_identifier'])) {
				$participant_ids = array();
				foreach($parameters['Participant']['qc_tf_bank_participant_identifier']as $new_participant_id) if(strlen($new_participant_id)) $participant_ids[] = $new_participant_id;
				if(!empty($participant_ids)) $conditions[] = 'Participant.qc_tf_bank_participant_identifier IN ('.implode($participant_ids, ',').')' ;
			
			} else if(isset($parameters['Participant']['qc_tf_bank_participant_identifier_with_file_upload'])) {
				$tmp_file_data = $parameters['Participant']['qc_tf_bank_participant_identifier_with_file_upload'];
				$handle = fopen($parameters['Participant']['qc_tf_bank_participant_identifier_with_file_upload']['tmp_name'], "r");
				// unset($tmp_file_data['name'], $tmp_file_data['type'], $tmp_file_data['tmp_name'], $tmp_file_data['error'], $tmp_file_data['size']);
				// in each LINE, get FIRST csv value, and attach to DATA array
				$participant_ids = array();
				while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
					if(strlen($csv_data[0])) $participant_ids[] = $csv_data[0];
				}
				fclose($handle);
				unset($tmp_file_data);
				unset($parameters['Participant']['qc_tf_bank_participant_identifier_with_file_upload']);
				if(!empty($participant_ids)) $conditions[] = 'Participant.qc_tf_bank_participant_identifier IN ('.implode($participant_ids, ',').')' ;
				
			} else if(isset($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) {
				if(strlen($parameters['Participant']['qc_tf_bank_participant_identifier_start'])) $conditions[] = 'Participant.qc_tf_bank_participant_identifier >= '.$parameters['Participant']['qc_tf_bank_participant_identifier_start'];
				if(strlen($parameters['Participant']['qc_tf_bank_participant_identifier_end'])) $conditions[] = 'Participant.qc_tf_bank_participant_identifier <= '.$parameters['Participant']['qc_tf_bank_participant_identifier_end'];
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
		
		$sql = 
			"SELECT DISTINCT
				Participant.id AS participant_id,
				Participant.qc_tf_bank_id,
				Participant.participant_identifier,
				Participant.qc_tf_bank_participant_identifier,
				Participant.vital_status,
				Participant.date_of_death,
				Participant.date_of_death_accuracy,
				Participant.qc_tf_last_contact,
				Participant.qc_tf_last_contact_accuracy,
				
				DiagnosisMaster.id AS primary_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisDetail.tool,
				DiagnosisMaster.age_at_dx,
				DiagnosisDetail.active_surveillance,
				DiagnosisDetail.gleason_score_biopsy,
				DiagnosisDetail.ptnm,
				DiagnosisDetail.gleason_score_rp,
				DiagnosisDetail.presence_of_lymph_node_invasion,
				DiagnosisDetail.presence_of_capsular_penetration,
				DiagnosisDetail.presence_of_seminal_vesicle_invasion,
				DiagnosisDetail.margin,
				DiagnosisDetail.hormonorefractory_status,
				DiagnosisDetail.survival_in_months,
				DiagnosisDetail.bcr_in_months,
				
				StorageMaster.selection_label,
				AliquotMaster.storage_coord_x,
				AliquotMaster.storage_coord_y
			
			FROM participants AS Participant 

			$join_on_storage collections AS Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
			$join_on_storage aliquot_masters AS AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND aliquot_control_id = 33
			$join_on_storage storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id AND StorageMaster.deleted <> 1
							
			LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_cpcbn AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id

			WHERE Participant.deleted <> 1 AND ($conditions_str)
			
			ORDER BY Participant.qc_tf_bank_id ASC, Participant.qc_tf_bank_participant_identifier ASC, StorageMaster.selection_label ASC, AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC;";
		
		
		$main_results = $this->Report->tryCatchQuery($sql);
		
		$primary_ids = array();
		foreach($main_results as $new_participant) if(!empty($new_participant['DiagnosisMaster']['primary_id'])) $primary_ids[] = $new_participant['DiagnosisMaster']['primary_id'];	
		$primary_ids_condition = empty($primary_ids)? '' : 'DiagnosisMaster.primary_id IN ('.implode($primary_ids, ',').')';
				
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
				DiagnosisDetail.type
				
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
							'first_metastasis_type' => '', 
							'other_types' => ''
						)
					) ;
				}
				if(empty($metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date']) && !empty($new_res['DiagnosisMaster']['dx_date'])) {
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date'] = $new_res['DiagnosisMaster']['dx_date'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_dx_date_accuracy'] = $new_res['DiagnosisMaster']['dx_date_accuracy'];
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['first_metastasis_type'] = $new_res['DiagnosisDetail']['type'];			
				} else if(!empty($new_res['DiagnosisDetail']['type'])) {
					$metastasis_results_from_primary_id[$studied_primary_id]['Metastasis']['other_types'][] = __($new_res['DiagnosisDetail']['type']);
				}
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
				'first_metastasis_type' => '',
				'other_types' => ''
			)
		);
		$fst_bcr_template = array(
			'FstBcrDiagnosisMaster' => array(
				'first_bcr_date' => '',
				'first_metastasfirst_bcr_date_accuracyis_dx_date' => ''),
			'FstBcrDiagnosisDetail' => array(
					'first_bcr_type' => ''
			)
		);				
		foreach($main_results as &$new_participant) {
			if(isset($dfs_start_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge($new_participant, $dfs_start_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge($new_participant, $dfs_psa_template);
			}
			if(isset($metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$other_types = $metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'];			
				$metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]['Metastasis']['other_types'] = (empty($other_types) || !is_array($other_types))? '' : implode($other_types, ' | ');
				$new_participant = array_merge($new_participant, $metastasis_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge($new_participant, $metastasis_template);
			}
			if(isset($fst_bcr_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']])) {
				$new_participant = array_merge($new_participant, $fst_bcr_results_from_primary_id[$new_participant['DiagnosisMaster']['primary_id']]);
			} else {
				$new_participant = array_merge($new_participant, $fst_bcr_template);
			}	
		}
		
		foreach($warnings as $new_warning) AppController::addWarningMsg($new_warning);
		
		$array_to_return = array(
			'header' => array(), 
			'data' => $main_results, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}	

}