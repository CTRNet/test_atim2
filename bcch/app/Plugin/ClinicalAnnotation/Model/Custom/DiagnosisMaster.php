<?php
// Customization for CCBR to set age at diagnosis in years, months and days to support pediatric
// Fields: age_at_dx, ccbr_age_at_dx_months, ccbr_age_at_dx_weeks, ccbr_age_at_dx_days

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = 'DiagnosisMaster';
	var $useTable = 'diagnosis_masters';

	var $belongsTo = array(        
		'Participant' => array(            
		'className'    => 'ClinicalAnnotation.Participant',            
		'foreignKey'    => 'participant_id'),
		'DiagnosisControl' => array(            
		'className'    => 'ClinicalAnnotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id')
	);

	function beforeSave($options) {

		// Check $this->data has been populated from screen and not from Participant.beforeSave() function
		if (!$this->data['DiagnosisMaster']['skip']) {

			$previous_dx_data = null;
			$participant_id = array_key_exists('participant_id', $this->data['DiagnosisMaster'])? $this->data['DiagnosisMaster']['participant_id'] : null;
			$dx_control_id = array_key_exists('diagnosis_control_id', $this->data['DiagnosisMaster'])? $this->data['DiagnosisMaster']['diagnosis_control_id'] : null;
		
			if(is_null($participant_id) || is_null($dx_control_id)) {
				
				$previous_dx_data = $this->find('first', array('conditions' => array ('DiagnosisMaster.id' => $this->id), 'recursive' => '-1'));
				if(empty($previous_dx_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$participant_id = $previous_dx_data['DiagnosisMaster']['participant_id'];	
				$dx_control_id = $previous_dx_data['DiagnosisMaster']['diagnosis_control_id'];	
			}

		
			$dx_control_model = AppModel::getInstance("ClinicalAnnotation", "DiagnosisControl", true);
			$dx_control_data = $dx_control_model->find('first', array('conditions' => array ('DiagnosisControl.id' => $dx_control_id)));
			
			if (empty($dx_control_data)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}

			$previous_dx_date = is_null($previous_dx_data)? null: $previous_dx_data['DiagnosisMaster']['dx_date'];
			$dx_date = $this->data['DiagnosisMaster']['dx_date'];
				
			if(is_null($previous_dx_data) || ($dx_date != $previous_dx_date)) {
					
				$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
				$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));

				if(empty($participant_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$date_of_birth = $participant_data['Participant']['date_of_birth'];
				
				// Update age at diagnosis	
				$this->updateAgeAtDx($dx_date, $date_of_birth);
			}

		} 
		return true; 
	}
	
	function updateAgeAtDx($date_of_diagnosis, $date_of_birth) {

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
				$this->data['DiagnosisMaster']['age_at_dx'] = $ageInYears;
				$this->data['DiagnosisMaster']['ccbr_age_at_dx_months'] = $ageInMonths;
       			$this->data['DiagnosisMaster']['ccbr_age_at_dx_weeks'] = $ageInWeeks;
       			$this->data['DiagnosisMaster']['ccbr_age_at_dx_days'] = $ageInDays;				
				
			} else {
       			$this->data['DiagnosisMaster']['age_at_dx'] = '';
       			$this->data['DiagnosisMaster']['ccbr_age_at_dx_months'] = '';
       			$this->data['DiagnosisMaster']['ccbr_age_at_dx_weeks'] = '';
       			$this->data['DiagnosisMaster']['ccbr_age_at_dx_days'] = '';
       		}

		}
		return true;
	}
}
?>