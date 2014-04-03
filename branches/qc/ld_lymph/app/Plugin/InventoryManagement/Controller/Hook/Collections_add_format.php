<?php
 	
 	// --------------------------------------------------------------------------------
	// Set default value
	// -------------------------------------------------------------------------------- 
	
	if(!$need_to_save && !isset($this->request->data['Collection']['bank_id'])) {
		$this->request->data['Collection']['bank_id'] = 1;
	}
	
