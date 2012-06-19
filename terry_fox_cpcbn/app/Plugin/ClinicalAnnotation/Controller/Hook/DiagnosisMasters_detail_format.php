<?php 
	
	if($dx_master_data['DiagnosisControl']['controls_type'] == 'prostate') {		
		$disease_free_start_trt = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.diagnosis_master_id' => $diagnosis_master_id, 'TreatmentMaster.qc_tf_disease_free_survival_start_events' => '1'), 'recursive' => '-1'));	
		$this->set('disease_free_start_trt_id', empty($disease_free_start_trt)? '-1' : $disease_free_start_trt['TreatmentMaster']['id']);
	}
