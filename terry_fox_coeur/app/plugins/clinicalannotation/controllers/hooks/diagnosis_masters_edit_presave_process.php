<?php
	
	// --------------------------------------------------------------------------------
	// Manage data for created primary
	// -------------------------------------------------------------------------------- 
	
	if(($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC') || ($dx_control_data['DiagnosisControl']['controls_type'] == 'other primary cancer')) {
		if($this->data['DiagnosisMaster']['primary_number'] != $dx_master_data['DiagnosisMaster']['primary_number']) {
			$submitted_data_validates = false;
			$this->DiagnosisMaster->validationErrors['primary_number'][] = 'the diagnoses group can not be changed for a primary diagnosis';
			$this->data['DiagnosisMaster']['primary_number'] = $dx_master_data['DiagnosisMaster']['primary_number'];
		}
	
	} else if($dx_control_data['DiagnosisControl']['controls_type'] == 'progression and recurrence') {
		$existing_primary_number_data = $this->DiagnosisMaster->find('first', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.primary_number' => $this->data['DiagnosisMaster']['primary_number']), 'fields'=> array('DiagnosisMaster.primary_number'), 'recursive' => '-1'));
		if(empty($this->data['DiagnosisMaster']['primary_number']) || empty($existing_primary_number_data)) {
			$submitted_data_validates = false;
			$this->DiagnosisMaster->validationErrors['primary_number'][] = 'a progression should be related to an existing diagnoses group';
			$this->data['DiagnosisMaster']['primary_number'] = $dx_master_data['DiagnosisMaster']['primary_number'];
		}		
	}

?>