<?php 

	if($participant['Participant']['procure_patient_withdrawn']){
		$add_to_tmp_array(array(
			'date'			=> $participant['Participant']['procure_patient_withdrawn_date'],
			'date_accuracy'	=> $participant['Participant']['procure_patient_withdrawn_date_accuracy'],
			'event'			=> __('patient withdrawn'),
			'chronology_details' => '',
			'link'			=> '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/'
		));
	}
