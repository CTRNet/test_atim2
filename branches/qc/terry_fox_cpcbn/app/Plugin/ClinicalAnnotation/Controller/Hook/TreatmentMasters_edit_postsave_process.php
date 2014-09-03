<?php 

	if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->request->data['TreatmentMaster'])) {
		$this->DiagnosisMaster->calculateSurvivalAndBcr($treatment_master_data['TreatmentMaster']['diagnosis_master_id']);
		if($treatment_master_data['TreatmentMaster']['diagnosis_master_id'] != $this->request->data['TreatmentMaster']['diagnosis_master_id']) $this->DiagnosisMaster->calculateSurvivalAndBcr($this->request->data['TreatmentMaster']['diagnosis_master_id']);
	}
