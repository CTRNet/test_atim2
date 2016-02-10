<?php

	if(!is_null($redefined_primary_control_id)) {
		$data_to_update = array();
		$dx_master_data['DiagnosisMaster']['ovcare_clinical_diagnosis'] = $data_to_update['DiagnosisMaster']['ovcare_clinical_diagnosis'] = $dx_master_data['DiagnosisMaster']['notes'];
		$dx_master_data['DiagnosisMaster']['notes'] = $data_to_update['DiagnosisMaster']['notes'] = '';
		if($new_primary_ctrl['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor') {
			$dx_master_data['DiagnosisMaster']['ovcare_tumor_site'] = $data_to_update['DiagnosisMaster']['ovcare_tumor_site'] = 'female genital-ovary';
		}
		$this->DiagnosisMaster->id = $diagnosis_master_id;
		if (!$this->DiagnosisMaster->save($data_to_update)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
	}

?>