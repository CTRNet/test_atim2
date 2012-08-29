<?php 
	
	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procure follow-up worksheet - treatment') {
		$EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
		$this->set('followup_identification_list', $EventMaster->getFollowupIdentificationFromId($participant_id));
	}
	
