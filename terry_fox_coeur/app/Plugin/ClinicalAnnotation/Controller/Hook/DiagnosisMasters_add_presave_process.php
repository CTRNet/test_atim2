<?php
	
	// --------------------------------------------------------------------------------
	// Manage data for created primary
	// -------------------------------------------------------------------------------- 
	
	if(($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC') || ($dx_control_data['DiagnosisControl']['controls_type'] == 'other primary cancer')) {
		$this->DiagnosisMaster->addWritableField(array('qc_tf_dx_origin','qc_tf_tumor_site','qc_tf_progression_detection_method'));
		$this->request->data['DiagnosisMaster']['qc_tf_dx_origin'] = 'primary';	
		if($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC'){
			$this->request->data['DiagnosisMaster']['qc_tf_tumor_site'] = 'Female Genital-Ovary';	
		}
		$this->request->data['DiagnosisMaster']['qc_tf_progression_detection_method'] = 'not applicable';
		
	} else if($dx_control_data['DiagnosisControl']['controls_type'] == 'progression and recurrence') {
		$this->DiagnosisMaster->addWritableField(array('qc_tf_dx_origin'));
		$this->request->data['DiagnosisMaster']['qc_tf_dx_origin'] = 'progression';
		
	} else {
		$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}

