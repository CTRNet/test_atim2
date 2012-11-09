<?php 

	$new_participant_data = $this->Participant->getOrRedirect($participant_id);
	if($participant_data['Participant']['date_of_death'] != $new_participant_data['Participant']['date_of_death']
	|| $participant_data['Participant']['date_of_death_accuracy'] != $new_participant_data['Participant']['date_of_death_accuracy']
	|| $participant_data['Participant']['qc_tf_last_contact'] != $new_participant_data['Participant']['qc_tf_last_contact']
	|| $participant_data['Participant']['qc_tf_last_contact_accuracy'] != $new_participant_data['Participant']['qc_tf_last_contact_accuracy']) {
		$conditions = array(
				'DiagnosisMaster.participant_id' => $participant_id,
				'DiagnosisMaster.deleted != 1',
				'DiagnosisControl.category' => 'primary',
				'DiagnosisControl.controls_type' => 'prostate');
		$all_prostat_primaries = $this->DiagnosisMaster->find('all', array('conditions'=>$conditions));	
		foreach($all_prostat_primaries as $new_primary) $this->DiagnosisMaster->calculateSurvivalAndBcr($new_primary['DiagnosisMaster']['id']);
	}
	
	if($participant_data['Participant']['date_of_birth'] != $new_participant_data['Participant']['date_of_birth']
	|| $participant_data['Participant']['date_of_birth_accuracy'] != $new_participant_data['Participant']['date_of_birth_accuracy']) {
		$this->DiagnosisMaster->updateAgeAtDx('Participant',$participant_id);
	}
	