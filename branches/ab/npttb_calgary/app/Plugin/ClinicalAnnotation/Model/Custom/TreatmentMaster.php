<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';

	var $belongsTo = array(        
		'Participant' => array(            
			'className'    => 'ClinicalAnnotation.Participant',            
			'foreignKey'    => 'participant_id'),
		'TreatmentControl' => array(            
			'className'    => 'ClinicalAnnotation.TreatmentControl',            
			'foreignKey'    => 'treatment_control_id')
	);

	function beforeSave($options) {
		
		// Check $this->data has been populated from screen and not from Participant.beforeSave() function
		if (!$this->data['TreatmentMaster']['skip']) {
			$previous_tx_data = null;
			$participant_id = array_key_exists('participant_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['participant_id'] : null;
			$tx_control_id = array_key_exists('treatment_control_id', $this->data['TreatmentMaster'])? $this->data['TreatmentMaster']['treatment_control_id'] : null;
		
			if(is_null($participant_id) || is_null($tx_control_id)) {
				
				$previous_tx_data = $this->find('first', array('conditions' => array ('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));
				if(empty($previous_tx_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$participant_id = $previous_tx_data['TreatmentMaster']['participant_id'];	
				$tx_control_id = $previous_tx_data['TreatmentMaster']['treatment_control_id'];	
			}

			$tx_control_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
			$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => $tx_control_id)));
			
			if (empty($tx_control_data)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}

			$previous_tx_date = is_null($previous_tx_data)? null: $previous_tx_data['TreatmentMaster']['start_date'];
			$tx_date = $this->data['TreatmentMaster']['start_date'];
				
			if(is_null($previous_tx_data) || ($dx_date != $previous_tx_date)) {
					
				$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
				$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));

				if(empty($participant_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$date_of_birth = $participant_data['Participant']['date_of_birth'];
				
				// Update age at diagnosis	
				$this->updateAgeAtDx($tx_date, $date_of_birth);
			}

		}
		return true; 
	}
	
	function updateAgeAtDx($date_of_treatment, $date_of_birth) {

		echo $date_of_treatment;
		echo $date_of_birth;

		if (isset($date_of_birth) && isset($date_of_treatment)) {

			$birthDateObj = new DateTime($date_of_birth);
			$txDateObj = new DateTime($date_of_treatment);
			$interval = $birthDateObj->diff($txDateObj);			

			if ($date_of_treatment >= $date_of_birth ) {	
				
				$ageInYears = $interval->format('%r%y');
				$this->data['TreatmentMaster']['npttb_age_at_tx'] = $ageInYears;			
			} else {
       			$this->data['TreatmentMaster']['npttb_age_at_tx'] = '';
       		}
		}
		return true;
	} 
}
?>