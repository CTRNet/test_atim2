<?php 

	if(isset($this->request->data['DiagnosisDetail']) && array_key_exists('first_biochemical_recurrence', $this->request->data['DiagnosisDetail'])) {
		$this->DiagnosisMaster->calculateSurvivalAndBcr($diagnosis_master_id);
	}
	
	$this->DiagnosisMaster->updateAgeAtDx('DiagnosisMaster', $diagnosis_master_id);
