<?php 
	
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procure follow-up worksheet - treatment') {
		$EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
		$this->set('followup_identification_list', $EventMaster->getFollowupIdentificationFromId($participant_id));
	} else if($tx_control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -MED1');
	}
	
