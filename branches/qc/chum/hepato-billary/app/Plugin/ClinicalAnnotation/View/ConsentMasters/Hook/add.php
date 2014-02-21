<?php

	// --------------------------------------------------------------------------------
	//   Add default consent status
	// --------------------------------------------------------------------------------
	if(isset($default_consent_status)) {
		$final_options['override' ]['ConsentMaster.consent_status'] = $default_consent_status;
	}
	
?>
