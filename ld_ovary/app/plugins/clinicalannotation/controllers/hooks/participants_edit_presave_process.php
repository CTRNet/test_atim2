<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates) {
		$this->data['Participant']['participant_identifier'] = strtoupper(substr($this->data['Participant']['first_name'], 0, 1).substr($this->data['Participant']['last_name'], 0, 1)).' ('.$participant_id.')';
	}
	
?>