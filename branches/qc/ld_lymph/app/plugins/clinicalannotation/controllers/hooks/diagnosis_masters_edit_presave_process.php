<?php

	if($dx_control_data['DiagnosisControl']['controls_type'] == 'ld lymph. diagnostic') {
		if($dx_master_data['DiagnosisMaster']['primary_number'] != $this->data['DiagnosisMaster']['primary_number']) {
			$this->data['DiagnosisMaster']['primary_number'] = $dx_master_data['DiagnosisMaster']['primary_number'];
			$this->DiagnosisMaster->validationErrors['dx_origin'][] = "the diagnoses group of a diagnosis can not be changed";	
			$submitted_data_validates = false;	
		}
		
	} else if($dx_control_data['DiagnosisControl']['controls_type'] == 'ld lymph. progression') {	
		$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($this->data['DiagnosisMaster']['primary_number']) || !$nbr_of_grp_diagnoses) {
			$this->data['DiagnosisMaster']['primary_number'] = NULL;
			$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a progression should be linked to an existing diagnoses group";	
			$submitted_data_validates = false;	
		}
		
	} else {
		$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
	}
	
?>
