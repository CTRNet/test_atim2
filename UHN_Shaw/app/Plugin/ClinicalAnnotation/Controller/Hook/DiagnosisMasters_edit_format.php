<?php
	
	if(isset($new_primary_ctrl) && $new_primary_ctrl['DiagnosisControl']['controls_type'] == 'ovary') {
		$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET uhn_site = 'female genital-ovary' WHERE id = $diagnosis_master_id;");
	}
	