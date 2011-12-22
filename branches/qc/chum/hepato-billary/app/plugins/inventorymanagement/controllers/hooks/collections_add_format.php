<?php

 	// --------------------------------------------------------------------------------
	// Set default value
	// -------------------------------------------------------------------------------- 
	
	if(!$need_to_save && !isset($this->data['Collection']['bank_id'])) {
		$this->data['Collection']['bank_id'] = 1;
		$this->data['Collection']['acquisition_label'] = (empty($ccl_data)? '??' : $ccl_data['Participant']['participant_identifier']);
		$this->data['Collection']['collection_site'] = "saint-luc hospital";
	}

?>