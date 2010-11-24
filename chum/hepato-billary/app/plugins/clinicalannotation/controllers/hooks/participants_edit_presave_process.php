<?php
	
	// --------------------------------------------------------------------------------
	// Update surgery treatment survival time
	// --------------------------------------------------------------------------------
	$new_last_news_date = $this->data['Participant']['last_news_date']['year'].'-'.$this->data['Participant']['last_news_date']['month'].'-'.$this->data['Participant']['last_news_date']['day'];
	if($participant_data['Participant']['last_news_date'] != $new_last_news_date) {
		// Update surgery survival time
		pr('WARNING: Save process done into the hook! Check participants_controller.php upgrade has no impact on the hook line code!');				
		$submitted_data_validates = false;

		App::import('Controller', 'Clinicalannotation.TreatmentMasters');
		$TreatmentMaster = new TreatmentMastersControllerCustom();	
		
		$TreatmentMaster->updateParticipantSurvivalTime($participant_id, $this->data['Participant']['last_news_date'] );
		
		// Launch participant save process
		$this->Participant->id = $participant_id;
		if ( $this->Participant->save($this->data) ) $this->flash( 'your data has been updated','/clinicalannotation/participants/profile/'.$participant_id );		
	}
	
?>