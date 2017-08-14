<?php
	
	// --------------------------------------------------------------------------------
	// Manage data for created primary
	// -------------------------------------------------------------------------------- 
	
	if($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC'){
		$this->DiagnosisMaster->addWritableField(array('qc_tf_tumor_site','qc_tf_progression_detection_method'));
		$this->request->data['DiagnosisMaster']['qc_tf_tumor_site'] = 'Female Genital-Ovary';
		$this->request->data['DiagnosisMaster']['qc_tf_progression_detection_method'] = 'not applicable';
	} else if($dx_control_data['DiagnosisControl']['controls_type'] == 'other primary cancer'){
		$this->DiagnosisMaster->addWritableField(array('qc_tf_progression_detection_method'));
		$this->request->data['DiagnosisMaster']['qc_tf_progression_detection_method'] = 'not applicable';
	}
	