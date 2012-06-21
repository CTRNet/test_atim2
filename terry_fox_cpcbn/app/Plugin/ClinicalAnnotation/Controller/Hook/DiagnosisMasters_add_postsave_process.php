<?php 

	if(isset($this->request->data['DiagnosisDetail']) && array_key_exists('first_biochemical_recurrence', $this->request->data['DiagnosisDetail']) && $this->request->data['DiagnosisDetail']['first_biochemical_recurrence']) {
		$this->DiagnosisMaster->calculateSurvivalAndBcr($diagnosis_master_id);
	}
