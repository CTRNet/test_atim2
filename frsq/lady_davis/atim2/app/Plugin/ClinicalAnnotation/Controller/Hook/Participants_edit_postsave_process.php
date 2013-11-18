<?php 

	$new_participant_data = $this->Participant->getOrRedirect($participant_id);
	if($participant_data['Participant']['date_of_birth'] != $new_participant_data['Participant']['date_of_birth']
	|| $participant_data['Participant']['date_of_birth_accuracy'] != $new_participant_data['Participant']['date_of_birth_accuracy']) {
		$this->DiagnosisMaster->updateAgeAtDx('Participant',$participant_id);
	}
	