<?php 

	$chronolgy_data_participant_birth = null;
	
	if($chronolgy_data_participant_death) $chronolgy_data_participant_death['chronology_details'] = $health_status_values[$participant['Participant']['vital_status']];
	if($participant['Participant']['qbcf_suspected_date_of_death']) {
		$add_to_tmp_array(array(
			'date'			=> $participant['Participant']['qbcf_suspected_date_of_death'],
			'date_accuracy'	=> $participant['Participant']['qbcf_suspected_date_of_death_accuracy'],
			'event' 		=> __('supected date of death'),
			'chronology_details' => $health_status_values[$participant['Participant']['vital_status']],
			'link'			=> '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/'
		));
	}
	if($participant['Participant']['qbcf_last_contact']) {
		$add_to_tmp_array(array(
			'date'			=> $participant['Participant']['qbcf_last_contact'],
			'date_accuracy'	=> $participant['Participant']['qbcf_last_contact_accuracy'],
			'event' 		=> __('last contact'),
			'chronology_details' => '',
			'link'			=> '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/'
		));
	}
	