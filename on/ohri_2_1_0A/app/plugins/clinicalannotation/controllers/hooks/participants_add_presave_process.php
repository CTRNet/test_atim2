<?php
 	
 	// --------------------------------------------------------------------------------
	// Manage Participant creation to generate participant identifier
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates) {
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check participants_controller.php upgrade has no impact on the hook line code!');				
		$submitted_data_validates = false;
		
		if ( $this->Participant->save($this->data) ) {
			$participant_id = $this->Participant->getLastInsertId();
			
			$participant_data_to_update = array();
			$participant_data_to_update['Participant']['participant_identifier'] = 'Ap-' . $participant_id;
			
			$this->Participant->id = $participant_id;					
			if(!$this->Participant->save($participant_data_to_update, false)) { $this->redirect('/pages/err_clin_system_error', null, true); }
					
			$this->atimFlash('your data has been saved', '/clinicalannotation/participants/profile/'.$participant_id);
		}
	}
	
?>
