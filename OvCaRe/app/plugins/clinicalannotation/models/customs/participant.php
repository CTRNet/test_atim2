<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'DiagnosisMaster' => array(
			'className'   => 'Clinicalannotation.DiagnosisMaster',
			 'foreignKey'  => 'participant_id')
	); 	

	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
					'menu'				=>	array( NULL, (__('participant identifier',true).' '.$result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, (__('participant identifier',true).' '.$result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	

	function beforeSave($options) {
		// Set Data For Diagnosis Update (step1)
		$this->data['OvcareFunctionManagement']['is_last_followup_date_updated'] = false;
		
		if(!empty($this->id)) {
			// Participant data has just been updated
			$previous_participant_data = $this->find('first', array('conditions' => array('Participant.id' => $this->id), 'recursive' => '-1'));
			if(empty($previous_participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$date_of_birth = $this->data['Participant']['date_of_birth'];
			$previous_date_of_birth = $previous_participant_data['Participant']['date_of_birth'];
			
			if($previous_date_of_birth != $date_of_birth) {
				
				// UPDATE AGE AT SURGERY
				
				$treatment_master_model = AppModel::getInstance("Clinicalannotation", "TreatmentMaster", true);
				$participant_treatments = $treatment_master_model->find('all', array('conditions' => array ('TreatmentMaster.participant_id' => $this->id), 'recursive' => '0'));

				foreach($participant_treatments as $new_trt) {
					if(($new_trt['TreatmentControl']['disease_site'] == 'ovcare') && ($new_trt['TreatmentControl']['tx_method'] == 'surgery')) {
						$new_surgery_id = $new_trt['TreatmentMaster']['id'];
						$surgery_date = $new_trt['TreatmentMaster']['start_date'];
						
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
						
						$new_tr_data = array();
						$new_tr_data['TreatmentMaster']['id'] = $new_surgery_id;
						$new_tr_data['TreatmentDetail']['ovcare_age_at_surgery'] = $ageInYears;
						$treatment_master_model->id = null;
						$treatment_master_model->data = array();
						if(!$treatment_master_model->save($new_tr_data, false)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
				}
			}
			
			// Set Data For Diagnosis Update (step2)
			$previous_followup_date = $previous_participant_data['Participant']['ovcare_last_followup_date'].'-'.$previous_participant_data['Participant']['ovcare_last_followup_date_accuracy'];
			$followup_date = $this->data['Participant']['ovcare_last_followup_date'].'-'.$this->data['Participant']['ovcare_last_followup_date_accuracy'];		
			if($previous_followup_date != $followup_date) $this->data['OvcareFunctionManagement']['is_last_followup_date_updated'] = true;
		}
		
		return true;
	}
	
	function afterSave($created) {
		if($this->data['OvcareFunctionManagement']['is_last_followup_date_updated']) {
			$diagnosis_master_model = AppModel::getInstance("Clinicalannotation", "DiagnosisMaster", true);
			$diagnosis_master_model->updateAllSurvivaleTimes($this->id);
		}
		unset($this->data['OvcareFunctionManagement']);
	}
}
?>