<?php

	if(!is_null($redefined_primary_control_id)) {
		if($new_primary_ctrl['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor') {
			$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET ovcare_tumor_site = 'female genital-ovary' WHERE id = $diagnosis_master_id;");
			$dx_master_data['DiagnosisMaster']['ovcare_tumor_site'] = 'female genital-ovary';
		}
		$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET ovcare_clinical_diagnosis = notes, notes = '' WHERE id = $diagnosis_master_id;");
		$dx_master_data['DiagnosisMaster']['ovcare_clinical_diagnosis'] = $dx_master_data['DiagnosisMaster']['notes'];
		$dx_master_data['DiagnosisMaster']['notes'] = '';
		if(!$this->DiagnosisMaster->save(array())) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); ;
	}

?>