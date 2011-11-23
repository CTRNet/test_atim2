<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';
	
	function beforeSave($options) {
		
		// Check $this->data has been populated from screen and not from Participant.beforeSave() function	
		if(!array_key_exists('ovcare_age_at_surgery', $this->data['TreatmentDetail'])) {
			
			$previous_treatment_data = null;
			$participant_id = array_key_exists('participant_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['participant_id'] : null;
			$treatment_control_id = array_key_exists('treatment_control_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['treatment_control_id'] : null;
			if(is_null($participant_id) || is_null($treatment_control_id)) {
				// Trt update
				$previous_treatment_data = $this->find('first', array('conditions' => array ('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));
				if(empty($previous_treatment_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$participant_id = $previous_treatment_data['TreatmentMaster']['participant_id'];	
				$treatment_control_id = $previous_treatment_data['TreatmentMaster']['treatment_control_id'];	
			}
	
			$tx_control_model = AppModel::getInstance("Clinicalannotation", "TreatmentControl", true);
			$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => $treatment_control_id)));
			if(empty($tx_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			// AGE AT SURGERY
			
			if(($tx_control_data['TreatmentControl']['disease_site'] == 'ovcare') && ($tx_control_data['TreatmentControl']['tx_method'] == 'surgery')) {
				$previous_surgery_date = is_null($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['start_date'];
				$surgery_date = $this->data['TreatmentMaster']['start_date'];
				
				if(is_null($previous_surgery_date) || ($surgery_date != $previous_surgery_date)) {
					
					// Set ovcare_age_at_surgery
	
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
			}
		}

		return true;
	}
}
?>