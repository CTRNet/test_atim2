<?php 
	
	if($event_control_data['EventControl']['event_type'] == 'procure pathology report') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -PST1');
	} else if($event_control_data['EventControl']['event_type'] == 'procure diagnostic information worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -FBP1');
	}
		
		
		
		
	
