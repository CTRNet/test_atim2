<?php 
	
	if($event_control_data['EventControl']['event_type'] == 'procure pathology report') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -PST1');
	} else if($event_control_data['EventControl']['event_type'] == 'procure diagnostic information worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -FBP1');
	} else if($event_control_data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -FSP1');
	} else if($event_control_data['EventControl']['event_type'] == 'procure questionnaire administration worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -QUE1');
	} else if(in_array($event_control_data['EventControl']['event_type'], array( 'procure follow-up worksheet - clinical event','procure follow-up worksheet - aps'))) {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' Vx -FSPx');
	}
	$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
	