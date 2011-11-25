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
		// Set Data For Diagnosis and surgery Update
		$this->data['OvcareFunctionParticipantManagement']['is_last_followup_date_updated'] = false;
		$this->data['OvcareFunctionParticipantManagement']['is_date_of_birth_updated'] = false;
		
		if(!empty($this->id)) {
			// Participant data has just been updated
			$previous_participant_data = $this->find('first', array('conditions' => array('Participant.id' => $this->id), 'recursive' => '-1'));
			if(empty($previous_participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			// Date of birth
			if($this->data['Participant']['date_of_birth'] != $previous_participant_data['Participant']['date_of_birth']) {
				$this->data['OvcareFunctionParticipantManagement']['is_date_of_birth_updated'] = true;
			}
			
			// Date of followup
			$previous_followup_date = $previous_participant_data['Participant']['ovcare_last_followup_date'].'-'.$previous_participant_data['Participant']['ovcare_last_followup_date_accuracy'];
			$followup_date = $this->data['Participant']['ovcare_last_followup_date'].'-'.$this->data['Participant']['ovcare_last_followup_date_accuracy'];		
			if($previous_followup_date != $followup_date) {
				$this->data['OvcareFunctionParticipantManagement']['is_last_followup_date_updated'] = true;
			}
		}
		
		return true;
	}
	
	function afterSave($created) {
		if($this->data['OvcareFunctionParticipantManagement']['is_last_followup_date_updated']) {
			$diagnosis_master_model = AppModel::getInstance("Clinicalannotation", "DiagnosisMaster", true);
			$diagnosis_master_model->updateAllSurvivaleTimes($this->id);
		}
		if($this->data['OvcareFunctionParticipantManagement']['is_date_of_birth_updated']) {
			$treatment_master_model = AppModel::getInstance("Clinicalannotation", "TreatmentMaster", true);
			$treatment_master_model->updateAllAgesAtSurgery($this->id);
		}
		unset($this->data['OvcareFunctionParticipantManagement']);
	}
}
?>