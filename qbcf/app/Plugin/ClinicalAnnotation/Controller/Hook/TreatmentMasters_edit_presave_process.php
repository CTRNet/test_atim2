<?php 

	if(!$this->TreatmentMaster->validatesTreatmentToDiagnosisLink($this->request->data['TreatmentMaster'], $treatmentMasterData['TreatmentControl'])) {
		$submittedDataValidates = false;
	}