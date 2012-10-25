<?php

class TreatmentDetailCustom extends TreatmentDetail {
	var $name = 'TreatmentDetail';
	var $useTable = 'txd_surgeries';

	var $belongsTo = array(        
		'Participant' => array(            
		'className'    => 'ClinicalAnnotation.Participant',            
		'foreignKey'    => 'participant_id'),
		'TreatmentControl' => array(            
		'className'    => 'ClinicalAnnotation.TreatmentControl',            
		'foreignKey'    => 'treatment_control_id')
	);

	function beforeSave($options) {
		echo "Calling custom BEFORE SAVE function";
		// Check $this->data has been populated from screen and not from Participant.beforeSave() function
/*		if (!$this->data['TreatmentDetail']['skip']) {
			
			$previous_dx_data = null;
			$participant_id = array_key_exists('participant_id', $this->data['TreatmentDetail'])? $this->data['TreatmentDetail']['participant_id'] : null;
			$dx_control_id = array_key_exists('treatment_control_id', $this->data['TreatmentDetail'])? $this->data['TreatmentDetail']['treatment_control_id'] : null;
		
			if(is_null($participant_id) || is_null($tx_control_id)) {
				
				$previous_tx_data = $this->find('first', array('conditions' => array ('TreatmentDetail.id' => $this->id), 'recursive' => '-1'));
				if(empty($previous_tx_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$participant_id = $previous_tx_data['TreatmentDetail']['participant_id'];	
				$tx_control_id = $previous_tx_data['TreatmentDetail']['treatment_control_id'];	
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

		} */
		return true; 
	}
	
	function updateAgeAtDx($date_of_diagnosis, $date_of_birth) {

		echo "Calling custom function";
/*
		if (isset($date_of_birth) && isset($date_of_diagnosis)) {

			$birthDateObj = new DateTime($date_of_birth);
			$dxDateObj = new DateTime($date_of_diagnosis);
			$interval = $birthDateObj->diff($dxDateObj);			

			if ($date_of_diagnosis >= $date_of_birth ) {	
				
				$ageInYears = $interval->format('%r%y');
				$ageInMonths = $interval->format('%m');
				$ageInDays = $interval->format('%d');
			
				if ($ageInDays >=7) {
					$ageInWeeks = (int)($ageInDays/7);
					$ageInDays = $ageInDays - ($ageInWeeks*7);
				}
				else {
					$ageInWeeks = 0;
				}
				$this->data['TreatmentDetail']['age_at_dx'] = $ageInYears;
				$this->data['TreatmentDetail']['ccbr_age_at_dx_months'] = $ageInMonths;
       			$this->data['TreatmentDetail']['ccbr_age_at_dx_weeks'] = $ageInWeeks;
       			$this->data['TreatmentDetail']['ccbr_age_at_dx_days'] = $ageInDays;				
				
			} else {
       			$this->data['TreatmentDetail']['age_at_dx'] = '';
       			$this->data['TreatmentDetail']['ccbr_age_at_dx_months'] = '';
       			$this->data['TreatmentDetail']['ccbr_age_at_dx_weeks'] = '';
       			$this->data['TreatmentDetail']['ccbr_age_at_dx_days'] = '';
       		}

		}*/
		return true;
	} 
}
?>