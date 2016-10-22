<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	
	function validatesTreatmentToDiagnosisLink($treatment_master_data, $treatment_control_data){
		
		$submitted_data_validates = true;
		if(!isset($treatment_master_data['diagnosis_master_id']) || !$treatment_master_data['diagnosis_master_id']) {
			$this->validationErrors['diagnosis_master_id'][] = __('a diagnosis should be selected');
			$submitted_data_validates = false;
		} else {
			$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
			$selected_dx = $DiagnosisMaster->find('first', array('conditions'=> array('DiagnosisMaster.id' => $treatment_master_data['diagnosis_master_id']), 'recursive' => '0'));
			switch($treatment_control_data['tx_method']) {
				case 'chemotherapy':
				case 'hormonotherapy':
				case 'immunotherapy':
				case 'bone specific therapy':
				case 'radiotherapy':
				case 'breast diagnostic event':
					if($selected_dx['DiagnosisControl']['controls_type'] != 'breast') {
						$this->validationErrors['diagnosis_master_id'][] = __('this treatment can not be linked to this type of diagnosis');
						$submitted_data_validates = false;
					}
					break;
				case 'other cancer':
					if($selected_dx['DiagnosisControl']['controls_type'] != 'other cancer') {
						$this->validationErrors['diagnosis_master_id'][] = __('this treatment can not be linked to this type of diagnosis');
						$submitted_data_validates = false;
					}
					break;
				default:
					AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}
		return $submitted_data_validates;
	}
	
	function beforeSave($options = array()){
		if(array_key_exists('TreatmentDetail', $this->data) && array_key_exists('her2_fish', $this->data['TreatmentDetail'])) {
			
			$her2_fish = $this->data['TreatmentDetail']['her2_fish'];
			$her2_ihc = $this->data['TreatmentDetail']['her2_ihc'];
			$er_overall = $this->data['TreatmentDetail']['er_overall'];
			$pr_overall = $this->data['TreatmentDetail']['pr_overall'];
			
			// TNBC
			$her_2_status = '';
			switch($her2_fish) {
				case 'positive':
					$her_2_status = 'positive';
					break;
				case 'negative':
					$her_2_status = 'negative';
					break;
				case 'equivocal':
					if($her2_ihc == 'positive') $her_2_status = 'positive';
					if($her2_ihc == 'negative') $her_2_status = 'equivocal';
					break;
				case 'unknown':
					if($her2_ihc == 'positive') $her_2_status = 'positive';
					if($her2_ihc == 'negative') $her_2_status = 'negative';
			}
			
			// HER2 Status
			$tnbc = '';
			if($her_2_status == 'negative' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
				$tnbc = 'yes';
			} else if($her_2_status == 'positive' || $er_overall == 'positive' || $pr_overall == 'positive' ) {
				$tnbc = 'no';
			} else if($her_2_status == 'unknown' || $er_overall == 'unknown' || $pr_overall == 'unknown' ) {
				$tnbc = 'unknown';
			} else if($her_2_status == 'equivocal' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
				$tnbc = 'equivocal';
			}

			$this->data['TreatmentDetail']['tnbc'] = $tnbc;
			$this->data['TreatmentDetail']['her_2_status'] = $her_2_status;
			$this->addWritableField(array('tnbc', 'her_2_status'));
		}
		$ret_val = parent::beforeSave($options);
		
		return $ret_val; 
	}
	
	/**
	 * For each 'breast diagnostic event' treatment (breast biopsy or surgery), this function will calculate:
	 *   - The time from the treatment to the last participant contact.
	 *   - The time to the next 'breast progression' diagnosis based on date.
	 *    
	 * @param integer $participant_id Id fo the participant.
	 */
	function calculateTimesTo($participant_id) {	
		//================================================================================================================================================================
		// Diagnosis & treatment reminder :
		//  - Only one breast primary diagnosis can be created per participant.
		//  - A 'breast diagnostic event' treatment can only be created for a breast primary diagnosis.
		//  - A 'breast progression' can only be created for a breast primary diagnosis.
		//  - So all 'breast diagnostic event' and 'breast progression' of one participant will be linked to the same breast primary diagnosis.
		//================================================================================================================================================================
		
		$conditions = array(
			'TreatmentMaster.deleted != 1',
			'TreatmentControl.tx_method' => 'breast diagnostic event',
			'TreatmentMaster.participant_id' => $participant_id
		);
		$all_breast_tx_diagnosis_event = $this->find('all', array('conditions'=>$conditions, 'recursive' => '0'));
		
		if(!$all_breast_tx_diagnosis_event) return;
		
		$all_warnings = array();
		
		// Get participant last contact or death
		$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$participant = $participant_model->getOrRedirect($participant_id);
		$last_contact_or_death_date = '';
		$last_contact_or_death_date_accuracy = '';
		if(!empty($participant['Participant']['date_of_death'])) {
			$last_contact_or_death_date = $participant['Participant']['date_of_death'];
			$last_contact_or_death_date_accuracy = $participant['Participant']['date_of_death_accuracy'];
		} else if(!empty($participant['Participant']['qbcf_suspected_date_of_death'])) {
			$last_contact_or_death_date = $participant['Participant']['qbcf_suspected_date_of_death'];
			$last_contact_or_death_date_accuracy = $participant['Participant']['qbcf_suspected_date_of_death_accuracy'];
		}else if(!empty($participant['Participant']['qbcf_last_contact'])) {
			$last_contact_or_death_date = $participant['Participant']['qbcf_last_contact'];
			$last_contact_or_death_date_accuracy = $participant['Participant']['qbcf_last_contact_accuracy'];
		} 
		if(empty($last_contact_or_death_date)) $all_warnings["the last contact or death date is unknown - the 'time to last contact' values cannot be calculated"] = array();
		
		// Check all progression dates are set
		$conditions = array(
			'DiagnosisMaster.deleted != 1',
			'DiagnosisControl.category' => 'secondary - distant',
			'DiagnosisControl.controls_type' => 'breast progression',
			'DiagnosisMaster.participant_id' => $participant_id,
			"DiagnosisMaster.dx_date IS NULL"
		);
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		$progression_with_no_date = $DiagnosisMaster->find('count', array('conditions'=>$conditions, 'recursive' => '0'));
		if($progression_with_no_date) $all_warnings["at least one breast progression diagnosis date is unknown"] = array(); 
		
		foreach($all_breast_tx_diagnosis_event as $new_breast_tx) {
			$new_time_to_last_contact_months = '';
			$new_time_to_first_progression_months = '';
			if($new_breast_tx['TreatmentMaster']['start_date']) {
				$start_date = $new_breast_tx['TreatmentMaster']['start_date'];
				$start_date_accuracy = $new_breast_tx['TreatmentMaster']['start_date_accuracy'];
				$start_date_ob = new DateTime($start_date);
				// Time To Last Contcat
				if(!empty($last_contact_or_death_date)) {
					if(in_array($start_date_accuracy.$last_contact_or_death_date_accuracy, array('cc', 'cd', 'dc'))) {
						if($start_date_accuracy.$last_contact_or_death_date_accuracy != 'cc') $all_warnings["'time to last contact' has been calculated with at least one unaccuracy date"][$start_date] = $start_date;
						$end_date_ob = new DateTime($last_contact_or_death_date);
						$interval = $start_date_ob->diff($end_date_ob);
						if($interval->invert) {
							$all_warnings["'time to last contact' cannot be calculated because dates are not chronological"][$start_date] = $start_date;
						} else {
							$new_time_to_last_contact_months = $interval->y*12 + $interval->m;
						}
					} else {
						$all_warnings["'time to last contact' cannot be calculated on inaccurate dates"][$start_date] = $start_date;
					}
				}
				// Time to first progression
				$conditions = array(
					'DiagnosisMaster.deleted != 1',
					'DiagnosisControl.category' => 'secondary - distant',
					'DiagnosisControl.controls_type' => 'breast progression',
					'DiagnosisMaster.participant_id' => $participant_id,
					'DiagnosisMaster.parent_id' => $new_breast_tx['TreatmentMaster']['diagnosis_master_id'],
					"DiagnosisMaster.dx_date IS NOT NULL",
					"DiagnosisMaster.dx_date >= '".$start_date."'"
				);
				$first_progression = $DiagnosisMaster->find('first', array('conditions'=>$conditions, 'recursive' => '0', 'order' => array('DiagnosisMaster.dx_date ASC')));
				if($first_progression) {
					$first_progression_date = $first_progression['DiagnosisMaster']['dx_date'];
					$first_progression_date_accuracy = $first_progression['DiagnosisMaster']['dx_date_accuracy'];
					if(in_array($start_date_accuracy.$first_progression_date_accuracy, array('cc', 'cd', 'dc'))) {
						if($start_date_accuracy.$first_progression_date_accuracy != 'cc') $all_warnings["'time to first progression' has been calculated with at least one unaccuracy date"][$start_date] = $start_date;
						$end_date_ob = new DateTime($first_progression_date);
						$interval = $start_date_ob->diff($end_date_ob);
						if($interval->invert) {
							$all_warnings["'time to first progression' cannot be calculated because dates are not chronological"][$start_date] = $start_date;
						} else {
							$new_time_to_first_progression_months = $interval->y*12 + $interval->m;
						}
					} else {
						$all_warnings["'time to first progression' cannot be calculated on inaccurate dates"][$start_date] = $start_date;
					}
				}
			} else {
				$all_warnings["at least one breast diagnostic event date is unknown - the 'time to' values cannot be calculated for 'un-dated' event"] = array();
			}
			//Update data
			$treatment_detail_to_update = array();
			if($new_time_to_last_contact_months != $new_breast_tx['TreatmentDetail']['time_to_last_contact_months']) $treatment_detail_to_update['time_to_last_contact_months'] = $new_time_to_last_contact_months;
			if($new_time_to_first_progression_months != $new_breast_tx['TreatmentDetail']['time_to_first_progression_months']) $treatment_detail_to_update['time_to_first_progression_months'] = $new_time_to_first_progression_months;
			if($treatment_detail_to_update) {
				$this->data = array();
				$this->id = $new_breast_tx['TreatmentMaster']['id'];
				if(!$this->save(array('TreatmentMaster' => array(), 'TreatmentDetail' => $treatment_detail_to_update))) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );					
			}
		}
		foreach($all_warnings as $new_warning => $all_start_dates) AppController::getInstance()->addWarningMsg(__($new_warning).($all_start_dates? ' - '.str_replace('%s', implode(', ', $all_start_dates), __('see treatment done on %s')) : ''));
	}
}
			
?>