<?php 

if($this->request->data) {
	if(!$tx_control_data['TreatmentControl']['use_addgrid']) {
		if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data['TreatmentMaster'], $tx_control_data['TreatmentControl'])) {
			$submitted_data_validates = false;
		}
	} else {
		$data_keys = array_keys($this->request->data);
		$first_key = array_shift($data_keys);
		$this->TreatmentMaster->validationErrors = array();
		if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data[$first_key]['TreatmentMaster'], $tx_control_data['TreatmentControl'])) {
			foreach($this->TreatmentMaster->validationErrors as $field => $msgs) {
				$msgs = is_array($msgs)? $msgs : array($msgs);
				foreach($msgs as $msg)$errors_tracking[$field][$msg][] = __('n/a');
			}
		}
	}
}
