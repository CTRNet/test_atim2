<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function summary( $diagnosis_master_id = null ) {
		$return = false;
		if ( !is_null($diagnosis_master_id) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id), 'recursive' => 0));
				
			$structure_alias = 'diagnosismasters';
				
			$return = array(
					'menu' 				=> array(NULL, __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' 			=> array(NULL,  __($result['DiagnosisControl']['controls_type'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> $structure_alias
			);
				
		}
		return $return;
	}
	
	function beforeSave($options = array()){
		if(array_key_exists('DiagnosisMaster', $this->data) && array_key_exists('parent_id', $this->data['DiagnosisMaster']) && $this->data['DiagnosisMaster']['parent_id']) 
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if(array_key_exists('DiagnosisDetail', $this->data) && array_key_exists('her2_fish', $this->data['DiagnosisDetail'])) {
			
			$her2_fish = $this->data['DiagnosisDetail']['her2_fish'];
			$her2_ihc = $this->data['DiagnosisDetail']['her2_ihc'];
			$er_overall = $this->data['DiagnosisDetail']['er_overall'];
			$pr_overall = $this->data['DiagnosisDetail']['pr_overall'];
			
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

			$this->data['DiagnosisDetail']['tnbc'] = $tnbc;
			$this->data['DiagnosisDetail']['her_2_status'] = $her_2_status;
			$this->addWritableField(array('tnbc', 'her_2_status'));
		}
		$ret_val = parent::beforeSave($options);
		return $ret_val; 
	}
	
	function calculateTimesTo($participant_id) {		
		$conditions = array(
			'DiagnosisMaster.deleted != 1',
			'DiagnosisControl.category' => 'primary',
			'DiagnosisControl.controls_type' => 'breast',
			'DiagnosisMaster.participant_id' => $participant_id
		);
		$this->unbindModel(array('hasMany' => array('Collection')));
		$all_breast_dx = $this->find('all', array('conditions'=>$conditions, 'recursive' => '0'));
		
		if(!$all_breast_dx) return;
		
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
			'DiagnosisControl.category' => 'primary',
			'DiagnosisControl.controls_type' => 'breast progression',
			'DiagnosisMaster.participant_id' => $participant_id,
			"DiagnosisMaster.dx_date IS NULL"
		);
		$progression_with_no_date = $this->find('count', array('conditions'=>$conditions, 'recursive' => '0'));pr("$progression_with_no_date?");
		if($progression_with_no_date) $all_warnings["at least one breast progression diagnosis date is unknown"] = array(); 
		
		foreach($all_breast_dx as $new_breast_dx) {
			$new_time_to_last_contact_months = '';
			$new_time_to_first_progression_months = '';
			if($new_breast_dx['DiagnosisMaster']['dx_date']) {
				$dx_date = $new_breast_dx['DiagnosisMaster']['dx_date'];
				$dx_date_accuracy = $new_breast_dx['DiagnosisMaster']['dx_date_accuracy'];
				$dx_date_ob = new DateTime($dx_date);
				// Time To Last Contcat
				if(!empty($last_contact_or_death_date)) {
					if(in_array($dx_date_accuracy.$last_contact_or_death_date_accuracy, array('cc', 'cd', 'dc'))) {
						if($dx_date_accuracy.$last_contact_or_death_date_accuracy != 'cc') $all_warnings["'time to last contact' has been calculated with at least one unaccuracy date"][$dx_date] = $dx_date;
						$end_date_ob = new DateTime($last_contact_or_death_date);
						$interval = $dx_date_ob->diff($end_date_ob);
						if($interval->invert) {
							$all_warnings["'time to last contact' cannot be calculated because dates are not chronological"][$dx_date] = $dx_date;
						} else {
							$new_time_to_last_contact_months = $interval->y*12 + $interval->m;
						}
					} else {
						$all_warnings["'time to last contact' cannot be calculated on inaccurate dates"][$dx_date] = $dx_date;
					}
				}
				// Time to first progression
				$conditions = array(
					'DiagnosisMaster.deleted != 1',
					'DiagnosisControl.category' => 'primary',
					'DiagnosisControl.controls_type' => 'breast progression',
					'DiagnosisMaster.participant_id' => $participant_id,
					"DiagnosisMaster.dx_date IS NOT NULL",
					"DiagnosisMaster.dx_date >= '".$dx_date."'"
				);
				$first_progression = $this->find('first', array('conditions'=>$conditions, 'recursive' => '0', 'order' => array('DiagnosisMaster.dx_date ASC')));
				if($first_progression) {
					$first_progression_date = $first_progression['DiagnosisMaster']['dx_date'];
					$first_progression_date_accuracy = $first_progression['DiagnosisMaster']['dx_date_accuracy'];
					if(in_array($dx_date_accuracy.$first_progression_date_accuracy, array('cc', 'cd', 'dc'))) {
						if($dx_date_accuracy.$first_progression_date_accuracy != 'cc') $all_warnings["'time to first progression' has been calculated with at least one unaccuracy date"][$dx_date] = $dx_date;
						$end_date_ob = new DateTime($first_progression_date);
						$interval = $dx_date_ob->diff($end_date_ob);
						if($interval->invert) {
							$all_warnings["'time to first progression' cannot be calculated because dates are not chronological"][$dx_date] = $dx_date;
						} else {
							$new_time_to_first_progression_months = $interval->y*12 + $interval->m;
						}
					} else {
						$all_warnings["'time to first progression' cannot be calculated on inaccurate dates"][$dx_date] = $dx_date;
					}
				}
				//Update data
				$diagnosis_detail_to_update = array();
				if($new_time_to_last_contact_months != $new_breast_dx['DiagnosisDetail']['time_to_last_contact_months']) $diagnosis_detail_to_update['time_to_last_contact_months'] = $new_time_to_last_contact_months;
				if($new_time_to_first_progression_months != $new_breast_dx['DiagnosisDetail']['time_to_first_progression_months']) $diagnosis_detail_to_update['time_to_first_progression_months'] = $new_time_to_first_progression_months;
				if($diagnosis_detail_to_update) {
					$this->data = array();
					$this->id = $new_breast_dx['DiagnosisMaster']['id'];
					if(!$this->save(array('DiagnosisMaster' => array(), 'DiagnosisDetail' => $diagnosis_detail_to_update))) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );					
				}
			} else {
				$all_warnings["at least one breast diagnosis date is unknown - the 'time to' values cannot be calculated for 'un-dated' diagnosis"] = array();
			}
		}
		foreach($all_warnings as $new_warning => $all_dx_dates) AppController::getInstance()->addWarningMsg(__($new_warning).($all_dx_dates? ' - '.str_replace('%s', implode(', ', $all_dx_dates), __('see diagnosis done on %s')) : ''));
	}
}
			
?>