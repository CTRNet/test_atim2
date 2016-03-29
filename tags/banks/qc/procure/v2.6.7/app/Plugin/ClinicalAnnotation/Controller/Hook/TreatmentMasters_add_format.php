<?php 
	
	$default_procure_form_identification = '';
	switch($tx_control_data['TreatmentControl']['tx_method']) {
		case'procure medication worksheet - drug':
			$default_procure_form_identification =  $participant_data['Participant']['participant_identifier'].' Vx -MEDx';
			break;
		case'procure follow-up worksheet - treatment':
		case 'procure follow-up worksheet - other tumor tx': 
			$default_procure_form_identification =  $participant_data['Participant']['participant_identifier'].' Vx -FSPx';
			break;
		case 'procure medication worksheet':
			$default_procure_form_identification =  $participant_data['Participant']['participant_identifier'].' V0 -MED1';
			break;
	}
	$this->set('default_procure_form_identification', $default_procure_form_identification);
	
	//Following line cannot be done in presave_process hook for multi-lines record because validate function is call first
	if (!empty($this->request->data)) $this->Participant->setParticipantIdentifierForFormValidation($participant_id);