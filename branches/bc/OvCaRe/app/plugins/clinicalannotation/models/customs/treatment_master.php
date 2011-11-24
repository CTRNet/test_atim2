<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';
	
	function beforeSave($options) {
		
		if(array_key_exists('start_date', $this->data['TreatmentMaster'])) { 
			// User just clicked on submit button of Treatment form
			
			$participant_id = array_key_exists('participant_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['participant_id'] : null;
			$treatment_control_id = array_key_exists('treatment_control_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['treatment_control_id'] : null;
			$previous_treatment_data =  array();
			$tx_control_data = array();
			
			if(is_null($participant_id) || is_null($treatment_control_id)) {
				// Trt is updated
				$previous_treatment_data = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '0'));
				if(empty($previous_treatment_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$participant_id = $previous_treatment_data['TreatmentMaster']['participant_id'];	
				$treatment_control_id = $previous_treatment_data['TreatmentMaster']['treatment_control_id'];
				$tx_control_data['TreatmentControl'] = $previous_treatment_data['TreatmentControl'];
			}
			
			if(empty($tx_control_data)) {
				$tx_control_model = AppModel::getInstance("Clinicalannotation", "TreatmentControl", true);
				$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => $treatment_control_id)));
				if(empty($tx_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			if(($tx_control_data['TreatmentControl']['disease_site'] == 'ovcare') && ($tx_control_data['TreatmentControl']['tx_method'] == 'surgery')) {	
				
				// *** SET AGE AT SURGERY ***
					
				$previous_surgery_date = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['start_date'];
				$surgery_date = $this->data['TreatmentMaster']['start_date'];
				
				if(is_null($previous_surgery_date) || ($surgery_date != $previous_surgery_date)) {
					$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
					$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));
					if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$date_of_birth = $participant_data['Participant']['date_of_birth'];
		
					$ageInYears = null;
					if(!empty($surgery_date) && !empty($date_of_birth)) {
						$birthDateObj = new DateTime($date_of_birth);
						$surgDateObj = new DateTime($surgery_date);
						$interval = $birthDateObj->diff($surgDateObj);
						$ageInYears = $interval->format('%r%y');
						if($ageInYears < 0) {
							$ageInYears = null;
							AppController::addWarningMsg(str_replace('%%field%%', __('age at surgery',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
						}
					}
					$this->data['TreatmentDetail']['ovcare_age_at_surgery'] = $ageInYears;
				}
				
				// Set Data For Diagnosis Update
				
				$this->data['OvcareFunctionManagement']['previous_diagnosis_master_id'] = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['diagnosis_master_id'];
				$this->data['OvcareFunctionManagement']['diagnosis_master_id'] = $this->data['TreatmentMaster']['diagnosis_master_id'];
			}
		}
		
		return true;
	}
	
	function afterSave() {					
		if(array_key_exists('OvcareFunctionManagement', $this->data)) {
			// *** LAUNCH INITIAL DIAGNOSIS SURGERY DATE RECORD ***
			$previous_diagnosis_master_id = $this->data['OvcareFunctionManagement']['previous_diagnosis_master_id'];
			$diagnosis_master_id = $this->data['OvcareFunctionManagement']['diagnosis_master_id'];
			unset($this->data['OvcareFunctionManagement']);
			$diagnosis_master_model = AppModel::getInstance("Clinicalannotation", "DiagnosisMaster", true);
			if(!empty($previous_diagnosis_master_id) && $previous_diagnosis_master_id != $diagnosis_master_id) $diagnosis_master_model->setInitialSurgeryDate($previous_diagnosis_master_id);
			if(!empty($diagnosis_master_id)) $diagnosis_master_model->setInitialSurgeryDate($diagnosis_master_id);
		}
	}		
			
}
?>