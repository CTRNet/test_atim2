<?php 
	
	$default_procure_form_identification = '';
	switch($event_control_data['EventControl']['event_type']) {
		case 'procure pathology report':
			$default_procure_form_identification = $participant_data['Participant']['participant_identifier'].' V0 -PST1';
			break;
		case 'procure diagnostic information worksheet':
			$default_procure_form_identification = $participant_data['Participant']['participant_identifier'].' V0 -FBP1';
			break;
		case 'procure follow-up worksheet':
			$default_procure_form_identification = $participant_data['Participant']['participant_identifier'].' V0 -FSP1';
			break;
		case 'procure questionnaire administration worksheet':
			$default_procure_form_identification = $participant_data['Participant']['participant_identifier'].' V0 -QUE1';
			break;
		case 'procure follow-up worksheet - clinical event':
		case 'procure follow-up worksheet - aps':
		case 'procure follow-up worksheet - other tumor dx':
		case 'procure follow-up worksheet - clinical note':
			$default_procure_form_identification = $participant_data['Participant']['participant_identifier'].' Vx -FSPx';
			break;
	}
	$this->set('default_procure_form_identification', $default_procure_form_identification);
	$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
	