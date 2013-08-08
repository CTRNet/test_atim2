<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = 'DiagnosisMaster';
	var $useTable = 'diagnosis_masters';
	
	var $ovcareIsDxDeletion = false;
	
	function atimDelete($model_id, $cascade = true){
		$dx_to_delete = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $model_id), 'recursive' => '0'));
		if(parent::atimDelete($model_id, $cascade)){
			if($dx_to_delete['DiagnosisControl']['category'] == 'recurrence') {
				$this->updateCalculatedFields($dx_to_delete['DiagnosisMaster']['participant_id']);
			}
			return true;
		}
		return false;
	}
	
	function updateCalculatedFields($participant_id) {
		// MANAGE OVARY DIAGNOSIS CALCULATED FIELDS
		$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		
		// Get Participant Data
		
		$particpant_data = $Participant->find('first', array('conditions' => array('Participant.id' => $participant_id), 'recursive' => '-1'));
		$ovcare_last_followup_date = $particpant_data['Participant']['ovcare_last_followup_date'];
		$ovcare_last_followup_date_accuracy = $particpant_data['Participant']['ovcare_last_followup_date_accuracy'];
		
		// Get & work on all Ovary Diagnoses
		
		$conditions = array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'ovary');
		$all_ovary_diagnoses = $this->find('all', array('conditions' => $conditions, 'recursive' => '0'));
		foreach($all_ovary_diagnoses as $new_dx) {
			$diagnosis_master_id = $new_dx['DiagnosisMaster']['id'];
			$participant_id = $new_dx['DiagnosisMaster']['participant_id'];
			$diagnosis_control_id = $new_dx['DiagnosisControl']['id'];
			
			$initial_surgery_date = $new_dx['DiagnosisDetail']['initial_surgery_date'];
			$initial_surgery_date_accuracy = $new_dx['DiagnosisDetail']['initial_surgery_date_accuracy'];
			$new_initial_surgery_date = '';
			$new_initial_surgery_date_accuracy = '';
			$existing_empty_surgery_date = false;
						
			$initial_recurrence_date = $new_dx['DiagnosisDetail']['initial_recurrence_date'];
			$initial_recurrence_date_accuracy = $new_dx['DiagnosisDetail']['initial_recurrence_date_accuracy'];
			$new_initial_recurrence_date = '';
			$new_initial_recurrence_date_accuracy = '';
			$existing_empty_recurrence_date = false;
			
			$progression_free_time_months = $new_dx['DiagnosisDetail']['progression_free_time_months'];
			$progression_free_time_months_precision = $new_dx['DiagnosisDetail']['progression_free_time_months_precision'];
			$new_progression_free_time_months = '';
			$new_progression_free_time_months_precision = 'missing information';
				
			$survival_time_months = $new_dx['DiagnosisMaster']['survival_time_months'];
			$survival_time_months_precision = $new_dx['DiagnosisMaster']['survival_time_months_precision'];
			$new_survival_time_months = '';
			$new_survival_time_months_precision = 'missing information';
			
			//Get recurrences + all diagnosis_master_ids linked to the tumor group
			
			$linked_ovary_diagnoses = $this->find('all', array(
				'conditions' => array('DiagnosisMaster.primary_id' => $diagnosis_master_id),
				'order' => array('DiagnosisMaster.dx_date ASC'),
				'fields' => array('DiagnosisMaster.id', 'DiagnosisMaster.dx_date', 'DiagnosisMaster.dx_date_accuracy', 'DiagnosisControl.category'), 
				'recursive' => '0'));
			$linked_ovary_diagnosis_master_ids = array();
			foreach($linked_ovary_diagnoses as $linked_dx) {
				// Get all linked diagnosis ids
				$linked_ovary_diagnosis_master_ids[] = $linked_dx['DiagnosisMaster']['id'];
				// Manage recurrences date
				if($linked_dx['DiagnosisControl']['category'] == 'recurrence') {
					if(empty($linked_dx['DiagnosisMaster']['dx_date'])) {
						$existing_empty_recurrence_date = true;
					} else if(empty($new_initial_recurrence_date)) {
						$new_initial_recurrence_date = $linked_dx['DiagnosisMaster']['dx_date'];
						$new_initial_recurrence_date_accuracy = $linked_dx['DiagnosisMaster']['dx_date_accuracy'];
					}
				}
			}
			
			// Get surgeries
			
			$linked_surgeries = $TreatmentMaster->find('all', array(
				'conditions' => array('TreatmentMaster.diagnosis_master_id' => $linked_ovary_diagnosis_master_ids, 'TreatmentControl.tx_method' => 'procedure - surgery biopsy'),
				'order' => array('TreatmentMaster.start_date ASC'),
				'fields' => array('TreatmentMaster.id', 'TreatmentMaster.start_date', 'TreatmentMaster.start_date_accuracy'), 
				'recursive' => '0'));			
			foreach($linked_surgeries as $new_surgery) {						
				if(empty($new_surgery['TreatmentMaster']['start_date'])) {
					$existing_empty_surgery_date = true;
				} else if(empty($new_initial_surgery_date)) {
					$new_initial_surgery_date = $new_surgery['TreatmentMaster']['start_date'];
					$new_initial_surgery_date_accuracy = $new_surgery['TreatmentMaster']['start_date_accuracy'];
				}				
			}
			
			// Calculate new value
			
			if($new_initial_surgery_date) {
				if($ovcare_last_followup_date) {
					$initialSurgeryDateObj = new DateTime($new_initial_surgery_date);
					$lastFollDateObj = new DateTime($ovcare_last_followup_date);
					$interval = $initialSurgeryDateObj->diff($lastFollDateObj);
					$new_survival_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');				
					if($new_survival_time_months < 0) {
						$new_survival_time_months = '';
						$new_survival_time_months_precision = "date error";
						AppController::addWarningMsg(str_replace('%%field%%', __('survival time months'), __('error in the dates definitions: the field [%%field%%] can not be generated')));
					} else if(!(in_array($new_initial_surgery_date_accuracy, array('c')) && in_array($ovcare_last_followup_date_accuracy, array('c')))) {
						$new_survival_time_months_precision = "approximate";
					} else if($existing_empty_surgery_date) {
						$new_survival_time_months_precision = "some surgery dates empty";
					} else {
						$new_survival_time_months_precision = "exact";
					}
				}
				if($new_initial_recurrence_date) {
					$initialSurgeryDateObj = new DateTime($new_initial_surgery_date);
					$initialRecurrenceDateObj = new DateTime($new_initial_recurrence_date);
					$interval = $initialSurgeryDateObj->diff($initialRecurrenceDateObj);
					$new_progression_free_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');
					if($new_progression_free_time_months < 0) {
						$new_progression_free_time_months = '';
						$new_progression_free_time_months_precision = "date error";
						AppController::addWarningMsg(str_replace('%%field%%', __('progression free time months'), __('error in the dates definitions: the field [%%field%%] can not be generated')));
					} else if(!in_array($new_initial_surgery_date_accuracy, array('c')) || !in_array($new_initial_recurrence_date_accuracy, array('c'))) {
						$new_progression_free_time_months_precision = "approximate";
					} else if($existing_empty_recurrence_date) {
						$new_progression_free_time_months_precision = "some recurrence dates empty";
					} else {
						$new_progression_free_time_months_precision = "exact";
					}					
				}
			}
			
			// Data to update
			
			$data_to_update = array();
			if($new_survival_time_months != $survival_time_months) $data_to_update['DiagnosisMaster']['survival_time_months'] = empty($new_survival_time_months)? "" : $new_survival_time_months; 
			if($new_survival_time_months_precision != $survival_time_months_precision) $data_to_update['DiagnosisMaster']['survival_time_months_precision'] = $new_survival_time_months_precision;
			if($new_initial_surgery_date != $initial_surgery_date) $data_to_update['DiagnosisDetail']['initial_surgery_date'] = $new_initial_surgery_date;
			if($new_initial_surgery_date_accuracy != $initial_surgery_date_accuracy) $data_to_update['DiagnosisDetail']['initial_surgery_date_accuracy'] = $new_initial_surgery_date_accuracy;
			if($new_initial_recurrence_date != $initial_recurrence_date) $data_to_update['DiagnosisDetail']['initial_recurrence_date'] = $new_initial_recurrence_date;
			if($new_initial_recurrence_date_accuracy != $initial_recurrence_date_accuracy) $data_to_update['DiagnosisDetail']['initial_recurrence_date_accuracy'] = $new_initial_recurrence_date_accuracy;
			if($new_progression_free_time_months != $progression_free_time_months) $data_to_update['DiagnosisDetail']['progression_free_time_months'] = empty($new_progression_free_time_months)? "" : $new_progression_free_time_months;
			if($new_progression_free_time_months_precision != $progression_free_time_months_precision) $data_to_update['DiagnosisDetail']['progression_free_time_months_precision'] = $new_progression_free_time_months_precision;
			if($data_to_update) {			
				$this->data = array();
				$this->id = $diagnosis_master_id;
				$data_to_update['DiagnosisMaster']['id'] = $diagnosis_master_id;
				$this->check_writable_fields = false;
				if(!$this->save($data_to_update)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}						
		}
	}
	
}
?>