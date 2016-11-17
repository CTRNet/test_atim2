<?php 
	
	//Set data for visit data entry worklfow
	if (empty($this->request->data)) $this->Participant->setNextUrlToFlashForVisitDataEntry($participant_id, 'TreatmentControl', $tx_control_data['TreatmentControl']);
	$next_url_to_flash_for_visit_data_entry = $this->Participant->getNextUrlToFlashForVisitDataEntry();
	$this->set('next_url_to_flash_for_visit_data_entry', $next_url_to_flash_for_visit_data_entry);