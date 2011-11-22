<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';
	
	function beforeSave($options) {
		$tx_control_model = AppModel::getInstance("Clinicalannotation", "TreatmentControl", true);
		$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => 7)));

		if(($tx_control_data['TreatmentControl']['disease_site'] == 'ovcare') && ($tx_control_data['TreatmentControl']['tx_method'] == 'surgery')) {
			$surgery_date = $this->data['TreatmentMaster']['start_date'];
			
			$participant_id = null;
			if(array_key_exists('participant_id', $this->data['TreatmentMaster'])) {	
				$participant_id = $this->data['TreatmentMaster']['participant_id'];
			} else {
				$db_trt_data = $this->find('first', array('conditions' => array ('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));	
				$participant_id = $db_trt_data['TreatmentMaster']['participant_id'];
			}
			
			$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
			$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));
			$date_of_brith = $participant_data['Participant']['date_of_birth'];

			$ageInYears = null;
			if(!empty($surgery_date) && !empty($date_of_brith)) {
				$birthDateObj = new DateTime($date_of_brith);
				$surgDateObj = new DateTime($surgery_date);
				$interval = $birthDateObj->diff($surgDateObj);
				$ageInYears = $interval->format('%r%y');
				if($ageInYears < 0) {
					$ageInYears = null;
					AppController::addWarningMsg(__(str_replace('%%field%%', __('age at surgery',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true))));
				}
			}
			
			$this->data['TreatmentDetail']['ovcare_age_at_surgery'] = $ageInYears;
		}

		return true;
	}
}
?>