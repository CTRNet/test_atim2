<?php 
	
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		$this->set('default_procure_form_identification', $participant_data['Participant']['participant_identifier'].' V0 -MED1');
	}
	
