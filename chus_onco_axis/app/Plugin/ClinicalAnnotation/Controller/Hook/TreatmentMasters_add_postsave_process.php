<?php 
	
	if(in_array($tx_control_data['TreatmentControl']['tx_method'], array('systemic therapy', 'surgery', 'biopsy', 'radiotherapy'))) {
		$redirect_url = '';
		if(isset($this->request->data['TreatmentMaster']['protocol_master_id']) && $this->request->data['TreatmentMaster']['protocol_master_id']) {
			$redirect_url ='/ClinicalAnnotation/TreatmentExtendMasters/'.$tx_control_data['TreatmentControl']['extended_data_import_process'].'/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId();
		} else {
			$redirect_url = '/ClinicalAnnotation/TreatmentExtendMasters/add/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId();
		}
		AppController::addInfoMsg(__('your data has been saved'));
		$this->redirect($redirect_url);
	}
