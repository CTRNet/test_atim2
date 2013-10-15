<?php

	if(!is_null($redefined_primary_control_id) && $new_primary_ctrl['DiagnosisControl']['controls_type'] == 'ovary') {
		$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET ovcare_tumor_site = 'female genital-ovary' WHERE id = $diagnosis_master_id;");
		$dx_master_data['DiagnosisMaster']['ovcare_tumor_site'] = 'female genital-ovary';
		$this->DiagnosisMaster->updateCalculatedFields($participant_id);
	}

?>