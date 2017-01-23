<?php 
	
  	$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
	
	//Set default data 
	$override_data = array();
	switch($event_control_data['EventControl']['event_type']) {
		case 'laboratory':
			$override_data['EventDetail.biochemical_relapse'] = 'n';
			break;
		case 'visit/contact':
			$override_data['EventDetail.refusing_treatments'] = 'n';
			break;
	}
	$this->set('override_data', $override_data);
	
	//Set data for validation
	$this->EventMaster->setEventTypeForDataEntryValidation($event_control_data['EventControl']['event_type']);
	
	// Clinical file update process
	if (empty($this->request->data)) $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $this->passedArgs);
	$this->Participant->addClinicalFileUpdateProcessInfo();
	