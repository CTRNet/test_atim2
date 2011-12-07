<?php
// Customization for CCBR to set age at diagnosis in years, months and days to support pediatric
// Fields: age_at_dx, ccbr_age_at_dx_months, ccbr_age_at_dx_weeks, ccbr_age_at_dx_days

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = 'DiagnosisMaster';
	var $useTable = 'diagnosis_masters';

	var $belongsTo = array(        
		'Participant' => array(            
		'className'    => 'Clinicalannotation.Participant',            
		'foreignKey'    => 'participant_id'),
		'DiagnosisControl' => array(            
		'className'    => 'Clinicalannotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id')
	);

	function beforeSave($options) {
		// TODO: Fix participant FK reference
		$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
		$participant_results = $participant_model->find('first', array('conditions' => array ('Participant.id' => 'DiagnosisMaster.participant_id'), 'fields' => array ('Participant.date_of_birth')));

		if (!empty($this->data['DiagnosisMaster']['dx_date']) && !empty($participant_results['Participant']['date_of_birth'])) {
			$this->updateAgeAtDx($this->data['DiagnosisMaster']['dx_date'], $participant_results['Participant']['date_of_birth']);
		}
		return true;
	}
	
	function updateAgeAtDx($dateofdiagnosis, $dateofbirth) {
		$status = false;
		if (isset($dateofbirth) && isset($dateofdiagnosis)) {
			echo $dateofbirth;
			echo $dateofdiagnosis;
			$birthDateObj = new DateTime($dateofbirth);
			$dxDateObj = new DateTime($dateofdiagnosis);
			$interval = $birthDateObj->diff($dxDateObj);			

			if ($dateofdiagnosis >= $dateofbirth ) {	
				
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
       		       		
			$status = true;
		}
		return $status;
	}
}
?>