<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'DiagnosisMaster' => array(
			'className'   => 'ClinicalAnnotation.DiagnosisMaster',
			 'foreignKey'  => 'participant_id')
	); 	
	
	// CCBR customization to calculate age at death
	function beforeSave($options) {
	
		// Check date of birth and date of death completed
		if (!empty($this->data['Participant']['date_of_birth']) && !empty($this->data['Participant']['date_of_death'])) {
			$this->updateAgeAtDeath($this->data['Participant']['date_of_birth'], $this->data['Participant']['date_of_death']);
		} else {
			$this->data['Participant']['ccbr_age_at_death'] = '';
		}
		
		// If this is a new participant skip updating related diagnosis records					
		if(!empty($this->id)) {

			// Get previous participant data
			$previous_participant_data = $this->find('first', array('conditions' => array('Participant.id' => $this->id), 'recursive' => '-1'));
			
			if(empty($previous_participant_data)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$date_of_birth = $this->data['Participant']['date_of_birth'];
			$previous_date_of_birth = $previous_participant_data['Participant']['date_of_birth'];

			// Update all Age at Diagnosis records if DOB has changed
			if($previous_date_of_birth != $date_of_birth) {
				$this->updateAllDxAges($date_of_birth);
			}	
		}		
		return true;
	}

	function updateAgeAtDeath($dateofbirth, $dateofdeath) {
		$updateStatus = false;
		if (isset($dateofbirth) && isset($dateofdeath)) {
	
			$birthDateObj = new DateTime($dateofbirth);
			$deathDateObj = new DateTime($dateofdeath);
			$interval = $birthDateObj->diff($deathDateObj);			

			if ($dateofdeath >= $dateofbirth ) {	
				$ageAtDeath = $interval->format('%r%y');
				$this->data['Participant']['ccbr_age_at_death'] = $ageAtDeath;
			} else {
				$this->data['Participant']['ccbr_age_at_death'] = '';
       		}		
			$updateStatus = true;
		}
		return $updateStatus;		
	}
	
	function updateAllDxAges($date_of_birth) {

		// Finds all associated diagnosis records
		$diagnosis_master_model = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		$participant_dx_results = $diagnosis_master_model->find('all', array('conditions' => array ('DiagnosisMaster.participant_id' => $this->id), 'recursive' => '0'));		
		
		foreach($participant_dx_results as $new_dx) {
	
			$new_dx_id = $new_dx['DiagnosisMaster']['id'];
			$dx_date = $new_dx['DiagnosisMaster']['dx_date'];
						
			$new_dx_data = array();

			// Ensure both dates are not empty and date of dx is after DOB
			if(!empty($dx_date) && !empty($date_of_birth) && ($dx_date >= $date_of_birth)) {

				// Calculate interval between DOB and Date of Dx
				$birthDateObj = new DateTime($date_of_birth);
				$dxDateObj = new DateTime($dx_date);
				$interval = $birthDateObj->diff($dxDateObj);
			
				$ageInYears = $interval->format('%r%y');
				$ageInMonths = $interval->format('%m');
				$ageInDays = $interval->format('%d');
			
				if ($ageInDays >=7) {
					$ageInWeeks = (int)($ageInDays/7);
					$ageInDays = $ageInDays - ($ageInWeeks*7);
				} else {
					$ageInWeeks = 0;
				}
				
				// Set age at values for current dx record
				$new_dx_data['DiagnosisMaster']['id'] = $new_dx_id;	
				$new_dx_data['DiagnosisMaster']['age_at_dx'] = $ageInYears;
				$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_months'] = $ageInMonths;
       			$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_weeks'] = $ageInWeeks;
       			$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_days'] = $ageInDays;	
       			$new_dx_data['DiagnosisMaster']['skip'] = true;			
			} else {
				$new_dx_data['DiagnosisMaster']['id'] = $new_dx_id;	
				$new_dx_data['DiagnosisMaster']['age_at_dx'] = '';
				$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_months'] = '';
       			$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_weeks'] = '';
       			$new_dx_data['DiagnosisMaster']['ccbr_age_at_dx_days'] = '';
       			$new_dx_data['DiagnosisMaster']['skip'] = true;		
       		}
       		
       		$diagnosis_master_model->id = null;
			$diagnosis_master_model->data = array();
			
			if(!$diagnosis_master_model->save($new_dx_data, false)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
				
		}
		
		return true;
	}
}
?>