<?php 
	
	if($event_control_data['EventControl']['event_type'] == 'procure pathology report') {
		$this->set('default_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -PST1');
	}
	
