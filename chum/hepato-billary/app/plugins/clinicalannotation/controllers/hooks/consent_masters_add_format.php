<?php

//NL Revised

	// --------------------------------------------------------------------------------
	//   Add default consent status
	// --------------------------------------------------------------------------------
	if(empty($this->data)) {
		$this->set('default_consent_status', 'obtained');		
	}
	
?>