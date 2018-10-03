<?php
	
	if(!is_null($redefined_primary_control_id) && empty($this->request->data) && ($dx_master_data['DiagnosisControl']['controls_type'] == 'ovary') && empty($dx_master_data['DiagnosisMaster']['ohri_tumor_site'])) {
		$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET ohri_tumor_site = 'Female Genital-Ovary' WHERE id = $diagnosis_master_id;");
		$dx_master_data['DiagnosisMaster']['ohri_tumor_site'] = "Female Genital-Ovary";
	}

	

?>
