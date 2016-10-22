<?php 

	if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data['TreatmentMaster'], $treatment_master_data['TreatmentControl'])) {
		$submitted_data_validates = false;
	}
	