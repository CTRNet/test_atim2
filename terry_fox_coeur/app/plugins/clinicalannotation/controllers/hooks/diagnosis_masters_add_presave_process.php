<?php
	
	// --------------------------------------------------------------------------------
	// Manage data for created primary
	// -------------------------------------------------------------------------------- 
	
	if(($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC') || ($dx_control_data['DiagnosisControl']['controls_type'] == 'other primary cancer')) {
		$existing_primary_number_data = $this->DiagnosisMaster->find('first', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.primary_number' => $this->data['DiagnosisMaster']['primary_number']), 'fields'=> array('DiagnosisMaster.primary_number'), 'recursive' => '-1'));
		
		$this->data['DiagnosisMaster']['qc_tf_dx_origin'] = 'primary';	
		if($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC'){
			$this->data['DiagnosisMaster']['qc_tf_tumor_site'] = 'Female Genital-Ovary';	
		}
		$this->data['DiagnosisMaster']['qc_tf_progression_detection_method'] = 'not applicable';
		
	} else if($dx_control_data['DiagnosisControl']['controls_type'] == 'progression and recurrence') {
		
		$this->data['DiagnosisMaster']['qc_tf_dx_origin'] = 'progression';
		
	} else {
		$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}

