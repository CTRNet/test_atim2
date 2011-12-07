<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'DiagnosisMaster' => array(
			'className'   => 'Clinicalannotation.DiagnosisMaster',
			 'foreignKey'  => 'participant_id')
	); 	
	
	// CCBR customization to calculate age at death
	function beforeSave($options) {
		// Check date of birth and date of death completed
		if (!empty($this->data['Participant']['date_of_birth']) && !empty($this->data['Participant']['date_of_death'])) {
		
			$this->updateAgeAtDeath($this->data['Participant']['date_of_death'], $this->data['Participant']['date_of_birth']);
			
			// TODO Fix FK reference
			$dx_model = AppModel::getInstance("Clinicalannotation", "DiagnosisMaster", true);
			$dx_results = $dx_model->find('all', array('conditions' => array ('DiagnosisMaster.participant_id' => 1)));
		
			$this->updateAllDxAges($this->data['Participant']['date_of_birth']);
		}
		return true;
	}

	function updateAgeAtDeath($dateofdeath, $dateofbirth) {
		$status = false;
		if (isset($dateofdeath) && isset($dateofbirth)) {
	
			$birthDateObj = new DateTime($dateofbirth);
			$deathDateObj = new DateTime($dateofdeath);
			$interval = $birthDateObj->diff($deathDateObj);			

			if ($dateofdeath >= $dateofbirth ) {	
				$ageAtDeath = $interval->format('%r%y');
				$this->data['Participant']['ccbr_age_at_death'] = $ageAtDeath;
			} else {
				$this->data['Participant']['ccbr_age_at_death'] = '';
       		}		
			$status = true;
		}
		return true;		
	}
	
	function updateAllDxAges($dateofbirth) {
		// Finds all associated diagnosis records and updates
		$status = false;
		
		return $status;
	}
}
?>