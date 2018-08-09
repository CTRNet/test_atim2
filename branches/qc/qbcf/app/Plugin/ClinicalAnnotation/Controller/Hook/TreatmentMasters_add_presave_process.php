<?php 

if($this->request->data) {
	if(!$txControlData['TreatmentControl']['use_addgrid']) {
		if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data['TreatmentMaster'], $txControlData['TreatmentControl'])) {
			$submittedDataValidates = false;
		}
	} else {
		$dataKeys = array_keys($this->request->data);
		$firstKey = array_shift($dataKeys);
		$this->TreatmentMaster->validationErrors = array();
		if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data[$firstKey]['TreatmentMaster'], $txControlData['TreatmentControl'])) {
			foreach($this->TreatmentMaster->validationErrors as $field => $msgs) {
				$msgs = is_array($msgs)? $msgs : array($msgs);
				foreach($msgs as $msg)$errorsTracking[$field][$msg][] = __('n/a');
			}
		}
	}
}