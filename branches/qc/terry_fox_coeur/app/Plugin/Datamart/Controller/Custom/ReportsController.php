<?php
class ReportsControllerCustom extends ReportsController {

	function buildCoeurSummary($parameters) {	
		$conditions = array();
		$warnings = array();	
		
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
		
		$csv_order_for_display = array();
		$search_on_patho_number = false;
		
		if(isset($parameters['Browser'])) {
			
			// 0-REPORT LAUNCHED FROM DATA BROWSER
				
			if(isset($parameters['Participant']['id'])) {
				if(($parameters['Participant']['id'] != 'all')) {
					$conditions[] = 'Participant.id IN ('.implode(',', $parameters['Participant']['id']).')' ;
				}
			} else {
				die('ERR 9900303');
			}
			
		} else {
			if(isset($parameters['Participant'])) {
				
				// 1-BANK
				$bank_ids = array_filter($parameters['Participant']['qc_tf_bank_id']);
				if(!empty($bank_ids)) $conditions[] = 'Participant.qc_tf_bank_id IN ('.implode(',', $bank_ids).')' ;
				
				// 2-PARTICIPANT IDENTIFIER
				if(isset($parameters['Participant']['participant_identifier'])) {
					$participant_ids = array_filter($parameters['Participant']['participant_identifier']);
					if(!empty($participant_ids)) {
						$conditions[] = "Participant.participant_identifier IN ('".implode("','", $participant_ids)."')" ;
						$csv_order_for_display[] = array('field' => 'Participant.participant_identifier', 'order' => $parameters['Participant']['participant_identifier']);
					}
				} else if(isset($parameters['Participant']['participant_identifier_start'])) {
					if(strlen($parameters['Participant']['participant_identifier_start'])) {
						$conditions[] = 'Participant.participant_identifier >= '.$parameters['Participant']['participant_identifier_start'];
					}
					if(strlen($parameters['Participant']['participant_identifier_end'])) {
						$conditions[] = 'Participant.participant_identifier <= '.$parameters['Participant']['participant_identifier_end'];
					}
				}
						
				// 3-PARTICIPANT BANK IDENTIFIER
				$qc_tf_bank_identifier_criteria_set = false;
				if(isset($parameters['Participant']['qc_tf_bank_identifier'])) {
					$participant_ids = array_filter($parameters['Participant']['qc_tf_bank_identifier']);
					if(!empty($participant_ids)) {
						$conditions[] = "Participant.qc_tf_bank_identifier IN ('".implode("','", $participant_ids)."')" ;
						$qc_tf_bank_identifier_criteria_set = true;
						$csv_order_for_display[] = array('field' => 'Participant.qc_tf_bank_identifier', 'order' => $parameters['Participant']['qc_tf_bank_identifier']);
					}	
				}
				if(($_SESSION['Auth']['User']['group_id'] != '1') && $qc_tf_bank_identifier_criteria_set) {
					AppController::addWarningMsg(__('your search will be limited to your bank'));
					$conditions[] = "Participant.qc_tf_bank_id = '$user_bank_id'";
				}
			
			}  else if(isset($parameters['AliquotDetail'])) {
				
				// 4-PATHOLOGY NUMBER
				if(isset($parameters['AliquotDetail']['patho_dpt_block_code'])) {
					$patho_dpt_block_codes = array_filter($parameters['AliquotDetail']['patho_dpt_block_code']);
					if(!empty($patho_dpt_block_codes)) {
						$conditions[] = "AliquotDetail.patho_dpt_block_code IN ('".implode("','", $patho_dpt_block_codes)."')" ;
						$csv_order_for_display[] = array('field' => 'AliquotDetail.patho_dpt_block_code', 'order' => $parameters['AliquotDetail']['patho_dpt_block_code']);
					}
				}
				$search_on_patho_number = true;
				
			}
			
			// 5-CHECK ORDER OF THE RESULT TO CONTROL
			
			if(isset($parameters['FunctionManagement']['qc_tf_keep_csv_file_order']) && $parameters['FunctionManagement']['qc_tf_keep_csv_file_order'][0]) {
				switch(sizeof($csv_order_for_display)) {
					case '0':
						$csv_order_for_display = null;
						AppController::addWarningMsg(__('the csv order cannot be preserved with these search criteria'));
						break;
					case '1':
						$csv_order_for_display = $csv_order_for_display[0];
						break;
					case '2':
						$csv_order_for_display = null;
						AppController::addWarningMsg(__('system is not able to to preserve the order when both participant identifiers and bank identifiers are used for research'));
						break;
					default:
						$csv_order_for_display = null;
				}
			} else {
				$csv_order_for_display = null;
			}
		}
		if(empty($conditions)) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'please complete at least one search criteria');
		}
		$conditions_str = implode(' AND ', $conditions);
		
		// *********** Get Participant & Diagnosis & Fst Bcr & TMA data ***********
		
		$sql = 
			"SELECT DISTINCT ".
				($search_on_patho_number? 'AliquotDetail.patho_dpt_block_code,' : '').
				"Participant.id AS participant_id,
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
			FROM participants AS Participant ".
			($search_on_patho_number? 'INNER JOIN collections Collection ON Collection.participant_id = Participant.id INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id ' : '').
			"LEFT JOIN diagnosis_masters AS DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id AND DiagnosisMaster.diagnosis_control_id = 14 AND DiagnosisMaster.deleted <> 1
			LEFT JOIN qc_tf_dxd_eocs AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			WHERE Participant.deleted <> 1 AND ($conditions_str)
			ORDER BY Participant.participant_identifier ASC;";
		$main_results = $this->Report->tryCatchQuery($sql);
		
		$eoc_primary_ids = array();
		$participant_ids = array();
		foreach($main_results as $new_participant) {
			$participant_ids[] = $new_participant['Participant']['participant_id'];
			if(!empty($new_participant['DiagnosisMaster']['primary_id'])) $eoc_primary_ids[] = $new_participant['DiagnosisMaster']['primary_id'];
		}

		// *********** Get first EOC ***********
		
		$first_eoc_chemos_from_participant_id = array();
		if($eoc_primary_ids) {
			$sql = 
				"SELECT 
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
				WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.diagnosis_master_id IN (".implode(',',$eoc_primary_ids).") AND TreatmentMaster.treatment_control_id = 14
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.finish_date ASC, TreatmentMaster.id ASC;";
			$eoc_chemo_results = $this->Report->tryCatchQuery($sql);
			foreach($eoc_chemo_results as $new_res) {		
				$studied_participant_id = $new_res['TreatmentMaster']['participant_id'];
				if(!isset($first_eoc_chemos_from_participant_id[$studied_participant_id])) {
					$first_eoc_chemos_from_participant_id[$studied_participant_id] = $new_res;
					$first_eoc_chemos_from_participant_id[$studied_participant_id]['0']['qc_tf_coeur_chemo_drugs'] = isset($new_res['Drug']['generic_name'])? array($new_res['Drug']['generic_name']) : array();			
				} else if($first_eoc_chemos_from_participant_id[$studied_participant_id]['TreatmentMaster']['id'] == $new_res['TreatmentMaster']['id']) {
					if(isset($new_res['Drug']['generic_name'])) $first_eoc_chemos_from_participant_id[$studied_participant_id]['0']['qc_tf_coeur_chemo_drugs'][] = $new_res['Drug']['generic_name'];
				}
			}
		}
		
		// *********** Get first Progression ***********
		
		$first_progression_from_participant_id = array();
		if($eoc_primary_ids) {
			$sql =
				"SELECT DISTINCT
					DiagnosisMaster.id,
					DiagnosisMaster.primary_id,
					DiagnosisMaster.participant_id,
					DiagnosisMaster.dx_date,
					DiagnosisMaster.dx_date_accuracy
				FROM diagnosis_masters AS DiagnosisMaster
				WHERE DiagnosisMaster.diagnosis_control_id = 16 AND DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.primary_id <> 1 AND DiagnosisMaster.primary_id IN (".implode(',',$eoc_primary_ids).")
				ORDER BY DiagnosisMaster.primary_id ASC, DiagnosisMaster.dx_date ASC";
			$eoc_progression_results = $this->Report->tryCatchQuery($sql);
			foreach($eoc_progression_results as $new_res) {
				$studied_participant_id = $new_res['DiagnosisMaster']['participant_id'];
				if(!isset($first_progression_from_participant_id[$studied_participant_id])) {
					$first_progression_from_participant_id[$studied_participant_id] = $new_res;
				}
			}
		}
		
		// *********** Get other DX ***********
		
		$other_dx_from_participant_id = array();
		if($participant_ids) {
			$sql =
				"SELECT DISTINCT
					DiagnosisMaster.participant_id,
					DiagnosisMaster.dx_date,
					DiagnosisMaster.dx_date_accuracy,
					DiagnosisMaster.qc_tf_tumor_site
				FROM diagnosis_masters AS DiagnosisMaster
				WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id = 15 AND DiagnosisMaster.participant_id IN (".implode(',',$participant_ids).")
				ORDER BY DiagnosisMaster.participant_id, DiagnosisMaster.dx_date ASC;";
			$other_dx_results = $this->Report->tryCatchQuery($sql);
			foreach($other_dx_results as $new_res) {
				$studied_participant_id = $new_res['DiagnosisMaster']['participant_id'];
				if(!isset($other_dx_from_participant_id[$studied_participant_id])) $other_dx_from_participant_id[$studied_participant_id] = array();
				if(sizeof($other_dx_from_participant_id[$studied_participant_id]) < 4) {
					$other_dx_from_participant_id[$studied_participant_id][] = $new_res;
				}
			}
		}
		
		// *********** Merge all data ***********

		$progression_warnings = array();
		foreach($main_results as &$new_participant) {
			$studied_participant_id = $new_participant['Participant']['participant_id'];
			$new_participant['0'] = array(
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
				'qc_tf_coeur_other_dx_tumor_date_3' => '');
			if(isset($first_eoc_chemos_from_participant_id[$studied_participant_id])) {			
				$new_participant['0']['qc_tf_coeur_end_of_first_chemo'] = $this->tmpFormatdate($first_eoc_chemos_from_participant_id[$studied_participant_id]['TreatmentMaster']['finish_date'], $first_eoc_chemos_from_participant_id[$studied_participant_id]['TreatmentMaster']['finish_date_accuracy']);
				$new_participant['0']['qc_tf_coeur_end_of_first_chemo_accuracy'] = $first_eoc_chemos_from_participant_id[$studied_participant_id]['TreatmentMaster']['finish_date_accuracy'];
				$new_participant['0']['qc_tf_coeur_chemo_drugs'] = implode(', ',array_filter($first_eoc_chemos_from_participant_id[$studied_participant_id]['0']['qc_tf_coeur_chemo_drugs']));	
			}
			if(isset($first_progression_from_participant_id[$studied_participant_id])) {
				$new_participant['0']['qc_tf_coeur_first_progression_date'] = $this->tmpFormatdate($first_progression_from_participant_id[$studied_participant_id]['DiagnosisMaster']['dx_date'], $first_progression_from_participant_id[$studied_participant_id]['DiagnosisMaster']['dx_date_accuracy']);
				if(!empty($new_participant['0']['qc_tf_coeur_end_of_first_chemo']) && !empty($first_progression_from_participant_id[$studied_participant_id]['DiagnosisMaster']['dx_date'])) {
					if(in_array($new_participant['0']['qc_tf_coeur_end_of_first_chemo_accuracy'].$first_progression_from_participant_id[$studied_participant_id]['DiagnosisMaster']['dx_date_accuracy'], array('cc'/*, 'cd', 'dc'*/))) {
						$first_chemo_date = new DateTime($new_participant['0']['qc_tf_coeur_end_of_first_chemo']);
						$first_progression_date = new DateTime($first_progression_from_participant_id[$studied_participant_id]['DiagnosisMaster']['dx_date']);
						$interval = $first_chemo_date->diff($first_progression_date);			
						if($interval->invert) {
							$progression_warnings['unable to calculate first chemo to first progression because dates are not chronological'][] = $new_participant['Participant']['participant_identifier'];
						} else {
							$new_participant['0']['qc_tf_coeur_first_first_chemo_to_first_progression_months'] = $interval->y*12 + $interval->m;
						}
					} else {
						$progression_warnings['unable to calculate first chemo to first progression with at least one unaccuracy date'][] = $new_participant['Participant']['participant_identifier'];
					}
				}
			}
			if(isset($other_dx_from_participant_id[$studied_participant_id])) {
				$id = 0;
				foreach($other_dx_from_participant_id[$studied_participant_id] as $new_other_dx) {
					$id++;
					$new_participant['0']['qc_tf_coeur_other_dx_tumor_site_'.$id] = $new_other_dx['DiagnosisMaster']['qc_tf_tumor_site'];
					$new_participant['0']['qc_tf_coeur_other_dx_tumor_date_'.$id] = $this->tmpFormatdate($new_other_dx['DiagnosisMaster']['dx_date'], $new_other_dx['DiagnosisMaster']['dx_date_accuracy']);
				}
			}
			if(($_SESSION['Auth']['User']['group_id'] != '1') && ($new_participant['Participant']['qc_tf_bank_id'] != $user_bank_id)) {
				$new_participant['Participant']['qc_tf_bank_identifier'] = CONFIDENTIAL_MARKER;
				$new_participant['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
			}
		}
		
		foreach($progression_warnings as $msg => $patient_ids) $warnings[] = __($msg).' - See TFRI# : '.implode(', ', $patient_ids);
		foreach($warnings as $new_warning) AppController::addWarningMsg($new_warning);
		
		if($csv_order_for_display) {
			list($model_for_order,$field_for_order) = explode('.',$csv_order_for_display['field']);
			$main_results_sorted_per_key = array();
			$empty_result = array();
			foreach($main_results as $new_result) {
				$csv_key = $new_result[$model_for_order][$field_for_order];
				$main_results_sorted_per_key[$csv_key][] = $new_result;
				$empty_result = $new_result;
			}
			foreach($empty_result as &$model_result) foreach($model_result as &$result) $result = '';
			$empty_result['Participant']['participant_id'] = '-1'; 
			$main_results = array();
			$values_assigned_to_many_patients = array();
			foreach($csv_order_for_display['order'] as $next_key) {
				if(array_key_exists($next_key, $main_results_sorted_per_key)) {
					if(sizeof($main_results_sorted_per_key[$next_key]) > 1) $values_assigned_to_many_patients[$next_key] = $next_key;
					foreach($main_results_sorted_per_key[$next_key] as $new_result) $main_results[] = $new_result;
				} else {
					$main_results[] = $empty_result;
				}
			}
			if($values_assigned_to_many_patients) AppController::addWarningMsg(__('following values are assigned to many patients').' : '.implode(', ', $values_assigned_to_many_patients));
		}
		
		$array_to_return = array(
			'header' => array(), 
			'data' => $main_results, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}	
	
	function tmpFormatdate($value, $accuracy) {
		if($value && $accuracy) {
			switch($accuracy){
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
					$value = '±'.substr($value, 0, 4);
					break;
				default:
					break;
			}
		}
		return $value;
	}
}