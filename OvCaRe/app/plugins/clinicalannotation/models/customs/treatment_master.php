<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';
	
	var $ovcareIsTreatmentDeletion = false;
	
	function beforeDelete() {
		if($this->id != $this->data['TreatmentMaster']['id']) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(($this->data['TreatmentControl']['disease_site'] == 'ovcare') && ($this->data['TreatmentControl']['tx_method'] == 'surgery')) {
			// *** SET DATA FOR DIAGNOSES UPDATE ***
			// (User is deleting a surgery)
			$this->data['OvcareTrtFunctionManagement']['previous_diagnosis_master_id_of_surg'] = $this->data['TreatmentMaster']['diagnosis_master_id'];
			$this->data['OvcareTrtFunctionManagement']['new_diagnosis_master_id_of_surg'] = null;
		}
		
		$this->ovcareIsTreatmentDeletion = true;

		return true;
	}
	
	function beforeSave($options) {
		
		if(array_key_exists('start_date', $this->data['TreatmentMaster']) && (!$this->ovcareIsTreatmentDeletion)) { 
			// User just clicked on submit button of Treatment form : Treatment is being created or updated
			
			$participant_id	= null;		
			$previous_treatment_data =  array();
			$tx_control_data = array();	
			if(array_key_exists('participant_id', $this->data['TreatmentMaster'])) {
				// Treatment is being created
				$participant_id	= $this->data['TreatmentMaster']['participant_id'];	
				$tx_control_model = AppModel::getInstance("Clinicalannotation", "TreatmentControl", true);
				$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => $this->data['TreatmentMaster']['treatment_control_id'])));				
			} else {
				// Treatment is being updated
				$previous_treatment_data = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '0'));
				if(empty($previous_treatment_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$participant_id = $previous_treatment_data['TreatmentMaster']['participant_id'];	
				$tx_control_data['TreatmentControl'] = $previous_treatment_data['TreatmentControl'];				
			}
			if(empty($tx_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			if(($tx_control_data['TreatmentControl']['disease_site'] == 'ovcare') && ($tx_control_data['TreatmentControl']['tx_method'] == 'surgery')) {	
				
				// *** SET AGE AT SURGERY ***
					
				$previous_surgery_date = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['start_date'];
				$surgery_date = $this->data['TreatmentMaster']['start_date'];			
				if(empty($previous_surgery_date) || ($surgery_date != $previous_surgery_date)) {
					$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
					$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));
					if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$date_of_birth = $participant_data['Participant']['date_of_birth'];
		
					$age_in_years = null;
					if(!empty($surgery_date) && !empty($date_of_birth)) {
						$birthDateObj = new DateTime($date_of_birth);
						$surgDateObj = new DateTime($surgery_date);
						$interval = $birthDateObj->diff($surgDateObj);
						$age_in_years = $interval->format('%r%y');
						if($age_in_years < 0) {
							$age_in_years = null;
							AppController::addWarningMsg(str_replace('%%field%%', __('age at surgery',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
						}
					}
					$this->data['TreatmentDetail']['ovcare_age_at_surgery'] = $age_in_years;
				}
				
				// *** SET DATA FOR DIAGNOSES UPDATE ***
				
				$this->data['OvcareTrtFunctionManagement']['previous_diagnosis_master_id_of_surg'] = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['diagnosis_master_id'];
				$this->data['OvcareTrtFunctionManagement']['new_diagnosis_master_id_of_surg'] = $this->data['TreatmentMaster']['diagnosis_master_id'];
			}
		}
					
		return true;
	}
	
	function afterSave() {
		if(array_key_exists('OvcareTrtFunctionManagement', $this->data)) {
			// *** LAUNCH DIAGNOSES UPDATE : INTIAL SURGERY DATE ***
			$tmp_id = $this->id;
			$tmp_data = $this->data;
			
			$previous_diagnosis_master_id_of_surg = $this->data['OvcareTrtFunctionManagement']['previous_diagnosis_master_id_of_surg'];
			$new_diagnosis_master_id_of_surg = $this->data['OvcareTrtFunctionManagement']['new_diagnosis_master_id_of_surg'];
			unset($this->data['OvcareTrtFunctionManagement']);
			
			$diagnosis_master_model = AppModel::getInstance("Clinicalannotation", "DiagnosisMaster", true);
			if($previous_diagnosis_master_id_of_surg != $new_diagnosis_master_id_of_surg) $diagnosis_master_model->setInitialSurgeryDate($previous_diagnosis_master_id_of_surg);
			$diagnosis_master_model->setInitialSurgeryDate($new_diagnosis_master_id_of_surg);

			$this->id = $tmp_id;
			$this->data = $tmp_data;
		}
	}
	
	function updateAllAgesAtSurgery($participant_id) {
		$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
		$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$date_of_birth = $participant_data['Participant']['date_of_birth'];
		
		$conditions =  array (
			'TreatmentMaster.participant_id' => $participant_id,
			'TreatmentControl.disease_site' => 'ovcare',
			'TreatmentControl.tx_method' => 'surgery',
			"TreatmentMaster.start_date != ''",
			"TreatmentMaster.start_date IS NOT NULL"		
		);
		$participant_surgeries = $this->find('all', array('conditions' => $conditions, 'recursive' => '0'));

		foreach($participant_surgeries as $new_trt) {
			$surgery_id = $new_trt['TreatmentMaster']['id'];
			$surgery_date = $new_trt['TreatmentMaster']['start_date'];
			
			$age_in_years = null;
			if(!empty($surgery_date) && !empty($date_of_birth)) {
				$birthDateObj = new DateTime($date_of_birth);
				$surgDateObj = new DateTime($surgery_date);
				$interval = $birthDateObj->diff($surgDateObj);
				$age_in_years = $interval->format('%r%y');
				if($age_in_years < 0) {
					$age_in_years = null;
					AppController::addWarningMsg(str_replace('%%field%%', __('age at surgery',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
				}
			}
			
			$new_tr_data = array();
			$new_tr_data['TreatmentMaster']['id'] = $surgery_id;
			$new_tr_data['TreatmentDetail']['ovcare_age_at_surgery'] = $age_in_years;
			$this->id = null;
			$this->data = array();
			if(!$this->save($new_tr_data, false)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
}
?>