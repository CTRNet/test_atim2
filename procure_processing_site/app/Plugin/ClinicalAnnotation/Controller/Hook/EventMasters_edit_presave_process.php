<?php 
	
	if($event_master_data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		if(empty($this->request->data['EventMaster']['event_date']['year'])) {
			$this->EventMaster->validationErrors['event_date'][] = 'the visite date has to be completed';
			$submitted_data_validates = false;
		}
	}
	
	$this->Participant->setParticipantIdentifierForFormValidation($participant_id);