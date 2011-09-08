<?php
	
	// --------------------------------------------------------------------------------
	// Set default value
	// -------------------------------------------------------------------------------- 
	if(isset($default_language)) {
		$final_options['override']['Participant.language_preferred'] = $default_language;
	}	
	if(isset($default_sex)) {
		$final_options['override']['Participant.sex'] = $default_sex;
	}
	
?>
