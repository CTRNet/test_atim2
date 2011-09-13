<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->data['Participant']['qc_ldov_initals'] = strtoupper($this->data['Participant']['qc_ldov_initals']);
	if($submitted_data_validates) {
		$this->data['Participant']['participant_identifier'] = $this->data['Participant']['qc_ldov_initals'].' ('.$participant_id.')';
	}
	
?>