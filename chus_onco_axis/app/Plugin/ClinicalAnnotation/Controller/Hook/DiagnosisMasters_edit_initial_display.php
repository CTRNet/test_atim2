<?php 
	
	if($this->request->data['DiagnosisControl']['controls_type'] == 'digestive system') {
		$this->request->data['FunctionManagement']['chus_autocomplete_digestive_morphology']
			= $this->DiagnosisMaster->getChusMorphologyDataForDisplay(array(
				'id' => $this->request->data['DiagnosisDetail']['morphology_id'],
				'morphology_code' => $this->request->data['DiagnosisDetail']['chus_morphology'],
				'tumour_type' => $this->request->data['DiagnosisDetail']['morphology_tumour_type'],
				'tumour_cell_origin' => $this->request->data['DiagnosisDetail']['morphology_tumour_cell_origin'],
				'tumour_category' => $this->request->data['DiagnosisDetail']['morphology_tumour_category'],
				'behaviour_code' => $this->request->data['DiagnosisDetail']['morphology_behaviour_code'],
				'morphology_description' => $this->request->data['DiagnosisDetail']['morphology_description']));
	}
	