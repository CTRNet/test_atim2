<?php 
	
	if($this->request->data['DiagnosisControl']['controls_type'] == 'digestive system') {
		$this->request->data['FunctionManagement']['chus_autocomplete_digestive_topography'] 
			= $this->DiagnosisMaster->getChusTopographyDataForDisplay(array(
				'code' => $this->request->data['DiagnosisMaster']['topography'], 
				'category' => $this->request->data['DiagnosisDetail']['topography_category'], 
				'description' => $this->request->data['DiagnosisDetail']['topography_description']));
		$this->request->data['FunctionManagement']['chus_autocomplete_digestive_morphology']
			= $this->DiagnosisMaster->getChusMorphologyDataForDisplay(array(
				'id' => $this->request->data['DiagnosisDetail']['morphology_id'],
				'morphology_code' => $this->request->data['DiagnosisMaster']['morphology'],
				'tumour_type' => $this->request->data['DiagnosisDetail']['morphology_tumour_type'],
				'tumour_cell_origin' => $this->request->data['DiagnosisDetail']['morphology_tumour_cell_origin'],
				'tumour_category' => $this->request->data['DiagnosisDetail']['morphology_tumour_category'],
				'behaviour_code' => $this->request->data['DiagnosisDetail']['morphology_behaviour_code'],
				'morphology_description' => $this->request->data['DiagnosisDetail']['morphology_description']));
	}
	