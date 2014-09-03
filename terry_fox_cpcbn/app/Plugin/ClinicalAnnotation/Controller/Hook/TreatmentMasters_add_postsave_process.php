<?php 

	if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->request->data['TreatmentMaster']) && $this->request->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events']) {
		$this->DiagnosisMaster->calculateSurvivalAndBcr($this->request->data['TreatmentMaster']['diagnosis_master_id']);
	}
