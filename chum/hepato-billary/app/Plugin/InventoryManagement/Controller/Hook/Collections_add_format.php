<?php

 	// --------------------------------------------------------------------------------
	// Set default value
	// -------------------------------------------------------------------------------- 
	
	if(!$need_to_save && !isset($this->request->data['Collection']['bank_id'])) {
		$this->request->data['Collection']['bank_id'] = 1;
		$this->request->data['Collection']['acquisition_label'] = (empty($collection_data)? '??' : $collection_data['Participant']['participant_identifier']);
		$this->request->data['Collection']['collection_site'] = "saint-luc hospital";
	}

?>