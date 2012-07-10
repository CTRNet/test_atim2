<?php 

	if($tx_control_data['TreatmentControl']['tx_method'] == 'medication worksheet') {
		$this->set('default_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -MED1');
	}
	
